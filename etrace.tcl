# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
proc ticklecharts::traceEchartsVersion {minversion baseversion args} {
    # Changes the script Echarts version variable.
    #
    # minversion   - minimum version
    # baseversion  - current version
    # args         - not used.
    #
    # Returns nothing.
    variable escript ; variable echarts_version
    variable checkURL

    # Minimum Echarts version.
    if {[ticklecharts::vCompare $minversion $echarts_version] == 1} {
        error "The minimum Echarts version for 'ticklEcharts' package\
               is the version '$minversion', currently the modified version\
               is '$echarts_version'"
    }

    if {[regexp {@([0-9.]+)} $escript -> match]} {
        set vMap [list $match $echarts_version]
        set escript [string map $vMap $escript]
    } else {
        puts stderr "warning(trace): Num version (@X.X.X) should be present in 'Echarts' path js.\
                    If no pattern matches, the script path is left unchanged\
                    and the 'echarts_version' variable is set to base version"
        set echarts_version $baseversion
    }

    # Verify if a URL exists.
    # Output warning message if url doesn't exists
    if {$checkURL && [ticklecharts::isURL? $escript]} {
        ticklecharts::urlExists? $escript
    }

    return {}
}

proc ticklecharts::traceEchartsGLVersion {minversion baseversion args} {
    # Changes the script Echarts GL version variable.
    #
    # minversion   - minimum version
    # baseversion  - current version
    # args         - not used.
    #
    # Returns nothing.
    variable eGLscript ; variable gl_version
    variable checkURL

    # Minimum GL Echarts version.
    if {[ticklecharts::vCompare $minversion $gl_version] == 1} {
        error "The minimum Echarts GL version for 'ticklEcharts' package\
               is the version '$minversion', currently the modified version\
               is '$gl_version'"
    }

    if {[regexp {@([0-9.]+)} $eGLscript -> match]} {
        set vMap [list $match $gl_version]
        set eGLscript [string map $vMap $eGLscript]
    } else {
        puts stderr "warning(trace): Num version (@X.X.X) should be present in 'EchartsGL' path js.\
                    If no pattern matches, the script path is left unchanged\
                    and the 'gl_version' variable is set to base version"
        set gl_version $baseversion
    }

    # Verify if a URL exists.
    # Output warning message if url doesn't exists
    if {$checkURL && [ticklecharts::isURL? $eGLscript]} {
        ticklecharts::urlExists? $eGLscript
    }

    return {}
}

proc ticklecharts::traceGmapVersion {minversion baseversion args} {
    # Changes the script Gmap version variable.
    #
    # minversion   - minimum version
    # baseversion  - current version
    # args         - not used.
    #
    # Returns nothing.
    variable gmscript ; variable gmap_version
    variable checkURL

    # Minimum WordCloud Echarts version.
    if {[ticklecharts::vCompare $minversion $gmap_version] == 1} {
        error "The minimum Echarts Gmap version for 'ticklEcharts' package\
               is the version '$minversion', currently the modified version\
               is '$gmap_version'"
    }

    if {[regexp {@([0-9.]+)} $gmscript -> match]} {
        set vMap [list $match $gmap_version]
        set gmscript [string map $vMap $gmscript]
    } else {
        puts stderr "warning(trace): Num version (@X.X.X) should be present in 'gmap' path js.\
                    If no pattern matches, the script path is left unchanged\
                    and the 'gmap_version' variable is set to base version"
        set gmap_version $baseversion
    }

    # Verify if a URL exists.
    # Output warning message if url doesn't exists
    if {$checkURL && [ticklecharts::isURL? $gmscript]} {
        ticklecharts::urlExists? $gmscript
    }

    return {}
}

proc ticklecharts::traceWCVersion {minversion baseversion args} {
    # Changes the script echarts-wordcloud version variable.
    #
    # minversion   - minimum version
    # baseversion  - current version
    # args         - not used.
    #
    # Returns nothing.
    variable wcscript ; variable wc_version
    variable checkURL

    # Minimum WordCloud Echarts version.
    if {[ticklecharts::vCompare $minversion $wc_version] == 1} {
        error "The minimum Echarts wordcloud version for 'ticklEcharts' package\
               is the version '$minversion', currently the modified version\
               is '$wc_version'"
    }

    if {[regexp {@([0-9.]+)} $wcscript -> match]} {
        set WCMap [list $match $wc_version]
        set wcscript [string map $WCMap $wcscript]
    } else {
        puts stderr "warning(trace): Num version (@X.X.X) should be present in 'wordcloud' path js.\
                    If no pattern matches, the script path is left unchanged\
                    and the 'wc_version' variable is set to base version"
        set wc_version $baseversion
    }

    # Verify if a URL exists.
    # Output warning message if url doesn't exists
    if {$checkURL && [ticklecharts::isURL? $wcscript]} {
        ticklecharts::urlExists? $wcscript
    }

    return {}
}

