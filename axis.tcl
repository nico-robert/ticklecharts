# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::radiusAxis {value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -id             -minversion 5       -validvalue {}                  -type str|null            -trace yes  -default "nothing"
    setdef options -polarIndex     -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options -type           -minversion 5       -validvalue formatType          -type str|null            -trace yes  -default "nothing"
    setdef options -name           -minversion 5       -validvalue {}                  -type str|null            -trace no   -default "nothing"
    setdef options -nameLocation   -minversion 5       -validvalue formatNameLocation  -type str|null            -trace no   -default "nothing"
    setdef options -nameTextStyle  -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTextStyle $value]
    setdef options -nameGap        -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options -nameRotate     -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options -nameTruncate   -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTruncate $value]
    setdef options -inverse        -minversion 5       -validvalue {}                  -type bool|null           -trace no   -default "nothing"
    setdef options -boundaryGap    -minversion 5       -validvalue {}                  -type bool|list.d|null    -trace no   -default "nothing"
    setdef options -min            -minversion 5       -validvalue formatMin           -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -max            -minversion 5       -validvalue formatMax           -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -scale          -minversion 5       -validvalue {}                  -type bool|null           -trace yes  -default "nothing"
    setdef options -splitNumber    -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -minInterval    -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -maxInterval    -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -interval       -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -logBase        -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -startValue     -minversion "5.5.1" -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options -silent         -minversion 5       -validvalue {}                  -type bool|null           -trace no   -default "nothing"
    setdef options -triggerEvent   -minversion 5       -validvalue {}                  -type bool|null           -trace yes  -default "nothing"
    setdef options -axisLine       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::splitArea $value]
    setdef options -data           -minversion 5       -validvalue {}                  -type list.d|null         -trace no   -default "nothing"
    setdef options -axisPointer    -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options -z              -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options -tooltip        -minversion "5.6.0" -validvalue {}                  -type dict|null           -trace yes  -default [ticklecharts::tooltip $value]
    #...

    # Both properties item are accepted.
    #   -dataRadiusAxisItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataRadiusAxisItem -dataItem} $value]

    if {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -trace no -default [ticklecharts::axisItem $value $itemKey]
    }

    # remove key(s)...
    set value [dict remove $value -axisLine -axisTick -minorSplitLine -tooltip \
                                  -axisLabel -splitLine -axisPointer \
                                  -splitArea -nameTextStyle -minorTick -nameTruncate $itemKey]

    set options [merge $options $value]

    return $options
}

proc ticklecharts::radarCoordinate {index value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -id           -minversion 5  -validvalue {}               -type str|null       -trace yes  -default "nothing"
    setdef options -zlevel       -minversion 5  -validvalue {}               -type num|null       -trace no   -default "nothing"
    setdef options -z            -minversion 5  -validvalue {}               -type num|null       -trace no   -default "nothing"
    setdef options -center       -minversion 5  -validvalue {}               -type list.d         -trace no   -default [list {"50%" "50%"}]
    setdef options -radius       -minversion 5  -validvalue {}               -type list.d|num|str -trace no   -default "75%"
    setdef options -startAngle   -minversion 5  -validvalue formatStartangle -type num            -trace no   -default 90
    setdef options -axisName     -minversion 5  -validvalue {}               -type dict|null      -trace no   -default [ticklecharts::axisName $value]
    setdef options -nameGap      -minversion 5  -validvalue {}               -type num|null       -trace no   -default 15
    setdef options -splitNumber  -minversion 5  -validvalue {}               -type num|null       -trace no   -default 5
    setdef options -shape        -minversion 5  -validvalue formatShape      -type str            -trace no   -default "polygon"
    setdef options -scale        -minversion 5  -validvalue {}               -type bool|null      -trace no   -default "nothing"
    setdef options -triggerEvent -minversion 5  -validvalue {}               -type bool|null      -trace no   -default "nothing"
    setdef options -axisLine     -minversion 5  -validvalue {}               -type dict|null      -trace no   -default [ticklecharts::axisLine $value]
    setdef options -axisTick     -minversion 5  -validvalue {}               -type dict|null      -trace no   -default [ticklecharts::axisTick $value]
    setdef options -axisLabel    -minversion 5  -validvalue {}               -type dict|null      -trace no   -default [ticklecharts::axisLabel $value]
    setdef options -splitLine    -minversion 5  -validvalue {}               -type dict|null      -trace no   -default [ticklecharts::splitLine $value]
    setdef options -splitArea    -minversion 5  -validvalue {}               -type dict|null      -trace no   -default [ticklecharts::splitArea $value]
    setdef options -indicator    -minversion 5  -validvalue {}               -type list.o         -trace no   -default [ticklecharts::indicatorItem $value]
    #...

    # remove key(s)...
    set value [dict remove $value -axisLine -axisTick \
                                  -axisName -axisLabel -splitLine \
                                  -splitArea -indicatoritem -indicatorItem]

    set options [merge $options $value]

    return $options
}

