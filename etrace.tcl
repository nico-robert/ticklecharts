# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

# Minimum versions
set ECHARTSVMIN "5.0.0"
set GLVMIN      "2.0.0"
set GMAPVMIN    "1.5.0"
set WCVMIN      "2.0.0"

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
    set traceSeries {lineSeries barSeries barSeries3D} ; # series filters 
    set key [string map {"-" ""} $key]

    for {set i $level} {$i > 0} {incr i -1} {
        set name [lindex [info level $i] 0]
        if {[string match {ticklecharts::*} $name] || [ticklecharts::isAObject $name]} {
            set property [string map {ticklecharts:: ""} $name]

            # Adds an index if the level properties is related to a series.
            if {[string match {ticklecharts::*Series} $name]} {
                
                # No other series accepted.
                if {$property ni $traceSeries} {return {}}

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

    $obj setTrace [join [list {*}[lrange $properties 1 end] $key] "."] $value

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
    # REMINDER FOR ME : The series are filtered in this procedure
    # 'ticklecharts::getTraceLevelProperties', if you want to add series,
    # think of also modifying it here.
    #
    # Returns nothing.

    foreach {keyP value} $properties {
        set i [expr {[regexp {\(\d+\)} $keyP num] ? $num : -1}]
        
        switch -exact -- $keyP {
            "lineSeries($i).showAllSymbol" {
                # https://echarts.apache.org/en/option.html#series-line.showAllSymbol
                if {($value ne "nothing") && [dict exists $properties xAxis.type]} {
                    set v [dict get $properties xAxis.type] 
                    if {$v ne "category"} {
                        puts stderr "warning(trace): xAxis.type should be set to 'category'\
                                     if '$keyP' is set to '$value'"
                    }
                }
            }
            "barSeries($i).stack"    -
            "barSeries3D($i).stack"  -
            "lineSeries($i).stack" {
                # https://echarts.apache.org/en/option.html#series-line.stack
                # https://echarts.apache.org/en/option.html#series-bar.stack
                # https://echarts.apache.org/en/option-gl.html#series-bar3D.stack
                if {($value ne "nothing") && [dict exists $properties yAxis.type]} {
                    set v [dict get $properties yAxis.type]
                    # Case barSeries (horizontal)
                    set xval ""
                    if {[string match {barSeries*} $keyP]} {
                        if {[dict exists $properties xAxis.type]} {
                            set xval [dict get $properties xAxis.type]
                        }
                    }
                    if {$v in {time category} && ($xval ne "value")} {
                        puts stderr "warning(trace): yAxis.type should be set to 'value' or 'log'\
                                    if '$keyP' is set."
                    }
                }
            }
            "barSeries($i).stackStrategy"   -
            "barSeries3D($i).stackStrategy" -
            "lineSeries($i).stackStrategy" {
                # https://echarts.apache.org/en/option.html#series-line.stackStrategy
                # https://echarts.apache.org/en/option.html#series-bar.stackStrategy
                # https://echarts.apache.org/en/option-gl.html#series-bar3D.stackStrategy
                if {$value ne "nothing"} {
                    lassign [split $keyP "."] series _
                    if {![dict exists $properties $series.stack] || [dict get $properties $series.stack] eq "nothing"} {
                        puts stderr "warning(trace): If '$keyP' is set, '$series.stack' should be set too."
                    }
                }
            }
            "lineSeries($i).label.distance" {
                # https://echarts.apache.org/en/option.html#series-line.label.distance
                lassign [split $keyP "."] series _
                if {($value ne "nothing") && [dict exists $properties $series.label.position]} {
                    set v [dict get $properties $series.label.position]
                    if {($v ne "nothing") && ($v ni {top insideRight})} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.label.position' is a 'string' (like 'top', 'insideRight')."
                    }
                }
            }
            "lineSeries($i).labelLine.lineStyle.miterLimit" {
                # https://echarts.apache.org/en/option.html#series-line.labelLine.lineStyle.miterLimit
                lassign [split $keyP "."] series _
                if {($value ne "nothing") && [dict exists $properties $series.labelLine.lineStyle.join]} {
                    set v [dict get $properties $series.labelLine.lineStyle.join]
                    if {$v ne "miter"} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.labelLine.lineStyle.join' is set as 'miter'"
                    }
                }
            }
            "lineSeries($i).labelLine.lineStyle.join" {
                # https://echarts.apache.org/en/option.html#series-line.labelLine.lineStyle.join
                lassign [split $keyP "."] series _
                if {($value ne "nothing") && [dict exists $properties $series.labelLine.lineStyle.miterLimit]} {
                    set v [dict get $properties $series.labelLine.lineStyle.miterLimit]
                    if {$v eq "nothing"} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.labelLine.lineStyle.miterLimit' is set, now it set to '$v'"
                    }
                }
            }
            "lineSeries($i).itemStyle.borderMiterLimit" {
                # https://echarts.apache.org/en/option.html#series-line.itemStyle.borderMiterLimit
                lassign [split $keyP "."] series _
                if {($value ne "nothing") && [dict exists $properties $series.itemStyle.borderJoin]} {
                    set v [dict get $properties $series.itemStyle.borderJoin]
                    if {$v ne "miter"} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.itemStyle.borderJoin' is set as 'miter'"
                    }
                }
            }
            "lineSeries($i).itemStyle.borderJoin" {
                # Doc e.g: https://echarts.apache.org/en/option.html#series-line.itemStyle.borderJoin
                lassign [split $keyP "."] series _
                if {($value eq "miter") && [dict exists $properties $series.itemStyle.borderMiterLimit]} {
                    set v [dict get $properties $series.itemStyle.borderMiterLimit]
                    if {$v eq "nothing"} {
                        puts stderr "warning(trace): '$keyP' is valid only\
                                    when '$series.itemStyle.borderMiterLimit' is set, now it set to '$v'"
                    }
                }
            }
            "lineSeries($i).label.ellipsis" {
                # https://echarts.apache.org/en/option.html#series-line.label.ellipsis
                lassign [split $keyP "."] series _
                if {($value ne "nothing") && [dict exists $properties $series.label.overflow]} {
                    set v [dict get $properties $series.label.overflow]
                    if {$v ne "truncate"} {
                        puts stderr "warning(trace):: '$keyP' is displayed when\
                                    '$series.label.overflow' is set to 'truncate'."
                    }
                }
            }
            "xAxis.id" -
            "yAxis.id" {
                # Some axis combinations are not allowed.
                foreach axisID {
                    angleAxis.id radiusAxis.id radarCoordinate.id 
                    singleAxis.id parallelAxis.id
                } {
                    if {[dict exists $properties $axisID]} {
                        set axis1 [lindex [split $keyP "."] 0]
                        set axis2 [lindex [split $axisID "."] 0]
                        return -code error "'$axis2' not suitable with '$axis1'"
                    }
                }
            }
            "barSeries($i).data"  -
            "lineSeries($i).data" {
                if {$value ne ""} {
                    foreach axis {xAxis yAxis} {
                        if {[dict exists $properties $axis.data]} {
                            set val [dict get $properties $axis.data]
                            if {($val ne "nothing") && [llength $value] > 1} {
                                return -code error "'$keyP' is defined as \[\[X, Y] \[...]], data\
                                    '$axis.data' property should not exist."
                            }
                        }
                    }                    
                }
            }
            "xAxis.data" -
            "yAxis.data" {
                if {($value ne "nothing") && [llength $value] > 1} {
                    return -code error "'$keyP' cannot be defined as \[\[X, Y] \[...]]."
                }
            }
        }
    }

    return {}
}

