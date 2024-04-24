# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
# From https://wiki.tcl-lang.org/page/Taygete+Scrap+Book :
# This is an experimental, partial, compact rebuild of some ideas of Jupyter Notebook.
# The name is derived from Taygete (Ταϋγέτη) which is a small retrograde irregular satellite of Jupiter,
# aka Jupiter XX.
# It consists of a webview (the rendering component/library of a web browser) with an added Tcl interface,
# plus some Tcl and JavaScript to provide a user interface resembling Jupyter Notebook.
# The webview part is basically taken from the Tiny cross-platform webview library for C/C++/Golang
# with the Python interface taken as starting point for the Tcl interface.
# No browser and webserver are required so it can be made into one binary with zero installation and without 
# requiring network infrastructure. Uncloudy, so to speak clean hot air.
# 
if {[namespace exists ::tsb]} {

    namespace eval ticklecharts {
        namespace eval etsb {
            # Generate uuid for <div> tsb...
            variable uuid [ticklecharts::uuid]
            variable path [dict create]

            proc readJsFile {file} {
                # file - js file
                #
                # Returns data js file
                try {
                    set fp [open $file r]
                    set js [read $fp]
                } on error {result options} {
                    error [dict get $options -errorinfo]
                } finally {
                    catch {close $fp}
                }

                return $js
            }
        }
        # All requirements must be fulfilled,
        # in order to function properly.
        set isReady [expr {
                ([info exists ::tsb::ready] && $::tsb::ready) &&
                [info exists ::ID] && [info exists ::W]
            }
        ]

        if {!$isReady} {error "'Tsb' file not sourced..."}

        # To gain speed
        set minProperties "True"

        try {
            package require ticklecharts::etsb
            # Searches for *.js files in the tsb.tcl file directory.
            set eJsdir    $etsb::dir ; # variable from pkgIndex.tcl
            set tracecmds [info commands ::ticklecharts::trace*]

            foreach {e_version script} {
                echarts_version escript
                gl_version      eGLscript
                wc_version      wcscript
                } {
                # Find folder according to variable version.
                # The folder should be named like this : @X.X.X/***.js
                # If the folder is not found, by default we take the variable ticklecharts::e**script
                set v [set $e_version]
                if {[file exists $eJsdir]} {
                    if {[set edir_js [glob -nocomplain -directory $eJsdir -types d *$v]] ne "" && 
                        [set ejs [glob -nocomplain -directory $edir_js -types f echarts*.js]] ne ""} {
                        set js [etsb::readJsFile $ejs] ; # read *.js file
                        # set variable with full js script.
                        set $script $js
                        dict incr etsb::path $script
                    } else {
                        # No version found on the folder name according to ticklecharts version.
                        # Try to find out if there are folders with lower or higher versions.
                        switch -exact -- $script {
                            "escript"   {set name "echarts@"}
                            "eGLscript" {set name "gl@"}
                            "wcscript"  {set name "wordcloud@"}
                        }
                        set lversion {}
                        foreach p [glob -nocomplain -directory $eJsdir -types d *$name*] {
                            if {[regexp {([0-9]+\.[0-9]+\.[0-9]+)} [file tail $p] -> match]} {
                                lappend lversion [list $match $p]
                            }
                        }
                        if {[llength $lversion]} {
                            # Take the highest version.
                            set last [lindex [lsort -dictionary -index 0 $lversion] end]
                            lassign $last lastversion lastpath
                            if {[set ejs [glob -nocomplain -directory $lastpath -types f echarts*.js]] ne ""} {
                                set js [etsb::readJsFile $ejs] ; # read *.js file
                                # Changes 'e_version' with the new version.
                                set ::ticklecharts::$e_version $lastversion
                                # set variable with full js script.
                                set $script $js
                                dict incr etsb::path $script
                            } 
                        }
                    }
                }
                # Replaces trace command, not supported...
                # By another trace tsb command
                foreach cmd $tracecmds {
                    set mapv [string map {_ ""} $e_version]
                    if {[string match -nocase *$mapv $cmd]} {

                        set vinfo [lindex [trace vinfo ticklecharts::$e_version] 0 1]
                        trace remove variable ticklecharts::$e_version write [list {*}$vinfo]
                        
                        proc ${cmd}_tsb {args} [subst {
                            # set variable to initial version...
                            set ::ticklecharts::$e_version [set ::ticklecharts::$e_version]
                            puts stderr "Variable '::ticklecharts::$e_version' can not be changed...\
                                        Not supported with 'Taygete Scrap Book'"
                        }]

                        trace add variable ticklecharts::$e_version write [list ${cmd}_tsb]
                        break
                    }
                }
            }
        } on error {message} {
            puts stderr $message
        }
    }

    # Define a new method 'RenderTsb' for
    # all ticklecharts classes.
    foreach class {
        ticklecharts::chart ticklecharts::chart3D 
        ticklecharts::Gridlayout ticklecharts::timeline
        } {
        oo::define $class {
            method RenderTsb {args} {
                # Export chart to Taygete Scrap Book.
                # https://www.androwish.org/home/dir?name=undroid/tsb
                #
                # Be careful the tsb.tcl file should be sourced...
                #
                # args - Options described below.
                #
                # -renderer - 'canvas' or 'svg'
                # -height   - size html canvas
                # -merge    - If false, all of the current components
                #             will be removed and new components will
                #             be created according to the new option.
                #             (false by default)
                # -evalJSON - Two possibilities 'JSON.parse' or 'eval' 
                #             to insert an JSON obj in Tsb Webview.
                #             'eval' JSON obj is not recommended (security reasons).
                #             JSON.parse is safe but 'function', 'js variable'
                #             in JSON obj are not supported.
                #             (false by default)
                #
                # Returns nothing.

                if {[llength $args] % 2} {
                    error "wrong # args: should be \"[self] [self method]\
                          ?-renderer renderer? ...\""
                }

                set json [my toJSON] ; # jsondump

                set opts [ticklecharts::renderOptions $args [self method]]
                set height   [lindex [dict get $opts -height] 0]
                set renderer [lindex [dict get $opts -renderer] 0]
                set merge    [lindex [dict get $opts -merge] 0]
                set evalJSON [lindex [dict get $opts -evalJSON] 0]

                # SVG renderer is not supported with Echarts GL.
                if {$renderer eq "svg"} {
                    if {[my getType] eq "chart3D" || "globe" in [[my get] keys] ||
                        [regexp {3D|surface|GL} [[my get] getTypeSeries]]} {
                        error "wrong # args: 'svg' renderer is not supported\
                               with echarts-gl."
                    }
                }

                # Add global options to main options.
                if {[my getType] in {chart chart3D}} {
                    set myopts [list {*}[my globalOptions] {*}[my options]]
                } else {
                    set myopts [my options]
                }
                
                if {!$evalJSON} {
                    if {[my getType] eq "timeline"} {
                        set timelineopts [list {*}[my baseOption] {*}$myopts]
                        ticklecharts::checkJsFunc $timelineopts [self method]
                    } else {
                        ticklecharts::checkJsFunc $myopts [self method]
                    }
                }

                set uuid $::ticklecharts::etsb::uuid
                # load if necessary 'echarts' js script...
                #
                set type ""
                foreach script {escript eGLscript wcscript} {
                    set ejs [set ::ticklecharts::$script]
                    if {[dict exists $::ticklecharts::etsb::path $script]} {
                        set type "text"
                    } else {
                        if {[ticklecharts::isURL? $ejs]} {
                            set type "source"
                        } else {
                            # If I understand, it is not possible to insert 
                            # a local file directly with the 'src' attribute in Webview.
                            #
                            set ejs [ticklecharts::etsb::readJsFile $ejs] ; # read *.js file
                            # write full js script... inside tsb
                            set ::ticklecharts::$script $ejs
                            set type "text"
                            dict incr ::ticklecharts::etsb::path $script
                        }
                    }
                    $::W call eSrc $ejs [format {%s_%s} $script $uuid] $type
                }
                set idEDiv [format {id_%s%s} $uuid $::ID]
                # set div + echarts height
                #
                $::W call eDiv $idEDiv $height
                # 
                after 100 [list $::W call eSeries \
                                        $idEDiv $json \
                                        $renderer $merge \
                                        $evalJSON]

                set ::ticklecharts::theme "custom"

                return {}
            }

            # export new method
            export RenderTsb
            # unexport method(s)
            unexport toJSON Render toHTML
        }
    }
}