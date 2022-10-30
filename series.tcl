# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::barseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-bar
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::barseries below.
    #
    # return dict barseries options

    setdef options -type                    -validvalue {}                   -type str             -default "bar"
    setdef options -id                      -validvalue {}                   -type str|null        -default "nothing"
    setdef options -name                    -validvalue {}                   -type str             -default "barseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy        -type str             -default "series"
    setdef options -legendHoverLink         -validvalue {}                   -type bool            -default "True"
    setdef options -coordinateSystem        -validvalue formatCSYS           -type str             -default "cartesian2d"
    setdef options -xAxisIndex              -validvalue {}                   -type num|null        -default "nothing"
    setdef options -yAxisIndex              -validvalue {}                   -type num|null        -default "nothing"
    setdef options -polarIndex              -validvalue {}                   -type num|null        -default "nothing"
    setdef options -roundCap                -validvalue {}                   -type bool            -default "False"
    setdef options -showBackground          -validvalue {}                   -type bool            -default "False"
    setdef options -backgroundStyle         -validvalue {}                   -type dict|null       -default [ticklecharts::backgroundStyle $value]
    setdef options -label                   -validvalue {}                   -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -validvalue {}                   -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -itemStyle               -validvalue {}                   -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -labelLayout             -validvalue {}                   -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -emphasis                -validvalue {}                   -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                   -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                   -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode   -type bool|str|null   -default "nothing"
    setdef options -stack                   -validvalue {}                   -type str|null        -default "nothing"
    setdef options -sampling                -validvalue formatSampling       -type str             -default "max"
    setdef options -cursor                  -validvalue formatCursor         -type str|null        -default "pointer"
    setdef options -barWidth                -validvalue {}                   -type str|num|null    -default "nothing"
    setdef options -barMaxWidth             -validvalue {}                   -type str|num|null    -default "nothing"
    setdef options -barMinWidth             -validvalue {}                   -type str|num|null    -default "null"
    setdef options -barMinHeight            -validvalue {}                   -type num|null        -default "nothing"
    setdef options -barMinAngle             -validvalue {}                   -type num|null        -default "nothing"
    setdef options -barGap                  -validvalue formatBarGap         -type str|null        -default "nothing"
    setdef options -barCategoryGap          -validvalue formatBarCategoryGap -type str|null        -default "20%"
    setdef options -large                   -validvalue {}                   -type bool            -default "False"
    setdef options -largeThreshold          -validvalue {}                   -type num             -default 400
    setdef options -progressive             -validvalue {}                   -type num|null        -default "nothing"
    setdef options -progressiveThreshold    -validvalue {}                   -type num|null        -default "nothing"
    setdef options -progressiveChunkMode    -validvalue formatPChunkMode     -type str|null        -default "nothing"
    setdef options -data                    -validvalue {}                   -type list.d          -default {}
    setdef options -markLine                -validvalue {}                   -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markPoint               -validvalue {}                   -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -zlevel                  -validvalue {}                   -type num             -default 0
    setdef options -z                       -validvalue {}                   -type num             -default 2
    setdef options -silent                  -validvalue {}                   -type bool            -default "False"
    setdef options -animation               -validvalue {}                   -type bool|null       -default "nothing"
    setdef options -animationThreshold      -validvalue {}                   -type num|null        -default "nothing"
    setdef options -animationDuration       -validvalue {}                   -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing        -type str|null        -default "nothing"
    setdef options -animationDelay          -validvalue {}                   -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                   -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing        -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                   -type num|jsfunc|null -default "nothing"
    setdef options -tooltip                 -validvalue {}                   -type dict|null       -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -databaritem]} {
            error "'chart' Class cannot contain '-data' or '-databaritem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -validvalue {} -type list.d|null      -default "nothing"
        setdef options  -seriesLayoutBy -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options  -encode         -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options  -datasetIndex   -validvalue {}                 -type num|null         -default "nothing"

    }
      
    if {[dict exists $value -databaritem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-databaritem'..."
        }
        setdef options -data -validvalue {} -type list.o -default [ticklecharts::BarItem $value]
    }
    
    set value [dict remove $value -label -endLabel \
                                  -labelLine -lineStyle \
                                  -areaStyle -markPoint -markLine \
                                  -labelLayout -itemStyle -backgroundStyle \
                                  -emphasis -blur -select -tooltip -encode -databaritem]
                                
    set options [merge $options $value]

    return $options

}

proc ticklecharts::lineseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-line
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::lineseries below.
    #
    # return dict barseries options

    setdef options -type                    -validvalue {}                  -type str             -default "line"
    setdef options -id                      -validvalue {}                  -type str|null        -default "nothing"
    setdef options -name                    -validvalue {}                  -type str             -default "lineseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy       -type str             -default "series"
    setdef options -coordinateSystem        -validvalue formatCSYS          -type str             -default "cartesian2d"
    setdef options -xAxisIndex              -validvalue {}                  -type num|null        -default "nothing"
    setdef options -yAxisIndex              -validvalue {}                  -type num|null        -default "nothing"
    setdef options -polarIndex              -validvalue {}                  -type num|null        -default "nothing"
    setdef options -symbol                  -validvalue formatItemSymbol    -type str|jsfunc|null -default [EchartsOptsTheme symbol]
    setdef options -symbolSize              -validvalue {}                  -type num|list.n      -default [EchartsOptsTheme symbolSize]
    setdef options -symbolRotate            -validvalue {}                  -type num|null        -default "nothing"
    setdef options -symbolKeepAspect        -validvalue {}                  -type bool            -default "True"
    setdef options -symbolOffset            -validvalue {}                  -type list.d|null     -default "nothing"
    setdef options -showSymbol              -validvalue {}                  -type bool            -default "True"
    setdef options -showAllSymbol           -validvalue formatShowAllSymbol -type bool|str        -default "auto"
    setdef options -legendHoverLink         -validvalue {}                  -type bool            -default "True"
    setdef options -stack                   -validvalue {}                  -type str|null        -default "nothing"
    setdef options -cursor                  -validvalue formatCursor        -type str|null        -default "pointer"
    setdef options -connectNulls            -validvalue {}                  -type bool            -default "False"
    setdef options -clip                    -validvalue {}                  -type bool            -default "True"
    setdef options -triggerLineEvent        -validvalue {}                  -type bool            -default "False"
    setdef options -step                    -validvalue formatStep          -type bool|str        -default "False"
    setdef options -label                   -validvalue {}                  -type dict|null       -default [ticklecharts::label $value]
    setdef options -endLabel                -validvalue {}                  -type dict|null       -default [ticklecharts::endLabel $value]
    setdef options -labelLine               -validvalue {}                  -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -validvalue {}                  -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -validvalue {}                  -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -lineStyle               -validvalue {}                  -type dict|null       -default [ticklecharts::lineStyle $value]
    setdef options -areaStyle               -validvalue {}                  -type dict|null       -default [ticklecharts::areaStyle $value]
    setdef options -emphasis                -validvalue {}                  -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                  -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                  -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode  -type bool|str|null   -default "nothing"
    setdef options -smooth                  -validvalue {}                  -type bool|num        -default [EchartsOptsTheme lineSmooth]
    setdef options -smoothMonotone          -validvalue formatSMonotone     -type str|null        -default "nothing"
    setdef options -sampling                -validvalue formatSampling      -type str|null        -default "nothing"
    setdef options -data                    -validvalue {}                  -type list.d          -default {}
    setdef options -markPoint               -validvalue {}                  -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -validvalue {}                  -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -validvalue {}                  -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -validvalue {}                  -type num             -default 0
    setdef options -z                       -validvalue {}                  -type num             -default 2
    setdef options -silent                  -validvalue {}                  -type bool            -default "False"
    setdef options -animation               -validvalue {}                  -type bool|null       -default "nothing"
    setdef options -animationThreshold      -validvalue {}                  -type num|null        -default "nothing"
    setdef options -animationDuration       -validvalue {}                  -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing       -type str|null        -default "nothing"
    setdef options -animationDelay          -validvalue {}                  -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                  -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing       -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                  -type num|jsfunc|null -default "nothing"
    setdef options -tooltip                 -validvalue {}                  -type dict|null       -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"
    
    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -datalineitem]} {
            error "'chart' Class cannot contain '-data' or '-datalineitem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class...
        # setdef options -dimensions    -validvalue {} -type list.d|null      -default "nothing"
        setdef options   -seriesLayoutBy -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options   -encode         -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -validvalue {}                 -type num|null         -default "nothing"

    }
    
    if {[dict exists $value -datalineitem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-datalineitem'..."
        }
        setdef options -data -validvalue {} -type list.o -default [ticklecharts::LineItem $value]
    }
    
    set value [dict remove $value -label -endLabel \
                                  -labelLine -lineStyle \
                                  -areaStyle -markPoint -markLine -markArea \
                                  -labelLayout -itemStyle\
                                  -emphasis -blur -select -tooltip -encode -datalineitem]
                                
    set options [merge $options $value]

    return $options

}

