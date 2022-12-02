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

    setdef options -type                    -minversion 5       -validvalue {}                   -type str             -default "bar"
    setdef options -id                      -minversion 5       -validvalue {}                   -type str|null        -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                   -type str             -default "barseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy        -type str             -default "series"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                   -type bool            -default "True"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS           -type str             -default "cartesian2d"
    setdef options -xAxisIndex              -minversion 5       -validvalue {}                   -type num|null        -default "nothing"
    setdef options -yAxisIndex              -minversion 5       -validvalue {}                   -type num|null        -default "nothing"
    setdef options -polarIndex              -minversion 5       -validvalue {}                   -type num|null        -default "nothing"
    setdef options -roundCap                -minversion 5       -validvalue {}                   -type bool            -default "False"
    setdef options -showBackground          -minversion 5       -validvalue {}                   -type bool            -default "False"
    setdef options -backgroundStyle         -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::backgroundStyle $value]
    setdef options -label                   -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -labelLayout             -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode   -type bool|str|null   -default "nothing"
    setdef options -stack                   -minversion 5       -validvalue {}                   -type str|null        -default "nothing"
    setdef options -stackStrategy           -minversion "5.3.3" -validvalue formatStackStrategy  -type str|null        -default "nothing"
    setdef options -sampling                -minversion 5       -validvalue formatSampling       -type str             -default "max"
    setdef options -cursor                  -minversion 5       -validvalue formatCursor         -type str|null        -default "pointer"
    setdef options -barWidth                -minversion 5       -validvalue {}                   -type str|num|null    -default "nothing"
    setdef options -barMaxWidth             -minversion 5       -validvalue {}                   -type str|num|null    -default "nothing"
    setdef options -barMinWidth             -minversion 5       -validvalue {}                   -type str|num|null    -default "null"
    setdef options -barMinHeight            -minversion 5       -validvalue {}                   -type num|null        -default "nothing"
    setdef options -barMinAngle             -minversion 5       -validvalue {}                   -type num|null        -default "nothing"
    setdef options -barGap                  -minversion 5       -validvalue formatBarGap         -type str|null        -default "nothing"
    setdef options -barCategoryGap          -minversion 5       -validvalue formatBarCategoryGap -type str|null        -default "20%"
    setdef options -large                   -minversion 5       -validvalue {}                   -type bool            -default "False"
    setdef options -largeThreshold          -minversion 5       -validvalue {}                   -type num             -default 400
    setdef options -progressive             -minversion 5       -validvalue {}                   -type num|null        -default "nothing"
    setdef options -progressiveThreshold    -minversion 5       -validvalue {}                   -type num|null        -default "nothing"
    setdef options -progressiveChunkMode    -minversion 5       -validvalue formatPChunkMode     -type str|null        -default "nothing"
    setdef options -data                    -minversion 5       -validvalue {}                   -type list.d          -default {}
    setdef options -markLine                -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markPoint               -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -zlevel                  -minversion 5       -validvalue {}                   -type num             -default 0
    setdef options -z                       -minversion 5       -validvalue {}                   -type num             -default 2
    setdef options -silent                  -minversion 5       -validvalue {}                   -type bool            -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                   -type bool|null       -default "nothing"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                   -type num|null        -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                   -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing        -type str|null        -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                   -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                   -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing        -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                   -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                   -type dict|null       -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                   -type dict|null       -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -databaritem]} {
            error "'chart' Class cannot contain '-data' or '-databaritem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -minversion 5  -validvalue {}                 -type list.d|null      -default "nothing"
        setdef options  -dataGroupId    -minversion 5  -validvalue {}                 -type str|null         -default "nothing"
        setdef options  -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options  -encode         -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options  -datasetIndex   -minversion 5  -validvalue {}                 -type num|null         -default "nothing"

    }
      
    if {[dict exists $value -databaritem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-databaritem'..."
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::BarItem $value]
    }
    
    set value [dict remove $value -label -endLabel -universalTransition \
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

    setdef options -type                    -minversion 5       -validvalue {}                  -type str             -default "line"
    setdef options -id                      -minversion 5       -validvalue {}                  -type str|null        -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                  -type str             -default "lineseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy       -type str             -default "series"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS          -type str             -default "cartesian2d"
    setdef options -xAxisIndex              -minversion 5       -validvalue {}                  -type num|null        -default "nothing"
    setdef options -yAxisIndex              -minversion 5       -validvalue {}                  -type num|null        -default "nothing"
    setdef options -polarIndex              -minversion 5       -validvalue {}                  -type num|null        -default "nothing"
    setdef options -symbol                  -minversion 5       -validvalue formatItemSymbol    -type str|jsfunc|null -default [EchartsOptsTheme symbol]
    setdef options -symbolSize              -minversion 5       -validvalue {}                  -type num|list.n      -default [EchartsOptsTheme symbolSize]
    setdef options -symbolRotate            -minversion 5       -validvalue {}                  -type num|null        -default "nothing"
    setdef options -symbolKeepAspect        -minversion 5       -validvalue {}                  -type bool            -default "True"
    setdef options -symbolOffset            -minversion 5       -validvalue {}                  -type list.d|null     -default "nothing"
    setdef options -showSymbol              -minversion 5       -validvalue {}                  -type bool            -default "True"
    setdef options -showAllSymbol           -minversion 5       -validvalue formatShowAllSymbol -type bool|str        -default "auto"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                  -type bool            -default "True"
    setdef options -stack                   -minversion 5       -validvalue {}                  -type str|null        -default "nothing"
    setdef options -stackStrategy           -minversion "5.3.3" -validvalue formatStackStrategy -type str|null        -default "nothing"
    setdef options -cursor                  -minversion 5       -validvalue formatCursor        -type str|null        -default "pointer"
    setdef options -connectNulls            -minversion 5       -validvalue {}                  -type bool            -default "False"
    setdef options -clip                    -minversion 5       -validvalue {}                  -type bool            -default "True"
    setdef options -triggerLineEvent        -minversion "5.2.2" -validvalue {}                  -type bool            -default "False"
    setdef options -step                    -minversion 5       -validvalue formatStep          -type bool|str        -default "False"
    setdef options -label                   -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::label $value]
    setdef options -endLabel                -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::endLabel $value]
    setdef options -labelLine               -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -lineStyle               -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::lineStyle $value]
    setdef options -areaStyle               -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::areaStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode  -type bool|str|null   -default "nothing"
    setdef options -smooth                  -minversion 5       -validvalue {}                  -type bool|num        -default [EchartsOptsTheme lineSmooth]
    setdef options -smoothMonotone          -minversion 5       -validvalue formatSMonotone     -type str|null        -default "nothing"
    setdef options -sampling                -minversion 5       -validvalue formatSampling      -type str|null        -default "nothing"
    setdef options -data                    -minversion 5       -validvalue {}                  -type list.d          -default {}
    setdef options -markPoint               -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -minversion 5       -validvalue {}                  -type num             -default 0
    setdef options -z                       -minversion 5       -validvalue {}                  -type num             -default 2
    setdef options -silent                  -minversion 5       -validvalue {}                  -type bool            -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                  -type bool|null       -default "nothing"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                  -type num|null        -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                  -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing       -type str|null        -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                  -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                  -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing       -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                  -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                  -type dict|null       -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                  -type dict|null       -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -datalineitem]} {
            error "'chart' Class cannot contain '-data' or '-datalineitem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class...
        # setdef options -dimensions     -minversion 5  -validvalue {}                 -type list.d|null      -default "nothing"
        setdef options   -dataGroupId    -minversion 5  -validvalue {}                 -type str|null         -default "nothing"
        setdef options   -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options   -encode         -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -minversion 5  -validvalue {}                 -type num|null         -default "nothing"

    }
    
    if {[dict exists $value -datalineitem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-datalineitem'..."
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::LineItem $value]
    }
    
    set value [dict remove $value -label -endLabel \
                                  -labelLine -lineStyle \
                                  -areaStyle -markPoint -markLine -markArea \
                                  -labelLayout -itemStyle -universalTransition \
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

    setdef options -type                    -minversion 5       -validvalue {}                 -type str             -default "pie"
    setdef options -id                      -minversion 5       -validvalue {}                 -type str|null        -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                 -type str             -default "pieseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy      -type str             -default "data"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                 -type bool            -default "True"
    setdef options -coordinateSystem        -minversion "5.4.0" -validvalue formatCSYS         -type str|null        -default "nothing"
    setdef options -geoIndex                -minversion "5.4.0" -validvalue {}                 -type num|null        -default "nothing"
    setdef options -calendarIndex           -minversion "5.4.0" -validvalue {}                 -type num|null        -default "nothing"
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode -type bool|str|null   -default "nothing"
    setdef options -selectedOffset          -minversion 5       -validvalue {}                 -type num             -default 10
    setdef options -clockwise               -minversion 5       -validvalue {}                 -type bool            -default "True"
    setdef options -startAngle              -minversion 5       -validvalue formatStartangle   -type num             -default 90
    setdef options -minAngle                -minversion 5       -validvalue {}                 -type num             -default 0
    setdef options -minShowLabelAngle       -minversion 5       -validvalue {}                 -type num             -default 0
    setdef options -roseType                -minversion 5       -validvalue formatRoseType     -type bool|str        -default "False"
    setdef options -avoidLabelOverlap       -minversion 5       -validvalue {}                 -type bool            -default "True"
    setdef options -stillShowZeroSum        -minversion 5       -validvalue {}                 -type bool            -default "True"
    setdef options -percentPrecision        -minversion 5       -validvalue {}                 -type num|null        -default "nothing"
    setdef options -cursor                  -minversion 5       -validvalue formatCursor       -type str|null        -default "pointer"
    setdef options -zlevel                  -minversion 5       -validvalue {}                 -type num             -default 0
    setdef options -z                       -minversion 5       -validvalue {}                 -type num             -default 2
    setdef options -left                    -minversion 5       -validvalue formatLeft         -type num|str         -default 0
    setdef options -top                     -minversion 5       -validvalue formatTop          -type num|str         -default 0
    setdef options -right                   -minversion 5       -validvalue formatRight        -type num|str         -default 0
    setdef options -bottom                  -minversion 5       -validvalue formatBottom       -type num|str         -default 0
    setdef options -width                   -minversion 5       -validvalue {}                 -type num|str         -default "auto"
    setdef options -height                  -minversion 5       -validvalue {}                 -type num|str         -default "auto"
    setdef options -showEmptyCircle         -minversion "5.2.0" -validvalue {}                 -type bool            -default "True"
    setdef options -emptyCircleStyle        -minversion "5.2.0" -validvalue {}                 -type dict|null       -default [ticklecharts::emptyCircleStyle $value]
    setdef options -label                   -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::select $value]
    setdef options -center                  -minversion 5       -validvalue {}                 -type list.d          -default [list {"50%" "50%"}]
    setdef options -radius                  -minversion 5       -validvalue {}                 -type list.d|num|str  -default [list {0 "75%"}]
    setdef options -markPoint               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -silent                  -minversion 5       -validvalue {}                 -type bool            -default "False"
    setdef options -animationType           -minversion 5       -validvalue formatAType        -type str|null        -default "expansion"
    setdef options -animationTypeUpdate     -minversion 5       -validvalue formatATypeUpdate  -type str|null        -default "transition"
    setdef options -animation               -minversion 5       -validvalue {}                 -type bool|null       -default "True"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                 -type num|null        -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                 -type dict|null       -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -datapieitem]} {
            error "'chart' Class cannot contain '-datapieitem' when a class dataset is present"
        }

        # set dimensions in dataset class...
        # setdef options -dimensions     -minversion 5  -validvalue {}                 -type list.d|null  -default "nothing"
        setdef options   -dataGroupId    -minversion 5  -validvalue {}                 -type str|null     -default "nothing"
        setdef options   -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null     -default "nothing"
        setdef options   -encode         -minversion 5  -validvalue {}                 -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -minversion 5  -validvalue {}                 -type num|null     -default "nothing"

    } else {
        # set data options when dataset class doesn't exist...
        setdef options   -data          -minversion 5   -validvalue {}                 -type list.o       -default [ticklecharts::PieItem $value]
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

    setdef options -type                    -minversion 5       -validvalue {}                 -type str             -default "funnel"
    setdef options -id                      -minversion 5       -validvalue {}                 -type str|null        -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                 -type str             -default "funnelseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy      -type str             -default "data"
    setdef options -min                     -minversion 5       -validvalue {}                 -type num|null        -default "nothing"
    setdef options -max                     -minversion 5       -validvalue {}                 -type num|null        -default "nothing"
    setdef options -minSize                 -minversion 5       -validvalue {}                 -type str|num|null    -default "0%"
    setdef options -maxSize                 -minversion 5       -validvalue {}                 -type str|num|null    -default "100%"
    setdef options -orient                  -minversion 5       -validvalue formatOrient       -type str             -default "vertical"
    setdef options -sort                    -minversion 5       -validvalue formatSort         -type str|jsfunc      -default "descending"
    setdef options -gap                     -minversion 5       -validvalue {}                 -type num             -default 0
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                 -type bool            -default "True"
    setdef options -funnelAlign             -minversion 5       -validvalue formatFunnelAlign  -type str             -default "center"
    setdef options -label                   -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode -type bool|str|null   -default "True"
    setdef options -zlevel                  -minversion 5       -validvalue {}                 -type num             -default 0
    setdef options -z                       -minversion 5       -validvalue {}                 -type num             -default 2
    setdef options -left                    -minversion 5       -validvalue formatLeft         -type num|str         -default 0
    setdef options -top                     -minversion 5       -validvalue formatTop          -type num|str         -default 0
    setdef options -right                   -minversion 5       -validvalue formatRight        -type num|str         -default 0
    setdef options -bottom                  -minversion 5       -validvalue formatBottom       -type num|str         -default 0
    setdef options -width                   -minversion 5       -validvalue {}                 -type num|str         -default "auto"
    setdef options -height                  -minversion 5       -validvalue {}                 -type num|str         -default "auto"
    setdef options -data                    -minversion 5       -validvalue {}                 -type list.o          -default [ticklecharts::FunnelItem $value]
    setdef options -markPoint               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::markPoint $value]
    setdef options -markLine                -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::markLine $value]
    setdef options -markArea                -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::markArea $value]
    setdef options -silent                  -minversion 5       -validvalue {}                 -type bool            -default "False"
    setdef options -animationType           -minversion 5       -validvalue formatAType        -type str|null        -default "expansion"
    setdef options -animationTypeUpdate     -minversion 5       -validvalue formatATypeUpdate  -type str|null        -default "transition"
    setdef options -animation               -minversion 5       -validvalue {}                 -type bool|null       -default "True"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                 -type num|null        -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue formatAEasing      -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue {}                 -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                 -type dict|null       -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -datafunnelitem]} {
            error "'chart' Class cannot contain '-data' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions     -minversion 5  -validvalue {}                 -type list.d|null  -default "nothing"
        setdef options   -dataGroupId    -minversion 5  -validvalue {}                 -type str|null     -default "nothing"
        setdef options   -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null     -default "nothing"
        setdef options   -encode         -minversion 5  -validvalue {}                 -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -minversion 5  -validvalue {}                 -type num|null     -default "nothing"

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

    setdef options -type                    -minversion 5       -validvalue {}                 -type str             -default "radar"
    setdef options -id                      -minversion 5       -validvalue {}                 -type str|null        -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                 -type str             -default "radarseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy      -type str             -default "data"
    setdef options -radarIndex              -minversion 5       -validvalue {}                 -type num|null        -default 0
    setdef options -symbol                  -minversion 5       -validvalue formatItemSymbol   -type str|jsfunc|null -default "circle"
    setdef options -symbolSize              -minversion 5       -validvalue {}                 -type num|list.n      -default 8
    setdef options -symbolRotate            -minversion 5       -validvalue {}                 -type num|null        -default "nothing"
    setdef options -symbolKeepAspect        -minversion 5       -validvalue {}                 -type bool            -default "True"
    setdef options -symbolOffset            -minversion 5       -validvalue {}                 -type list.d|null     -default "nothing"
    setdef options -label                   -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLayout             -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -lineStyle               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::lineStyle $value]
    setdef options -areaStyle               -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::areaStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode -type bool|str|null   -default "nothing"
    setdef options -data                    -minversion 5       -validvalue {}                 -type list.o          -default [ticklecharts::RadarItem $value]
    setdef options -zlevel                  -minversion 5       -validvalue {}                 -type num             -default 0
    setdef options -z                       -minversion 5       -validvalue {}                 -type num             -default 2
    setdef options -silent                  -minversion 5       -validvalue {}                 -type bool            -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                 -type bool|null       -default "nothing"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                 -type num|null        -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                 -type dict|null       -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                 -type dict|null       -default [ticklecharts::tooltip $value]

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

    setdef options -type                    -minversion 5       -validvalue formatTypeScatter  -type str               -default "scatter"
    setdef options -id                      -minversion 5       -validvalue {}                 -type str|null          -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                 -type str               -default "scatterseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy      -type str               -default "series"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS         -type str               -default "cartesian2d"
    setdef options -xAxisIndex              -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -yAxisIndex              -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -polarIndex              -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -geoIndex                -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -calendarIndex           -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                 -type bool              -default "True"
    setdef options -symbol                  -minversion 5       -validvalue formatItemSymbol   -type str|jsfunc|null   -default "circle"
    setdef options -symbolSize              -minversion 5       -validvalue {}                 -type num|jsfunc|list.n -default 10
    setdef options -symbolRotate            -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -symbolKeepAspect        -minversion 5       -validvalue {}                 -type bool              -default "True"
    setdef options -symbolOffset            -minversion 5       -validvalue {}                 -type list.d|null       -default "nothing"    
    setdef options -large                   -minversion 5       -validvalue {}                 -type bool              -default "False"
    setdef options -largeThreshold          -minversion 5       -validvalue {}                 -type num               -default 2000    
    setdef options -cursor                  -minversion 5       -validvalue formatCursor       -type str|null          -default "pointer"    
    setdef options -label                   -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLine               -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::labelLine $value]    
    setdef options -labelLayout             -minversion 5       -validvalue {}                 -type dict|jsfunc|null  -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode -type bool|str|null     -default "nothing"
    setdef options -progressive             -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -progressiveThreshold    -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -data                    -minversion 5       -validvalue {}                 -type list.d            -default {}    
    setdef options -markLine                -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markPoint               -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markArea                -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -clip                    -minversion 5       -validvalue {}                 -type bool              -default "True"
    setdef options -zlevel                  -minversion 5       -validvalue {}                 -type num               -default 0
    setdef options -z                       -minversion 5       -validvalue {}                 -type num               -default 2
    setdef options -silent                  -minversion 5       -validvalue {}                 -type bool              -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                 -type bool|null         -default "nothing"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing      -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing      -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                 -type dict|null         -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::tooltip $value]
        
    if {[dict exists $value -type]} {
        switch -exact -- [dict get $value -type] {
            effectScatter {
                setdef options -clip         -minversion "5.1.0" -validvalue {}              -type bool      -default "True"
                setdef options -effectType   -minversion 5       -validvalue {}              -type str       -default "ripple"
                setdef options -showEffectOn -minversion 5       -validvalue formatSEffectOn -type str       -default "render"
                setdef options -rippleEffect -minversion 5       -validvalue {}              -type dict|null -default [ticklecharts::rippleEffect $value]
            }
        }
    }

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data]} {
            error "'chart' Class cannot contain '-data' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class...
        # setdef options -dimensions     -minversion 5  -validvalue {} -type list.d|null -default "nothing"
        setdef options   -dataGroupId    -minversion 5  -validvalue {}                 -type str|null       -default "nothing"
        setdef options   -datasetId      -minversion 5  -validvalue {}                   -type str|null     -default "nothing"
        setdef options   -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout   -type str|null     -default "nothing"
        setdef options   -encode         -minversion 5  -validvalue {}                   -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -minversion 5  -validvalue {}                   -type num|null     -default "nothing"

    }
    
    set lflag {-label -labelLine -lineStyle
               -markPoint -markLine -universalTransition \
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

    setdef options -type                 -minversion 5  -validvalue {}                 -type str              -default "heatmap"
    setdef options -id                   -minversion 5  -validvalue {}                 -type str|null         -default "nothing"
    setdef options -name                 -minversion 5  -validvalue {}                 -type str              -default "heatmapseries_${index}"
    setdef options -coordinateSystem     -minversion 5  -validvalue formatCSYS         -type str              -default "cartesian2d"
    setdef options -xAxisIndex           -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options -yAxisIndex           -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options -geoIndex             -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options -calendarIndex        -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options -pointSize            -minversion 5  -validvalue {}                 -type num              -default 20
    setdef options -blurSize             -minversion 5  -validvalue {}                 -type num              -default 20
    setdef options -minOpacity           -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options -maxOpacity           -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options -progressive          -minversion 5  -validvalue {}                 -type num|null         -default 400
    setdef options -progressiveThreshold -minversion 5  -validvalue {}                 -type num|null         -default 3000
    setdef options -label                -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::label $value]
    setdef options -labelLine            -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::labelLine $value]    
    setdef options -labelLayout          -minversion 5  -validvalue {}                 -type dict|jsfunc|null -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle            -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::itemStyle $value]
    setdef options -emphasis             -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::emphasis $value]
    setdef options -universalTransition  -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::universalTransition $value]
    setdef options -blur                 -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::blur $value]
    setdef options -select               -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::select $value]
    setdef options -selectedMode         -minversion 5  -validvalue formatSelectedMode -type bool|str|null    -default "nothing"
    setdef options -data                 -minversion 5  -validvalue {}                 -type list.d           -default {}    
    setdef options -markLine             -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::markLine $value]
    setdef options -markPoint            -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::markPoint $value]
    setdef options -markArea             -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::markArea $value]
    setdef options -zlevel               -minversion 5  -validvalue {}                 -type num              -default 0
    setdef options -z                    -minversion 5  -validvalue {}                 -type num              -default 2
    setdef options -silent               -minversion 5  -validvalue {}                 -type bool             -default "False"
    setdef options -tooltip              -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data]} {
            error "'chart' Class cannot contain '-data' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions     -minversion 5  -validvalue {}                 -type list.d|null  -default "nothing"
        setdef options   -dataGroupId    -minversion 5  -validvalue {}                 -type str|null     -default "nothing"
        setdef options   -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null     -default "nothing"
        setdef options   -encode         -minversion 5  -validvalue {}                 -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -minversion 5  -validvalue {}                 -type num|null     -default "nothing"

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

    setdef options -type                    -minversion 5  -validvalue {}                 -type str             -default "sunburst"
    setdef options -id                      -minversion 5  -validvalue {}                 -type str|null        -default "nothing"
    setdef options -name                    -minversion 5  -validvalue {}                 -type str             -default "sunburstseries_${index}"
    setdef options -zlevel                  -minversion 5  -validvalue {}                 -type num             -default 0
    setdef options -z                       -minversion 5  -validvalue {}                 -type num             -default 2
    setdef options -center                  -minversion 5  -validvalue {}                 -type list.d          -default [list {"50%" "50%"}]
    setdef options -radius                  -minversion 5  -validvalue {}                 -type list.d|num|str  -default [list {0 "75%"}]
    setdef options -data                    -minversion 5  -validvalue {}                 -type list.o          -default [ticklecharts::sunburstItem $value]
    setdef options -labelLayout             -minversion 5  -validvalue {}                 -type dict|null       -default [ticklecharts::labelLayout $value]
    setdef options -label                   -minversion 5  -validvalue {}                 -type dict|null       -default [ticklecharts::label $value]
    setdef options -labelLine               -minversion 5  -validvalue {}                 -type dict|null       -default [ticklecharts::labelLine $value]
    setdef options -itemStyle               -minversion 5  -validvalue {}                 -type dict|null       -default [ticklecharts::itemStyle $value]
    setdef options -nodeClick               -minversion 5  -validvalue formatNodeClick    -type bool|str        -default "rootToNode"
    setdef options -sort                    -minversion 5  -validvalue formatSort         -type str|jsfunc|null -default "desc"
    setdef options -renderLabelForZeroData  -minversion 5  -validvalue {}                 -type bool|null       -default "nothing"
    setdef options -emphasis                -minversion 5  -validvalue {}                 -type dict|null       -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5  -validvalue {}                 -type dict|null       -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5  -validvalue {}                 -type dict|null       -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5  -validvalue formatSelectedMode -type bool|str|null   -default "nothing"
    setdef options -levels                  -minversion 5  -validvalue {}                 -type list.o|null     -default [ticklecharts::levelsItem $value]
    setdef options -animation               -minversion 5  -validvalue {}                 -type bool|null       -default "True"
    setdef options -animationThreshold      -minversion 5  -validvalue {}                 -type num|null        -default "nothing"
    setdef options -animationDuration       -minversion 5  -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasing         -minversion 5  -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelay          -minversion 5  -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationDurationUpdate -minversion 5  -validvalue {}                 -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5  -validvalue formatAEasing      -type str|null        -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5  -validvalue {}                 -type num|jsfunc|null -default "nothing"


    if {![dict exists $value -data]} {
        error "key -data not present... for [lindex [info level 0] 0]"
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

    setdef options -type                    -minversion 5  -validvalue {}                  -type str               -default "tree"
    setdef options -id                      -minversion 5  -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -minversion 5  -validvalue {}                  -type str               -default "treeseries_${index}"
    setdef options -zlevel                  -minversion 5  -validvalue {}                  -type num               -default 0
    setdef options -z                       -minversion 5  -validvalue {}                  -type num               -default 2
    setdef options -left                    -minversion 5  -validvalue formatLeft          -type num|str           -default 0
    setdef options -top                     -minversion 5  -validvalue formatTop           -type num|str           -default 0
    setdef options -right                   -minversion 5  -validvalue formatRight         -type num|str           -default 0
    setdef options -bottom                  -minversion 5  -validvalue formatBottom        -type num|str           -default 0
    setdef options -width                   -minversion 5  -validvalue {}                  -type num|str           -default "auto"
    setdef options -height                  -minversion 5  -validvalue {}                  -type num|str           -default "auto"
    setdef options -layout                  -minversion 5  -validvalue formatLayout        -type str               -default "orthogonal"
    setdef options -orient                  -minversion 5  -validvalue formatTreeOrient    -type str               -default "LR"
    setdef options -symbol                  -minversion 5  -validvalue formatItemSymbol    -type str|jsfunc|null   -default [EchartsOptsTheme symbol]
    setdef options -symbolSize              -minversion 5  -validvalue {}                  -type num|list.n|jsfunc -default [EchartsOptsTheme symbolSize]
    setdef options -symbolRotate            -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -symbolKeepAspect        -minversion 5  -validvalue {}                  -type bool              -default "True"
    setdef options -symbolOffset            -minversion 5  -validvalue {}                  -type list.d|null       -default "nothing"
    setdef options -edgeShape               -minversion 5  -validvalue formatEdgeShape     -type str               -default "curve"
    setdef options -edgeForkPosition        -minversion 5  -validvalue formatEForkPosition -type str|null          -default "50%"
    setdef options -roam                    -minversion 5  -validvalue formatRoam          -type str|bool          -default "False"
    setdef options -expandAndCollapse       -minversion 5  -validvalue {}                  -type bool              -default "True"
    setdef options -initialTreeDepth        -minversion 5  -validvalue {}                  -type num               -default 2
    setdef options -itemStyle               -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -label                   -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLayout             -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -lineStyle               -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::lineStyle $value]
    setdef options -emphasis                -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5  -validvalue formatSelectedMode  -type bool|str|null     -default "nothing"
    setdef options -leaves                  -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::leaves $value]
    setdef options -data                    -minversion 5  -validvalue {}                  -type list.o            -default [ticklecharts::treeItem $value]
    setdef options -animation               -minversion 5  -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -animationThreshold      -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options -animationDuration       -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5  -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5  -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::tooltip $value]

    if {![dict exists $value -data]} {
        error "key -data not present... for [lindex [info level 0] 0]"
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

    setdef options -type                    -minversion 5       -validvalue {}                  -type str               -default "themeRiver"
    setdef options -id                      -minversion 5       -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                  -type str               -default "themeriverseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy       -type str               -default "data"
    setdef options -zlevel                  -minversion 5       -validvalue {}                  -type num               -default 0
    setdef options -z                       -minversion 5       -validvalue {}                  -type num               -default 2
    setdef options -left                    -minversion 5       -validvalue formatLeft          -type num|str|null      -default "nothing"
    setdef options -top                     -minversion 5       -validvalue formatTop           -type num|str|null      -default "nothing"
    setdef options -right                   -minversion 5       -validvalue formatRight         -type num|str|null      -default "nothing"
    setdef options -bottom                  -minversion 5       -validvalue formatBottom        -type num|str|null      -default "nothing"
    setdef options -width                   -minversion 5       -validvalue {}                  -type num|str|null      -default "nothing"
    setdef options -height                  -minversion 5       -validvalue {}                  -type num|str|null      -default "nothing"
    # bug with coordinateSystem = single... 5.2.2
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS          -type str|null          -default "nothing"
    setdef options -boundaryGap             -minversion 5       -validvalue {}                  -type list.d            -default [list {"10%" "10%"}]
    setdef options -singleAxisIndex         -minversion 5       -validvalue {}                  -type num               -default 0
    setdef options -label                   -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLine               -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::labelLine $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -labelLayout             -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode  -type bool|str|null     -default "False"
    setdef options -data                    -minversion 5       -validvalue {}                  -type list.d            -default [ticklecharts::themeriverItem $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::tooltip $value]

    # not supported yet...
    # setdef options -tooltip               -minversion 5        -validvalue {} -type dict|null  -default [ticklecharts::tooltipseries $value]

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

    setdef options -type                    -minversion 5  -validvalue {}                  -type str               -default "sankey"
    setdef options -id                      -minversion 5  -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -minversion 5  -validvalue {}                  -type str               -default "sankeyseries_${index}"
    setdef options -zlevel                  -minversion 5  -validvalue {}                  -type num               -default 0
    setdef options -z                       -minversion 5  -validvalue {}                  -type num               -default 2
    setdef options -left                    -minversion 5  -validvalue formatLeft          -type num|str           -default "5%"
    setdef options -top                     -minversion 5  -validvalue formatTop           -type num|str           -default "5%"
    setdef options -right                   -minversion 5  -validvalue formatRight         -type num|str           -default "20%"
    setdef options -bottom                  -minversion 5  -validvalue formatBottom        -type num|str           -default "5%"
    setdef options -width                   -minversion 5  -validvalue {}                  -type num|str           -default "auto"
    setdef options -height                  -minversion 5  -validvalue {}                  -type num|str           -default "auto"
    setdef options -nodeWidth               -minversion 5  -validvalue {}                  -type num               -default 20
    setdef options -nodeGap                 -minversion 5  -validvalue {}                  -type num               -default 8
    setdef options -nodeAlign               -minversion 5  -validvalue formatNodeAlign     -type str               -default "justify"
    setdef options -layoutIterations        -minversion 5  -validvalue {}                  -type num               -default 32
    setdef options -orient                  -minversion 5  -validvalue formatOrient        -type str               -default "horizontal"
    setdef options -draggable               -minversion 5  -validvalue {}                  -type bool              -default "True"
    setdef options -levels                  -minversion 5  -validvalue {}                  -type list.o|null       -default [ticklecharts::levelsSankeyItem $value]
    setdef options -label                   -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLayout             -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -lineStyle               -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::lineStyle $value]
    setdef options -itemStyle               -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5  -validvalue formatSelectedMode  -type bool|str|null     -default "nothing"
    setdef options -data                    -minversion 5  -validvalue {}                  -type list.o            -default [ticklecharts::sankeyItem $value -data]
    setdef options -nodes                   -minversion 5  -validvalue {}                  -type list.o|null       -default [ticklecharts::sankeyItem $value -nodes]
    setdef options -links                   -minversion 5  -validvalue {}                  -type list.o|null       -default [ticklecharts::linksItem $value -links]
    setdef options -edges                   -minversion 5  -validvalue {}                  -type list.o|null       -default [ticklecharts::linksItem $value -edges]
    setdef options -silent                  -minversion 5  -validvalue {}                  -type bool              -default "False"
    setdef options -animation               -minversion 5  -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -animationThreshold      -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options -animationDuration       -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5  -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5  -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::tooltip $value]

    if {![dict exists $value -data] && ![dict exists $value -nodes]} {
        error "key -data or -nodes not present... for [lindex [info level 0] 0]"
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

    setdef options -type                    -minversion 5       -validvalue {}                    -type str               -default "pictorialBar"
    setdef options -id                      -minversion 5       -validvalue {}                    -type str|null          -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                    -type str               -default "pictorialbarseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy         -type str               -default "series"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                    -type bool              -default "True"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS            -type str               -default "cartesian2d"
    setdef options -xAxisIndex              -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -yAxisIndex              -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -cursor                  -minversion 5       -validvalue formatCursor          -type str|null          -default "pointer"
    setdef options -label                   -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::label $value]
    setdef options -labelLine               -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode    -type bool|str|null     -default "nothing"
    setdef options -barWidth                -minversion 5       -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -barMaxWidth             -minversion 5       -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -barMinWidth             -minversion 5       -validvalue {}                    -type str|num|null      -default "null"
    setdef options -barMinHeight            -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -barMinAngle             -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -barGap                  -minversion 5       -validvalue formatBarGap          -type str|null          -default "nothing"
    setdef options -barCategoryGap          -minversion 5       -validvalue formatBarCategoryGap  -type str|null          -default "20%" 
    setdef options -symbol                  -minversion 5       -validvalue formatItemSymbol      -type str|jsfunc|null   -default "nothing"
    setdef options -symbolSize              -minversion 5       -validvalue {}                    -type num|list.d|null   -default "nothing"
    setdef options -symbolPosition          -minversion 5       -validvalue formatSymbolPosition  -type str|null          -default "start"
    setdef options -symbolOffset            -minversion 5       -validvalue {}                    -type list.d|null       -default "nothing"
    setdef options -symbolRotate            -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -symbolKeepAspect        -minversion 5       -validvalue {}                    -type bool              -default "True"
    setdef options -symbolRepeat            -minversion 5       -validvalue formatSymbolRepeat    -type bool|str|num|null -default "nothing"
    setdef options -symbolRepeatDirection   -minversion 5       -validvalue formatsymbolRepeatDir -type str               -default "start"
    setdef options -symbolMargin            -minversion 5       -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -symbolClip              -minversion 5       -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -symbolBoundingData      -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -symbolPatternSize       -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -hoverAnimation          -minversion 5       -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -data                    -minversion 5       -validvalue {}                    -type list.o            -default [ticklecharts::pictorialBarItem $value]
    setdef options -markPoint               -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -minversion 5       -validvalue {}                    -type num               -default 0
    setdef options -z                       -minversion 5       -validvalue {}                    -type num               -default 2
    setdef options -silent                  -minversion 5       -validvalue {}                    -type bool              -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing         -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing         -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                    -type dict|null         -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data]} {
            error "'chart' Class cannot contain '-data' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -minversion 5  -validvalue {}                 -type list.d|null  -default "nothing"
        setdef options  -dataGroupId    -minversion 5  -validvalue {}                 -type str|null     -default "nothing"
        setdef options  -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null     -default "nothing"
        setdef options  -encode         -minversion 5  -validvalue {}                 -type dict|null    -default [ticklecharts::encode $chart $value]

    }
          
    set value [dict remove $value -label \
                                  -labelLine -lineStyle \
                                  -markPoint -markLine -markArea \
                                  -labelLayout -itemStyle -universalTransition \
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

    setdef options -type                    -minversion 5       -validvalue {}                    -type str               -default "candlestick"
    setdef options -id                      -minversion 5       -validvalue {}                    -type str|null          -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                    -type str               -default "candlestickseries_${index}"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS            -type str               -default "cartesian2d"
    setdef options -xAxisIndex              -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -yAxisIndex              -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy         -type str               -default "series"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                    -type bool              -default "True"
    setdef options -hoverAnimation          -minversion 5       -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -layout                  -minversion 5       -validvalue formatOrient          -type str|null          -default "nothing"
    setdef options -barWidth                -minversion 5       -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -barMaxWidth             -minversion 5       -validvalue {}                    -type str|num|null      -default "nothing"
    setdef options -barMinWidth             -minversion 5       -validvalue {}                    -type str|num|null      -default "null"
    setdef options -itemStyle               -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode    -type bool|str|null     -default "nothing"
    setdef options -large                   -minversion 5       -validvalue {}                    -type bool              -default "False"
    setdef options -largeThreshold          -minversion 5       -validvalue {}                    -type num               -default 400
    setdef options -progressive             -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -progressiveThreshold    -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -progressiveChunkMode    -minversion 5       -validvalue formatPChunkMode      -type str|null          -default "nothing"
    setdef options -data                    -minversion 5       -validvalue {}                    -type list.d            -default {}
    setdef options -markPoint               -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -clip                    -minversion 5       -validvalue {}                    -type bool              -default "True"
    setdef options -zlevel                  -minversion 5       -validvalue {}                    -type num               -default 0
    setdef options -z                       -minversion 5       -validvalue {}                    -type num               -default 2
    setdef options -silent                  -minversion 5       -validvalue {}                    -type bool              -default "False"
    setdef options -animationDuration       -minversion 5       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing         -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                    -type dict|null         -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -datacandlestickitem]} {
            error "'chart' Class cannot contain '-data' or 'datacandlestickitem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -minversion 5  -validvalue {} -type list.d|null  -default "nothing"
        setdef options  -dataGroupId    -minversion 5  -validvalue {} -type str|null     -default "nothing"
        setdef options  -encode         -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::encode $chart $value]

    }

    # not supported
    if {[dict exists $value -datacandlestickitem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-datacandlestickitem'..."
        }
        # setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::candlestickItem $value]
    }
          
    set value [dict remove $value -markPoint -markLine -markArea \
                                  -labelLayout -itemStyle -universalTransition \
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

    setdef options -type                    -minversion 5       -validvalue {}                  -type str               -default "parallel"
    setdef options -id                      -minversion 5       -validvalue {}                  -type str|null          -default "nothing"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS          -type str               -default "parallel"
    setdef options -name                    -minversion 5       -validvalue {}                  -type str               -default "parallelseries_${index}"
    setdef options -parallelIndex           -minversion 5       -validvalue {}                  -type num               -default 0
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy       -type str               -default "series"
    setdef options -lineStyle               -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::lineStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -inactiveOpacity         -minversion 5       -validvalue {}                  -type num               -default 0.05
    setdef options -activeOpacity           -minversion 5       -validvalue {}                  -type num               -default 1
    setdef options -realtime                -minversion 5       -validvalue {}                  -type bool              -default "True"
    setdef options -smooth                  -minversion 5       -validvalue {}                  -type bool|num|null     -default "nothing"
    setdef options -progressive             -minversion 5       -validvalue {}                  -type num               -default 500
    setdef options -progressiveThreshold    -minversion 5       -validvalue {}                  -type num|null          -default "nothing"
    setdef options -progressiveChunkMode    -minversion 5       -validvalue formatPChunkMode    -type str|null          -default "nothing"
    setdef options -data                    -minversion 5       -validvalue {}                  -type list.d            -default {}
    setdef options -zlevel                  -minversion 5       -validvalue {}                  -type num               -default 0
    setdef options -z                       -minversion 5       -validvalue {}                  -type num               -default 2
    setdef options -silent                  -minversion 5       -validvalue {}                  -type bool              -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                  -type num|null          -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                  -type num|jsfunc|null   -default "nothing"

    if {[dict exists $value -dataParallelItem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-dataParallelItem'..."
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::ParallelItem $value]
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

    setdef options -type                    -minversion 5       -validvalue {}                  -type str               -default "gauge"
    setdef options -id                      -minversion 5       -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                  -type str               -default "gauge_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy       -type str               -default "data"
    setdef options -zlevel                  -minversion 5       -validvalue {}                  -type num               -default 0
    setdef options -z                       -minversion 5       -validvalue {}                  -type num               -default 2
    setdef options -center                  -minversion 5       -validvalue {}                  -type list.d            -default [list {"50%" "50%"}]
    setdef options -radius                  -minversion 5       -validvalue {}                  -type str|num           -default "75%"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                  -type bool              -default "True"
    setdef options -startAngle              -minversion 5       -validvalue formatStartangle    -type num               -default 225
    setdef options -endAngle                -minversion 5       -validvalue formatEndangle      -type num               -default -45
    setdef options -clockwise               -minversion 5       -validvalue {}                  -type bool              -default "True"
    setdef options -data                    -minversion 5       -validvalue {}                  -type list.n            -default {}
    setdef options -min                     -minversion 5       -validvalue {}                  -type num|null          -default "nothing"
    setdef options -max                     -minversion 5       -validvalue {}                  -type num|null          -default "nothing"
    setdef options -splitNumber             -minversion 5       -validvalue {}                  -type num               -default 10
    setdef options -axisLine                -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::axisLine $value]
    setdef options -progress                -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::progress $value]
    setdef options -splitLine               -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::splitLine $value]
    setdef options -axisTick                -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::axisTick $value]
    setdef options -axisLabel               -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::axisLabel $value]
    setdef options -pointer                 -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::pointer $value]
    setdef options -anchor                  -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::anchor $value]
    setdef options -itemStyle               -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -title                   -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::titleGauge $value]
    setdef options -detail                  -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::detail $value]
    setdef options -markPoint               -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -minversion 5       -validvalue {}                  -type dict|null         -default [ticklecharts::markArea $value]    
    setdef options -silent                  -minversion 5       -validvalue {}                  -type bool              -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                  -type num|null          -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                  -type num|jsfunc|null   -default "nothing"

    if {[dict exists $value -dataGaugeItem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-dataGaugeItem'..."
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::gaugeItem $value]
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

    setdef options -type                    -minversion 5       -validvalue {}                 -type str               -default "graph"
    setdef options -id                      -minversion 5       -validvalue {}                 -type str|null          -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                 -type str               -default "graphseries_${index}"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                 -type bool              -default "True"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS         -type str|null          -default "null"
    setdef options -xAxisIndex              -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -yAxisIndex              -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -polarIndex              -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -geoIndex                -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -calendarIndex           -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -center                  -minversion "5.3.0" -validvalue {}                 -type list.d|null       -default "nothing"
    setdef options -zoom                    -minversion 5       -validvalue {}                 -type num               -default 1
    setdef options -layout                  -minversion 5       -validvalue formatLayout       -type str               -default "none"
    setdef options -circular                -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::circular $value]
    setdef options -force                   -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::force $value]
    setdef options -roam                    -minversion 5       -validvalue formatRoam         -type str|bool          -default "False"
    setdef options -scaleLimit              -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::scaleLimit $value]
    setdef options -nodeScaleRatio          -minversion 5       -validvalue {}                 -type num               -default 0.6
    setdef options -draggable               -minversion 5       -validvalue {}                 -type bool|null         -default "nothing"
    setdef options -symbol                  -minversion 5       -validvalue formatItemSymbol   -type str|null          -default "nothing"
    setdef options -symbolSize              -minversion 5       -validvalue {}                 -type num|list.d|null   -default "nothing"
    setdef options -symbolOffset            -minversion 5       -validvalue {}                 -type list.d|null       -default "nothing"
    setdef options -symbolRotate            -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -symbolKeepAspect        -minversion 5       -validvalue {}                 -type bool              -default "True"
    setdef options -edgeSymbol              -minversion 5       -validvalue {}                 -type str|list.d|null   -default "nothing"
    setdef options -edgeSymbolSize          -minversion 5       -validvalue {}                 -type num|list.d|null   -default "nothing"
    setdef options -cursor                  -minversion 5       -validvalue formatCursor       -type str|null          -default "pointer"
    setdef options -itemStyle               -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -lineStyle               -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::lineStyle $value]
    setdef options -label                   -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::label $value]
    setdef options -edgeLabel               -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::edgeLabel $value]
    setdef options -labelLayout             -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode -type bool|str|null     -default "False"
    setdef options -categories              -minversion 5       -validvalue {}                 -type list.o|null       -default [ticklecharts::categories $value]
    setdef options -autoCurveness           -minversion 5       -validvalue {}                 -type bool|num|null     -default "nothing"
    setdef options -data                    -minversion 5       -validvalue {}                 -type list.d            -default {}
    setdef options -links                   -minversion 5       -validvalue {}                 -type list.o|null       -default [ticklecharts::linksItem $value -links]
    setdef options -edges                   -minversion 5       -validvalue {}                 -type list.o|null       -default [ticklecharts::linksItem $value -edges]
    setdef options -markPoint               -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -minversion 5       -validvalue {}                 -type num               -default 0
    setdef options -z                       -minversion 5       -validvalue {}                 -type num               -default 2
    setdef options -left                    -minversion 5       -validvalue formatLeft         -type num|str|null      -default "nothing"
    setdef options -top                     -minversion 5       -validvalue formatTop          -type num|str|null      -default "nothing"
    setdef options -right                   -minversion 5       -validvalue formatRight        -type num|str|null      -default "nothing"
    setdef options -bottom                  -minversion 5       -validvalue formatBottom       -type num|str|null      -default "nothing"
    setdef options -width                   -minversion 5       -validvalue {}                 -type num|str|null      -default "nothing"
    setdef options -height                  -minversion 5       -validvalue {}                 -type num|str|null      -default "nothing"
    setdef options -silent                  -minversion 5       -validvalue {}                 -type bool              -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                 -type bool|null         -default "nothing"
    setdef options -animationThreshold      -minversion 5       -validvalue {}                 -type num|null          -default "nothing"
    setdef options -animationDuration       -minversion 5       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing      -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing      -type str|null          -default "nothing"
    setdef options -animationDelayUpdate    -minversion 5       -validvalue {}                 -type num|jsfunc|null   -default "nothing"
    setdef options -tooltip                 -minversion 5       -validvalue {}                 -type dict|null         -default [ticklecharts::tooltip $value]


    if {[dict exists $value -dataGraphItem]} {
        if {[dict exists $value -data]} {
            error "'graph' args cannot contain '-data' and '-dataGraphItem'..."
        }
        setdef options -data  -minversion 5  -validvalue {}  -type list.o  -default [ticklecharts::dataGraphItem $value]
    }

    if {![dict exists $value -data] && ![dict exists $value -dataGraphItem]} {
        error "key '-data' or '-dataGraphItem' not present... for [lindex [info level 0] 0]"
    }

    set value [dict remove $value -circular -force -scaleLimit -itemStyle -lineStyle -label -edgeLabel -labelLayout -emphasis \
                                  -blur -select -categories -links -edges -markPoint -markLine -markArea -dataGraphItem]
                                
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

    setdef options -type              -minWCversion 2        -validvalue {}               -type str            -default "wordCloud"
    setdef options -shape             -minWCversion 2        -validvalue formatWCshape    -type str            -default "circle"
    setdef options -keepAspect        -minWCversion "2.1.0"  -validvalue {}               -type bool|null      -default "nothing"
    setdef options -maskImage         -minWCversion 2        -validvalue {}               -type jsfunc|null    -default "nothing"
    setdef options -left              -minWCversion 2        -validvalue formatLeft       -type num|str|null   -default "center"
    setdef options -top               -minWCversion 2        -validvalue formatTop        -type num|str|null   -default "middle"
    setdef options -right             -minWCversion 2        -validvalue formatRight      -type num|str|null   -default "null"
    setdef options -bottom            -minWCversion 2        -validvalue formatBottom     -type num|str|null   -default "null"
    setdef options -width             -minWCversion 2        -validvalue {}               -type num|str|null   -default "70%"
    setdef options -height            -minWCversion 2        -validvalue {}               -type num|str|null   -default "80%"
    setdef options -sizeRange         -minWCversion 2        -validvalue {}               -type list.n         -default [list {12 60}]
    setdef options -rotationRange     -minWCversion 2        -validvalue {}               -type list.n         -default [list {-90 90}]
    setdef options -rotationStep      -minWCversion 2        -validvalue {}               -type num            -default 45
    setdef options -gridSize          -minWCversion 2        -validvalue {}               -type num            -default 8
    setdef options -drawOutOfBound    -minWCversion "2.1.0"  -validvalue {}               -type bool           -default "False"
    setdef options -shrinkToFit       -minWCversion "2.1.0"  -validvalue {}               -type bool|null      -default "nothing"
    setdef options -layoutAnimation   -minWCversion 2        -validvalue {}               -type bool           -default "True"
    setdef options -textStyle         -minWCversion 2        -validvalue {}               -type dict|null      -default [ticklecharts::textStyle $value -textStyle]
    setdef options -emphasis          -minWCversion 2        -validvalue {}               -type dict|null      -default [ticklecharts::emphasis $value]
    setdef options -data              -minWCversion 2        -validvalue {}               -type list.o         -default [ticklecharts::dataWCItem $value]


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

    setdef options -type                    -minversion 5       -validvalue {}                    -type str               -default "boxplot"
    setdef options -id                      -minversion 5       -validvalue {}                    -type str|null          -default "nothing"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS            -type str               -default "cartesian2d"
    setdef options -xAxisIndex              -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -yAxisIndex              -minversion 5       -validvalue {}                    -type num|null          -default "nothing"
    setdef options -name                    -minversion 5       -validvalue {}                    -type str               -default "boxPlotseries_${index}"
    setdef options -colorBy                 -minversion "5.2.0" -validvalue formatColorBy         -type str               -default "series"
    setdef options -legendHoverLink         -minversion 5       -validvalue {}                    -type bool              -default "True"
    setdef options -hoverAnimation          -minversion 5       -validvalue {}                    -type bool|null         -default "nothing"
    setdef options -layout                  -minversion 5       -validvalue formatOrient          -type str|null          -default "nothing"
    setdef options -boxWidth                -minversion 5       -validvalue {}                    -type list.n            -default [list {7 50}]
    setdef options -itemStyle               -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5       -validvalue formatSelectedMode    -type bool|str|null     -default "nothing"
    setdef options -data                    -minversion 5       -validvalue formatDataBox         -type list.n            -default {}
    setdef options -markPoint               -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markPoint $value]
    setdef options -markLine                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markLine $value]
    setdef options -markArea                -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::markArea $value]
    setdef options -zlevel                  -minversion 5       -validvalue {}                    -type num               -default 0
    setdef options -z                       -minversion 5       -validvalue {}                    -type num               -default 2
    setdef options -silent                  -minversion 5       -validvalue {}                    -type bool              -default "False"
    setdef options -animationDuration       -minversion 5       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5       -validvalue formatAEasing         -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5       -validvalue {}                    -type num|jsfunc|null   -default "nothing"
    setdef options -universalTransition     -minversion "5.2.0" -validvalue {}                    -type dict|null         -default [ticklecharts::universalTransition $value]
    setdef options -tooltip                 -minversion 5       -validvalue {}                    -type dict|null         -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -dataBoxPlotitem]} {
            error "'chart' Class cannot contain '-data' or 'dataBoxPlotitem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -minversion 5  -validvalue {} -type list.d|null  -default "nothing"
        setdef options  -dataGroupId    -minversion 5  -validvalue {} -type str|null     -default "nothing"
        setdef options  -datasetId      -minversion 5  -validvalue {} -type str|null     -default "nothing"
        setdef options  -encode         -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::encode $chart $value]
        setdef options  -datasetIndex   -minversion 5  -validvalue {} -type num|null     -default "nothing"

    }

    if {[dict exists $value -dataBoxPlotitem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-dataBoxPlotitem'..."
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::boxPlotitem $value]
    }
          
    set value [dict remove $value -markPoint -markLine -markArea \
                                  -itemStyle -dataBoxPlotitem \
                                  -emphasis -blur -select -tooltip -encode]
                                
    set options [merge $options $value]

    return $options

}

