# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::levelsSankeyItem {value} {

    if {![dict exists $value -levels]} {
        return "nothing"
    }

    foreach item [dict get $value -levels] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options depth       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options lineStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::lineStyle $item]
        setdef options emphasis    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur        -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select      -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        set item [dict remove $item label lineStyle itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::sankeyItem {value key} {

    if {![dict exists $value $key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name        -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options depth       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur        -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select      -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        set item [dict remove $item label itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::linksItem {value key} {

    if {![dict exists $value $key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options source      -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options target      -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options lineStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::lineStyle $item]
        setdef options emphasis    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur        -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select      -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        if {[InfoNameProc 2 "graphseries"]} {
            setdef options source            -minversion 5  -validvalue {}               -type str|num|null    -default "nothing"
            setdef options target            -minversion 5  -validvalue {}               -type str|num|null    -default "nothing"
            setdef options symbol            -minversion 5  -validvalue formatItemSymbol -type str|null        -default "nothing"
            setdef options symbolSize        -minversion 5  -validvalue {}               -type num|list.d|null -default "nothing"
            setdef options ignoreForceLayout -minversion 5  -validvalue {}               -type bool|null       -default "nothing"
            setdef options label             -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::label $item]
        }


        set item [dict remove $item label lineStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::themeriverItem {value} {

    if {![dict exists $value -data]} {
        error "key -data not present..."
    }

    foreach item [dict get $value -data] {

        if {[llength $item] != 3} {
            error "item should be a list of 3 elements..."
        }

        lassign $item date value name

        setdef options date   -minversion 5  -validvalue {}   -type str|num  -default "nothing"
        setdef options value  -minversion 5  -validvalue {}   -type num      -default "nothing"
        setdef options name   -minversion 5  -validvalue {}   -type str      -default "nothing"

        # simply to check if the data in my list item are correct...
        merge $options [dict create date $date value $value name $name]

        lappend opts [list $date $value $name]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::treeItem {value} {

    if {[dict exists $value -data]} { 
        set key -data
    } elseif {[dict exists $value children]} {
        set key children
    } else {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name                    -minversion 5  -validvalue {}            -type str|null        -default "nothing"
        setdef options value                   -minversion 5  -validvalue {}            -type num|null        -default "nothing"
        setdef options collapsed               -minversion 5  -validvalue {}            -type bool|null       -default "False"
        setdef options itemStyle               -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::itemStyle $item]
        setdef options lineStyle               -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::lineStyle $item]
        setdef options children                -minversion 5  -validvalue {}            -type list.o|null     -default [ticklecharts::treeItem $item]
        setdef options label                   -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::label $item]
        setdef options emphasis                -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::emphasis $item]
        setdef options blur                    -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::blur $item]
        setdef options select                  -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::select $item]
        setdef options animation               -minversion 5  -validvalue {}            -type bool|null       -default "nothing"
        setdef options animationThreshold      -minversion 5  -validvalue {}            -type num|null        -default "nothing"
        setdef options animationDuration       -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
        setdef options animationEasing         -minversion 5  -validvalue formatAEasing -type str|null        -default "nothing"
        setdef options animationDelay          -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
        setdef options animationDurationUpdate -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
        setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing -type str|null        -default "nothing"
        setdef options animationDelayUpdate    -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
        

        set item [dict remove $item children label itemStyle lineStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::LegendItem {value} {

    if {![dict exists $value dataLegendItem]} {
        error "key dataLegendItem not present..."
    }

    foreach item [dict get $value dataLegendItem] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name         -minversion 5  -validvalue {}               -type str|null     -default "nothing"
        setdef options icon         -minversion 5  -validvalue formatItemSymbol -type str          -default [EchartsOptsTheme symbol]
        setdef options itemStyle    -minversion 5  -validvalue {}               -type dict|null    -default [ticklecharts::itemStyle $item]
        setdef options lineStyle    -minversion 5  -validvalue {}               -type dict|null    -default [ticklecharts::lineStyle $item]
        setdef options symbolRotate -minversion 5  -validvalue {}               -type str|num|null -default "inherit"
        setdef options textStyle    -minversion 5  -validvalue {}               -type dict|null    -default [ticklecharts::textStyle $item textStyle]

        set item [dict remove $item itemStyle lineStyle textStyle]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::sunburstItem {value} {

    if {[dict exists $value -data]} { 
        set key -data
    } elseif {[dict exists $value children]} {
        set key children
    } else {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name        -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options link        -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options children    -minversion 5  -validvalue {}  -type list.o|null -default [ticklecharts::sunburstItem $item]
        setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]

        set item [dict remove $item children label labelLine itemStyle]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::levelsItem {value} {

    if {![dict exists $value -levels]} {
        return "nothing"
    }

    foreach item [dict get $value -levels] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options radius      -minversion "5.2.0" -validvalue {}  -type list.d|null -default "nothing"
        setdef options label       -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine   -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle   -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis    -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur        -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select      -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        set item [dict remove $item label labelLine itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::treeMapItem {value} {

    if {[dict exists $value -data]} { 
        set key -data
    } elseif {[dict exists $value children]} {
        set key children
    } else {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        setdef options value                -minversion 5  -validvalue {}                  -type num|list.d|null -default "nothing"
        setdef options id                   -minversion 5  -validvalue {}                  -type str|null        -default "nothing"
        setdef options name                 -minversion 5  -validvalue {}                  -type str|null        -default "nothing"
        setdef options path                 -minversion 5  -validvalue {}                  -type str|null        -default "nothing"
        setdef options visualDimension      -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options visualMin            -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options visualMax            -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options color                -minversion 5  -validvalue formatColor         -type str|null        -default "nothing"
        setdef options colorAlpha           -minversion 5  -validvalue {}                  -type list.d|null     -default "nothing"
        setdef options colorSaturation      -minversion 5  -validvalue {}                  -type list.d|null     -default "nothing"
        setdef options colorMappingBy       -minversion 5  -validvalue formatColorMapping  -type str             -default "index"
        setdef options visibleMin           -minversion 5  -validvalue {}                  -type num             -default 10
        setdef options childrenVisibleMin   -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options label                -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::label $item]
        setdef options upperLabel           -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::upperLabel $item]
        setdef options itemStyle            -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::itemStyle $item]
        setdef options emphasis             -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::emphasis $item]
        setdef options blur                 -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::blur $item]
        setdef options select               -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::select $item]
        setdef options link                 -minversion 5  -validvalue {}                  -type str|null        -default "nothing"
        setdef options target               -minversion 5  -validvalue formatTarget        -type str|null        -default "blank"
        setdef options children             -minversion 5  -validvalue {}                  -type list.o|null     -default [ticklecharts::treeMapItem $item]
        setdef options tooltip              -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::tooltip $item]

        set item [dict remove $item children label upperLabel itemStyle tooltip emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::levelsTreeMapItem {value} {

    if {![dict exists $value -levels]} {
        return "nothing"
    }

    foreach item [dict get $value -levels] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options visualDimension      -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options visualMin            -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options visualMax            -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options color                -minversion 5  -validvalue formatColor         -type str|list.s|null -default "nothing"
        setdef options colorAlpha           -minversion 5  -validvalue {}                  -type list.d|null     -default "nothing"
        setdef options colorSaturation      -minversion 5  -validvalue {}                  -type list.d|null     -default "nothing"
        setdef options colorMappingBy       -minversion 5  -validvalue formatColorMapping  -type str             -default "index"
        setdef options visibleMin           -minversion 5  -validvalue {}                  -type num             -default 10
        setdef options childrenVisibleMin   -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options label                -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::label $item]
        setdef options upperLabel           -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::upperLabel $item]
        setdef options itemStyle            -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::itemStyle $item]
        setdef options emphasis             -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::emphasis $item]
        setdef options blur                 -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::blur $item]
        setdef options select               -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::select $item]

        set item [dict remove $item label upperLabel itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::BarItem {value} {

    if {![dict exists $value -databaritem]} {
        error "key -databaritem not present..."
    }

    foreach item [dict get $value -databaritem] {

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name             -minversion 5  -validvalue {}               -type str|null    -default "nothing"
        setdef options value            -minversion 5  -validvalue {}               -type num|null    -default "nothing"
        setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str         -default [EchartsOptsTheme symbol]
        setdef options symbolSize       -minversion 5  -validvalue {}               -type num         -default [EchartsOptsTheme symbolSize]
        setdef options symbolRotate     -minversion 5  -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool        -default "False"
        setdef options symbolOffset     -minversion 5  -validvalue {}               -type list.n|null -default "nothing"
        setdef options label            -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis         -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip          -minversion 5  -validvalue {}               -type dict|null   -default "nothing"

        set item [dict remove $item label labelLine itemStyle emphasis blur]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::pictorialBarItem {value} {

    if {![dict exists $value -data]} {
        error "key -data not present..."
    }

    foreach item [dict get $value -data] {

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name                    -minversion 5  -validvalue {}                    -type str|null          -default "nothing"
        setdef options value                   -minversion 5  -validvalue {}                    -type num|null          -default "nothing"
        setdef options groupId                 -minversion 5  -validvalue {}                    -type str|null          -default "nothing"
        setdef options symbol                  -minversion 5  -validvalue formatItemSymbol      -type str|jsfunc|null   -default "nothing"
        setdef options symbolSize              -minversion 5  -validvalue {}                    -type num|list.d|null   -default "nothing"
        setdef options symbolPosition          -minversion 5  -validvalue formatSymbolPosition  -type str|null          -default "nothing"
        setdef options symbolOffset            -minversion 5  -validvalue {}                    -type list.d|null       -default "nothing"
        setdef options symbolRotate            -minversion 5  -validvalue {}                    -type num|null          -default "nothing"
        setdef options symbolRepeat            -minversion 5  -validvalue formatSymbolRepeat    -type bool|str|num|null -default "nothing"
        setdef options symbolRepeatDirection   -minversion 5  -validvalue formatsymbolRepeatDir -type str|null          -default "nothing"
        setdef options symbolMargin            -minversion 5  -validvalue {}                    -type str|num|null      -default "nothing"
        setdef options symbolClip              -minversion 5  -validvalue {}                    -type bool|null         -default "nothing"
        setdef options symbolBoundingData      -minversion 5  -validvalue {}                    -type num|null          -default "nothing"
        setdef options symbolPatternSize       -minversion 5  -validvalue {}                    -type num|null          -default "nothing"
        setdef options hoverAnimation          -minversion 5  -validvalue {}                    -type bool|null         -default "nothing"
        setdef options z                       -minversion 5  -validvalue {}                    -type num|null          -default "nothing"
        setdef options animation               -minversion 5  -validvalue {}                    -type bool|null         -default "nothing"
        setdef options animationThreshold      -minversion 5  -validvalue {}                    -type num|null          -default "nothing"
        setdef options animationDuration       -minversion 5  -validvalue {}                    -type num|jsfunc|null   -default "nothing"
        setdef options animationEasing         -minversion 5  -validvalue formatAEasing         -type str|null          -default "nothing"
        setdef options animationDelay          -minversion 5  -validvalue {}                    -type num|jsfunc|null   -default "nothing"
        setdef options animationDurationUpdate -minversion 5  -validvalue {}                    -type num|jsfunc|null   -default "nothing"
        setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing         -type str|null          -default "nothing"
        setdef options animationDelayUpdate    -minversion 5  -validvalue {}                    -type num|jsfunc|null   -default "nothing"
        setdef options labelLine               -minversion 5  -validvalue {}                    -type dict|null         -default [ticklecharts::labelLine $item]
        setdef options itemStyle               -minversion 5  -validvalue {}                    -type dict|null         -default [ticklecharts::itemStyle $item]
        setdef options emphasis                -minversion 5  -validvalue {}                    -type dict|null         -default [ticklecharts::emphasis $item]
        setdef options blur                    -minversion 5  -validvalue {}                    -type dict|null         -default [ticklecharts::blur $item]
        setdef options select                  -minversion 5  -validvalue {}                    -type dict|null         -default [ticklecharts::select $item]

        set item [dict remove $item labelLine itemStyle emphasis blur select]
        
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
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name             -minversion 5  -validvalue {}               -type str|null    -default "nothing"
        setdef options value            -minversion 5  -validvalue {}               -type num|null    -default "nothing"
        setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str|null    -default "nothing"
        setdef options symbolSize       -minversion 5  -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolRotate     -minversion 5  -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool        -default "False"
        setdef options symbolOffset     -minversion 5  -validvalue {}               -type list.n|null -default "nothing"
        setdef options label            -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis         -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip          -minversion 5  -validvalue {}               -type dict|null   -default "nothing"

        set item [dict remove $item label labelLine itemStyle emphasis blur]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::RadarItem {value} {

    if {![dict exists $value -dataradaritem]} {
        error "key -dataradaritem not present..."
    }

    foreach item [dict get $value -dataradaritem] {

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name             -minversion 5  -validvalue {}               -type str|null    -default "nothing"
        setdef options value            -minversion 5  -validvalue {}               -type list.n|null -default "nothing"
        setdef options groupId          -minversion 5  -validvalue {}               -type str|null    -default "nothing"
        setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str|null    -default "nothing"
        setdef options symbolSize       -minversion 5  -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolRotate     -minversion 5  -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool        -default "False"
        setdef options symbolOffset     -minversion 5  -validvalue {}               -type list.n|null -default "nothing"
        setdef options label            -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::label $item]
        setdef options itemStyle        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options lineStyle        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::lineStyle $item]
        setdef options areaStyle        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::areaStyle $item]
        setdef options emphasis         -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::blur $item]
        setdef options select           -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::select $item]
        setdef options tooltip          -minversion 5  -validvalue {}               -type dict|null   -default "nothing"

        set item [dict remove $item label itemStyle lineStyle areaStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::IndicatorItem {value} {

    if {![dict exists $value -indicatoritem]} {
        error "key -indicatoritem not present..."
    }

    foreach item [dict get $value -indicatoritem] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        if {![dict exists $item name]} {
            error "key 'name' must be present in item"
        }

        setdef options name   -minversion 5  -validvalue {}          -type str|null    -default "nothing"
        setdef options max    -minversion 5  -validvalue {}          -type num|null    -default "nothing"
        setdef options min    -minversion 5  -validvalue {}          -type num|null    -default "nothing"
        setdef options color  -minversion 5  -validvalue formatColor -type str|null    -default "nothing"

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
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name      -minversion 5  -validvalue {} -type str|null    -default "nothing"
        setdef options value     -minversion 5  -validvalue {} -type num|null    -default "nothing"
        setdef options groupId   -minversion 5  -validvalue {} -type num|null    -default "nothing"
        setdef options selected  -minversion 5  -validvalue {} -type bool        -default "False"
        setdef options label     -minversion 5  -validvalue {} -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine -minversion 5  -validvalue {} -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis  -minversion 5  -validvalue {} -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur      -minversion 5  -validvalue {} -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip   -minversion 5  -validvalue {} -type dict|null   -default "nothing"

        set item [dict remove $item label labelLine itemStyle emphasis blur]

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
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name      -minversion 5  -validvalue {} -type str|null  -default "nothing"
        setdef options value     -minversion 5  -validvalue {} -type num|null  -default "nothing"
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $item]
        setdef options labelLine -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::labelLine $item]
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $item]
        setdef options emphasis  -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::emphasis $item]
        setdef options blur      -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::blur $item]
        setdef options select    -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::select $item]
        setdef options tooltip   -minversion 5  -validvalue {} -type dict|null -default "nothing"

        set item [dict remove $item label labelLine itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::ParallelItem {value} {

    foreach item [dict get $value -dataParallelItem] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name           -minversion 5  -validvalue {}                  -type str|null        -default "nothing"
        setdef options value          -minversion 5  -validvalue {}                  -type list.d          -default {}
        setdef options lineStyle      -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::lineStyle $item]
        setdef options color          -minversion 5  -validvalue formatColor         -type str|null        -default "#000"
        setdef options width          -minversion 5  -validvalue {}                  -type num             -default 2
        setdef options type           -minversion 5  -validvalue formatLineStyleType -type list.n|num|str  -default "solid"
        setdef options dashOffset     -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
        setdef options cap            -minversion 5  -validvalue formatCap           -type str             -default "butt"
        setdef options join           -minversion 5  -validvalue formatJoin          -type str             -default "bevel"
        setdef options miterLimit     -minversion 5  -validvalue {}                  -type num             -default 10
        setdef options shadowBlur     -minversion 5  -validvalue {}                  -type num             -default 0
        setdef options shadowColor    -minversion 5  -validvalue formatColor         -type str|null        -default "null"
        setdef options shadowOffsetX  -minversion 5  -validvalue {}                  -type num             -default 0
        setdef options shadowOffsetY  -minversion 5  -validvalue {}                  -type num             -default 0
        setdef options opacity        -minversion 5  -validvalue {}                  -type num             -default 0.45
        setdef options emphasis       -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::emphasis $item]

        set item [dict remove $item lineStyle emphasis]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::gaugeItem {value} {

    foreach item [dict get $value -dataGaugeItem] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        setdef options name           -minversion 5  -validvalue {}  -type str|null   -default "nothing"
        setdef options value          -minversion 5  -validvalue {}  -type num        -default {}
        setdef options detail         -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::detail $item]
        setdef options title          -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::titleGauge $item]
        setdef options itemStyle      -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::itemStyle $item]

        set item [dict remove $item itemStyle detail title]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::dataGraphItem {value} {

    if {[dict exists $value -dataGraphItem]} {
        set key "-dataGraphItem"
    }
    
    if {[dict exists $value -data]} {
        set key "-data"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name             -minversion 5  -validvalue {}               -type str|null        -default "nothing"
        setdef options x                -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options y                -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options source           -minversion 5  -validvalue {}               -type str|num|null    -default "nothing"
        setdef options id               -minversion 5  -validvalue {}               -type str|null        -default "nothing"
        setdef options target           -minversion 5  -validvalue {}               -type str|num|null    -default "nothing"
        setdef options value            -minversion 5  -validvalue {}               -type num|list.d|null -default "nothing"
        setdef options fixed            -minversion 5  -validvalue {}               -type bool|null       -default "nothing"
        setdef options category         -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str|null        -default "nothing"
        setdef options symbolSize       -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options symbolRotate     -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool            -default "False"
        setdef options symbolOffset     -minversion 5  -validvalue {}               -type list.n|null     -default "nothing"
        setdef options lineStyle        -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::lineStyle $item]
        setdef options itemStyle        -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::itemStyle $item]
        setdef options label            -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::label $item]
        setdef options emphasis         -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::emphasis $item]
        setdef options blur             -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::blur $item]
        setdef options select           -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::select $item]
        setdef options tooltip          -minversion 5  -validvalue {}               -type dict|null       -default "nothing"

        set item [dict remove $item label itemStyle lineStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::dataWCItem {value} {

    if {![dict exists $value -dataWCItem]} {
        error "key -dataWCItem not present..."
    }

    foreach item [dict get $value -dataWCItem] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        setdef options name        -minversion 5  -validvalue {}   -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}   -type num|null    -default "nothing"
        setdef options textStyle   -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::textStyle $item textStyle]
        setdef options emphasis    -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::emphasis $item]

        set item [dict remove $item textStyle emphasis]

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
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options color         -minversion 5  -validvalue formatColor             -type str|null    -default "#fff"
        setdef options fontStyle     -minversion 5  -validvalue formatFontStyle         -type str|null    -default "normal"
        setdef options fontWeight    -minversion 5  -validvalue formatFontWeight        -type str|null    -default "normal"
        setdef options fontFamily    -minversion 5  -validvalue {}                      -type str|null    -default "sans-serif"
        setdef options fontSize      -minversion 5  -validvalue {}                      -type num|null    -default 12
        setdef options align         -minversion 5  -validvalue formatTextAlign         -type str|null    -default "nothing"
        setdef options verticalAlign -minversion 5  -validvalue formatVerticalTextAlign -type str|null    -default "nothing"
        setdef options lineHeight    -minversion 5  -validvalue {}                      -type num|null    -default "nothing"

        if {[dict exists $item backgroundColor image]} {
            set val [dict get $item backgroundColor image]
            # type value (should be a string...)
            set type [Type $val]
            # spaces in path... ??
            set val [ticklecharts::MapSpaceString $val]
            setdef options backgroundColor -minversion 5  -validvalue {} -type dict -default [dict create image [list $val $type]]
            # remove key image
            set item [dict remove $item backgroundColor]
        } else {
            setdef options backgroundColor -minversion 5  -validvalue formatColor -type str|null  -default "nothing"
        }

        setdef options borderColor          -minversion 5  -validvalue formatColor          -type str|null            -default "nothing"
        setdef options borderWidth          -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
        setdef options borderType           -minversion 5  -validvalue formatBorderType     -type str|null            -default "solid"
        setdef options borderDashOffset     -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
        setdef options borderRadius         -minversion 5  -validvalue {}                   -type num|list.n|null     -default "nothing"
        setdef options padding              -minversion 5  -validvalue {}                   -type num|list.n|null     -default "nothing"
        setdef options shadowColor          -minversion 5  -validvalue formatColor          -type str|null            -default "nothing"
        setdef options shadowBlur           -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
        setdef options shadowOffsetX        -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
        setdef options shadowOffsetY        -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
        setdef options width                -minversion 5  -validvalue {}                   -type num|str|null        -default "nothing"
        setdef options height               -minversion 5  -validvalue {}                   -type num|str|null        -default "nothing"
        setdef options textBorderColor      -minversion 5  -validvalue formatColor          -type str|null            -default "nothing"
        setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
        setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n|null -default "solid"
        setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
        setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str|null            -default "transparent"
        setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
        setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num|null            -default "nothing"

        # map spaces key... or others...
        set key [ticklecharts::MapSpaceString $key]

        lappend opts $key [list [merge $options $item] dict]
        set options {}

    }

    return [dict create {*}$opts]

}

