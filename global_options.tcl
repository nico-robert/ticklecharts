# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::globaloptions {value} {
    # Global options chart
    #
    # value - Options described below.
    #
    # - backgroundColor         - https://echarts.apache.org/en/option.html#backgroundColor
    # - color                   - https://echarts.apache.org/en/option.html#color
    # - animation               - https://echarts.apache.org/en/option.html#animation
    # - animationDuration       - https://echarts.apache.org/en/option.html#animationDuration
    # - animationDurationUpdate - https://echarts.apache.org/en/option.html#animationDurationUpdate
    # - animationEasing         - https://echarts.apache.org/en/option.html#animationEasing
    # - animationEasingUpdate   - https://echarts.apache.org/en/option.html#animationEasingUpdate
    # - animationThreshold      - https://echarts.apache.org/en/option.html#animationThreshold
    # - progressiveThreshold    - https://echarts.apache.org/en/option.html#progressiveThreshold
    #
    # return dict options

    setdef options -backgroundColor         -type str|jsfunc|null -default [dict get $::ticklecharts::opts_theme backgroundColor]
    setdef options -color                   -type list.s|null     -default [dict get $::ticklecharts::opts_theme color]
    setdef options -animation               -type bool|str|null   -default "True"
    setdef options -animationDuration       -type num|null        -default 1000
    setdef options -animationDurationUpdate -type num|null        -default 500
    setdef options -animationEasing         -type str|null        -default "cubicInOut"
    setdef options -animationEasingUpdate   -type str|null        -default "cubicInOut"
    setdef options -animationThreshold      -type num|null        -default 2000
    setdef options -progressiveThreshold    -type num|null        -default 3000

    set options [merge $options $value]

    return $options

}

