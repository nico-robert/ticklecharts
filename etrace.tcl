# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {
    variable etrace [dict create]
}

# When version is modified adds trace command.
#
# The last argument of the command is the minimum version
trace add variable ticklecharts::echarts_version write [list ticklecharts::traceEchartsVersion   "5.0.0" $::ticklecharts::echarts_version]
trace add variable ticklecharts::gl_version      write [list ticklecharts::traceEchartsGLVersion "2.0.0" $::ticklecharts::gl_version] 
trace add variable ticklecharts::gmap_version    write [list ticklecharts::traceGmapVersion      "1.5.0" $::ticklecharts::gmap_version]
trace add variable ticklecharts::wc_version      write [list ticklecharts::traceWCVersion        "2.0.0" $::ticklecharts::wc_version]
trace add variable ticklecharts::keyGMAPI        write [list ticklecharts::traceKeyGMAPI]

trace add execution ticklecharts::xAxis      leave ticklecharts::track
trace add execution ticklecharts::yAxis      leave ticklecharts::track
trace add execution ticklecharts::lineSeries leave ticklecharts::track
trace add execution ticklecharts::label      leave ticklecharts::track
trace add execution ticklecharts::endLabel   leave ticklecharts::track
trace add execution ticklecharts::lineStyle  leave ticklecharts::track
trace add execution ticklecharts::itemStyle  leave ticklecharts::track
trace add execution ticklecharts::textStyle  leave ticklecharts::track

proc ticklecharts::traceEchartsVersion {minversion baseversion args} {
    # Changes the script Echarts version variable.
    #
    # minversion   - minimum version
    # args         - not used...
    #
    # Returns nothing.
    variable escript ; variable echarts_version

    # Minimum Echarts version...
    if {[ticklecharts::vCompare $minversion $echarts_version] == 1} {
        error "The minimum Echarts version for 'ticklEcharts' package\
               is the version '$minversion', currently the modified version\
               is '$echarts_version'"
    }

    if {[regexp {@([0-9.]+)} $escript -> match]} {
        set vMap [list $match $echarts_version]
        set escript [string map $vMap $escript]
    } else {
        puts "warning: Num version (@X.X.X) should be present in 'Echarts' path js.\
              If no pattern matches, the script path is left unchanged\
              and the 'echarts_version' variable is set to base version"
        set echarts_version $baseversion
    }

    # Verify if a URL exists.
    # Output warning message if url doesn't exists
    if {$::ticklecharts::checkURL && [ticklecharts::isURL? $escript]} {
        ticklecharts::urlExists? $escript
    }

    return {}
}

proc ticklecharts::traceEchartsGLVersion {minversion baseversion args} {
    # Changes the script Echarts GL version variable.
    #
    # minversion   - minimum version
    # args         - not used...
    #
    # Returns nothing.
    variable eGLscript ; variable gl_version

    # Minimum GL Echarts version...
    if {[ticklecharts::vCompare $minversion $gl_version] == 1} {
        error "The minimum Echarts GL version for 'ticklEcharts' package\
               is the version '$minversion', currently the modified version\
               is '$gl_version'"
    }

    if {[regexp {@([0-9.]+)} $eGLscript -> match]} {
        set vMap [list $match $gl_version]
        set eGLscript [string map $vMap $eGLscript]
    } else {
        puts "warning: Num version (@X.X.X) should be present in 'EchartsGL' path js.\
              If no pattern matches, the script path is left unchanged\
              and the 'gl_version' variable is set to base version"
        set gl_version $baseversion
    }

    # Verify if a URL exists.
    # Output warning message if url doesn't exists
    if {$::ticklecharts::checkURL && [ticklecharts::isURL? $eGLscript]} {
        ticklecharts::urlExists? $eGLscript
    }

    return {}
}

proc ticklecharts::traceGmapVersion {minversion baseversion args} {
    # Changes the script Gmap version variable.
    #
    # minversion   - minimum version
    # args         - not used...
    #
    # Returns nothing.
    variable gmscript ; variable gmap_version

    # Minimum WordCloud Echarts version...
    if {[ticklecharts::vCompare $minversion $gmap_version] == 1} {
        error "The minimum Echarts Gmap version for 'ticklEcharts' package\
               is the version '$minversion', currently the modified version\
               is '$gmap_version'"
    }

    if {[regexp {@([0-9.]+)} $gmscript -> match]} {
        set vMap [list $match $gmap_version]
        set gmscript [string map $vMap $gmscript]
    } else {
        puts "warning: Num version (@X.X.X) should be present in 'gmap' path js.\
              If no pattern matches, the script path is left unchanged\
              and the 'gmap_version' variable is set to base version"
        set gmap_version $baseversion
    }

    # Verify if a URL exists.
    # Output warning message if url doesn't exists
    if {$::ticklecharts::checkURL && [ticklecharts::isURL? $gmscript]} {
        ticklecharts::urlExists? $gmscript
    }

    return {}
}