proc ticklecharts::boxPlotitem {value} {

    foreach item [dict get $value -dataBoxPlotitem] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        if {[llength {*}[dict get $item value]] != 5} {
            error "'value' should be a list of 5 elements : \[min,  Q1,  median (or Q2),  Q3,  max\]"
        }

        setdef options name       -minversion 5  -validvalue {}   -type str|null    -default "nothing"
        setdef options value      -minversion 5  -validvalue {}   -type list.n      -default {}
        setdef options groupId    -minversion 5  -validvalue {}   -type str|null    -default "nothing"
        setdef options itemStyle  -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis   -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur       -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::blur $item]
        setdef options select     -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::select $item]
        setdef options tooltip    -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::tooltip $item]

        set item [dict remove $item select itemStyle emphasis blur tooltip]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::mapItem {value} {

    foreach item [dict get $value -dataMapItem] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }
        
        if {![dict exists $item value]} {
            error "key 'value' must be present in item"
        }

        setdef options name        -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options groupId     -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options selected    -minversion 5  -validvalue {}  -type bool|null   -default "nothing"
        setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options tooltip     -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::tooltip $item]
        setdef options select      -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        set item [dict remove $item label labelLine itemStyle emphasis tooltip select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::regionsItem {value} {

    if {![dict exists $value regions]} {
        return "nothing"
    }

    foreach item [dict get $value regions] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }
        
        setdef options name        -minversion 5        -validvalue {}  -type str|null    -default "nothing"
        setdef options selected    -minversion 5        -validvalue {}  -type bool|null   -default "nothing"
        setdef options itemStyle   -minversion 5        -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options label       -minversion 5        -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options emphasis    -minversion 5        -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options select      -minversion 5        -validvalue {}  -type dict|null   -default [ticklecharts::select $item]
        setdef options blur        -minversion "5.1.0"  -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip     -minversion "5.1.0"  -validvalue {}  -type dict|null   -default [ticklecharts::tooltip $item]
        
        set item [dict remove $item label blur itemStyle emphasis tooltip select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

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
                error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
            }

            setdef options type       -minversion 5  -validvalue {} -type str|null     -default "nothing"
            setdef options valueIndex -minversion 5  -validvalue {} -type num|null     -default 0
            setdef options valueDim   -minversion 5  -validvalue {} -type str|null     -default "nothing"
            setdef options coord      -minversion 5  -validvalue {} -type list.d|null  -default "nothing"
            setdef options name       -minversion 5  -validvalue {} -type str|null     -default "nothing"
            setdef options x          -minversion 5  -validvalue {} -type num|str|null -default "nothing"
            setdef options y          -minversion 5  -validvalue {} -type num|str|null -default "nothing"
            setdef options xAxis      -minversion 5  -validvalue {} -type str|null     -default "nothing"
            setdef options value      -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options itemStyle  -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::itemStyle $item]
            setdef options label      -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::label $item]
            setdef options emphasis   -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::emphasis $item]
            setdef options blur       -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::blur $item]

            set item [dict remove $item label itemStyle emphasis blur]

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
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options label -minversion 5  -validvalue {}          -type str|null -default "nothing"
        setdef options value -minversion 5  -validvalue {}          -type num|null -default "nothing"
        setdef options color -minversion 5  -validvalue formatColor -type str|null -default "nothing"
        setdef options min   -minversion 5  -validvalue {}          -type num|null -default "nothing"
        setdef options max   -minversion 5  -validvalue {}          -type num|null -default "nothing"
        setdef options gt    -minversion 5  -validvalue {}          -type num|null -default "nothing"
        setdef options gte   -minversion 5  -validvalue {}          -type num|null -default "nothing"
        setdef options lt    -minversion 5  -validvalue {}          -type num|null -default "nothing"
        setdef options lte   -minversion 5  -validvalue {}          -type num|null -default "nothing"
        
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

        set data [dict get $d -data]

        setdef options name       -minversion 5  -validvalue {}               -type str|null        -default "nothing"
        setdef options type       -minversion 5  -validvalue {}               -type str|null        -default "nothing"
        setdef options valueIndex -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options valueDim   -minversion 5  -validvalue {}               -type str|null        -default "nothing"
        setdef options coord      -minversion 5  -validvalue {}               -type list.d|null     -default "nothing"
        setdef options xAxis      -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options yAxis      -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options value      -minversion 5  -validvalue {}               -type num|null        -default "nothing"
        setdef options symbol     -minversion 5  -validvalue formatItemSymbol -type str|null        -default "nothing"
        setdef options symbolSize -minversion 5  -validvalue {}               -type num|list.n|null -default "nothing"
        setdef options itemStyle  -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::itemStyle $data]
        setdef options label      -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::label $data]
        
        if {[dict exists $data emphasis]} {
            dict set data emphasis scale     "nothing"
            dict set data emphasis focus     "nothing"
            dict set data emphasis blurScope "nothing"
            dict set data emphasis labelLine "nothing"
            dict set data emphasis lineStyle "nothing"
            dict set data emphasis areaStyle "nothing"
            dict set data emphasis endLabel  "nothing"
        }
        
        setdef options emphasis                -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::emphasis $data]
        setdef options animation               -minversion 5  -validvalue {}            -type bool|null       -default "nothing"
        setdef options animationThreshold      -minversion 5  -validvalue {}            -type num|null        -default "nothing"
        setdef options animationDuration       -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
        setdef options animationEasing         -minversion 5  -validvalue formatAEasing -type str|null        -default "nothing"
        setdef options animationDelay          -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
        setdef options animationDurationUpdate -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
        setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing -type str|null        -default "nothing"
        setdef options animationDelayUpdate    -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"

        set data [dict remove $data itemStyle label emphasis]

        lappend opts [merge $options $data]
        set options {}
    }

    return [list {*}$opts]

}

proc ticklecharts::linkAxisPointerItem {value} {

    if {![dict exists $value link]} {
        return "nothing"
    }

    foreach item [dict get $value link] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options xAxisIndex       -minversion 5  -validvalue {}  -type str|num|list.n|null  -default "nothing"
        setdef options xAxisName        -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options xAxisId          -minversion 5  -validvalue {}  -type list.s|null          -default "nothing"
        setdef options xAxis            -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options yAxisIndex       -minversion 5  -validvalue {}  -type str|num|list.n|null  -default "nothing"
        setdef options yAxisName        -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options yAxisId          -minversion 5  -validvalue {}  -type list.s|null          -default "nothing"
        setdef options yAxis            -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options radiusAxisIndex  -minversion 5  -validvalue {}  -type str|num|list.n|null  -default "nothing"
        setdef options radiusAxisName   -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options radiusAxisId     -minversion 5  -validvalue {}  -type list.s|null          -default "nothing"
        setdef options radiusAxis       -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options angleAxisIndex   -minversion 5  -validvalue {}  -type str|num|list.n|null  -default "nothing"
        setdef options angleAxisName    -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options angleAxisId      -minversion 5  -validvalue {}  -type list.s|null          -default "nothing"
        setdef options angleAxis        -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options singleAxisIndex  -minversion 5  -validvalue {}  -type str|num|list.n|null  -default "nothing"
        setdef options singleAxisName   -minversion 5  -validvalue {}  -type str|null             -default "nothing"
        setdef options singleAxisId     -minversion 5  -validvalue {}  -type list.s|null          -default "nothing"
        setdef options singleAxis       -minversion 5  -validvalue {}  -type str|null             -default "nothing"

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::timelineItem {value} {

    if {![dict exists $value -data]} {
        error "key data not present..."
    }

    set d [dict get $value -data]

    if {![dict exists $d value]} {
        error "key 'value' must be present in -data"
    }

    if {[llength $value] % 2} {
        error "value list must have an even number of elements..."
    }

    # force string value for this key below
    dict set d value [string cat [dict get $d value] "<s!>"]

    setdef options value            -minversion 5  -validvalue {}               -type str|null    -default "nothing"
    setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str|null    -default "nothing"
    setdef options symbolSize       -minversion 5  -validvalue {}               -type num|null    -default "nothing"
    setdef options tooltip          -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::tooltip $d]

    set d [dict remove $d tooltip]
    

    set options [merge $options $d]

    return $options

}

proc ticklecharts::dataBackground {value} {

    if {![dict exists $value dataBackground]} {
        return "nothing"
    }
    
    set d [dict get $value dataBackground]

    setdef options lineStyle -minversion 5  -validvalue {}  -type dict|null -default [ticklecharts::lineStyle $d]
    setdef options areaStyle -minversion 5  -validvalue {}  -type dict|null -default [ticklecharts::areaStyle $d]

    set d [dict remove $d lineStyle areaStyle]

    set options [merge $options $d]

    return $options
}

proc ticklecharts::selectedDataBackground {value} {

    if {![dict exists $value selectedDataBackground]} {
        return "nothing"
    }
    
    set d [dict get $value selectedDataBackground]

    setdef options lineStyle -minversion 5  -validvalue {}  -type dict|null -default [ticklecharts::lineStyle $d]
    setdef options areaStyle -minversion 5  -validvalue {}  -type dict|null -default [ticklecharts::areaStyle $d]

    set d [dict remove $d lineStyle areaStyle]

    set options [merge $options $d]

    return $options
}

proc ticklecharts::itemStyle {value} {

    if {![ticklecharts::keyDictExists "itemStyle" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]
    
    setdef options color            -minversion 5  -validvalue formatColor         -type str|jsfunc|null -default "nothing"
    setdef options borderColor      -minversion 5  -validvalue formatColor         -type str|null        -default "rgb(0, 0, 0)"
    setdef options borderWidth      -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
    setdef options borderType       -minversion 5  -validvalue formatBorderType    -type str|num|list.n  -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}                  -type num|null        -default 0
    setdef options borderCap        -minversion 5  -validvalue formatCap           -type str             -default "butt"
    setdef options borderJoin       -minversion 5  -validvalue formatJoin          -type str             -default "bevel"
    setdef options borderMiterLimit -minversion 5  -validvalue {}                  -type num             -default 10
    setdef options shadowBlur       -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor         -type str|null        -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}                  -type num|null        -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity       -type num|null        -default 1
    setdef options decal            -minversion 5  -validvalue {}                  -type dict|null       -default [ticklecharts::decal $d]
    #...
    
    if {[InfoNameProc 2 "legend"]} {
        setdef options color            -minversion 5  -validvalue formatColor   -type str|jsfunc|null -default "inherit"
        setdef options borderColor      -minversion 5  -validvalue formatColor   -type str|null        -default "inherit"
        setdef options borderWidth      -minversion 5  -validvalue {}            -type str|num|null    -default "auto"
        setdef options borderDashOffset -minversion 5  -validvalue {}            -type str|num|null    -default "inherit"
        setdef options borderCap        -minversion 5  -validvalue formatCap     -type str             -default "inherit"
        setdef options borderJoin       -minversion 5  -validvalue formatJoin    -type str             -default "inherit"
        setdef options borderMiterLimit -minversion 5  -validvalue {}            -type num|str         -default "inherit"
        setdef options opacity          -minversion 5  -validvalue formatOpacity -type str|num|null    -default "inherit"
    }

    if {[InfoNameProc 2 "pieseries"] || [InfoNameProc 2 "sunburstseries"]} {
        setdef options borderColor  -minversion 5  -validvalue formatColor   -type str|null             -default "nothing"
        setdef options borderRadius -minversion 5  -validvalue formatBRadius -type str|num|list.d|null  -default "nothing"
    }

    if {[InfoNameProc 2 "treeseries"]} {
        setdef options borderColor      -minversion 5  -validvalue formatColor   -type str|null        -default "#c23531"
        setdef options borderWidth      -minversion 5  -validvalue {}            -type str|num|null    -default 1.5
    }

    if {[InfoNameProc 2 "sankeyseries"]} {
        setdef options borderColor      -minversion 5  -validvalue formatColor   -type str|null        -default "inherit"
    }

    if {[InfoNameProc 2 "barseries"]} {
        setdef options borderRadius     -minversion 5  -validvalue {}            -type num|null        -default "nothing"
    }

    if {[InfoNameProc 2 "heatmapseries"]} {
        setdef options borderRadius     -minversion "5.3.1" -validvalue {}       -type num|list.n|null -default "nothing"
    }

    if {[InfoNameProc 2 "candlestickseries"]} {
        setdef options color0           -minversion 5  -validvalue formatColor   -type str|null        -default "nothing"
        setdef options borderColor0     -minversion 5  -validvalue formatColor   -type str|null        -default "nothing"
    }

    if {[InfoNameProc 2 "timelineOpts"]} {
        setdef options color           -minversion 5  -validvalue formatColor   -type str|null        -default [EchartsOptsTheme timelineItemColorE]
        setdef options borderColor     -minversion 5  -validvalue formatColor   -type str|null        -default "nothing"
    }

    if {[InfoNameProc 3 "anchor"]} {
        # gauge series...
        setdef options borderColor   -minversion 5  -validvalue formatColor  -type str|null  -default "nothing"
    }

    if {[InfoNameProc 3 "levelsTreeMapItem"]} {
        setdef options borderColor            -minversion 5  -validvalue formatColor -type str|null             -default "nothing"
        setdef options borderRadius           -minversion 5  -validvalue {}          -type str|num|list.d|null  -default "nothing"
        setdef options gapWidth               -minversion 5  -validvalue {}          -type num|null             -default "nothing"
        setdef options borderColorSaturation  -minversion 5  -validvalue {}          -type num|null             -default "nothing"
    }

    set d [dict remove $d decal]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::emphasis {value} {

    if {![ticklecharts::keyDictExists "emphasis" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options disabled  -minversion "5.3.0"       -validvalue {}              -type bool|null               -default "nothing"
    setdef options scale     -minversion "5.0.0:5.3.2" -validvalue {}              -type bool|null:bool|num|null -default "True"
    setdef options focus     -minversion "5.1.0"       -validvalue formatFocus     -type str|null                -default "none"
    setdef options blurScope -minversion 5             -validvalue formatBlurScope -type str|null                -default "coordinateSystem"
    setdef options label     -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::label     $d]
    setdef options labelLine -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::labelLine $d]
    setdef options itemStyle -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::itemStyle $d]
    setdef options lineStyle -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::lineStyle $d]
    setdef options areaStyle -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::areaStyle $d]
    setdef options endLabel  -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::endLabel  $d]
    #...

    set d [dict remove $d label labelLine itemStyle lineStyle areaStyle endLabel]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::markPoint {value} {

    if {![dict exists $value -markPoint]} {
        return "nothing"
    }

    set d [dict get $value -markPoint]
    
    setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str         -default "pin"
    setdef options symbolSize       -minversion 5  -validvalue {}               -type num|list.n  -default 50
    setdef options symbolRotate     -minversion 5  -validvalue {}               -type num|null    -default "nothing"
    setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool        -default "False"
    setdef options symbolOffset     -minversion 5  -validvalue {}               -type list.d|null -default "nothing"
    setdef options silent           -minversion 5  -validvalue {}               -type bool        -default "False"
    setdef options label            -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::label     $d]
    setdef options itemStyle        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::itemStyle $d]
    
    if {[dict exists $d emphasis]} {
        dict set d emphasis scale     "nothing"
        dict set d emphasis focus     "nothing"
        dict set d emphasis blurScope "nothing"
        dict set d emphasis labelLine "nothing"
        dict set d emphasis lineStyle "nothing"
        dict set d emphasis areaStyle "nothing"
        dict set d emphasis endLabel  "nothing"
    }
    
    if {[dict exists $d blur]} {
        dict set d blur labelLine "nothing"
        dict set d blur lineStyle "nothing"
        dict set d blur areaStyle "nothing"
        dict set d blur endLabel  "nothing"
    }
    
    setdef options emphasis -minversion 5  -validvalue {} -type dict|null   -default [ticklecharts::emphasis $d]
    setdef options blur     -minversion 5  -validvalue {} -type dict|null   -default [ticklecharts::blur $d]
    setdef options data     -minversion 5  -validvalue {} -type list.o|null -default [ticklecharts::markPointItem $d]
    #...
    
    set d [dict remove $d data blur label itemStyle emphasis]
    
    set options [merge $options $d]

    return $options
}

proc ticklecharts::blur {value} {

    if {![ticklecharts::keyDictExists "blur" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label     $d]
    setdef options labelLine -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::labelLine $d]
    setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
    setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
    setdef options areaStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::areaStyle $d]
    setdef options endLabel  -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::endLabel  $d]
    #...

    set d [dict remove $d label labelLine itemStyle lineStyle areaStyle endLabel]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::select {value} {

    if {![ticklecharts::keyDictExists "select" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options disabled  -minversion "5.3.0" -validvalue {} -type bool|null -default "nothing"
    setdef options label     -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::label     $d]
    setdef options labelLine -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::labelLine $d]
    setdef options itemStyle -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
    setdef options lineStyle -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
    setdef options areaStyle -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::areaStyle $d]
    setdef options endLabel  -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::endLabel  $d]
    #...

    set d [dict remove $d label labelLine itemStyle lineStyle areaStyle endLabel]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::decal {value} {

    if {![dict exists $value decal]} {
        return "nothing"
    }

    setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str        -default "rect"
    setdef options symbolSize       -minversion 5  -validvalue {}               -type num        -default 1
    setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool       -default "True"
    setdef options color            -minversion 5  -validvalue formatColor      -type str|jsfunc -default "rgba(0, 0, 0, 0.2)"
    setdef options backgroundColor  -minversion 5  -validvalue formatColor      -type str|null   -default "nothing"
    setdef options dashArrayX       -minversion 5  -validvalue {}               -type num        -default 5
    setdef options dashArrayY       -minversion 5  -validvalue {}               -type num        -default 5
    setdef options rotation         -minversion 5  -validvalue {}               -type num        -default 0
    setdef options maxTileWidth     -minversion 5  -validvalue {}               -type num        -default 512
    setdef options maxTileHeight    -minversion 5  -validvalue {}               -type num        -default 512
    #...

    set options [merge $options [dict get $value decal]]

    return $options

}