proc ticklecharts::treeMapseries {index value} {
    # options : https://echarts.apache.org/en/option.html#series-treemap
    #
    # index - index series.
    # value - Options described in proc ticklecharts::treeMapseries below.
    #
    # return dict treeMapseries options

    setdef options -type                    -minversion 5  -validvalue {}                  -type str               -default "treemap"
    setdef options -id                      -minversion 5  -validvalue {}                  -type str|null          -default "nothing"
    setdef options -name                    -minversion 5  -validvalue {}                  -type str               -default "treeMapseries_${index}"
    setdef options -zlevel                  -minversion 5  -validvalue {}                  -type num               -default 0
    setdef options -z                       -minversion 5  -validvalue {}                  -type num               -default 2
    setdef options -left                    -minversion 5  -validvalue formatLeft          -type num|str           -default "center"
    setdef options -top                     -minversion 5  -validvalue formatTop           -type num|str           -default "middle"
    setdef options -right                   -minversion 5  -validvalue formatRight         -type num|str           -default "auto"
    setdef options -bottom                  -minversion 5  -validvalue formatBottom        -type num|str           -default "auto"
    setdef options -width                   -minversion 5  -validvalue {}                  -type num|str           -default "80%"
    setdef options -height                  -minversion 5  -validvalue {}                  -type num|str           -default "80%"
    setdef options -squareRatio             -minversion 5  -validvalue {}                  -type num               -default [expr {0.5 * (1 + sqrt(5))}]
    setdef options -leafDepth               -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options -drillDownIcon           -minversion 5  -validvalue {}                  -type str               -default "▶"
    setdef options -roam                    -minversion 5  -validvalue formatRoam          -type str|bool          -default "True"
    setdef options -nodeClick               -minversion 5  -validvalue formatNodeClick     -type bool|str          -default "zoomToNode"
    setdef options -zoomToNodeRatio         -minversion 5  -validvalue {}                  -type num               -default [expr {0.32 * 0.32}]
    setdef options -visualDimension         -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options -visualMin               -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options -visualMax               -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options -colorAlpha              -minversion 5  -validvalue {}                  -type list.n|null       -default "nothing"
    setdef options -colorSaturation         -minversion 5  -validvalue {}                  -type list.n|null       -default "nothing"
    setdef options -colorMappingBy          -minversion 5  -validvalue formatColorMapping  -type str               -default "index"
    setdef options -visibleMin              -minversion 5  -validvalue {}                  -type num               -default 10
    setdef options -childrenVisibleMin      -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options -label                   -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::label $value]
    setdef options -upperLabel              -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::upperLabel $value]
    setdef options -itemStyle               -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::itemStyle $value]
    setdef options -emphasis                -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::emphasis $value]
    setdef options -blur                    -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::blur $value]
    setdef options -select                  -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::select $value]
    setdef options -selectedMode            -minversion 5  -validvalue formatSelectedMode  -type bool|str|null     -default "False"
    setdef options -breadcrumb              -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::breadcrumb $value]
    setdef options -labelLine               -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::labelLine $value]
    setdef options -labelLayout             -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::labelLayout $value]
    setdef options -levels                  -minversion 5  -validvalue {}                  -type list.o|null       -default [ticklecharts::levelsTreeMapItem $value]
    setdef options -data                    -minversion 5  -validvalue {}                  -type list.o            -default [ticklecharts::treeMapItem $value]
    setdef options -silent                  -minversion 5  -validvalue {}                  -type bool              -default "False"
    setdef options -animationDuration       -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasing         -minversion 5  -validvalue formatAEasing       -type str|null          -default "nothing"
    setdef options -animationDelay          -minversion 5  -validvalue {}                  -type num|jsfunc|null   -default "nothing"
    setdef options -emphasis                -minversion 5  -validvalue {}                  -type dict|null         -default [ticklecharts::emphasisLegend $value]
    setdef options -selector                -minversion 5  -validvalue {}                  -type bool|null         -default "nothing"
    setdef options -selectorPosition        -minversion 5  -validvalue formatSelectorPos   -type str|null          -default "nothing"
    setdef options -selectorItemGap         -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options -selectorButtonGap       -minversion 5  -validvalue {}                  -type num|null          -default "nothing"

    if {![dict exists $value -data]} {
        error "key -data not present... for [lindex [info level 0] 0]"
    }

    set value [dict remove $value -label -upperLabel \
                                  -data -breadcrumb -tooltip \
                                  -labelLine -labelLayout -itemStyle \
                                  -emphasis -blur -select -levels]
    

    set options [merge $options $value]

    return $options
 
}