proc ticklecharts::angleAxis {value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -id             -minversion 5        -validvalue {}               -type str|null            -trace yes  -default "nothing"
    setdef options -polarIndex     -minversion 5        -validvalue {}               -type num|null            -trace no   -default "nothing"
    setdef options -startAngle     -minversion 5        -validvalue formatStartangle -type num                 -trace no   -default 90
    setdef options -endAngle       -minversion "5.5.0"  -validvalue {}               -type num|null            -trace no   -default "nothing"
    setdef options -clockwise      -minversion 5        -validvalue {}               -type bool                -trace no   -default "True"
    setdef options -type           -minversion 5        -validvalue formatType       -type str|null            -trace yes  -default "nothing"
    setdef options -boundaryGap    -minversion 5        -validvalue {}               -type bool|list.d|null    -trace no   -default "nothing"
    setdef options -min            -minversion 5        -validvalue formatMin        -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -max            -minversion 5        -validvalue formatMax        -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -scale          -minversion 5        -validvalue {}               -type bool|null           -trace yes  -default "nothing"
    setdef options -splitNumber    -minversion 5        -validvalue {}               -type num|null            -trace yes  -default "nothing"
    setdef options -minInterval    -minversion 5        -validvalue {}               -type num|null            -trace yes  -default "nothing"
    setdef options -maxInterval    -minversion 5        -validvalue {}               -type num|null            -trace yes  -default "nothing"
    setdef options -interval       -minversion 5        -validvalue {}               -type num|null            -trace yes  -default "nothing"
    setdef options -logBase        -minversion 5        -validvalue {}               -type num|null            -trace yes  -default "nothing"
    setdef options -startValue     -minversion "5.5.1"  -validvalue {}               -type num|null            -trace no   -default "nothing"
    setdef options -silent         -minversion 5        -validvalue {}               -type bool|null           -trace no   -default "nothing"
    setdef options -triggerEvent   -minversion 5        -validvalue {}               -type bool|null           -trace yes  -default "nothing"
    setdef options -axisLine       -minversion 5        -validvalue {}               -type dict|null           -trace no   -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -minversion 5        -validvalue {}               -type dict|null           -trace no   -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -minversion 5        -validvalue {}               -type dict|null           -trace no   -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -minversion 5        -validvalue {}               -type dict|null           -trace no   -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -minversion 5        -validvalue {}               -type dict|null           -trace no   -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -minversion 5        -validvalue {}               -type dict|null           -trace no   -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -minversion 5        -validvalue {}               -type dict|null           -trace no   -default [ticklecharts::splitArea $value]
    setdef options -data           -minversion 5        -validvalue {}               -type list.d|null         -trace no   -default "nothing"
    setdef options -axisPointer    -minversion 5        -validvalue {}               -type dict|null           -trace no   -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -minversion 5        -validvalue {}               -type num|null            -trace no   -default "nothing"
    setdef options -z              -minversion 5        -validvalue {}               -type num|null            -trace no   -default "nothing"
    setdef options -tooltip        -minversion "5.6.0"  -validvalue {}               -type dict|null           -trace yes  -default [ticklecharts::tooltip $value]
    #...

    # Both properties item are accepted.
    #   -dataAngleAxisItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataAngleAxisItem -dataItem} $value]

    if {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -trace no -default [ticklecharts::axisItem $value $itemKey]
    }

    # remove key(s)...
    set value [dict remove $value -axisLine -axisTick -tooltip \
                                  -minorTick -axisLabel -splitLine \
                                  -minorSplitLine -splitArea -axisPointer $itemKey]

    set options [merge $options $value]

    return $options
}