proc ticklecharts::pieseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-pie
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::pieseries below.
    #
    # return dict pieseries options

    setdef options -type                    -validvalue {}                 -type str             -default "pie"
    setdef options -id                      -validvalue {}                 -type str|null        -default "nothing"
    setdef options -name                    -validvalue {}                 -type str             -default "pieseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy      -type str             -default "data"
    setdef options -legendHoverLink         -validvalue {}                 -type bool            -default "True"
    setdef options -selectedMode            -validvalue formatSelectedMode -type bool|str|null   -default "nothing"
    setdef options -selectedOffset          -validvalue {}                 -type num             -default 10
    setdef options -clockwise               -validvalue {}                 -type bool            -default "True"
    setdef options -startAngle              -validvalue formatStartangle   -type num             -default 90
    setdef options -minAngle                -validvalue {}                 -type num             -default 0
    setdef options -minShowLabelAngle       -validvalue {}                 -type num             -default 0
    setdef options -roseType                -validvalue formatRoseType     -type bool|str        -default "False"
    setdef options -avoidLabelOverlap       -validvalue {}                 -type bool            -default "True"
    setdef options -stillShowZeroSum        -validvalue {}                 -type bool            -default "True"
    setdef options -cursor                  -validvalue formatCursor       -type str|null        -default "pointer"
    setdef options -zlevel                  -validvalue {}                 -type num             -default 0
    setdef options -z                       -validvalue {}                 -type num             -default 2
    setdef options -left                    -validvalue formatLeft         -type num|str         -default 0
    setdef options -top                     -validvalue formatTop          -type num|str         -default 0
    setdef options -right                   -validvalue formatRight        -type num|str         -default 0
    setdef options -bottom                  -validvalue formatBottom       -type num|str         -default 0
    setdef options -width                   -validvalue {}                 -type num|str         -default "auto"
    setdef options -height                  -validvalue {}                 -type num|str         -default "auto"
    setdef options -showEmptyCircle         -validvalue {}                 -type bool            -default "True"
    setdef options -emptyCircleStyle        -validvalue {}                 -type dict|null       -default [ticklecharts::emptyCircleStyle $value]
    setdef options -label                   -validvalue {}                 -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -validvalue {}                 -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -validvalue {}                 -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -validvalue {}                 -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -validvalue {}                 -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                 -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                 -type dict|null       -default [ticklecharts::select $value]
    setdef options -center                  -validvalue {}                 -type list.d          -default [list {"50%" "50%"}]
    setdef options -radius                  -validvalue {}                 -type list.d|num|str  -default [list {0 "75%"}]
    setdef options -markPoint               -validvalue {}                 -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -validvalue {}                 -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -validvalue {}                 -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -silent                  -validvalue {}                 -type bool            -default "False"
    setdef options -animationType           -validvalue formatAType        -type str|null        -default "expansion"
    setdef options -animationTypeUpdate     -validvalue formatATypeUpdate  -type str|null        -default "transition"
    setdef options -animation               -validvalue {}                 -type bool|null       -default "True"
    setdef options -animationThreshold      -validvalue {}                 -type num|null        -default "nothing"
    setdef options -animationDuration       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelay          -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -validvalue {}                 -type dict|null       -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -validvalue {}                 -type dict|null       -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -datapieitem]} {
            error "'chart' Class cannot contain '-datapieitem' when a class dataset is present"
        }

        # set dimensions in dataset class...
        # setdef options -dimensions    -validvalue {} -type list.d|null  -default "nothing"
        setdef options   -seriesLayoutBy -validvalue formatSeriesLayout -type str|null     -default "nothing"
        setdef options   -encode         -validvalue {}                 -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -validvalue {}                 -type num|null     -default "nothing"

    } else {
        # set data options when dataset class doesn't exist...
        setdef options   -data          -validvalue {} -type list.o       -default [ticklecharts::PieItem $value]
    }

    set value [dict remove $value -label \
                                  -labelLine \
                                  -markPoint \
                                  -datapieitem \
                                  -markLine -markArea \
                                  -emptyCircleStyle \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -universalTransition -tooltip -encode]
    

    set options [merge $options $value]

    return $options

}