proc ticklecharts::traceKeyGMAPI {args} {
    # Changes the API key in Google script js.
    #
    # args   - not used.
    #
    # Returns nothing.
    variable gapiscript ; variable keyGMAPI

    if {[regexp {key=([a-zA-Z0-9?_-]+)} $gapiscript -> match]} {
        set vMap [list $match $keyGMAPI]
        set gapiscript [string map $vMap $gapiscript]
    } else {
        puts stderr "warning(trace): 'key=' should be present in Google script path js.\
                    If no pattern matches, the script path is left unchanged."
    }

    return {}
}

proc ticklecharts::readEchartsVersion {minversion baseversion args} {
    # Checks the first variable reading.
    # Note : This trace is removed at first reading.
    #
    # minversion   - minimum version
    # baseversion  - current version
    # args         - list command
    #
    # Returns nothing.
    if {[ticklecharts::vCompare $minversion $baseversion] == 1} {
        error "The minimum version for '[lindex $args 0]' must be equal\
               to or greater to '$minversion', currently the variable\
               is equal to '$baseversion'"
    }

    # Remove trace.
    set vinfo [lindex [trace info variable [lindex $args 0]] 0 1]
    trace remove variable [lindex $args 0] read [list {*}$vinfo]

    return {}
}

proc ticklecharts::getTraceLevelProperties {level key value} {
    # Gets trace level properties
    #
    # level  - num level procedure
    # key    - key properties
    # value  - value properties
    #
    # Returns nothing

    set properties  {}
    set key [string map {"-" ""} $key]

    for {set i $level} {$i > 0} {incr i -1} {
        set name [lindex [info level $i] 0]
        if {[string match {ticklecharts::*} $name] || [ticklecharts::isAObject $name]} {
            set property [string map {ticklecharts:: ""} $name]
            # Adds an index if the level properties is related 
            # to a series or specific axes.
            if {
                [string match {ticklecharts::*Series} $name] ||
                [string match {ticklecharts::[xy]Axis} $name] ||
                [string match {ticklecharts::radarCoordinate} $name]
            } {

                set index [lindex [info level $i] 1]
                if {[ticklecharts::typeOf $index] ne "num"} {
                    error "'$index' should be an integer value." 
                }
                set property $property\($index)
            }

            if {$property ni $properties} {
                lappend properties $property
            }
        }
    }

    set properties [lreverse $properties]

    set obj [lindex $properties 0]

    if {![ticklecharts::isAObject $obj]} {
        error "First index of list for 'getTraceLevelProperties' command\
               should be an object, now is '$obj'"
    }

    # No other classes accepted.
    if {[$obj getType] ni {chart chart3D}} {
        return {}
    }

    # Guess if '$value' is an object.
    if {[ticklecharts::isAObject $value]} {
        set value [$value get]
    }

    set keyP [join [list {*}[lrange $properties 1 end] $key] "."]

    # Special case for 'parallelAxis'
    if {[lindex $properties 1] eq "parallelAxis"} {
        set trace [lreverse [$obj getTrace]]
        set map   [string map {parallelAxis {parallelAxis(*)}} $keyP]
        set pos   [lsearch -glob $trace $map]
        if {$pos > -1} {
            set re [string map {parallelAxis {parallelAxis\(([0-9]+)\)}} $keyP]
            regexp $re [lindex $trace $pos] -> match
            lset properties 1 "parallelAxis\([incr match])"
        } else {
            lset properties 1 "parallelAxis\(1)"
        }
        set keyP [join [list {*}[lrange $properties 1 end] $key] "."]
    }

    $obj setTrace $keyP $value


    return {}
}