# Adds a trace when the variable version is read for the first time.
# This trace command is removed on first reading.
trace add variable ticklecharts::echarts_version read [list ticklecharts::readEchartsVersion $ECHARTSVMIN $::ticklecharts::echarts_version]
trace add variable ticklecharts::gl_version      read [list ticklecharts::readEchartsVersion $GLVMIN      $::ticklecharts::gl_version]
trace add variable ticklecharts::gmap_version    read [list ticklecharts::readEchartsVersion $GMAPVMIN    $::ticklecharts::gmap_version]
trace add variable ticklecharts::wc_version      read [list ticklecharts::readEchartsVersion $WCVMIN      $::ticklecharts::wc_version]

# When the version is modified adds trace command.
# The first argument of the command is the minimum version.
# The last argument of the command is the current version.
trace add variable ticklecharts::echarts_version write [list ticklecharts::traceEchartsVersion   $ECHARTSVMIN $::ticklecharts::echarts_version]
trace add variable ticklecharts::gl_version      write [list ticklecharts::traceEchartsGLVersion $GLVMIN      $::ticklecharts::gl_version] 
trace add variable ticklecharts::gmap_version    write [list ticklecharts::traceGmapVersion      $GMAPVMIN    $::ticklecharts::gmap_version]
trace add variable ticklecharts::wc_version      write [list ticklecharts::traceWCVersion        $WCVMIN      $::ticklecharts::wc_version]
trace add variable ticklecharts::keyGMAPI        write [list ticklecharts::traceKeyGMAPI]