proc ticklecharts::htmloptions {value} { 
    # Global options chart
    #
    # value - Options described below.
    #
    # see file chart.tcl (method render)

    setdef options -title      -type str.n     -default "ticklEcharts !!!"
    setdef options -width      -type str.n|num -default "900px"
    setdef options -height     -type str.n|num -default "500px"
    setdef options -render     -type str.n     -default "canvas"
    setdef options -jschartvar -type str.n     -default [format "chart_%s" [clock clicks]]
    setdef options -divid      -type str.n     -default [format "id_%s"    [clock clicks]]
    setdef options -outfile    -type str.n     -default [file join [file dirname [info script]] render.html]
    setdef options -jsecharts  -type str.n     -default $::ticklecharts::script
    setdef options -jsvar      -type str.n     -default "option"

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::title {value} {
    # options : https://echarts.apache.org/en/option.html#title
    #
    # value - Options described in proc ticklecharts::title below.
    #
    # return dict title options

    set dico [dict get $value -title]

    setdef options id                -type str|null   -default "nothing"
    setdef options show              -type bool       -default "True"
    setdef options text              -type str|null   -default "nothing"
    setdef options link              -type str|null   -default "nothing"
    setdef options target            -type str        -default "blank"
    setdef options textStyle         -type dict|null  -default [ticklecharts::textStyle $dico textStyle]
    setdef options subtext           -type str|null   -default "nothing"
    setdef options sublink           -type str|null   -default "nothing"
    setdef options subtarget         -type str        -default "blank"
    setdef options subtextStyle      -type dict|null  -default [ticklecharts::textStyle $dico subtextStyle]
    setdef options textAlign         -type str|null   -default "null"
    setdef options textVerticalAlign -type str        -default "auto"
    setdef options triggerEvent      -type bool|null  -default "nothing"
    setdef options padding           -type num|list.n -default 5
    setdef options itemGap           -type num        -default 10
    setdef options zlevel            -type num|null   -default "nothing"
    setdef options z                 -type num        -default 2
    setdef options left              -type str|num    -default "auto"
    setdef options top               -type str|num    -default "auto"
    setdef options right             -type str|num    -default "auto"
    setdef options bottom            -type str|num    -default "auto"
    setdef options backgroundColor   -type str        -default "transparent"
    setdef options borderColor       -type str        -default "transparent"
    setdef options borderWidth       -type num        -default 1
    setdef options borderRadius      -type num|list.n -default 0
    setdef options shadowBlur        -type num|null   -default "nothing"
    setdef options shadowColor       -type str|null   -default "nothing"
    setdef options shadowOffsetX     -type num|null   -default "nothing"
    setdef options shadowOffsetY     -type num|null   -default "nothing"
    #...

    set options [merge $options $dico]

    return $options

}

proc ticklecharts::grid {value} {
    # options : https://echarts.apache.org/en/option.html#grid
    #
    # value - Options described in proc ticklecharts::grid below.
    #
    # return dict grid options

    set dico [dict get $value -grid]

    setdef options id                -type str|null     -default "nothing"
    setdef options show              -type bool|null    -default "nothing"
    setdef options zlevel            -type num|null     -default "nothing"
    setdef options z                 -type num|null     -default "nothing"
    setdef options left              -type str|num|null -default "nothing"
    setdef options top               -type str|num|null -default "nothing"
    setdef options right             -type str|num|null -default "nothing"
    setdef options bottom            -type str|num|null -default "nothing"
    setdef options width             -type str|num|null -default "nothing"
    setdef options height            -type str|num|null -default "nothing"
    setdef options containLabel      -type bool|null    -default "nothing"
    setdef options backgroundColor   -type str|null     -default "nothing"
    setdef options borderColor       -type str|null     -default "nothing"
    setdef options borderWidth       -type num|null     -default "nothing"
    setdef options shadowBlur        -type num|null     -default "nothing"
    setdef options shadowColor       -type str|null     -default "nothing"
    setdef options shadowOffsetX     -type num|null     -default "nothing"
    setdef options shadowOffsetY     -type num|null     -default "nothing"
    #...

    set options [merge $options $dico]

    return $options

}

proc ticklecharts::tooltip {value} {
    # options : https://echarts.apache.org/en/option.html#tooltip
    #
    # value - Options described in proc ticklecharts::tooltip below.
    #
    # return dict tooltip options

    set dico [dict get $value -tooltip]

    setdef options show               -type bool                   -default "True"
    setdef options trigger            -type str|null               -default "item"
    setdef options axisPointer        -type dict|null              -default [ticklecharts::axisPointer $dico]
    setdef options showContent        -type bool                   -default "True"
    setdef options alwaysShowContent  -type bool|null              -default "False"
    setdef options triggerOn          -type str                    -default "mousemove|click"
    setdef options showDelay          -type num|null               -default "nothing"
    setdef options hideDelay          -type num|null               -default "nothing"
    setdef options enterable          -type bool|null              -default "nothing"
    setdef options renderMode         -type str|null               -default "nothing"
    setdef options confine            -type bool|null              -default "nothing"
    setdef options appendToBody       -type bool|null              -default "nothing"
    setdef options className          -type str|null               -default "nothing"
    setdef options transitionDuration -type num|null               -default 0.4
    setdef options position           -type str|list.d|jsfunc|null -default "nothing"
    setdef options formatter          -type str|jsfunc|null        -default "nothing"
    setdef options valueFormatter     -type str|jsfunc|null        -default "nothing"
    setdef options backgroundColor    -type str|null               -default "nothing"
    setdef options borderColor        -type str|null               -default "nothing"
    setdef options borderWidth        -type num|null               -default "nothing"
    setdef options padding            -type num|list.n|null        -default 5
    setdef options textStyle          -type dict|null              -default [ticklecharts::textStyle $dico textStyle]
    setdef options extraCssText       -type str|null               -default "nothing"
    setdef options order              -type str|null               -default "seriesAsc"
    #...

    set options [merge $options $dico]

    return $options

}

proc ticklecharts::legend {value} {
    # options : https://echarts.apache.org/en/option.html#legend
    #
    # value - Options described in proc ticklecharts::legend below.
    #
    # return dict legend options

    set dico [dict get $value -legend]

    setdef options type                  -type str             -default "plain"
    setdef options id                    -type str|null        -default "nothing"
    setdef options show                  -type bool            -default "True"
    setdef options zlevel                -type num|null        -default "nothing"
    setdef options z                     -type num             -default 2
    setdef options left                  -type str|num|null    -default "center"
    setdef options top                   -type str|num|null    -default "auto"
    setdef options right                 -type str|num|null    -default "auto"
    setdef options bottom                -type str|num|null    -default "auto"
    setdef options width                 -type str|num|null    -default "auto"
    setdef options height                -type str|num|null    -default "auto"
    setdef options orient                -type str             -default "horizontal"
    setdef options align                 -type str             -default "auto"
    setdef options padding               -type num|list.n      -default 5
    setdef options itemGap               -type num             -default 10
    setdef options itemWidth             -type num             -default 25
    setdef options itemHeight            -type num             -default 14
    setdef options itemStyle             -type dict|null       -default [ticklecharts::itemStyle $dico]
    setdef options lineStyle             -type dict|null       -default [ticklecharts::lineStyle $dico]
    setdef options symbolRotate          -type str|num         -default "inherit"
    setdef options formatter             -type str|jsfunc|null -default "nothing"
    setdef options selectedMode          -type bool|str        -default "True"
    setdef options inactiveColor         -type str             -default "rgb(204, 204, 204)"
    setdef options inactiveBorderColor   -type str             -default "rgb(204, 204, 204)"
    setdef options inactiveBorderWidth   -type str             -default "auto"
    setdef options selected              -type jsfunc|null     -default "nothing"
    setdef options textStyle             -type dict|null       -default [ticklecharts::textStyle $dico textStyle]
    setdef options icon                  -type str|null        -default "nothing"
    setdef options backgroundColor       -type str|null        -default "transparent"
    setdef options borderWidth           -type num             -default 0
    setdef options borderRadius          -type num             -default 0
    setdef options shadowBlur            -type num|null        -default "nothing"
    setdef options shadowColor           -type str|null        -default "nothing"
    setdef options shadowOffsetX         -type num|null        -default "nothing"
    setdef options shadowOffsetY         -type num|null        -default "nothing"
    setdef options scrollDataIndex       -type num|null        -default "nothing"
    setdef options pageButtonItemGap     -type num             -default 5
    setdef options pageButtonGap         -type num|null        -default "nothing"
    setdef options pageButtonPosition    -type str|null        -default "nothing"
    setdef options pageFormatter         -type str|jsfunc|null -default "nothing"
    setdef options pageIconColor         -type str             -default "rgb(47, 69, 84)"
    setdef options pageIconInactiveColor -type str             -default "rgb(170, 170, 170)"
    setdef options pageIconSize          -type num|list.n      -default 15
    
    # not fully supported...
    setdef options data                  -type list.d|null     -default "nothing"
    #...

    set options [merge $options $dico]
    
    return $options

}

proc ticklecharts::polar {value} {
    # options : https://echarts.apache.org/en/option.html#polar
    #
    # value - Options described in proc ticklecharts::polar below.
    #
    # return dict polar options

    set dico [dict get $value -polar]

    setdef options id     -type str|null            -default "nothing"
    setdef options zlevel -type num|null            -default "nothing"
    setdef options z      -type num                 -default 2
    setdef options center -type list.d|null         -default "nothing"
    setdef options radius -type str|num|list.d|null -default "nothing"
    #...

    set options [merge $options $dico]
    
    return $options

}

proc ticklecharts::visualMap {value} {
    # options : https://echarts.apache.org/en/option.html#visualMap
    #
    # value - Options described in proc ticklecharts::visualMap below.
    #
    # return dict visualMap options

    set dico [dict get $value -visualMap]

    if {![dict exists $dico type]} {
        error "visualMap type shoud be specified... 'continuous' or 'piecewise'"
    }

    switch -exact -- [dict get $dico type] {
        continuous {
            setdef options type            -type str             -default [dict get $dico type]
            setdef options id              -type str|null        -default "nothing"
            setdef options min             -type num|null        -default "nothing"
            setdef options max             -type num|null        -default "nothing"
            setdef options range           -type list.n|null     -default "nothing"
            setdef options calculable      -type bool|null       -default "False"
            setdef options realtime        -type bool|null       -default "True"
            setdef options inverse         -type bool|null       -default "False"
            setdef options precision       -type num|null        -default 0
            setdef options itemWidth       -type num|null        -default 20
            setdef options itemHeight      -type num|null        -default 14
            setdef options align           -type str|null        -default "auto"
            setdef options text            -type list.s|null     -default "nothing"
            setdef options textGap         -type num|null        -default 10
            setdef options show            -type bool            -default "True"
            setdef options dimension       -type num|null        -default "nothing"
            setdef options seriesIndex     -type num|list.d|null -default "nothing"
            setdef options hoverLink       -type bool            -default "True"
            setdef options inRange         -type dict|null       -default [ticklecharts::inRange $dico]
            setdef options outOfRange      -type dict|null       -default [ticklecharts::outOfRange $dico]
            setdef options controller      -type dict|null       -default [ticklecharts::controller $dico]
            setdef options zlevel          -type num             -default 0
            setdef options z               -type num             -default 4
            setdef options left            -type num|str|null    -default "auto"
            setdef options top             -type num|str|null    -default "auto"
            setdef options right           -type num|str|null    -default "auto"
            setdef options bottom          -type num|str|null    -default "auto"
            setdef options padding         -type list.n|num      -default 5
            setdef options backgroundColor -type str             -default "rgba(0,0,0,0)"
            setdef options borderColor     -type str             -default "#ccc"
            setdef options borderWidth     -type num             -default 0
            setdef options color           -type list.s|null     -default "nothing"
            setdef options color           -type list.s|null     -default "nothing"
            setdef options textStyle       -type dict|null       -default [ticklecharts::textStyle $dico textStyle]
            setdef options formatter       -type str|jsfunc|null -default "nothing"
            setdef options handleIcon      -type str|null        -default "nothing"
            setdef options handleSize      -type str|num|null    -default "120%"
            setdef options handleStyle     -type dict|null       -default [ticklecharts::handleStyle $dico]
            setdef options indicatorIcon   -type str|null        -default "circle"
            setdef options indicatorSize   -type str|num|null    -default "50%"
            setdef options indicatorStyle  -type dict|null       -default [ticklecharts::indicatorStyle $dico]
            #...
        }
        piecewise {
            setdef options type            -type str             -default [dict get $dico type]
            setdef options id              -type str|null        -default "nothing"
            setdef options splitNumber     -type num|null        -default 5
            setdef options pieces          -type list.o|null     -default [ticklecharts::piecesItem $dico]
            setdef options min             -type num|null        -default "nothing"
            setdef options max             -type num|null        -default "nothing"
            setdef options minOpen         -type bool|null       -default "nothing"
            setdef options maxOpen         -type bool|null       -default "nothing"
            setdef options selectedMode    -type str|null        -default "multiple"
            setdef options inverse         -type bool|null       -default "False"
            setdef options precision       -type num|null        -default 0
            setdef options itemWidth       -type num|null        -default 20
            setdef options itemHeight      -type num|null        -default 14
            setdef options align           -type str|null        -default "auto"
            setdef options text            -type list.s|null     -default "nothing"
            setdef options textGap         -type num|null        -default 10
            setdef options showLabel       -type bool|null       -default "nothing"
            setdef options itemGap         -type num|null        -default 10
            setdef options itemSymbol      -type str|null        -default "roundRect"
            setdef options show            -type bool            -default "True"
            setdef options dimension       -type num|null        -default "nothing"
            setdef options seriesIndex     -type num|list.d|null -default "nothing"
            setdef options hoverLink       -type bool            -default "True"
            setdef options inRange         -type dict|null       -default [ticklecharts::inRange $dico]
            setdef options outOfRange      -type dict|null       -default [ticklecharts::outOfRange $dico]
            setdef options controller      -type dict|null       -default [ticklecharts::controller $dico]
            setdef options zlevel          -type num             -default 0
            setdef options z               -type num             -default 4
            setdef options left            -type num|str|null    -default "auto"
            setdef options top             -type num|str|null    -default "auto"
            setdef options right           -type num|str|null    -default "auto"
            setdef options bottom          -type num|str|null    -default "auto"
            setdef options padding         -type list.n|num      -default 5
            setdef options backgroundColor -type str             -default "rgba(0,0,0,0)"
            setdef options borderColor     -type str             -default "#ccc"
            setdef options borderWidth     -type num             -default 0
            setdef options color           -type list.s|null     -default "nothing"
            setdef options color           -type list.s|null     -default "nothing"
            setdef options textStyle       -type dict|null       -default [ticklecharts::textStyle $dico textStyle]
            setdef options formatter       -type str|jsfunc|null -default "nothing"
            #...
        }
        default {
            error "Type name shoud be 'continuous' or 'piecewise'"
        }
    }
    
    # remove key
    set dico [dict remove $dico pieces]
    #...

    set options [merge $options $dico]
    
    return $options

}