proc ticklecharts::funnelseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-funnel
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::funnelseries below.
    #
    # return dict funnelseries options

    setdef options -type                    -validvalue {}                 -type str             -default "funnel"
    setdef options -id                      -validvalue {}                 -type str|null        -default "nothing"
    setdef options -name                    -validvalue {}                 -type str             -default "funnelseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy      -type str             -default "data"
    setdef options -min                     -validvalue {}                 -type num|null        -default "nothing"
    setdef options -max                     -validvalue {}                 -type num|null        -default "nothing"
    setdef options -minSize                 -validvalue {}                 -type str|num|null    -default "0%"
    setdef options -maxSize                 -validvalue {}                 -type str|num|null    -default "100%"
    setdef options -orient                  -validvalue formatOrient       -type str             -default "vertical"
    setdef options -sort                    -validvalue formatSort         -type str|jsfunc      -default "descending"
    setdef options -gap                     -validvalue {}                 -type num             -default 0
    setdef options -legendHoverLink         -validvalue {}                 -type bool            -default "True"
    setdef options -funnelAlign             -validvalue formatFunnelAlign  -type str             -default "center"
    setdef options -label                   -validvalue {}                 -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -validvalue {}                 -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -validvalue {}                 -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -validvalue {}                 -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -validvalue {}                 -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                 -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                 -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode -type bool|str|null   -default "True"
    setdef options -zlevel                  -validvalue {}                 -type num             -default 0
    setdef options -z                       -validvalue {}                 -type num             -default 2
    setdef options -left                    -validvalue formatLeft         -type num|str         -default 0
    setdef options -top                     -validvalue formatTop          -type num|str         -default 0
    setdef options -right                   -validvalue formatRight        -type num|str         -default 0
    setdef options -bottom                  -validvalue formatBottom       -type num|str         -default 0
    setdef options -width                   -validvalue {}                 -type num|str         -default "auto"
    setdef options -height                  -validvalue {}                 -type num|str         -default "auto"
    setdef options -data                    -validvalue {}                 -type list.o          -default [ticklecharts::FunnelItem $value]
    setdef options -markPoint               -validvalue {}                 -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -validvalue {}                 -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -validvalue {}                 -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -silent                  -validvalue {}                 -type bool            -default "False"
    setdef options -animationType           -validvalue formatAType        -type str|null        -default "expansion"
    setdef options -animationTypeUpdate     -validvalue formatATypeUpdate  -type str|null        -default "transition"
    setdef options -animation               -validvalue {}                 -type bool|null       -default "True"
    setdef options -animationThreshold      -validvalue {}                 -type num|null        -default "nothing"
    setdef options -animationDuration       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelay          -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -validvalue formatAEasing      -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -validvalue {}                 -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -validvalue {}                 -type dict|null       -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -validvalue {}                 -type dict|null       -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -datafunnelitem]} {
            error "'chart' Class cannot contain '-data' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -validvalue {} -type list.d|null      -default "nothing"
        setdef options   -seriesLayoutBy -validvalue formatSeriesLayout -type str|null     -default "nothing"
        setdef options   -encode         -validvalue {}                 -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -validvalue {}                 -type num|null     -default "nothing"

    }

    set value [dict remove $value -label \
                                  -labelLine \
                                  -datafunnelitem \
                                  -markPoint \
                                  -markLine -markArea \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -universalTransition -encode -tooltip]
    

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

    setdef options -type                    -validvalue {}                 -type str             -default "radar"
    setdef options -id                      -validvalue {}                 -type str|null        -default "nothing"
    setdef options -name                    -validvalue {}                 -type str             -default "radarseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy      -type str             -default "data"
    setdef options -radarIndex              -validvalue {}                 -type num|null        -default 0
    setdef options -symbol                  -validvalue formatItemSymbol   -type str|jsfunc|null -default "circle"
    setdef options -symbolSize              -validvalue {}                 -type num|list.n      -default 8
    setdef options -symbolRotate            -validvalue {}                 -type num|null        -default "nothing"
    setdef options -symbolKeepAspect        -validvalue {}                 -type bool            -default "True"
    setdef options -symbolOffset            -validvalue {}                 -type list.d|null     -default "nothing"
    setdef options -label                   -validvalue {}                 -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLayout             -validvalue {}                 -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -validvalue {}                 -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -lineStyle               -validvalue {}                 -type dict|null       -default [ticklecharts::lineStyle $value]
    setdef options -areaStyle               -validvalue {}                 -type dict|null       -default [ticklecharts::areaStyle $value]
    setdef options -emphasis                -validvalue {}                 -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                 -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                 -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode -type bool|str|null   -default "nothing"
    setdef options -data                    -validvalue {}                 -type list.o          -default [ticklecharts::RadarItem $value]
    setdef options -zlevel                  -validvalue {}                 -type num             -default 0
    setdef options -z                       -validvalue {}                 -type num             -default 2
    setdef options -silent                  -validvalue {}                 -type bool            -default "False"
    setdef options -animation               -validvalue {}                 -type bool|null       -default "nothing"
    setdef options -animationThreshold      -validvalue {}                 -type num|null        -default "nothing"
    setdef options -animationDuration       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelay          -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -validvalue {}                 -type dict|null       -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -validvalue {}                 -type dict|null       -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    set value [dict remove $value -label \
                                  -lineStyle \
                                  -dataradaritem \
                                  -areaStyle \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -universalTransition -tooltip]
                                
    set options [merge $options $value]

    return $options

}

proc ticklecharts::scatterseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-scatter
    # or
    # options : https://echarts.apache.org/en/option.html#series-effectScatter
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::scatterseries below.
    #
    # return dict scatterseries or effectScatterseries options

    setdef options -type                    -validvalue {}                 -type str               -default "scatter"
    setdef options -id                      -validvalue {}                 -type str|null          -default "nothing"
    setdef options -name                    -validvalue {}                 -type str               -default "scatterseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy      -type str               -default "series"
    setdef options -coordinateSystem        -validvalue formatCSYS         -type str               -default "cartesian2d"
    setdef options -xAxisIndex              -validvalue {}                 -type num|null          -default "nothing"
    setdef options -yAxisIndex              -validvalue {}                 -type num|null          -default "nothing"
    setdef options -polarIndex              -validvalue {}                 -type num|null          -default "nothing"
    setdef options -geoIndex                -validvalue {}                 -type num|null          -default "nothing"
    setdef options -calendarIndex           -validvalue {}                 -type num|null          -default "nothing"
    setdef options -legendHoverLink         -validvalue {}                 -type bool              -default "True"
    setdef options -symbol                  -validvalue formatItemSymbol   -type str|jsfunc|null   -default "circle"
    setdef options -symbolSize              -validvalue {}                 -type num|jsfunc|list.n -default 10
    setdef options -symbolRotate            -validvalue {}                 -type num|null          -default "nothing"
    setdef options -symbolKeepAspect        -validvalue {}                 -type bool              -default "True"
    setdef options -symbolOffset            -validvalue {}                 -type list.d|null       -default "nothing"    
    setdef options -large                   -validvalue {}                 -type bool              -default "False"
    setdef options -largeThreshold          -validvalue {}                 -type num               -default 2000    
    setdef options -cursor                  -validvalue formatCursor       -type str|null          -default "pointer"    
    setdef options -label                   -validvalue {}                 -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLine               -validvalue {}                 -type dict|null         -default [ticklecharts::labelLine $value]    
    setdef options -labelLayout             -validvalue {}                 -type dict|jsfunc|null  -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -validvalue {}                 -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -validvalue {}                 -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                 -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                 -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode -type bool|str|null     -default "nothing"
    setdef options -progressive             -validvalue {}                 -type num|null          -default "nothing"
    setdef options -progressiveThreshold    -validvalue {}                 -type num|null          -default "nothing"
    setdef options -data                    -validvalue {}                 -type list.d            -default {}    
    setdef options -markLine                -validvalue {}                 -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markPoint               -validvalue {}                 -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markArea                -validvalue {}                 -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -clip                    -validvalue {}                 -type bool              -default "True"
    setdef options -zlevel                  -validvalue {}                 -type num               -default 0
    setdef options -z                       -validvalue {}                 -type num               -default 2
    setdef options -silent                  -validvalue {}                 -type bool              -default "False"
    setdef options -animation               -validvalue {}                 -type bool|null         -default "nothing"
    setdef options -animationThreshold      -validvalue {}                 -type num|null          -default "nothing"
    setdef options -animationDuration       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing      -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing      -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -validvalue {}                 -type dict|null         -default [ticklecharts::tooltip $value]
        
    if {[dict exists $value -type]} {
        switch -exact -- [dict get $value -type] {
            effectScatter {
                setdef options -effectType   -validvalue {} -type str       -default "ripple"
                setdef options -showEffectOn -validvalue {} -type str       -default "render"
                setdef options -rippleEffect -validvalue {} -type dict|null -default [ticklecharts::rippleEffect $value]
            }
        }
    }        
    
    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data]} {
            error "'chart' Class cannot contain '-data' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class...
        # setdef options -dimensions    -validvalue {} -type list.d|null      -default "nothing"
        setdef options   -datasetId      -validvalue {}                 -type str|null     -default "nothing"
        setdef options   -seriesLayoutBy -validvalue formatSeriesLayout -type str|null     -default "nothing"
        setdef options   -encode         -validvalue {}                 -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -validvalue {}                 -type num|null     -default "nothing"

    }
    
    set lflag {-label -labelLine -lineStyle
               -markPoint -markLine \
               -labelLayout -itemStyle -markArea 
               -emphasis -blur -select -tooltip -rippleEffect -encode}
    
    # does not remove '-labelLayout' for js function.
    if {[dict exists $value -labelLayout] && [Type [dict get $value -labelLayout]] eq "jsfunc"} {
        set lflag [lsearch -inline -all -not -exact $lflag "-labelLayout"]
        set value [dict remove $value {*}$lflag]
    } else {
        set value [dict remove $value {*}$lflag]
    }
        
    set options [merge $options $value]

    return $options

}