proc ticklecharts::SetRadiusAxis {value} {

    setdef options -id             -minversion 5  -validvalue {}                  -type str|null            -default "nothing"
    setdef options -polarIndex     -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -type           -minversion 5  -validvalue formatType          -type str|null            -default "nothing"
    setdef options -name           -minversion 5  -validvalue {}                  -type str|null            -default "nothing"
    setdef options -nameLocation   -minversion 5  -validvalue formatNameLocation  -type str|null            -default "nothing"
    setdef options -nameTextStyle  -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::nameTextStyle $value]
    setdef options -nameGap        -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -nameRotate     -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -inverse        -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    setdef options -boundaryGap    -minversion 5  -validvalue {}                  -type bool|list.d|null    -default "nothing"
    setdef options -min            -minversion 5  -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
    setdef options -max            -minversion 5  -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
    setdef options -scale          -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    setdef options -splitNumber    -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -minInterval    -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -maxInterval    -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -interval       -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -logBase        -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -silent         -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    setdef options -triggerEvent   -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    setdef options -axisLine       -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::splitArea $value]
    setdef options -data           -minversion 5  -validvalue {}                  -type list.d|null         -default "nothing"
    setdef options -axisPointer    -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options -z              -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    #...

    # remove key(s)
    set value [dict remove $value -axisLine -axisTick -minorSplitLine \
                                  -axisLabel -splitLine -axisPointer \
                                  -splitArea -nameTextStyle -minorTick]

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::SetRadarCoordinate {value} {

    setdef options -id           -minversion 5  -validvalue {}               -type str|null       -default "nothing"
    setdef options -zlevel       -minversion 5  -validvalue {}               -type num|null       -default "nothing"
    setdef options -z            -minversion 5  -validvalue {}               -type num|null       -default "nothing"
    setdef options -center       -minversion 5  -validvalue {}               -type list.d         -default [list {"50%" "50%"}]
    setdef options -radius       -minversion 5  -validvalue {}               -type list.d|num|str -default "75%"
    setdef options -startAngle   -minversion 5  -validvalue formatStartangle -type num            -default 90
    setdef options -axisName     -minversion 5  -validvalue {}               -type dict|null      -default [ticklecharts::axisName $value]
    setdef options -nameGap      -minversion 5  -validvalue {}               -type num|null       -default 15
    setdef options -splitNumber  -minversion 5  -validvalue {}               -type num|null       -default 5
    setdef options -shape        -minversion 5  -validvalue formatShape      -type str            -default "polygon"
    setdef options -scale        -minversion 5  -validvalue {}               -type bool|null      -default "nothing"
    setdef options -triggerEvent -minversion 5  -validvalue {}               -type bool|null      -default "nothing"
    setdef options -axisLine     -minversion 5  -validvalue {}               -type dict|null      -default [ticklecharts::axisLine $value]
    setdef options -axisTick     -minversion 5  -validvalue {}               -type dict|null      -default [ticklecharts::axisTick $value]
    setdef options -axisLabel    -minversion 5  -validvalue {}               -type dict|null      -default [ticklecharts::axisLabel $value]
    setdef options -splitLine    -minversion 5  -validvalue {}               -type dict|null      -default [ticklecharts::splitLine $value]
    setdef options -splitArea    -minversion 5  -validvalue {}               -type dict|null      -default [ticklecharts::splitArea $value]
    setdef options -indicator    -minversion 5  -validvalue {}               -type list.o         -default [ticklecharts::IndicatorItem $value]
    #...

    # remove key(s)
    set value [dict remove $value -axisLine -axisTick \
                                  -axisName -axisLabel -splitLine \
                                  -splitArea -indicatoritem]

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::SetAngleAxis {value} {

    setdef options -id             -minversion 5  -validvalue {}               -type str|null            -default "nothing"
    setdef options -polarIndex     -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options -startAngle     -minversion 5  -validvalue formatStartangle -type num                 -default 90
    setdef options -clockwise      -minversion 5  -validvalue {}               -type bool                -default "True"
    setdef options -type           -minversion 5  -validvalue formatType       -type str|null            -default "nothing"
    setdef options -boundaryGap    -minversion 5  -validvalue {}               -type bool|list.d|null    -default "nothing"
    setdef options -min            -minversion 5  -validvalue {}               -type num|str|jsfunc|null -default "nothing"
    setdef options -max            -minversion 5  -validvalue {}               -type num|str|jsfunc|null -default "nothing"
    setdef options -scale          -minversion 5  -validvalue {}               -type bool|null           -default "nothing"
    setdef options -splitNumber    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options -minInterval    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options -maxInterval    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options -interval       -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options -logBase        -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options -silent         -minversion 5  -validvalue {}               -type bool|null           -default "nothing"
    setdef options -triggerEvent   -minversion 5  -validvalue {}               -type bool|null           -default "nothing"
    setdef options -axisLine       -minversion 5  -validvalue {}               -type dict|null           -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -minversion 5  -validvalue {}               -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -minversion 5  -validvalue {}               -type dict|null           -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -minversion 5  -validvalue {}               -type dict|null           -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -minversion 5  -validvalue {}               -type dict|null           -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -minversion 5  -validvalue {}               -type dict|null           -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -minversion 5  -validvalue {}               -type dict|null           -default [ticklecharts::splitArea $value]
    setdef options -data           -minversion 5  -validvalue {}               -type list.d|null         -default "nothing"
    setdef options -axisPointer    -minversion 5  -validvalue {}               -type dict|null           -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options -z              -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    #...

    # remove key(s)
    set value [dict remove $value -axisLine -axisTick \
                                  -minorTick -axisLabel -splitLine \
                                  -minorSplitLine -splitArea -axisPointer]

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::setXAxis {chart value} {
    
    setdef options -id             -minversion 5       -validvalue {}                  -type str|null            -default "nothing"
    setdef options -show           -minversion 5       -validvalue {}                  -type bool                -default "True"
    setdef options -type           -minversion 5       -validvalue formatType          -type str|null            -default "category"
    setdef options -data           -minversion 5       -validvalue {}                  -type list.d|null         -default "nothing"
    setdef options -gridIndex      -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -alignTicks     -minversion "5.3.0" -validvalue {}                  -type bool|null           -default "nothing"
    setdef options -position       -minversion 5       -validvalue formatXAxisPosition -type str                 -default "bottom"
    setdef options -offset         -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -name           -minversion 5       -validvalue {}                  -type str|null            -default "nothing"
    setdef options -nameLocation   -minversion 5       -validvalue formatNameLocation  -type str                 -default "end"
    setdef options -nameTextStyle  -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::nameTextStyle $value]
    setdef options -nameGap        -minversion 5       -validvalue {}                  -type num                 -default 15
    setdef options -nameRotate     -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -inverse        -minversion 5       -validvalue {}                  -type bool                -default "False"
    setdef options -boundaryGap    -minversion 5       -validvalue {}                  -type bool|list.d         -default "True"
    setdef options -min            -minversion 5       -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
    setdef options -max            -minversion 5       -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
    setdef options -scale          -minversion 5       -validvalue {}                  -type bool                -default "False"
    setdef options -splitNumber    -minversion 5       -validvalue {}                  -type num                 -default 5
    setdef options -minInterval    -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -maxInterval    -minversion 5       -validvalue {}                  -type num|null            -default "nothing"
    setdef options -interval       -minversion 5       -validvalue {}                  -type num|null            -default "nothing"
    setdef options -logBase        -minversion 5       -validvalue {}                  -type num|null            -default "nothing"
    setdef options -silent         -minversion 5       -validvalue {}                  -type bool                -default "False"
    setdef options -triggerEvent   -minversion 5       -validvalue {}                  -type bool                -default "False"
    setdef options -axisLine       -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::axisLine $value]
    setdef options -axisTick       -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -minorTick      -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::minorTick $value]
    setdef options -axisLabel      -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::axisLabel $value]
    setdef options -splitLine      -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea      -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::splitArea $value]
    setdef options -axisPointer    -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::axisPointer $value]
    setdef options -zlevel         -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -z              -minversion 5       -validvalue {}                  -type num                 -default 0

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data]} {
            error "'chart' Class cannot contain Xaxis 'data' when a class dataset is present"
        }
    }

    # remove key(s)
    set value [dict remove $value -nameTextStyle -axisLine -axisTick \
                                  -minorTick -axisLabel -splitLine \
                                  -minorSplitLine -splitArea -axisPointer]
    
    set options [merge $options $value]

    return $options

}

proc ticklecharts::setYAxis {chart value} {

    setdef options -id              -minversion 5       -validvalue {}                  -type str|null            -default "nothing"
    setdef options -show            -minversion 5       -validvalue {}                  -type bool                -default "True"
    setdef options -gridIndex       -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -alignTicks      -minversion "5.3.0" -validvalue {}                  -type bool|null           -default "nothing"
    setdef options -position        -minversion 5       -validvalue formatYAxisPosition -type str                 -default "left"
    setdef options -offset          -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -realtimeSort    -minversion 5       -validvalue {}                  -type bool                -default "True"
    setdef options -sortSeriesIndex -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -type            -minversion 5       -validvalue formatType          -type str|null            -default "value"
    setdef options -data            -minversion 5       -validvalue {}                  -type list.d|null         -default "nothing"
    setdef options -name            -minversion 5       -validvalue {}                  -type str|null            -default "nothing"
    setdef options -nameLocation    -minversion 5       -validvalue formatNameLocation  -type str                 -default "end"
    setdef options -nameTextStyle   -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::nameTextStyle $value]
    setdef options -nameGap         -minversion 5       -validvalue {}                  -type num                 -default 15
    setdef options -nameRotate      -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -inverse         -minversion 5       -validvalue {}                  -type bool                -default "False"
    setdef options -boundaryGap     -minversion 5       -validvalue {}                  -type bool|list.s         -default "False"
    setdef options -min             -minversion 5       -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
    setdef options -max             -minversion 5       -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
    setdef options -scale           -minversion 5       -validvalue {}                  -type bool                -default "False"
    setdef options -splitNumber     -minversion 5       -validvalue {}                  -type num                 -default 5
    setdef options -minInterval     -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -maxInterval     -minversion 5       -validvalue {}                  -type num|null            -default "nothing"
    setdef options -interval        -minversion 5       -validvalue {}                  -type num|null            -default "nothing"
    setdef options -logBase         -minversion 5       -validvalue {}                  -type num|null            -default "nothing"
    setdef options -silent          -minversion 5       -validvalue {}                  -type bool                -default "False"
    setdef options -triggerEvent    -minversion 5       -validvalue {}                  -type bool                -default "False"
    setdef options -axisLine        -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::axisLine $value]
    setdef options -axisTick        -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -minorTick       -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::minorTick $value]
    setdef options -axisLabel       -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::axisLabel $value]
    setdef options -splitLine       -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::splitLine $value]
    setdef options -minorSplitLine  -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::minorSplitLine $value]
    setdef options -splitArea       -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::splitArea $value]
    setdef options -axisPointer     -minversion 5       -validvalue {}                  -type dict|null           -default [ticklecharts::axisPointer $value]
    setdef options -zlevel          -minversion 5       -validvalue {}                  -type num                 -default 0
    setdef options -z               -minversion 5       -validvalue {}                  -type num                 -default 0

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    if {$dataset ne ""} {
        if {[dict exists $value -data]} {
            error "'chart' Class cannot contain YAxis 'data' when a class dataset is present"
        }
    }

    # remove key(s)
    set value [dict remove $value -nameTextStyle -axisLine -axisTick \
                                  -minorTick -axisLabel -splitLine \
                                  -minorSplitLine -splitArea -axisPointer]
    
    set options [merge $options $value]

    return $options

}

proc ticklecharts::SetSingleAxis {value} {
    
    setdef options -id             -minversion 5  -validvalue {}                 -type str|null            -default "nothing"
    setdef options -zlevel         -minversion 5  -validvalue {}                 -type num                 -default 0
    setdef options -z              -minversion 5  -validvalue {}                 -type num                 -default 2
    setdef options -left           -minversion 5  -validvalue formatLeft         -type num|str             -default "5%"
    setdef options -top            -minversion 5  -validvalue formatTop          -type num|str             -default "5%"
    setdef options -right          -minversion 5  -validvalue formatRight        -type num|str             -default "5%"
    setdef options -bottom         -minversion 5  -validvalue formatBottom       -type num|str             -default "5%"
    setdef options -width          -minversion 5  -validvalue {}                 -type num|str             -default "auto"
    setdef options -height         -minversion 5  -validvalue {}                 -type num|str             -default "auto"
    setdef options -orient         -minversion 5  -validvalue formatOrient       -type str                 -default "horizontal"
    setdef options -type           -minversion 5  -validvalue formatType         -type str|null            -default "value"
    setdef options -name           -minversion 5  -validvalue {}                 -type str|null            -default "nothing"
    setdef options -nameLocation   -minversion 5  -validvalue formatNameLocation -type str                 -default "end"
    setdef options -nameTextStyle  -minversion 5  -validvalue {}                 -type dict|null           -default [ticklecharts::nameTextStyle $value]
    setdef options -nameGap        -minversion 5  -validvalue {}                 -type num                 -default 15
    setdef options -nameRotate     -minversion 5  -validvalue {}                 -type num                 -default 0
    setdef options -inverse        -minversion 5  -validvalue {}                 -type bool                -default "False"
    setdef options -boundaryGap    -minversion 5  -validvalue {}                 -type bool|list.d         -default "True"
    setdef options -min            -minversion 5  -validvalue {}                 -type num|str|jsfunc|null -default "nothing"
    setdef options -max            -minversion 5  -validvalue {}                 -type num|str|jsfunc|null -default "nothing"
    setdef options -scale          -minversion 5  -validvalue {}                 -type bool|null           -default "nothing"
    setdef options -splitNumber    -minversion 5  -validvalue {}                 -type num                 -default 5
    setdef options -minInterval    -minversion 5  -validvalue {}                 -type num                 -default 0
    setdef options -maxInterval    -minversion 5  -validvalue {}                 -type num|null            -default "nothing"
    setdef options -interval       -minversion 5  -validvalue {}                 -type num|null            -default "nothing"
    setdef options -logBase        -minversion 5  -validvalue {}                 -type num|null            -default "nothing"
    setdef options -silent         -minversion 5  -validvalue {}                 -type bool                -default "False"
    setdef options -triggerEvent   -minversion 5  -validvalue {}                 -type bool                -default "False"
    setdef options -axisPointer    -minversion 5  -validvalue {}                 -type dict|null           -default [ticklecharts::axisPointer $value]
    setdef options -axisTick       -minversion 5  -validvalue {}                 -type dict|null           -default [ticklecharts::axisTick $value]
    setdef options -axisLabel      -minversion 5  -validvalue {}                 -type dict|null           -default [ticklecharts::axisLabel $value]
    # ...

    # remove key(s)
    set value [dict remove $value -nameTextStyle -axisTick \
                                  -axisLabel -axisPointer]

    set options [merge $options $value]

    return $options

}

proc ticklecharts::SetParallelAxis {value} {

    foreach item {*}$value {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options -id              -minversion 5  -validvalue {}                  -type str|null            -default "nothing"
        setdef options -dim             -minversion 5  -validvalue {}                  -type num                 -default 0
        setdef options -parallelIndex   -minversion 5  -validvalue {}                  -type num                 -default 0
        setdef options -realtime        -minversion 5  -validvalue {}                  -type bool                -default "True"
        setdef options -areaSelectStyle -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::areaSelectStyle $item]
        setdef options -type            -minversion 5  -validvalue formatType          -type str|null            -default "value"
        setdef options -name            -minversion 5  -validvalue {}                  -type str|null            -default "nothing"
        setdef options -nameLocation    -minversion 5  -validvalue formatNameLocation  -type str|null            -default "end"
        setdef options -nameTextStyle   -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::nameTextStyle $item]
        setdef options -nameGap         -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
        setdef options -nameRotate      -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
        setdef options -inverse         -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
        setdef options -boundaryGap     -minversion 5  -validvalue {}                  -type bool|list.d|null    -default "nothing"
        setdef options -min             -minversion 5  -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
        setdef options -max             -minversion 5  -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
        setdef options -scale           -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
        setdef options -splitNumber     -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
        setdef options -minInterval     -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
        setdef options -maxInterval     -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
        setdef options -interval        -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
        setdef options -logBase         -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
        setdef options -silent          -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
        setdef options -triggerEvent    -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
        setdef options -axisLine        -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisLine $item]
        setdef options -axisTick        -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisTick $item]
        setdef options -minorTick       -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::minorTick $item]
        setdef options -axisLabel       -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisLabel $item]
        setdef options -data            -minversion 5  -validvalue {}                  -type list.d|null         -default "nothing"
        #...

        # remove key(s)
        set item [dict remove $item -areaSelectStyle -NameTextStyle -axisLine -axisTick -minorTick -axisLabel]

        lappend opts [merge $options $item]
        set options {}

    }

    return $opts

}

proc ticklecharts::SetGraphic {value} {
    
    setdef options -id       -minversion 5  -validvalue {} -type str|null    -default "nothing"
    setdef options -elements -minversion 5  -validvalue {} -type list.o|null -default [ticklecharts::childrenElements $value "-elements"]

    set value [dict remove $value -elements]
    
    set options [merge $options $value]

    return $options

}