proc ticklecharts::xAxis {index chart value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -id             -minversion 5       -validvalue {}                  -type str|null            -trace yes  -default "nothing"
    setdef options -show           -minversion 5       -validvalue {}                  -type bool                -trace no   -default "True"
    setdef options -type           -minversion 5       -validvalue formatType          -type str|null            -trace yes  -default "category"
    setdef options -data           -minversion 5       -validvalue {}                  -type list.d|null         -trace yes  -default "nothing"
    setdef options -gridIndex      -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -alignTicks     -minversion "5.3.0" -validvalue {}                  -type bool|null           -trace yes  -default "nothing"
    setdef options -position       -minversion 5       -validvalue formatXAxisPosition -type str                 -trace no   -default "bottom"
    setdef options -offset         -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -name           -minversion 5       -validvalue {}                  -type str|null            -trace no   -default "nothing"
    setdef options -nameLocation   -minversion 5       -validvalue formatNameLocation  -type str                 -trace no   -default "end"
    setdef options -nameTextStyle  -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTextStyle $value]
    setdef options -nameGap        -minversion 5       -validvalue {}                  -type num                 -trace no   -default 15
    setdef options -nameRotate     -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -nameTruncate   -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTruncate $value]
    setdef options -inverse        -minversion 5       -validvalue {}                  -type bool                -trace no   -default "False"
    setdef options -boundaryGap    -minversion 5       -validvalue {}                  -type bool|list.d         -trace no   -default "True"
    setdef options -min            -minversion 5       -validvalue formatMin           -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -max            -minversion 5       -validvalue formatMax           -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -scale          -minversion 5       -validvalue {}                  -type bool                -trace yes  -default "False"
    setdef options -splitNumber    -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -minInterval    -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -maxInterval    -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -interval       -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -logBase        -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -startValue     -minversion "5.5.1" -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options -silent         -minversion 5       -validvalue {}                  -type bool                -trace no   -default "False"
    setdef options -triggerEvent   -minversion 5       -validvalue {}                  -type bool                -trace yes  -default "False"
    setdef options -axisLine       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::splitArea $value]
    setdef options -axisPointer    -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -z              -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -tooltip        -minversion "5.6.0" -validvalue {}                  -type dict|null           -trace yes  -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    # Both properties item are accepted.
    #   -dataXAxisItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataXAxisItem -dataItem} $value]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value $itemKey]} {
            error "'chart' object cannot contains '-data', '-dataItem' or '-dataXAxisItem'\
                    when a class dataset is defined."
        }
    } elseif {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -trace no -default [ticklecharts::axisItem $value $itemKey]
    }

    # remove key(s)...
    set value [dict remove $value -nameTextStyle -axisLine -axisTick -tooltip \
                                  -minorTick -axisLabel -splitLine \
                                  -minorSplitLine -splitArea -axisPointer -nameTruncate $itemKey]

    set options [merge $options $value]

    return $options
}

