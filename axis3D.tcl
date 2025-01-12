# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::xAxis3D {value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -show           -minversion 5  -validvalue {}          -type bool|null     -default "True"
    setdef options -name           -minversion 5  -validvalue {}          -type str|null      -default "X"
    setdef options -grid3DIndex    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -nameTextStyle  -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::nameTextStyle3D $value]
    setdef options -nameGap        -minversion 5  -validvalue {}          -type num|null      -default 20
    setdef options -type           -minversion 5  -validvalue formatType  -type str|null      -default "value"
    setdef options -min            -minversion 5  -validvalue formatMin   -type num|str|null  -default "nothing"
    setdef options -max            -minversion 5  -validvalue formatMax   -type num|str|null  -default "nothing"
    setdef options -scale          -minversion 5  -validvalue {}          -type bool|null     -default "False"
    setdef options -splitNumber    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -minInterval    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -interval       -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -logBase        -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -data           -minversion 5  -validvalue {}          -type list.d|null   -default "nothing"
    setdef options -axisLine       -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisLine3D $value]
    setdef options -axisLabel      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisLabel3D $value]
    setdef options -axisTick       -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisTick3D $value]
    setdef options -splitLine      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::splitLine3D $value]
    setdef options -splitArea      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::splitArea3D $value]
    setdef options -axisPointer    -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisPointer3D $value]
    #...

    # Both properties item are accepted.
    #   -dataXAxis3DItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataXAxis3DItem -dataItem} $value]

    if {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart3D' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -trace no -default [ticklecharts::axis3DItem $value $itemKey]
    }

    # remove key(s)...
    set value [dict remove $value -axisLine -axisTick \
                                  -axisLabel -splitLine -axisPointer \
                                  -splitArea -nameTextStyle $itemKey]

    set options [merge $options $value]
    
    return $options
}

proc ticklecharts::yAxis3D {value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -show           -minversion 5  -validvalue {}          -type bool|null     -default "True"
    setdef options -name           -minversion 5  -validvalue {}          -type str|null      -default "Y"
    setdef options -grid3DIndex    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -nameTextStyle  -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::nameTextStyle3D $value]
    setdef options -nameGap        -minversion 5  -validvalue {}          -type num|null      -default 20
    setdef options -type           -minversion 5  -validvalue formatType  -type str|null      -default "value"
    setdef options -min            -minversion 5  -validvalue formatMin   -type num|str|null  -default "nothing"
    setdef options -max            -minversion 5  -validvalue formatMax   -type num|str|null  -default "nothing"
    setdef options -scale          -minversion 5  -validvalue {}          -type bool|null     -default "False"
    setdef options -splitNumber    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -minInterval    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -interval       -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -logBase        -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -data           -minversion 5  -validvalue {}          -type list.d|null   -default "nothing"
    setdef options -axisLine       -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisLine3D $value]
    setdef options -axisLabel      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisLabel3D $value]
    setdef options -axisTick       -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisTick3D $value]
    setdef options -splitLine      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::splitLine3D $value]
    setdef options -splitArea      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::splitArea3D $value]
    setdef options -axisPointer    -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisPointer3D $value]
    #...

    # Both properties item are accepted.
    #   -dataYAxis3DItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataYAxis3DItem -dataItem} $value]

    if {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart3D' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -trace no -default [ticklecharts::axis3DItem $value $itemKey]
    }


    # remove key(s)...
    set value [dict remove $value -axisLine -axisTick \
                                  -axisLabel -splitLine -axisPointer \
                                  -splitArea -nameTextStyle $itemKey]

    set options [merge $options $value]
    
    return $options
}

proc ticklecharts::zAxis3D {value} {

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -show           -minversion 5  -validvalue {}          -type bool|null     -default "True"
    setdef options -name           -minversion 5  -validvalue {}          -type str|null      -default "Z"
    setdef options -grid3DIndex    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -nameTextStyle  -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::nameTextStyle3D $value]
    setdef options -nameGap        -minversion 5  -validvalue {}          -type num|null      -default 20
    setdef options -type           -minversion 5  -validvalue formatType  -type str|null      -default "value"
    setdef options -min            -minversion 5  -validvalue formatMin   -type num|str|null  -default "nothing"
    setdef options -max            -minversion 5  -validvalue formatMax   -type num|str|null  -default "nothing"
    setdef options -scale          -minversion 5  -validvalue {}          -type bool|null     -default "False"
    setdef options -splitNumber    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -minInterval    -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -interval       -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -logBase        -minversion 5  -validvalue {}          -type num|null      -default "nothing"
    setdef options -data           -minversion 5  -validvalue {}          -type list.d|null   -default "nothing"
    setdef options -axisLine       -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisLine3D $value]
    setdef options -axisLabel      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisLabel3D $value]
    setdef options -axisTick       -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisTick3D $value]
    setdef options -splitLine      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::splitLine3D $value]
    setdef options -splitArea      -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::splitArea3D $value]
    setdef options -axisPointer    -minversion 5  -validvalue {}          -type dict|null     -default [ticklecharts::axisPointer3D $value]
    #...

    # Both properties item are accepted.
    #   -dataZAxis3DItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataZAxis3DItem -dataItem} $value]

    if {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart3D' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -trace no -default [ticklecharts::axis3DItem $value $itemKey]
    }

    # remove key(s)...
    set value [dict remove $value -axisLine -axisTick \
                                  -axisLabel -splitLine -axisPointer \
                                  -splitArea -nameTextStyle $itemKey]

    set options [merge $options $value]
    
    return $options
}