proc ticklecharts::traceWCVersion {minversion baseversion args} {
    # Changes the script echarts-wordcloud version variable.
    #
    # minversion   - minimum version
    # args         - not used...
    #
    # Returns nothing.
    variable wcscript ; variable wc_version

    # Minimum WordCloud Echarts version...
    if {[ticklecharts::vCompare $minversion $wc_version] == 1} {
        error "The minimum Echarts wordcloud version for 'ticklEcharts' package\
               is the version '$minversion', currently the modified version\
               is '$wc_version'"
    }

    if {[regexp {@([0-9.]+)} $wcscript -> match]} {
        set WCMap [list $match $wc_version]
        set wcscript [string map $WCMap $wcscript]
    } else {
        puts "warning: Num version (@X.X.X) should be present in 'wordcloud' path js.\
              If no pattern matches, the script path is left unchanged\
              and the 'wc_version' variable is set to base version"
        set wc_version $baseversion
    }

    # Verify if a URL exists.
    # Output warning message if url doesn't exists
    if {$::ticklecharts::checkURL && [ticklecharts::isURL? $wcscript]} {
        ticklecharts::urlExists? $wcscript
    }

    return {}
}

proc ticklecharts::traceKeyGMAPI {args} {
    # Changes the API key in Google script js.
    #
    # args   - not used...
    #
    # Returns nothing.
    variable gapiscript ; variable keyGMAPI

    if {[regexp {key=([a-zA-Z0-9?_-]+)} $gapiscript -> match]} {
        set vMap [list $match $keyGMAPI]
        set gapiscript [string map $vMap $gapiscript]
    } else {
        puts "warning: 'key=' should be present in Google script path js.\
              If no pattern matches, the script path is left unchanged."
    }

    return {}
}

