# Copyright (c) 2022-2023 Nicolas ROBERT.
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
        }
        # All requirements must be fulfilled,
        # in order to function properly.
        set tsbIsReady [expr {
                ([info exists ::tsb::ready] && $::tsb::ready) &&
                [info exists ::ID] && [info exists ::W]
                }
            ]

        # To gain speed.
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
                # Find folder according to variable version.
                # The folder should be named like this : @X.X.X/***.js
                # If the folder is not found, by default we take the variable ticklecharts::e**script
                set v [set $e_version]
                if {[file exists $eJsdir]} {
                    if {[set edir_js [glob -nocomplain -directory $eJsdir -types d *$v]] ne "" && 
                        [set ejs [glob -nocomplain -directory $edir_js -types f echarts*.js]] ne ""} {
                        set f  [open $ejs r] ; # read *.js file
                        set js [read $f] ; close $f
                        # set variable with full js script.
                        set $script $js
                        dict incr etsb::path $script
                    }
                }
            }
        } on error {message} {
            puts $message
        }
    }
}