proc ticklecharts::track {properties} {
    # The goal here is to find if certain values
    # match each other (experimental procedure 2nd test)
    # Maybe will be deleted... or reworked
    # Currently tested for :
    #   - lineSeries
    #   - barSeries
    #   - barSeries3D
    # Outputs :
    #  - A 'warning' message if there is a conflict between the properties.
    #  - An 'error' message if some axis combinations are not allowed.
    #
    # properties - list
    #
    # Returns nothing.

    foreach {keyP value} $properties {

        switch -glob -- $keyP {
            "lineSeries(*).showAllSymbol" {
                # https://echarts.apache.org/en/option.html#series-line.showAllSymbol
                if {$value ni {nothing null}} {
                    foreach {k info} [dict filter $properties key xAxis(*).type] {
                        if {$info ne "category"} {
                            puts stderr "warning(trace): '$k' should be set to 'category'\
                                        if '$keyP' is set to '$value'"
                        }
                    }
                }
            }
            "barSeries(*).stack"    -
            "barSeries3D(*).stack"  -
            "lineSeries(*).stack" {
                # https://echarts.apache.org/en/option.html#series-line.stack
                # https://echarts.apache.org/en/option.html#series-bar.stack
                # https://echarts.apache.org/en/option-gl.html#series-bar3D.stack
                if {$value ni {nothing null}} {
                    foreach {k info} [dict filter $properties key yAxis(*).type] {
                        # Case barSeries (horizontal)
                        set xval ""
                        if {[string match {barSeries*} $keyP]} {
                            foreach {kb infob} [dict filter $properties key xAxis(*).type] {
                                set xval $infob
                            }
                        }
                        if {$info in {time category} && ($xval ne "value")} {
                            puts stderr "warning(trace): '$k' should be set to 'value' or 'log'\
                                        if '$keyP' is set."
                        }
                    }
                }
            }
            "barSeries(*).stackStrategy"   -
            "barSeries3D(*).stackStrategy" -
            "lineSeries(*).stackStrategy" {
                # https://echarts.apache.org/en/option.html#series-line.stackStrategy
                # https://echarts.apache.org/en/option.html#series-bar.stackStrategy
                # https://echarts.apache.org/en/option-gl.html#series-bar3D.stackStrategy
                if {$value ni {nothing null}} {
                    lassign [split $keyP "."] series _
                    if {![dict exists $properties $series.stack] || [dict get $properties $series.stack] in {nothing null}} {
                        puts stderr "warning(trace): If '$keyP' is set, '$series.stack' should be set too."
                    }
                }
            }
            "lineSeries(*).label.distance" {
                # https://echarts.apache.org/en/option.html#series-line.label.distance
                lassign [split $keyP "."] series _
                if {($value ni {nothing null}) && [dict exists $properties $series.label.position]} {
                    set v [dict get $properties $series.label.position]
                    if {($v ni {nothing null}) && ($v ni {top insideRight})} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.label.position' is a 'string' (like 'top', 'insideRight')."
                    }
                }
            }
            "lineSeries(*).labelLine.lineStyle.miterLimit" {
                # https://echarts.apache.org/en/option.html#series-line.labelLine.lineStyle.miterLimit
                lassign [split $keyP "."] series _
                if {($value ni {nothing null}) && [dict exists $properties $series.labelLine.lineStyle.join]} {
                    set v [dict get $properties $series.labelLine.lineStyle.join]
                    if {$v ne "miter"} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.labelLine.lineStyle.join' is set as 'miter'"
                    }
                }
            }
            "lineSeries(*).labelLine.lineStyle.join" {
                # https://echarts.apache.org/en/option.html#series-line.labelLine.lineStyle.join
                lassign [split $keyP "."] series _
                if {($value ni {nothing null}) && [dict exists $properties $series.labelLine.lineStyle.miterLimit]} {
                    set v [dict get $properties $series.labelLine.lineStyle.miterLimit]
                    if {$v eq "nothing"} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.labelLine.lineStyle.miterLimit' is set, now it set to '$v'"
                    }
                }
            }
            "lineSeries(*).itemStyle.borderMiterLimit" {
                # https://echarts.apache.org/en/option.html#series-line.itemStyle.borderMiterLimit
                lassign [split $keyP "."] series _
                if {($value ni {nothing null}) && [dict exists $properties $series.itemStyle.borderJoin]} {
                    set v [dict get $properties $series.itemStyle.borderJoin]
                    if {$v ne "miter"} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.itemStyle.borderJoin' is set as 'miter'"
                    }
                }
            }
            "lineSeries(*).itemStyle.borderJoin" {
                # Doc e.g: https://echarts.apache.org/en/option.html#series-line.itemStyle.borderJoin
                lassign [split $keyP "."] series _
                if {($value eq "miter") && [dict exists $properties $series.itemStyle.borderMiterLimit]} {
                    set v [dict get $properties $series.itemStyle.borderMiterLimit]
                    if {$v in {nothing null}} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.itemStyle.borderMiterLimit' is set, now it set to '$v'"
                    }
                }
            }
            "lineSeries(*).label.ellipsis" {
                # https://echarts.apache.org/en/option.html#series-line.label.ellipsis
                lassign [split $keyP "."] series _
                if {($value ni {nothing null}) && [dict exists $properties $series.label.overflow]} {
                    set v [dict get $properties $series.label.overflow]
                    if {$v ne "truncate"} {
                        puts stderr "warning(trace): '$keyP' is displayed when\
                                    '$series.label.overflow' is set to 'truncate'."
                    }
                }
            }
            "xAxis(*).id" -
            "yAxis(*).id" {
                # Some axis combinations are not allowed.
                foreach axisID {
                    angleAxis radiusAxis radarCoordinate
                    singleAxis parallelAxis
                } {
                    if {[dict keys $properties ${axisID}*.id] ne ""} {
                        regsub {\(\d+\)\.id} $keyP {} axis1
                        return -code error "'$axisID' not suitable with '$axis1'"
                    }
                }
            }
            "barSeries(*).data"  -
            "lineSeries(*).data" {
                if {$value ne ""} {
                    foreach axis {xAxis yAxis} {
                        foreach {k info} [dict filter $properties key ${axis}(*).data] {
                            if {($info ne "nothing") && [llength $value] > 1} {
                                return -code error "'$keyP' is defined as \[\[X, Y] \[...]], data\
                                    '$axis.data' property should not exist."
                            }
                        }
                    }                    
                }
            }
            "xAxis(*).data" -
            "yAxis(*).data" {
                if {($value ni {nothing null}) && [llength $value] > 1} {
                    return -code error "'$keyP' cannot be defined as \[\[X, Y] \[...]]."
                }
            }
            "yAxis(*).alignTicks" -
            "xAxis(*).alignTicks" {
                # https://echarts.apache.org/en/option.html#xAxis.alignTicks
                if {($value ni {nothing null}) && $value} {
                    set axis [lindex [split $keyP "."] 0]
                    if {[dict exists $properties ${axis}.type]} {
                        set p [dict get $properties ${axis}.type] 
                        if {($p ne "null") && ($p ni {value log})} {
                            puts stderr "warning(trace): ${axis}.type should be set to\
                                        'value' or 'log' if '$keyP' is set to '$value'."
                        }
                    }
                }
            }
            "yAxis(*).scale" - "radiusAxis.scale" - "angleAxis.scale" -
            "xAxis(*).scale" - "singleAxis.scale" - "parallelAxis(*).scale" {
                # https://echarts.apache.org/en/option.html#xAxis.scale
                if {($value ni {nothing null}) && $value} {
                    set axis [lindex [split $keyP "."] 0]
                    if {[dict exists $properties ${axis}.type]} {
                        set p [dict get $properties ${axis}.type] 
                        if {($p ne "null") && ($p ne "value")} {
                            puts stderr "warning(trace): ${axis}.type should be set to\
                                        'value' if '$keyP' is set to '$value'."
                        }
                    }
                    if {[dict exists $properties ${axis}.max] && 
                        [dict exists $properties ${axis}.min]
                    } {
                        set max [dict get $properties ${axis}.max]
                        set min [dict get $properties ${axis}.min]
                        if {($max ni {nothing null}) && ($min ni {nothing null})} {
                            puts stderr "warning(trace): ${axis}.scale is unavailable\
                                         when the 'min' and 'max' properties are set."
                        }
                    }
                }
            }
            "yAxis(*).splitNumber" - "singleAxis.splitNumber" - "angleAxis.splitNumber" -
            "xAxis(*).splitNumber" - "radiusAxis.splitNumber" - "parallelAxis(*).splitNumber" {
                # https://echarts.apache.org/en/option.html#xAxis.splitNumber
                if {$value ni {nothing null}} {
                    set axis [lindex [split $keyP "."] 0]
                    if {[dict exists $properties ${axis}.type]} {
                        set p [dict get $properties ${axis}.type] 
                        if {($p ne "null") && ($p eq "category")} {
                            puts stderr "warning(trace): ${axis}.type should not be set to\
                                        'category' if '$keyP' is set."
                        }
                    }
                }
            }
            "yAxis(*).interval" - "singleAxis.interval" - "angleAxis.interval" -
            "xAxis(*).interval" - "radiusAxis.interval" - "parallelAxis(*).interval" {
                # https://echarts.apache.org/en/option.html#xAxis.interval
                if {$value ni {nothing null}} {
                    set axis [lindex [split $keyP "."] 0]
                    if {[dict exists $properties ${axis}.type]} {
                        set p [dict get $properties ${axis}.type] 
                        if {($p ne "null") && ($p eq "category")} {
                            puts stderr "warning(trace): ${axis}.type should not be set to\
                                        'category' if '$keyP' is set."
                        }
                    }
                }
            }
            "yAxis(*).minInterval"   - "yAxis(*).maxInterval"        - "singleAxis.maxInterval" -
            "radiusAxis.minInterval" - "radiusAxis.maxInterval"      - "angleAxis.maxInterval"  -
            "xAxis(*).minInterval"   - "xAxis(*).maxInterval"        - "singleAxis.minInterval" - 
            "angleAxis.minInterval"  - "parallelAxis(*).maxInterval" - "parallelAxis(*).minInterval" {
                # https://echarts.apache.org/en/option.html#xAxis.minInterval
                # https://echarts.apache.org/en/option.html#xAxis.maxInterval
                if {$value ni {nothing null}} {
                    set axis [lindex [split $keyP "."] 0]
                    if {[dict exists $properties ${axis}.type]} {
                        set p [dict get $properties ${axis}.type] 
                        if {($p ni {null nothing}) && ($p ni {value time})} {
                            puts stderr "warning(trace): ${axis}.type should not be set to\
                                        '$p' if '$keyP' is set."
                        }
                    }
                }
            }
            "yAxis(*).logBase" - "singleAxis.logBase" - "angleAxis.logBase" -
            "xAxis(*).logBase" - "radiusAxis.logBase" - "parallelAxis(*).logBase" {
                # https://echarts.apache.org/en/option.html#xAxis.logBase
                if {$value ni {nothing null}} {
                    set axis [lindex [split $keyP "."] 0]
                    if {[dict exists $properties ${axis}.type]} {
                        set p [dict get $properties ${axis}.type] 
                        if {($p ne "null") && ($p ne "log")} {
                            puts stderr "warning(trace): ${axis}.type should be set to\
                                        'log' if '$keyP' is set."
                        }
                    }
                }
            }
            "yAxis(*).offset" -
            "xAxis(*).offset" {
                # https://echarts.apache.org/en/option.html#xAxis.offset
                # https://echarts.apache.org/en/option.html#yAxis.offset
                if {$value ni {nothing null}} {
                    set axis [lindex [split $keyP "."] 0]
                    if {[dict exists $properties ${axis}.axisLine.onZero] &&
                        [dict get $properties ${axis}.axisLine.onZero]} {
                        puts stderr "warning(trace): Set '${axis}.axisLine.onZero' to\
                                     'False' to activate '$keyP' option."
                    }
                }
            }
            "xAxis(*).tooltip"  - "yAxis(*).tooltip" - "radiusAxis.tooltip" -
            "angleAxis.tooltip" - "parallelAxis(*).tooltip" - "parallel.parallelAxisDefault.tooltip" {
                if {$value ni {nothing null}} {
                    if {$keyP eq "parallel.parallelAxisDefault.tooltip"} {
                        set axis [string map {.tooltip ""} $keyP]
                    } else {
                        set axis [lindex [split $keyP "."] 0]
                    }
                    if {[dict exists $properties ${axis}.triggerEvent] &&
                        ![string equal -nocase "true" [dict get $properties ${axis}.triggerEvent]]
                    } {
                        puts stderr "warning(trace): Set '${axis}.triggerEvent' to\
                                     'True' to activate '$keyP' option."
                    }
                }
            }
        }
    }

    return {}
}