proc ticklecharts::heatmapseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-heatmap
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::heatmapseries below.
    #
    # return dict heatmapseries options

    setdef options -type                 -validvalue {}                 -type str              -default "heatmap"
    setdef options -id                   -validvalue {}                 -type str|null         -default "nothing"
    setdef options -name                 -validvalue {}                 -type str              -default "heatmapseries_${index}"
    setdef options -coordinateSystem     -validvalue formatCSYS         -type str              -default "cartesian2d"
    setdef options -xAxisIndex           -validvalue {}                 -type num|null         -default "nothing"
    setdef options -yAxisIndex           -validvalue {}                 -type num|null         -default "nothing"
    setdef options -geoIndex             -validvalue {}                 -type num|null         -default "nothing"
    setdef options -calendarIndex        -validvalue {}                 -type num|null         -default "nothing"
    setdef options -pointSize            -validvalue {}                 -type num              -default 20
    setdef options -blurSize             -validvalue {}                 -type num              -default 20
    setdef options -minOpacity           -validvalue {}                 -type num|null         -default "nothing"
    setdef options -maxOpacity           -validvalue {}                 -type num|null         -default "nothing"
    setdef options -progressive          -validvalue {}                 -type num|null         -default 400
    setdef options -progressiveThreshold -validvalue {}                 -type num|null         -default 3000
    setdef options -label                -validvalue {}                 -type dict|null        -default [ticklecharts::label $value]
    setdef options -labelLine            -validvalue {}                 -type dict|null        -default [ticklecharts::labelLine $value]    
    setdef options -labelLayout          -validvalue {}                 -type dict|jsfunc|null -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle            -validvalue {}                 -type dict|null        -default [ticklecharts::itemStyle $value]
    setdef options -emphasis             -validvalue {}                 -type dict|null        -default [ticklecharts::emphasis $value]
    setdef options -universalTransition  -validvalue {}                 -type dict|null        -default [ticklecharts::universalTransition $value]
    setdef options -blur                 -validvalue {}                 -type dict|null        -default [ticklecharts::blur $value]
    setdef options -select               -validvalue {}                 -type dict|null        -default [ticklecharts::select $value]
    setdef options -selectedMode         -validvalue formatSelectedMode -type bool|str|null    -default "nothing"
    setdef options -data                 -validvalue {}                 -type list.d           -default {}    
    setdef options -markLine             -validvalue {}                 -type dict|null        -default [ticklecharts::markLine $value]
    setdef options -markPoint            -validvalue {}                 -type dict|null        -default [ticklecharts::markPoint $value]
    setdef options -markArea             -validvalue {}                 -type dict|null        -default [ticklecharts::markArea $value]
    setdef options -zlevel               -validvalue {}                 -type num              -default 0
    setdef options -z                    -validvalue {}                 -type num              -default 2
    setdef options -silent               -validvalue {}                 -type bool             -default "False"
    setdef options -tooltip              -validvalue {}                 -type dict|null        -default [ticklecharts::tooltip $value]
        
    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data]} {
            error "'chart' Class cannot contain '-data' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -validvalue {} -type list.d|null      -default "nothing"
        setdef options   -seriesLayoutBy -validvalue formatSeriesLayout -type str|null     -default "nothing"
        setdef options   -encode         -validvalue {}                 -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -validvalue {}                 -type num|null     -default "nothing"

    }
    
    set value [dict remove $value -label \
                                  -labelLine \
                                  -labelLayout -itemStyle -markLine -markPoint -markArea \
                                  -emphasis -blur -select -universalTransition -encode -tooltip]
        
    set options [merge $options $value]

    return $options

}

proc ticklecharts::sunburstseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-sunburst
    #
    # index - index series.
    # value - Options described in proc ticklecharts::sunburstseries below.
    #
    # return dict sunburstseries options

    setdef options -type                    -validvalue {}                 -type str             -default "sunburst"
    setdef options -id                      -validvalue {}                 -type str|null        -default "nothing"
    setdef options -name                    -validvalue {}                 -type str             -default "sunburstseries_${index}"
    setdef options -zlevel                  -validvalue {}                 -type num             -default 0
    setdef options -z                       -validvalue {}                 -type num             -default 2
    setdef options -center                  -validvalue {}                 -type list.d          -default [list {"50%" "50%"}]
    setdef options -radius                  -validvalue {}                 -type list.d|num|str  -default [list {0 "75%"}]
    setdef options -data                    -validvalue {}                 -type list.o          -default [ticklecharts::sunburstItem $value]
    setdef options -labelLayout             -validvalue {}                 -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -label                   -validvalue {}                 -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -validvalue {}                 -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -itemStyle               -validvalue {}                 -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -nodeClick               -validvalue formatNodeClick    -type bool|str        -default "rootToNode"
    setdef options -sort                    -validvalue formatSort         -type str|jsfunc|null -default "desc"
    setdef options -renderLabelForZeroData  -validvalue {}                 -type bool|null       -default "nothing"
    setdef options -emphasis                -validvalue {}                 -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                 -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                 -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode -type bool|str|null   -default "nothing"
    setdef options -levels                  -validvalue {}                 -type list.o|null     -default [ticklecharts::levelsItem $value]
    setdef options -animation               -validvalue {}                 -type bool|null       -default "True"
    setdef options -animationThreshold      -validvalue {}                 -type num|null        -default "nothing"
    setdef options -animationDuration       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelay          -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                 -type num|jsfunc|null -default "nothing"


    if {![dict exists $value -data]} {
        error "key -data not present..."
    }

    set value [dict remove $value -label \
                                  -data \
                                  -levels \
                                  -labelLine \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select]
    

    set options [merge $options $value]

    return $options

}

