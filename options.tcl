# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.

namespace eval ticklecharts {}

proc ticklecharts::BarItem {value} {

    if {![dict exists $value -databaritem]} {
        error "key -databaritem not present..."
    }

    foreach item [dict get $value -databaritem] {

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        if {[llength $item] % 2} {
            error "item must be even..."
        }

        setdef options name             -type str|null    -default "nothing"
        setdef options value            -type num|null    -default "nothing"
        setdef options symbol           -type str         -default [dict get $::ticklecharts::opts_theme symbol]
        setdef options symbolSize       -type num         -default [dict get $::ticklecharts::opts_theme symbolSize]
        setdef options symbolRotate     -type num|null    -default "nothing"
        setdef options symbolKeepAspect -type bool        -default "False"
        setdef options symbolOffset     -type list.n|null -default "nothing"
        setdef options label            -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine        -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle        -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis         -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip          -type dict|null   -default "nothing"

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::LineItem {value} {

    if {![dict exists $value -datalineitem]} {
        error "key -datalineitem not present..."
    }

    foreach item [dict get $value -datalineitem] {

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        if {[llength $item] % 2} {
            error "item must be even..."
        }

        setdef options name             -type str|null    -default "nothing"
        setdef options value            -type num|null    -default "nothing"
        setdef options symbol           -type str         -default [dict get $::ticklecharts::opts_theme symbol]
        setdef options symbolSize       -type num         -default [dict get $::ticklecharts::opts_theme symbolSize]
        setdef options symbolRotate     -type num|null    -default "nothing"
        setdef options symbolKeepAspect -type bool        -default "False"
        setdef options symbolOffset     -type list.n|null -default "nothing"
        setdef options label            -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine        -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle        -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis         -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip          -type dict|null   -default "nothing"

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::PieItem {value} {

    if {![dict exists $value -datapieitem]} {
        error "key -datapieitem not present..."
    }

    foreach item [dict get $value -datapieitem] {

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        if {[llength $item] % 2} {
            error "item must be even..."
        }

        setdef options name             -type str|null    -default "nothing"
        setdef options value            -type num|null    -default "nothing"
        setdef options groupId          -type num|null    -default "nothing"
        setdef options selected         -type bool        -default "False"
        setdef options label            -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine        -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle        -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis         -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip          -type dict|null   -default "nothing"

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::FunnelItem {value} {

    if {![dict exists $value -datafunnelitem]} {
        error "key -datafunnelitem not present..."
    }

    foreach item [dict get $value -datafunnelitem] {

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        if {[llength $item] % 2} {
            error "item must be even..."
        }

        setdef options name      -type str|null  -default "nothing"
        setdef options value     -type num|null  -default "nothing"
        setdef options label     -type dict|null -default [ticklecharts::label $item]
        setdef options labelLine -type dict|null -default [ticklecharts::labelLine $item]
        setdef options itemStyle -type dict|null -default [ticklecharts::itemStyle $item]
        setdef options emphasis  -type dict|null -default [ticklecharts::emphasis $item]
        setdef options blur      -type dict|null -default [ticklecharts::blur $item]
        setdef options select    -type dict|null -default [ticklecharts::select $item]
        setdef options tooltip   -type dict|null -default "nothing"

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::RichItem {value} {

    if {![dict exists $value richitem]} {
        return "nothing"
    }

    foreach {key item} [dict get $value richitem] {

        if {[llength $item] % 2} {
            error "item must be even..."
        }

        setdef options color                -type str|null            -default "#fff"
        setdef options fontStyle            -type str|null            -default "normal"
        setdef options fontWeight           -type str|null            -default "normal"
        setdef options fontFamily           -type str|null            -default "sans-serif"
        setdef options fontSize             -type num|null            -default 12
        setdef options align                -type str|null            -default "nothing"
        setdef options verticalAlign        -type str|null            -default "nothing"
        setdef options lineHeight           -type num|null            -default "nothing"

        if {[dict exists $item backgroundColor image]} {
            set val [dict get $item backgroundColor image]
            set type [Type $val] ; # type value (should be a string...)
            set val [ticklecharts::MapSpaceString $val] ; # spaces in path... ??
            setdef options backgroundColor -type dict -default [dict create image [list $val $type]]
            set item [dict remove $item backgroundColor] ; # remove key image
        } else {
            setdef options backgroundColor  -type str|null  -default "nothing"
        }

        setdef options borderColor          -type str|null            -default "nothing"
        setdef options borderWidth          -type num|null            -default "nothing"
        setdef options borderType           -type str|null            -default "solid"
        setdef options borderDashOffset     -type num|null            -default "nothing"
        setdef options borderRadius         -type num|list.n|null     -default "nothing"
        setdef options padding              -type num|list.n|null     -default "nothing"
        setdef options shadowColor          -type str|null            -default "nothing"
        setdef options shadowBlur           -type num|null            -default "nothing"
        setdef options shadowOffsetX        -type num|null            -default "nothing"
        setdef options shadowOffsetY        -type num|null            -default "nothing"
        setdef options width                -type num|str|null        -default "nothing"
        setdef options height               -type num|str|null        -default "nothing"
        setdef options textBorderColor      -type str|null            -default "nothing"
        setdef options textBorderWidth      -type num|null            -default "nothing"
        setdef options textBorderType       -type str|num|list.n|null -default "solid"
        setdef options textBorderDashOffset -type num|null            -default "nothing"
        setdef options textShadowColor      -type str|null            -default "transparent"
        setdef options textShadowOffsetX    -type num|null            -default "nothing"
        setdef options textShadowOffsetY    -type num|null            -default "nothing"

        lappend opts $key [list [merge $options $item] dict]
        set options {}

    }

    return [dict create {*}$opts]

}

proc ticklecharts::markAreaItem {value} {

    if {![dict exists $value data]} {
        return "nothing"
    }

    foreach listitem [dict get $value data] {

        if {[llength $listitem] != 2} {
            error "should be a list of 2 elements..."
        }

        set subopts {}

        foreach item $listitem {

            if {[llength $item] % 2} {
                error "item must be even..."
            }

            setdef options type       -type str|null     -default "nothing"
            setdef options valueIndex -type num|null     -default 0
            setdef options valueDim   -type str|null     -default "nothing"
            setdef options coord      -type list.d|null  -default "nothing"
            setdef options name       -type str|null     -default "nothing"
            setdef options x          -type num|str|null -default "nothing"
            setdef options y          -type num|str|null -default "nothing"
            setdef options xAxis      -type str|null     -default "nothing"
            setdef options value      -type num|null     -default "nothing"
            setdef options itemStyle  -type dict|null    -default [ticklecharts::itemStyle $item]
            setdef options label      -type dict|null    -default [ticklecharts::label $item]
            setdef options emphasis   -type dict|null    -default [ticklecharts::emphasis $item]
            setdef options blur       -type dict|null    -default [ticklecharts::blur $item]

            lappend subopts [merge $options $item]
            set options {} 
        }

        lappend opts [list $subopts list.o]

    }

    return [list {*}$opts]

}

proc ticklecharts::piecesItem {value} {

    if {![dict exists $value pieces]} {
        return "nothing"
    }

    foreach item [dict get $value pieces] {

        if {[llength $item] % 2} {
            error "item must be even..."
        }

        setdef options label -type str|null -default "nothing"
        setdef options value -type num|null -default "nothing"
        setdef options color -type str|null -default "nothing"
        setdef options min   -type num|null -default "nothing"
        setdef options max   -type num|null -default "nothing"
        setdef options gt    -type num|null -default "nothing"
        setdef options gte   -type num|null -default "nothing"
        setdef options lt    -type num|null -default "nothing"
        setdef options lte   -type num|null -default "nothing"
        
        lappend opts [merge $options $item]
        set options {}

    }
    
    return [list {*}$opts]

}

proc ticklecharts::markPointItem {value} {

    if {![dict exists $value data]} {
        return "nothing"
    }
    
    foreach info [dict get $value data] {

        set d [dict create -data $info]

        setdef options name       -type str|null        -default "nothing"
        setdef options type       -type str|null        -default "nothing"
        setdef options valueIndex -type num|null        -default "nothing"
        setdef options valueDim   -type str|null        -default "nothing"
        setdef options coord      -type list.n|null     -default "nothing"
        setdef options xAxis      -type num|null        -default "nothing"
        setdef options yAxis      -type num|null        -default "nothing"
        setdef options value      -type num|null        -default "nothing"
        setdef options symbol     -type str|null        -default "nothing"
        setdef options symbolSize -type num|list.n|null -default "nothing"
        setdef options itemStyle  -type dict|null       -default [ticklecharts::itemStyle [dict get $d -data]]
        setdef options label      -type dict|null       -default [ticklecharts::label [dict get $d -data]]
        
        if {[dict exists [dict get $d -data] emphasis]} {
            set dico [dict get $d -data]
            dict set dico emphasis scale "nothing"
            dict set dico emphasis focus "nothing"
            dict set dico emphasis blurScope "nothing"
            dict set dico emphasis labelLine "nothing"
            dict set dico emphasis lineStyle "nothing"
            dict set dico emphasis areaStyle "nothing"
            dict set dico emphasis endLabel  "nothing"
            dict set d -markPoint $dico
        }
        
        setdef options emphasis                -type dict|null       -default [ticklecharts::emphasis [dict get $d -data]]
        setdef options animation               -type bool|null       -default "nothing"
        setdef options animationThreshold      -type num|null        -default "nothing"
        setdef options animationDuration       -type num|jsfunc|null -default "nothing"
        setdef options animationEasing         -type str|null        -default "nothing"
        setdef options animationDelay          -type num|jsfunc|null -default "nothing"
        setdef options animationDurationUpdate -type num|jsfunc|null -default "nothing"
        setdef options animationEasingUpdate   -type str|null        -default "nothing"
        setdef options animationDelayUpdate    -type num|jsfunc|null -default "nothing"
        

        lappend opts [merge $options [dict get $d -data]]
        set options {}
    }

    return [list {*}$opts]

}

proc ticklecharts::itemStyle {value} {

    if {[dict exists $value itemStyle]} {
        set key "itemStyle"
    } elseif {[dict exists $value -itemStyle]} {
        set key "-itemStyle"
    } else {
        return "nothing"
    }
    
    lassign [info level 2] proc
    
    setdef options color            -type str|jsfunc|null -default "nothing"
    setdef options borderColor      -type str|null        -default "rgb(0, 0, 0)"
    setdef options borderWidth      -type num|null        -default 0
    setdef options borderType       -type str|num|list.n  -default "solid"
    setdef options borderDashOffset -type num|null        -default 0
    setdef options borderCap        -type str             -default "butt"
    setdef options borderJoin       -type str             -default "bevel"
    setdef options borderMiterLimit -type num             -default 10
    setdef options shadowBlur       -type num|null        -default "nothing"
    setdef options shadowColor      -type str|null        -default "nothing"
    setdef options shadowOffsetX    -type num|null        -default "nothing"
    setdef options shadowOffsetY    -type num|null        -default "nothing"
    setdef options opacity          -type num|null        -default 1
    setdef options decal            -type dict|null       -default "nothing"
    #...
    
    if {$proc eq "ticklecharts::legend"} {
        set options [dict remove $options color borderColor borderWidth \
                                          borderDashOffset borderCap \
                                          borderJoin borderMiterLimit \
                                          opacity]
        setdef options color            -type str|jsfunc|null -default "inherit"
        setdef options borderColor      -type str|null        -default "inherit"
        setdef options borderWidth      -type str|num|null    -default "auto"
        setdef options borderDashOffset -type str|num|null    -default "inherit"
        setdef options borderCap        -type str             -default "inherit"
        setdef options borderJoin       -type str             -default "inherit"
        setdef options borderMiterLimit -type num|str         -default "inherit"
        setdef options opacity          -type str|num|null    -default "inherit"
    }

    if {$proc eq "ticklecharts::pieseries"} {
        setdef options borderRadius -type str|num|list.d|null  -default "nothing"
    }
    
    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::emphasis {value} {

    if {[dict exists $value emphasis]} {
        set key "emphasis"
    } elseif {[dict exists $value -emphasis]} {
        set key "-emphasis"
    } else {
        return "nothing"
    }

    setdef options scale     -type bool|null -default "True"
    setdef options focus     -type str|null  -default "none"
    setdef options blurScope -type str|null  -default "coordinateSystem"
    setdef options label     -type dict|null -default [ticklecharts::label     [dict get $value $key]]
    setdef options labelLine -type dict|null -default [ticklecharts::labelLine [dict get $value $key]]
    setdef options itemStyle -type dict|null -default [ticklecharts::itemStyle [dict get $value $key]]
    setdef options lineStyle -type dict|null -default [ticklecharts::lineStyle [dict get $value $key]]
    setdef options areaStyle -type dict|null -default [ticklecharts::areaStyle [dict get $value $key]]
    setdef options endLabel  -type dict|null -default [ticklecharts::endLabel  [dict get $value $key]]
    #...

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::markPoint {value} {

    if {![dict exists $value -markPoint]} {
        return "nothing"
    }
    

    setdef options symbol           -type str         -default "pin"
    setdef options symbolSize       -type num|list.n  -default 50
    setdef options symbolRotate     -type num|null    -default "nothing"
    setdef options symbolKeepAspect -type bool        -default "False"
    setdef options symbolOffset     -type list.d|null -default "nothing"
    setdef options silent           -type bool        -default "False"
    setdef options label            -type dict|null   -default [ticklecharts::label     [dict get $value -markPoint]]
    setdef options itemStyle        -type dict|null   -default [ticklecharts::itemStyle [dict get $value -markPoint]]
    
    if {[dict exists [dict get $value -markPoint] emphasis]} {
        set d [dict get $value -markPoint]
        dict set d emphasis scale "nothing"
        dict set d emphasis focus "nothing"
        dict set d emphasis blurScope "nothing"
        dict set d emphasis labelLine "nothing"
        dict set d emphasis lineStyle "nothing"
        dict set d emphasis areaStyle "nothing"
        dict set d emphasis endLabel  "nothing"
        dict set value -markPoint $d
    }
    
    setdef options emphasis -type dict|null -default [ticklecharts::emphasis [dict get $value -markPoint]]
    
    if {[dict exists [dict get $value -markPoint] blur]} {
        set d [dict get $value -markPoint]
        dict set d blur labelLine "nothing"
        dict set d blur lineStyle "nothing"
        dict set d blur areaStyle "nothing"
        dict set d blur endLabel  "nothing"
        dict set value -markPoint $d
    }
    
    setdef options blur -type dict|null   -default [ticklecharts::blur [dict get $value -markPoint]]
    setdef options data -type list.o|null -default [ticklecharts::markPointItem [dict get $value -markPoint]]
    #...
    
    set dico [dict get $value -markPoint]
    
    if {[dict exists $dico data]} {
        set dico [dict remove $dico data]
    }
    
    set options [merge $options $dico]

    return $options
}

proc ticklecharts::blur {value} {

    if {[dict exists $value blur]} {
        set key "blur"
    } elseif {[dict exists $value -blur]} {
        set key "-blur"
    } else {
        return "nothing"
    }

    setdef options label     -type dict|null -default [ticklecharts::label     [dict get $value $key]]
    setdef options labelLine -type dict|null -default [ticklecharts::labelLine [dict get $value $key]]
    setdef options itemStyle -type dict|null -default [ticklecharts::itemStyle [dict get $value $key]]
    setdef options lineStyle -type dict|null -default [ticklecharts::lineStyle [dict get $value $key]]
    setdef options areaStyle -type dict|null -default [ticklecharts::areaStyle [dict get $value $key]]
    setdef options endLabel  -type dict|null -default [ticklecharts::endLabel  [dict get $value $key]]
    #...

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::select {value} {

    if {[dict exists $value select]} {
        set key "select"
    } elseif {[dict exists $value -select]} {
        set key "-select"
    } else {
        return "nothing"
    }

    setdef options label     -type dict|null -default [ticklecharts::label     [dict get $value $key]]
    setdef options labelLine -type dict|null -default [ticklecharts::labelLine [dict get $value $key]]
    setdef options itemStyle -type dict|null -default [ticklecharts::itemStyle [dict get $value $key]]
    setdef options lineStyle -type dict|null -default [ticklecharts::lineStyle [dict get $value $key]]
    setdef options areaStyle -type dict|null -default [ticklecharts::areaStyle [dict get $value $key]]
    setdef options endLabel  -type dict|null -default [ticklecharts::endLabel  [dict get $value $key]]
    #...

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::decal {value} {

    if {![dict exists $value decal]} {
        return "nothing"
    }

    setdef options symbol                -type str        -default "rect"
    setdef options symbolSize            -type num        -default 1
    setdef options symbolKeepAspect      -type bool       -default "True"
    setdef options color                 -type str|jsfunc -default "rgba(0, 0, 0, 0.2)"
    setdef options backgroundColor       -type str|null   -default "nothing"
    setdef options dashArrayX            -type num        -default 5
    setdef options dashArrayY            -type num        -default 5
    setdef options rotation              -type num        -default 0
    setdef options maxTileWidth          -type num        -default 512
    setdef options maxTileHeight         -type num        -default 512
    #...

    set options [merge $options [dict get $value decal]]

    return $options

}

proc ticklecharts::SetRadiusAxis {value} {

    setdef options -id             -type str|null            -default "nothing"
    setdef options -polarIndex     -type num|null            -default "nothing"
    setdef options -type           -type str|null            -default "nothing"
    setdef options -name           -type str|null            -default "nothing"
    setdef options -nameLocation   -type str|null            -default "nothing"
    setdef options -nameTextStyle  -type dict|null           -default [ticklecharts::NameTextStyle $value]
    setdef options -nameGap        -type num|null            -default "nothing"
    setdef options -nameRotate     -type num|null            -default "nothing"
    setdef options -inverse        -type bool|null           -default "nothing"
    setdef options -boundaryGap    -type bool|list.d|null    -default "nothing"
    setdef options -min            -type num|str|jsfunc|null -default "nothing"
    setdef options -max            -type num|str|jsfunc|null -default "nothing"
    setdef options -scale          -type bool|null           -default "nothing"
    setdef options -splitNumber    -type num|null            -default "nothing"
    setdef options -minInterval    -type num|null            -default "nothing"
    setdef options -maxInterval    -type num|null            -default "nothing"
    setdef options -interval       -type num|null            -default "nothing"
    setdef options -logBase        -type num|null            -default "nothing"
    setdef options -silent         -type bool|null           -default "nothing"
    setdef options -triggerEvent   -type bool|null           -default "nothing"
    setdef options -axisLine       -type dict|null           -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -type dict|null           -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -type dict|null           -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -type dict|null           -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -type dict|null           -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -type dict|null           -default [ticklecharts::splitArea $value]
    setdef options -data           -type list.d|null         -default "nothing"
    setdef options -axisPointer    -type dict|null           -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -type num|null            -default "nothing"
    setdef options -z              -type num|null            -default "nothing"
    #...

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::SetAngleAxis {value} {

    setdef options -id             -type str|null            -default "nothing"
    setdef options -polarIndex     -type num|null            -default "nothing"
    setdef options -startAngle     -type num                 -default 90
    setdef options -clockwise      -type bool                -default "True"
    setdef options -type           -type str|null            -default "nothing"
    setdef options -boundaryGap    -type bool|list.d|null    -default "nothing"
    setdef options -min            -type num|str|jsfunc|null -default "nothing"
    setdef options -max            -type num|str|jsfunc|null -default "nothing"
    setdef options -scale          -type bool|null           -default "nothing"
    setdef options -splitNumber    -type num|null            -default "nothing"
    setdef options -minInterval    -type num|null            -default "nothing"
    setdef options -maxInterval    -type num|null            -default "nothing"
    setdef options -interval       -type num|null            -default "nothing"
    setdef options -logBase        -type num|null            -default "nothing"
    setdef options -silent         -type bool|null           -default "nothing"
    setdef options -triggerEvent   -type bool|null           -default "nothing"
    setdef options -axisLine       -type dict|null           -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -type dict|null           -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -type dict|null           -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -type dict|null           -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -type dict|null           -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -type dict|null           -default [ticklecharts::splitArea $value]
    setdef options -data           -type list.d|null         -default "nothing"
    setdef options -axisPointer    -type dict|null           -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -type num|null            -default "nothing"
    setdef options -z              -type num|null            -default "nothing"
    #...

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::setXAxis {value} {
    
    setdef options -id             -type str|null            -default "nothing"
    setdef options -show           -type bool                -default "True"
    setdef options -type           -type str|null            -default "category"
    setdef options -data           -type list.d|null         -default "nothing"
    setdef options -gridIndex      -type num                 -default 0
    setdef options -alignTicks      -type bool|null          -default "nothing"
    setdef options -position       -type str                 -default "bottom"
    setdef options -offset         -type num                 -default 0
    setdef options -name           -type str|null            -default "nothing"
    setdef options -nameLocation   -type str                 -default "end"
    setdef options -nameTextStyle  -type dict|null           -default [ticklecharts::NameTextStyle $value]
    setdef options -nameGap        -type num                 -default 15
    setdef options -nameRotate     -type num                 -default 0
    setdef options -inverse        -type bool                -default "False"
    setdef options -boundaryGap    -type bool|list.d         -default "True"
    setdef options -min            -type num|str|jsfunc|null -default "nothing"
    setdef options -max            -type num|str|jsfunc|null -default "nothing"
    setdef options -scale          -type bool                -default "False"
    setdef options -splitNumber    -type num                 -default 5
    setdef options -minInterval    -type num                 -default 0
    setdef options -maxInterval    -type num|null            -default "nothing"
    setdef options -interval       -type num|null            -default "nothing"
    setdef options -logBase        -type num|null            -default "nothing"
    setdef options -silent         -type bool                -default "False"
    setdef options -triggerEvent   -type bool                -default "False"
    setdef options -axisLine       -type dict|null           -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -type dict|null           -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -type dict|null           -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -type dict|null           -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -type dict|null           -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -type dict|null           -default [ticklecharts::splitArea $value]
    setdef options -axisPointer    -type dict|null           -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -type num                 -default 0
    setdef options -z              -type num                 -default 0
    
    set options [merge $options $value]

    return $options

}

proc ticklecharts::setYAxis {value} {


    setdef options -id              -type str|null            -default "nothing"
    setdef options -show            -type bool                -default "True"
    setdef options -gridIndex       -type num                 -default 0
    setdef options -alignTicks      -type bool|null           -default "nothing"
    setdef options -position        -type str                 -default "bottom"
    setdef options -offset          -type num                 -default 0
    setdef options -realtimeSort    -type bool                -default "True"
    setdef options -sortSeriesIndex -type num                 -default 0
    setdef options -type            -type str|null            -default "value"
    setdef options -data            -type list.d|null         -default "nothing"
    setdef options -name            -type str|null            -default "nothing"
    setdef options -nameLocation    -type str                 -default "end"
    setdef options -nameTextStyle   -type dict|null           -default [ticklecharts::NameTextStyle $value]
    setdef options -nameGap         -type num                 -default 15
    setdef options -nameRotate      -type num                 -default 0
    setdef options -inverse         -type bool                -default "False"
    setdef options -boundaryGap     -type bool|list.s         -default "False"
    setdef options -min             -type num|str|jsfunc|null -default "nothing"
    setdef options -max             -type num|str|jsfunc|null -default "nothing"
    setdef options -scale           -type bool                -default "False"
    setdef options -splitNumber     -type num                 -default 5
    setdef options -minInterval     -type num                 -default 0
    setdef options -maxInterval     -type num|null            -default "nothing"
    setdef options -interval        -type num|null            -default "nothing"
    setdef options -logBase         -type num|null            -default "nothing"
    setdef options -silent          -type bool                -default "False"
    setdef options -triggerEvent    -type bool                -default "False"
    setdef options -axisLine        -type dict|null           -default [ticklecharts::axisLine $value]
    setdef options -axisTick        -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -minorTick       -type dict|null           -default [ticklecharts::minorTick $value]
    setdef options -axisLabel       -type dict|null           -default [ticklecharts::axisLabel $value]
    setdef options -splitLine       -type dict|null           -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine  -type dict|null           -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea       -type dict|null           -default [ticklecharts::splitArea $value]
    setdef options -zlevel          -type num                 -default 0
    setdef options -z               -type num                 -default 0
    
    set options [merge $options $value]

    return $options

}

proc ticklecharts::splitLine {value} {

    lassign [info level 2] proc_l2

    if {$::ticklecharts::theme ne "basic"} {
        if {![dict exists $value -splitLine]} {
            dict set value -splitLine [dict create dummy null]
        }
    }

    if {![dict exists $value -splitLine]} {
        return "nothing"
    }

    if {$proc_l2 eq "ticklecharts::setXAxis"} {
        set showgrid [dict get $::ticklecharts::opts_theme axisXgridlineShow]
    } elseif {$proc_l2 eq "ticklecharts::setYAxis"} {
        set showgrid [dict get $::ticklecharts::opts_theme axisYgridlineShow] 
    } else {
        set showgrid "True"
    }



    setdef options show            -type bool            -default $showgrid
    setdef options onZero          -type bool            -default "True"
    setdef options onZeroAxisIndex -type num|null        -default "nothing"
    setdef options symbol          -type str|list.s|null -default "null"
    setdef options symbolSize      -type list.n|null     -default "nothing"
    setdef options symbolOffset    -type list.n|num|null -default "nothing"
    setdef options lineStyle       -type dict|null       -default [ticklecharts::lineStyle [dict get $value -splitLine]]
    #...

    set options [merge $options [dict get $value -splitLine]]

    return $options

}

proc ticklecharts::universalTransition {value} {

    if {![dict exists $value -universalTransition]} {
        return "nothing"
    }

    setdef options enabled         -type bool            -default "False"
    setdef options seriesKey       -type str|list.d|null -default "nothing"
    setdef options divideShape     -type str|null        -default "nothing"
    setdef options delay           -type jsfunc|null     -default "nothing"
    #...

    set options [merge $options [dict get $value -universalTransition]]

    return $options

}

proc ticklecharts::minorSplitLine {value} {

    if {![dict exists $value -minorSplitLine]} {
        return "nothing"
    }

    setdef options show      -type bool      -default "False"
    setdef options lineStyle -type dict|null -default [ticklecharts::lineStyle [dict get $value -minorSplitLine]]
    #...

    set options [merge $options [dict get $value -minorSplitLine]]

    return $options

}

proc ticklecharts::splitArea {value} {

    if {![dict exists $value -splitArea]} {
        return "nothing"
    }

    setdef options interval  -type num       -default 0
    setdef options show      -type bool      -default "False"
    setdef options areaStyle -type dict|null -default [ticklecharts::areaStyle [dict get $value -splitArea]]
    #...

    set options [merge $options [dict get $value -splitArea]]

    return $options

}

proc ticklecharts::areaStyle {value} {

    if {[dict exists $value areaStyle]} {
        set key "areaStyle"
    } elseif {[dict exists $value -areaStyle]} {
        set key "-areaStyle"
    } else {
        return "nothing"
    }
    
    lassign [info level 3] proc
    
    if {$proc eq "ticklecharts::splitArea"} {
        set color  [dict get $::ticklecharts::opts_theme splitAreaColor]
    } else {
        set color "null"
    }
    
    setdef options color         -type list.s|str|jsfunc|null -default $color
    setdef options shadowBlur    -type num                    -default 0
    setdef options shadowColor   -type str|null               -default "nothing"
    setdef options shadowOffsetX -type num                    -default 0
    setdef options shadowOffsetY -type num                    -default 0
    setdef options opacity       -type num                    -default 0.5
    #...

    set options [merge $options [dict get $value $key]]

    return $options
}


proc ticklecharts::axisLine {value} {

    if {$::ticklecharts::theme ne "basic"} {
        if {![dict exists $value -axisLine]} {
            dict set value -axisLine [dict create dummy null]
        }
    }

    if {![dict exists $value -axisLine]} {
        return "nothing"
    }
    
    set d [dict get $value -axisLine]

    setdef options show            -type bool            -default [dict get $::ticklecharts::opts_theme axisLineShow]
    setdef options onZero          -type bool            -default "True"
    setdef options onZeroAxisIndex -type num|null        -default "nothing"
    setdef options symbol          -type str|list.s|null -default "null"
    setdef options symbolSize      -type list.n|null     -default "nothing"
    setdef options symbolOffset    -type list.n|num|null -default "nothing"
    setdef options lineStyle       -type dict|null       -default [ticklecharts::lineStyle $d]
    #...
    
    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::markLine {value} {

    if {[dict exists $value markLine]} {
        set key "markLine"
    } elseif {[dict exists $value -markLine]} {
        set key "-markLine"
    } else {
        return "nothing"
    }
    
    set d [dict get $value $key]

    setdef options silent                  -type bool            -default "False"
    setdef options symbol                  -type str|list.s|null -default "nothing"
    setdef options symbolSize              -type list.n|null     -default "nothing"
    setdef options precision               -type num|null        -default 2
    setdef options label                   -type dict|null       -default [ticklecharts::label $d]
    setdef options lineStyle               -type dict|null       -default [ticklecharts::lineStyle $d]
    setdef options emphasis                -type dict|null       -default [ticklecharts::emphasis $d]
    setdef options blur                    -type dict|null       -default [ticklecharts::blur $d]
    setdef options data                    -type list.o|null     -default [ticklecharts::markLineItem $d]
    setdef options animation               -type bool|null       -default "nothing"
    setdef options animationThreshold      -type num|null        -default "nothing"
    setdef options animationDuration       -type num|jsfunc|null -default "nothing"
    setdef options animationEasing         -type str|null        -default "nothing"
    setdef options animationDelay          -type num|jsfunc|null -default "nothing"
    setdef options animationDurationUpdate -type num|jsfunc|null -default "nothing"
    setdef options animationEasingUpdate   -type str|null        -default "nothing"
    setdef options animationDelayUpdate    -type num|jsfunc|null -default "nothing"
    
    set d [dict remove $d data label lineStyle emphasis blur]

    set options [merge $options $d]

    return $options
}

proc ticklecharts::markLineItem {value} {

    if {![dict exists $value data]} {
        return "nothing"
    }

    foreach {key info} [dict get $value data] {

        if {$info eq ""} {
            error "Key $key must be associated with value"
        }

        switch -exact -- $key {
            lineItem {

                if {[llength $info] != 2} {
                    error "must be a list of 2 startpoint and endpoint"
                }

                set t {}
                foreach var $info {
                    append t "[ticklecharts::markLineItem [dict create data [list objectItem $var]]] "
                }

                lappend opts [list $t list.o]
                
            }
            objectItem {
                setdef options name             -type str|null        -default "nothing"
                setdef options type             -type str|null        -default "nothing"
                setdef options valueIndex       -type num|null        -default "nothing"
                setdef options valueDim         -type str|null        -default "nothing"
                setdef options coord            -type list.n|null     -default "nothing"
                setdef options x                -type num|str|null    -default "nothing"
                setdef options y                -type num|str|null    -default "nothing"
                setdef options xAxis            -type num|str|null    -default "nothing"
                setdef options yAxis            -type num|str|null    -default "nothing"
                setdef options value            -type num|null        -default "nothing"
                setdef options symbol           -type str|null        -default "nothing"
                setdef options symbolSize       -type num|list.n|null -default "nothing"
                setdef options symbolKeepAspect -type bool|null       -default "nothing"
                setdef options symbolOffset     -type list.d|null     -default "nothing"
                setdef options lineStyle        -type dict|null       -default [ticklecharts::lineStyle $info]
                setdef options label            -type dict|null       -default [ticklecharts::label $info]
                setdef options emphasis         -type dict|null       -default [ticklecharts::emphasis $info]
                setdef options blur             -type dict|null       -default [ticklecharts::blur $info]

                lappend opts [merge $options $info]

            }
            default {error "Key must be 'lineItem' or 'objectItem' "}
        }
        
    }

    return [list {*}$opts]

}

proc ticklecharts::labelLine {value} {

    if {[dict exists $value labelLine]} {
        set key "labelLine"
    } elseif {[dict exists $value -labelLine]} {
        set key "-labelLine"
    } else {
        return "nothing"
    }

    setdef options show         -type bool          -default "True"
    setdef options showAbove    -type bool|null     -default "nothing"
    setdef options length2      -type num|null      -default "nothing"
    setdef options smooth       -type bool|num|null -default "nothing"
    setdef options minTurnAngle -type num|null      -default "nothing"
    setdef options lineStyle    -type dict|null     -default [ticklecharts::lineStyle [dict get $value $key]]
    #...

    lassign [info level 2] proc_l2

    if {$proc_l2 eq "ticklecharts::pieseries"} {
        setdef options length           -type num|null  -default "nothing"
        setdef options maxSurfaceAngle  -type num|null  -default "nothing"
    }

    set options [merge $options [dict get $value $key]]

    return $options
}

proc ticklecharts::labelLayout {value} {

    if {![dict exists $value -labelLayout]} {
        return "nothing"
    }

    setdef options hideOverlap     -type bool|null    -default "nothing"
    setdef options moveOverlap     -type str|null     -default "shiftX"
    setdef options x               -type num|str|null -default "nothing"
    setdef options y               -type num|str|null -default "nothing"
    setdef options dx              -type num|null     -default "nothing"
    setdef options dy              -type num|null     -default "nothing"
    setdef options rotate          -type num|null     -default "nothing"
    setdef options width           -type num|null     -default "nothing"
    setdef options height          -type num|null     -default "nothing"
    setdef options align           -type str          -default "left"
    setdef options verticalAlign   -type str          -default "top"
    setdef options fontSize        -type num|null     -default "nothing"
    setdef options draggable       -type bool|null    -default "nothing"
    setdef options labelLinePoints -type list.n|null  -default "nothing"
    #...

    set options [merge $options [dict get $value -labelLayout]]

    return $options
}

proc ticklecharts::axisTick {value} {

    if {$::ticklecharts::theme ne "basic"} {
        if {![dict exists $value -axisTick]} {
            dict set value -axisTick [dict create dummy null]
        }
    }

    if {![dict exists $value -axisTick]} {
        return "nothing"
    }

    setdef options show            -type bool      -default [dict get $::ticklecharts::opts_theme axisTickShow]
    setdef options alignWithLabel  -type bool|null -default "nothing"
    setdef options interval        -type str       -default "auto"
    setdef options length          -type num       -default 5
    setdef options lineStyle       -type dict|null -default [ticklecharts::lineStyle [dict get $value -axisTick]]
    #...

    set options [merge $options [dict get $value -axisTick]]

    return $options
}

proc ticklecharts::minorTick {value} {

    if {![dict exists $value -minorTick]} {
        return "nothing"
    }

    setdef options show        -type bool      -default "False"
    setdef options splitNumber -type num       -default 5
    setdef options length      -type num       -default 3
    setdef options lineStyle   -type dict|null -default [ticklecharts::lineStyle [dict get $value -minorTick]]
    #...

    set options [merge $options [dict get $value -minorTick]]

    return $options

}

proc ticklecharts::axisLabel {value} {

    if {$::ticklecharts::theme ne "basic"} {
        if {![dict exists $value -axisLabel]} {
            dict set value -axisLabel [dict create dummy null]
        }
    }

    if {![dict exists $value -axisLabel]} {
        return "nothing"
    }
        
    setdef options show                 -type bool            -default [dict get $::ticklecharts::opts_theme axisLabelShow]
    setdef options interval             -type num|jsfunc      -default 0
    setdef options inside               -type bool            -default "False"
    setdef options rotate               -type num             -default 0
    setdef options margin               -type num             -default 8
    setdef options formatter            -type str|jsfunc|null -default "nothing"
    setdef options showMinLabel         -type bool|null       -default "null"
    setdef options showMaxLabel         -type bool|null       -default "null"
    setdef options hideOverlap          -type bool            -default "False"
    setdef options color                -type str|null        -default [dict get $::ticklecharts::opts_theme axisLabelColor]
    setdef options fontStyle            -type str             -default "normal"
    setdef options fontWeight           -type str|num         -default "normal"
    setdef options fontFamily           -type str             -default "sans-serif"
    setdef options fontSize             -type num             -default 12
    setdef options align                -type str|null        -default "nothing"
    setdef options verticalAlign        -type str|null        -default "nothing"
    setdef options lineHeight           -type num             -default 12
    setdef options backgroundColor      -type str             -default "transparent"
    setdef options borderColor          -type str|null        -default "nothing"
    setdef options borderWidth          -type num             -default 0
    setdef options borderType           -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -type num|null        -default 0
    setdef options borderRadius         -type num             -default 0
    setdef options padding              -type num|list.n      -default 0
    setdef options shadowColor          -type str             -default "transparent"
    setdef options shadowBlur           -type num             -default 0
    setdef options shadowOffsetX        -type num             -default 0
    setdef options shadowOffsetY        -type num             -default 0
    setdef options width                -type num|null        -default "nothing"
    setdef options height               -type num|null        -default "nothing"
    setdef options textBorderColor      -type str|null        -default "null"
    setdef options textBorderWidth      -type num             -default 0
    setdef options textBorderType       -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -type num             -default 0
    setdef options textShadowColor      -type str             -default "transparent"
    setdef options textShadowBlur       -type num             -default 0
    setdef options textShadowOffsetX    -type num             -default 0
    setdef options textShadowOffsetY    -type num             -default 0
    setdef options overflow             -type str             -default "truncate"
    setdef options ellipsis             -type str             -default "..."
    #...

    set options [merge $options [dict get $value -axisLabel]]

    return $options

}

proc ticklecharts::label {value} {


    if {[dict exists $value label]} {
        set key "label"
    } elseif {[dict exists $value -label]} {
        set key "-label"
    } else {
        return "nothing"
    }

    set d [dict get $value $key]
    
    setdef options show                 -type bool            -default "True"
    setdef options position             -type str|list.d|null -default "nothing"
    setdef options distance             -type num|null        -default "nothing"
    setdef options rotate               -type num             -default 0
    setdef options formatter            -type str|jsfunc|null -default "nothing"
    setdef options color                -type str|null        -default [dict get $::ticklecharts::opts_theme axisLabelColor]
    setdef options fontStyle            -type str             -default "normal"
    setdef options fontWeight           -type str|num         -default "normal"
    setdef options fontFamily           -type str             -default "sans-serif"
    setdef options fontSize             -type num             -default 12
    setdef options align                -type str|null        -default "nothing"
    setdef options verticalAlign        -type str|null        -default "nothing"
    setdef options lineHeight           -type num|null        -default 12
    setdef options backgroundColor      -type str|null        -default "nothing"
    setdef options borderColor          -type str|null        -default "nothing"
    setdef options borderWidth          -type num             -default 0
    setdef options borderType           -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -type num             -default 0
    setdef options borderRadius         -type num             -default 2
    setdef options padding              -type num|list.n|null -default "nothing"
    setdef options shadowColor          -type str             -default "transparent"
    setdef options shadowBlur           -type num             -default 0
    setdef options shadowOffsetX        -type num             -default 0
    setdef options shadowOffsetY        -type num             -default 0
    setdef options width                -type num|null        -default "nothing"
    setdef options height               -type num|null        -default "nothing"
    setdef options textBorderColor      -type str|null        -default "null"
    setdef options textBorderWidth      -type num             -default 0
    setdef options textBorderType       -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -type num             -default 0
    setdef options textShadowColor      -type str             -default "transparent"
    setdef options textShadowBlur       -type num             -default 0
    setdef options textShadowOffsetX    -type num             -default 0
    setdef options textShadowOffsetY    -type num             -default 0
    setdef options overflow             -type str             -default "truncate"
    setdef options ellipsis             -type str             -default "..."
    setdef options rich                 -type dict|null       -default [ticklecharts::RichItem $d]
    #...

    lassign [info level 2] proc_l2

    if {$proc_l2 eq "ticklecharts::pieseries"} {
        setdef options alignTo             -type str          -default "none"
        setdef options edgeDistance        -type str|num|null -default "25%"
        setdef options bleedMargin         -type num|null     -default 10
        setdef options margin              -type num|null     -default "nothing"
        setdef options distanceToLabelLine -type num          -default 5
    }

    # remove key from dict value rich...
    set d [dict remove $d richitem]

    set options [merge $options $d]

    return $options
}

proc ticklecharts::endLabel {value} {

    if {[dict exists $value endLabel]} {
        set key "endLabel"
    } elseif {[dict exists $value -endLabel]} {
        set key "-endLabel"
    } else {
        return "nothing"
    }

    setdef options show                 -type bool            -default "False"
    setdef options distance             -type num             -default 5
    setdef options rotate               -type num             -default 0
    setdef options offset               -type list.d|null     -default "nothing"
    setdef options formatter            -type str|jsfunc|null -default "nothing"
    setdef options color                -type str|null        -default "inherit"
    setdef options fontStyle            -type str             -default "normal"
    setdef options fontWeight           -type str|num         -default "normal"
    setdef options fontFamily           -type str             -default "sans-serif"
    setdef options fontSize             -type num             -default 12
    setdef options align                -type str             -default "left"
    setdef options verticalAlign        -type str             -default "top"
    setdef options lineHeight           -type num             -default 12
    setdef options backgroundColor      -type str             -default "transparent"
    setdef options borderColor          -type str|null        -default "nothing"
    setdef options borderWidth          -type num             -default 0
    setdef options borderType           -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -type num             -default 0
    setdef options borderRadius         -type num             -default 0
    setdef options padding              -type num|list.n      -default 0
    setdef options shadowColor          -type str             -default "transparent"
    setdef options shadowBlur           -type num             -default 0
    setdef options shadowOffsetX        -type num             -default 0
    setdef options shadowOffsetY        -type num             -default 0
    setdef options width                -type num             -default 100
    setdef options height               -type num             -default 100
    setdef options textBorderColor      -type str|null        -default "null"
    setdef options textBorderWidth      -type num             -default 0
    setdef options textBorderType       -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -type num             -default 0
    setdef options textShadowColor      -type str             -default "transparent"
    setdef options textShadowBlur       -type num             -default 0
    setdef options textShadowOffsetX    -type num             -default 0
    setdef options textShadowOffsetY    -type num             -default 0
    setdef options overflow             -type str             -default "truncate"
    setdef options ellipsis             -type str             -default "..."
    setdef options valueAnimation       -type bool|null       -default "nothing"
    #...

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::lineStyle {value} {

    lassign [info level 3] proc_l3
    lassign [info level 2] proc_l2

    if {$::ticklecharts::theme ne "basic"} {
        if {![dict exists $value -lineStyle]} {
            dict set value -lineStyle [dict create dummy null]
        }
    }

    if {[dict exists $value lineStyle]} {
        set key "lineStyle"
    } elseif {[dict exists $value -lineStyle]} {
        set key "-lineStyle"
    } else {
        return "nothing"
    }
        
    if {$proc_l3 eq "ticklecharts::splitLine"} {
        set color     [dict get $::ticklecharts::opts_theme splitLineColor]
        set linewidth [dict get $::ticklecharts::opts_theme graphLineWidth]
    } elseif {$proc_l2 eq "ticklecharts::lineseries"} {
        set color     "nothing"
        set linewidth [dict get $::ticklecharts::opts_theme lineWidth]
    } else {
        set color     [dict get $::ticklecharts::opts_theme axisLineColor]
        set linewidth [dict get $::ticklecharts::opts_theme graphLineWidth]
    }
    
    setdef options color          -type str|jsfunc|null -default $color
    setdef options width          -type num             -default $linewidth
    setdef options type           -type list.n|num|str  -default "solid"
    setdef options dashOffset     -type num             -default 0
    setdef options cap            -type str             -default "butt"
    setdef options join           -type str             -default "bevel"
    setdef options miterLimit     -type num             -default 10
    setdef options shadowBlur     -type num             -default 0
    setdef options shadowColor    -type str|null        -default "null"
    setdef options shadowOffsetX  -type num             -default 0
    setdef options shadowOffsetY  -type num             -default 0
    setdef options opacity        -type num             -default 1
    #...
    
    if {$proc_l2 eq "ticklecharts::legend"} {
        set options [dict remove $options color width type \
                                          dashOffset cap join \
                                          miterLimit shadowBlur opacity]
                                          
        setdef options color      -type str|null       -default "inherit"
        setdef options width      -type str|num|null   -default "auto"
        setdef options type       -type list.n|num|str -default "inherit"
        setdef options dashOffset -type num|str        -default "inherit"
        setdef options cap        -type str            -default "inherit"
        setdef options join       -type str            -default "inherit"
        setdef options miterLimit -type num|str        -default "inherit"
        setdef options shadowBlur -type num|str        -default "inherit"
        setdef options opacity    -type num|str        -default "inherit"
    }

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::textStyle {value key} {

    lassign [info level 2] proc_l2

    if {$::ticklecharts::theme ne "basic" && $proc_l2 ne "ticklecharts::tooltip"} {
        if {![dict exists $value $key]} {
            dict set value $key [dict create dummy null]
        }
    }

    if {![dict exists $value $key]} {
        return "nothing"
    }

    switch -exact -- $key {
        textStyle    {set color [dict get $::ticklecharts::opts_theme titleColor]}
        subtextStyle {set color [dict get $::ticklecharts::opts_theme subtitleColor]}
        default      {set color "nothing"}
    }

    if {$::ticklecharts::theme ne "basic" && $proc_l2 eq "ticklecharts::legend"} {
        set fontSize 12
        set fontWeight "normal"
    } else {
        set fontSize 18
        set fontWeight "bolder"
    }

    if {$::ticklecharts::theme ne "basic" && $key eq "subtextStyle"} {
        set fontSize 13
        set fontWeight "normal"
    }

    setdef options color                -type str|null       -default $color
    setdef options fontStyle            -type str            -default "normal"
    setdef options fontWeight           -type str|num        -default $fontWeight
    setdef options fontFamily           -type str            -default "sans-serif"
    setdef options fontSize             -type num            -default $fontSize
    setdef options lineHeight           -type num|null       -default "nothing"
    setdef options width                -type num            -default 100
    setdef options height               -type num            -default 50
    setdef options textBorderColor      -type str|null       -default "null"
    setdef options textBorderWidth      -type num            -default 0
    setdef options textBorderType       -type str|num|list.n -default "solid"
    setdef options textBorderDashOffset -type num            -default 0
    setdef options textShadowColor      -type str            -default "transparent"
    setdef options textShadowBlur       -type num            -default 0
    setdef options textShadowOffsetX    -type num            -default 0
    setdef options textShadowOffsetY    -type num            -default 0
    setdef options overflow             -type str|null       -default "null"
    setdef options ellipsis             -type str            -default "..."
    #...

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::NameTextStyle {value} {

    if {![dict exists $value -nameTextStyle]} {
        return "nothing"
    }

    setdef options color                -type str|null       -default "nothing"
    setdef options fontStyle            -type str            -default "normal"
    setdef options fontWeight           -type str|num        -default "normal"
    setdef options fontFamily           -type str            -default "sans-serif"
    setdef options fontSize             -type num            -default 12
    setdef options align                -type str            -default "left"
    setdef options verticalAlign        -type str            -default "top"
    setdef options lineHeight           -type num            -default 12
    setdef options backgroundColor      -type str            -default "transparent"
    setdef options borderColor          -type str|null       -default "nothing"
    setdef options borderWidth          -type num            -default 0
    setdef options borderType           -type str|num|list.n -default "solid"
    setdef options borderDashOffset     -type num            -default 0
    setdef options borderRadius         -type num            -default 0
    setdef options padding              -type num|list.n     -default 0
    setdef options shadowColor          -type str            -default "transparent"
    setdef options shadowBlur           -type num            -default 0
    setdef options shadowOffsetX        -type num            -default 0
    setdef options shadowOffsetY        -type num            -default 0
    setdef options width                -type num            -default 100
    setdef options height               -type num            -default 100
    setdef options textBorderColor      -type str|null       -default "null"
    setdef options textBorderWidth      -type num            -default 0
    setdef options textBorderType       -type str|num|list.n -default "solid"
    setdef options textBorderDashOffset -type num            -default 0
    setdef options textShadowColor      -type str            -default "transparent"
    setdef options textShadowBlur       -type num            -default 0
    setdef options textShadowOffsetX    -type num            -default 0
    setdef options textShadowOffsetY    -type num            -default 0
    setdef options overflow             -type str            -default "truncate"
    setdef options ellipsis             -type str            -default "..."
    #...

    set options [merge $options [dict get $value -nameTextStyle]]

    return $options

}

proc ticklecharts::crossStyle {value} {

    if {![dict exists $value crossStyle]} {
        return "nothing"
    }
    
    set d [dict get $value crossStyle]

    setdef options color         -type str                 -default "rgb(85, 85, 85)"
    setdef options width         -type num                 -default 1
    setdef options type          -type str|num|list.n|null -default "solid"
    setdef options dashOffset    -type num|null            -default "nothing"
    setdef options cap           -type str                 -default "butt"
    setdef options join          -type str                 -default "bevel"
    setdef options miterLimit    -type num|null            -default "nothing"
    setdef options shadowBlur    -type num|null            -default "nothing"
    setdef options shadowColor   -type str|null            -default "nothing"
    setdef options shadowOffsetX -type num|null            -default "nothing"
    setdef options shadowOffsetY -type num|null            -default "nothing"
    setdef options opacity       -type num|null            -default 0.5
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::backgroundStyle {value} {

    if {![dict exists $value -backgroundStyle]} {
        return "nothing"
    }
    
    set d [dict get $value -backgroundStyle]

    setdef options color         -type str             -default "rgba(180, 180, 180, 0.2)"
    setdef options borderColor   -type str|null        -default "#000"
    setdef options borderWidth   -type num|null        -default "nothing"
    setdef options borderType    -type str|null        -default "solid"
    setdef options borderRadius  -type num|list.n|null -default 0
    setdef options dashOffset    -type num|null        -default "nothing"
    setdef options shadowBlur    -type num|null        -default "nothing"
    setdef options shadowColor   -type str|null        -default "nothing"
    setdef options shadowOffsetX -type num|null        -default "nothing"
    setdef options shadowOffsetY -type num|null        -default "nothing"
    setdef options opacity       -type num|null        -default 0.5
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::shadowStyle {value} {

    if {![dict exists $value shadowStyle]} {
        return "nothing"
    }
    
    set d [dict get $value shadowStyle]

    setdef options color         -type str      -default "rgba(150,150,150,0.3)"
    setdef options shadowBlur    -type num|null -default "nothing"
    setdef options shadowColor   -type str|null -default "nothing"
    setdef options shadowColor   -type str|null -default "nothing"
    setdef options shadowOffsetX -type num|null -default "nothing"
    setdef options shadowOffsetY -type num|null -default "nothing"
    setdef options opacity       -type num|null -default 0.5
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::emptyCircleStyle {value} {

    if {![dict exists $value -emptyCircleStyle]} {
        return "nothing"
    }
    
    set d [dict get $value -emptyCircleStyle]

    setdef options color            -type str      -default "lightgray"
    setdef options borderColor      -type str|null -default "#000"
    setdef options borderWidth      -type num|null -default "nothing"
    setdef options borderType       -type str|null -default "solid"
    setdef options borderdashOffset -type num|null -default "nothing"
    setdef options borderCap        -type str      -default "butt"
    setdef options borderJoin       -type str      -default "bevel"
    setdef options borderMiterLimit -type num      -default 10
    setdef options shadowBlur       -type num|null -default "nothing"
    setdef options shadowColor      -type str|null -default "nothing"
    setdef options shadowOffsetX    -type num|null -default "nothing"
    setdef options shadowOffsetY    -type num|null -default "nothing"
    setdef options opacity          -type num|null -default 0.5
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::axisPointer {value} {

    if {[dict exists $value axisPointer]} {
        set key "axisPointer"
    } elseif {[dict exists $value -axisPointer]} {
        set key "-axisPointer"
    } else {
        return "nothing"
    }
    
    set d [dict get $value $key]

    setdef options type                    -type str             -default "line"
    setdef options axis                    -type str             -default "auto"
    setdef options snap                    -type bool|null       -default "nothing"
    setdef options z                       -type num|null        -default "nothing"
    setdef options label                   -type dict|null       -default [ticklecharts::label $d]
    setdef options lineStyle               -type dict|null       -default [ticklecharts::lineStyle $d]
    setdef options shadowStyle             -type dict|null       -default [ticklecharts::shadowStyle $d]
    setdef options crossStyle              -type dict|null       -default [ticklecharts::crossStyle $d]
    setdef options animation               -type bool            -default "True"
    setdef options animationThreshold      -type num             -default 2000
    setdef options animationDuration       -type num|jsfunc      -default 1000
    setdef options animationEasing         -type str             -default "cubicOut"
    setdef options animationDelay          -type num|jsfunc|null -default "nothing"
    setdef options animationDurationUpdate -type num|jsfunc      -default 200
    setdef options animationEasingUpdate   -type str             -default "exponentialOut"
    setdef options animationDelayUpdate    -type num|jsfunc|null -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::inRange {value} {

    if {![dict exists $value inRange]} {
        return "nothing"
    }
    
    set d [dict get $value inRange]

    setdef options symbol          -type list.d|null -default "nothing"
    setdef options symbolSize      -type list.d|null -default "nothing"
    setdef options color           -type list.d|null -default "nothing"
    setdef options colorAlpha      -type list.d|null -default "nothing"
    setdef options opacity         -type list.d|null -default "nothing"
    setdef options colorLightness  -type list.d|null -default "nothing"
    setdef options colorSaturation -type list.d|null -default "nothing"
    setdef options colorHue        -type list.d|null -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::outOfRange {value} {

    if {![dict exists $value outOfRange]} {
        return "nothing"
    }
    
    set d [dict get $value outOfRange]

    setdef options symbol          -type list.d|null -default "nothing"
    setdef options symbolSize      -type list.d|null -default "nothing"
    setdef options color           -type list.d|null -default "nothing"
    setdef options colorAlpha      -type list.d|null -default "nothing"
    setdef options opacity         -type list.d|null -default "nothing"
    setdef options colorLightness  -type list.d|null -default "nothing"
    setdef options colorSaturation -type list.d|null -default "nothing"
    setdef options colorHue        -type list.d|null -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::controller {value} {

    if {![dict exists $value controller]} {
        return "nothing"
    }
    
    set d [dict get $value controller]

    setdef options inRange    -type dict|null -default [ticklecharts::inRange $d]
    setdef options outOfRange -type dict|null -default [ticklecharts::outOfRange $d]
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::handleStyle {value} {

    if {![dict exists $value handleStyle]} {
        return "nothing"
    }
    
    set d [dict get $value handleStyle]

    setdef options color            -type str|null            -default "nothing"
    setdef options borderColor      -type str|null            -default "nothing"
    setdef options borderWidth      -type num|null            -default 1
    setdef options borderType       -type str|num|list.d|null -default "solid"
    setdef options borderDashOffset -type num|null            -default "nothing"
    setdef options borderCap        -type str|null            -default "butt"
    setdef options borderMiterLimit -type num|null            -default 10
    setdef options shadowBlur       -type num|null            -default "nothing"
    setdef options shadowColor      -type str|null            -default "nothing"
    setdef options shadowOffsetX    -type num|null            -default "nothing"
    setdef options shadowOffsetY    -type num|null            -default "nothing"
    setdef options opacity          -type num|null            -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::indicatorStyle {value} {

    if {![dict exists $value indicatorStyle]} {
        return "nothing"
    }
    
    set d [dict get $value indicatorStyle]

    setdef options color            -type str|null            -default "nothing"
    setdef options borderColor      -type str|null            -default "nothing"
    setdef options borderWidth      -type num|null            -default 1
    setdef options borderType       -type str|num|list.d|null -default "solid"
    setdef options borderDashOffset -type num|null            -default "nothing"
    setdef options borderCap        -type str|null            -default "butt"
    setdef options borderMiterLimit -type num|null            -default 10
    setdef options shadowBlur       -type num|null            -default "nothing"
    setdef options shadowColor      -type str|null            -default "nothing"
    setdef options shadowOffsetX    -type num|null            -default "nothing"
    setdef options shadowOffsetY    -type num|null            -default "nothing"
    setdef options opacity          -type num|null            -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::markArea {value} {

    if {![dict exists $value -markArea]} {
        return "nothing"
    }
    
    set d [dict get $value -markArea]

    setdef options silent                  -type bool|null       -default "False"
    setdef options label                   -type dict|null       -default [ticklecharts::label $d]
    setdef options itemStyle               -type dict|null       -default [ticklecharts::itemStyle $d]
    setdef options emphasis                -type dict|null       -default [ticklecharts::emphasis $d]
    setdef options blur                    -type dict|null       -default [ticklecharts::blur $d]
    setdef options data                    -type list.o|null     -default [ticklecharts::markAreaItem $d]
    setdef options animation               -type bool|null       -default "nothing"
    setdef options animationThreshold      -type num|null        -default "nothing"
    setdef options animationDuration       -type num|jsfunc|null -default "nothing"
    setdef options animationEasing         -type str|null        -default "nothing"
    setdef options animationDelay          -type num|jsfunc|null -default "nothing"
    setdef options animationDurationUpdate -type num|jsfunc|null -default "nothing"
    setdef options animationEasingUpdate   -type str|null        -default "nothing"
    setdef options animationDelayUpdate    -type num|jsfunc|null -default "nothing"
    #...

    set d [dict remove $d data label itemStyle emphasis blur]

    set options [merge $options $d]

    return $options

}