proc ticklecharts::yAxis {index chart value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -id              -minversion 5       -validvalue {}                  -type str|null            -trace yes  -default "nothing"
    setdef options -show            -minversion 5       -validvalue {}                  -type bool                -trace no   -default "True"
    setdef options -gridIndex       -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -alignTicks      -minversion "5.3.0" -validvalue {}                  -type bool|null           -trace yes  -default "nothing"
    setdef options -position        -minversion 5       -validvalue formatYAxisPosition -type str                 -trace no   -default "left"
    setdef options -offset          -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -realtimeSort    -minversion 5       -validvalue {}                  -type bool                -trace no   -default "True"
    setdef options -sortSeriesIndex -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -type            -minversion 5       -validvalue formatType          -type str|null            -trace yes  -default "value"
    setdef options -data            -minversion 5       -validvalue {}                  -type list.d|null         -trace yes  -default "nothing"
    setdef options -name            -minversion 5       -validvalue {}                  -type str|null            -trace no   -default "nothing"
    setdef options -nameLocation    -minversion 5       -validvalue formatNameLocation  -type str                 -trace no   -default "end"
    setdef options -nameTextStyle   -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTextStyle $value]
    setdef options -nameGap         -minversion 5       -validvalue {}                  -type num                 -trace no   -default 15
    setdef options -nameRotate      -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -nameTruncate    -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTruncate $value]
    setdef options -inverse         -minversion 5       -validvalue {}                  -type bool                -trace no   -default "False"
    setdef options -boundaryGap     -minversion 5       -validvalue {}                  -type bool|list.s         -trace no   -default "False"
    setdef options -min             -minversion 5       -validvalue formatMin           -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -max             -minversion 5       -validvalue formatMax           -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -scale           -minversion 5       -validvalue {}                  -type bool                -trace yes  -default "False"
    setdef options -splitNumber     -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -minInterval     -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -maxInterval     -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -interval        -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -logBase         -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
    setdef options -startValue      -minversion "5.5.1" -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options -silent          -minversion 5       -validvalue {}                  -type bool                -trace no   -default "False"
    setdef options -triggerEvent    -minversion 5       -validvalue {}                  -type bool                -trace yes  -default "False"
    setdef options -axisLine        -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLine $value]
    setdef options -axisTick        -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisTick $value]
    setdef options -minorTick       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::minorTick $value]
    setdef options -axisLabel       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLabel $value]
    setdef options -splitLine       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine  -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::splitArea $value]
    setdef options -axisPointer     -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisPointer $value]
    setdef options -zlevel          -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -z               -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
    setdef options -tooltip         -minversion "5.6.0" -validvalue {}                  -type dict|null           -trace yes  -default [ticklecharts::tooltip $value]

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    # Both properties item are accepted.
    #   -dataYAxisItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataYAxisItem -dataItem} $value]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value $itemKey]} {
            error "'chart' object cannot contains '-data', '-dataItem' or '-dataYAxisItem'\
                    when a class dataset is defined."
        }
    } elseif {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -trace no -default [ticklecharts::axisItem $value $itemKey]
    }

    # remove key(s)...
    set value [dict remove $value -nameTextStyle -axisLine -axisTick -tooltip \
                                  -minorTick -axisLabel -splitLine \
                                  -minorSplitLine -splitArea -axisPointer -nameTruncate $itemKey]

    set options [merge $options $value]

    return $options
}