proc ticklecharts::treeseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-tree
    #
    # index - index series.
    # value - Options described in proc ticklecharts::treeseries below.
    #
    # return dict treeseries options

    setdef options -type                    -validvalue {}                  -type str               -default "tree"
    setdef options -id                      -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -validvalue {}                  -type str               -default "treeseries_${index}"
    setdef options -zlevel                  -validvalue {}                  -type num               -default 0
    setdef options -z                       -validvalue {}                  -type num               -default 2
    setdef options -left                    -validvalue formatLeft          -type num|str           -default 0
    setdef options -top                     -validvalue formatTop           -type num|str           -default 0
    setdef options -right                   -validvalue formatRight         -type num|str           -default 0
    setdef options -bottom                  -validvalue formatBottom        -type num|str           -default 0
    setdef options -width                   -validvalue {}                  -type num|str           -default "auto"
    setdef options -height                  -validvalue {}                  -type num|str           -default "auto"
    setdef options -layout                  -validvalue formatLayout        -type str               -default "orthogonal"
    setdef options -orient                  -validvalue formatTreeOrient    -type str               -default "LR"
    setdef options -symbol                  -validvalue formatItemSymbol    -type str|jsfunc|null   -default [EchartsOptsTheme symbol]
    setdef options -symbolSize              -validvalue {}                  -type num|list.n|jsfunc -default [EchartsOptsTheme symbolSize]
    setdef options -symbolRotate            -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -symbolKeepAspect        -validvalue {}                  -type bool              -default "True"
    setdef options -symbolOffset            -validvalue {}                  -type list.d|null       -default "nothing"
    setdef options -edgeShape               -validvalue formatEdgeShape     -type str               -default "curve"
    setdef options -edgeForkPosition        -validvalue formatEForkPosition -type str|null          -default "50%"
    setdef options -roam                    -validvalue formatRoam          -type str|bool          -default "False"
    setdef options -expandAndCollapse       -validvalue {}                  -type bool              -default "True"
    setdef options -initialTreeDepth        -validvalue {}                  -type num               -default 2
    setdef options -itemStyle               -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -label                   -validvalue {}                  -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLayout             -validvalue {}                  -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -lineStyle               -validvalue {}                  -type dict|null         -default [ticklecharts::lineStyle $value]
    setdef options -emphasis                -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                  -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                  -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode  -type bool|str|null     -default "nothing"
    setdef options -leaves                  -validvalue {}                  -type dict|null         -default [ticklecharts::leaves $value]
    setdef options -data                    -validvalue {}                  -type list.o            -default [ticklecharts::treeItem $value]
    setdef options -animation               -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -animationThreshold      -validvalue {}                  -type num|null          -default "nothing"
    setdef options -animationDuration       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -validvalue {}                  -type dict|null         -default [ticklecharts::tooltip $value]

    if {![dict exists $value -data]} {
        error "key -data not present..."
    }

    set value [dict remove $value -label \
                                  -data \
                                  -lineStyle \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -leaves]
    

    set options [merge $options $value]

    return $options
 
}

proc ticklecharts::themeriverseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-themeRiver
    #
    # index - index series.
    # value - Options described in proc ticklecharts::themeriverseries below.
    #
    # return dict themeriverseries options

    setdef options -type                    -validvalue {}                  -type str               -default "themeRiver"
    setdef options -id                      -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -validvalue {}                  -type str               -default "themeriverseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy       -type str               -default "data"
    setdef options -zlevel                  -validvalue {}                  -type num               -default 0
    setdef options -z                       -validvalue {}                  -type num               -default 2
    setdef options -left                    -validvalue formatLeft          -type num|str|null      -default "nothing"
    setdef options -top                     -validvalue formatTop           -type num|str|null      -default "nothing"
    setdef options -right                   -validvalue formatRight         -type num|str|null      -default "nothing"
    setdef options -bottom                  -validvalue formatBottom        -type num|str|null      -default "nothing"
    setdef options -width                   -validvalue {}                  -type num|str|null      -default "nothing"
    setdef options -height                  -validvalue {}                  -type num|str|null      -default "nothing"
    # bug with coordinateSystem = single... 5.2.2
    setdef options -coordinateSystem        -validvalue formatCSYS          -type str|null          -default "nothing"
    setdef options -boundaryGap             -validvalue {}                  -type list.d            -default [list {"10%" "10%"}]
    setdef options -singleAxisIndex         -validvalue {}                  -type num               -default 0
    setdef options -label                   -validvalue {}                  -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLine               -validvalue {}                  -type dict|null         -default [ticklecharts::labelLine $value]
    setdef options -itemStyle               -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -labelLayout             -validvalue {}                  -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -emphasis                -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                  -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                  -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode  -type bool|str|null     -default "False"
    setdef options -data                    -validvalue {}                  -type list.d            -default [ticklecharts::themeriverItem $value]
    setdef options -tooltip                 -validvalue {}                  -type dict|null         -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -tooltip                -validvalue {} -type dict|null        -default [ticklecharts::tooltipseries $value]

    set value [dict remove $value -label \
                                  -data \
                                  -labelLine \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select]
    

    set options [merge $options $value]

    return $options

}

proc ticklecharts::sankeyseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-sankey
    #
    # index - index series.
    # value - Options described in proc ticklecharts::sankeyseries below.
    #
    # return dict sankeyseries options

    setdef options -type                    -validvalue {}                  -type str               -default "sankey"
    setdef options -id                      -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -validvalue {}                  -type str               -default "sankeyseries_${index}"
    setdef options -zlevel                  -validvalue {}                  -type num               -default 0
    setdef options -z                       -validvalue {}                  -type num               -default 2
    setdef options -left                    -validvalue formatLeft          -type num|str           -default "5%"
    setdef options -top                     -validvalue formatTop           -type num|str           -default "5%"
    setdef options -right                   -validvalue formatRight         -type num|str           -default "20%"
    setdef options -bottom                  -validvalue formatBottom        -type num|str           -default "5%"
    setdef options -width                   -validvalue {}                  -type num|str           -default "auto"
    setdef options -height                  -validvalue {}                  -type num|str           -default "auto"
    setdef options -nodeWidth               -validvalue {}                  -type num               -default 20
    setdef options -nodeGap                 -validvalue {}                  -type num               -default 8
    setdef options -nodeAlign               -validvalue formatNodeAlign     -type str               -default "justify"
    setdef options -layoutIterations        -validvalue {}                  -type num               -default 32
    setdef options -orient                  -validvalue formatOrient        -type str               -default "horizontal"
    setdef options -draggable               -validvalue {}                  -type bool              -default "True"
    setdef options -levels                  -validvalue {}                  -type list.o|null       -default [ticklecharts::levelsSankeyItem $value]
    setdef options -label                   -validvalue {}                  -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLayout             -validvalue {}                  -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -lineStyle               -validvalue {}                  -type dict|null         -default [ticklecharts::lineStyle $value]
    setdef options -itemStyle               -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                  -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                  -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode  -type bool|str|null     -default "nothing"
    setdef options -data                    -validvalue {}                  -type list.o            -default [ticklecharts::sankeyItem $value -data]
    setdef options -nodes                   -validvalue {}                  -type list.o|null       -default [ticklecharts::sankeyItem $value -nodes]
    setdef options -links                   -validvalue {}                  -type list.o|null       -default [ticklecharts::linksItem $value -links]
    setdef options -edges                   -validvalue {}                  -type list.o|null       -default [ticklecharts::linksItem $value -edges]
    setdef options -silent                  -validvalue {}                  -type bool              -default "False"
    setdef options -animation               -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -animationThreshold      -validvalue {}                  -type num|null          -default "nothing"
    setdef options -animationDuration       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -validvalue {}                  -type dict|null         -default [ticklecharts::tooltip $value]

    if {![dict exists $value -data] && ![dict exists $value -nodes]} {
        error "key -data or -nodes not present..."
    }

    set value [dict remove $value -levels \
                                  -label \
                                  -lineStyle \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -data -nodes -links -edges]
    

    set options [merge $options $value]

    return $options
 
}

