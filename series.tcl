# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
#
namespace eval ticklecharts {}

proc ticklecharts::barseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-bar
    #
    # index - index series.
    # value - Options described in proc ticklecharts::barseries below.
    #
    # return dict barseries options

    setdef options -type                    -type str             -default "bar"
    setdef options -id                      -type str|null        -default "nothing"
    setdef options -name                    -type str             -default "barseries_${index}"
    setdef options -colorBy                 -type str             -default "series"
    setdef options -legendHoverLink         -type bool            -default "True"
    setdef options -coordinateSystem        -type str             -default "cartesian2d"
    setdef options -xAxisIndex              -type num|null        -default "nothing"
    setdef options -yAxisIndex              -type num|null        -default "nothing"
    setdef options -polarIndex              -type num|null        -default "nothing"
    setdef options -roundCap                -type bool            -default "False"
    setdef options -showBackground          -type bool            -default "False"
    setdef options -backgroundStyle         -type dict|null       -default [ticklecharts::backgroundStyle $value]
    setdef options -label                   -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -itemStyle               -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -labelLayout             -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -emphasis                -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -type bool|str|null   -default "nothing"
    setdef options -stack                   -type str|null        -default "nothing"
    setdef options -sampling                -type str             -default "max"
    setdef options -cursor                  -type str|null        -default "pointer"
    setdef options -barWidth                -type str|num|null    -default "nothing"
    setdef options -barMaxWidth             -type str|num|null    -default "nothing"
    setdef options -barMinWidth             -type str|num|null    -default "null"
    setdef options -barMinHeight            -type num|null        -default "nothing"
    setdef options -barMinAngle             -type num|null        -default "nothing"
    setdef options -barGap                  -type str|null        -default "nothing"
    setdef options -barCategoryGap          -type str|null        -default "20%"
    setdef options -large                   -type bool            -default "False"
    setdef options -largeThreshold          -type num             -default 400
    setdef options -progressive             -type num|null        -default "nothing"
    setdef options -progressiveThreshold    -type num|null        -default "nothing"
    setdef options -progressiveChunkMode    -type str|null        -default "nothing"
    setdef options -progressiveChunkMode    -type str|null        -default "nothing"
    setdef options -data                    -type list.d          -default {}
    setdef options -markLine                -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markPoint               -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -zlevel                  -type num             -default 0
    setdef options -z                       -type num             -default 2
    setdef options -silent                  -type bool            -default "False"
    setdef options -animation               -type bool|null       -default "nothing"
    setdef options -animationThreshold      -type num|null        -default "nothing"
    setdef options -animationDuration       -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -type str|null        -default "nothing"
    setdef options -animationDelay          -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -type num|jsfunc|null -default "nothing"
    # not supported yet...

    # setdef options -dimensions             -type list.d|null      -default "nothing"
    # setdef options -encode                 -type dict|null        -default "nothing"
    # setdef options -seriesLayoutBy         -type str|null         -default "nothing"
    # setdef options -datasetIndex           -type num|null         -default "nothing"
    # setdef options -dataGroupId            -type str|null         -default "nothing"
    # setdef options -tooltip                -type dict|null        -default [ticklecharts::tooltipseries $value]
      
    if {[dict exists $value -databaritem]} {
        set options [dict remove $options -data]
        setdef options -data -type list.o -default [ticklecharts::BarItem $value]
    }
    
    set value [dict remove $value -label -endLabel \
                                  -labelLine -lineStyle \
                                  -areaStyle -markPoint \
                                  -labelLayout -itemStyle -backgroundStyle \
                                  -emphasis -blur -select -tooltip]
                                
    set options [merge $options $value]

    return $options

}