proc ticklecharts::singleAxis {value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -id             -minversion 5       -validvalue {}                 -type str|null            -trace yes  -default "nothing"
    setdef options -zlevel         -minversion 5       -validvalue {}                 -type num                 -trace no   -default 0
    setdef options -z              -minversion 5       -validvalue {}                 -type num                 -trace no   -default 2
    setdef options -left           -minversion 5       -validvalue formatLeft         -type num|str             -trace no   -default "5%"
    setdef options -top            -minversion 5       -validvalue formatTop          -type num|str             -trace no   -default "5%"
    setdef options -right          -minversion 5       -validvalue formatRight        -type num|str             -trace no   -default "5%"
    setdef options -bottom         -minversion 5       -validvalue formatBottom       -type num|str             -trace no   -default "5%"
    setdef options -width          -minversion 5       -validvalue {}                 -type num|str             -trace no   -default "auto"
    setdef options -height         -minversion 5       -validvalue {}                 -type num|str             -trace no   -default "auto"
    setdef options -orient         -minversion 5       -validvalue formatOrient       -type str                 -trace no   -default "horizontal"
    setdef options -type           -minversion 5       -validvalue formatType         -type str|null            -trace yes  -default "value"
    setdef options -name           -minversion 5       -validvalue {}                 -type str|null            -trace no   -default "nothing"
    setdef options -nameLocation   -minversion 5       -validvalue formatNameLocation -type str                 -trace no   -default "end"
    setdef options -nameTextStyle  -minversion 5       -validvalue {}                 -type dict|null           -trace no   -default [ticklecharts::nameTextStyle $value]
    setdef options -nameGap        -minversion 5       -validvalue {}                 -type num                 -trace no   -default 15
    setdef options -nameRotate     -minversion 5       -validvalue {}                 -type num                 -trace no   -default 0
    setdef options -nameTruncate   -minversion 5       -validvalue {}                 -type dict|null           -trace no   -default [ticklecharts::nameTruncate $value]
    setdef options -inverse        -minversion 5       -validvalue {}                 -type bool                -trace no   -default "False"
    setdef options -boundaryGap    -minversion 5       -validvalue {}                 -type bool|list.d         -trace no   -default "True"
    setdef options -min            -minversion 5       -validvalue formatMin          -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -max            -minversion 5       -validvalue formatMax          -type num|str|jsfunc|null -trace yes  -default "nothing"
    setdef options -scale          -minversion 5       -validvalue {}                 -type bool|null           -trace yes  -default "nothing"
    setdef options -splitNumber    -minversion 5       -validvalue {}                 -type num|null            -trace yes  -default "nothing"
    setdef options -minInterval    -minversion 5       -validvalue {}                 -type num|null            -trace yes  -default "nothing"
    setdef options -maxInterval    -minversion 5       -validvalue {}                 -type num|null            -trace yes  -default "nothing"
    setdef options -interval       -minversion 5       -validvalue {}                 -type num|null            -trace yes  -default "nothing"
    setdef options -logBase        -minversion 5       -validvalue {}                 -type num|null            -trace yes  -default "nothing"
    setdef options -startValue     -minversion "5.5.1" -validvalue {}                 -type num|null            -trace no   -default "nothing"
    setdef options -silent         -minversion 5       -validvalue {}                 -type bool                -trace no   -default "False"
    setdef options -triggerEvent   -minversion 5       -validvalue {}                 -type bool                -trace no   -default "False"
    setdef options -axisPointer    -minversion 5       -validvalue {}                 -type dict|null           -trace no   -default [ticklecharts::axisPointer $value]
    setdef options -axisTick       -minversion 5       -validvalue {}                 -type dict|null           -trace no   -default [ticklecharts::axisTick $value]
    setdef options -axisLabel      -minversion 5       -validvalue {}                 -type dict|null           -trace no   -default [ticklecharts::axisLabel $value]
    # ...

    # remove key(s)...
    set value [dict remove $value -nameTextStyle -axisTick -axisLabel -axisPointer -nameTruncate]

    set options [merge $options $value]

    return $options
}