proc ticklecharts::pictorialbarseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-pictorialBar
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::pictorialbarseries below.
    #
    # return dict pictorialbarseries options

    setdef options -type                    -validvalue {}                    -type str               -default "pictorialBar"
    setdef options -id                      -validvalue {}                    -type str|null          -default "nothing"
    setdef options -name                    -validvalue {}                    -type str               -default "pictorialbarseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy         -type str               -default "series"
    setdef options -legendHoverLink         -validvalue {}                    -type bool              -default "True"
    setdef options -coordinateSystem        -validvalue formatCSYS            -type str               -default "cartesian2d"
    setdef options -xAxisIndex              -validvalue {}                    -type num|null          -default "nothing"
    setdef options -yAxisIndex              -validvalue {}                    -type num|null          -default "nothing"
    setdef options -cursor                  -validvalue formatCursor          -type str|null          -default "pointer"
    setdef options -label                   -validvalue {}                    -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLine               -validvalue {}                    -type dict|null         -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -validvalue {}                    -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -validvalue {}                    -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -validvalue {}                    -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                    -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                    -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode    -type bool|str|null     -default "nothing"
    setdef options -barWidth                -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -barMaxWidth             -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -barMinWidth             -validvalue {}                    -type str|num|null      -default "null"
    setdef options -barMinHeight            -validvalue {}                    -type num|null          -default "nothing"
    setdef options -barMinAngle             -validvalue {}                    -type num|null          -default "nothing"
    setdef options -barGap                  -validvalue formatBarGap          -type str|null          -default "nothing"
    setdef options -barCategoryGap          -validvalue formatBarCategoryGap  -type str|null          -default "20%" 
    setdef options -symbol                  -validvalue formatItemSymbol      -type str|jsfunc|null   -default "nothing"
    setdef options -symbolSize              -validvalue {}                    -type num|list.d|null   -default "nothing"
    setdef options -symbolPosition          -validvalue formatSymbolPosition  -type str|null          -default "start"
    setdef options -symbolOffset            -validvalue {}                    -type list.d|null       -default "nothing"
    setdef options -symbolRotate            -validvalue {}                    -type num|null          -default "nothing"
    setdef options -symbolKeepAspect        -validvalue {}                    -type bool              -default "True"
    setdef options -symbolRepeat            -validvalue formatsymbolRepeat    -type bool|str|num|null -default "nothing"
    setdef options -symbolRepeatDirection   -validvalue formatsymbolRepeatDir -type str               -default "start"
    setdef options -symbolMargin            -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -symbolClip              -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -symbolBoundingData      -validvalue {}                    -type num|null          -default "nothing"
    setdef options -symbolPatternSize       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -hoverAnimation          -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -data                    -validvalue {}                    -type list.o            -default [ticklecharts::pictorialBarItem $value]
    setdef options -markPoint               -validvalue {}                    -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -validvalue {}                    -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -validvalue {}                    -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -validvalue {}                    -type num               -default 0
    setdef options -z                       -validvalue {}                    -type num               -default 2
    setdef options -silent                  -validvalue {}                    -type bool              -default "False"
    setdef options -animation               -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -animationThreshold      -validvalue {}                    -type num|null          -default "nothing"
    setdef options -animationDuration       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing         -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing         -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -validvalue {}                    -type dict|null         -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data]} {
            error "'chart' Class cannot contain '-data' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -validvalue {} -type list.d|null      -default "nothing"
        setdef options  -seriesLayoutBy -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options  -encode         -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]

    }
          
    set value [dict remove $value -label \
                                  -labelLine -lineStyle \
                                  -markPoint -markLine -markArea \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -tooltip -encode -data]
                                
    set options [merge $options $value]

    return $options

}

proc ticklecharts::candlestickseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-candlesticks
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::candlestickseries below.
    #
    # return dict candlestickseries options

    setdef options -type                    -validvalue {}                    -type str               -default "candlestick"
    setdef options -id                      -validvalue {}                    -type str|null          -default "nothing"
    setdef options -name                    -validvalue {}                    -type str               -default "candlestickseries_${index}"
    setdef options -coordinateSystem        -validvalue formatCSYS            -type str               -default "cartesian2d"
    setdef options -xAxisIndex              -validvalue {}                    -type num|null          -default "nothing"
    setdef options -yAxisIndex              -validvalue {}                    -type num|null          -default "nothing"
    setdef options -colorBy                 -validvalue formatColorBy         -type str               -default "series"
    setdef options -legendHoverLink         -validvalue {}                    -type bool              -default "True"
    setdef options -hoverAnimation          -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -layout                  -validvalue formatOrient          -type str|null          -default "nothing"
    setdef options -barWidth                -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -barMaxWidth             -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -barMinWidth             -validvalue {}                    -type str|num|null      -default "null"
    setdef options -itemStyle               -validvalue {}                    -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -validvalue {}                    -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                    -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                    -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode    -type bool|str|null     -default "nothing"
    setdef options -large                   -validvalue {}                    -type bool              -default "False"
    setdef options -largeThreshold          -validvalue {}                    -type num               -default 400
    setdef options -progressive             -validvalue {}                    -type num|null          -default "nothing"
    setdef options -progressiveThreshold    -validvalue {}                    -type num|null          -default "nothing"
    setdef options -progressiveChunkMode    -validvalue formatPChunkMode      -type str|null          -default "nothing"
    setdef options -data                    -validvalue {}                    -type list.d            -default {}
    setdef options -markPoint               -validvalue {}                    -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -validvalue {}                    -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -validvalue {}                    -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -clip                    -validvalue {}                    -type bool              -default "True"
    setdef options -zlevel                  -validvalue {}                    -type num               -default 0
    setdef options -z                       -validvalue {}                    -type num               -default 2
    setdef options -silent                  -validvalue {}                    -type bool              -default "False"
    setdef options -animationDuration       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing         -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -validvalue {}                    -type dict|null         -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -datacandlestickitem]} {
            error "'chart' Class cannot contain '-data' or 'datacandlestickitem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -validvalue {} -type list.d|null      -default "nothing"
        setdef options  -encode         -validvalue {} -type dict|null        -default [ticklecharts::encode $chart $value]

    }

    # not supported
    if {[dict exists $value -datacandlestickitem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-datacandlestickitem'..."
        }
        # setdef options -data -validvalue {} -type list.o -default [ticklecharts::candlestickItem $value]
    }
          
    set value [dict remove $value -markPoint -markLine -markArea \
                                  -labelLayout -itemStyle \
                                  -emphasis -blur -select -tooltip -encode]
                                
    set options [merge $options $value]

    return $options

}