namespace eval ticklecharts {
    # Minimum versions :
    proc EVMIN    {} {return "5.0.0"}
    proc GLVMIN   {} {return "2.0.0"}
    proc GMAPVMIN {} {return "1.5.0"}
    proc WCVMIN   {} {return "2.0.0"}

    # Adds a trace when the variable version is read for the first time.
    # This trace command is removed on first reading.
    trace add variable echarts_version read [list ticklecharts::readEchartsVersion [EVMIN]    $echarts_version]
    trace add variable gl_version      read [list ticklecharts::readEchartsVersion [GLVMIN]   $gl_version]
    trace add variable gmap_version    read [list ticklecharts::readEchartsVersion [GMAPVMIN] $gmap_version]
    trace add variable wc_version      read [list ticklecharts::readEchartsVersion [WCVMIN]   $wc_version]

    # When the version is modified adds trace command.
    #  - The first argument of the command is the minimum version.
    #  - The last argument of the command is the current version.
    trace add variable echarts_version write [list ticklecharts::traceEchartsVersion   [EVMIN]    $echarts_version]
    trace add variable gl_version      write [list ticklecharts::traceEchartsGLVersion [GLVMIN]   $gl_version]
    trace add variable gmap_version    write [list ticklecharts::traceGmapVersion      [GMAPVMIN] $gmap_version]
    trace add variable wc_version      write [list ticklecharts::traceWCVersion        [WCVMIN]   $wc_version]
    trace add variable keyGMAPI        write [list ticklecharts::traceKeyGMAPI]
}