proc ticklecharts::childrenElements {value key} {
    
    if {![dict exists $value $key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {![dict exists $item type]} {
            error "'type' for '$key' should be specified..."
        }

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        set typegraphic [dict get $item type]

        setdef options type            -minversion 5  -validvalue {}             -type str             -default $typegraphic
        setdef options id              -minversion 5  -validvalue {}             -type str|null        -default "nothing"
        setdef options x               -minversion 5  -validvalue {}             -type num|null        -default "nothing"
        setdef options y               -minversion 5  -validvalue {}             -type num|null        -default "nothing"
        setdef options rotation        -minversion 5  -validvalue {}             -type num|null        -default 0
        setdef options scaleX          -minversion 5  -validvalue {}             -type num|null        -default 1
        setdef options scaleY          -minversion 5  -validvalue {}             -type num|null        -default 1
        setdef options originX         -minversion 5  -validvalue {}             -type num|null        -default "nothing"
        setdef options originY         -minversion 5  -validvalue {}             -type num|null        -default "nothing"
        setdef options transition      -minversion 5  -validvalue {}             -type str|list.s|null -default [list {x y}]
        setdef options enterFrom       -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::propertiesAnimation $item "enterFrom"]
        setdef options leaveTo         -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::propertiesAnimation $item "leaveTo"]
        setdef options enterAnimation  -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::typeAnimation $item "enterAnimation"]
        setdef options updateAnimation -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::typeAnimation $item "updateAnimation"]
        setdef options leaveAnimation  -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::typeAnimation $item "leaveAnimation"]
        setdef options left            -minversion 5  -validvalue formatELeft    -type str|num|null    -default "nothing"
        setdef options right           -minversion 5  -validvalue formatERight   -type str|num|null    -default "nothing"
        setdef options top             -minversion 5  -validvalue formatETop     -type str|num|null    -default "nothing"
        setdef options bottom          -minversion 5  -validvalue formatEBottom  -type str|num|null    -default "nothing"
        setdef options bounding        -minversion 5  -validvalue formatBounding -type str             -default "all"
        setdef options z               -minversion 5  -validvalue {}             -type num             -default 0
        setdef options zlevel          -minversion 5  -validvalue {}             -type num             -default 0
        setdef options info            -minversion 5  -validvalue {}             -type jsfunc|null     -default "nothing"
        setdef options silent          -minversion 5  -validvalue {}             -type bool            -default "False"
        setdef options invisible       -minversion 5  -validvalue {}             -type bool            -default "False"
        setdef options ignore          -minversion 5  -validvalue {}             -type bool            -default "False"
        # setdef options textContent   -minversion 5  -validvalue {}             -type dict|null       -default "nothing"
        setdef options textConfig      -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::textConfig $item]
        setdef options during          -minversion 5  -validvalue {}             -type jsfunc|null     -default "nothing"
        setdef options cursor          -minversion 5  -validvalue formatCursor   -type str             -default "pointer"
        setdef options draggable       -minversion 5  -validvalue {}             -type bool            -default "False"
        setdef options progressive     -minversion 5  -validvalue {}             -type bool            -default "False"

        switch -exact -- $typegraphic {
            group {
                setdef options keyframeAnimation  -minversion 5  -validvalue {} -type list.o|null  -default [ticklecharts::keyframeAnimation $item $typegraphic]
                setdef options width              -minversion 5  -validvalue {} -type num|null     -default "nothing"
                setdef options height             -minversion 5  -validvalue {} -type num|null     -default "nothing"
                setdef options diffChildrenByName -minversion 5  -validvalue {} -type bool|null    -default "nothing"
                setdef options children           -minversion 5  -validvalue {} -type list.o|null  -default [ticklecharts::appendInGroup $item]
                # ...
            }
            image {
                setdef options keyframeAnimation  -minversion 5  -validvalue {}              -type list.o|null  -default [ticklecharts::keyframeAnimation $item $typegraphic]
                setdef options style              -minversion 5  -validvalue {}              -type dict|null    -default [ticklecharts::style $item $typegraphic]
                setdef options focus              -minversion 5  -validvalue formatFocus     -type str          -default "none"
                setdef options blurScope          -minversion 5  -validvalue formatBlurScope -type str          -default "coordinateSystem"
                # ...
            }
            text {
                setdef options keyframeAnimation  -minversion 5  -validvalue {}              -type list.o|null  -default [ticklecharts::keyframeAnimation $item $typegraphic]
                setdef options style              -minversion 5  -validvalue {}              -type dict|null    -default [ticklecharts::style $item $typegraphic]
                setdef options focus              -minversion 5  -validvalue formatFocus     -type str          -default "none"
                setdef options blurScope          -minversion 5  -validvalue formatBlurScope -type str          -default "coordinateSystem"
                # ...
            }
            circle      -
            ring        -
            sector      -
            arc         -
            polygon     -
            polyline    -
            line        -
            bezierCurve -
            rect {
                setdef options keyframeAnimation  -minversion 5  -validvalue {}              -type list.o|null  -default [ticklecharts::keyframeAnimation $item $typegraphic]
                setdef options shape              -minversion 5  -validvalue {}              -type dict|null    -default [ticklecharts::shape $item $typegraphic]
                setdef options style              -minversion 5  -validvalue {}              -type dict|null    -default [ticklecharts::style $item $typegraphic]
                setdef options focus              -minversion 5  -validvalue formatFocus     -type str          -default "none"
                setdef options blurScope          -minversion 5  -validvalue formatBlurScope -type str          -default "coordinateSystem"
                # ...
            }

            default {error "bad type or not supported..."}
        }


        setdef options onclick      -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options onmouseover  -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options onmouseout   -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options onmousemove  -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options onmousewheel -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options onmousedown  -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options onmouseup    -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options ondrag       -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options ondragstart  -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options ondragend    -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options ondragenter  -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options ondragleave  -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options ondragover   -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"
        setdef options ondrop       -minversion 5  -validvalue {} -type jsfunc|null  -default "nothing"

        
        set item [dict remove $item enterFrom leaveTo \
                            enterAnimation updateAnimation \
                            leaveAnimation keyframeAnimation textConfig style children shape]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::appendInGroup {value} {

    if {![dict exists $value children]} {
        return "nothing"
    }

    foreach item [dict get $value children] {
        set d [list "children" [list $item]]
        lappend opts {*}[ticklecharts::childrenElements $d "children"]
    }

    return [list {*}$opts]

}

proc ticklecharts::shape {value type} {

    if {![dict exists $value shape]} {
        return "nothing"
    }

    set d [dict get $value shape]

    switch -exact -- $type {
        rect {
            setdef options x          -minversion 5  -validvalue {} -type num|null    -default "nothing"
            setdef options y          -minversion 5  -validvalue {} -type num|null    -default "nothing"
            setdef options width      -minversion 5  -validvalue {} -type num|null    -default "nothing"
            setdef options height     -minversion 5  -validvalue {} -type num|null    -default "nothing"
            setdef options r          -minversion 5  -validvalue {} -type list.n|null -default "nothing"
        }
        circle {
            setdef options cx         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options cy         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options r          -minversion 5  -validvalue {} -type num|null     -default "nothing"
        }
        ring {
            setdef options cx         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options cy         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options r          -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options r0         -minversion 5  -validvalue {} -type num|null     -default "nothing"
        }
        arc -
        sector {
            setdef options cx         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options cy         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options r          -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options r0         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options startAngle -minversion 5  -validvalue {} -type num          -default 0
            setdef options endAngle   -minversion 5  -validvalue {} -type num          -default [expr {3.14159 * 2}]
            setdef options clockwise  -minversion 5  -validvalue {} -type bool         -default "True"
        }
        polyline -
        polygon {
            setdef options points           -minversion 5  -validvalue {}                -type list.n|null   -default "nothing"
            setdef options smooth           -minversion 5  -validvalue formatShapeSmooth -type num|str|null  -default "nothing"
            setdef options smoothConstraint -minversion 5  -validvalue {}                -type bool|null     -default "nothing"
        }
        line {
            setdef options x1         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options y1         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options x2         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options y2         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options percent    -minversion 5  -validvalue {} -type num          -default 1
        }
        bezierCurve {
            setdef options x1         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options y1         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options x2         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options y2         -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options cpx1       -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options cpy1       -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options cpx2       -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options cpy2       -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options percent    -minversion 5  -validvalue {} -type num          -default 1
        }
        default {error "bad shape type or not supported for this $type..."}
    }

    setdef options transition -minversion 5  -validvalue {} -type list.s|str|null -default "nothing"

    set options [merge $options $d]

    return $options

}

proc ticklecharts::style {value type} {

    if {![dict exists $value style]} {
        return "nothing"
    }

    set d [dict get $value style]

    if {[dict exists $d $type]} {
        # spaces in path... ??
        dict set d $type [ticklecharts::MapSpaceString [dict get $d $type]]
    }

    switch -exact -- $type {
        image {
            setdef options image  -minversion 5  -validvalue {} -type str|null -default "nothing"
            setdef options height -minversion 5  -validvalue {} -type num|null -default "nothing"
        }
        text {
            setdef options text              -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
            setdef options overflow          -minversion 5  -validvalue formatOverflow          -type str|null    -default "nothing"
            setdef options font              -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
            setdef options fontSize          -minversion 5  -validvalue {}                      -type num|null    -default "nothing"
            setdef options fontWeight        -minversion 5  -validvalue formatFontWeight        -type str|null    -default "nothing"
            setdef options lineDash          -minversion 5  -validvalue {}                      -type list.n|null -default "nothing"
            setdef options lineDashOffset    -minversion 5  -validvalue {}                      -type num|null    -default "nothing"
            setdef options textAlign         -minversion 5  -validvalue formatTextAlign         -type str|null    -default "nothing"
            setdef options textVerticalAlign -minversion 5  -validvalue formatVerticalTextAlign -type str|null    -default "nothing"
        }
    }

    setdef options width         -minversion 5  -validvalue {}          -type num|null        -default "nothing"
    setdef options x             -minversion 5  -validvalue {}          -type num|null        -default "nothing"
    setdef options y             -minversion 5  -validvalue {}          -type num|null        -default "nothing"
    setdef options fill          -minversion 5  -validvalue formatColor -type str|null        -default "nothing"
    setdef options stroke        -minversion 5  -validvalue formatColor -type str|null        -default "nothing"
    setdef options lineWidth     -minversion 5  -validvalue {}          -type num|null        -default "nothing"
    setdef options shadowBlur    -minversion 5  -validvalue {}          -type num|null        -default "nothing"
    setdef options shadowOffsetX -minversion 5  -validvalue {}          -type num|null        -default "nothing"
    setdef options shadowOffsetY -minversion 5  -validvalue {}          -type num|null        -default "nothing"
    setdef options shadowColor   -minversion 5  -validvalue formatColor -type str|null        -default "nothing"
    setdef options transition    -minversion 5  -validvalue {}          -type str|list.d|null -default "nothing"


    set options [merge $options $d]

    return $options

}

proc ticklecharts::textConfig {value} {

    if {![dict exists $value textConfig]} {
        return "nothing"
    }

    set d [dict get $value textConfig]

    setdef options position      -minversion 5  -validvalue formatPosition -type str         -default "inside"
    setdef options rotation      -minversion 5  -validvalue {}             -type num         -default 0
    setdef options origin        -minversion 5  -validvalue {}             -type list.d|null -default "nothing"
    setdef options distance      -minversion 5  -validvalue {}             -type num         -default 5
    setdef options local         -minversion 5  -validvalue {}             -type bool        -default "False"
    setdef options insideFill    -minversion 5  -validvalue formatColor    -type str|null    -default "nothing"
    setdef options insideStroke  -minversion 5  -validvalue formatColor    -type str|null    -default "nothing"
    setdef options outsideFill   -minversion 5  -validvalue formatColor    -type str|null    -default "nothing"
    setdef options outsideStroke -minversion 5  -validvalue formatColor    -type str|null    -default "nothing"
    setdef options inside        -minversion 5  -validvalue {}             -type bool|null   -default "nothing"
    # setdef options layoutRect  -minversion 5  -validvalue {}             -type dict|null   -default "nothing"
    # setdef options offset      -minversion 5  -validvalue {}             -type dict|null   -default "nothing"

    set options [merge $options $d]

    return $options

}

proc ticklecharts::keyframeAnimation {value type} {

    if {![dict exists $value keyframeAnimation]} {
        return "nothing"
    }

    foreach item [dict get $value keyframeAnimation] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options duration  -minversion 5  -validvalue {}            -type num|null    -default "nothing"
        setdef options easing    -minversion 5  -validvalue formatAEasing -type str|null    -default "nothing"
        setdef options delay     -minversion 5  -validvalue {}            -type num|null    -default "nothing"
        setdef options loop      -minversion 5  -validvalue {}            -type bool        -default "False"
        setdef options keyframes -minversion 5  -validvalue {}            -type list.o|null -default [ticklecharts::keyframes $item $type]

        set item [dict remove $item keyframes]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::keyframes {value type} {

    if {![dict exists $value keyframes]} {
        return "nothing"
    }

    foreach item [dict get $value keyframes] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options percent -minversion 5  -validvalue {}            -type num|null  -default "nothing"
        setdef options easing  -minversion 5  -validvalue formatAEasing -type str|null  -default "nothing"
        setdef options scaleX  -minversion 5  -validvalue {}            -type num|null  -default "nothing"
        setdef options scaleY  -minversion 5  -validvalue {}            -type num|null  -default "nothing"
        setdef options style   -minversion 5  -validvalue {}            -type dict|null -default [ticklecharts::style $item $type]

        set item [dict remove $item style]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::propertiesAnimation {value key} {

    if {![dict exists $value $key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options x     -minversion 5  -validvalue {} -type num|null  -default 0
    setdef options style -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::propertiestyle $d]

    set d [dict remove $d style]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::propertiestyle {value} {

    if {![dict exists $value style]} {
        return "nothing"
    }

    set d [dict get $value style]

    setdef options opacity -minversion 5  -validvalue {} -type num|null -default 0

    set options [merge $options $d]

    return $options

}

proc ticklecharts::typeAnimation {value key} {

    if {![dict exists $value $key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options duration -minversion 5  -validvalue {}            -type num|null -default "nothing"
    setdef options easing   -minversion 5  -validvalue formatAEasing -type str|null -default "nothing"
    setdef options delay    -minversion 5  -validvalue {}            -type num|null -default "nothing"

    set options [merge $options $d]

    return $options

}

proc ticklecharts::splitLine {value} {

    if {![ticklecharts::keyDictExists "splitLine" $value key]} {
        set key "-splitLine"
    }

    if {$::ticklecharts::theme ne "basic"} {
        if {![dict exists $value $key]} {
            dict set value $key [dict create dummy null]
        }
    }

    if {![dict exists $value $key]} {
        return "nothing"
    }

    if {[InfoNameProc 2 "setXAxis"]} {
        set showgrid [EchartsOptsTheme axisXgridlineShow]
    } elseif {[InfoNameProc 2 "setYAxis"]} {
        set showgrid [EchartsOptsTheme axisYgridlineShow] 
    } else {
        set showgrid "True"
    }

    set d [dict get $value $key]

    setdef options show            -minversion 5  -validvalue {}               -type bool            -default $showgrid
    setdef options onZero          -minversion 5  -validvalue {}               -type bool            -default "True"
    setdef options onZeroAxisIndex -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options symbol          -minversion 5  -validvalue formatItemSymbol -type str|list.s|null -default "null"
    setdef options symbolSize      -minversion 5  -validvalue {}               -type list.n|null     -default "nothing"
    setdef options symbolOffset    -minversion 5  -validvalue {}               -type list.n|num|null -default "nothing"
    setdef options lineStyle       -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::lineStyle $d]

    if {[InfoNameProc 2 "gaugeseries"]} {
        # add flag length series-gauge.splitLine
        setdef options length    -minversion 5  -validvalue {} -type num|null -default "nothing"
        setdef options distance  -minversion 5  -validvalue {} -type num|null -default "nothing"
    }

    #...
    set d [dict remove $d lineStyle]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::universalTransition {value} {

    if {![dict exists $value -universalTransition]} {
        return "nothing"
    }

    set d [dict get $value -universalTransition]

    setdef options enabled     -minversion 5  -validvalue {}                -type bool            -default "False"
    setdef options seriesKey   -minversion 5  -validvalue {}                -type str|list.d|null -default "nothing"
    setdef options divideShape -minversion 5  -validvalue formatDivideShape -type str|null        -default "nothing"
    setdef options delay       -minversion 5  -validvalue {}                -type jsfunc|null     -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::minorSplitLine {value} {

    if {![dict exists $value -minorSplitLine]} {
        return "nothing"
    }

    set d [dict get $value -minorSplitLine]

    setdef options show      -minversion 5  -validvalue {} -type bool      -default "False"
    setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
    #...
    set d [dict remove $d lineStyle]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::splitArea {value} {

    if {![dict exists $value -splitArea]} {
        return "nothing"
    }

    set d [dict get $value -splitArea]

    setdef options interval  -minversion 5  -validvalue {} -type num       -default 0
    setdef options show      -minversion 5  -validvalue {} -type bool      -default "False"
    setdef options areaStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::areaStyle $d]
    #...

    set d [dict remove $d areaStyle]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::areaStyle {value} {

    if {![ticklecharts::keyDictExists "areaStyle" $value key]} {
        return "nothing"
    }

    set opacity 0.5
    
    if {[InfoNameProc 3 "splitArea"]} {
        set color [EchartsOptsTheme splitAreaColor]
    } elseif {[InfoNameProc 3 "dataBackground"]} {
        set color [EchartsOptsTheme datazoomFillColor]
        set opacity 0.2
    } elseif {[InfoNameProc 3 "selectedDataBackground"]} {
        set color "#8fb0f7"
        set opacity 0.2
    } else {
        set color "null"
    }

    set d [dict get $value $key]
    
    setdef options color         -minversion 5             -validvalue formatColor           -type list.s|str|jsfunc|null -default $color
    setdef options origin        -minversion "5.0.0:5.3.2" -validvalue formatAreaStyleOrigin -type str|null:str|num|null  -default "nothing"
    setdef options shadowBlur    -minversion 5             -validvalue {}                    -type num                    -default 0
    setdef options shadowColor   -minversion 5             -validvalue formatColor           -type str|null               -default "nothing"
    setdef options shadowOffsetX -minversion 5             -validvalue {}                    -type num                    -default 0
    setdef options shadowOffsetY -minversion 5             -validvalue {}                    -type num                    -default 0
    setdef options opacity       -minversion 5             -validvalue formatOpacity         -type num                    -default $opacity
    #...

    set options [merge $options $d]

    return $options
}


proc ticklecharts::axisLine {value} {

    if {![ticklecharts::keyDictExists "axisLine" $value key]} {
        set key "-axisLine"
    }

    if {$::ticklecharts::theme ne "basic"} {
        if {![dict exists $value $key]} {
            dict set value $key [dict create dummy null]
        }
    }

    if {![dict exists $value $key]} {
        return "nothing"
    }
    
    set d [dict get $value $key]

    setdef options show            -minversion 5  -validvalue {}               -type bool            -default [EchartsOptsTheme axisLineShow]
    setdef options onZero          -minversion 5  -validvalue {}               -type bool            -default "True"
    setdef options onZeroAxisIndex -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options symbol          -minversion 5  -validvalue formatItemSymbol -type str|list.s|null -default "null"
    setdef options symbolSize      -minversion 5  -validvalue {}               -type list.n|null     -default "nothing"
    setdef options symbolOffset    -minversion 5  -validvalue {}               -type list.n|num|null -default "nothing"
    setdef options lineStyle       -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::lineStyle $d]

    if {[InfoNameProc 2 "gaugeseries"]} {
        setdef options show      -minversion 5  -validvalue {} -type bool -default "True"
        setdef options roundCap  -minversion 5  -validvalue {} -type bool -default "False"
        # remove flag from dict options... not present in series-gauge.axisLine
        set options [dict remove $options onZero onZeroAxisIndex symbol symbolSize symbolOffset]
    }
    #...

    set d [dict remove $d lineStyle]
    
    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::markLine {value} {

    if {![ticklecharts::keyDictExists "markLine" $value key]} {
        return "nothing"
    }
    
    set d [dict get $value $key]

    setdef options silent                  -minversion 5  -validvalue {}               -type bool            -default "False"
    setdef options symbol                  -minversion 5  -validvalue formatItemSymbol -type str|list.s|null -default "nothing"
    setdef options symbolSize              -minversion 5  -validvalue {}               -type list.n|null     -default "nothing"
    setdef options precision               -minversion 5  -validvalue {}               -type num|null        -default 2
    setdef options label                   -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::label $d]
    setdef options lineStyle               -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::lineStyle $d]
    setdef options emphasis                -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::emphasis $d]
    setdef options blur                    -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::blur $d]
    setdef options data                    -minversion 5  -validvalue {}               -type list.o|null     -default [ticklecharts::markLineItem $d]
    setdef options animation               -minversion 5  -validvalue {}               -type bool|null       -default "nothing"
    setdef options animationThreshold      -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options animationDuration       -minversion 5  -validvalue {}               -type num|jsfunc|null -default "nothing"
    setdef options animationEasing         -minversion 5  -validvalue formatAEasing    -type str|null        -default "nothing"
    setdef options animationDelay          -minversion 5  -validvalue {}               -type num|jsfunc|null -default "nothing"
    setdef options animationDurationUpdate -minversion 5  -validvalue {}               -type num|jsfunc|null -default "nothing"
    setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing    -type str|null        -default "nothing"
    setdef options animationDelayUpdate    -minversion 5  -validvalue {}               -type num|jsfunc|null -default "nothing"
    
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
                    error "must be a list of 2, startpoint and endpoint"
                }

                set t {}
                foreach var $info {
                    append t "[ticklecharts::markLineItem [dict create data [list objectItem $var]]] "
                }

                lappend opts [list $t list.o]
                
            }
            objectItem {
                setdef options name             -minversion 5  -validvalue {}               -type str|null        -default "nothing"
                setdef options type             -minversion 5  -validvalue {}               -type str|null        -default "nothing"
                setdef options valueIndex       -minversion 5  -validvalue {}               -type num|null        -default "nothing"
                setdef options valueDim         -minversion 5  -validvalue {}               -type str|null        -default "nothing"
                setdef options coord            -minversion 5  -validvalue {}               -type list.n|null     -default "nothing"
                setdef options x                -minversion 5  -validvalue {}               -type num|str|null    -default "nothing"
                setdef options y                -minversion 5  -validvalue {}               -type num|str|null    -default "nothing"
                setdef options xAxis            -minversion 5  -validvalue {}               -type num|str|null    -default "nothing"
                setdef options yAxis            -minversion 5  -validvalue {}               -type num|str|null    -default "nothing"
                setdef options value            -minversion 5  -validvalue {}               -type num|null        -default "nothing"
                setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str|null        -default "nothing"
                setdef options symbolSize       -minversion 5  -validvalue {}               -type num|list.n|null -default "nothing"
                setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool|null       -default "nothing"
                setdef options symbolOffset     -minversion 5  -validvalue {}               -type list.d|null     -default "nothing"
                setdef options lineStyle        -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::lineStyle $info]
                setdef options label            -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::label $info]
                setdef options emphasis         -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::emphasis $info]
                setdef options blur             -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::blur $info]

                set info [dict remove $info lineStyle label emphasis blur]

                lappend opts [merge $options $info]

            }
            default {error "Key must be 'lineItem' or 'objectItem' "}
        }
        
    }

    return [list {*}$opts]

}