proc ticklecharts::parallelseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-parallel
    #
    # index - index series.
    # value - Options described in proc ticklecharts::parallelseries below.
    #
    # return dict parallelseries options

    setdef options -type                    -validvalue {}                  -type str               -default "parallel"
    setdef options -id                      -validvalue {}                  -type str|null          -default "nothing"
    setdef options -coordinateSystem        -validvalue formatCSYS          -type str               -default "parallel"
    setdef options -name                    -validvalue {}                  -type str               -default "parallelseries_${index}"
    setdef options -parallelIndex           -validvalue {}                  -type num               -default 0
    setdef options -colorBy                 -validvalue formatColorBy       -type str               -default "series"
    setdef options -lineStyle               -validvalue {}                  -type dict|null         -default [ticklecharts::lineStyle $value]
    setdef options -emphasis                -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -inactiveOpacity         -validvalue {}                  -type num               -default 0.05
    setdef options -activeOpacity           -validvalue {}                  -type num               -default 1
    setdef options -realtime                -validvalue {}                  -type bool              -default "True"
    setdef options -smooth                  -validvalue {}                  -type bool|num|null     -default "nothing"
    setdef options -progressive             -validvalue {}                  -type num               -default 500
    setdef options -progressiveThreshold    -validvalue {}                  -type num|null          -default "nothing"
    setdef options -progressiveChunkMode    -validvalue formatPChunkMode    -type str|null          -default "nothing"
    setdef options -data                    -validvalue {}                  -type list.d            -default {}
    setdef options -zlevel                  -validvalue {}                  -type num               -default 0
    setdef options -z                       -validvalue {}                  -type num               -default 2
    setdef options -silent                  -validvalue {}                  -type bool              -default "False"
    setdef options -animation               -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -animationThreshold      -validvalue {}                  -type num|null          -default "nothing"
    setdef options -animationDuration       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                  -type num|jsfunc|null   -default "nothing"

    if {[dict exists $value -dataParallelItem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-dataParallelItem'..."
        }
        setdef options -data -validvalue {} -type list.o -default [ticklecharts::ParallelItem $value]
    }

    set value [dict remove $value -lineStyle -emphasis]
    
    set options [merge $options $value]

    return $options
 
}

proc ticklecharts::gaugeseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-gauge
    #
    # index - index series.
    # value - Options described in proc ticklecharts::gaugeseries below.
    #
    # return dict gaugeseries options

    setdef options -type                    -validvalue {}                  -type str               -default "gauge"
    setdef options -id                      -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -validvalue {}                  -type str               -default "gauge_${index}"
    setdef options -colorBy                 -validvalue formatColorBy       -type str               -default "data"
    setdef options -zlevel                  -validvalue {}                  -type num               -default 0
    setdef options -z                       -validvalue {}                  -type num               -default 2
    setdef options -center                  -validvalue {}                  -type list.d            -default [list {"50%" "50%"}]
    setdef options -radius                  -validvalue {}                  -type str|num           -default "75%"
    setdef options -legendHoverLink         -validvalue {}                  -type bool              -default "True"
    setdef options -startAngle              -validvalue formatStartangle    -type num               -default 225
    setdef options -endAngle                -validvalue formatEndangle      -type num               -default -45
    setdef options -clockwise               -validvalue {}                  -type bool              -default "True"
    setdef options -data                    -validvalue {}                  -type list.n            -default {}
    setdef options -min                     -validvalue {}                  -type num|null          -default "nothing"
    setdef options -max                     -validvalue {}                  -type num|null          -default "nothing"
    setdef options -splitNumber             -validvalue {}                  -type num               -default 10
    setdef options -axisLine                -validvalue {}                  -type dict|null         -default [ticklecharts::axisLine $value]
    setdef options -progress                -validvalue {}                  -type dict|null         -default [ticklecharts::progress $value]
    setdef options -splitLine               -validvalue {}                  -type dict|null         -default [ticklecharts::splitLine $value]
    setdef options -axisTick                -validvalue {}                  -type dict|null         -default [ticklecharts::axisTick $value]
    setdef options -axisLabel               -validvalue {}                  -type dict|null         -default [ticklecharts::axisLabel $value]
    setdef options -pointer                 -validvalue {}                  -type dict|null         -default [ticklecharts::pointer $value]
    setdef options -anchor                  -validvalue {}                  -type dict|null         -default [ticklecharts::anchor $value]
    setdef options -itemStyle               -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -title                   -validvalue {}                  -type dict|null         -default [ticklecharts::titleGauge $value]
    setdef options -detail                  -validvalue {}                  -type dict|null         -default [ticklecharts::detail $value]
    setdef options -markPoint               -validvalue {}                  -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -validvalue {}                  -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -validvalue {}                  -type dict|null         -default [ticklecharts::markArea $value]    
    setdef options -silent                  -validvalue {}                  -type bool              -default "False"
    setdef options -animation               -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -animationThreshold      -validvalue {}                  -type num|null          -default "nothing"
    setdef options -animationDuration       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                  -type num|jsfunc|null   -default "nothing"

    if {[dict exists $value -dataGaugeItem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-dataGaugeItem'..."
        }
        setdef options -data -validvalue {} -type list.o -default [ticklecharts::gaugeItem $value]
    }

    set value [dict remove $value -axisLine -progress -splitLine -axisTick \
                                  -axisLabel -pointer -anchor -itemStyle \
                                  -emphasis -title -detail -markPoint -markLine -markArea]
    
    set options [merge $options $value]

    return $options
 
}

proc ticklecharts::graphseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-graph
    #
    # index - index series.
    # value - Options described in proc ticklecharts::graphseries below.
    #
    # return dict graphseries options

    lassign [split $::ticklecharts::echarts_version "."] major minor patch

    setdef options -type                    -validvalue {}                 -type str               -default "graph"
    setdef options -id                      -validvalue {}                 -type str|null          -default "nothing"
    setdef options -name                    -validvalue {}                 -type str               -default "graphseries_${index}"
    setdef options -legendHoverLink         -validvalue {}                 -type bool              -default "True"
    setdef options -coordinateSystem        -validvalue formatCSYS         -type str|null          -default "null"
    setdef options -xAxisIndex              -validvalue {}                 -type num|null          -default "nothing"
    setdef options -yAxisIndex              -validvalue {}                 -type num|null          -default "nothing"
    setdef options -polarIndex              -validvalue {}                 -type num|null          -default "nothing"
    setdef options -geoIndex                -validvalue {}                 -type num|null          -default "nothing"
    setdef options -calendarIndex           -validvalue {}                 -type num|null          -default "nothing"

    if {[format {%s.%s} $major $minor] >= 5.3} {
        setdef options -center             -validvalue {}                  -type list.d|null       -default "nothing"
    }

    setdef options -zoom                    -validvalue {}                 -type num               -default 1
    setdef options -layout                  -validvalue formatLayout       -type str               -default "none"
    setdef options -circular                -validvalue {}                 -type dict|null         -default [ticklecharts::circular $value]
    setdef options -force                   -validvalue {}                 -type dict|null         -default [ticklecharts::force $value]
    setdef options -roam                    -validvalue formatRoam         -type str|bool          -default "False"
    setdef options -scaleLimit              -validvalue {}                 -type dict|null         -default [ticklecharts::scaleLimit $value]
    setdef options -nodeScaleRatio          -validvalue {}                 -type num               -default 0.6
    setdef options -draggable               -validvalue {}                 -type bool|null         -default "nothing"
    setdef options -symbol                  -validvalue formatItemSymbol   -type str|null          -default "nothing"
    setdef options -symbolSize              -validvalue {}                 -type num|list.d|null   -default "nothing"
    setdef options -symbolOffset            -validvalue {}                 -type list.d|null       -default "nothing"
    setdef options -symbolRotate            -validvalue {}                 -type num|null          -default "nothing"
    setdef options -symbolKeepAspect        -validvalue {}                 -type bool              -default "True"
    setdef options -edgeSymbol              -validvalue {}                 -type str|list.d|null   -default "nothing"
    setdef options -edgeSymbolSize          -validvalue {}                 -type num|list.d|null   -default "nothing"
    setdef options -cursor                  -validvalue formatCursor       -type str|null          -default "pointer"
    setdef options -itemStyle               -validvalue {}                 -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -lineStyle               -validvalue {}                 -type dict|null         -default [ticklecharts::lineStyle $value]
    setdef options -label                   -validvalue {}                 -type dict|null         -default [ticklecharts::label $value]
    setdef options -edgeLabel               -validvalue {}                 -type dict|null         -default [ticklecharts::edgeLabel $value]
    setdef options -labelLayout             -validvalue {}                 -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -emphasis                -validvalue {}                 -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                 -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                 -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode -type bool|str|null     -default "False"
    setdef options -categories              -validvalue {}                 -type list.o|null       -default [ticklecharts::categories $value]
    setdef options -autoCurveness           -validvalue {}                 -type bool|num|null     -default "nothing"
    setdef options -data                    -validvalue {}                 -type list.o            -default [ticklecharts::dataGraphItem $value]
    setdef options -links                   -validvalue {}                 -type list.o|null       -default [ticklecharts::linksItem $value -links]
    setdef options -edges                   -validvalue {}                 -type list.o|null       -default [ticklecharts::linksItem $value -edges]
    setdef options -markPoint               -validvalue {}                 -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -validvalue {}                 -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -validvalue {}                 -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -validvalue {}                 -type num               -default 0
    setdef options -z                       -validvalue {}                 -type num               -default 2
    setdef options -left                    -validvalue formatLeft         -type num|str|null      -default "nothing"
    setdef options -top                     -validvalue formatTop          -type num|str|null      -default "nothing"
    setdef options -right                   -validvalue formatRight        -type num|str|null      -default "nothing"
    setdef options -bottom                  -validvalue formatBottom       -type num|str|null      -default "nothing"
    setdef options -width                   -validvalue {}                 -type num|str|null      -default "nothing"
    setdef options -height                  -validvalue {}                 -type num|str|null      -default "nothing"
    setdef options -silent                  -validvalue {}                 -type bool              -default "False"
    setdef options -animation               -validvalue {}                 -type bool|null         -default "nothing"
    setdef options -animationThreshold      -validvalue {}                 -type num|null          -default "nothing"
    setdef options -animationDuration       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing      -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -validvalue formatAEasing      -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -validvalue {}                 -type dict|null         -default [ticklecharts::tooltip $value]


    if {[dict exists $value -dataGraphItem] && [dict exists $value -data]} {
        error "'graph' args cannot contain '-data' and '-dataGraphItem'..."
    } elseif {![dict exists $value -dataGraphItem] && ![dict exists $value -data]} {
        error "key '-dataGraphItem' or '-data' not present..."
    }
          
    set value [dict remove $value -circular -force -scaleLimit -itemStyle -lineStyle -label -edgeLabel -labelLayout -emphasis \
                                  -blur -select -categories -data -links -edges -markPoint -markLine -markArea -dataGraphItem]
                                
    set options [merge $options $value]

    return $options

}