proc ticklecharts::parallelAxis {value} {

    set setopts {}
    foreach line [split [info body ticklecharts::parallelAxis] "\n"] {
        if {[string match {*-minversion [0-9]*} $line]} {
            # Adds minus sign to key to control 
            # Simply to check whether properties with a minus sign are also accepted.
            lappend setopts [list setdef options -[lindex $line 2] -minversion {} -validvalue {} -type null -default "nothing"]
        }
    }

    foreach item $value {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        # Inserts properties with minus sign.
        foreach val $setopts {{*}$val}

        # Removes minus sign at the beginning of the item key.
        # Note: both are accepted.
        foreach {key info} $item {
            if {[string range $key 0 0] eq "-"} {
                set item   [dict remove $item $key]
                set newkey [string range $key 1 end]
                dict set item $newkey $info
            }
        }

        setdef options id              -minversion 5       -validvalue {}                  -type str|null            -trace yes  -default "nothing"
        setdef options dim             -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
        setdef options parallelIndex   -minversion 5       -validvalue {}                  -type num                 -trace no   -default 0
        setdef options realtime        -minversion 5       -validvalue {}                  -type bool                -trace no   -default "True"
        setdef options areaSelectStyle -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::areaSelectStyle $item]
        setdef options type            -minversion 5       -validvalue formatType          -type str|null            -trace yes  -default "value"
        setdef options name            -minversion 5       -validvalue {}                  -type str|null            -trace no   -default "nothing"
        setdef options nameLocation    -minversion 5       -validvalue formatNameLocation  -type str|null            -trace no   -default "end"
        setdef options nameTextStyle   -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTextStyle $item]
        setdef options nameGap         -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
        setdef options nameRotate      -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
        setdef options nameTruncate    -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTruncate $value]
        setdef options inverse         -minversion 5       -validvalue {}                  -type bool|null           -trace no   -default "nothing"
        setdef options boundaryGap     -minversion 5       -validvalue {}                  -type bool|list.d|null    -trace no   -default "nothing"
        setdef options min             -minversion 5       -validvalue formatMin           -type num|str|jsfunc|null -trace yes  -default "nothing"
        setdef options max             -minversion 5       -validvalue formatMax           -type num|str|jsfunc|null -trace yes  -default "nothing"
        setdef options scale           -minversion 5       -validvalue {}                  -type bool|null           -trace yes  -default "nothing"
        setdef options splitNumber     -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
        setdef options minInterval     -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
        setdef options maxInterval     -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
        setdef options interval        -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
        setdef options logBase         -minversion 5       -validvalue {}                  -type num|null            -trace yes  -default "nothing"
        setdef options startValue      -minversion "5.5.1" -validvalue {}                  -type num|null            -trace no   -default "nothing"
        setdef options silent          -minversion 5       -validvalue {}                  -type bool|null           -trace no   -default "nothing"
        setdef options triggerEvent    -minversion 5       -validvalue {}                  -type bool|null           -trace yes  -default "nothing"
        setdef options axisLine        -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLine $item]
        setdef options axisTick        -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisTick $item]
        setdef options minorTick       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::minorTick $item]
        setdef options axisLabel       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLabel $item]
        setdef options data            -minversion 5       -validvalue {}                  -type list.d|null         -trace no   -default "nothing"
        setdef options tooltip         -minversion "5.6.0" -validvalue {}                  -type dict|null           -trace yes  -default [ticklecharts::tooltip $item]
        #...

        # Both properties item are accepted.
        #   -dataParallelAxisItem
        #   -dataItem
        set itemKey [ticklecharts::itemKey {dataParallelAxisItem dataItem} $item]

        if {[dict exists $item $itemKey]} {
            if {[dict exists $item data]} {
                error "'chart' object cannot contains 'data' and '$itemKey'... for\
                    '[ticklecharts::getLevelProperties [info level]]'"
            }
            setdef options data -minversion 5  -validvalue {} -type list.o -trace no -default [ticklecharts::axisItem $item $itemKey]
        }

        # remove key(s)...
        set item [dict remove $item areaSelectStyle nameTextStyle \
                              axisLine axisTick minorTick axisLabel \
                              nameTruncate $itemKey tooltip]

        lappend opts [merge $options $item]
        set options {}

    }

    return $opts
}