proc ticklecharts::lineseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-line
    #
    # index - index series.
    # value - Options described in proc ticklecharts::lineseries below.
    #
    # return dict barseries options

    setdef options -type                    -type str             -default "line"
    setdef options -id                      -type str|null        -default "nothing"
    setdef options -name                    -type str             -default "lineseries_${index}"
    setdef options -colorBy                 -type str             -default "series"
    setdef options -coordinateSystem        -type str             -default "cartesian2d"
    setdef options -xAxisIndex              -type num|null        -default "nothing"
    setdef options -yAxisIndex              -type num|null        -default "nothing"
    setdef options -polarIndex              -type num|null        -default "nothing"
    setdef options -symbol                  -type str|jsfunc|null -default [dict get $::ticklecharts::opts_theme symbol]
    setdef options -symbolSize              -type num|list.n      -default [dict get $::ticklecharts::opts_theme symbolSize]
    setdef options -symbolRotate            -type num|null        -default "nothing"
    setdef options -symbolKeepAspect        -type bool            -default "True"
    setdef options -symbolOffset            -type list.d|null     -default "nothing"
    setdef options -showSymbol              -type bool            -default "True"
    setdef options -showAllSymbol           -type bool|str        -default "auto"
    setdef options -legendHoverLink         -type bool            -default "True"
    setdef options -stack                   -type str|null        -default "nothing"
    setdef options -cursor                  -type str|null        -default "pointer"
    setdef options -connectNulls            -type bool            -default "False"
    setdef options -clip                    -type bool            -default "True"
    setdef options -triggerLineEvent        -type bool            -default "False"
    setdef options -step                    -type bool            -default "False"
    setdef options -label                   -type dict|null       -default [ticklecharts::label $value]
    setdef options -endLabel                -type dict|null       -default [ticklecharts::endLabel $value]
    setdef options -labelLine               -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -lineStyle               -type dict|null       -default [ticklecharts::lineStyle $value]
    setdef options -areaStyle               -type dict|null       -default [ticklecharts::areaStyle $value]
    setdef options -emphasis                -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -type bool|str|null   -default "nothing"
    setdef options -smooth                  -type bool|num        -default [dict get $::ticklecharts::opts_theme lineSmooth]
    setdef options -smoothMonotone          -type str|null        -default "nothing"
    setdef options -sampling                -type str|null        -default "nothing"
    setdef options -data                    -type list.d          -default {}
    setdef options -markPoint               -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -type num             -default 0
    setdef options -z                       -type num             -default 2
    setdef options -silent                  -type bool            -default "False"
    setdef options -animation               -type bool|null       -default "nothing"
    setdef options -animationThreshold      -type num|null        -default "nothing"
    setdef options -animationDuration       -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -type str|null        -default "nothing"
    setdef options -animationDelay          -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -type num|jsfunc|null -default "nothing"
    # not supported yet...

    # setdef options -dimensions             -type list.d|null      -default "nothing"
    # setdef options -encode                 -type dict|null        -default "nothing"
    # setdef options -seriesLayoutBy         -type str|null         -default "nothing"
    # setdef options -datasetIndex           -type num|null         -default "nothing"
    # setdef options -dataGroupId            -type str|null         -default "nothing"
    # setdef options -tooltip                -type dict|null        -default [ticklecharts::tooltipseries $value]
    
    
    if {[dict exists $value -datalineitem]} {
        set options [dict remove $options -data]
        setdef options -data -type list.o -default [ticklecharts::LineItem $value]
    }
    
    set value [dict remove $value -label -endLabel \
                                  -labelLine -lineStyle \
                                  -areaStyle -markPoint -markLine -markArea \
                                  -labelLayout -itemStyle\
                                  -emphasis -blur -select -tooltip]
                                
    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::pieseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-pie
    #
    # index - index series.
    # value - Options described in proc ticklecharts::pieseries below.
    #
    # return dict pieseries options

    setdef options -type                    -type str             -default "pie"
    setdef options -id                      -type str|null        -default "nothing"
    setdef options -name                    -type str             -default "pieseries_${index}"
    setdef options -colorBy                 -type str             -default "data"
    setdef options -legendHoverLink         -type bool            -default "True"
    setdef options -selectedMode            -type bool|str|null   -default "nothing"
    setdef options -selectedOffset          -type num             -default 10
    setdef options -clockwise               -type bool            -default "True"
    setdef options -startAngle              -type num             -default 90
    setdef options -minAngle                -type num             -default 0
    setdef options -minShowLabelAngle       -type num             -default 0
    setdef options -roseType                -type bool|str        -default "False"
    setdef options -avoidLabelOverlap       -type bool            -default "True"
    setdef options -stillShowZeroSum        -type bool            -default "True"
    setdef options -cursor                  -type str|null        -default "pointer"
    setdef options -zlevel                  -type num             -default 0
    setdef options -z                       -type num             -default 2
    setdef options -left                    -type num|str         -default 0
    setdef options -top                     -type num|str         -default 0
    setdef options -right                   -type num|str         -default 0
    setdef options -bottom                  -type num|str         -default 0
    setdef options -width                   -type num|str         -default "auto"
    setdef options -height                  -type num|str         -default "auto"
    setdef options -showEmptyCircle         -type bool            -default "True"
    setdef options -emptyCircleStyle        -type dict|null       -default [ticklecharts::emptyCircleStyle $value]
    setdef options -label                   -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -type dict|null       -default [ticklecharts::select $value]
    setdef options -center                  -type list.d          -default [list {"50%" "50%"}]
    setdef options -radius                  -type list.d|num|str  -default [list {0 "75%"}]
    setdef options -data                    -type list.o          -default [ticklecharts::PieItem $value]
    setdef options -markPoint               -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -silent                  -type bool            -default "False"
    setdef options -animationType           -type str|null        -default "expansion"
    setdef options -animationTypeUpdate     -type str|null        -default "transition"
    setdef options -animation               -type bool|null       -default "True"
    setdef options -animationThreshold      -type num|null        -default "nothing"
    setdef options -animationDuration       -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -type str|null        -default "nothing"
    setdef options -animationDelay          -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -type bool|null       -default "nothing"

    # not supported yet...

    # setdef options -dimensions             -type list.d|null      -default "nothing"
    # setdef options -encode                 -type dict|null        -default "nothing"
    # setdef options -seriesLayoutBy         -type str|null         -default "nothing"
    # setdef options -datasetIndex           -type num|null         -default "nothing"
    # setdef options -dataGroupId            -type str|null         -default "nothing"
    # setdef options -tooltip                -type dict|null        -default [ticklecharts::tooltipseries $value]

    set value [dict remove $value -label \
                                  -labelLine \
                                  -markPoint \
                                  -markLine -markArea \
                                  -emptyCircleStyle \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -tooltip]
    

    set options [merge $options $value]

    return $options

}

