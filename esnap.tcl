# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {
    variable snapdebug 0  ; # debug message
}
foreach class {
    ticklecharts::chart
    ticklecharts::Gridlayout
    ticklecharts::timeline
} {
    oo::define $class {

        method SnapShot {args} {
            # Export Chart to png|svg|base64.
            #
            # args - Options described below.
            # 
            # -address           - Local adress.
            # -port              - Port number.
            # -exe               - Full path executable.
            # -html              - Html fragment.
            # -jschartvar        - Variable name chart.
            # -renderer          - base64, png or svg.
            # -outfile           - Full path file.
            # -excludecomponents - Excluded components.
            # -timeout           - Time to execute JS function.
            #
            # Returns full path if 'png|svg' renderer,
            # data if 'base64' renderer or '-1' if there is an error.
            try {

                my variable browser
                my variable forever
                my variable isrendered
                my variable renderer
                my variable outfile
                my variable imginfo
                my variable js
                my variable connection
                my variable timeout
                my variable jschartvar

                package require huddle::json
                package require websocket

                if {[llength $args] % 2} {
                    error "wrong # args: should be \"[self] [self method]\
                          ?-port port? ...\""
                }

                set imginfo -1
                set connection 0
                # Gets arguments options
                set opts [ticklecharts::renderOptions $args [self method]]

                foreach {key info} $opts {
                    set k  [string map {- ""} $key]
                    set $k [lindex $info 0]
                }

                if {$html eq ""} {
                    if {$renderer eq "svg"} {
                        set htmlopts [ticklecharts::renderOptions {
                            -renderer svg
                        } "toHTML"]
                    } else {
                        set htmlopts [ticklecharts::renderOptions {} "toHTML"]
                    }
                    set jschartvar [lindex [dict get $htmlopts -jschartvar] 0]
                    set html       [my toHTML {*}$htmlopts]
                } else {
                    if {$jschartvar eq ""} {
                        error "'-jschartvar' property should be defined\
                                if '-html' is provided."
                    }
                }

                if {$renderer in {png svg}} {
                    if {
                        ($outfile ne "") && 
                        ([file extension $outfile] ne ".$renderer")
                    } {
                        error "wrong # args: file extension for '-outfile'\
                            property should be '.png'"
                    }
                }

                # Try to find out if 'gridlayout' or 'timeline'
                # class contains 'chart3D' chart type.
                if {[my getType] in {gridlayout timeline}} {
                    foreach c [my charts] {
                        if {[$c getType] eq "chart3D"} {
                            error "'[my getType]' class should not\
                                    contain 'chart3D'."
                        }
                    }
                }

                # Add global options to main options.
                if {[my getType] eq "chart"} {
                    set myopts [list {*}[my globalOptions] {*}[my options]]
                    set optsg  [[ticklecharts::globalOptions {}] get]
                    set optsg  [ticklecharts::optsToEchartsHuddle $optsg]
                } else {
                    set myopts [my options]
                    set optsg {}
                }

                switch -exact -- [my getType] {
                    timeline {set options [list {*}$myopts]}
                    default  {set options [list $myopts $optsg]}
                }
                    
                # Finds out whether the animation property is active or not.
                foreach opts $options {
                    if {[dict exists $opts @B=animation]} {
                        if {[dict get $opts @B=animation]} {
                            error "'-animation' in global options property\
                                    should be disabled."
                        }
                        break
                    }
                }

                # Exclude components or not.
                set exc {}
                if {$excludecomponents ne "nothing"} {
                    set len [llength {*}$excludecomponents]
                    set frt [format [string repeat "'%s', " $len] \
                        {*}[join $excludecomponents] \
                    ]
                    set exc $frt
                }

                # JS function.
                if {$renderer in {png base64}} {
                    set js [subst -nocommands {
                        var img_${jschartvar} = new Image();
                        img_${jschartvar}.src = ${jschartvar}.getDataURL({
                            pixelRatio: 1,
                            excludeComponents : [$exc]
                        });
                    }]
                } else {
                    set js [subst {
                        var svg_${jschartvar};
                        svg_${jschartvar} = ${jschartvar}.renderToSVGString();
                    }]
                }
                
                # A temporary file is created when the command is executed.
                # This may change in future versions of 'ticklEcharts'
                set htmltmpfile [ticklecharts::htmlTmpFile $html]

                set isrendered 0

                my StartBrowser $exe $port $address $htmltmpfile
                vwait [namespace current]::browser

                if {$browser != 2} {
                    set url "http://${address}:${port}/json"
                    my ConnectLocalHost $url
                    vwait [namespace current]::forever
                }

                return $imginfo

            } on error {result options} {
                error "error(snap): [dict get $options -errorinfo]"
            } finally {
                # Delete temporary file.
                catch {file delete -force $htmltmpfile}
            }
        }

        method StartBrowser {exe port address tmpfile} {
            # Start Browser
            #
            # exe      - full path executable.
            # port     - port number.
            # adress   - adress local host.
            # tempfile - full path html temporary file.
            #
            set cmd [list $exe \
                        --remote-debugging-port=$port \
                        --remote-debugging-address=$address \
                        --headless file:///${tmpfile}]

            set f [open "|$cmd 2>@1" r]
            fileevent  $f readable [callback Handle $f]
        }

        method Handle {f} {
            # Capture sdterr, stdout '-exe' file.
            #
            # f - open file
            #
            my variable browser

            set status [catch {gets $f line} result]
            if {$status != 0} {
                catch {close $f}
            } elseif {$result >= 0} {
                if {[string match {*ERROR:*} $line]} {
                    puts stderr "error(snap): $line"
                    catch {close $f}
                    set browser 2
                } else {
                    set browser 1
                }
            } elseif {[eof $f]} {
                catch {close $f}
            } elseif {[fblocked $f]} {
                # do nothing
            }
        }

        method ConnectLocalHost {url} {
            # Connection to local host.
            #
            # url     - string url
            #
            set response [http::geturl $url]
            set data [http::data $response]
            http::cleanup $response

            set pages [ticklecharts::messageToDict $data]
            set page [lindex $pages 0]
            set wsDebuggerUrl [dict get $page webSocketDebuggerUrl]

            set websocketUrl $wsDebuggerUrl
            set ws [websocket::open $websocketUrl [callback Handler]]
            
            after 300 [callback Runtime $ws]

        }

        method BrowserRender {msg sock} {
            # Save image.
            #
            # msg  - message from websocket
            # sock - websocket
            #
            my variable isrendered
            my variable renderer
            my variable outfile
            my variable imginfo

            try {
                set d [ticklecharts::messageToDict $msg]
                set data [dict get $d result result value]
                set data [string map {data:image/png;base64, ""} $data]
                set isrendered 1
                set mode wb+
                if {$renderer eq "base64"} {
                    set imginfo $data
                } else {
                    switch -exact -- $renderer {
                        png {set dataImg [binary decode base64 $data]}
                        svg {set dataImg $data ; set mode w+}
                    }
                    set fp [open $outfile $mode]
                    puts $fp $dataImg
                    if {$::ticklecharts::htmlstdout} {
                        puts stdout [format "${renderer}:%s" \
                            [file nativename $outfile] \
                        ]
                    }
                    set imginfo $outfile
                }
            } on error {result options} {
                set imginfo -1
                error "error(snap): [dict get $options -errorinfo]"
            } finally {
                catch {close $fp}
                my CloseBrowser $sock
            }
            
        }

        method Handler {sock type msg} {
            # Capture messages from websocket.
            #
            # sock    - websocket
            # type    - type message websocket
            # msg     - message websocket
            # timeout - time to execute JS function (milliseconds)
            #
            my variable forever
            my variable isrendered
            my variable browser
            my variable imginfo
            my variable connection
            my variable jschartvar

            if {$browser == 2} {return}

            switch -exact -- $type {
                text {
                    if {
                        [string match {*data:image/png;base64*} $msg] ||
                        [string match {*<svg *} $msg]
                    } {
                        my BrowserRender $msg $sock
                    } elseif {[string match {*TypeError*} $msg]} {
                        puts stderr "error(snap): '$msg'"
                        set imginfo -1
                        my CloseBrowser $sock
                    } elseif {[string match {*target_closed*} $msg]} {
                        ::websocket::close $sock
                        set forever 1
                    } elseif {
                        [string match {*"result":{}*} $msg] && 
                        !$isrendered && ($connection == 2)
                    } {
                        puts stderr "warning(snap): 'jsondata' is not available, try\
                                     to increase `-timeout` property in the 'SnapShot'\
                                     method argument options."
                        set imginfo -1
                        my CloseBrowser $sock
                    } elseif {
                        [string match {*ReferenceError*} $msg] &&
                        !$isrendered
                    } {
                        set d [ticklecharts::messageToDict $msg]
                        if {[dict exists $d result result description]} {
                            set info [dict get $d result result description]
                        } else {
                            set info $msg
                        }
                        # Try running the command again
                        if {
                            ($connection <= 2) &&
                            [string match "*$jschartvar is not defined*" $info]
                        } {
                            my Runtime $sock
                            incr connection
                        } else {
                            puts stderr "error(snap): $info"
                            set imginfo -1
                            my CloseBrowser $sock
                        }
                    } else {
                        if {$::ticklecharts::snapdebug} {
                            puts stdout $msg
                        }
                    }
                }
            }
        }

        method Runtime {sock} {
            # Execute Js function.
            #
            # sock    - websocket
            #
            # Return nothing
            my variable forever
            my variable js
            my variable timeout

            set conninfo [websocket::conninfo $sock state]
            if {$conninfo ne "CONNECTED"} {
                websocket::close $sock
                my CloseBrowser $sock
                puts stderr "warning(snap): [websocket::conninfo $sock state]"
                set forever 1
            } else {
                after $timeout
                set jsonData [subst {
                    { 
                        "id": 1,
                        "method": "Runtime.evaluate",
                        "params": {
                            "expression": "$js"
                        }
                    }
                }]
                websocket::send $sock text $jsonData
            }

            return {}
        }

        method CloseBrowser {sock} {
            # Try to close the browser properly.
            #
            # sock - websocket
            #
            # Return nothing
            set jsonData {{"id": 1,  "method": "Browser.close"}}
            websocket::send $sock text $jsonData

            return {}
        }

        # export new method.
        export SnapShot
    }
}

proc ticklecharts::htmlTmpFile {html} {
    # Create a temporary file.
    #
    # html  - html string
    #
    # Returns full path.
    foreach tmp {TMP TEMP TMPDIR} {
        if {[info exists ::env($tmp)]} {
            set tmpdir $::env($tmp)
        }
    }

    set htmltmpfile [file join $tmpdir [clock click].html]
    set fp [open $htmltmpfile w+]
    puts $fp $html
    close $fp

    return $htmltmpfile
}

proc ticklecharts::messageToDict {msg} {
    # Trnasform Json to dict.
    #
    # msg  - json data
    #
    # Returns dict.
    set h [huddle::json2huddle $msg]

    return [huddle get_stripped $h]
}