proc ticklecharts::labelLine {value} {

    if {![ticklecharts::keyDictExists "labelLine" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show         -minversion 5  -validvalue {} -type bool          -default "True"
    setdef options showAbove    -minversion 5  -validvalue {} -type bool|null     -default "nothing"
    setdef options length2      -minversion 5  -validvalue {} -type num|null      -default "nothing"
    setdef options smooth       -minversion 5  -validvalue {} -type bool|num|null -default "nothing"
    setdef options minTurnAngle -minversion 5  -validvalue {} -type num|null      -default "nothing"
    setdef options lineStyle    -minversion 5  -validvalue {} -type dict|null     -default [ticklecharts::lineStyle $d]
    #...

    if {[InfoNameProc 2 "pieseries"]} {
        setdef options length           -minversion 5  -validvalue {} -type num|null  -default "nothing"
        setdef options maxSurfaceAngle  -minversion 5  -validvalue {} -type num|null  -default "nothing"
    }

    if {[InfoNameProc 2 "funnelseries"]} {
        setdef options length           -minversion 5  -validvalue {} -type num|null  -default "nothing"
    }

    set d [dict remove $d lineStyle]

    set options [merge $options $d]

    return $options
}

proc ticklecharts::labelLayout {value} {

    if {![dict exists $value -labelLayout]} {
        return "nothing"
    }

    set d [dict get $value -labelLayout]

    setdef options hideOverlap     -minversion 5  -validvalue {}                      -type bool|null    -default "nothing"
    setdef options moveOverlap     -minversion 5  -validvalue formatMoveOverlap       -type str|null     -default "shiftX"
    setdef options x               -minversion 5  -validvalue {}                      -type num|str|null -default "nothing"
    setdef options y               -minversion 5  -validvalue {}                      -type num|str|null -default "nothing"
    setdef options dx              -minversion 5  -validvalue {}                      -type num|null     -default "nothing"
    setdef options dy              -minversion 5  -validvalue {}                      -type num|null     -default "nothing"
    setdef options rotate          -minversion 5  -validvalue {}                      -type num|null     -default "nothing"
    setdef options width           -minversion 5  -validvalue {}                      -type num|null     -default "nothing"
    setdef options height          -minversion 5  -validvalue {}                      -type num|null     -default "nothing"
    setdef options align           -minversion 5  -validvalue formatTextAlign         -type str          -default "left"
    setdef options verticalAlign   -minversion 5  -validvalue formatVerticalTextAlign -type str          -default "top"
    setdef options fontSize        -minversion 5  -validvalue {}                      -type num|null     -default "nothing"
    setdef options draggable       -minversion 5  -validvalue {}                      -type bool|null    -default "nothing"
    setdef options labelLinePoints -minversion 5  -validvalue {}                      -type list.n|null  -default "nothing"
    #...

    set options [merge $options $d]

    return $options
}

proc ticklecharts::axisTick {value} {

    if {![ticklecharts::keyDictExists "axisTick" $value key]} {
        set key "-axisTick"
    }

    if {$::ticklecharts::theme ne "basic" && ![InfoNameProc 2 "SetRadarCoordinate"]} {
        if {![dict exists $value $key]} {
            dict set value $key [dict create dummy null]
        }
    }

    if {![dict exists $value $key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show            -minversion 5  -validvalue {}             -type bool           -default [EchartsOptsTheme axisTickShow]
    setdef options alignWithLabel  -minversion 5  -validvalue {}             -type bool|null      -default "nothing"
    setdef options inside          -minversion 5  -validvalue {}             -type bool|null      -default "nothing"
    setdef options interval        -minversion 5  -validvalue formatInterval -type str|num|jsfunc -default "auto"
    setdef options length          -minversion 5  -validvalue {}             -type num            -default 5
    setdef options lineStyle       -minversion 5  -validvalue {}             -type dict|null      -default [ticklecharts::lineStyle $d]

    if {[InfoNameProc 2 "gaugeseries"]} {
        # add flag 'distance' series-gauge.axisTick
        setdef options splitNumber  -minversion 5  -validvalue {} -type num|null -default "nothing"
        setdef options distance     -minversion 5  -validvalue {} -type num|null -default "nothing"
    }
    #...
    set d [dict remove $d lineStyle]

    set options [merge $options $d]

    return $options
}

proc ticklecharts::minorTick {value} {

    if {![ticklecharts::keyDictExists "minorTick" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show        -minversion 5  -validvalue {} -type bool      -default "False"
    setdef options splitNumber -minversion 5  -validvalue {} -type num       -default 5
    setdef options length      -minversion 5  -validvalue {} -type num       -default 3
    setdef options lineStyle   -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
    #...
    set d [dict remove $d lineStyle]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::axisLabel {value} {

    if {![ticklecharts::keyDictExists "axisLabel" $value key]} {
        set key "-axisLabel"
    }

    if {$::ticklecharts::theme ne "basic" && ![InfoNameProc 2 "SetRadarCoordinate"]} {
        if {![dict exists $value $key]} {
            dict set value $key [dict create dummy null]
        }
    }

    if {![dict exists $value $key]} {
        return "nothing"
    }

    set d [dict get $value $key]
        
    setdef options show                 -minversion 5       -validvalue {}                      -type bool            -default [EchartsOptsTheme axisLabelShow]
    setdef options interval             -minversion 5       -validvalue formatInterval          -type num|str|jsfunc  -default "auto"
    setdef options inside               -minversion 5       -validvalue {}                      -type bool            -default "False"
    setdef options rotate               -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options margin               -minversion 5       -validvalue {}                      -type num             -default 8
    setdef options formatter            -minversion 5       -validvalue {}                      -type str|jsfunc|null -default "nothing"
    setdef options showMinLabel         -minversion 5       -validvalue {}                      -type bool|null       -default "null"
    setdef options showMaxLabel         -minversion 5       -validvalue {}                      -type bool|null       -default "null"
    setdef options hideOverlap          -minversion "5.2.0" -validvalue {}                      -type bool            -default "False"
    setdef options color                -minversion 5       -validvalue formatColor             -type str|null        -default [EchartsOptsTheme axisLabelColor]
    setdef options fontStyle            -minversion 5       -validvalue formatFontStyle         -type str             -default "normal"
    setdef options fontWeight           -minversion 5       -validvalue formatFontWeight        -type str|num         -default "normal"
    setdef options fontFamily           -minversion 5       -validvalue {}                      -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5       -validvalue {}                      -type num             -default 12
    setdef options align                -minversion 5       -validvalue formatTextAlign         -type str|null        -default "nothing"
    setdef options verticalAlign        -minversion 5       -validvalue formatVerticalTextAlign -type str|null        -default "nothing"
    setdef options lineHeight           -minversion 5       -validvalue {}                      -type num             -default 12
    setdef options backgroundColor      -minversion 5       -validvalue formatColor             -type str             -default "transparent"
    setdef options borderColor          -minversion 5       -validvalue formatColor             -type str|null        -default "nothing"
    setdef options borderWidth          -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options borderType           -minversion 5       -validvalue formatBorderType        -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -minversion 5       -validvalue {}                      -type num|null        -default 0
    setdef options borderRadius         -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options padding              -minversion 5       -validvalue {}                      -type num|list.n      -default 0
    setdef options shadowColor          -minversion 5       -validvalue formatColor             -type str             -default "transparent"
    setdef options shadowBlur           -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetX        -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetY        -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options width                -minversion 5       -validvalue {}                      -type num|null        -default "nothing"
    setdef options height               -minversion 5       -validvalue {}                      -type num|null        -default "nothing"
    setdef options textBorderColor      -minversion 5       -validvalue formatColor             -type str|null        -default "null"
    setdef options textBorderWidth      -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options textBorderType       -minversion 5       -validvalue formatTextBorderType    -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options textShadowColor      -minversion 5       -validvalue formatColor             -type str             -default "transparent"
    setdef options textShadowBlur       -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetX    -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetY    -minversion 5       -validvalue {}                      -type num             -default 0
    setdef options overflow             -minversion 5       -validvalue formatOverflow          -type str             -default "truncate"
    setdef options ellipsis             -minversion 5       -validvalue {}                      -type str             -default "..."

    if {[InfoNameProc 2 "gaugeseries"]} {
        # add flag 'distance' series-gauge.axisLabel
        setdef options rotate    -minversion "5.4.0" -validvalue formatGaugeALrotate -type str|num  -default 0
        setdef options distance  -minversion 5       -validvalue {}                  -type num|null -default "nothing"
    }

    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::upperLabel {value} {

    if {![ticklecharts::keyDictExists "upperLabel" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]
    
    setdef options show                 -minversion 5  -validvalue {}                      -type bool            -default "False"
    setdef options offset               -minversion 5  -validvalue {}                      -type list.n|null     -default "nothing"
    setdef options position             -minversion 5  -validvalue formatPosition          -type str|list.d|null -default "inside"
    setdef options distance             -minversion 5  -validvalue {}                      -type num|null        -default 5
    setdef options rotate               -minversion 5  -validvalue formatRotate            -type num|null        -default "nothing"
    setdef options formatter            -minversion 5  -validvalue {}                      -type str|jsfunc|null -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type str|null        -default [EchartsOptsTheme axisLabelColor]
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str             -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num         -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num|null        -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str|null        -default "nothing"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str|null        -default "nothing"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num|null        -default "nothing"
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type str|null        -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null        -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n|null -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num|null        -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                      -type num|null        -default 20
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null        -default "nothing"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num|null        -default "nothing"
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num|null        -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str             -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str             -default "..."
    setdef options rich                 -minversion 5  -validvalue {}                      -type dict|null       -default [ticklecharts::RichItem $d]
    #...

    # remove key(s) from dict value rich...
    set d [dict remove $d richitem]

    set options [merge $options $d]

    return $options
}


proc ticklecharts::label {value} {


    if {![ticklecharts::keyDictExists "label" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]
    
    setdef options show                 -minversion 5  -validvalue {}                      -type bool            -default "True"
    setdef options offset               -minversion 5  -validvalue {}                      -type list.n|null     -default "nothing"
    setdef options position             -minversion 5  -validvalue formatPosition          -type str|list.d|null -default "nothing"
    setdef options distance             -minversion 5  -validvalue {}                      -type num|null        -default "nothing"
    setdef options rotate               -minversion 5  -validvalue formatRotate            -type num             -default 0
    setdef options formatter            -minversion 5  -validvalue {}                      -type str|jsfunc|null -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type str|null        -default [EchartsOptsTheme axisLabelColor]
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str             -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num         -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num|null        -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str|null        -default "nothing"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str|null        -default "nothing"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num|null        -default 12
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type str|null        -default "nothing"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null        -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num             -default 2
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n|null -default "nothing"
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num|null        -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                      -type num|null        -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null        -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str             -default "truncate"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str             -default "..."
    setdef options rich                 -minversion 5  -validvalue {}                      -type dict|null       -default [ticklecharts::RichItem $d]
    #...

    if {[InfoNameProc 3 "axisPointer"]} {
        set options [dict remove $options position distance rotate align verticalAlign borderType borderDashOffset \
                                          borderRadius]

        setdef options precision  -minversion 5  -validvalue {} -type str|num  -default "auto"
        setdef options margin     -minversion 5  -validvalue {} -type num|null -default 3
    }

    if {[InfoNameProc 2 "pieseries"]} {
        setdef options alignTo             -minversion 5  -validvalue formatAlignTo -type str          -default "none"
        setdef options edgeDistance        -minversion 5  -validvalue {}            -type str|num|null -default "25%"
        setdef options bleedMargin         -minversion 5  -validvalue {}            -type num|null     -default 10
        setdef options margin              -minversion 5  -validvalue {}            -type num|null     -default "nothing"
        setdef options distanceToLabelLine -minversion 5  -validvalue {}            -type num          -default 5
    }

    if {[InfoNameProc 2 "sunburstseries"]} {
        setdef options rotate       -minversion 5  -validvalue formatRotate    -type num|str         -default "radial"
        setdef options align        -minversion 5  -validvalue formatTextAlign -type str|null        -default "center"
        setdef options minAngle     -minversion 5  -validvalue {}              -type num|null        -default "nothing"
        setdef options position     -minversion 5  -validvalue formatPosition  -type str|list.d|null -default "inside"
        setdef options distance     -minversion 5  -validvalue {}              -type num|null        -default 5
        setdef options borderRadius -minversion 5  -validvalue {}              -type num             -default 0
        setdef options offset       -minversion 5  -validvalue {}              -type list.n|null     -default "nothing"
    }

    # remove key(s) from dict value rich...
    set d [dict remove $d richitem]

    set options [merge $options $d]

    return $options
}

proc ticklecharts::endLabel {value} {

    if {![ticklecharts::keyDictExists "endLabel" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show                 -minversion 5  -validvalue {}                      -type bool            -default "False"
    setdef options distance             -minversion 5  -validvalue {}                      -type num             -default 5
    setdef options rotate               -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options offset               -minversion 5  -validvalue {}                      -type list.d|null     -default "nothing"
    setdef options formatter            -minversion 5  -validvalue {}                      -type str|jsfunc|null -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type str|null        -default "inherit"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str             -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num         -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num             -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str             -default "left"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str             -default "top"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num             -default 12
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null        -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n      -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num             -default 100
    setdef options height               -minversion 5  -validvalue {}                      -type num             -default 100
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null        -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str             -default "truncate"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str             -default "..."
    setdef options valueAnimation       -minversion 5  -validvalue {}                      -type bool|null       -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::axisName {value} {

    if {![ticklecharts::keyDictExists "axisName" $value key]} {
        return "nothing"
    }

    setdef options show                 -minversion 5  -validvalue {}                   -type bool            -default "True"
    setdef options formatter            -minversion 5  -validvalue {}                   -type str|jsfunc|null -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor          -type str|null        -default [EchartsOptsTheme axisLabelColor]
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str             -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|num         -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num             -default 12
    setdef options lineHeight           -minversion 5  -validvalue formatColor          -type num|null        -default "nothing"
    setdef options backgroundColor      -minversion 5  -validvalue formatColor          -type str             -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor          -type str|null        -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType     -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options padding              -minversion 5  -validvalue {}                   -type num|list.n      -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor          -type str             -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options width                -minversion 5  -validvalue {}                   -type num|null        -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                   -type num|null        -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue formatColor          -type str|null        -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str             -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow       -type str             -default "truncate"
    setdef options ellipsis             -minversion 5  -validvalue {}                   -type str             -default "..."
    #...

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::lineStyle {value} {

    if {$::ticklecharts::theme ne "basic" && ![InfoNameProc 3 "RadarItem"] && ![InfoNameProc 2 "radarseries"]} {
        if {![dict exists $value -lineStyle]} {
            dict set value -lineStyle [dict create dummy null]
        }
    }

    if {![ticklecharts::keyDictExists "lineStyle" $value key]} {
        return "nothing"
    }
        
    if {[InfoNameProc 3 "splitLine"] || [InfoNameProc 3 "minorSplitLine"]} {
        set color     [EchartsOptsTheme splitLineColor]
        set linewidth [EchartsOptsTheme graphLineWidth]
    } elseif {[InfoNameProc 2 "lineseries"]} {
        set color     "nothing"
        set linewidth [EchartsOptsTheme lineWidth]
    } elseif {[InfoNameProc 3 "dataBackground"]} {
        set color     [EchartsOptsTheme datazoomFillColor]
        set linewidth 0.5
    } elseif {[InfoNameProc 3 "selectedDataBackground"]} {
        set color "#8fb0f7"
        set linewidth 0.5
    } elseif {[InfoNameProc 3 "timelineOpts"]} {
        set color [EchartsOptsTheme timelineLineColor]
        set linewidth [EchartsOptsTheme timelineLineColor]
    } else {
        set color     [EchartsOptsTheme axisLineColor]
        set linewidth [EchartsOptsTheme graphLineWidth]
    }
    
    setdef options color          -minversion 5  -validvalue formatColor         -type str|jsfunc|list.s|null -default $color
    setdef options width          -minversion 5  -validvalue {}                  -type num                    -default $linewidth
    setdef options type           -minversion 5  -validvalue formatLineStyleType -type list.n|num|str         -default "solid"
    setdef options dashOffset     -minversion 5  -validvalue {}                  -type num                    -default 0
    setdef options cap            -minversion 5  -validvalue formatCap           -type str                    -default "butt"
    setdef options join           -minversion 5  -validvalue formatJoin          -type str                    -default "bevel"
    setdef options miterLimit     -minversion 5  -validvalue {}                  -type num                    -default 10
    setdef options shadowBlur     -minversion 5  -validvalue {}                  -type num                    -default 0
    setdef options shadowColor    -minversion 5  -validvalue formatColor         -type str|null               -default "null"
    setdef options shadowOffsetX  -minversion 5  -validvalue {}                  -type num                    -default 0
    setdef options shadowOffsetY  -minversion 5  -validvalue {}                  -type num                    -default 0
    setdef options curveness      -minversion 5  -validvalue {}                  -type num|null               -default "nothing"
    setdef options opacity        -minversion 5  -validvalue formatOpacity       -type num                    -default 1
    #...
    
    if {[InfoNameProc 2 "legend"]} {                                          
        setdef options color      -minversion 5  -validvalue formatColor         -type str|null       -default "inherit"
        setdef options width      -minversion 5  -validvalue {}                  -type str|num|null   -default "auto"
        setdef options type       -minversion 5  -validvalue formatLineStyleType -type list.n|num|str -default "inherit"
        setdef options dashOffset -minversion 5  -validvalue {}                  -type num|str        -default "inherit"
        setdef options cap        -minversion 5  -validvalue formatCap           -type str            -default "inherit"
        setdef options join       -minversion 5  -validvalue formatJoin          -type str            -default "inherit"
        setdef options miterLimit -minversion 5  -validvalue {}                  -type num|str        -default "inherit"
        setdef options shadowBlur -minversion 5  -validvalue {}                  -type num|str        -default "inherit"
        setdef options opacity    -minversion 5  -validvalue formatOpacity       -type num|str        -default "inherit"
    }

    if {[InfoNameProc 2 "gaugeseries"]} {
        # remove flag from dict options... not present in series-gauge.axisLine
        set options [dict remove $options type dashOffset cap join miterLimit opacity]
    }

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::textStyle {value key} {

    if {$::ticklecharts::theme ne "basic" && ![InfoNameProc 2 "tooltip"]} {
        if {![dict exists $value $key]} {
            dict set value $key [dict create dummy null]
        }
    }

    if {![dict exists $value $key]} {
        return "nothing"
    }

    switch -exact -- $key {
        textStyle    {set color [EchartsOptsTheme titleColor]}
        subtextStyle {set color [EchartsOptsTheme subtitleColor]}
        default      {set color "nothing"}
    }

    if {$::ticklecharts::theme ne "basic" && [InfoNameProc 2 "legend"]} {
        set fontSize 12
        set fontWeight "normal"
    } elseif {$::ticklecharts::theme ne "basic" && [InfoNameProc 2 "dataZoom"]} {
        set fontSize 12
        set fontWeight "bolder"
    } elseif {$::ticklecharts::theme ne "basic" && [InfoNameProc 2 "visualMap"]} {
        set fontSize 12
        set fontWeight "bolder"
    } elseif {$::ticklecharts::theme ne "basic" && $key eq "subtextStyle"} {
        set fontSize 13
        set fontWeight "normal"
    } else {
        set fontSize 18
        set fontWeight "bolder"
    }

    setdef options color                -minversion 5  -validvalue formatColor          -type str|jsfunc|null -default $color
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str             -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|num         -default $fontWeight
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num             -default $fontSize
    setdef options lineHeight           -minversion 5  -validvalue {}                   -type num|null        -default "nothing"
    setdef options width                -minversion 5  -validvalue {}                   -type num             -default 100
    setdef options height               -minversion 5  -validvalue {}                   -type num             -default 50
    setdef options textBorderColor      -minversion 5  -validvalue {}                   -type str|null        -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str             -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow       -type str|null        -default "null"
    setdef options ellipsis             -minversion 5  -validvalue {}                   -type str             -default "..."
    #...

    if {[InfoNameProc 2 "wordcloudseries"]} {
        setdef options fontSize         -minversion 5  -validvalue {}                   -type null            -default "nothing"
        setdef options lineHeight       -minversion 5  -validvalue {}                   -type null            -default "nothing"
        setdef options width            -minversion 5  -validvalue {}                   -type null            -default "nothing"
        setdef options height           -minversion 5  -validvalue {}                   -type null            -default "nothing"
        setdef options ellipsis         -minversion 5  -validvalue {}                   -type null            -default "nothing"
    }

    if {$key eq "subtextStyle"} {
        setdef options align         -minversion 5  -validvalue formatTextAlign         -type str|null  -default "nothing"
        setdef options verticalAlign -minversion 5  -validvalue formatVerticalTextAlign -type str|null  -default "nothing" 
    }

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::nameTextStyle {value} {

    if {![ticklecharts::keyDictExists "nameTextStyle" $value key]} {
        return "nothing"
    }

    setdef options color                -minversion 5  -validvalue formatColor             -type str|null       -default "nothing"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str            -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num        -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str            -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num            -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str            -default "left"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str            -default "top"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num            -default 12
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type str            -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null       -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n     -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str            -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num            -default 100
    setdef options height               -minversion 5  -validvalue {}                      -type num            -default 100
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null       -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str            -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num            -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str            -default "truncate"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str            -default "..."
    #...

    set options [merge $options [dict get $value $key]]

    return $options

}

proc ticklecharts::crossStyle {value} {

    if {![dict exists $value crossStyle]} {
        return "nothing"
    }
    
    set d [dict get $value crossStyle]

    setdef options color         -minversion 5  -validvalue formatColor      -type str                 -default "rgb(85, 85, 85)"
    setdef options width         -minversion 5  -validvalue {}               -type num                 -default 1
    setdef options type          -minversion 5  -validvalue formatCrossStyle -type str|num|list.n|null -default "solid"
    setdef options dashOffset    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options cap           -minversion 5  -validvalue formatCap        -type str                 -default "butt"
    setdef options join          -minversion 5  -validvalue formatJoin       -type str                 -default "bevel"
    setdef options miterLimit    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowBlur    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowColor   -minversion 5  -validvalue formatColor      -type str|null            -default "nothing"
    setdef options shadowOffsetX -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowOffsetY -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options opacity       -minversion 5  -validvalue formatOpacity    -type num|null            -default 0.5
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::backgroundStyle {value} {

    if {![dict exists $value -backgroundStyle]} {
        return "nothing"
    }
    
    set d [dict get $value -backgroundStyle]

    setdef options color         -minversion 5  -validvalue formatColor      -type str             -default "rgba(180, 180, 180, 0.2)"
    setdef options borderColor   -minversion 5  -validvalue formatColor      -type str|null        -default "#000"
    setdef options borderWidth   -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options borderType    -minversion 5  -validvalue formatBorderType -type str|null        -default "solid"
    setdef options borderRadius  -minversion 5  -validvalue {}               -type num|list.n|null -default 0
    setdef options dashOffset    -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options shadowBlur    -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options shadowColor   -minversion 5  -validvalue formatColor      -type str|null        -default "nothing"
    setdef options shadowOffsetX -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options shadowOffsetY -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options opacity       -minversion 5  -validvalue formatOpacity    -type num|null        -default 0.5
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::shadowStyle {value} {

    if {![dict exists $value shadowStyle]} {
        return "nothing"
    }
    
    set d [dict get $value shadowStyle]

    setdef options color         -minversion 5  -validvalue formatColor   -type str      -default "rgba(150,150,150,0.3)"
    setdef options shadowBlur    -minversion 5  -validvalue {}            -type num|null -default "nothing"
    setdef options shadowColor   -minversion 5  -validvalue formatColor   -type str|null -default "nothing"
    setdef options shadowOffsetX -minversion 5  -validvalue {}            -type num|null -default "nothing"
    setdef options shadowOffsetY -minversion 5  -validvalue {}            -type num|null -default "nothing"
    setdef options opacity       -minversion 5  -validvalue formatOpacity -type num|null -default 0.5
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::emptyCircleStyle {value} {

    if {![dict exists $value -emptyCircleStyle]} {
        return "nothing"
    }
    
    set d [dict get $value -emptyCircleStyle]

    setdef options color            -minversion "5.2.0" -validvalue formatColor      -type str      -default "rgb(211,211,211)"
    setdef options borderColor      -minversion "5.2.0" -validvalue formatColor      -type str|null -default "#000"
    setdef options borderWidth      -minversion "5.2.0" -validvalue {}               -type num|null -default "nothing"
    setdef options borderType       -minversion "5.2.0" -validvalue formatBorderType -type str|null -default "solid"
    setdef options borderdashOffset -minversion "5.2.0" -validvalue {}               -type num|null -default "nothing"
    setdef options borderCap        -minversion "5.2.0" -validvalue formatCap        -type str      -default "butt"
    setdef options borderJoin       -minversion "5.2.0" -validvalue formatJoin       -type str      -default "bevel"
    setdef options borderMiterLimit -minversion "5.2.0" -validvalue {}               -type num      -default 10
    setdef options shadowBlur       -minversion "5.2.0" -validvalue {}               -type num|null -default "nothing"
    setdef options shadowColor      -minversion "5.2.0" -validvalue formatColor      -type str|null -default "nothing"
    setdef options shadowOffsetX    -minversion "5.2.0" -validvalue {}               -type num|null -default "nothing"
    setdef options shadowOffsetY    -minversion "5.2.0" -validvalue {}               -type num|null -default "nothing"
    setdef options opacity          -minversion "5.2.0" -validvalue formatOpacity    -type num|null -default 0.5
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::axisPointer {value} {

    if {![ticklecharts::keyDictExists "axisPointer" $value key]} {
        return "nothing"
    }
    
    set d [dict get $value $key]

    setdef options type                    -minversion 5  -validvalue formatAxisPointerType -type str             -default "line"
    setdef options axis                    -minversion 5  -validvalue formatAxisPointerAxis -type str             -default "auto"
    setdef options snap                    -minversion 5  -validvalue {}                    -type bool|null       -default "nothing"
    setdef options z                       -minversion 5  -validvalue {}                    -type num|null        -default "nothing"
    setdef options label                   -minversion 5  -validvalue {}                    -type dict|null       -default [ticklecharts::label $d]
    setdef options lineStyle               -minversion 5  -validvalue {}                    -type dict|null       -default [ticklecharts::lineStyle $d]
    setdef options shadowStyle             -minversion 5  -validvalue {}                    -type dict|null       -default [ticklecharts::shadowStyle $d]
    setdef options crossStyle              -minversion 5  -validvalue {}                    -type dict|null       -default [ticklecharts::crossStyle $d]
    setdef options animation               -minversion 5  -validvalue {}                    -type bool            -default "True"
    setdef options animationThreshold      -minversion 5  -validvalue {}                    -type num             -default 2000
    setdef options animationDuration       -minversion 5  -validvalue {}                    -type num|jsfunc      -default 1000
    setdef options animationEasing         -minversion 5  -validvalue formatAEasing         -type str             -default "cubicOut"
    setdef options animationDelay          -minversion 5  -validvalue {}                    -type num|jsfunc|null -default "nothing"
    setdef options animationDurationUpdate -minversion 5  -validvalue {}                    -type num|jsfunc      -default 200
    setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing         -type str             -default "exponentialOut"
    setdef options animationDelayUpdate    -minversion 5  -validvalue {}                    -type num|jsfunc|null -default "nothing"
    #...

    # remove key(s)
    set d [dict remove $d label lineStyle \
                          shadowStyle crossStyle]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::inRange {value} {

    if {![dict exists $value inRange]} {
        return "nothing"
    }
    
    set d [dict get $value inRange]

    setdef options symbol          -minversion 5  -validvalue formatItemSymbol -type list.d|str|null -default "nothing"
    setdef options symbolSize      -minversion 5  -validvalue {}               -type list.d|num|null -default "nothing"
    setdef options color           -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options colorAlpha      -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options opacity         -minversion 5  -validvalue {}               -type list.d|num|null -default "nothing"
    setdef options colorLightness  -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options colorSaturation -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options colorHue        -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::outOfRange {value} {

    if {![dict exists $value outOfRange]} {
        return "nothing"
    }
    
    set d [dict get $value outOfRange]

    setdef options symbol          -minversion 5  -validvalue formatItemSymbol -type list.d|str|null -default "nothing"
    setdef options symbolSize      -minversion 5  -validvalue {}               -type list.d|num|null -default "nothing"
    setdef options color           -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options colorAlpha      -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options opacity         -minversion 5  -validvalue {}               -type list.d|num|null -default "nothing"
    setdef options colorLightness  -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options colorSaturation -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options colorHue        -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::controller {value} {

    if {![dict exists $value controller]} {
        return "nothing"
    }
    
    set d [dict get $value controller]

    setdef options inRange    -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::inRange $d]
    setdef options outOfRange -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::outOfRange $d]
    #...

    set d [dict remove $d inRange outOfRange]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::handleStyle {value} {

    if {![ticklecharts::keyDictExists "handleStyle" $value key]} {
        return "nothing"
    }
    
    set d [dict get $value $key]

    setdef options color            -minversion 5  -validvalue formatColor      -type str|null            -default "nothing"
    setdef options borderColor      -minversion 5  -validvalue formatColor      -type str|null            -default "nothing"
    setdef options borderWidth      -minversion 5  -validvalue {}               -type num|null            -default 1
    setdef options borderType       -minversion 5  -validvalue formatBorderType -type str|num|list.d|null -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options borderCap        -minversion 5  -validvalue formatCap        -type str|null            -default "butt"
    setdef options borderMiterLimit -minversion 5  -validvalue {}               -type num|null            -default 10
    setdef options shadowBlur       -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor      -type str|null            -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity    -type num|null            -default "nothing"
    #...

    if {[InfoNameProc 2 "dataZoom"]} {
        setdef options color            -minversion 5  -validvalue formatColor  -type str|null            -default "#fff"
        setdef options borderColor      -minversion 5  -validvalue formatColor  -type str|null            -default "#ACB8D1"
        setdef options borderWidth      -minversion 5  -validvalue {}           -type num|null            -default 0
        setdef options borderDashOffset -minversion 5  -validvalue {}           -type num|null            -default 0
        setdef options borderJoin       -minversion 5  -validvalue formatJoin   -type str                 -default "bevel"
    }

    set options [merge $options $d]

    return $options

}

proc ticklecharts::moveHandleStyle {value} {

    if {![dict exists $value -moveHandleStyle]} {
        return "nothing"
    }
    
    set d [dict get $value -moveHandleStyle]

    setdef options color            -minversion 5  -validvalue formatColor      -type str|null            -default "#D2DBEE"
    setdef options borderColor      -minversion 5  -validvalue formatColor      -type str|null            -default "#000"
    setdef options borderWidth      -minversion 5  -validvalue {}               -type num|null            -default 0
    setdef options borderType       -minversion 5  -validvalue formatBorderType -type str|num|list.d|null -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options borderCap        -minversion 5  -validvalue formatCap        -type str|null            -default "butt"
    setdef options borderJoin       -minversion 5  -validvalue formatJoin       -type str                 -default "bevel"
    setdef options borderMiterLimit -minversion 5  -validvalue {}               -type num|null            -default 10
    setdef options shadowBlur       -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor      -type str|null            -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity    -type num|null            -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::indicatorStyle {value} {

    if {![dict exists $value indicatorStyle]} {
        return "nothing"
    }
    
    set d [dict get $value indicatorStyle]

    setdef options color            -minversion 5  -validvalue formatColor      -type str|null            -default "nothing"
    setdef options borderColor      -minversion 5  -validvalue formatColor      -type str|null            -default "nothing"
    setdef options borderWidth      -minversion 5  -validvalue {}               -type num|null            -default 1
    setdef options borderType       -minversion 5  -validvalue formatBorderType -type str|num|list.d|null -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options borderCap        -minversion 5  -validvalue formatCap        -type str|null            -default "butt"
    setdef options borderMiterLimit -minversion 5  -validvalue {}               -type num|null            -default 10
    setdef options shadowBlur       -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor      -type str|null            -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}               -type num|null            -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity    -type num|null            -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::markArea {value} {

    if {![dict exists $value -markArea]} {
        return "nothing"
    }
    
    set d [dict get $value -markArea]

    setdef options silent                  -minversion 5  -validvalue {}            -type bool|null       -default "False"
    setdef options label                   -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::label $d]
    setdef options itemStyle               -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::itemStyle $d]
    setdef options emphasis                -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::emphasis $d]
    setdef options blur                    -minversion 5  -validvalue {}            -type dict|null       -default [ticklecharts::blur $d]
    setdef options data                    -minversion 5  -validvalue {}            -type list.o|null     -default [ticklecharts::markAreaItem $d]
    setdef options animation               -minversion 5  -validvalue {}            -type bool|null       -default "nothing"
    setdef options animationThreshold      -minversion 5  -validvalue {}            -type num|null        -default "nothing"
    setdef options animationDuration       -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
    setdef options animationEasing         -minversion 5  -validvalue formatAEasing -type str|null        -default "nothing"
    setdef options animationDelay          -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
    setdef options animationDurationUpdate -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
    setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing -type str|null        -default "nothing"
    setdef options animationDelayUpdate    -minversion 5  -validvalue {}            -type num|jsfunc|null -default "nothing"
    #...

    set d [dict remove $d data label itemStyle emphasis blur]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::rippleEffect {value} {

    if {![dict exists $value -rippleEffect]} {
        return "nothing"
    }
    
    set d [dict get $value -rippleEffect]

    setdef options color     -minversion 5       -validvalue formatColor      -type str|null -default "nothing"
    setdef options number    -minversion "5.2.0" -validvalue {}               -type num|null -default 3
    setdef options period    -minversion 5       -validvalue {}               -type num|null -default 4
    setdef options scale     -minversion 5       -validvalue {}               -type num|null -default 2.5
    setdef options brushType -minversion 5       -validvalue formatEbrushType -type str|null -default "fill"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::feature {value} {

    if {![dict exists $value feature]} {
        return "nothing"
    }
    
    set d [dict get $value feature]

    setdef options dataZoom     -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::toolBoxdataZoom $d]
    setdef options dataView     -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::dataView $d]
    setdef options magicType    -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::magicType $d]
    setdef options brush        -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::brushopts $d]
    setdef options restore      -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::restore $d]
    setdef options saveAsImage  -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::saveAsImage $d]
    #...

    set d [dict remove $d saveAsImage restore dataView dataZoom magicType brush]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::saveAsImage {value} {

    if {![dict exists $value saveAsImage]} {
        return "nothing"
    }
    
    set d [dict get $value saveAsImage]

    setdef options type                     -minversion 5  -validvalue formatSaveAsImg -type str          -default "png"
    setdef options name                     -minversion 5  -validvalue {}              -type str|null     -default "nothing"
    setdef options backgroundColor          -minversion 5  -validvalue formatColor     -type str|null     -default "transparent"
    setdef options connectedBackgroundColor -minversion 5  -validvalue formatColor     -type str|null     -default "#fff"
    setdef options excludeComponents        -minversion 5  -validvalue {}              -type list.s|null  -default "nothing"
    setdef options show                     -minversion 5  -validvalue {}              -type bool         -default "True"
    setdef options title                    -minversion 5  -validvalue {}              -type str          -default "Save as image"
    setdef options icon                     -minversion 5  -validvalue {}              -type str|null     -default "nothing"
    setdef options iconStyle                -minversion 5  -validvalue {}              -type dict|null    -default [ticklecharts::iconStyle $d "iconStyle"]
    setdef options emphasis                 -minversion 5  -validvalue {}              -type dict|null    -default [ticklecharts::iconEmphasis $d]
    setdef options pixelRatio               -minversion 5  -validvalue {}              -type num          -default 1
    #...

    set d [dict remove $d iconStyle emphasis]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::restore {value} {

    if {![dict exists $value restore]} {
        return "nothing"
    }
    
    set d [dict get $value restore]

    setdef options show      -minversion 5  -validvalue {} -type bool      -default "True"
    setdef options title     -minversion 5  -validvalue {} -type str       -default "Restore"
    setdef options icon      -minversion 5  -validvalue {} -type str|null  -default "nothing"
    setdef options iconStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::iconStyle $d "iconStyle"]
    setdef options emphasis  -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::iconEmphasis $d]
    #...

    set d [dict remove $d iconStyle emphasis]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::dataView {value} {

    if {![dict exists $value dataView]} {
        return "nothing"
    }
    
    set d [dict get $value dataView]

    setdef options show                -minversion 5  -validvalue {}          -type bool         -default "True"
    setdef options title               -minversion 5  -validvalue {}          -type str          -default "Data view"
    setdef options icon                -minversion 5  -validvalue {}          -type str|null     -default "nothing"
    setdef options iconStyle           -minversion 5  -validvalue {}          -type dict|null    -default [ticklecharts::iconStyle $d "iconStyle"]
    setdef options emphasis            -minversion 5  -validvalue {}          -type dict|null    -default [ticklecharts::iconEmphasis $d]
    setdef options readOnly            -minversion 5  -validvalue {}          -type bool         -default "False"
    setdef options optionToContent     -minversion 5  -validvalue {}          -type jsfunc|null  -default "nothing"
    setdef options contentToOption     -minversion 5  -validvalue {}          -type jsfunc|null  -default "nothing"
    setdef options lang                -minversion 5  -validvalue {}          -type list.s|null  -default [list {"Data view" "Turn off" "Refresh"}]
    setdef options backgroundColor     -minversion 5  -validvalue formatColor -type str          -default "#fff"
    setdef options textareaColor       -minversion 5  -validvalue formatColor -type str          -default "#fff"
    setdef options textareaBorderColor -minversion 5  -validvalue formatColor -type str          -default "#000"
    setdef options buttonColor         -minversion 5  -validvalue formatColor -type str          -default "#c23531"
    setdef options buttonTextColor     -minversion 5  -validvalue formatColor -type str          -default "#fff"
    #...

    set d [dict remove $d iconStyle emphasis]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::toolBoxdataZoom {value} {

    if {![dict exists $value dataZoom]} {
        return "nothing"
    }
    
    set d [dict get $value dataZoom]

    setdef options show        -minversion 5  -validvalue {}               -type bool                     -default "True"
    setdef options title       -minversion 5  -validvalue {}               -type dict|null                -default [ticklecharts::toolBoxTitle $d "dataZoom"]
    setdef options icon        -minversion 5  -validvalue {}               -type dict|null                -default [ticklecharts::icon $d "dataZoom"]
    setdef options iconStyle   -minversion 5  -validvalue {}               -type dict|null                -default [ticklecharts::iconStyle $d "iconStyle"]
    setdef options emphasis    -minversion 5  -validvalue {}               -type dict|null                -default [ticklecharts::iconEmphasis $d]
    setdef options filterMode  -minversion 5  -validvalue formatFilterMode -type str                      -default "filter"
    setdef options xAxisIndex  -minversion 5  -validvalue {}               -type num|list.n|bool|str|null -default "nothing"
    setdef options yAxisIndex  -minversion 5  -validvalue {}               -type num|list.n|bool|str|null -default "nothing"
    setdef options brushStyle  -minversion 5  -validvalue {}               -type dict|null                -default [ticklecharts::brushStyle $d]
    #...

    set d [dict remove $d title iconStyle emphasis icon brushStyle]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::magicType {value} {

    if {![dict exists $value magicType]} {
        return "nothing"
    }
    
    set d [dict get $value magicType]

    setdef options show           -minversion 5  -validvalue {} -type bool            -default "True"
    setdef options type           -minversion 5  -validvalue {} -type list.s|null     -default [list {"line" "bar" "stack"}]
    setdef options title          -minversion 5  -validvalue {} -type dict|null       -default [ticklecharts::toolBoxTitle $d "magicType"]
    setdef options icon           -minversion 5  -validvalue {} -type dict|null       -default [ticklecharts::icon $d "magicType"]
    setdef options iconStyle      -minversion 5  -validvalue {} -type dict|null       -default [ticklecharts::iconStyle $d "iconStyle"]
    setdef options emphasis       -minversion 5  -validvalue {} -type dict|null       -default [ticklecharts::iconEmphasis $d]
    # not supported yet...
    # setdef options option       -minversion 5  -validvalue {} -type dict|null       -default [ticklecharts::option $d]
    # setdef options seriesIndex  -minversion 5  -validvalue {} -type dict|null       -default [ticklecharts::seriesIndex $d]
    #...

    set d [dict remove $d title icon iconStyle emphasis]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::brushopts {value} {

    if {![dict exists $value brush]} {
        return "nothing"
    }
    
    set d [dict get $value brush]

    setdef options type   -minversion 5  -validvalue {} -type list.s|null  -default "nothing"
    setdef options icon   -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::icon $d "brush"]
    setdef options title  -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::toolBoxTitle $d "brush"]
    #...

    set d [dict remove $d title icon]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::toolBoxTitle {value type} {

    if {![dict exists $value title]} {
        return "nothing"
    }
    
    set d [dict get $value title]

    switch -exact -- $type {
        dataZoom {
            setdef options zoom   -minversion 5  -validvalue {} -type str   -default "Area zooming"
            setdef options back   -minversion 5  -validvalue {} -type str   -default "Restore area zooming" 
        }

        magicType {
            setdef options line   -minversion 5  -validvalue {} -type str   -default "Switch to Line Chart"
            setdef options bar    -minversion 5  -validvalue {} -type str   -default "Switch to Bar Chart"
            setdef options stack  -minversion 5  -validvalue {} -type str   -default "Stack"
            setdef options tiled  -minversion 5  -validvalue {} -type str   -default "Tile"
        }

        brush {
            setdef options rect     -minversion 5  -validvalue {} -type str   -default "Rectangle selection"
            setdef options polygon  -minversion 5  -validvalue {} -type str   -default "Polygon selection'"
            setdef options lineX    -minversion 5  -validvalue {} -type str   -default "Horizontal selection"
            setdef options lineY    -minversion 5  -validvalue {} -type str   -default "Vertical selection"
            setdef options keep     -minversion 5  -validvalue {} -type str   -default "Keep previous selection"
            setdef options clear    -minversion 5  -validvalue {} -type str   -default "Clear selection"
        }
    }
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::icon {value type} {

    if {![dict exists $value icon]} {
        return "nothing"
    }
    
    set d [dict get $value icon]

    switch -exact -- $type {
        dataZoom {
            setdef options zoom   -minversion 5  -validvalue {} -type str|null   -default "nothing"
            setdef options back   -minversion 5  -validvalue {} -type str|null   -default "nothing"
        }

        magicType {
            setdef options line   -minversion 5  -validvalue {} -type str|null   -default "nothing"
            setdef options bar    -minversion 5  -validvalue {} -type str|null   -default "nothing"
            setdef options stack  -minversion 5  -validvalue {} -type str|null   -default "nothing"
        }

        brush {
            setdef options rect     -minversion 5  -validvalue {} -type str|null   -default "nothing"
            setdef options polygon  -minversion 5  -validvalue {} -type str|null   -default "nothing"
            setdef options lineX    -minversion 5  -validvalue {} -type str|null   -default "nothing"
            setdef options lineY    -minversion 5  -validvalue {} -type str|null   -default "nothing"
            setdef options keep     -minversion 5  -validvalue {} -type str|null   -default "nothing"
            setdef options clear    -minversion 5  -validvalue {} -type str|null   -default "nothing"
        }
    }
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::iconEmphasis {value} {

    if {![dict exists $value emphasis]} {
        return "nothing"
    }
    
    set d [dict get $value emphasis]

    setdef options iconStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::iconStyle $d "emphasis"]
    #...

    set d [dict remove $d emphasis]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::iconStyle {value key} {

    if {![dict exists $value $key]} {
        return "nothing"
    }
    
    set d [dict get $value $key]

    setdef options color            -minversion 5  -validvalue formatColor      -type str|jsfunc|null -default "nothing"
    setdef options borderColor      -minversion 5  -validvalue formatColor      -type str|null        -default "#666"
    setdef options borderWidth      -minversion 5  -validvalue {}               -type num|null        -default 1
    setdef options borderType       -minversion 5  -validvalue formatBorderType -type str|num|list.n  -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}               -type num|null        -default 0
    setdef options borderCap        -minversion 5  -validvalue formatCap        -type str             -default "butt"
    setdef options borderJoin       -minversion 5  -validvalue formatJoin       -type str             -default "bevel"
    setdef options borderMiterLimit -minversion 5  -validvalue {}               -type num             -default 10
    setdef options shadowBlur       -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor      -type str|null        -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity    -type num|null        -default 1

    if {$key eq "emphasis"} {
        setdef options textPosition        -minversion 5  -validvalue formatTextPosition  -type str      -default "bottom"
        setdef options textFill            -minversion 5  -validvalue formatColor         -type str      -default "#000"
        setdef options textAlign           -minversion 5  -validvalue formatTextAlign     -type str      -default "center"
        setdef options textBackgroundColor -minversion 5  -validvalue formatColor         -type str|null -default "nothing"
        setdef options textBorderRadius    -minversion 5  -validvalue {}                  -type num|null -default "nothing"
        setdef options textPadding         -minversion 5  -validvalue {}                  -type num|null -default "nothing"
    }
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::brushStyle {value} {

    if {![ticklecharts::keyDictExists "brushStyle" $value key]} {
        return "nothing"
    }
    
    set d [dict get $value $key]

    if {[InfoNameProc 2 "dataZoom"]} {
        set color "rgba(135,175,274,0.15)"
        set borderwidth 0
    } else {
        set color "nothing"
        set borderwidth 1
    }

    setdef options color            -minversion 5  -validvalue formatColor      -type str|jsfunc|null -default $color
    setdef options borderColor      -minversion 5  -validvalue formatColor      -type str|null        -default "#000"
    setdef options borderWidth      -minversion 5  -validvalue {}               -type num|null        -default $borderwidth
    setdef options borderType       -minversion 5  -validvalue formatBorderType -type str|num|list.n  -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}               -type num|null        -default 0
    setdef options borderCap        -minversion 5  -validvalue formatCap        -type str             -default "butt"
    setdef options borderJoin       -minversion 5  -validvalue formatJoin       -type str             -default "bevel"
    setdef options borderMiterLimit -minversion 5  -validvalue {}               -type num             -default 10
    setdef options shadowBlur       -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor      -type str|null        -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity    -type num|null        -default 1
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::leaves {value} {

    if {![dict exists $value -leaves]} {
        return "nothing"
    }
    
    set d [dict get $value -leaves]

    setdef options label        -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $d]
    setdef options itemStyle    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $d]
    setdef options emphasis     -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $d]
    setdef options blur         -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::blur $d]
    #...

    set d [dict remove $d label itemStyle emphasis blur]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::encode {chart value} {

    if {![dict exists $value -encode]} {
        return "nothing"
    }

    set d [dict get $value -encode]

    setdef options x          -minversion 5  -validvalue {}  -type str|num|list.d|null  -default "nothing"
    setdef options y          -minversion 5  -validvalue {}  -type str|num|list.d|null  -default "nothing"
    setdef options itemName   -minversion 5  -validvalue {}  -type str|null             -default "nothing"
    setdef options label      -minversion 5  -validvalue {}  -type str|null             -default "nothing"
    setdef options value      -minversion 5  -validvalue {}  -type str|null             -default "nothing"
    setdef options radius     -minversion 5  -validvalue {}  -type num|null             -default "nothing"
    setdef options angle      -minversion 5  -validvalue {}  -type num|null             -default "nothing"
    setdef options tooltip    -minversion 5  -validvalue {}  -type list.d|str|null      -default "nothing"
    #...

    # Special case when dimensions are double values...
    # If I understand Echarts documentation
    # 'value' should be a string value
    set dataset [$chart dataset]
    if {[dict exists $d value]} {
        set v [dict get $d value] 
        foreach dimension [$dataset dim] {
            lassign $dimension datadim type
            if {($v in $datadim) && ([Type $v] ne "str")} {
                # force string representation
                dict set d value [string cat $v "<s!>"]
                break
            }
        }
    }

    if {[dict exists $d tooltip]} {
        set v [dict get $d tooltip]
        if {[Type $v] eq "num"} {
            # force string representation
            dict set d tooltip [string cat $v "<s!>"]
        }
    }

    set options [merge $options $d]

    return $options

}

proc ticklecharts::config {value} {

    if {![dict exists $value config]} {
        return "nothing"
    }
    
    set d [dict get $value config]

    setdef options dimension         -minversion 5  -validvalue {}  -type str|null        -default "nothing"
    setdef options order             -minversion 5  -validvalue {}  -type str|null        -default "nothing"
    setdef options groupBy           -minversion 5  -validvalue {}  -type str|null        -default "nothing"
    setdef options value             -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options gte               -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options itemNameFormatter -minversion 5  -validvalue {}  -type str|jsfunc|null -default "nothing"
    #...
    
    if {[dict exists $d resultDimensions]} {
        foreach item [dict get $d resultDimensions] {
            if {[llength $item] % 2} {
                error "item list must have an even number of elements..."
            }
            set listobj {}
            foreach {key info} $item {
                set val [ticklecharts::MapSpaceString $info]
                append listobj [format {%s {%s %s} } $key $val [Type $val]]
            }
            lappend opts $listobj
        }
        setdef options resultDimensions -minversion 5  -validvalue {}  -type list.o -default [list {*}$opts]
    }

    set d [dict remove $d resultDimensions]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::parallelAxisDefault {value} {

    if {![dict exists $value parallelAxisDefault]} {
        return "nothing"
    }

    set d [dict get $value parallelAxisDefault]

    setdef options type           -minversion 5  -validvalue formatType          -type str|null            -default "value"
    setdef options name           -minversion 5  -validvalue {}                  -type str|null            -default "nothing"
    setdef options nameLocation   -minversion 5  -validvalue formatNameLocation  -type str|null            -default "end"
    setdef options nameTextStyle  -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::nameTextStyle $d]
    setdef options nameGap        -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options nameRotate     -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options inverse        -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    setdef options boundaryGap    -minversion 5  -validvalue {}                  -type bool|list.d|null    -default "nothing"
    setdef options min            -minversion 5  -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
    setdef options max            -minversion 5  -validvalue {}                  -type num|str|jsfunc|null -default "nothing"
    setdef options scale          -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    setdef options splitNumber    -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options minInterval    -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options maxInterval    -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options interval       -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options logBase        -minversion 5  -validvalue {}                  -type num|null            -default "nothing"
    setdef options silent         -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    setdef options triggerEvent   -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    setdef options axisLine       -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisLine $d]
    setdef options axisTick       -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisTick $d]
    setdef options splitLine      -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::splitLine $d]
    setdef options minorTick      -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::minorTick $d]
    setdef options axisLabel      -minversion 5  -validvalue {}                  -type dict|null           -default [ticklecharts::axisLabel $d]
    setdef options data           -minversion 5  -validvalue {}                  -type list.d|null         -default "nothing"
    setdef options realtime       -minversion 5  -validvalue {}                  -type bool|null           -default "nothing"
    
    #...

    set d [dict remove $d nameTextStyle axisLine axisTick splitLine minorTick axisLabel]

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::areaSelectStyle {value} {

    if {![dict exists $value areaSelectStyle]} {
        return "nothing"
    }

    setdef options width       -minversion 5  -validvalue {}          -type num   -default 20
    setdef options borderWidth -minversion 5  -validvalue {}          -type num   -default 1
    setdef options borderColor -minversion 5  -validvalue formatColor -type str   -default "rgb(160,197,232)"
    setdef options color       -minversion 5  -validvalue formatColor -type str   -default "rgb(160,197,232)"
    setdef options opacity     -minversion 5  -validvalue {}          -type num   -default 0.3

    #...

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::brushStyle {value} {

    if {![dict exists $value brushStyle]} {
        return "nothing"
    }

    setdef options borderWidth -minversion 5  -validvalue {}          -type num   -default 1
    setdef options borderColor -minversion 5  -validvalue formatColor -type str   -default "rgba(120,140,180,0.8)"
    setdef options color       -minversion 5  -validvalue formatColor -type str   -default "rgba(120,140,180,0.3)"
    #...

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::brushVisual {key value} {

    if {![dict exists $value $key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str|null        -default "nothing"
    setdef options symbolSize       -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options color            -minversion 5  -validvalue formatColor      -type str|null        -default "nothing"
    setdef options colorAlpha       -minversion 5  -validvalue formatColor      -type list.d|str|null -default "nothing"
    setdef options opacity          -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options colorLightness   -minversion 5  -validvalue {}               -type str|null        -default "nothing"
    setdef options colorSaturation  -minversion 5  -validvalue {}               -type str|null        -default "nothing"
    setdef options colorHue         -minversion 5  -validvalue {}               -type str|null        -default "nothing"
    #...

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::timelineOpts {value} {

    if {$::ticklecharts::theme ne "basic"} {
        if {![dict exists $value -checkpointStyle]} {
            dict set value -checkpointStyle [dict create dummy null]
        }
        if {![dict exists $value -controlStyle]} {
            dict set value -controlStyle [dict create dummy null]
        }
        if {![dict exists $value -label]} {
            dict set value -label [dict create dummy null]
        }
        if {![dict exists $value -itemStyle]} {
            dict set value -itemStyle [dict create dummy null]
        }
    }

    setdef options -show                -minversion 5  -validvalue {}                      -type bool                 -default "True"
    setdef options -type                -minversion 5  -validvalue formatTimelineType      -type str                  -default "slider"
    setdef options -axisType            -minversion 5  -validvalue formatTimelineAxisType  -type str                  -default "time"
    setdef options -currentIndex        -minversion 5  -validvalue {}                      -type num|null             -default "nothing"
    setdef options -autoPlay            -minversion 5  -validvalue {}                      -type bool|null            -default "nothing"
    setdef options -rewind              -minversion 5  -validvalue {}                      -type bool|null            -default "nothing"
    setdef options -loop                -minversion 5  -validvalue {}                      -type bool                 -default "True"
    setdef options -playInterval        -minversion 5  -validvalue {}                      -type num                  -default 1000
    setdef options -realtime            -minversion 5  -validvalue {}                      -type bool                 -default "True"
    setdef options -replaceMerge        -minversion 5  -validvalue formatTimelineMerge     -type str|list.s|null      -default "nothing"
    setdef options -controlPosition     -minversion 5  -validvalue formatTimelinePosition  -type str                  -default "left"
    setdef options -width               -minversion 5  -validvalue {}                      -type num|null             -default "nothing"
    setdef options -zlevel              -minversion 5  -validvalue {}                      -type num|null             -default "nothing"
    setdef options -z                   -minversion 5  -validvalue {}                      -type num                  -default 2
    setdef options -left                -minversion 5  -validvalue formatLeft              -type str|num|null         -default "nothing"
    setdef options -top                 -minversion 5  -validvalue formatTop               -type str|num|null         -default "nothing"
    setdef options -right               -minversion 5  -validvalue formatRight             -type str|num|null         -default "nothing"
    setdef options -bottom              -minversion 5  -validvalue formatBottom            -type str|num|null         -default "nothing"
    setdef options -padding             -minversion 5  -validvalue {}                      -type num|list.n           -default 5
    setdef options -orient              -minversion 5  -validvalue formatOrient            -type str                  -default "horizontal"
    setdef options -inverse             -minversion 5  -validvalue {}                      -type bool|null            -default "nothing"
    setdef options -itemSymbol          -minversion 5  -validvalue formatItemSymbol        -type str|null             -default "emptyCircle"
    setdef options -symbolSize          -minversion 5  -validvalue {}                      -type num|list.n           -default 10
    setdef options -symbolRotate        -minversion 5  -validvalue {}                      -type num|null             -default "nothing"
    setdef options -symbolKeepAspect    -minversion 5  -validvalue {}                      -type bool|null            -default "nothing"
    setdef options -symbolOffset        -minversion 5  -validvalue {}                      -type list.n|null          -default "nothing"
    setdef options -lineStyle           -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::lineStyle $value]
    setdef options -label               -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::label $value]
    setdef options -itemStyle           -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::itemStyle $value]
    setdef options -checkpointStyle     -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::checkpointStyle $value]
    setdef options -controlStyle        -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::controlStyle $value]
    setdef options -progress            -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::progress $value]
    setdef options -emphasis            -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::emphasis $value]
    #...
    
    # remove key(s)
    if {[llength $value]} {
        set value [dict remove $value -lineStyle -label -itemStyle \
                                      -checkpointStyle -controlStyle \
                                      -progress -emphasis]
    }

    set options [merge $options $value]

    return $options

}

proc ticklecharts::checkpointStyle {value} {

    if {![dict exists $value -checkpointStyle]} {
        return "nothing"
    }

    set d [dict get $value -checkpointStyle]

    setdef options symbol            -minversion 5  -validvalue formatItemSymbol -type str         -default "circle"
    setdef options symbolSize        -minversion 5  -validvalue {}               -type num         -default 13
    setdef options symbolRotate      -minversion 5  -validvalue {}               -type num|null    -default "nothing"
    setdef options symbolKeepAspect  -minversion 5  -validvalue {}               -type bool        -default "False"
    setdef options symbolOffset      -minversion 5  -validvalue {}               -type list.n|null -default "nothing"
    setdef options color             -minversion 5  -validvalue formatColor      -type str|null    -default [EchartsOptsTheme timelineCheckColor]
    setdef options borderColor       -minversion 5  -validvalue formatColor      -type str|null    -default [EchartsOptsTheme timelineCheckBorderColor]
    setdef options borderWidth       -minversion 5  -validvalue {}               -type num|null    -default 2
    setdef options borderType        -minversion 5  -validvalue formatBorderType -type str|null    -default "solid"
    setdef options borderDashOffset  -minversion 5  -validvalue {}               -type num|null    -default "nothing"
    setdef options borderCap         -minversion 5  -validvalue formatCap        -type str         -default "butt"
    setdef options borderJoin        -minversion 5  -validvalue formatJoin       -type str         -default "bevel"
    setdef options borderMiterLimit  -minversion 5  -validvalue {}               -type num         -default 10
    setdef options shadowBlur        -minversion 5  -validvalue {}               -type num|null    -default 2
    setdef options shadowColor       -minversion 5  -validvalue formatColor      -type str|null    -default "rgba(0, 0, 0, 0.3)"
    setdef options shadowOffsetX     -minversion 5  -validvalue {}               -type num|null    -default 1
    setdef options shadowOffsetY     -minversion 5  -validvalue {}               -type num|null    -default 1
    setdef options opacity           -minversion 5  -validvalue formatOpacity    -type num|null    -default "nothing"
    setdef options animation         -minversion 5  -validvalue {}               -type bool|null   -default "True"
    setdef options animationDuration -minversion 5  -validvalue {}               -type num|null    -default 300
    setdef options animationEasing   -minversion 5  -validvalue formatAEasing    -type str|null    -default "quinticInOut"
    #...

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::controlStyle {value} {

    if {![dict exists $value -controlStyle]} {
        return "nothing"
    }

    set d [dict get $value -controlStyle]

    setdef options show             -minversion 5  -validvalue {}                  -type bool        -default "True"
    setdef options showPlayBtn      -minversion 5  -validvalue {}                  -type bool        -default "True"
    setdef options showNextBtn      -minversion 5  -validvalue {}                  -type bool        -default "True"
    setdef options itemSize         -minversion 5  -validvalue {}                  -type num         -default 22
    setdef options itemGap          -minversion 5  -validvalue {}                  -type num         -default 12

    if {[dict exists $value orient] && [dict get $value orient] eq "vertical"} {
        setdef options position  -minversion 5  -validvalue {}  -type str  -default "top"
    } else {
        setdef options position  -minversion 5  -validvalue {}  -type str  -default "left"
    }

    setdef options playIcon          -minversion 5  -validvalue formatTimelineIcon  -type str|null    -default "nothing"
    setdef options stopIcon          -minversion 5  -validvalue formatTimelineIcon  -type str|null    -default "nothing"
    setdef options prevIcon          -minversion 5  -validvalue formatTimelineIcon  -type str|null    -default "nothing"
    setdef options color             -minversion 5  -validvalue formatColor         -type str|null    -default [EchartsOptsTheme timelineItemColor]
    setdef options borderColor       -minversion 5  -validvalue formatColor         -type str|null    -default [EchartsOptsTheme timelineItemColor]
    setdef options borderWidth       -minversion 5  -validvalue {}                  -type num|null    -default 1
    setdef options borderType        -minversion 5  -validvalue formatBorderType    -type str|null    -default "solid"
    setdef options borderDashOffset  -minversion 5  -validvalue {}                  -type num|null    -default "nothing"
    setdef options borderCap         -minversion 5  -validvalue formatCap           -type str         -default "butt"
    setdef options borderJoin        -minversion 5  -validvalue formatJoin          -type str         -default "bevel"
    setdef options borderMiterLimit  -minversion 5  -validvalue {}                  -type num         -default 10
    setdef options shadowBlur        -minversion 5  -validvalue {}                  -type num|null    -default "nothing"
    setdef options shadowColor       -minversion 5  -validvalue formatColor         -type str|null    -default "nothing"
    setdef options shadowOffsetX     -minversion 5  -validvalue {}                  -type num|null    -default "nothing"
    setdef options shadowOffsetY     -minversion 5  -validvalue {}                  -type num|null    -default "nothing"
    setdef options opacity           -minversion 5  -validvalue formatOpacity       -type num|null    -default "nothing"
    #...
    
    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::progress {value} {

    if {![dict exists $value -progress]} {
        return "nothing"
    }

    set d [dict get $value -progress]

    setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $d]
    setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $d]
    setdef options lineStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::lineStyle $d]


    if {[InfoNameProc 2 "gaugeseries"]} {
        setdef options show     -minversion 5  -validvalue {} -type bool -default "False"
        setdef options overlap  -minversion 5  -validvalue {} -type bool -default "True"
        setdef options width    -minversion 5  -validvalue {} -type num  -default 10
        setdef options roundCap -minversion 5  -validvalue {} -type bool -default "False"
        setdef options clip     -minversion 5  -validvalue {} -type bool -default "False"
        # remove flag from dict options... not present in series-gauge.progress
        set options [dict remove $options label lineStyle]
    }

    #...
    set d [dict remove $d label itemStyle lineStyle]

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::pointer {value} {

    if {![dict exists $value -pointer]} {
        return "nothing"
    }

    set d [dict get $value -pointer]

    setdef options show         -minversion 5       -validvalue {}               -type bool      -default "True"
    setdef options showAbove    -minversion "5.2.0" -validvalue {}               -type bool      -default "True"
    setdef options icon         -minversion 5       -validvalue formatItemSymbol -type str|null  -default "nothing"
    setdef options offsetCenter -minversion 5       -validvalue {}               -type list.d    -default [list {0 0}]
    setdef options length       -minversion 5       -validvalue {}               -type str|num   -default "60%"
    setdef options width        -minversion 5       -validvalue {}               -type num       -default 6
    setdef options keepAspect   -minversion 5       -validvalue {}               -type bool|null -default "nothing"
    setdef options itemStyle    -minversion 5       -validvalue {}               -type dict|null -default [ticklecharts::itemStyle $d]

    #...
    set d [dict remove $d label itemStyle]

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::anchor {value} {

    if {![dict exists $value -anchor]} {
        return "nothing"
    }

    set d [dict get $value -anchor]

    setdef options show         -minversion 5  -validvalue {}               -type bool      -default "True"
    setdef options showAbove    -minversion 5  -validvalue {}               -type bool      -default "False"
    setdef options size         -minversion 5  -validvalue {}               -type num       -default 6
    setdef options icon         -minversion 5  -validvalue formatItemSymbol -type str|null  -default "nothing"
    setdef options offsetCenter -minversion 5  -validvalue {}               -type list.d    -default [list {0 0}]    
    setdef options keepAspect   -minversion 5  -validvalue {}               -type bool|null -default "False"
    setdef options itemStyle    -minversion 5  -validvalue {}               -type dict|null -default [ticklecharts::itemStyle $d]

    #...
    set d [dict remove $d label itemStyle]

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::titleGauge {value} {

    if {![ticklecharts::keyDictExists "title" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show                 -minversion 5  -validvalue {}                   -type bool                -default "True"
    setdef options offsetCenter         -minversion 5  -validvalue {}                   -type list.d              -default [list {0 "20%"}]    
    setdef options keepAspect           -minversion 5  -validvalue {}                   -type bool|null           -default "False"
    setdef options itemStyle            -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::itemStyle $d]
    setdef options color                -minversion 5  -validvalue formatColor          -type str|null            -default "#464646"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str|null            -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|null            -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str|null            -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num|null            -default 16
    setdef options lineHeight           -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options backgroundColor      -minversion 5  -validvalue formatColor          -type str|null            -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor          -type str|null            -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options borderType           -minversion 5  -validvalue formatBorderType     -type str|null            -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options borderRadius         -minversion 5  -validvalue {}                   -type num|list.n|null     -default "nothing"
    setdef options padding              -minversion 5  -validvalue {}                   -type num|list.n|null     -default "nothing"
    setdef options shadowColor          -minversion 5  -validvalue formatColor          -type str|null            -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options width                -minversion 5  -validvalue {}                   -type num|str|null        -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                   -type num|str|null        -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue formatColor          -type str|null            -default "nothing"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n|null -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str|null            -default "transparent"
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options overflow             -minversion 5  -validvalue formatOverflow       -type str                 -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                   -type str                 -default "..."
    setdef options valueAnimation       -minversion 5  -validvalue {}                   -type bool|null           -default "nothing"
    #...

    set d [dict remove $d itemStyle]

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::detail {value} {

    if {![ticklecharts::keyDictExists "detail" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show                 -minversion 5  -validvalue {}                   -type bool                -default "True"
    setdef options color                -minversion 5  -validvalue formatColor          -type str|null            -default "#464646"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str|null            -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|null            -default "bold"
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str|null            -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num|null            -default 30
    setdef options lineHeight           -minversion 5  -validvalue {}                   -type num|null            -default 30
    setdef options backgroundColor      -minversion 5  -validvalue formatColor          -type str|null            -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor          -type str|null            -default "#ccc"
    setdef options borderWidth          -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options borderType           -minversion 5  -validvalue formatBorderType     -type str|null            -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options borderRadius         -minversion 5  -validvalue {}                   -type num|list.n|null     -default "nothing"
    setdef options padding              -minversion 5  -validvalue {}                   -type num|list.n|null     -default "nothing"
    setdef options shadowColor          -minversion 5  -validvalue formatColor          -type str|null            -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options width                -minversion 5  -validvalue {}                   -type num|str|null        -default 100
    setdef options height               -minversion 5  -validvalue {}                   -type num|str|null        -default 40
    setdef options textBorderColor      -minversion 5  -validvalue formatColor          -type str|null            -default "nothing"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n|null -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str|null            -default "transparent"
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options overflow             -minversion 5  -validvalue formatOverflow       -type str                 -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                   -type str                 -default "..."
    setdef options valueAnimation       -minversion 5  -validvalue {}                   -type bool|null           -default "nothing"
    setdef options offsetCenter         -minversion 5  -validvalue {}                   -type list.d              -default [list {0 "40%"}] 
    setdef options formatter            -minversion 5  -validvalue {}                   -type str|jsfunc|null     -default "nothing"
    setdef options rich                 -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::RichItem $d]
    #...

    set d [dict remove $d rich]
    
    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::circular {value} {

    if {![ticklecharts::keyDictExists "circular" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options rotateLabel  -minversion 5  -validvalue {} -type bool  -default "True"

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::force {value} {

    if {![ticklecharts::keyDictExists "force" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options initLayout      -minversion 5  -validvalue {} -type str|null    -default "nothing"
    setdef options repulsion       -minversion 5  -validvalue {} -type num|list.d  -default 50
    setdef options gravity         -minversion 5  -validvalue {} -type num         -default 0.1
    setdef options edgeLength      -minversion 5  -validvalue {} -type num|list.d  -default 30
    setdef options layoutAnimation -minversion 5  -validvalue {} -type bool        -default "True"
    setdef options friction        -minversion 5  -validvalue {} -type num         -default 0.6

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::scaleLimit {value} {

    if {![ticklecharts::keyDictExists "scaleLimit" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options max   -minversion 5  -validvalue {} -type num  -default 1
    setdef options min   -minversion 5  -validvalue {} -type num  -default 1

    set options [merge $options $d]

    return $options

}

proc ticklecharts::edgeLabel {value} {

    if {![ticklecharts::keyDictExists "edgeLabel" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show                 -minversion 5  -validvalue {}                      -type bool|null           -default "nothing"
    setdef options position             -minversion 5  -validvalue formatEdgeLabelPosition -type str                 -default "middle"
    setdef options formatter            -minversion 5  -validvalue {}                      -type str|jsfunc|null     -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type str|null|null       -default "nothing"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str|null            -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|null            -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str|null            -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num|null            -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str|null            -default "nothing"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str|null            -default "nothing"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type str|null            -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null            -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|null            -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num|list.n|null     -default "nothing"
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n|null     -default "nothing"
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str|null            -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options width                -minversion 5  -validvalue {}                      -type num|str|null        -default 100
    setdef options height               -minversion 5  -validvalue {}                      -type num|str|null        -default 40
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null            -default "nothing"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n|null -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str|null            -default "transparent"
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str                 -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str                 -default "..."
    setdef options valueAnimation       -minversion 5  -validvalue {}                      -type bool|null           -default "nothing"
    setdef options rich                 -minversion 5  -validvalue {}                      -type dict|null           -default [ticklecharts::RichItem $d]
    #...

    set d [dict remove $d rich]
    
    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::categories {value} {

    if {![ticklecharts::keyDictExists "categories" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} {
            error "item list for '[lindex [info level 0] 0]' must have an even number of elements..."
        }

        setdef options name             -minversion 5  -validvalue {}               -type str|null          -default "nothing"
        setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str|null          -default "nothing"
        setdef options symbolSize       -minversion 5  -validvalue {}               -type num|list.d|null   -default "nothing"
        setdef options symbolRotate     -minversion 5  -validvalue {}               -type num|null          -default "nothing"
        setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool              -default "False"
        setdef options symbolOffset     -minversion 5  -validvalue {}               -type list.d|null       -default "nothing"
        setdef options itemStyle        -minversion 5  -validvalue {}               -type dict|null         -default [ticklecharts::itemStyle $item]
        setdef options label            -minversion 5  -validvalue {}               -type dict|null         -default [ticklecharts::label $item]
        setdef options emphasis         -minversion 5  -validvalue {}               -type dict|null         -default [ticklecharts::emphasis $item]
        setdef options blur             -minversion 5  -validvalue {}               -type dict|null         -default [ticklecharts::blur $item]
        setdef options select           -minversion 5  -validvalue {}               -type dict|null         -default [ticklecharts::select $item]


        set item [dict remove $item itemStyle label emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]

}

proc ticklecharts::breadcrumb {value} {

    if {![dict exists $value breadcrumb]} {
        return "nothing"
    }

    set d [dict get $value breadcrumb]

    setdef options show           -minversion 5       -validvalue {}            -type bool          -default "True"
    setdef options left           -minversion 5       -validvalue formatLeft    -type str|num|null  -default "center"
    setdef options top            -minversion 5       -validvalue formatTop     -type str|num|null  -default "auto"
    setdef options right          -minversion 5       -validvalue formatRight   -type str|num|null  -default "auto"
    setdef options bottom         -minversion 5       -validvalue formatBottom  -type str|num|null  -default "auto"
    setdef options height         -minversion 5       -validvalue {}            -type num           -default 22
    setdef options emptyItemWidth -minversion 5       -validvalue {}            -type num           -default 25
    setdef options itemStyle      -minversion 5       -validvalue {}            -type dict|null     -default [ticklecharts::itemStyle $value]
    setdef options emphasis       -minversion "5.4.0" -validvalue {}            -type dict|null     -default [ticklecharts::emphasis $value]
    #...
    
    # remove key(s)
    set d [dict remove $d emphasis itemStyle]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::pageIcons {value} {

    if {![ticklecharts::keyDictExists "pageIcons" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options horizontal -minversion 5  -validvalue {}  -type list.s|null  -default "nothing"
    setdef options vertical   -minversion 5  -validvalue {}  -type list.s|null  -default "nothing"
    #...
    
    set options [merge $options $d]

    return $options

}

proc ticklecharts::pageTextStyle {value} {

    if {![ticklecharts::keyDictExists "pageIcons" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]
    
    setdef options color                -minversion 5  -validvalue formatColor          -type str|jsfunc|null -default $color
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str             -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|num         -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num             -default 12
    setdef options lineHeight           -minversion 5  -validvalue {}                   -type num|null        -default "nothing"
    setdef options width                -minversion 5  -validvalue {}                   -type num|null        -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                   -type num|null        -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue {}                   -type str|null        -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str             -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num             -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow       -type str|null        -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                   -type str             -default "..."
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::emphasisLegend {value} {

    if {![ticklecharts::keyDictExists "emphasis" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    # To avoid error in merge command...
    if {![dict exists $key selectorLabel]} {
        return "nothing"
    }

    setdef options selectorLabel  -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::selectorLabel $d]

    # remove key(s)
    set d [dict remove $d selectorLabel]

    set options [merge $options $d]

    return $options

}

proc ticklecharts::selectorLabel {value} {

    if {![ticklecharts::keyDictExists "selectorLabel" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show                 -minversion 5  -validvalue {}                      -type bool            -default "True"
    setdef options distance             -minversion 5  -validvalue {}                      -type num             -default 12
    setdef options rotate               -minversion 5  -validvalue formatRotate            -type num|null        -default "nothing"
    setdef options offset               -minversion 5  -validvalue {}                      -type list.n|null     -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type str|null        -default [EchartsOptsTheme axisLabelColor]
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str             -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num         -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num             -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str|null        -default "nothing"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str|null        -default "nothing"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num             -default 12
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null        -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n  -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num|null        -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n      -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num|null        -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                      -type num|null        -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null        -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str             -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num             -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str             -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str             -default "..."
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::handle {value} {

    if {![ticklecharts::keyDictExists "handle" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options show          -minversion 5  -validvalue {}                 -type bool             -default "True"
    setdef options icon          -minversion 5  -validvalue formatTimelineIcon -type str|null         -default "nothing"
    setdef options size          -minversion 5  -validvalue {}                 -type num|list.n|null  -default 45
    setdef options margin        -minversion 5  -validvalue {}                 -type num|null         -default 50
    setdef options color         -minversion 5  -validvalue formatColor        -type str|null         -default "nothing"
    setdef options throttle      -minversion 5  -validvalue {}                 -type num|null         -default 40
    setdef options shadowBlur    -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options shadowColor   -minversion 5  -validvalue formatColor        -type str|null         -default "nothing"
    setdef options shadowOffsetX -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options shadowOffsetY -minversion 5  -validvalue {}                 -type num|null         -default "nothing"

    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::projection {value} {

    if {![ticklecharts::keyDictExists "projection" $value key]} {
        return "nothing"
    }

    set d [dict get $value $key]

    setdef options project    -minversion 5  -validvalue {}  -type jsfunc|null  -default "nothing"
    setdef options unproject  -minversion 5  -validvalue {}  -type jsfunc|null  -default "nothing"
    setdef options stream     -minversion 5  -validvalue {}  -type jsfunc|null  -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::nameMap {value} {

    if {![dict exists $value -nameMap]} {
        return "nothing"
    }

    foreach {key item} [dict get $value -nameMap] {

        if {$item eq ""} {
            error "'[lindex [info level 0] 0]' should be a 'key + item'"
        }

        # map spaces... and others...
        set key [ticklecharts::MapSpaceString $key]

        # set key in options...
        setdef options $key -minversion 5 -validvalue {} -type str|num|list.d -default $item

        append opts "[merge $options [list $key $item]] "
        set options {}
    }

    return [dict create {*}$opts]

}
