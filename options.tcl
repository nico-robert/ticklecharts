# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::levelsSankeyItem {value} {

    if {![ticklecharts::keyDictExists "-levels" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options depth       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options lineStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::lineStyle $item]
        setdef options emphasis    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur        -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select      -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        # remove key(s)...
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

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options name        -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options depth       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur        -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select      -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        # remove key(s)...
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

    set levelP      [ticklecharts::getLevelProperties [info level]]
    set graphSeries [expr {[ticklecharts::whichSeries? $levelP] eq "graphSeries"}]

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options source      -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options target      -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options lineStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::lineStyle $item]
        setdef options emphasis    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur        -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select      -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        if {$graphSeries} {
            setdef options source            -minversion 5  -validvalue {}               -type str|num|null    -default "nothing"
            setdef options target            -minversion 5  -validvalue {}               -type str|num|null    -default "nothing"
            setdef options symbol            -minversion 5  -validvalue formatItemSymbol -type str|null        -default "nothing"
            setdef options symbolSize        -minversion 5  -validvalue {}               -type num|list.d|null -default "nothing"
            setdef options ignoreForceLayout -minversion 5  -validvalue {}               -type bool|null       -default "nothing"
            setdef options label             -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::label $item]
        }

        # remove key(s)...
        set item [dict remove $item label lineStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::themeRiverData {value} {

    if {![ticklecharts::keyDictExists "-data" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] != 3} {
            error "Item list should be a list of 3 elements for\
                  [ticklecharts::getLevelProperties [info level]] see\
                  https://echarts.apache.org/en/option.html#series-themeRiver.data"
        }

        lassign $item date value name

        setdef options date   -minversion 5  -validvalue {}   -type str|num  -default "nothing"
        setdef options value  -minversion 5  -validvalue {}   -type num      -default "nothing"
        setdef options name   -minversion 5  -validvalue {}   -type str      -default "nothing"

        # Check that the items on my list are correct.
        merge $options [list date $date value $value name $name]

        lappend opts [list $date $value $name]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::treeItem {value} {

    set key [ticklecharts::itemKey {-data -dataItem children} $value]

    if {$key eq ""} {return "nothing"}

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options name                    -minversion 5  -validvalue {}            -type str|null        -trace no   -default "nothing"
        setdef options value                   -minversion 5  -validvalue {}            -type num|null        -trace no   -default "nothing"
        setdef options collapsed               -minversion 5  -validvalue {}            -type bool|null       -trace no   -default "False"
        setdef options itemStyle               -minversion 5  -validvalue {}            -type dict|null       -trace no   -default [ticklecharts::itemStyle $item]
        setdef options lineStyle               -minversion 5  -validvalue {}            -type dict|null       -trace no   -default [ticklecharts::lineStyle $item]
        setdef options children                -minversion 5  -validvalue {}            -type list.o|null     -trace no   -default [ticklecharts::treeItem $item]
        setdef options label                   -minversion 5  -validvalue {}            -type dict|null       -trace no   -default [ticklecharts::label $item]
        setdef options emphasis                -minversion 5  -validvalue {}            -type dict|null       -trace no   -default [ticklecharts::emphasis $item]
        setdef options blur                    -minversion 5  -validvalue {}            -type dict|null       -trace no   -default [ticklecharts::blur $item]
        setdef options select                  -minversion 5  -validvalue {}            -type dict|null       -trace no   -default [ticklecharts::select $item]
        setdef options animation               -minversion 5  -validvalue {}            -type bool|null       -trace yes  -default "nothing"
        setdef options animationThreshold      -minversion 5  -validvalue {}            -type num|null        -trace no   -default "nothing"
        setdef options animationDuration       -minversion 5  -validvalue {}            -type num|jsfunc|null -trace no   -default "nothing"
        setdef options animationEasing         -minversion 5  -validvalue formatAEasing -type str|null        -trace no   -default "nothing"
        setdef options animationDelay          -minversion 5  -validvalue {}            -type num|jsfunc|null -trace no   -default "nothing"
        setdef options animationDurationUpdate -minversion 5  -validvalue {}            -type num|jsfunc|null -trace no   -default "nothing"
        setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing -type str|null        -trace no   -default "nothing"
        setdef options animationDelayUpdate    -minversion 5  -validvalue {}            -type num|jsfunc|null -trace no   -default "nothing"

        # remove key(s)...
        set item [dict remove $item children label itemStyle lineStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::legendItem {value} {

    foreach item [dict get $value dataLegendItem] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options name                -minversion 5  -validvalue {}               -type str|null          -default "nothing"
        setdef options icon                -minversion 5  -validvalue formatItemSymbol -type str|null          -default "nothing"
        setdef options inactiveColor       -minversion 5  -validvalue formatColor      -type str|e.color|null  -default "nothing"
        setdef options inactiveBorderColor -minversion 5  -validvalue formatColor      -type str|e.color|null  -default "nothing"
        setdef options inactiveBorderWidth -minversion 5  -validvalue formatIBwidth    -type str|num|null      -default "nothing"
        setdef options itemStyle           -minversion 5  -validvalue {}               -type dict|null         -default [ticklecharts::itemStyle $item]
        setdef options lineStyle           -minversion 5  -validvalue {}               -type dict|null         -default [ticklecharts::lineStyle $item]
        setdef options symbolRotate        -minversion 5  -validvalue {}               -type str|num|null      -default "inherit"
        setdef options textStyle           -minversion 5  -validvalue {}               -type dict|null         -default [ticklecharts::textStyle $item textStyle]

        # remove key(s)...
        set item [dict remove $item itemStyle lineStyle textStyle]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::sunburstItem {value} {

    set key [ticklecharts::itemKey {-data -dataItem children} $value]

    if {$key eq ""} {return "nothing"}

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options name        -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}  -type num|null    -default "nothing"
        setdef options link        -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options children    -minversion 5  -validvalue {}  -type list.o|null -default [ticklecharts::sunburstItem $item]
        setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]

        # remove key(s)...
        set item [dict remove $item children label labelLine itemStyle]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::levelsItem {value} {

    if {![ticklecharts::keyDictExists "-levels" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options radius      -minversion "5.2.0" -validvalue {}  -type list.d|null -default "nothing"
        setdef options label       -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine   -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle   -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis    -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur        -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select      -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        # remove key(s)...
        set item [dict remove $item label labelLine itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::treemapItem {value} {

    set key [ticklecharts::itemKey {-data -dataItem children} $value]

    if {$key eq ""} {return "nothing"}

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $key value
        }

        setdef options value                -minversion 5        -validvalue {}                  -type num|list.d|null  -default "nothing"
        setdef options id                   -minversion 5        -validvalue {}                  -type str|null         -default "nothing"
        setdef options name                 -minversion 5        -validvalue {}                  -type str|null         -default "nothing"
        setdef options path                 -minversion 5        -validvalue {}                  -type str|null         -default "nothing"
        setdef options visualDimension      -minversion 5        -validvalue {}                  -type num|null         -default "nothing"
        setdef options visualMin            -minversion 5        -validvalue {}                  -type num|null         -default "nothing"
        setdef options visualMax            -minversion 5        -validvalue {}                  -type num|null         -default "nothing"
        setdef options color                -minversion 5        -validvalue formatColor         -type e.color|str|null -default "nothing"
        setdef options colorAlpha           -minversion 5        -validvalue {}                  -type list.d|null      -default "nothing"
        setdef options colorSaturation      -minversion 5        -validvalue {}                  -type list.d|null      -default "nothing"
        setdef options colorMappingBy       -minversion 5        -validvalue formatColorMapping  -type str              -default "index"
        setdef options visibleMin           -minversion 5        -validvalue {}                  -type num              -default 10
        setdef options childrenVisibleMin   -minversion 5        -validvalue {}                  -type num|null         -default "nothing"
        setdef options label                -minversion 5        -validvalue {}                  -type dict|null        -default [ticklecharts::label $item]
        setdef options upperLabel           -minversion 5        -validvalue {}                  -type dict|null        -default [ticklecharts::upperLabel $item]
        setdef options itemStyle            -minversion 5        -validvalue {}                  -type dict|null        -default [ticklecharts::itemStyle $item]
        setdef options emphasis             -minversion 5        -validvalue {}                  -type dict|null        -default [ticklecharts::emphasis $item]
        setdef options blur                 -minversion 5        -validvalue {}                  -type dict|null        -default [ticklecharts::blur $item]
        setdef options select               -minversion 5        -validvalue {}                  -type dict|null        -default [ticklecharts::select $item]
        setdef options link                 -minversion 5        -validvalue {}                  -type str|null         -default "nothing"
        setdef options target               -minversion 5        -validvalue formatTarget        -type str|null         -default "blank"
        setdef options children             -minversion 5        -validvalue {}                  -type list.o|null      -default [ticklecharts::treemapItem $item]
        setdef options tooltip              -minversion 5        -validvalue {}                  -type dict|null        -default [ticklecharts::tooltip $item]
        setdef options cursor               -minversion "5.6.0"  -validvalue formatCursor        -type str|null         -default "nothing"

        # remove key(s)...
        set item [dict remove $item children label upperLabel itemStyle tooltip emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::levelsTreeMapItem {value} {

    if {![ticklecharts::keyDictExists "-levels" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options visualDimension      -minversion 5  -validvalue {}                  -type num|null                -default "nothing"
        setdef options visualMin            -minversion 5  -validvalue {}                  -type num|null                -default "nothing"
        setdef options visualMax            -minversion 5  -validvalue {}                  -type num|null                -default "nothing"
        setdef options color                -minversion 5  -validvalue formatColor         -type e.color|str|list.s|null -default "nothing"
        setdef options colorAlpha           -minversion 5  -validvalue {}                  -type list.d|null             -default "nothing"
        setdef options colorSaturation      -minversion 5  -validvalue {}                  -type list.d|null             -default "nothing"
        setdef options colorMappingBy       -minversion 5  -validvalue formatColorMapping  -type str                     -default "index"
        setdef options visibleMin           -minversion 5  -validvalue {}                  -type num                     -default 10
        setdef options childrenVisibleMin   -minversion 5  -validvalue {}                  -type num|null                -default "nothing"
        setdef options label                -minversion 5  -validvalue {}                  -type dict|null               -default [ticklecharts::label $item]
        setdef options upperLabel           -minversion 5  -validvalue {}                  -type dict|null               -default [ticklecharts::upperLabel $item]
        setdef options itemStyle            -minversion 5  -validvalue {}                  -type dict|null               -default [ticklecharts::itemStyle $item]
        setdef options emphasis             -minversion 5  -validvalue {}                  -type dict|null               -default [ticklecharts::emphasis $item]
        setdef options blur                 -minversion 5  -validvalue {}                  -type dict|null               -default [ticklecharts::blur $item]
        setdef options select               -minversion 5  -validvalue {}                  -type dict|null               -default [ticklecharts::select $item]

        # remove key(s)...
        set item [dict remove $item label upperLabel itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::barItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        setdef options name          -minversion 5       -validvalue {}  -type str|null    -default "nothing"
        setdef options value         -minversion 5       -validvalue {}  -type num|null    -default "nothing"
        setdef options groupId       -minversion 5       -validvalue {}  -type str|null    -default "nothing"
        setdef options childGroupId  -minversion "5.5.0" -validvalue {}  -type str|null    -default "nothing"
        setdef options label         -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine     -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle     -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis      -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur          -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select        -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::select $item]

        # remove key(s)...
        set item [dict remove $item label labelLine itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::pictorialBarItem {value key} {

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $key value
        }

        setdef options name                    -minversion 5  -validvalue {}                    -type str|null          -trace no   -default "nothing"
        setdef options value                   -minversion 5  -validvalue {}                    -type num|null          -trace no   -default "nothing"
        setdef options groupId                 -minversion 5  -validvalue {}                    -type str|null          -trace no   -default "nothing"
        setdef options symbol                  -minversion 5  -validvalue formatItemSymbol      -type str|jsfunc|null   -trace no   -default "nothing"
        setdef options symbolSize              -minversion 5  -validvalue {}                    -type num|list.d|null   -trace no   -default "nothing"
        setdef options symbolPosition          -minversion 5  -validvalue formatSymbolPosition  -type str|null          -trace no   -default "nothing"
        setdef options symbolOffset            -minversion 5  -validvalue {}                    -type list.d|null       -trace no   -default "nothing"
        setdef options symbolRotate            -minversion 5  -validvalue {}                    -type num|null          -trace no   -default "nothing"
        setdef options symbolRepeat            -minversion 5  -validvalue formatSymbolRepeat    -type bool|str|num|null -trace no   -default "nothing"
        setdef options symbolRepeatDirection   -minversion 5  -validvalue formatsymbolRepeatDir -type str|null          -trace no   -default "nothing"
        setdef options symbolMargin            -minversion 5  -validvalue {}                    -type str|num|null      -trace no   -default "nothing"
        setdef options symbolClip              -minversion 5  -validvalue {}                    -type bool|null         -trace no   -default "nothing"
        setdef options symbolBoundingData      -minversion 5  -validvalue {}                    -type num|null          -trace no   -default "nothing"
        setdef options symbolPatternSize       -minversion 5  -validvalue {}                    -type num|null          -trace no   -default "nothing"
        setdef options hoverAnimation          -minversion 5  -validvalue {}                    -type bool|null         -trace no   -default "nothing"
        setdef options z                       -minversion 5  -validvalue {}                    -type num|null          -trace no   -default "nothing"
        setdef options animation               -minversion 5  -validvalue {}                    -type bool|null         -trace yes  -default "nothing"
        setdef options animationThreshold      -minversion 5  -validvalue {}                    -type num|null          -trace no   -default "nothing"
        setdef options animationDuration       -minversion 5  -validvalue {}                    -type num|jsfunc|null   -trace no   -default "nothing"
        setdef options animationEasing         -minversion 5  -validvalue formatAEasing         -type str|null          -trace no   -default "nothing"
        setdef options animationDelay          -minversion 5  -validvalue {}                    -type num|jsfunc|null   -trace no   -default "nothing"
        setdef options animationDurationUpdate -minversion 5  -validvalue {}                    -type num|jsfunc|null   -trace no   -default "nothing"
        setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing         -type str|null          -trace no   -default "nothing"
        setdef options animationDelayUpdate    -minversion 5  -validvalue {}                    -type num|jsfunc|null   -trace no   -default "nothing"
        setdef options labelLine               -minversion 5  -validvalue {}                    -type dict|null         -trace no   -default [ticklecharts::labelLine $item]
        setdef options itemStyle               -minversion 5  -validvalue {}                    -type dict|null         -trace no   -default [ticklecharts::itemStyle $item]
        setdef options emphasis                -minversion 5  -validvalue {}                    -type dict|null         -trace no   -default [ticklecharts::emphasis $item]
        setdef options blur                    -minversion 5  -validvalue {}                    -type dict|null         -trace no   -default [ticklecharts::blur $item]
        setdef options select                  -minversion 5  -validvalue {}                    -type dict|null         -trace no   -default [ticklecharts::select $item]

        # remove key(s)...
        set item [dict remove $item labelLine itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::lineItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        setdef options name             -minversion 5       -validvalue {}               -type str|null    -default "nothing"
        setdef options value            -minversion 5       -validvalue {}               -type num|null    -default "nothing"
        setdef options groupId          -minversion 5       -validvalue {}               -type str|null    -default "nothing"
        setdef options childGroupId     -minversion "5.5.0" -validvalue {}               -type str|null    -default "nothing"
        setdef options symbol           -minversion 5       -validvalue formatItemSymbol -type str|null    -default "nothing"
        setdef options symbolSize       -minversion 5       -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolRotate     -minversion 5       -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolKeepAspect -minversion 5       -validvalue {}               -type bool        -default "False"
        setdef options symbolOffset     -minversion 5       -validvalue {}               -type list.n|null -default "nothing"
        setdef options label            -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine        -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle        -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis         -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip          -minversion 5       -validvalue {}               -type dict|null   -default "nothing"

        # remove key(s)...
        set item [dict remove $item label labelLine itemStyle emphasis blur]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::radarItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        setdef options name             -minversion 5       -validvalue {}               -type str|null    -default "nothing"
        setdef options value            -minversion 5       -validvalue {}               -type list.n|null -default "nothing"
        setdef options groupId          -minversion 5       -validvalue {}               -type str|null    -default "nothing"
        setdef options childGroupId     -minversion "5.5.0" -validvalue {}               -type str|null    -default "nothing"
        setdef options symbol           -minversion 5       -validvalue formatItemSymbol -type str|null    -default "nothing"
        setdef options symbolSize       -minversion 5       -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolRotate     -minversion 5       -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolKeepAspect -minversion 5       -validvalue {}               -type bool        -default "False"
        setdef options symbolOffset     -minversion 5       -validvalue {}               -type list.n|null -default "nothing"
        setdef options label            -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::label $item]
        setdef options itemStyle        -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options lineStyle        -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::lineStyle $item]
        setdef options areaStyle        -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::areaStyle $item]
        setdef options emphasis         -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::blur $item]
        setdef options select           -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::select $item]
        setdef options tooltip          -minversion 5       -validvalue {}               -type dict|null   -default "nothing"

        # remove key(s)...
        set item [dict remove $item label itemStyle lineStyle areaStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::indicatorItem {value} {

    # Both properties are supported.
    set key [ticklecharts::itemKey {-indicatoritem -indicatorItem} $value]

    if {$key eq ""} {
        set levelP [uplevel 1 {ticklecharts::getLevelProperties [info level]}]
        error "Key property '-indicatoritem' or '-indicatorItem'\
               not defined for $levelP"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item name]} {
            ticklecharts::errorKeyArgs $key name
        }

        setdef options name   -minversion 5  -validvalue {}          -type str|null          -default "nothing"
        setdef options max    -minversion 5  -validvalue {}          -type num|null          -default "nothing"
        setdef options min    -minversion 5  -validvalue {}          -type num|null          -default "nothing"
        setdef options color  -minversion 5  -validvalue formatColor -type e.color|str|null  -default "nothing"

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::pieItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        setdef options name         -minversion 5       -validvalue {} -type str|null    -default "nothing"
        setdef options value        -minversion 5       -validvalue {} -type num|null    -default "nothing"
        setdef options groupId      -minversion 5       -validvalue {} -type num|null    -default "nothing"
        setdef options childGroupId -minversion "5.5.0" -validvalue {} -type str|null    -default "nothing"
        setdef options selected     -minversion 5       -validvalue {} -type bool        -default "False"
        setdef options label        -minversion 5       -validvalue {} -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine    -minversion 5       -validvalue {} -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle    -minversion 5       -validvalue {} -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis     -minversion 5       -validvalue {} -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur         -minversion 5       -validvalue {} -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip      -minversion 5       -validvalue {} -type dict|null   -default "nothing"

        # remove key(s)...
        set item [dict remove $item label labelLine itemStyle emphasis blur]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::funnelItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
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

        # remove key(s)...
        set item [dict remove $item label labelLine itemStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::parallelItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options name           -minversion 5  -validvalue {}                  -type str|null         -default "nothing"
        setdef options value          -minversion 5  -validvalue {}                  -type list.d           -default {}
        setdef options lineStyle      -minversion 5  -validvalue {}                  -type dict|null        -default [ticklecharts::lineStyle $item]
        setdef options color          -minversion 5  -validvalue formatColor         -type e.color|str|null -default "#000"
        setdef options width          -minversion 5  -validvalue {}                  -type num              -default 2
        setdef options type           -minversion 5  -validvalue formatLineStyleType -type list.n|num|str   -default "solid"
        setdef options dashOffset     -minversion 5  -validvalue {}                  -type num|null         -default "nothing"
        setdef options cap            -minversion 5  -validvalue formatCap           -type str              -default "butt"
        setdef options join           -minversion 5  -validvalue formatJoin          -type str              -default "bevel"
        setdef options miterLimit     -minversion 5  -validvalue {}                  -type num              -default 10
        setdef options shadowBlur     -minversion 5  -validvalue {}                  -type num              -default 0
        setdef options shadowColor    -minversion 5  -validvalue formatColor         -type str|null         -default "null"
        setdef options shadowOffsetX  -minversion 5  -validvalue {}                  -type num              -default 0
        setdef options shadowOffsetY  -minversion 5  -validvalue {}                  -type num              -default 0
        setdef options opacity        -minversion 5  -validvalue {}                  -type num              -default 0.45
        setdef options emphasis       -minversion 5  -validvalue {}                  -type dict|null        -default [ticklecharts::emphasis $item]

        # remove key(s)...
        set item [dict remove $item lineStyle emphasis]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::scatterItem {value type itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        setdef options name             -minversion 5       -validvalue {}               -type str|null    -default "nothing"
        setdef options value            -minversion 5       -validvalue {}               -type list.d      -default {}
        setdef options groupId          -minversion 5       -validvalue {}               -type str|null    -default "nothing"
        setdef options childGroupId     -minversion "5.5.0" -validvalue {}               -type str|null    -default "nothing"
        setdef options symbol           -minversion 5       -validvalue formatItemSymbol -type str|null    -default "nothing"
        setdef options symbolSize       -minversion 5       -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolRotate     -minversion 5       -validvalue {}               -type num|null    -default "nothing"
        setdef options symbolKeepAspect -minversion 5       -validvalue {}               -type bool|null   -default "nothing"
        setdef options symbolOffset     -minversion 5       -validvalue {}               -type list.n|null -default "nothing"
        setdef options labelLine        -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle        -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options label            -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::label $item]
        setdef options emphasis         -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur             -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::blur $item]
        setdef options select           -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::select $item]
        setdef options tooltip          -minversion 5       -validvalue {}               -type dict|null   -default [ticklecharts::tooltip $item]

        # remove key(s)...
        if {$type eq "effectScatter"} {
            set options [dict remove $options groupId childGroupId]
        }
        set item [dict remove $item labelLine itemStyle label emphasis blur select tooltip]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::gaugeItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        setdef options name           -minversion 5  -validvalue {}  -type str|null   -default "nothing"
        setdef options value          -minversion 5  -validvalue {}  -type num        -default {}
        setdef options detail         -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::detail $item]
        setdef options title          -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::titleGauge $item]
        setdef options itemStyle      -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::itemStyle $item]

        # remove key(s)...
        set item [dict remove $item itemStyle detail title]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::dataGraphItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

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

        # remove key(s)...
        set item [dict remove $item label itemStyle lineStyle emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::candlestickItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        if {[llength {*}[dict get $item value]] != 4} {
            error "'value' property should be a list of 4 elements '\[open, close, lowest, highest\]'\
                   for [ticklecharts::getLevelProperties [info level]]."
        }

        setdef options name         -minversion 5       -validvalue {}  -type str|null    -default "nothing"
        setdef options value        -minversion 5       -validvalue {}  -type list.n|null -default "nothing"
        setdef options groupId      -minversion 5       -validvalue {}  -type str|null    -default "nothing"
        setdef options childGroupId -minversion "5.5.0" -validvalue {}  -type str|null    -default "nothing"
        setdef options itemStyle    -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis     -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur         -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options select       -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::select $item]
        setdef options tooltip      -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::tooltip $item]

        # remove key(s)...
        set item [dict remove $item itemStyle emphasis blur select tooltip]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::dataWCItem {value key} {

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $key value
        }

        setdef options name        -minversion 5  -validvalue {}   -type str|null    -default "nothing"
        setdef options value       -minversion 5  -validvalue {}   -type num|null    -default "nothing"
        setdef options textStyle   -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::textStyle $item textStyle]
        setdef options emphasis    -minversion 5  -validvalue {}   -type dict|null   -default [ticklecharts::emphasis $item]

        # remove key(s)...
        set item [dict remove $item textStyle emphasis]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::richItem {value} {

    # Both properties are supported.
    set rkey [ticklecharts::itemKey {richitem richItem} $value]

    if {$rkey eq ""} {return "nothing"}

    foreach {key item} [dict get $value $rkey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options color         -minversion 5  -validvalue formatColor             -type e.color|str|null  -default "#fff"
        setdef options fontStyle     -minversion 5  -validvalue formatFontStyle         -type str|null          -default "normal"
        setdef options fontWeight    -minversion 5  -validvalue formatFontWeight        -type str|null          -default "normal"
        setdef options fontFamily    -minversion 5  -validvalue {}                      -type str|null          -default "sans-serif"
        setdef options fontSize      -minversion 5  -validvalue {}                      -type num|null          -default 12
        setdef options align         -minversion 5  -validvalue formatTextAlign         -type str|null          -default "nothing"
        setdef options verticalAlign -minversion 5  -validvalue formatVerticalTextAlign -type str|null          -default "nothing"
        setdef options lineHeight    -minversion 5  -validvalue {}                      -type num|null          -default "nothing"

        if {[dict exists $item backgroundColor image]} {
            set val [dict get $item backgroundColor image]
            # type value (should be a string...)
            set type [ticklecharts::typeOf $val]
            # spaces in path... ??
            set val [ticklecharts::mapSpaceString $val]
            setdef options backgroundColor -minversion 5  -validvalue {} -type dict -default [new edict [dict create image [list $val $type]]]
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
        set key [ticklecharts::mapSpaceString $key]

        lappend opts $key [list [new edict [merge $options $item]] dict]
        set options {}

    }

    return [new edict $opts]
}

proc ticklecharts::boxPlotItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        if {[llength {*}[dict get $item value]] != 5} {
            error "'value' property should be a list of 5 elements: \[min,  Q1,  median (or Q2),  Q3,  max\]\
                    for [ticklecharts::getLevelProperties [info level]]"
        }

        setdef options name         -minversion 5       -validvalue {}   -type str|null    -default "nothing"
        setdef options value        -minversion 5       -validvalue {}   -type list.n      -default {}
        setdef options groupId      -minversion 5       -validvalue {}   -type str|null    -default "nothing"
        setdef options childGroupId -minversion "5.5.0" -validvalue {}   -type str|null    -default "nothing"
        setdef options itemStyle    -minversion 5       -validvalue {}   -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis     -minversion 5       -validvalue {}   -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options blur         -minversion 5       -validvalue {}   -type dict|null   -default [ticklecharts::blur $item]
        setdef options select       -minversion 5       -validvalue {}   -type dict|null   -default [ticklecharts::select $item]
        setdef options tooltip      -minversion 5       -validvalue {}   -type dict|null   -default [ticklecharts::tooltip $item]

        # remove key(s)...
        set item [dict remove $item select itemStyle emphasis blur tooltip]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::mapItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        setdef options name         -minversion 5       -validvalue {}  -type str|null    -default "nothing"
        setdef options value        -minversion 5       -validvalue {}  -type num|null    -default "nothing"
        setdef options groupId      -minversion 5       -validvalue {}  -type str|null    -default "nothing"
        setdef options childGroupId -minversion "5.5.0" -validvalue {}  -type str|null    -default "nothing"
        setdef options selected     -minversion 5       -validvalue {}  -type bool|null   -default "nothing"
        setdef options label        -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options labelLine    -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::labelLine $item]
        setdef options itemStyle    -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options emphasis     -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options tooltip      -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::tooltip $item]
        setdef options select       -minversion 5       -validvalue {}  -type dict|null   -default [ticklecharts::select $item]
        setdef options silent       -minversion "5.6.0" -validvalue {}  -type bool        -default "False"

        # remove key(s)...
        set item [dict remove $item label labelLine itemStyle emphasis tooltip select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::regionsItem {value} {

    if {![ticklecharts::keyDictExists "regions" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options name        -minversion 5        -validvalue {}  -type str|null    -default "nothing"
        setdef options selected    -minversion 5        -validvalue {}  -type bool|null   -default "nothing"
        setdef options itemStyle   -minversion 5        -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $item]
        setdef options label       -minversion 5        -validvalue {}  -type dict|null   -default [ticklecharts::label $item]
        setdef options emphasis    -minversion 5        -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $item]
        setdef options select      -minversion 5        -validvalue {}  -type dict|null   -default [ticklecharts::select $item]
        setdef options blur        -minversion "5.1.0"  -validvalue {}  -type dict|null   -default [ticklecharts::blur $item]
        setdef options tooltip     -minversion "5.1.0"  -validvalue {}  -type dict|null   -default [ticklecharts::tooltip $item]
        setdef options silent      -minversion "5.6.0"  -validvalue {}  -type bool        -default "False"

        # remove key(s)...
        set item [dict remove $item label blur itemStyle emphasis tooltip select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::linesItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item coords]} {
            ticklecharts::errorKeyArgs $itemKey coords
        }

        setdef options name         -minversion 5       -validvalue {} -type str|null     -default "nothing"
        setdef options groupId      -minversion 5       -validvalue {} -type str|null     -default "nothing"
        setdef options childGroupId -minversion "5.5.0" -validvalue {} -type str|null     -default "nothing"
        setdef options coords       -minversion 5       -validvalue {} -type list.n|null  -default "nothing"
        setdef options lineStyle    -minversion 5       -validvalue {} -type dict|null    -default [ticklecharts::lineStyle $item]
        setdef options label        -minversion 5       -validvalue {} -type dict|null    -default [ticklecharts::label $item]
        setdef options emphasis     -minversion 5       -validvalue {} -type dict|null    -default [ticklecharts::emphasis $item]
        setdef options blur         -minversion 5       -validvalue {} -type dict|null    -default [ticklecharts::blur $item]
        setdef options select       -minversion 5       -validvalue {} -type dict|null    -default [ticklecharts::select $item]

        # remove key(s)...
        set item [dict remove $item lineStyle label emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::markAreaItem {value} {

    if {![ticklecharts::keyDictExists "data" $value key]} {
        return "nothing"
    }

    foreach listitem [dict get $value $key] {

        if {[llength $listitem] != 2} {
            error "Item list should be a list of 2 elements for\
                  [ticklecharts::getLevelProperties [info level]]"
        }

        set subopts {}

        foreach item $listitem {

            if {[llength $item] % 2} ticklecharts::errorEvenArgs

            setdef options type       -minversion 5  -validvalue {} -type str|null     -default "nothing"
            setdef options valueIndex -minversion 5  -validvalue {} -type num|null     -default 0
            setdef options valueDim   -minversion 5  -validvalue {} -type str|null     -default "nothing"
            setdef options coord      -minversion 5  -validvalue {} -type list.d|null  -default "nothing"
            setdef options name       -minversion 5  -validvalue {} -type str|null     -default "nothing"
            setdef options x          -minversion 5  -validvalue {} -type num|str|null -default "nothing"
            setdef options y          -minversion 5  -validvalue {} -type num|str|null -default "nothing"
            setdef options xAxis      -minversion 5  -validvalue {} -type num|str|null -default "nothing"
            setdef options yAxis      -minversion 5  -validvalue {} -type num|str|null -default "nothing"
            setdef options value      -minversion 5  -validvalue {} -type num|null     -default "nothing"
            setdef options itemStyle  -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::itemStyle $item]
            setdef options label      -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::label $item]
            setdef options emphasis   -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::emphasis $item]
            setdef options blur       -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::blur $item]

            # remove key(s)...
            set item [dict remove $item label itemStyle emphasis blur]

            lappend subopts [merge $options $item]
            set options {}
        }

        lappend opts [list $subopts list.o]

    }

    return [list {*}$opts]
}

proc ticklecharts::piecesItem {value} {

    if {![ticklecharts::keyDictExists "pieces" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options label -minversion 5  -validvalue {}          -type str|null         -default "nothing"
        setdef options value -minversion 5  -validvalue {}          -type num|null         -default "nothing"
        setdef options color -minversion 5  -validvalue formatColor -type e.color|str|null -default "nothing"
        setdef options min   -minversion 5  -validvalue {}          -type num|null         -default "nothing"
        setdef options max   -minversion 5  -validvalue {}          -type num|null         -default "nothing"
        setdef options gt    -minversion 5  -validvalue {}          -type num|null         -default "nothing"
        setdef options gte   -minversion 5  -validvalue {}          -type num|null         -default "nothing"
        setdef options lt    -minversion 5  -validvalue {}          -type num|null         -default "nothing"
        setdef options lte   -minversion 5  -validvalue {}          -type num|null         -default "nothing"

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::markPointItem {value} {

    if {![ticklecharts::keyDictExists "data" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options name                    -minversion 5  -validvalue {}               -type str|null         -trace no   -default "nothing"
        setdef options type                    -minversion 5  -validvalue {}               -type str|null         -trace no   -default "nothing"
        setdef options valueIndex              -minversion 5  -validvalue {}               -type num|null         -trace no   -default "nothing"
        setdef options valueDim                -minversion 5  -validvalue {}               -type str|null         -trace no   -default "nothing"
        setdef options coord                   -minversion 5  -validvalue {}               -type list.d|null      -trace no   -default "nothing"
        setdef options xAxis                   -minversion 5  -validvalue {}               -type num|null         -trace no   -default "nothing"
        setdef options yAxis                   -minversion 5  -validvalue {}               -type num|null         -trace no   -default "nothing"
        setdef options value                   -minversion 5  -validvalue {}               -type num|null         -trace no   -default "nothing"
        setdef options symbol                  -minversion 5  -validvalue formatItemSymbol -type str|null         -trace no   -default "nothing"
        setdef options symbolSize              -minversion 5  -validvalue {}               -type num|list.n|null  -trace no   -default "nothing"
        setdef options itemStyle               -minversion 5  -validvalue {}               -type dict|null        -trace no   -default [ticklecharts::itemStyle $item]
        setdef options label                   -minversion 5  -validvalue {}               -type dict|null        -trace no   -default [ticklecharts::label $item]
        setdef options emphasis                -minversion 5  -validvalue {}               -type dict|null        -trace no   -default [ticklecharts::emphasis $item]
        setdef options animation               -minversion 5  -validvalue {}               -type bool|null        -trace yes  -default "nothing"
        setdef options animationThreshold      -minversion 5  -validvalue {}               -type num|null         -trace no   -default "nothing"
        setdef options animationDuration       -minversion 5  -validvalue {}               -type num|jsfunc|null  -trace no   -default "nothing"
        setdef options animationEasing         -minversion 5  -validvalue formatAEasing    -type str|null         -trace no   -default "nothing"
        setdef options animationDelay          -minversion 5  -validvalue {}               -type num|jsfunc|null  -trace no   -default "nothing"
        setdef options animationDurationUpdate -minversion 5  -validvalue {}               -type num|jsfunc|null  -trace no   -default "nothing"
        setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing    -type str|null         -trace no   -default "nothing"
        setdef options animationDelayUpdate    -minversion 5  -validvalue {}               -type num|jsfunc|null  -trace no   -default "nothing"

        # remove key(s)...
        set item [dict remove $item itemStyle label emphasis]

        lappend opts [merge $options $item]
        set options {}
    }

    return [list {*}$opts]
}

proc ticklecharts::linkAxisPointerItem {value} {

    if {![ticklecharts::keyDictExists "link" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

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

proc ticklecharts::axisItem {value itemKey} {

    foreach item [dict get $value $itemKey] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        if {![dict exists $item value]} {
            ticklecharts::errorKeyArgs $itemKey value
        }

        setdef options value      -minversion 5  -validvalue {}  -type str|null    -default "nothing"
        setdef options textStyle  -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::textStyle $item textStyle]

        # remove key(s)...
        set item [dict remove $item textStyle]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::dataBackground {value} {

    if {![ticklecharts::keyDictExists "dataBackground" $value key]} {
        return "nothing"
    }
    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options lineStyle -minversion 5  -validvalue {}  -type dict|null -default [ticklecharts::lineStyle $d]
    setdef options areaStyle -minversion 5  -validvalue {}  -type dict|null -default [ticklecharts::areaStyle $d]

    # remove key(s)...
    set d [dict remove $d lineStyle areaStyle]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::selectedDataBackground {value} {

    if {![ticklecharts::keyDictExists "selectedDataBackground" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options lineStyle -minversion 5  -validvalue {}  -type dict|null -default [ticklecharts::lineStyle $d]
    setdef options areaStyle -minversion 5  -validvalue {}  -type dict|null -default [ticklecharts::areaStyle $d]

    # remove key(s)...
    set d [dict remove $d lineStyle areaStyle]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::itemStyle {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "itemStyle" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "itemStyle"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    set color [expr {[keysOptsThemeExists $levelP.color] ? [echartsOptsTheme $levelP.color] : "nothing"}]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options color            -minversion 5  -validvalue formatColor         -type e.color|str.t|jsfunc|null -trace no   -default $color
    setdef options borderColor      -minversion 5  -validvalue formatColor         -type e.color|str|null          -trace no   -default "rgb(0, 0, 0)"
    setdef options borderWidth      -minversion 5  -validvalue {}                  -type num|null                  -trace no   -default "nothing"
    setdef options borderType       -minversion 5  -validvalue formatBorderType    -type str|num|list.n            -trace no   -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}                  -type num|null                  -trace no   -default 0
    setdef options borderCap        -minversion 5  -validvalue formatCap           -type str                       -trace no   -default "butt"
    setdef options borderJoin       -minversion 5  -validvalue formatJoin          -type str                       -trace yes  -default "bevel"
    setdef options borderMiterLimit -minversion 5  -validvalue {}                  -type num|null                  -trace yes  -default "nothing"
    setdef options shadowBlur       -minversion 5  -validvalue {}                  -type num|null                  -trace no   -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor         -type str|null                  -trace no   -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}                  -type num|null                  -trace no   -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}                  -type num|null                  -trace no   -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity       -type num|null                  -trace no   -default 1
    setdef options decal            -minversion 5  -validvalue {}                  -type dict|null                 -trace no   -default [ticklecharts::decal $d]
    #...

    if {[infoNameProc $levelP "legend.itemStyle"]} {
        setdef options color            -minversion 5  -validvalue formatColor   -type e.color|str|jsfunc|null -trace no  -default "inherit"
        setdef options borderColor      -minversion 5  -validvalue formatColor   -type e.color|str|null        -trace no  -default "inherit"
        setdef options borderWidth      -minversion 5  -validvalue {}            -type str|num|null            -trace no  -default "auto"
        setdef options borderDashOffset -minversion 5  -validvalue {}            -type str|num|null            -trace no  -default "inherit"
        setdef options borderCap        -minversion 5  -validvalue formatCap     -type str                     -trace no  -default "inherit"
        setdef options borderJoin       -minversion 5  -validvalue formatJoin    -type str                     -trace no  -default "inherit"
        setdef options borderMiterLimit -minversion 5  -validvalue {}            -type num|str                 -trace no  -default "inherit"
        setdef options opacity          -minversion 5  -validvalue formatOpacity -type str|num|null            -trace no  -default "inherit"
    }

    switch -exact -- [ticklecharts::whichSeries? $levelP] {
        "pieSeries" - "sunburstSeries" {
            setdef options borderColor  -minversion 5  -validvalue formatColor   -type e.color|str|null    -trace no -default "nothing"
            setdef options borderRadius -minversion 5  -validvalue formatBRadius -type str|num|list.d|null -trace no -default "nothing"
        }
        "treeSeries" {
            setdef options borderColor  -minversion 5  -validvalue formatColor   -type e.color|str|null -trace no  -default "#c23531"
            setdef options borderWidth  -minversion 5  -validvalue {}            -type str|num|null     -trace no  -default 1.5
        }
        "sankeySeries" {
            setdef options borderColor  -minversion 5        -validvalue formatColor  -type e.color|str|null -trace no  -default "inherit"
            setdef options borderRadius -minversion "5.5.1"  -validvalue {}           -type list.n|null      -trace no  -default "nothing"
        }
        "barSeries" {
            setdef options borderRadius -minversion 5  -validvalue {} -type num|list.n|null -trace no   -default "nothing"

            if {([dict exists $value -coordinateSystem] && [dict get $value -coordinateSystem] eq "polar") ||
                ([ticklecharts::procDefaultValue "barSeries" "-coordinateSystem"] eq "polar")} {
                setdef options borderRadius -minversion "5.4.2" -validvalue {} -type num|list.n|null -trace no  -default "nothing"
            }
        }
        "heatmapSeries" {
            setdef options borderRadius -minversion "5.3.1" -validvalue {}  -type num|list.n|null -trace no  -default "nothing"
        }
    }

    if {[infoNameProc $levelP "timelineOpts.*"]} {
        setdef options color           -minversion 5  -validvalue formatColor   -type e.color|str.t|null  -trace no  -default $color
        setdef options borderColor     -minversion 5  -validvalue formatColor   -type e.color|str|null    -trace no  -default "nothing"
    }

    if {[infoNameProc $levelP "gaugeSeries.anchor.*"]} {
        # gauge series...
        setdef options borderColor   -minversion 5  -validvalue formatColor  -type e.color|str|null  -trace no  -default "nothing"
    }

    if {[infoNameProc $levelP "treemapSeries.levelsTreeMapItem.*"]} {
        setdef options borderColor            -minversion 5  -validvalue formatColor -type e.color|str|null     -trace no  -default "nothing"
        setdef options borderRadius           -minversion 5  -validvalue {}          -type str|num|list.d|null  -trace no  -default "nothing"
        setdef options gapWidth               -minversion 5  -validvalue {}          -type num|null             -trace no  -default "nothing"
        setdef options borderColorSaturation  -minversion 5  -validvalue {}          -type num|null             -trace no  -default "nothing"
    }

    if {[infoNameProc $levelP "candlestickSeries.itemStyle"]} {
        set color0       [expr {[keysOptsThemeExists $levelP.color0]       ? [echartsOptsTheme $levelP.color0] : "nothing"}]
        set borderColor0 [expr {[keysOptsThemeExists $levelP.borderColor0] ? [echartsOptsTheme $levelP.borderColor0] : "nothing"}]

        setdef options color0           -minversion 5       -validvalue formatColor   -type e.color|str.t|null  -trace no  -default $color0
        setdef options borderColor0     -minversion 5       -validvalue formatColor   -type e.color|str.t|null  -trace no  -default $borderColor0
        setdef options borderColorDoji  -minversion "5.4.1" -validvalue formatColor   -type e.color|str|null    -trace no  -default "nothing"
    }

    if {[infoNameProc $levelP "candlestickSeries.select.itemStyle"]} {
        setdef options color0           -minversion "5.6.0"  -validvalue formatColor   -type e.color|str|null  -trace no  -default "nothing"
        setdef options borderColor0     -minversion "5.6.0"  -validvalue formatColor   -type e.color|str|null  -trace no  -default "nothing"
        setdef options borderColorDoji  -minversion "5.6.0"  -validvalue formatColor   -type e.color|str|null  -trace no  -default "nothing"
    }

    # remove key(s)...
    set d [dict remove $d decal]

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::emphasis {value} {

    if {![ticklecharts::keyDictExists "emphasis" $value key]} {
        return "nothing"
    }

    set levelP [ticklecharts::getLevelProperties [info level]]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    if {[infoNameProc $levelP "legend.emphasis"]} {
        setdef options selectorLabel  -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::selectorLabel $d]
        #...
    } elseif {[infoNameProc $levelP "*.markPoint*"] || [infoNameProc $levelP "*.markLine*"] || [infoNameProc $levelP "*.markArea*"]} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}  -type bool|null  -default "nothing"
        setdef options label      -minversion 5             -validvalue {}  -type dict|null  -default [ticklecharts::label     $d]
        setdef options itemStyle  -minversion 5             -validvalue {}  -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "treemapSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion "5.1.0"       -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        setdef options labelLine  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::labelLine $d]
        setdef options upperLabel -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::upperLabel $d]
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "barSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion "5.1.0"       -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        setdef options labelLine  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::labelLine $d]
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "pieSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options scale      -minversion 5             -validvalue {}              -type bool|null  -default "True"
        setdef options scaleSize  -minversion 5             -validvalue {}              -type num|null   -default "nothing"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        setdef options labelLine  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::labelLine $d]
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "scatterSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null               -default "nothing"
        setdef options scale      -minversion "5.0.0:5.3.2" -validvalue {}              -type bool|null:bool|num|null -default "True"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null                -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null                -default "coordinateSystem"
        setdef options label      -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::label     $d]
        setdef options labelLine  -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::labelLine $d]
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "radarSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        setdef options lineStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::lineStyle $d]
        setdef options areaStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::areaStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "treeSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        setdef options lineStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::lineStyle $d]
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "treeMapSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        setdef options labelLine  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::labelLine $d]
        setdef options upperLabel -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::upperLabel $d]
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "sunburstSeries"} {
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        setdef options labelLine  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::labelLine $d]
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] in {"boxPlotSeries" "candlestickSeries"}} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "heatmapSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "mapSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}  -type bool|null  -default "nothing"
        setdef options label      -minversion 5             -validvalue {}  -type dict|null  -default [ticklecharts::label     $d]
        setdef options itemStyle  -minversion 5             -validvalue {}  -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "parallelSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}  -type bool|null  -default "nothing"
        setdef options lineStyle  -minversion 5             -validvalue {}  -type dict|null  -default [ticklecharts::lineStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "linesSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options lineStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::lineStyle $d]
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "graphSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null               -default "nothing"
        setdef options scale      -minversion "5.0.0:5.3.2" -validvalue {}              -type bool|null:bool|num|null -default "True"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null                -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null                -default "coordinateSystem"
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::itemStyle $d]
        setdef options lineStyle  -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::lineStyle $d]
        setdef options label      -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::label     $d]
        setdef options edgeLabel  -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::edgeLabel $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "sankeySeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null  -default "nothing"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null   -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null   -default "coordinateSystem"
        setdef options label      -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::label     $d]
        setdef options edgeLabel  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::edgeLabel $d]
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::itemStyle $d]
        setdef options lineStyle  -minversion 5             -validvalue {}              -type dict|null  -default [ticklecharts::lineStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] in {"funnelSeries" "pictorialBarSeries" "themeRiverSeries"}} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}              -type bool|null               -default "nothing"
        setdef options scale      -minversion "5.0.0:5.3.2" -validvalue {}              -type bool|null:bool|num|null -default "True"
        setdef options focus      -minversion 5             -validvalue formatFocus     -type str|null                -default "none"
        setdef options blurScope  -minversion 5             -validvalue formatBlurScope -type str|null                -default "coordinateSystem"
        setdef options label      -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::label     $d]
        setdef options labelLine  -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::labelLine $d]
        setdef options itemStyle  -minversion 5             -validvalue {}              -type dict|null               -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "gaugeSeries"} {
        setdef options disabled   -minversion "5.3.0"       -validvalue {}  -type bool|null  -default "nothing"
        setdef options itemStyle  -minversion 5             -validvalue {}  -type dict|null  -default [ticklecharts::itemStyle $d]
        #...
    } else {
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
    }

    # remove key(s)...
    set d [dict remove $d label labelLine itemStyle \
                          lineStyle areaStyle endLabel \
                          selectorLabel upperLabel edgeLabel]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::markPoint {value} {

    if {![ticklecharts::keyDictExists "-markPoint" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str         -default "pin"
    setdef options symbolSize       -minversion 5  -validvalue {}               -type num|list.n  -default 50
    setdef options symbolRotate     -minversion 5  -validvalue {}               -type num|null    -default "nothing"
    setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool        -default "False"
    setdef options symbolOffset     -minversion 5  -validvalue {}               -type list.d|null -default "nothing"
    setdef options silent           -minversion 5  -validvalue {}               -type bool        -default "False"
    setdef options label            -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::label $d]
    setdef options itemStyle        -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::itemStyle $d]
    setdef options emphasis         -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::emphasis $d]
    setdef options blur             -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::blur $d]
    setdef options data             -minversion 5  -validvalue {}               -type list.o|null -default [ticklecharts::markPointItem $d]
    #...

    # remove key(s)...
    set d [dict remove $d data blur label itemStyle emphasis]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::blur {value} {

    if {![ticklecharts::keyDictExists "blur" $value key]} {
        return "nothing"
    }

    set levelP [ticklecharts::getLevelProperties [info level]]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    if {[infoNameProc $levelP "*.markPoint*"] || [infoNameProc $levelP "*.markArea*"] || [infoNameProc $levelP "geo.blur"]} {
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[infoNameProc $levelP "*.markLine*"]} {
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] in {
        "barSeries" "pieSeries" "scatterSeries" "sunburstSeries" "funnelSeries" "pictorialBarSeries" "themeRiverSeries"
        }} {
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        setdef options labelLine -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::labelLine $d]
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "radarSeries"} {
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
        setdef options areaStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::areaStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "treeSeries"} {
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "treemapSeries"} {
        setdef options label      -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        setdef options labelLine  -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::labelLine $d]
        setdef options upperLabel -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::upperLabel $d]
        setdef options itemStyle  -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] in {"boxplotSeries" "candlestickSeries"}} {
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "heatmapSeries"} {
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] eq "linesSeries"} {
        setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        #...
    } elseif {[ticklecharts::whichSeries? $levelP] in {"graphSeries" "sankeySeries"}} {
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        setdef options edgeLabel -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::edgeLabel $d]
        #...
    } else {
        setdef options label     -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::label $d]
        setdef options labelLine -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::labelLine $d]
        setdef options itemStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
        setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
        setdef options areaStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::areaStyle $d]
        setdef options endLabel  -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::endLabel  $d]
        #...
    }

    # remove key(s)...
    set d [dict remove $d label labelLine itemStyle lineStyle areaStyle endLabel upperLabel edgeLabel]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::select {value} {

    if {![ticklecharts::keyDictExists "select" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options disabled  -minversion "5.3.0" -validvalue {} -type bool|null -default "nothing"
    setdef options label     -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::label     $d]
    setdef options labelLine -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::labelLine $d]
    setdef options itemStyle -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::itemStyle $d]
    setdef options lineStyle -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]
    setdef options areaStyle -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::areaStyle $d]
    setdef options endLabel  -minversion 5       -validvalue {} -type dict|null -default [ticklecharts::endLabel  $d]
    #...

    # remove key(s)...
    set d [dict remove $d label labelLine itemStyle lineStyle areaStyle endLabel]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::decal {value} {

    if {![ticklecharts::keyDictExists "decal" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str                -default "rect"
    setdef options symbolSize       -minversion 5  -validvalue {}               -type num                -default 1
    setdef options symbolKeepAspect -minversion 5  -validvalue {}               -type bool               -default "True"
    setdef options color            -minversion 5  -validvalue formatColor      -type e.color|str|jsfunc -default "rgba(0, 0, 0, 0.2)"
    setdef options backgroundColor  -minversion 5  -validvalue formatColor      -type str|null           -default "nothing"
    setdef options dashArrayX       -minversion 5  -validvalue {}               -type num                -default 5
    setdef options dashArrayY       -minversion 5  -validvalue {}               -type num                -default 5
    setdef options rotation         -minversion 5  -validvalue {}               -type num                -default 0
    setdef options maxTileWidth     -minversion 5  -validvalue {}               -type num                -default 512
    setdef options maxTileHeight    -minversion 5  -validvalue {}               -type num                -default 512
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::childrenElements {value key} {

    if {![dict exists $value $key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {![dict exists $item type]} {
            error "'type' for '$key' should be specified for\
                   [ticklecharts::getLevelProperties [info level]]"
        }

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

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

            default {
                error "Wrong 'type' or not supported for this '$typegraphic' in\
                      [ticklecharts::getLevelProperties [info level]]"
            }
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

        # remove key(s)...
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

    # Gets key value.
    set d [ticklecharts::getValue $value "shape"]

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
        default {
            error "Wrong shape 'type' or not supported for this '$type' in\
                  [ticklecharts::getLevelProperties [info level]]"
        }
    }

    setdef options transition -minversion 5  -validvalue {} -type list.s|str|null -default "nothing"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::style {value type} {

    if {![dict exists $value style]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "style"]

    if {[dict exists $d $type]} {
        # spaces in path... ??
        dict set d $type [ticklecharts::mapSpaceString [dict get $d $type]]
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

    return [new edict $options]
}

proc ticklecharts::textConfig {value} {

    if {![dict exists $value textConfig]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "textConfig"]

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
    setdef options layoutRect    -minversion 5  -validvalue {}             -type dict|null   -default [ticklecharts::layoutRect $d]
    setdef options offset        -minversion 5  -validvalue {}             -type list.d|null -default "nothing"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::layoutRect {value} {

    if {![dict exists $value layoutRect]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "layoutRect"]

    setdef options x       -minversion 5  -validvalue {}  -type num|null -default "nothing"
    setdef options y       -minversion 5  -validvalue {}  -type num|null -default "nothing"
    setdef options width   -minversion 5  -validvalue {}  -type num|null -default "nothing"
    setdef options height  -minversion 5  -validvalue {}  -type num|null -default "nothing"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::keyframeAnimation {value type} {

    if {![ticklecharts::keyDictExists "keyframeAnimation" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options duration  -minversion 5  -validvalue {}            -type num|null    -default "nothing"
        setdef options easing    -minversion 5  -validvalue formatAEasing -type str|null    -default "nothing"
        setdef options delay     -minversion 5  -validvalue {}            -type num|null    -default "nothing"
        setdef options loop      -minversion 5  -validvalue {}            -type bool        -default "False"
        setdef options keyframes -minversion 5  -validvalue {}            -type list.o|null -default [ticklecharts::keyframes $item $type]

        # remove key(s)...
        set item [dict remove $item keyframes]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::keyframes {value type} {

    if {![ticklecharts::keyDictExists "keyframes" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options percent -minversion 5  -validvalue {}            -type num|null  -default "nothing"
        setdef options easing  -minversion 5  -validvalue formatAEasing -type str|null  -default "nothing"
        setdef options scaleX  -minversion 5  -validvalue {}            -type num|null  -default "nothing"
        setdef options scaleY  -minversion 5  -validvalue {}            -type num|null  -default "nothing"
        setdef options style   -minversion 5  -validvalue {}            -type dict|null -default [ticklecharts::style $item $type]

        # remove key(s)...
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

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options x     -minversion 5  -validvalue {} -type num|null  -default 0
    setdef options style -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::propertiesStyle $d]

    # remove key(s)...
    set d [dict remove $d style]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::propertiesStyle {value} {

    if {![dict exists $value style]} {
        return "nothing"
    }
    # Gets key value.
    set d [ticklecharts::getValue $value "style"]

    setdef options opacity -minversion 5  -validvalue {} -type num|null -default 0

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::typeAnimation {value key} {

    if {![dict exists $value $key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options duration -minversion 5  -validvalue {}            -type num|null -default "nothing"
    setdef options easing   -minversion 5  -validvalue formatAEasing -type str|null -default "nothing"
    setdef options delay    -minversion 5  -validvalue {}            -type num|null -default "nothing"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::splitLine {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "splitLine" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "splitLine"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    set showgrid [expr {[keysOptsThemeExists $levelP.show] ? [echartsOptsTheme $levelP.show] : "True"}]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show            -minversion 5  -validvalue {}               -type bool.t          -default $showgrid
    setdef options onZero          -minversion 5  -validvalue {}               -type bool            -default "True"
    setdef options onZeroAxisIndex -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options symbol          -minversion 5  -validvalue formatItemSymbol -type str|list.s|null -default "null"
    setdef options symbolSize      -minversion 5  -validvalue {}               -type list.n|null     -default "nothing"
    setdef options symbolOffset    -minversion 5  -validvalue {}               -type list.n|num|null -default "nothing"
    setdef options lineStyle       -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::lineStyle $d]

    if {[ticklecharts::whichSeries? $levelP] eq "gaugeSeries"} {
        # add 'length' property to series-gauge.splitLine
        setdef options length    -minversion 5  -validvalue {} -type num|null -default "nothing"
        setdef options distance  -minversion 5  -validvalue {} -type num|null -default "nothing"
    }

    if {[infoNameProc $levelP "xAxis.splitLine"] || [infoNameProc $levelP "radiusAxis.splitLine"] || [infoNameProc $levelP "angleAxis.splitLine"] ||
        [infoNameProc $levelP "radarCoordinate.splitLine"] || [infoNameProc $levelP "singleAxis.splitLine"] || [infoNameProc $levelP "yAxis.splitLine"]
    } {
        setdef options showMinLine   -minversion "5.6.0"  -validvalue {}  -type bool  -default "True"
        setdef options showMaxLine   -minversion "5.6.0"  -validvalue {}  -type bool  -default "True"
    }

    # remove key(s)...
    set d [dict remove $d lineStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::universalTransition {value} {

    if {![dict exists $value -universalTransition]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "-universalTransition"]

    setdef options enabled     -minversion 5  -validvalue {}                -type bool            -default "False"
    setdef options seriesKey   -minversion 5  -validvalue {}                -type str|list.d|null -default "nothing"
    setdef options divideShape -minversion 5  -validvalue formatDivideShape -type str|null        -default "nothing"
    setdef options delay       -minversion 5  -validvalue {}                -type jsfunc|null     -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::minorSplitLine {value} {

    if {![ticklecharts::keyDictExists "-minorSplitLine" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show      -minversion 5  -validvalue {} -type bool      -default "False"
    setdef options lineStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]

    # remove key(s)...
    set d [dict remove $d lineStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::splitArea {value} {

    if {![ticklecharts::keyDictExists "-splitArea" $value key]} {
        return "nothing"
    }
    
    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options interval  -minversion 5  -validvalue {} -type num       -default 0
    setdef options show      -minversion 5  -validvalue {} -type bool      -default "False"
    setdef options areaStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::areaStyle $d]

    # remove key(s)...
    set d [dict remove $d areaStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::areaStyle {value} {

    if {![ticklecharts::keyDictExists "areaStyle" $value key]} {
        return "nothing"
    }

    set levelP [ticklecharts::getLevelProperties [info level]]

    set color   [expr {[keysOptsThemeExists $levelP.color] ? [echartsOptsTheme $levelP.color] : "null"}]
    set opacity [expr {[keysOptsThemeExists $levelP.opacity] ? [echartsOptsTheme $levelP.opacity] : 0.5}]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options color         -minversion 5             -validvalue formatColor           -type e.color|list.st|str.t|jsfunc|null -default $color
    setdef options origin        -minversion "5.0.0:5.3.2" -validvalue formatAreaStyleOrigin -type str|null:str|num|null             -default "nothing"
    setdef options shadowBlur    -minversion 5             -validvalue {}                    -type num                               -default 0
    setdef options shadowColor   -minversion 5             -validvalue formatColor           -type str|null                          -default "nothing"
    setdef options shadowOffsetX -minversion 5             -validvalue {}                    -type num                               -default 0
    setdef options shadowOffsetY -minversion 5             -validvalue {}                    -type num                               -default 0
    setdef options opacity       -minversion 5             -validvalue formatOpacity         -type num.t                             -default $opacity
    #...

    set options [merge $options $d]

    return [new edict $options]
}


proc ticklecharts::axisLine {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "axisLine" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "axisLine"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    set show [expr {[keysOptsThemeExists $levelP.show] ? [echartsOptsTheme $levelP.show] : "True"}]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show            -minversion 5  -validvalue {}               -type bool.t          -trace no  -default $show
    setdef options onZero          -minversion 5  -validvalue {}               -type bool            -trace yes -default "True"
    setdef options onZeroAxisIndex -minversion 5  -validvalue {}               -type num|null        -trace no  -default "nothing"
    setdef options symbol          -minversion 5  -validvalue formatItemSymbol -type str|list.s|null -trace no  -default "null"
    setdef options symbolSize      -minversion 5  -validvalue {}               -type list.n|null     -trace no  -default "nothing"
    setdef options symbolOffset    -minversion 5  -validvalue {}               -type list.n|num|null -trace no  -default "nothing"
    setdef options lineStyle       -minversion 5  -validvalue {}               -type dict|null       -trace no  -default [ticklecharts::lineStyle $d]

    if {[ticklecharts::whichSeries? $levelP] eq "gaugeSeries"} {
        setdef options show      -minversion 5  -validvalue {} -type bool -trace no -default "True"
        setdef options roundCap  -minversion 5  -validvalue {} -type bool -trace no -default "False"
        # remove flag from dict options... not defined in series-gauge.axisLine
        set options [dict remove $options onZero onZeroAxisIndex symbol symbolSize symbolOffset]
    }

    # remove key(s)...
    set d [dict remove $d lineStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::markLine {value} {

    if {![ticklecharts::keyDictExists "markLine" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options silent                  -minversion 5  -validvalue {}               -type bool              -trace no   -default "False"
    setdef options symbol                  -minversion 5  -validvalue formatItemSymbol -type str|list.s|null   -trace no   -default "nothing"
    setdef options symbolSize              -minversion 5  -validvalue {}               -type list.n|null       -trace no   -default "nothing"
    setdef options precision               -minversion 5  -validvalue {}               -type num|null          -trace no   -default 2
    setdef options label                   -minversion 5  -validvalue {}               -type dict|null         -trace no   -default [ticklecharts::label $d]
    setdef options lineStyle               -minversion 5  -validvalue {}               -type dict|null         -trace no   -default [ticklecharts::lineStyle $d]
    setdef options emphasis                -minversion 5  -validvalue {}               -type dict|null         -trace no   -default [ticklecharts::emphasis $d]
    setdef options blur                    -minversion 5  -validvalue {}               -type dict|null         -trace no   -default [ticklecharts::blur $d]
    setdef options data                    -minversion 5  -validvalue {}               -type list.o|null       -trace no   -default [ticklecharts::markLineItem $d]
    setdef options animation               -minversion 5  -validvalue {}               -type bool|null         -trace yes  -default "nothing"
    setdef options animationThreshold      -minversion 5  -validvalue {}               -type num|null          -trace no   -default "nothing"
    setdef options animationDuration       -minversion 5  -validvalue {}               -type num|jsfunc|null   -trace no   -default "nothing"
    setdef options animationEasing         -minversion 5  -validvalue formatAEasing    -type str|null          -trace no   -default "nothing"
    setdef options animationDelay          -minversion 5  -validvalue {}               -type num|jsfunc|null   -trace no   -default "nothing"
    setdef options animationDurationUpdate -minversion 5  -validvalue {}               -type num|jsfunc|null   -trace no   -default "nothing"
    setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing    -type str|null          -trace no   -default "nothing"
    setdef options animationDelayUpdate    -minversion 5  -validvalue {}               -type num|jsfunc|null   -trace no   -default "nothing"

    # remove key(s)...
    set d [dict remove $d data label lineStyle emphasis blur]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::markLineItem {value} {

    if {![dict exists $value data]} {
        return "nothing"
    }

    foreach {key info} [dict get $value data] {

        if {$info eq ""} {
            error "Key $key should be associated with a value for\
                   [ticklecharts::getLevelProperties [info level]]"
        }

        switch -exact -- $key {
            lineItem {

                if {[llength $info] != 2} {
                    error "Should be a list of 2, 'startpoint' and 'endpoint' for\
                          [ticklecharts::getLevelProperties [info level]]"
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

                # remove key(s)...
                set info [dict remove $info lineStyle label emphasis blur]

                lappend opts [merge $options $info]

            }
            default {
                error "Key must be 'lineItem' or 'objectItem' for\
                      [ticklecharts::getLevelProperties [info level]]"
            }
        }

    }

    return [list {*}$opts]
}

proc ticklecharts::labelLine {value} {

    if {![ticklecharts::keyDictExists "labelLine" $value key]} {
        return "nothing"
    }

    set levelP [ticklecharts::getLevelProperties [info level]]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show         -minversion 5  -validvalue {} -type bool          -default "True"
    setdef options showAbove    -minversion 5  -validvalue {} -type bool|null     -default "nothing"
    setdef options length2      -minversion 5  -validvalue {} -type num|null      -default "nothing"
    setdef options smooth       -minversion 5  -validvalue {} -type bool|num|null -default "nothing"
    setdef options minTurnAngle -minversion 5  -validvalue {} -type num|null      -default "nothing"
    setdef options lineStyle    -minversion 5  -validvalue {} -type dict|null     -default [ticklecharts::lineStyle $d]
    #...

    switch -exact -- [ticklecharts::whichSeries? $levelP] {
        "pieSeries" {
            setdef options length           -minversion 5  -validvalue {} -type num|null  -default "nothing"
            setdef options maxSurfaceAngle  -minversion 5  -validvalue {} -type num|null  -default "nothing"
        }
        "funnelSeries" {
            setdef options length -minversion 5  -validvalue {} -type num|null  -default "nothing"
        }
    }

    # remove key(s)...
    set d [dict remove $d lineStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::labelLayout {value} {

    if {![ticklecharts::keyDictExists "-labelLayout" $value key]} {
        return "nothing"
    }

    if {[ticklecharts::typeOf [dict get $value $key]] eq "jsfunc"} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

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

    return [new edict $options]
}

proc ticklecharts::axisTick {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "axisTick" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "axisTick"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    set show [expr {[keysOptsThemeExists $levelP.show] ? [echartsOptsTheme $levelP.show] : "True"}]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show            -minversion 5        -validvalue {}             -type bool.t         -default $show
    setdef options alignWithLabel  -minversion 5        -validvalue {}             -type bool|null      -default "nothing"
    setdef options inside          -minversion 5        -validvalue {}             -type bool|null      -default "nothing"
    setdef options interval        -minversion 5        -validvalue formatInterval -type str|num|jsfunc -default "auto"
    setdef options length          -minversion 5        -validvalue {}             -type num            -default 5
    setdef options lineStyle       -minversion 5        -validvalue {}             -type dict|null      -default [ticklecharts::lineStyle $d]
    setdef options customValues    -minversion "5.5.1"  -validvalue {}             -type list.d|null    -default "nothing"

    if {[ticklecharts::whichSeries? $levelP] eq "gaugeSeries"} {
        # add 'distance' property to series-gauge.axisTick
        setdef options splitNumber  -minversion 5  -validvalue {} -type num|null -default "nothing"
        setdef options distance     -minversion 5  -validvalue {} -type num|null -default "nothing"
    }

    # remove key(s)...
    set d [dict remove $d lineStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::minorTick {value} {

    if {![ticklecharts::keyDictExists "minorTick" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show        -minversion 5  -validvalue {} -type bool      -default "False"
    setdef options splitNumber -minversion 5  -validvalue {} -type num       -default 5
    setdef options length      -minversion 5  -validvalue {} -type num       -default 3
    setdef options lineStyle   -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::lineStyle $d]

    # remove key(s)...
    set d [dict remove $d lineStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::axisLabel {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "axisLabel" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "axisLabel"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    set color [expr {[keysOptsThemeExists $levelP.color] ? [echartsOptsTheme $levelP.color] : "nothing"}]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5       -validvalue {}                      -type bool               -default "True"
    setdef options interval             -minversion 5       -validvalue formatInterval          -type num|str|jsfunc     -default "auto"
    setdef options inside               -minversion 5       -validvalue {}                      -type bool               -default "False"
    setdef options rotate               -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options margin               -minversion 5       -validvalue {}                      -type num                -default 8
    setdef options formatter            -minversion 5       -validvalue {}                      -type str|jsfunc|null    -default "nothing"
    setdef options showMinLabel         -minversion 5       -validvalue {}                      -type bool|null          -default "null"
    setdef options showMaxLabel         -minversion 5       -validvalue {}                      -type bool|null          -default "null"
    setdef options hideOverlap          -minversion "5.2.0" -validvalue {}                      -type bool               -default "False"
    setdef options color                -minversion 5       -validvalue formatColor             -type e.color|str.t|null -default $color
    setdef options fontStyle            -minversion 5       -validvalue formatFontStyle         -type str                -default "normal"
    setdef options fontWeight           -minversion 5       -validvalue formatFontWeight        -type str|num            -default "normal"
    setdef options fontFamily           -minversion 5       -validvalue {}                      -type str                -default "sans-serif"
    setdef options fontSize             -minversion 5       -validvalue {}                      -type num                -default 12
    setdef options align                -minversion 5       -validvalue formatTextAlign         -type str|null           -default "nothing"
    setdef options verticalAlign        -minversion 5       -validvalue formatVerticalTextAlign -type str|null           -default "nothing"
    setdef options lineHeight           -minversion 5       -validvalue {}                      -type num                -default 12
    setdef options backgroundColor      -minversion 5       -validvalue formatColor             -type e.color|str        -default "transparent"
    setdef options borderColor          -minversion 5       -validvalue formatColor             -type str|null           -default "nothing"
    setdef options borderWidth          -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options borderType           -minversion 5       -validvalue formatBorderType        -type str|num|list.n     -default "solid"
    setdef options borderDashOffset     -minversion 5       -validvalue {}                      -type num|null           -default 0
    setdef options borderRadius         -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options padding              -minversion 5       -validvalue {}                      -type num|list.n         -default 0
    setdef options shadowColor          -minversion 5       -validvalue formatColor             -type str                -default "transparent"
    setdef options shadowBlur           -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options shadowOffsetX        -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options shadowOffsetY        -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options width                -minversion 5       -validvalue {}                      -type num|null           -default "nothing"
    setdef options height               -minversion 5       -validvalue {}                      -type num|null           -default "nothing"
    setdef options textBorderColor      -minversion 5       -validvalue formatColor             -type str|null           -default "null"
    setdef options textBorderWidth      -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options textBorderType       -minversion 5       -validvalue formatTextBorderType    -type str|num|list.n     -default "solid"
    setdef options textBorderDashOffset -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options textShadowColor      -minversion 5       -validvalue formatColor             -type str                -default "transparent"
    setdef options textShadowBlur       -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options textShadowOffsetX    -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options textShadowOffsetY    -minversion 5       -validvalue {}                      -type num                -default 0
    setdef options overflow             -minversion 5       -validvalue formatOverflow          -type str                -default "truncate"
    setdef options ellipsis             -minversion 5       -validvalue {}                      -type str                -default "..."
    #...

    if {[ticklecharts::whichSeries? $levelP] eq "gaugeSeries"} {
        # add 'distance' property to series-gauge.axisLabel
        setdef options rotate    -minversion "5.4.0" -validvalue formatGaugeALrotate -type str|num  -default 0
        setdef options distance  -minversion 5       -validvalue {}                  -type num|null -default "nothing"
    }

    if {[infoNameProc $levelP "xAxis.axisLabel"]} {
        setdef options alignMinLabel -minversion "5.5.0" -validvalue formatalignL -type str|null  -default "nothing"
        setdef options alignMaxLabel -minversion "5.5.0" -validvalue formatalignL -type str|null  -default "nothing"
    }

    if {[infoNameProc $levelP "yAxis.axisLabel"]} {
        setdef options verticalAlignMinLabel -minversion "5.5.0" -validvalue formatValignL -type str|null  -default "nothing"
        setdef options verticalAlignMaxLabel -minversion "5.5.0" -validvalue formatValignL -type str|null  -default "nothing"
    }

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::upperLabel {value} {

    if {![ticklecharts::keyDictExists "upperLabel" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5  -validvalue {}                      -type bool             -default "False"
    setdef options offset               -minversion 5  -validvalue {}                      -type list.n|null      -default "nothing"
    setdef options position             -minversion 5  -validvalue formatPosition          -type str|list.d|null  -default "inside"
    setdef options distance             -minversion 5  -validvalue {}                      -type num|null         -default 5
    setdef options rotate               -minversion 5  -validvalue formatRotate            -type num|null         -default "nothing"
    setdef options formatter            -minversion 5  -validvalue {}                      -type str|jsfunc|null  -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type e.color|str|null -default "nothing"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str              -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num          -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str              -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num|null         -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str|null         -default "nothing"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str|null         -default "nothing"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type e.color|str|null -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null         -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n   -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n|null  -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str              -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                      -type num|null         -default 20
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null         -default "nothing"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n   -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num|null         -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str              -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str              -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str              -default "..."
    setdef options rich                 -minversion 5  -validvalue {}                      -type dict|struct|null -default [ticklecharts::richItem $d]
    #...

    # remove key(s) from dict value rich...
    set d [dict remove $d richitem richItem]

    set options [merge $options $d]

    return [new edict $options]
}


proc ticklecharts::label {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "label" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "label"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    set color [expr {[keysOptsThemeExists $levelP.color] ? [echartsOptsTheme $levelP.color] : [echartsOptsTheme textStyle.color]}]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5  -validvalue {}                      -type bool               -trace no   -default "True"
    setdef options offset               -minversion 5  -validvalue {}                      -type list.n|null        -trace no   -default "nothing"
    setdef options position             -minversion 5  -validvalue formatPosition          -type str|list.d|null    -trace no   -default "nothing"
    setdef options distance             -minversion 5  -validvalue {}                      -type num|list.n|null    -trace yes  -default "nothing"
    setdef options rotate               -minversion 5  -validvalue formatRotate            -type num                -trace no   -default 0
    setdef options formatter            -minversion 5  -validvalue {}                      -type str|jsfunc|null    -trace no   -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type e.color|str.t|null -trace no   -default $color
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str                -trace no   -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num            -trace no   -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str                -trace no   -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num|null           -trace no   -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str|null           -trace no   -default "nothing"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str|null           -trace no   -default "nothing"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num|null           -trace no   -default 12
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type e.color|str|null   -trace no   -default "nothing"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null           -trace no   -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n     -trace no   -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num                -trace no   -default 2
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n|null    -trace no   -default "nothing"
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str                -trace no   -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num|null           -trace no   -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                      -type num|null           -trace no   -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null           -trace no   -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n     -trace no   -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str                -trace no   -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num                -trace no   -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str                -trace yes  -default "truncate"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str                -trace yes  -default "..."
    setdef options rich                 -minversion 5  -validvalue {}                      -type dict|struct|null   -trace no   -default [ticklecharts::richItem $d]
    #...

    if {[infoNameProc $levelP "*.axisPointer.*"]} {
        set options [dict remove $options position distance rotate align verticalAlign borderType borderDashOffset borderRadius]

        setdef options precision  -minversion 5  -validvalue {} -type str|num  -trace no  -default "auto"
        setdef options margin     -minversion 5  -validvalue {} -type num|null -trace no  -default 3
    }

    switch -exact -- [ticklecharts::whichSeries? $levelP] {
        "pieSeries" {
            setdef options rotate              -minversion 5  -validvalue formatRotate  -type num|bool|string  -trace no  -default 0
            setdef options alignTo             -minversion 5  -validvalue formatAlignTo -type str              -trace no  -default "none"
            setdef options edgeDistance        -minversion 5  -validvalue {}            -type str|num|null     -trace no  -default "25%"
            setdef options bleedMargin         -minversion 5  -validvalue {}            -type num|null         -trace no  -default 10
            setdef options margin              -minversion 5  -validvalue {}            -type num|null         -trace no  -default "nothing"
            setdef options distanceToLabelLine -minversion 5  -validvalue {}            -type num              -trace no  -default 5
        }
        "sunburstSeries" {
            setdef options rotate       -minversion 5  -validvalue formatRotate    -type num|str         -trace no  -default "radial"
            setdef options align        -minversion 5  -validvalue formatTextAlign -type str|null        -trace no  -default "center"
            setdef options minAngle     -minversion 5  -validvalue {}              -type num|null        -trace no  -default "nothing"
            setdef options position     -minversion 5  -validvalue formatPosition  -type str|list.d|null -trace no  -default "inside"
            setdef options distance     -minversion 5  -validvalue {}              -type num|null        -trace no  -default 5
            setdef options borderRadius -minversion 5  -validvalue {}              -type num             -trace no  -default 0
            setdef options offset       -minversion 5  -validvalue {}              -type list.n|null     -trace no  -default "nothing"
        }
    }

    # remove key(s) from dict value rich...
    set d [dict remove $d richitem richItem]

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::endLabel {value} {

    if {![ticklecharts::keyDictExists "endLabel" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5  -validvalue {}                      -type bool             -trace no  -default "False"
    setdef options distance             -minversion 5  -validvalue {}                      -type num              -trace no  -default 5
    setdef options rotate               -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options offset               -minversion 5  -validvalue {}                      -type list.d|null      -trace no  -default "nothing"
    setdef options formatter            -minversion 5  -validvalue {}                      -type str|jsfunc|null  -trace no  -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type e.color|str|null -trace no  -default "inherit"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str              -trace no  -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num          -trace no  -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str              -trace no  -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num              -trace no  -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str              -trace no  -default "left"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str              -trace no  -default "top"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num              -trace no  -default 12
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type e.color|str      -trace no  -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null         -trace no  -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n   -trace no  -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n       -trace no  -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str              -trace no  -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num              -trace no  -default 100
    setdef options height               -minversion 5  -validvalue {}                      -type num              -trace no  -default 100
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null         -trace no  -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n   -trace no  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str              -trace no  -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num              -trace no  -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str              -trace no  -default "truncate"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str              -trace yes -default "..."
    setdef options valueAnimation       -minversion 5  -validvalue {}                      -type bool|null        -trace no  -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::axisName {value} {

    if {![ticklecharts::keyDictExists "axisName" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5  -validvalue {}                   -type bool             -default "True"
    setdef options formatter            -minversion 5  -validvalue {}                   -type str|jsfunc|null  -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor          -type e.color|str|null -default "nothing"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str              -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|num          -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str              -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num              -default 12
    setdef options lineHeight           -minversion 5  -validvalue formatColor          -type num|null         -default "nothing"
    setdef options backgroundColor      -minversion 5  -validvalue formatColor          -type e.color|str      -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor          -type str|null         -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType     -type str|num|list.n   -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options padding              -minversion 5  -validvalue {}                   -type num|list.n       -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor          -type str              -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options width                -minversion 5  -validvalue {}                   -type num|null         -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                   -type num|null         -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue formatColor          -type str|null         -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n   -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str              -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num              -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow       -type str              -default "truncate"
    setdef options ellipsis             -minversion 5  -validvalue {}                   -type str              -default "..."
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::lineStyle {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "lineStyle" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "lineStyle"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    set color     [expr {[keysOptsThemeExists $levelP.color] ? [echartsOptsTheme $levelP.color] : "nothing"}]
    set linewidth [expr {[keysOptsThemeExists $levelP.width] ? [echartsOptsTheme $levelP.width] : "nothing"}]

    setdef options color          -minversion 5  -validvalue formatColor         -type e.color|str.t|jsfunc|list.st|null -trace no  -default $color
    setdef options width          -minversion 5  -validvalue {}                  -type num.t|null                        -trace no  -default $linewidth
    setdef options type           -minversion 5  -validvalue formatLineStyleType -type list.n|num|str                    -trace no  -default "solid"
    setdef options dashOffset     -minversion 5  -validvalue {}                  -type num                               -trace no  -default 0
    setdef options cap            -minversion 5  -validvalue formatCap           -type str                               -trace no  -default "butt"
    setdef options join           -minversion 5  -validvalue formatJoin          -type str                               -trace yes -default "bevel"
    setdef options miterLimit     -minversion 5  -validvalue {}                  -type num|null                          -trace yes -default "nothing"
    setdef options shadowBlur     -minversion 5  -validvalue {}                  -type num                               -trace no  -default 0
    setdef options shadowColor    -minversion 5  -validvalue formatColor         -type str|null                          -trace no  -default "null"
    setdef options shadowOffsetX  -minversion 5  -validvalue {}                  -type num                               -trace no  -default 0
    setdef options shadowOffsetY  -minversion 5  -validvalue {}                  -type num                               -trace no  -default 0
    setdef options curveness      -minversion 5  -validvalue {}                  -type num|null                          -trace no  -default "nothing"
    setdef options opacity        -minversion 5  -validvalue formatOpacity       -type num|null                          -trace no  -default 1
    #...

    if {[infoNameProc $levelP "legend.lineStyle"]} {
        setdef options color      -minversion 5  -validvalue formatColor         -type e.color|str|null  -trace no  -default "inherit"
        setdef options width      -minversion 5  -validvalue {}                  -type str|num|null      -trace no  -default "auto"
        setdef options type       -minversion 5  -validvalue formatLineStyleType -type list.n|num|str    -trace no  -default "inherit"
        setdef options dashOffset -minversion 5  -validvalue {}                  -type num|str           -trace no  -default "inherit"
        setdef options cap        -minversion 5  -validvalue formatCap           -type str               -trace no  -default "inherit"
        setdef options join       -minversion 5  -validvalue formatJoin          -type str               -trace no  -default "inherit"
        setdef options miterLimit -minversion 5  -validvalue {}                  -type num|str           -trace no  -default "inherit"
        setdef options shadowBlur -minversion 5  -validvalue {}                  -type num|str           -trace no  -default "inherit"
        setdef options opacity    -minversion 5  -validvalue formatOpacity       -type num|str           -trace no  -default "inherit"
    }

    if {[ticklecharts::whichSeries? $levelP] eq "gaugeSeries"} {
        # remove flag from dict options... not defined in series-gauge.axisLine
        set options [dict remove $options type dashOffset cap join miterLimit opacity]
    }

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::textStyle {value key} {
    variable theme
    variable minProperties

    set levelP [string map [list textStyle $key] [ticklecharts::getLevelProperties [info level]]]
    set minP $minProperties

    if {![dict exists $value $key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    set color      [expr {[keysOptsThemeExists $levelP.color]      ? [echartsOptsTheme $levelP.color] : "nothing"}]
    set fontSize   [expr {[keysOptsThemeExists $levelP.fontSize]   ? [echartsOptsTheme $levelP.fontSize] : "nothing"}]
    set fontWeight [expr {[keysOptsThemeExists $levelP.fontWeight] ? [echartsOptsTheme $levelP.fontWeight] : "nothing"}]

    setdef options color                -minversion 5  -validvalue formatColor          -type str.t|jsfunc|null -trace no  -default $color
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str               -trace no  -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str.t|num.t|null  -trace no  -default $fontWeight
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str               -trace no  -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num.t|null        -trace no  -default $fontSize
    setdef options lineHeight           -minversion 5  -validvalue {}                   -type num|null          -trace no  -default "nothing"
    setdef options width                -minversion 5  -validvalue {}                   -type num               -trace no  -default 100
    setdef options height               -minversion 5  -validvalue {}                   -type num               -trace no  -default 50
    setdef options textBorderColor      -minversion 5  -validvalue {}                   -type str|null          -trace no  -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num               -trace no  -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n    -trace no  -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num               -trace no  -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str               -trace no  -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                   -type num               -trace no  -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num               -trace no  -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num               -trace no  -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow       -type str|null          -trace no  -default "null"
    setdef options ellipsis             -minversion 5  -validvalue {}                   -type str               -trace yes -default "..."
    #...

    if {[ticklecharts::whichSeries? $levelP] eq "wordcloudSeries"} {
        setdef options fontSize    -minversion 5  -validvalue {}  -type null  -trace no  -default "nothing"
        setdef options lineHeight  -minversion 5  -validvalue {}  -type null  -trace no  -default "nothing"
        setdef options width       -minversion 5  -validvalue {}  -type null  -trace no  -default "nothing"
        setdef options height      -minversion 5  -validvalue {}  -type null  -trace no  -default "nothing"
        setdef options ellipsis    -minversion 5  -validvalue {}  -type null  -trace no  -default "nothing"
    }

    if {$key eq "subtextStyle"} {
        setdef options align         -minversion 5  -validvalue formatTextAlign         -type str|null  -trace no  -default "nothing"
        setdef options verticalAlign -minversion 5  -validvalue formatVerticalTextAlign -type str|null  -trace no  -default "nothing"
    }

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::nameTextStyle {value} {

    if {![ticklecharts::keyDictExists "nameTextStyle" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options color                -minversion 5  -validvalue formatColor             -type str|null        -default "nothing"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str             -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num         -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str             -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num             -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str             -default "left"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str             -default "top"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num             -default 12
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type e.color|str     -default "transparent"
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
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::crossStyle {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "crossStyle" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "crossStyle"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    if {[keysOptsThemeExists $levelP.color] && [echartsOptsTheme $levelP.color] ne "nothing"} {
        set color [echartsOptsTheme $levelP.color]
    } else {
        set color "rgb(85, 85, 85)"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options color         -minversion 5  -validvalue formatColor      -type e.color|str.t       -default $color
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

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::backgroundStyle {value} {

    if {![dict exists $value -backgroundStyle]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "-backgroundStyle"]

    setdef options color         -minversion 5  -validvalue formatColor      -type e.color|str     -default "rgba(180, 180, 180, 0.2)"
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

    return [new edict $options]
}

proc ticklecharts::shadowStyle {value} {

    if {![dict exists $value shadowStyle]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "shadowStyle"]

    setdef options color         -minversion 5  -validvalue formatColor   -type e.color|str -default "rgba(150,150,150,0.3)"
    setdef options shadowBlur    -minversion 5  -validvalue {}            -type num|null    -default "nothing"
    setdef options shadowColor   -minversion 5  -validvalue formatColor   -type str|null    -default "nothing"
    setdef options shadowOffsetX -minversion 5  -validvalue {}            -type num|null    -default "nothing"
    setdef options shadowOffsetY -minversion 5  -validvalue {}            -type num|null    -default "nothing"
    setdef options opacity       -minversion 5  -validvalue formatOpacity -type num|null    -default 0.5
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::emptyCircleStyle {value} {

    if {![dict exists $value -emptyCircleStyle]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "-emptyCircleStyle"]

    setdef options color            -minversion "5.2.0" -validvalue formatColor      -type e.color|str -default "rgb(211,211,211)"
    setdef options borderColor      -minversion "5.2.0" -validvalue formatColor      -type str|null    -default "#000"
    setdef options borderWidth      -minversion "5.2.0" -validvalue {}               -type num|null    -default "nothing"
    setdef options borderType       -minversion "5.2.0" -validvalue formatBorderType -type str|null    -default "solid"
    setdef options borderdashOffset -minversion "5.2.0" -validvalue {}               -type num|null    -default "nothing"
    setdef options borderCap        -minversion "5.2.0" -validvalue formatCap        -type str         -default "butt"
    setdef options borderJoin       -minversion "5.2.0" -validvalue formatJoin       -type str         -default "bevel"
    setdef options borderMiterLimit -minversion "5.2.0" -validvalue {}               -type num         -default 10
    setdef options shadowBlur       -minversion "5.2.0" -validvalue {}               -type num|null    -default "nothing"
    setdef options shadowColor      -minversion "5.2.0" -validvalue formatColor      -type str|null    -default "nothing"
    setdef options shadowOffsetX    -minversion "5.2.0" -validvalue {}               -type num|null    -default "nothing"
    setdef options shadowOffsetY    -minversion "5.2.0" -validvalue {}               -type num|null    -default "nothing"
    setdef options opacity          -minversion "5.2.0" -validvalue formatOpacity    -type num|null    -default 0.5
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::axisPointer {value} {

    if {![ticklecharts::keyDictExists "axisPointer" $value key]} {
        return "nothing"
    }

    set levelP [ticklecharts::getLevelProperties [info level]]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    if {[infoNameProc $levelP "xAxis.axisPointer"] || [infoNameProc $levelP "yAxis.axisPointer"] || [infoNameProc $levelP "singleAxis.axisPointer"]} {
        setdef options show                    -minversion 5       -validvalue {}                      -type bool|null       -default "nothing"
        setdef options type                    -minversion 5       -validvalue formatAxisPointerType   -type str             -default "line"
        setdef options snap                    -minversion 5       -validvalue {}                      -type bool|null       -default "nothing"
        setdef options z                       -minversion 5       -validvalue {}                      -type num|null        -default "nothing"
        setdef options label                   -minversion 5       -validvalue {}                      -type dict|null       -default [ticklecharts::label $d]
        setdef options lineStyle               -minversion 5       -validvalue {}                      -type dict|null       -default [ticklecharts::lineStyle $d]
        setdef options shadowStyle             -minversion 5       -validvalue {}                      -type dict|null       -default [ticklecharts::shadowStyle $d]
        setdef options triggerEmphasis         -minversion "5.4.3" -validvalue {}                      -type bool|null       -default "nothing"
        setdef options triggerTooltip          -minversion 5       -validvalue {}                      -type bool|null       -default "nothing"
        setdef options value                   -minversion 5       -validvalue {}                      -type num|null        -default "nothing"
        setdef options status                  -minversion 5       -validvalue formatAxisPointerStatus -type str|null        -default "nothing"
        setdef options handle                  -minversion 5       -validvalue {}                      -type dict|null       -default [ticklecharts::handle $d]
    } else {
        setdef options type                    -minversion 5       -validvalue formatAxisPointerType   -type str             -default "line"
        setdef options axis                    -minversion 5       -validvalue formatAxisPointerAxis   -type str             -default "auto"
        setdef options snap                    -minversion 5       -validvalue {}                      -type bool|null       -default "nothing"
        setdef options z                       -minversion 5       -validvalue {}                      -type num|null        -default "nothing"
        setdef options label                   -minversion 5       -validvalue {}                      -type dict|null       -default [ticklecharts::label $d]
        setdef options lineStyle               -minversion 5       -validvalue {}                      -type dict|null       -default [ticklecharts::lineStyle $d]
        setdef options shadowStyle             -minversion 5       -validvalue {}                      -type dict|null       -default [ticklecharts::shadowStyle $d]
        setdef options crossStyle              -minversion 5       -validvalue {}                      -type dict|null       -default [ticklecharts::crossStyle $d]
        setdef options animation               -minversion 5       -validvalue {}                      -type bool            -default "True"
        setdef options animationThreshold      -minversion 5       -validvalue {}                      -type num             -default 2000
        setdef options animationDuration       -minversion 5       -validvalue {}                      -type num|jsfunc      -default 1000
        setdef options animationEasing         -minversion 5       -validvalue formatAEasing           -type str             -default "cubicOut"
        setdef options animationDelay          -minversion 5       -validvalue {}                      -type num|jsfunc|null -default "nothing"
        setdef options animationDurationUpdate -minversion 5       -validvalue {}                      -type num|jsfunc      -default 200
        setdef options animationEasingUpdate   -minversion 5       -validvalue formatAEasing           -type str             -default "exponentialOut"
        setdef options animationDelayUpdate    -minversion 5       -validvalue {}                      -type num|jsfunc|null -default "nothing"
        #...
    }

    # remove key(s)...
    set d [dict remove $d label lineStyle shadowStyle crossStyle handle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::inRange {value} {

    if {![dict exists $value inRange]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "inRange"]

    setdef options symbol          -minversion 5  -validvalue formatItemSymbol -type list.d|str|null         -default "nothing"
    setdef options symbolSize      -minversion 5  -validvalue {}               -type list.d|num|null         -default "nothing"
    setdef options color           -minversion 5  -validvalue formatColor      -type e.color|list.d|str|null -default "nothing"
    setdef options colorAlpha      -minversion 5  -validvalue formatColor      -type list.d|str|null         -default "nothing"
    setdef options opacity         -minversion 5  -validvalue {}               -type list.d|num|null         -default "nothing"
    setdef options colorLightness  -minversion 5  -validvalue formatColor      -type list.d|str|null         -default "nothing"
    setdef options colorSaturation -minversion 5  -validvalue formatColor      -type list.d|str|null         -default "nothing"
    setdef options colorHue        -minversion 5  -validvalue formatColor      -type list.d|str|null         -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::outOfRange {value} {

    if {![dict exists $value outOfRange]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "outOfRange"]

    setdef options symbol          -minversion 5  -validvalue formatItemSymbol -type list.d|str|null         -default "nothing"
    setdef options symbolSize      -minversion 5  -validvalue {}               -type list.d|num|null         -default "nothing"
    setdef options color           -minversion 5  -validvalue formatColor      -type e.color|list.d|str|null -default "nothing"
    setdef options colorAlpha      -minversion 5  -validvalue formatColor      -type list.d|str|null         -default "nothing"
    setdef options opacity         -minversion 5  -validvalue {}               -type list.d|num|null         -default "nothing"
    setdef options colorLightness  -minversion 5  -validvalue formatColor      -type list.d|str|null         -default "nothing"
    setdef options colorSaturation -minversion 5  -validvalue formatColor      -type list.d|str|null         -default "nothing"
    setdef options colorHue        -minversion 5  -validvalue formatColor      -type list.d|str|null         -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::controller {value} {

    if {![dict exists $value controller]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "controller"]

    setdef options inRange    -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::inRange $d]
    setdef options outOfRange -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::outOfRange $d]
    #...

    # remove key(s)...
    set d [dict remove $d inRange outOfRange]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::handleStyle {value} {

    if {![ticklecharts::keyDictExists "handleStyle" $value key]} {
        return "nothing"
    }

    set levelP [ticklecharts::getLevelProperties [info level]]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options color            -minversion 5  -validvalue formatColor      -type e.color|str|null    -default "nothing"
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

    if {[infoNameProc $levelP "*dataZoom.handleStyle"]} {
        setdef options color            -minversion 5  -validvalue formatColor  -type e.color|str|null    -default "#fff"
        setdef options borderColor      -minversion 5  -validvalue formatColor  -type str|null            -default "#ACB8D1"
        setdef options borderWidth      -minversion 5  -validvalue {}           -type num|null            -default 0
        setdef options borderDashOffset -minversion 5  -validvalue {}           -type num|null            -default 0
        setdef options borderJoin       -minversion 5  -validvalue formatJoin   -type str                 -default "bevel"
    }

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::moveHandleStyle {value} {

    if {![dict exists $value -moveHandleStyle]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "-moveHandleStyle"]

    setdef options color            -minversion 5  -validvalue formatColor      -type e.color|str|null    -default "#D2DBEE"
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

    return [new edict $options]
}

proc ticklecharts::indicatorStyle {value} {

    if {![dict exists $value indicatorStyle]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "indicatorStyle"]

    setdef options color            -minversion 5  -validvalue formatColor      -type e.color|str|null    -default "nothing"
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

    return [new edict $options]
}

proc ticklecharts::markArea {value} {

    if {![dict exists $value -markArea]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "-markArea"]

    setdef options silent                  -minversion 5  -validvalue {}            -type bool|null        -trace no   -default "False"
    setdef options label                   -minversion 5  -validvalue {}            -type dict|null        -trace no   -default [ticklecharts::label $d]
    setdef options itemStyle               -minversion 5  -validvalue {}            -type dict|null        -trace no   -default [ticklecharts::itemStyle $d]
    setdef options emphasis                -minversion 5  -validvalue {}            -type dict|null        -trace no   -default [ticklecharts::emphasis $d]
    setdef options blur                    -minversion 5  -validvalue {}            -type dict|null        -trace no   -default [ticklecharts::blur $d]
    setdef options data                    -minversion 5  -validvalue {}            -type list.o|null      -trace no   -default [ticklecharts::markAreaItem $d]
    setdef options animation               -minversion 5  -validvalue {}            -type bool|null        -trace yes  -default "nothing"
    setdef options animationThreshold      -minversion 5  -validvalue {}            -type num|null         -trace no   -default "nothing"
    setdef options animationDuration       -minversion 5  -validvalue {}            -type num|jsfunc|null  -trace no   -default "nothing"
    setdef options animationEasing         -minversion 5  -validvalue formatAEasing -type str|null         -trace no   -default "nothing"
    setdef options animationDelay          -minversion 5  -validvalue {}            -type num|jsfunc|null  -trace no   -default "nothing"
    setdef options animationDurationUpdate -minversion 5  -validvalue {}            -type num|jsfunc|null  -trace no   -default "nothing"
    setdef options animationEasingUpdate   -minversion 5  -validvalue formatAEasing -type str|null         -trace no   -default "nothing"
    setdef options animationDelayUpdate    -minversion 5  -validvalue {}            -type num|jsfunc|null  -trace no   -default "nothing"
    #...

    # remove key(s)...
    set d [dict remove $d data label itemStyle emphasis blur]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::rippleEffect {value} {

    if {![dict exists $value -rippleEffect]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "-rippleEffect"]

    setdef options color     -minversion 5       -validvalue formatColor      -type str|null  -default "nothing"
    setdef options number    -minversion "5.2.0" -validvalue {}               -type num|null  -default 3
    setdef options period    -minversion 5       -validvalue {}               -type num|null  -default 4
    setdef options scale     -minversion 5       -validvalue {}               -type num|null  -default 2.5
    setdef options brushType -minversion 5       -validvalue formatEbrushType -type str|null  -default "fill"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::feature {value} {

    if {![ticklecharts::keyDictExists "feature" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options dataZoom     -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::toolBoxDataZoom $d]
    setdef options dataView     -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::dataView $d]
    setdef options magicType    -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::magicType $d]
    setdef options brush        -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::brushOpts $d]
    setdef options restore      -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::restore $d]
    setdef options saveAsImage  -minversion 5  -validvalue {} -type dict|null  -default [ticklecharts::saveAsImage $d]
    #...

    # remove key(s)...
    set d [dict remove $d saveAsImage restore dataView dataZoom magicType brush]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::saveAsImage {value} {

    if {![ticklecharts::keyDictExists "saveAsImage" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options type                     -minversion 5  -validvalue formatSaveAsImg -type str              -default "png"
    setdef options name                     -minversion 5  -validvalue {}              -type str|null         -default "nothing"
    setdef options backgroundColor          -minversion 5  -validvalue formatColor     -type e.color|str|null -default "transparent"
    setdef options connectedBackgroundColor -minversion 5  -validvalue formatColor     -type str|null         -default "#fff"
    setdef options excludeComponents        -minversion 5  -validvalue {}              -type list.s|null      -default "nothing"
    setdef options show                     -minversion 5  -validvalue {}              -type bool             -default "True"
    setdef options title                    -minversion 5  -validvalue {}              -type str              -default "Save as image"
    setdef options icon                     -minversion 5  -validvalue {}              -type str|null         -default "nothing"
    setdef options iconStyle                -minversion 5  -validvalue {}              -type dict|null        -default [ticklecharts::iconStyle $d "iconStyle"]
    setdef options emphasis                 -minversion 5  -validvalue {}              -type dict|null        -default [ticklecharts::iconEmphasis $d]
    setdef options pixelRatio               -minversion 5  -validvalue {}              -type num              -default 1
    #...

    # remove key(s)...
    set d [dict remove $d iconStyle emphasis]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::restore {value} {

    if {![ticklecharts::keyDictExists "restore" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show      -minversion 5  -validvalue {} -type bool      -default "True"
    setdef options title     -minversion 5  -validvalue {} -type str       -default "Restore"
    setdef options icon      -minversion 5  -validvalue {} -type str|null  -default "nothing"
    setdef options iconStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::iconStyle $d "iconStyle"]
    setdef options emphasis  -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::iconEmphasis $d]
    #...

    # remove key(s)...
    set d [dict remove $d iconStyle emphasis]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::dataView {value} {

    if {![ticklecharts::keyDictExists "dataView" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                -minversion 5  -validvalue {}          -type bool         -default "True"
    setdef options title               -minversion 5  -validvalue {}          -type str          -default "Data view"
    setdef options icon                -minversion 5  -validvalue {}          -type str|null     -default "nothing"
    setdef options iconStyle           -minversion 5  -validvalue {}          -type dict|null    -default [ticklecharts::iconStyle $d "iconStyle"]
    setdef options emphasis            -minversion 5  -validvalue {}          -type dict|null    -default [ticklecharts::iconEmphasis $d]
    setdef options readOnly            -minversion 5  -validvalue {}          -type bool         -default "False"
    setdef options optionToContent     -minversion 5  -validvalue {}          -type jsfunc|null  -default "nothing"
    setdef options contentToOption     -minversion 5  -validvalue {}          -type jsfunc|null  -default "nothing"
    setdef options lang                -minversion 5  -validvalue {}          -type list.s|null  -default [list {"Data view" "Turn off" "Refresh"}]
    setdef options backgroundColor     -minversion 5  -validvalue formatColor -type e.color|str  -default "#fff"
    setdef options textareaColor       -minversion 5  -validvalue formatColor -type str          -default "#fff"
    setdef options textareaBorderColor -minversion 5  -validvalue formatColor -type str          -default "#000"
    setdef options buttonColor         -minversion 5  -validvalue formatColor -type str          -default "#c23531"
    setdef options buttonTextColor     -minversion 5  -validvalue formatColor -type str          -default "#fff"
    #...

    # remove key(s)...
    set d [dict remove $d iconStyle emphasis]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::toolBoxDataZoom {value} {

    if {![ticklecharts::keyDictExists "dataZoom" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

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

    # remove key(s)...
    set d [dict remove $d title iconStyle emphasis icon brushStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::magicType {value} {

    if {![ticklecharts::keyDictExists "magicType" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

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

    # remove key(s)...
    set d [dict remove $d title icon iconStyle emphasis]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::brushOpts {value} {

    if {![dict exists $value brush]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "brush"]

    setdef options type   -minversion 5  -validvalue {} -type list.s|null  -default "nothing"
    setdef options icon   -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::icon $d "brush"]
    setdef options title  -minversion 5  -validvalue {} -type dict|null    -default [ticklecharts::toolBoxTitle $d "brush"]
    #...

    # remove key(s)...
    set d [dict remove $d title icon]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::toolBoxTitle {value type} {

    if {![dict exists $value title]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "title"]

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
        default {
            error "Type should be 'dataZoom', 'magicType', 'brush' for\
                  [ticklecharts::getLevelProperties [info level]]"
        }
    }
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::icon {value type} {

    if {![dict exists $value icon]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "icon"]

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
        default {
            error "Type should be 'dataZoom', 'magicType', 'brush' for\
                   [ticklecharts::getLevelProperties [info level]]"
        }
    }
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::iconEmphasis {value} {

    if {![dict exists $value emphasis]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "emphasis"]

    setdef options iconStyle -minversion 5  -validvalue {} -type dict|null -default [ticklecharts::iconStyle $d "emphasis"]
    #...

    # remove key(s)...
    set d [dict remove $d emphasis]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::iconStyle {value key} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![dict exists $value $key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    set borderColor [expr {[keysOptsThemeExists $levelP.borderColor] ? [echartsOptsTheme $levelP.borderColor] : "nothing"}]

    setdef options color            -minversion 5  -validvalue formatColor      -type str|jsfunc|null  -default "nothing"
    setdef options borderColor      -minversion 5  -validvalue formatColor      -type str.t|null       -default $borderColor
    setdef options borderWidth      -minversion 5  -validvalue {}               -type num|null         -default 1
    setdef options borderType       -minversion 5  -validvalue formatBorderType -type str|num|list.n   -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}               -type num|null         -default 0
    setdef options borderCap        -minversion 5  -validvalue formatCap        -type str              -default "butt"
    setdef options borderJoin       -minversion 5  -validvalue formatJoin       -type str              -default "bevel"
    setdef options borderMiterLimit -minversion 5  -validvalue {}               -type num              -default 10
    setdef options shadowBlur       -minversion 5  -validvalue {}               -type num|null         -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor      -type str|null         -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}               -type num|null         -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}               -type num|null         -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity    -type num|null         -default 1

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

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::brushStyle {value} {

    if {![ticklecharts::keyDictExists "brushStyle" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    set levelP [ticklecharts::getLevelProperties [info level]]

    if {[keysOptsThemeExists $levelP.color]} {
        set color [echartsOptsTheme $levelP.color]
        set borderwidth 0
    } else {
        set color "nothing"
        set borderwidth 1
    }

    setdef options color            -minversion 5  -validvalue formatColor      -type e.color|str|jsfunc|null -default $color
    setdef options borderColor      -minversion 5  -validvalue formatColor      -type str|null                -default "#000"
    setdef options borderWidth      -minversion 5  -validvalue {}               -type num|null                -default $borderwidth
    setdef options borderType       -minversion 5  -validvalue formatBorderType -type str|num|list.n          -default "solid"
    setdef options borderDashOffset -minversion 5  -validvalue {}               -type num|null                -default 0
    setdef options borderCap        -minversion 5  -validvalue formatCap        -type str                     -default "butt"
    setdef options borderJoin       -minversion 5  -validvalue formatJoin       -type str                     -default "bevel"
    setdef options borderMiterLimit -minversion 5  -validvalue {}               -type num                     -default 10
    setdef options shadowBlur       -minversion 5  -validvalue {}               -type num|null                -default "nothing"
    setdef options shadowColor      -minversion 5  -validvalue formatColor      -type str|null                -default "nothing"
    setdef options shadowOffsetX    -minversion 5  -validvalue {}               -type num|null                -default "nothing"
    setdef options shadowOffsetY    -minversion 5  -validvalue {}               -type num|null                -default "nothing"
    setdef options opacity          -minversion 5  -validvalue formatOpacity    -type num|null                -default 1
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::leaves {value} {

    if {![dict exists $value -leaves]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "-leaves"]

    setdef options label        -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $d]
    setdef options itemStyle    -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $d]
    setdef options emphasis     -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::emphasis $d]
    setdef options blur         -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::blur $d]
    #...

    # remove key(s)...
    set d [dict remove $d label itemStyle emphasis blur]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::encode {chart value} {

    if {![ticklecharts::keyDictExists "-encode" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options x                 -minversion 5       -validvalue {}  -type str|num|list.d|null  -default "nothing"
    setdef options y                 -minversion 5       -validvalue {}  -type str|num|list.d|null  -default "nothing"
    if {[$chart getType] eq "chart3D"} {
        setdef options z             -minversion 5       -validvalue {}  -type str|num|list.d|null  -default "nothing"
    }
    setdef options itemName          -minversion 5       -validvalue {}  -type str|num|null         -default "nothing"
    setdef options label             -minversion 5       -validvalue {}  -type num|str|null         -default "nothing"
    setdef options value             -minversion 5       -validvalue {}  -type str|null             -default "nothing"
    setdef options seriesName        -minversion 5       -validvalue {}  -type list.d|null          -default "nothing"
    setdef options itemId            -minversion 5       -validvalue {}  -type num|null             -default "nothing"
    setdef options itemGroupId       -minversion 5       -validvalue {}  -type num|null             -default "nothing"
    setdef options itemChildGroupId  -minversion "5.5.0" -validvalue {}  -type num|null             -default "nothing"
    setdef options radius            -minversion 5       -validvalue {}  -type num|null             -default "nothing"
    setdef options angle             -minversion 5       -validvalue {}  -type num|null             -default "nothing"
    setdef options lng               -minversion 5       -validvalue {}  -type num|null             -default "nothing"
    setdef options lat               -minversion 5       -validvalue {}  -type num|null             -default "nothing"
    setdef options tooltip           -minversion 5       -validvalue {}  -type list.d|str|null      -default "nothing"
    #...

    # Special case when dimensions are double values.
    # If I understand Echarts documentation
    # 'value' should be a string value
    set dataset [$chart dataset]
    if {[dict exists $d value]} {
        set v [dict get $d value]
        foreach dimension [$dataset dim] {
            lassign $dimension datadim type
            if {($v in $datadim) && ([ticklecharts::typeOf $v] ni {str str.e})} {
                # force string representation
                dict set d "value" [new estr $v]
                break
            }
        }
    }

    if {[dict exists $d tooltip]} {
        set v [dict get $d tooltip]
        if {[ticklecharts::typeOf $v] eq "num"} {
            # force string representation
            dict set d "tooltip" [new estr $v]
        }
    }

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::config {value} {

    if {![ticklecharts::keyDictExists "config" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options dimension         -minversion 5  -validvalue {}  -type str|num|null    -default "nothing"
    setdef options order             -minversion 5  -validvalue {}  -type str|null        -default "nothing"
    setdef options groupBy           -minversion 5  -validvalue {}  -type str|null        -default "nothing"
    setdef options method            -minversion 5  -validvalue {}  -type str|null        -default "nothing"
    setdef options value             -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options gt                -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options gte               -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options lt                -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options lte               -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options eq                -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options ne                -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options reg               -minversion 5  -validvalue {}  -type num|null        -default "nothing"
    setdef options itemNameFormatter -minversion 5  -validvalue {}  -type str|jsfunc|null -default "nothing"
    #...

    if {[dict exists $d resultDimensions]} {
        foreach item [dict get $d resultDimensions] {
            if {[llength $item] % 2} ticklecharts::errorEvenArgs
            set listobj {}
            foreach {key info} $item {
                set val [ticklecharts::mapSpaceString $info]
                append listobj [format {%s {%s %s} } $key $val [ticklecharts::typeOf $val]]
            }
            lappend opts $listobj
        }
        setdef options resultDimensions -minversion 5  -validvalue {}  -type list.o -default [list {*}$opts]
    }

    # remove key(s)...
    set d [dict remove $d resultDimensions]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::parallelAxisDefault {value} {

    if {![ticklecharts::keyDictExists "parallelAxisDefault" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options type           -minversion 5       -validvalue formatType          -type str|null            -trace no   -default "value"
    setdef options name           -minversion 5       -validvalue {}                  -type str|null            -trace no   -default "nothing"
    setdef options nameLocation   -minversion 5       -validvalue formatNameLocation  -type str|null            -trace no   -default "end"
    setdef options nameTextStyle  -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::nameTextStyle $d]
    setdef options nameGap        -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options nameRotate     -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options inverse        -minversion 5       -validvalue {}                  -type bool|null           -trace no   -default "nothing"
    setdef options boundaryGap    -minversion 5       -validvalue {}                  -type bool|list.d|null    -trace no   -default "nothing"
    setdef options min            -minversion 5       -validvalue formatMin           -type num|str|jsfunc|null -trace no   -default "nothing"
    setdef options max            -minversion 5       -validvalue formatMax           -type num|str|jsfunc|null -trace no   -default "nothing"
    setdef options scale          -minversion 5       -validvalue {}                  -type bool|null           -trace no   -default "nothing"
    setdef options splitNumber    -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options minInterval    -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options maxInterval    -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options interval       -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options logBase        -minversion 5       -validvalue {}                  -type num|null            -trace no   -default "nothing"
    setdef options silent         -minversion 5       -validvalue {}                  -type bool|null           -trace no   -default "nothing"
    setdef options triggerEvent   -minversion 5       -validvalue {}                  -type bool|null           -trace yes  -default "nothing"
    setdef options axisLine       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLine $d]
    setdef options axisTick       -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisTick $d]
    setdef options splitLine      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::splitLine $d]
    setdef options minorTick      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::minorTick $d]
    setdef options axisLabel      -minversion 5       -validvalue {}                  -type dict|null           -trace no   -default [ticklecharts::axisLabel $d]
    setdef options data           -minversion 5       -validvalue {}                  -type list.d|null         -trace no   -default "nothing"
    setdef options realtime       -minversion 5       -validvalue {}                  -type bool|null           -trace no   -default "nothing"
    setdef options tooltip        -minversion "5.6.0" -validvalue {}                  -type dict|null           -trace yes  -default [ticklecharts::tooltip $d]
    #...

    # remove key(s)...
    set d [dict remove $d nameTextStyle axisLine \
                          axisTick splitLine \
                          minorTick axisLabel tooltip]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::areaSelectStyle {value} {

    if {![dict exists $value areaSelectStyle]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "areaSelectStyle"]

    setdef options width       -minversion 5  -validvalue {}          -type num         -default 20
    setdef options borderWidth -minversion 5  -validvalue {}          -type num         -default 1
    setdef options borderColor -minversion 5  -validvalue formatColor -type str         -default "rgb(160,197,232)"
    setdef options color       -minversion 5  -validvalue formatColor -type e.color|str -default "rgb(160,197,232)"
    setdef options opacity     -minversion 5  -validvalue {}          -type num         -default 0.3
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::brushStyleItem {value} {

    if {![dict exists $value brushStyle]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value "brushStyle"]

    setdef options borderWidth -minversion 5  -validvalue {}          -type num         -default 1
    setdef options borderColor -minversion 5  -validvalue formatColor -type str         -default "rgba(120,140,180,0.8)"
    setdef options color       -minversion 5  -validvalue formatColor -type e.color|str -default "rgba(120,140,180,0.3)"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::brushVisual {key value} {

    if {![dict exists $value $key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options symbol           -minversion 5  -validvalue formatItemSymbol -type str|null         -default "nothing"
    setdef options symbolSize       -minversion 5  -validvalue {}               -type num|null         -default "nothing"
    setdef options color            -minversion 5  -validvalue formatColor      -type e.color|str|null -default "nothing"
    setdef options colorAlpha       -minversion 5  -validvalue formatColor      -type list.d|str|null  -default "nothing"
    setdef options opacity          -minversion 5  -validvalue {}               -type num|null         -default "nothing"
    setdef options colorLightness   -minversion 5  -validvalue {}               -type str|null         -default "nothing"
    setdef options colorSaturation  -minversion 5  -validvalue {}               -type str|null         -default "nothing"
    setdef options colorHue         -minversion 5  -validvalue {}               -type str|null         -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::checkPointStyle {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "checkpointStyle" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "checkpointStyle"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options symbol            -minversion 5  -validvalue formatItemSymbol -type str          -trace no   -default "circle"
    setdef options symbolSize        -minversion 5  -validvalue {}               -type num          -trace no   -default 13
    setdef options symbolRotate      -minversion 5  -validvalue {}               -type num|null     -trace no   -default "nothing"
    setdef options symbolKeepAspect  -minversion 5  -validvalue {}               -type bool         -trace no   -default "False"
    setdef options symbolOffset      -minversion 5  -validvalue {}               -type list.n|null  -trace no   -default "nothing"
    setdef options color             -minversion 5  -validvalue formatColor      -type str.t|null   -trace no   -default [echartsOptsTheme $levelP.color]
    setdef options borderColor       -minversion 5  -validvalue formatColor      -type str.t|null   -trace no   -default [echartsOptsTheme $levelP.borderColor]
    setdef options borderWidth       -minversion 5  -validvalue {}               -type num|null     -trace no   -default 2
    setdef options borderType        -minversion 5  -validvalue formatBorderType -type str|null     -trace no   -default "solid"
    setdef options borderDashOffset  -minversion 5  -validvalue {}               -type num|null     -trace no   -default "nothing"
    setdef options borderCap         -minversion 5  -validvalue formatCap        -type str          -trace no   -default "butt"
    setdef options borderJoin        -minversion 5  -validvalue formatJoin       -type str          -trace no   -default "bevel"
    setdef options borderMiterLimit  -minversion 5  -validvalue {}               -type num          -trace no   -default 10
    setdef options shadowBlur        -minversion 5  -validvalue {}               -type num|null     -trace no   -default 2
    setdef options shadowColor       -minversion 5  -validvalue formatColor      -type str|null     -trace no   -default "rgba(0, 0, 0, 0.3)"
    setdef options shadowOffsetX     -minversion 5  -validvalue {}               -type num|null     -trace no   -default 1
    setdef options shadowOffsetY     -minversion 5  -validvalue {}               -type num|null     -trace no   -default 1
    setdef options opacity           -minversion 5  -validvalue formatOpacity    -type num|null     -trace no   -default "nothing"
    setdef options animation         -minversion 5  -validvalue {}               -type bool|null    -trace yes  -default "True"
    setdef options animationDuration -minversion 5  -validvalue {}               -type num|null     -trace no   -default 300
    setdef options animationEasing   -minversion 5  -validvalue formatAEasing    -type str|null     -trace no   -default "quinticInOut"
    #...

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::controlStyle {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "controlStyle" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "controlStyle"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

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

    setdef options playIcon          -minversion 5  -validvalue formatTimelineIcon  -type str|null          -default "nothing"
    setdef options stopIcon          -minversion 5  -validvalue formatTimelineIcon  -type str|null          -default "nothing"
    setdef options prevIcon          -minversion 5  -validvalue formatTimelineIcon  -type str|null          -default "nothing"
    setdef options color             -minversion 5  -validvalue formatColor         -type str.t|null        -default [echartsOptsTheme $levelP.color]
    setdef options borderColor       -minversion 5  -validvalue formatColor         -type str.t|null        -default [echartsOptsTheme $levelP.borderColor]
    setdef options borderWidth       -minversion 5  -validvalue {}                  -type num|null          -default 1
    setdef options borderType        -minversion 5  -validvalue formatBorderType    -type str|null          -default "solid"
    setdef options borderDashOffset  -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options borderCap         -minversion 5  -validvalue formatCap           -type str               -default "butt"
    setdef options borderJoin        -minversion 5  -validvalue formatJoin          -type str               -default "bevel"
    setdef options borderMiterLimit  -minversion 5  -validvalue {}                  -type num               -default 10
    setdef options shadowBlur        -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options shadowColor       -minversion 5  -validvalue formatColor         -type str|null          -default "nothing"
    setdef options shadowOffsetX     -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options shadowOffsetY     -minversion 5  -validvalue {}                  -type num|null          -default "nothing"
    setdef options opacity           -minversion 5  -validvalue formatOpacity       -type num|null          -default "nothing"
    #...

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::progress {value} {
    variable theme
    variable minProperties

    set levelP [ticklecharts::getLevelProperties [info level]]
    set minP $minProperties

    if {![ticklecharts::keyDictExists "progress" $value key]} {
        if {$theme ne "custom" && ![string match "*Item.*" $levelP]} {
            set minProperties 1 ; set key "progress"
            dict set value $key {dummy null}
        } else {
            return "nothing"
        }
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options label       -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::label $d]
    setdef options itemStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::itemStyle $d]
    setdef options lineStyle   -minversion 5  -validvalue {}  -type dict|null   -default [ticklecharts::lineStyle $d]

    if {[ticklecharts::whichSeries? $levelP] eq "gaugeSeries"} {
        setdef options show     -minversion 5  -validvalue {} -type bool -default "False"
        setdef options overlap  -minversion 5  -validvalue {} -type bool -default "True"
        setdef options width    -minversion 5  -validvalue {} -type num  -default 10
        setdef options roundCap -minversion 5  -validvalue {} -type bool -default "False"
        setdef options clip     -minversion 5  -validvalue {} -type bool -default "False"
        # remove flag from dict options... not defined in series-gauge.progress
        set options [dict remove $options label lineStyle]
    }

    # remove key(s)...
    set d [dict remove $d label itemStyle lineStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    # reset minProperties...
    set minProperties $minP

    if {![dict size $options]} {
        return "nothing"
    } else {
        return [new edict $options]
    }
}

proc ticklecharts::pointer {value} {

    if {![ticklecharts::keyDictExists "-pointer" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show         -minversion 5       -validvalue {}               -type bool      -default "True"
    setdef options showAbove    -minversion "5.2.0" -validvalue {}               -type bool      -default "True"
    setdef options icon         -minversion 5       -validvalue formatItemSymbol -type str|null  -default "nothing"
    setdef options offsetCenter -minversion 5       -validvalue {}               -type list.d    -default [list {0 0}]
    setdef options length       -minversion 5       -validvalue {}               -type str|num   -default "60%"
    setdef options width        -minversion 5       -validvalue {}               -type num       -default 6
    setdef options keepAspect   -minversion 5       -validvalue {}               -type bool|null -default "nothing"
    setdef options itemStyle    -minversion 5       -validvalue {}               -type dict|null -default [ticklecharts::itemStyle $d]

    # remove key(s)...
    set d [dict remove $d label itemStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::anchor {value} {

    if {![ticklecharts::keyDictExists "-anchor" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show         -minversion 5  -validvalue {}               -type bool      -default "True"
    setdef options showAbove    -minversion 5  -validvalue {}               -type bool      -default "False"
    setdef options size         -minversion 5  -validvalue {}               -type num       -default 6
    setdef options icon         -minversion 5  -validvalue formatItemSymbol -type str|null  -default "nothing"
    setdef options offsetCenter -minversion 5  -validvalue {}               -type list.d    -default [list {0 0}]
    setdef options keepAspect   -minversion 5  -validvalue {}               -type bool|null -default "False"
    setdef options itemStyle    -minversion 5  -validvalue {}               -type dict|null -default [ticklecharts::itemStyle $d]

    # remove key(s)...
    set d [dict remove $d label itemStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::titleGauge {value} {

    if {![ticklecharts::keyDictExists "title" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5  -validvalue {}                   -type bool                -default "True"
    setdef options offsetCenter         -minversion 5  -validvalue {}                   -type list.d              -default [list {0 "20%"}]
    setdef options keepAspect           -minversion 5  -validvalue {}                   -type bool|null           -default "False"
    setdef options itemStyle            -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::itemStyle $d]
    setdef options color                -minversion 5  -validvalue formatColor          -type e.color|str|null    -default "#464646"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str|null            -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|null            -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str|null            -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num|null            -default 16
    setdef options lineHeight           -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
    setdef options backgroundColor      -minversion 5  -validvalue formatColor          -type e.color|str|null    -default "transparent"
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

    # remove key(s)...
    set d [dict remove $d itemStyle]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::detail {value} {

    if {![ticklecharts::keyDictExists "detail" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5  -validvalue {}                   -type bool                -default "True"
    setdef options color                -minversion 5  -validvalue formatColor          -type e.color|str|null    -default "#464646"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str|null            -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|null            -default "bold"
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str|null            -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num|null            -default 30
    setdef options lineHeight           -minversion 5  -validvalue {}                   -type num|null            -default 30
    setdef options backgroundColor      -minversion 5  -validvalue formatColor          -type e.color|str|null    -default "transparent"
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
    setdef options rich                 -minversion 5  -validvalue {}                   -type dict|struct|null    -default [ticklecharts::richItem $d]
    #...

    # remove key(s)...
    set d [dict remove $d richItem richitem]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::circular {value} {

    if {![ticklecharts::keyDictExists "circular" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options rotateLabel  -minversion 5  -validvalue {} -type bool  -default "True"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::force {value} {

    if {![ticklecharts::keyDictExists "force" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options initLayout      -minversion 5  -validvalue {} -type str|null    -default "nothing"
    setdef options repulsion       -minversion 5  -validvalue {} -type num|list.d  -default 50
    setdef options gravity         -minversion 5  -validvalue {} -type num         -default 0.1
    setdef options edgeLength      -minversion 5  -validvalue {} -type num|list.d  -default 30
    setdef options layoutAnimation -minversion 5  -validvalue {} -type bool        -default "True"
    setdef options friction        -minversion 5  -validvalue {} -type num         -default 0.6

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::scaleLimit {value} {

    if {![ticklecharts::keyDictExists "scaleLimit" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options max   -minversion 5  -validvalue {} -type num  -default 1
    setdef options min   -minversion 5  -validvalue {} -type num  -default 1

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::edgeLabel {value} {

    if {![ticklecharts::keyDictExists "edgeLabel" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5  -validvalue {}                      -type bool|null           -default "nothing"
    setdef options position             -minversion 5  -validvalue formatEdgeLabelPosition -type str                 -default "middle"
    setdef options formatter            -minversion 5  -validvalue {}                      -type str|jsfunc|null     -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type e.color|str|null    -default "nothing"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str|null            -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|null            -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str|null            -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num|null            -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str|null            -default "nothing"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str|null            -default "nothing"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num|null            -default "nothing"
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type e.color|str|null    -default "transparent"
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
    setdef options rich                 -minversion 5  -validvalue {}                      -type dict|struct|null    -default [ticklecharts::richItem $d]
    #...

    # remove key(s)...
    set d [dict remove $d richItem richitem]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::categories {value} {

    if {![ticklecharts::keyDictExists "categories" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

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

        # remove key(s)...
        set item [dict remove $item itemStyle label emphasis blur select]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::breadcrumb {value} {

    if {![ticklecharts::keyDictExists "breadcrumb" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show           -minversion 5       -validvalue {}            -type bool          -default "True"
    setdef options left           -minversion 5       -validvalue formatLeft    -type str|num|null  -default "center"
    setdef options top            -minversion 5       -validvalue formatTop     -type str|num|null  -default "auto"
    setdef options right          -minversion 5       -validvalue formatRight   -type str|num|null  -default "auto"
    setdef options bottom         -minversion 5       -validvalue formatBottom  -type str|num|null  -default "auto"
    setdef options height         -minversion 5       -validvalue {}            -type num           -default 22
    setdef options emptyItemWidth -minversion 5       -validvalue {}            -type num           -default 25
    setdef options itemStyle      -minversion 5       -validvalue {}            -type dict|null     -default [ticklecharts::itemStyle $d]
    setdef options emphasis       -minversion "5.4.0" -validvalue {}            -type dict|null     -default [ticklecharts::emphasis $d]
    #...

    # remove key(s)...
    set d [dict remove $d emphasis itemStyle]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::pageIcons {value} {

    if {![ticklecharts::keyDictExists "pageIcons" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options horizontal -minversion 5  -validvalue {}  -type list.s|null  -default "nothing"
    setdef options vertical   -minversion 5  -validvalue {}  -type list.s|null  -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::pageTextStyle {value} {

    if {![ticklecharts::keyDictExists "pageIcons" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options color                -minversion 5  -validvalue formatColor          -type e.color|str|jsfunc|null -default $color
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle      -type str                     -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|num                 -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                   -type str                     -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                   -type num                     -default 12
    setdef options lineHeight           -minversion 5  -validvalue {}                   -type num|null                -default "nothing"
    setdef options width                -minversion 5  -validvalue {}                   -type num|null                -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                   -type num|null                -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue {}                   -type str|null                -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                   -type num                     -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n          -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                   -type num                     -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor          -type str                     -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                   -type num                     -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                   -type num                     -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                   -type num                     -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow       -type str|null                -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                   -type str                     -default "..."
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::selectorLabel {value} {

    if {![ticklecharts::keyDictExists "selectorLabel" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5  -validvalue {}                      -type bool             -default "True"
    setdef options distance             -minversion 5  -validvalue {}                      -type num              -default 12
    setdef options rotate               -minversion 5  -validvalue formatRotate            -type num|null         -default "nothing"
    setdef options offset               -minversion 5  -validvalue {}                      -type list.n|null      -default "nothing"
    setdef options color                -minversion 5  -validvalue formatColor             -type e.color|str|null -default "nothing"
    setdef options fontStyle            -minversion 5  -validvalue formatFontStyle         -type str              -default "normal"
    setdef options fontWeight           -minversion 5  -validvalue formatFontWeight        -type str|num          -default "normal"
    setdef options fontFamily           -minversion 5  -validvalue {}                      -type str              -default "sans-serif"
    setdef options fontSize             -minversion 5  -validvalue {}                      -type num              -default 12
    setdef options align                -minversion 5  -validvalue formatTextAlign         -type str|null         -default "nothing"
    setdef options verticalAlign        -minversion 5  -validvalue formatVerticalTextAlign -type str|null         -default "nothing"
    setdef options lineHeight           -minversion 5  -validvalue {}                      -type num              -default 12
    setdef options backgroundColor      -minversion 5  -validvalue formatColor             -type e.color|str      -default "transparent"
    setdef options borderColor          -minversion 5  -validvalue formatColor             -type str|null         -default "nothing"
    setdef options borderWidth          -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options borderType           -minversion 5  -validvalue formatBorderType        -type str|num|list.n   -default "solid"
    setdef options borderDashOffset     -minversion 5  -validvalue {}                      -type num|null         -default 0
    setdef options borderRadius         -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options padding              -minversion 5  -validvalue {}                      -type num|list.n       -default 0
    setdef options shadowColor          -minversion 5  -validvalue formatColor             -type str              -default "transparent"
    setdef options shadowBlur           -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options shadowOffsetX        -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options shadowOffsetY        -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options width                -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options height               -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options textBorderColor      -minversion 5  -validvalue formatColor             -type str|null         -default "null"
    setdef options textBorderWidth      -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options textBorderType       -minversion 5  -validvalue formatTextBorderType    -type str|num|list.n   -default "solid"
    setdef options textBorderDashOffset -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options textShadowColor      -minversion 5  -validvalue formatColor             -type str              -default "transparent"
    setdef options textShadowBlur       -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options textShadowOffsetX    -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options textShadowOffsetY    -minversion 5  -validvalue {}                      -type num              -default 0
    setdef options overflow             -minversion 5  -validvalue formatOverflow          -type str              -default "none"
    setdef options ellipsis             -minversion 5  -validvalue {}                      -type str              -default "..."
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::handle {value} {

    if {![ticklecharts::keyDictExists "handle" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show          -minversion 5  -validvalue {}                 -type bool             -default "True"
    setdef options icon          -minversion 5  -validvalue formatTimelineIcon -type str|null         -default "nothing"
    setdef options size          -minversion 5  -validvalue {}                 -type num|list.n|null  -default 45
    setdef options margin        -minversion 5  -validvalue {}                 -type num|null         -default 50
    setdef options color         -minversion 5  -validvalue formatColor        -type e.color|str|null -default "nothing"
    setdef options throttle      -minversion 5  -validvalue {}                 -type num|null         -default 40
    setdef options shadowBlur    -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options shadowColor   -minversion 5  -validvalue formatColor        -type str|null         -default "nothing"
    setdef options shadowOffsetX -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    setdef options shadowOffsetY -minversion 5  -validvalue {}                 -type num|null         -default "nothing"
    #...

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::projection {value} {

    if {![ticklecharts::keyDictExists "projection" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options project    -minversion 5  -validvalue {}  -type jsfunc|null  -default "nothing"
    setdef options unproject  -minversion 5  -validvalue {}  -type jsfunc|null  -default "nothing"
    setdef options stream     -minversion 5  -validvalue {}  -type jsfunc|null  -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::nameMap {value} {

    if {![dict exists $value -nameMap]} {
        return "nothing"
    }

    foreach {key item} [dict get $value -nameMap] {

        if {$item eq ""} {
            error "Should be a 'key + item' for\
                   [ticklecharts::getLevelProperties [info level]]"
        }

        # map spaces... and others...
        set key [ticklecharts::mapSpaceString $key]

        # set key in options...
        setdef options $key -minversion 5 -validvalue {} -type str|num|list.d -default $item

        append opts "[merge $options [list $key $item]] "
        set options {}
    }

    return [new edict $opts]
}

proc ticklecharts::calendarLabel {value time} {

    if {![ticklecharts::keyDictExists $time $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show                 -minversion 5        -validvalue {}                      -type bool               -default "True"
    setdef options firstDay             -minversion 5        -validvalue {}                      -type num|null           -default "nothing"
    setdef options margin               -minversion 5        -validvalue {}                      -type num|null           -default "nothing"
    setdef options position             -minversion 5        -validvalue formatPosition          -type str|null           -default "nothing"
    setdef options nameMap              -minversion 5        -validvalue formatNameMap           -type list.d|str|null    -default "nothing"
    setdef options color                -minversion 5        -validvalue formatColor             -type e.color|str.t|null -default [echartsOptsTheme calendar.${time}.color]
    setdef options fontStyle            -minversion 5        -validvalue formatFontStyle         -type str                -default "normal"
    setdef options fontWeight           -minversion 5        -validvalue formatFontWeight        -type str|num            -default "normal"
    setdef options fontFamily           -minversion 5        -validvalue {}                      -type str                -default "sans-serif"
    setdef options fontSize             -minversion 5        -validvalue {}                      -type num                -default 12
    setdef options align                -minversion 5        -validvalue formatTextAlign         -type str|null           -default "nothing"
    setdef options verticalAlign        -minversion 5        -validvalue formatVerticalTextAlign -type str|null           -default "nothing"
    setdef options lineHeight           -minversion 5        -validvalue {}                      -type num                -default 12
    setdef options backgroundColor      -minversion 5        -validvalue formatColor             -type e.color|str        -default "transparent"
    setdef options borderColor          -minversion 5        -validvalue formatColor             -type str|null           -default "nothing"
    setdef options borderWidth          -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options borderType           -minversion 5        -validvalue formatBorderType        -type str|num|list.n     -default "solid"
    setdef options borderDashOffset     -minversion 5        -validvalue {}                      -type num|null           -default 0
    setdef options borderRadius         -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options padding              -minversion 5        -validvalue {}                      -type num|list.n         -default 0
    setdef options shadowColor          -minversion 5        -validvalue formatColor             -type str                -default "transparent"
    setdef options shadowBlur           -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options shadowOffsetX        -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options shadowOffsetY        -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options width                -minversion 5        -validvalue {}                      -type num|null           -default "nothing"
    setdef options height               -minversion 5        -validvalue {}                      -type num|null           -default "nothing"
    setdef options textBorderColor      -minversion 5        -validvalue formatColor             -type str|null           -default "null"
    setdef options textBorderWidth      -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options textBorderType       -minversion 5        -validvalue formatTextBorderType    -type str|num|list.n     -default "solid"
    setdef options textBorderDashOffset -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options textShadowColor      -minversion 5        -validvalue formatColor             -type str                -default "transparent"
    setdef options textShadowBlur       -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options textShadowOffsetX    -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options textShadowOffsetY    -minversion 5        -validvalue {}                      -type num                -default 0
    setdef options overflow             -minversion 5        -validvalue formatOverflow          -type str                -default "none"
    setdef options ellipsis             -minversion 5        -validvalue {}                      -type str                -default "..."
    setdef options rich                 -minversion 5        -validvalue {}                      -type dict|struct|null   -default [ticklecharts::richItem $d]
    setdef options silent               -minversion "5.6.0"  -validvalue {}                      -type bool               -default "False"
    #...

    # remove key(s) from dict value rich...
    set d [dict remove $d richitem richItem]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::ariaDecal {value} {

    if {![ticklecharts::keyDictExists "decal" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show    -minversion 5  -validvalue {}      -type bool       -default "True"
    setdef options decals  -minversion 5  -validvalue {}      -type dict|null  -default [ticklecharts::ariaDecals $d]
    #...

    # remove key(s)...
    set d [dict remove $d decals]

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::ariaDecals {value} {

    if {![ticklecharts::keyDictExists "decals" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options symbol           -minversion 5  -validvalue formatItemSymbol      -type str|list.s   -default "rect"
    setdef options symbolSize       -minversion 5  -validvalue formatRangeSymbolSize -type num          -default 1
    setdef options symbolKeepAspect -minversion 5  -validvalue {}                    -type bool         -default "True"
    setdef options color            -minversion 5  -validvalue {}                    -type str          -default "rgba(0, 0, 0, 0.2)"
    setdef options backgroundColor  -minversion 5  -validvalue {}                    -type str|null     -default "nothing"
    setdef options dashArrayX       -minversion 5  -validvalue {}                    -type num|list.n   -default 5
    setdef options dashArrayY       -minversion 5  -validvalue {}                    -type num|list.n   -default 5
    setdef options rotation         -minversion 5  -validvalue formatRangeRotation   -type num|null     -default "nothing"
    setdef options maxTileWidth     -minversion 5  -validvalue {}                    -type num          -default 512
    setdef options maxTileHeight    -minversion 5  -validvalue {}                    -type num          -default 512
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::ariaLabel {value} {

    if {![ticklecharts::keyDictExists "label" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options enabled      -minversion 5  -validvalue {}      -type bool       -default "True"
    setdef options description  -minversion 5  -validvalue {}      -type str|null   -default "nothing"
    setdef options general      -minversion 5  -validvalue {}      -type dict|null  -default [ticklecharts::ariaGeneral $d]
    setdef options series       -minversion 5  -validvalue {}      -type dict|null  -default [ticklecharts::ariaLabelSeries $d]
    setdef options data         -minversion 5  -validvalue {}      -type dict|null  -default [ticklecharts::ariaData $d]
    #...

    # remove key(s)...
    set d [dict remove $d general series data]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::ariaData {value} {

    if {![ticklecharts::keyDictExists "data" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options maxCount             -minversion 5        -validvalue {}  -type num           -default 10
    setdef options allData              -minversion 5        -validvalue {}  -type str|null      -default "nothing"
    setdef options partialData          -minversion 5        -validvalue {}  -type str|null      -default "nothing"
    setdef options withName             -minversion 5        -validvalue {}  -type str|null      -default "nothing"
    setdef options withoutName          -minversion 5        -validvalue {}  -type str|null      -default "nothing"
    setdef options excludeDimensionId   -minversion "5.6.0"  -validvalue {}  -type list.d|null   -default "nothing"
    setdef options separator            -minversion 5        -validvalue {}  -type dict|null     -default [ticklecharts::ariaSeparator $d]
    #...

    # remove key(s)...
    set d [dict remove $d separator]

    set options [merge $options $d]

    return [new edict $options]
}


proc ticklecharts::ariaGeneral {value} {

    if {![ticklecharts::keyDictExists "general" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options withTitle     -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    setdef options withoutTitle  -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::ariaLabelSeries {value} {

    if {![ticklecharts::keyDictExists "series" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options maxCount  -minversion 5  -validvalue {}  -type num        -default 10
    setdef options single    -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::ariaSeriesSingle $d]
    setdef options multiple  -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::ariaSeriesMultiple $d]
    #...

    # remove key(s)...
    set d [dict remove $d single multiple]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::ariaSeriesSingle {value} {

    if {![ticklecharts::keyDictExists "single" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options prefix        -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    setdef options withName      -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    setdef options withoutName   -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::ariaSeriesMultiple {value} {

    if {![ticklecharts::keyDictExists "multiple" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options prefix        -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    setdef options withName      -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    setdef options withoutName   -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    setdef options separator     -minversion 5  -validvalue {}  -type dict|null  -default [ticklecharts::ariaSeparator $d]
    #...

    # remove key(s)...
    set d [dict remove $d separator]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::ariaSeparator {value} {

    if {![ticklecharts::keyDictExists "separator" $value key]} {
        return "nothing"
    }

    set levelP [ticklecharts::getLevelProperties [info level]]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    if {![infoNameProc $levelP "*ariaSeriesMultiple*"]} {
        setdef options middle  -minversion 5  -validvalue {}  -type str   -default ","
        setdef options end     -minversion 5  -validvalue {}  -type str   -default ""
    } else {
        setdef options middle  -minversion 5  -validvalue {}  -type str   -default ";"
        setdef options end     -minversion 5  -validvalue {}  -type str   -default "."
    }
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::effect {value} {

    if {![ticklecharts::keyDictExists "effect" $value key]} {
        return "nothing"
    }

    set levelP [ticklecharts::getLevelProperties [info level]]

    set symbol [expr {[keysOptsThemeExists $levelP.symbol] ? [echartsOptsTheme $levelP.symbol] : "nothing"}]

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show          -minversion 5        -validvalue {}                      -type bool              -default "False"
    setdef options period        -minversion 5        -validvalue {}                      -type num               -default 4
    setdef options delay         -minversion 5        -validvalue {}                      -type num|jsfunc|null   -default "nothing"
    setdef options constantSpeed -minversion 5        -validvalue {}                      -type num|null          -default "nothing"
    setdef options symbol        -minversion 5        -validvalue formatItemSymbol        -type str.t|null        -default $symbol
    setdef options symbolSize    -minversion 5        -validvalue {}                      -type num|list.n|null   -default 3
    setdef options color         -minversion 5        -validvalue formatColor             -type str|null          -default "nothing"
    setdef options trailLength   -minversion 5        -validvalue formatRangeTrailLength  -type num               -default 0.2
    setdef options loop          -minversion 5        -validvalue {}                      -type bool              -default "True"
    setdef options roundTrip     -minversion "5.4.0"  -validvalue {}                      -type bool|null         -default "nothing"
    #...

    # Switch not necessary properties for default dictionary
    # to 'nothing' if this key below is false.
    ticklecharts::IsItTrue? "show" -value d -dopts options -remove "not_needed"

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::mapGStyle {value} {

    if {![ticklecharts::keyDictExists "styles" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options featureType  -minversion {}  -validvalue {}  -type str|null     -default "nothing"
        setdef options elementType  -minversion {}  -validvalue {}  -type str|null     -default "nothing"
        setdef options stylers      -minversion {}  -validvalue {}  -type list.o|null  -default [ticklecharts::stylers $item]

        # remove key(s)...
        set item [dict remove $item stylers]

        lappend opts [merge $options $item]
        set options {}

    }

    return [list {*}$opts]
}

proc ticklecharts::stylers {value} {

    if {![ticklecharts::keyDictExists "stylers" $value key]} {
        return "nothing"
    }

    foreach item [dict get $value $key] {

        if {[llength $item] % 2} ticklecharts::errorEvenArgs

        setdef options color      -minversion {}  -validvalue formatColor  -type str|null -default "nothing"
        setdef options visibility -minversion {}  -validvalue {}           -type str|null -default "nothing"
        setdef options saturation -minversion {}  -validvalue {}           -type num|null -default "nothing"
        setdef options hue        -minversion {}  -validvalue formatColor  -type str|null -default "nothing"
        setdef options gamma      -minversion {}  -validvalue {}           -type num|null -default "nothing"
        setdef options lightness  -minversion {}  -validvalue {}           -type num|null -default "nothing"
        setdef options weight     -minversion {}  -validvalue {}           -type num|null -default "nothing"

        lappend opts [merge $options $item]
        set options {}

    }

   return [list {*}$opts]
}

proc ticklecharts::nameTruncate {value} {

    if {![ticklecharts::keyDictExists "nameTruncate" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options maxWidth      -minversion 5  -validvalue {}  -type num|null   -default "nothing"
    setdef options ellipsis      -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    setdef options placeholder   -minversion 5  -validvalue {}  -type str|null   -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::handleLabel {value} {

    if {![ticklecharts::keyDictExists "handleLabel" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show  -minversion "5.6.0"  -validvalue {}  -type bool  -default "False"
    #...

    set options [merge $options $d]

    return [new edict $options]
}