proc ticklecharts::funnelseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-funnel
    #
    # index - index series.
    # value - Options described in proc ticklecharts::funnelseries below.
    #
    # return dict funnelseries options

    setdef options -type                    -type str             -default "funnel"
    setdef options -id                      -type str|null        -default "nothing"
    setdef options -name                    -type str             -default "funnelseries_${index}"
    setdef options -colorBy                 -type str             -default "data"
    setdef options -min                     -type num|null        -default "nothing"
    setdef options -max                     -type num|null        -default "nothing"
    setdef options -minSize                 -type str|num|null    -default "0%"
    setdef options -maxSize                 -type str|num|null    -default "100%"
    setdef options -orient                  -type str             -default "vertical"
    setdef options -sort                    -type str|jsfunc      -default "descending"
    setdef options -gap                     -type num             -default 0
    setdef options -legendHoverLink         -type bool            -default "True"
    setdef options -funnelAlign             -type str             -default "center"
    setdef options -label                   -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -type bool|str|null   -default "True"
    setdef options -zlevel                  -type num             -default 0
    setdef options -z                       -type num             -default 2
    setdef options -left                    -type num|str         -default 0
    setdef options -top                     -type num|str         -default 0
    setdef options -right                   -type num|str         -default 0
    setdef options -bottom                  -type num|str         -default 0
    setdef options -width                   -type num|str         -default "auto"
    setdef options -height                  -type num|str         -default "auto"
    setdef options -data                    -type list.o          -default [ticklecharts::FunnelItem $value]
    setdef options -markPoint               -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -silent                  -type bool            -default "False"
    setdef options -animationType           -type str|null        -default "expansion"
    setdef options -animationTypeUpdate     -type str|null        -default "transition"
    setdef options -animation               -type bool|null       -default "True"
    setdef options -animationThreshold      -type num|null        -default "nothing"
    setdef options -animationDuration       -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -type str|null        -default "nothing"
    setdef options -animationDelay          -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -type bool|null       -default "nothing"

    # not supported yet...

    # setdef options -dimensions             -type list.d|null      -default "nothing"
    # setdef options -encode                 -type dict|null        -default "nothing"
    # setdef options -seriesLayoutBy         -type str|null         -default "nothing"
    # setdef options -datasetIndex           -type num|null         -default "nothing"
    # setdef options -dataGroupId            -type str|null         -default "nothing"
    # setdef options -tooltip                -type dict|null        -default [ticklecharts::tooltipseries $value]

    set value [dict remove $value -label \
                                  -labelLine \
                                  -markPoint \
                                  -markLine -markArea \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -tooltip]
    

    set options [merge $options $value]

    return $options

}

proc ticklecharts::radarseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-radar
    #
    # index - index series.
    # value - Options described in proc ticklecharts::radarseries below.
    #
    # return dict radarseries options

    setdef options -type                    -type str             -default "radar"
    setdef options -id                      -type str|null        -default "nothing"
    setdef options -name                    -type str             -default "radarseries_${index}"
    setdef options -colorBy                 -type str             -default "data"
    setdef options -radarIndex              -type num|null        -default 0
    setdef options -symbol                  -type str|jsfunc|null -default "circle"
    setdef options -symbolSize              -type num|list.n      -default 8
    setdef options -symbolRotate            -type num|null        -default "nothing"
    setdef options -symbolKeepAspect        -type bool            -default "True"
    setdef options -symbolOffset            -type list.d|null     -default "nothing"
    setdef options -label                   -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLayout             -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -lineStyle               -type dict|null       -default [ticklecharts::lineStyle $value]
    setdef options -areaStyle               -type dict|null       -default [ticklecharts::areaStyle $value]
    setdef options -emphasis                -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -type bool|str|null   -default "nothing"
    setdef options -data                    -type list.o          -default [ticklecharts::RadarItem $value]
    setdef options -zlevel                  -type num             -default 0
    setdef options -z                       -type num             -default 2
    setdef options -silent                  -type bool            -default "False"
    setdef options -animation               -type bool|null       -default "nothing"
    setdef options -animationThreshold      -type num|null        -default "nothing"
    setdef options -animationDuration       -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -type str|null        -default "nothing"
    setdef options -animationDelay          -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -type num|jsfunc|null -default "nothing"

    # not supported yet...

    # setdef options -dataGroupId            -type str|null         -default "nothing"
    # setdef options -universalTransition    -type dict|null        -default "nothing"
    # setdef options -tooltip                -type dict|null        -default [ticklecharts::tooltipseries $value]

    set value [dict remove $value -label \
                                  -lineStyle \
                                  -areaStyle \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -tooltip]
                                
    set options [merge $options $value]

    return $options

}