proc ticklecharts::wordcloudseries {index value} {
    # options : https://github.com/ecomfe/echarts-wordcloud
    #
    # index - index series.
    # value - Options described in proc ticklecharts::wordcloudseries below.
    #
    # return dict wordcloudseries options

    setdef options -type              -validvalue {}               -type str            -default "wordCloud"
    setdef options -shape             -validvalue formatWCshape    -type str            -default "circle"
    # 'keepAspect' is supported from echarts-wordcloud@2.1.0
    setdef options -keepAspect        -validvalue {}               -type bool|null      -default "nothing"
    setdef options -maskImage         -validvalue {}               -type jsfunc|null    -default "nothing"
    setdef options -left              -validvalue formatLeft       -type num|str|null   -default "center"
    setdef options -top               -validvalue formatTop        -type num|str|null   -default "center"
    setdef options -right             -validvalue formatRight      -type num|str|null   -default "null"
    setdef options -bottom            -validvalue formatBottom     -type num|str|null   -default "null"
    setdef options -width             -validvalue {}               -type num|str|null   -default "70%"
    setdef options -height            -validvalue {}               -type num|str|null   -default "80%"
    setdef options -sizeRange         -validvalue {}               -type list.n         -default [list {12 60}]
    setdef options -rotationRange     -validvalue {}               -type list.n         -default [list {-90 90}]
    setdef options -rotationStep      -validvalue {}               -type num            -default 45
    setdef options -gridSize          -validvalue {}               -type num            -default 8
    setdef options -drawOutOfBound    -validvalue {}               -type bool           -default "false"
    setdef options -layoutAnimation   -validvalue {}               -type bool           -default "true"
    setdef options -textStyle         -validvalue {}               -type dict|null      -default [ticklecharts::textStyle $value -textStyle]
    setdef options -emphasis          -validvalue {}               -type dict|null      -default [ticklecharts::emphasis $value]
    setdef options -data              -validvalue {}               -type list.o         -default [ticklecharts::dataWCItem $value]


    set value [dict remove $value -textStyle -emphasis -dataWCItem]

    set options [merge $options $value]

    return $options

}

proc ticklecharts::boxPlotseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-boxplot
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::boxPlotseries below.
    #
    # return dict boxPlotseries options

    setdef options -type                    -validvalue {}                    -type str               -default "boxplot"
    setdef options -id                      -validvalue {}                    -type str|null          -default "nothing"
    setdef options -coordinateSystem        -validvalue formatCSYS            -type str               -default "cartesian2d"
    setdef options -xAxisIndex              -validvalue {}                    -type num|null          -default "nothing"
    setdef options -yAxisIndex              -validvalue {}                    -type num|null          -default "nothing"
    setdef options -name                    -validvalue {}                    -type str               -default "boxPlotseries_${index}"
    setdef options -colorBy                 -validvalue formatColorBy         -type str               -default "series"
    setdef options -legendHoverLink         -validvalue {}                    -type bool              -default "True"
    setdef options -hoverAnimation          -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -layout                  -validvalue formatOrient          -type str|null          -default "nothing"
    setdef options -boxWidth                -validvalue {}                    -type list.n            -default [list {7 50}]
    setdef options -itemStyle               -validvalue {}                    -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -validvalue {}                    -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -validvalue {}                    -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -validvalue {}                    -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -validvalue formatSelectedMode    -type bool|str|null     -default "nothing"
    setdef options -data                    -validvalue formatDataBox         -type list.n            -default {}
    setdef options -markPoint               -validvalue {}                    -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -validvalue {}                    -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -validvalue {}                    -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -validvalue {}                    -type num               -default 0
    setdef options -z                       -validvalue {}                    -type num               -default 2
    setdef options -silent                  -validvalue {}                    -type bool              -default "False"
    setdef options -animationDuration       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -validvalue formatAEasing         -type str|null          -default "nothing"
    setdef options -animationDelay          -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -universalTransition     -validvalue {}                    -type dict|null         -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -validvalue {}                    -type dict|null         -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -dataGroupId            -validvalue {} -type str|null         -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -dataBoxPlotitem]} {
            error "'chart' Class cannot contain '-data' or 'dataBoxPlotitem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -validvalue {} -type list.d|null      -default "nothing"
        setdef options  -datasetId      -validvalue {} -type str|null     -default "nothing"
        setdef options  -encode         -validvalue {} -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options  -datasetIndex   -validvalue {} -type num|null     -default "nothing"

    }

    if {[dict exists $value -dataBoxPlotitem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-dataBoxPlotitem'..."
        }
        setdef options -data -validvalue {} -type list.o -default [ticklecharts::boxPlotitem $value]
    }
          
    set value [dict remove $value -markPoint -markLine -markArea \
                                  -itemStyle -dataBoxPlotitem \
                                  -emphasis -blur -select -tooltip -encode]
                                
    set options [merge $options $value]

    return $options

}