proc ticklecharts::mapseries {index chart value} {
    # options : https://echarts.apache.org/en/option.html#series-map
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::mapseries below.
    #
    # return dict mapseries options

    setdef options -type                 -minversion 5              -validvalue {}                  -type str                     -default "map"
    setdef options -id                   -minversion 5              -validvalue {}                  -type str|null                -default "nothing"
    setdef options -name                 -minversion 5              -validvalue {}                  -type str                     -default "mapseries_${index}"
    setdef options -colorBy              -minversion "5.2.0"        -validvalue formatColorBy       -type str                     -default "series"
    setdef options -map                  -minversion 5              -validvalue {}                  -type str|null                -default "nothing"
    setdef options -roam                 -minversion 5              -validvalue formatRoam          -type str|bool                -default "True"
    setdef options -projection           -minversion "5.3.0"        -validvalue {}                  -type dict|null               -default [ticklecharts::projection $value]
    setdef options -center               -minversion "5.0.0:5.3.3"  -validvalue {}                  -type list.n|null:list.d|null -default "nothing"
    setdef options -aspectScale          -minversion 5              -validvalue {}                  -type num|null                -default "nothing"
    setdef options -boundingCoords       -minversion 5              -validvalue {}                  -type list.n|null             -default "nothing"
    setdef options -zoom                 -minversion 5              -validvalue {}                  -type num                     -default 1
    setdef options -scaleLimit           -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::scaleLimit $value]
    setdef options -nameMap              -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::nameMap $value]
    setdef options -nameProperty         -minversion 5              -validvalue {}                  -type str|null                -default "nothing"
    setdef options -selectedMode         -minversion 5              -validvalue formatSelectedMode  -type bool|str|null           -default "False"
    setdef options -label                -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::label $value]
    setdef options -itemStyle            -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::itemStyle $value]
    setdef options -emphasis             -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::emphasis $value]
    setdef options -zlevel               -minversion 5              -validvalue {}                  -type num                     -default 0
    setdef options -z                    -minversion 5              -validvalue {}                  -type num                     -default 2
    setdef options -left                 -minversion 5              -validvalue formatLeft          -type num|str|null            -default "nothing"
    setdef options -top                  -minversion 5              -validvalue formatTop           -type num|str|null            -default "nothing"
    setdef options -right                -minversion 5              -validvalue formatRight         -type num|str|null            -default "nothing"
    setdef options -bottom               -minversion 5              -validvalue formatBottom        -type num|str|null            -default "nothing"
    setdef options -layoutCenter         -minversion 5              -validvalue {}                  -type list.d|null             -default "nothing"
    setdef options -layoutSize           -minversion 5              -validvalue {}                  -type num|str|null            -default "nothing"
    setdef options -geoIndex             -minversion 5              -validvalue {}                  -type num|null                -default "nothing"
    setdef options -mapValueCalculation  -minversion 5              -validvalue formatMVCalculation -type str                     -default "sum"
    setdef options -showLegendSymbol     -minversion 5              -validvalue {}                  -type bool|null               -default "nothing"
    setdef options -labelLayout          -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::labelLayout $value]
    setdef options -labelLine            -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::labelLine $value]
    setdef options -data                 -minversion 5              -validvalue {}                  -type list.n|null             -default "nothing"
    setdef options -markPoint            -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::markPoint $value]
    setdef options -markLine             -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::markLine $value]
    setdef options -markArea             -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::markArea $value]
    setdef options -silent               -minversion 5              -validvalue {}                  -type bool                    -default "False"
    setdef options -universalTransition  -minversion "5.2.0"        -validvalue {}                  -type dict|null               -default [ticklecharts::universalTransition $value]
    setdef options -tooltip              -minversion 5              -validvalue {}                  -type dict|null               -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value -dataMapItem]} {
            error "'chart' Class cannot contain '-data' or '-dataMapItem' when a class dataset is present"
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -minversion 5  -validvalue {}                 -type list.d|null      -default "nothing"
        setdef options  -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options  -encode         -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options  -datasetIndex   -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
        setdef options  -dataGroupId    -minversion 5  -validvalue {}                 -type str|null         -default "nothing"

    }
    
    if {[dict exists $value -dataMapItem]} {
        if {[dict exists $value -data]} {
            error "'chart' args cannot contain '-data' and '-dataMapItem'..."
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::mapItem $value]
    }

    set value [dict remove $value -projection -scaleLimit \
                                  -nameMap -label -itemStyle -dataMapItem \
                                  -emphasis -labelLayout -labelLine -tooltip \
                                  -markPoint -markLine -markArea -universalTransition]
    

    set options [merge $options $value]

    return $options
 
}