proc ticklecharts::track {call args} {
    # The goal here is to find if certain values
    # match each other (experimental procedure)
    # Maybe will be deleted... or reworked
    # Currently only tested for :
    # - line series
    # Output a warning message If there is no match...
    #
    # call - command
    # args - data
    #
    # Returns nothing. 
    variable etrace

    set data [lindex $args end-1]

    if {$data eq "nothing" || $data eq ""} {
        return {}
    }

    set cmds {}
    for {set i 1} {$i < [info level]} {incr i} {
        set name [lindex [info level $i] 0]
        if {[string match {ticklecharts::*} $name] ||
            [ticklecharts::isAObject $name]} {
            # Adds an index if the trace command is related to a series.
            if {[string match {ticklecharts::*Series} $name]} {
                set index [lindex [info level $i] 1]
                if {[ticklecharts::typeOf $index] ne "num"} {
                    error "'$index' should be an integer." 
                }
                set name $name\($index)
            }
            lappend cmds $name
        }
    }

    set obj [lindex $cmds 0]

    if {![ticklecharts::isAObject $obj]} {
        error "First index of list for 'track' command\
               should be an object"
    }
    
    set cmd [lindex $call 0]
    # Adds an index if the trace command is related to a series.
    if {[string match {ticklecharts::*Series} $cmd]} {
        set index [lindex $call 1]
        if {[ticklecharts::typeOf $index] ne "num"} {
            error "'$index' should be an integer." 
        }
        set cmd $cmd\($index)
    }

    lappend cmds $cmd
    set cmds [string map {ticklecharts:: ""} [join $cmds "."]]

    # 'data' variable may be a class.
    if {[ticklecharts::iseDictClass $data] || 
        [ticklecharts::iseListClass $data]} {
        set data [$data get]
    }

    # set dict trace.
    dict set etrace $cmds $data

    foreach {key info} $data {
        lassign $info value type trace
        if {[lindex $trace 0] == 1} {
            set key  [string map {"-" ""} $key]
            switch -glob -- [lindex $trace 1] {
                "lineSeries*" {
                    switch -exact -- $key {
                        "showAllSymbol" {
                            # https://echarts.apache.org/en/option.html#series-line.showAllSymbol
                            if {[dict exists $etrace $obj.xAxis]} {
                                set _d [dict get $etrace $obj.xAxis] 
                                if {($value ne "nothing") && [dict exists $_d -type]} {
                                    set v [lindex [dict get $_d -type] 0]
                                    if {$v ne "category"} {
                                        puts "warning (trace): xAxis.type should be set to 'category'\
                                            if '[lindex $trace 1].showAllSymbol' is set to '$value'"
                                    }
                                }
                            }
                        }
                        "stack" {
                            # https://echarts.apache.org/en/option.html#series-line.stack
                            if {[dict exists $etrace $obj.yAxis]} {
                                set _d [dict get $etrace $obj.yAxis] 
                                if {($value ne "nothing") && [dict exists $_d -type]} {
                                    set v [lindex [dict get $_d -type] 0]
                                    if {$v in {time category}} {
                                        puts "warning (trace): yAxis.type should be set to 'value' or 'log'\
                                            if '[lindex $trace 1].stack' is set to '$value'"
                                    }
                                }
                            }
                        }
                        "distance" {
                            # https://echarts.apache.org/en/option.html#series-line.label.distance
                            if {[dict exists $etrace $obj.[lindex $trace 1]]} {
                                set _d [dict get $etrace $obj.[lindex $trace 1]]
                                if {($value ne "nothing") && [dict exists $_d position]} {
                                    set v [lindex [dict get $_d position] 0]
                                    if {$v ne "nothing" && $v ni {top insideRight}} {
                                        puts "warning (trace): [lindex $trace 1].distance is valid only\
                                            when '[lindex $trace 1].position' is a 'string' (like 'top', 'insideRight')."
                                    }
                                }
                            }
                        }
                        "miterLimit" {
                            # Doc e.g: https://echarts.apache.org/en/option.html#series-line.labelLine.lineStyle.miterLimit
                            # Available for all series-line.***.miterLimit
                            if {[dict exists $etrace $obj.[lindex $trace 1]]} {
                                set _d [dict get $etrace $obj.[lindex $trace 1]]
                                if {($value ne "nothing") && [dict exists $_d join]} {
                                    set v [lindex [dict get $_d join] 0]
                                    if {$v ne "miter"} {
                                        puts "warning (trace): [lindex $trace 1].miterLimit is valid only\
                                            when '[lindex $trace 1].join' is set as 'miter'"
                                    }
                                }
                            }
                        }
                        "join" {
                            # Doc e.g: https://echarts.apache.org/en/option.html#series-line.labelLine.lineStyle.join
                            # Available for all series-line.***.join
                            if {[dict exists $etrace $obj.[lindex $trace 1]]} {
                                set _d [dict get $etrace $obj.[lindex $trace 1]]
                                if {($value eq "miter") && [dict exists $_d miterLimit]} {
                                    set v [lindex [dict get $_d miterLimit] 0]
                                    if {$v eq "nothing"} {
                                        puts "warning (trace): [lindex $trace 1].join is valid only\
                                            when '[lindex $trace 1].miterLimit' is set, now it set to '$v'"
                                    }
                                }
                            }
                        }
                        "borderMiterLimit" {
                            # Doc e.g: https://echarts.apache.org/en/option.html#series-line.itemStyle.borderMiterLimit
                            # Available for all series-line.***.borderMiterLimit
                            if {[dict exists $etrace $obj.[lindex $trace 1]]} {
                                set _d [dict get $etrace $obj.[lindex $trace 1]]
                                if {($value ne "nothing") && [dict exists $_d borderJoin]} {
                                    set v [lindex [dict get $_d borderJoin] 0]
                                    if {$v ne "miter"} {
                                        puts "warning (trace): [lindex $trace 1].borderMiterLimit is valid only\
                                            when '[lindex $trace 1].borderJoin' is set as 'miter'"
                                    }
                                }
                            }
                        }
                        "borderJoin" {
                            # Doc e.g: https://echarts.apache.org/en/option.html#series-line.itemStyle.borderJoin
                            # Available for all series-line.***.borderJoin
                            if {[dict exists $etrace $obj.[lindex $trace 1]]} {
                                set _d [dict get $etrace $obj.[lindex $trace 1]]
                                if {($value eq "miter") && [dict exists $_d borderMiterLimit]} {
                                    set v [lindex [dict get $_d borderMiterLimit] 0]
                                    if {$v eq "nothing"} {
                                        puts "warning (trace): [lindex $trace 1].borderJoin is valid only\
                                            when '[lindex $trace 1].borderMiterLimit' is set, now it set to '$v'"
                                    }
                                }
                            }
                        }
                        "ellipsis" {
                            # Doc e.g: https://echarts.apache.org/en/option.html#series-line.label.ellipsis
                            # Available for all series-line.***.ellipsis
                            if {[dict exists $etrace $obj.[lindex $trace 1]]} {
                                set _d [dict get $etrace $obj.[lindex $trace 1]]
                                if {($value ne "nothing") && [dict exists $_d overflow]} {
                                    set v [lindex [dict get $_d overflow] 0]
                                    if {$v ne "truncate"} {
                                        puts "warning (trace): [lindex $trace 1].ellipsis to be displayed when\
                                             '[lindex $trace 1].overflow' is set to 'truncate'."
                                    }
                                }
                            }
                        }
                    }
                }
                "xAxis" {
                    if {$key eq "type"} {
                        foreach objSeries [dict keys $etrace $obj.lineSeries(*)] {
                            set _d [dict get $etrace $objSeries]
                            if {($value ne "category") && [dict exists $_d -showAllSymbol]} {
                                set v [lindex [dict get $_d -showAllSymbol] 0]
                                if {$v ne "nothing"} {
                                    puts "warning (trace): xAxis.type should be set to 'category'\
                                        if '$objSeries.showAllSymbol' is set to '$v'"
                                }
                            }
                        }
                    }
                }
                "yAxis" {
                    if {$key eq "type"} {
                        foreach objSeries [dict keys $etrace $obj.lineSeries(*)] {
                            set _d [dict get $etrace $objSeries]
                            if {($value in {time category}) && [dict exists $_d -stack]} {
                                set v [lindex [dict get $_d -stack] 0]
                                if {$v ne "nothing"} {
                                    puts "warning (trace): yAxis.type should be set to 'value' or 'log'\
                                        if '$objSeries.stack' is set to '$v'"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return {}
}
