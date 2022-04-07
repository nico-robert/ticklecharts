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

    setdef options -backgroundColor         -validvalue formatColor   -type str|jsfunc|null -default [EchartsOptsTheme backgroundColor]
    setdef options -color                   -validvalue formatColor   -type list.s|null     -default [EchartsOptsTheme color]
    setdef options -animation               -validvalue {}            -type bool|str|null   -default "True"
    setdef options -animationDuration       -validvalue {}            -type num|null        -default 1000
    setdef options -animationDurationUpdate -validvalue {}            -type num|null        -default 500
    setdef options -animationEasing         -validvalue formatAEasing -type str|null        -default "cubicInOut"
    setdef options -animationEasingUpdate   -validvalue formatAEasing -type str|null        -default "cubicInOut"
    setdef options -animationThreshold      -validvalue {}            -type num|null        -default 2000
    setdef options -progressiveThreshold    -validvalue {}            -type num|null        -default 3000

    set options [merge $options $value]

    return $options

}

proc ticklecharts::htmloptions {value} { 
    # Global options chart
    #
    # value - Options described below.
    #
    # see file chart.tcl (method render)

    setdef options -title      -validvalue {}             -type str.n     -default "ticklEcharts !!!"
    setdef options -width      -validvalue {}             -type str.n|num -default "900px"
    setdef options -height     -validvalue {}             -type str.n|num -default "500px"
    setdef options -render     -validvalue formatRenderer -type str.n     -default "canvas"
    setdef options -jschartvar -validvalue {}             -type str.n     -default [format "chart_%s" [clock clicks]]
    setdef options -divid      -validvalue {}             -type str.n     -default [format "id_%s"    [clock clicks]]
    setdef options -outfile    -validvalue {}             -type str.n     -default [file join [file dirname [info script]] render.html]
    setdef options -jsecharts  -validvalue {}             -type str.n     -default $::ticklecharts::script
    setdef options -jsvar      -validvalue {}             -type str.n     -default "option"

    set options [merge $options $value]
    
    return $options

}

proc ticklecharts::title {value} {
    # options : https://echarts.apache.org/en/option.html#title
    #
    # value - Options described in proc ticklecharts::title below.
    #
    # return dict title options

    set d [dict get $value -title]

    setdef options id                -validvalue {}                      -type str|null   -default "nothing"
    setdef options show              -validvalue {}                      -type bool       -default "True"
    setdef options text              -validvalue {}                      -type str|null   -default "nothing"
    setdef options link              -validvalue {}                      -type str|null   -default "nothing"
    setdef options target            -validvalue formatTarget            -type str        -default "blank"
    setdef options textStyle         -validvalue {}                      -type dict|null  -default [ticklecharts::textStyle $d textStyle]
    setdef options subtext           -validvalue {}                      -type str|null   -default "nothing"
    setdef options sublink           -validvalue {}                      -type str|null   -default "nothing"
    setdef options subtarget         -validvalue formatTarget            -type str        -default "blank"
    setdef options subtextStyle      -validvalue {}                      -type dict|null  -default [ticklecharts::textStyle $d subtextStyle]
    setdef options textAlign         -validvalue formatTextAlign         -type str|null   -default "null"
    setdef options textVerticalAlign -validvalue formatVerticalTextAlign -type str        -default "auto"
    setdef options triggerEvent      -validvalue {}                      -type bool|null  -default "nothing"
    setdef options padding           -validvalue {}                      -type num|list.n -default 5
    setdef options itemGap           -validvalue {}                      -type num        -default 10
    setdef options zlevel            -validvalue {}                      -type num|null   -default "nothing"
    setdef options z                 -validvalue {}                      -type num        -default 2
    setdef options left              -validvalue formatLeft              -type str|num    -default "auto"
    setdef options top               -validvalue formatTop               -type str|num    -default "auto"
    setdef options right             -validvalue formatRight             -type str|num    -default "auto"
    setdef options bottom            -validvalue formatBottom            -type str|num    -default "auto"
    setdef options backgroundColor   -validvalue formatColor             -type str        -default "transparent"
    setdef options borderColor       -validvalue formatColor             -type str        -default "transparent"
    setdef options borderWidth       -validvalue {}                      -type num        -default 1
    setdef options borderRadius      -validvalue {}                      -type num|list.n -default 0
    setdef options shadowBlur        -validvalue {}                      -type num|null   -default "nothing"
    setdef options shadowColor       -validvalue formatColor             -type str|null   -default "nothing"
    setdef options shadowOffsetX     -validvalue {}                      -type num|null   -default "nothing"
    setdef options shadowOffsetY     -validvalue {}                      -type num|null   -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::grid {value} {
    # options : https://echarts.apache.org/en/option.html#grid
    #
    # value - Options described in proc ticklecharts::grid below.
    #
    # return dict grid options

    set d [dict get $value -grid]

    setdef options id              -validvalue {}           -type str|null     -default "nothing"
    setdef options show            -validvalue {}           -type bool|null    -default "nothing"
    setdef options zlevel          -validvalue {}           -type num|null     -default "nothing"
    setdef options z               -validvalue {}           -type num|null     -default "nothing"
    setdef options left            -validvalue formatLeft   -type str|num|null -default "nothing"
    setdef options top             -validvalue formatTop    -type str|num|null -default "nothing"
    setdef options right           -validvalue formatRight  -type str|num|null -default "nothing"
    setdef options bottom          -validvalue formatBottom -type str|num|null -default "nothing"
    setdef options width           -validvalue {}           -type str|num|null -default "nothing"
    setdef options height          -validvalue {}           -type str|num|null -default "nothing"
    setdef options containLabel    -validvalue {}           -type bool|null    -default "nothing"
    setdef options backgroundColor -validvalue formatColor  -type str|null     -default "nothing"
    setdef options borderColor     -validvalue formatColor  -type str|null     -default "nothing"
    setdef options borderWidth     -validvalue {}           -type num|null     -default "nothing"
    setdef options shadowBlur      -validvalue {}           -type num|null     -default "nothing"
    setdef options shadowColor     -validvalue formatColor  -type str|null     -default "nothing"
    setdef options shadowOffsetX   -validvalue {}           -type num|null     -default "nothing"
    setdef options shadowOffsetY   -validvalue {}           -type num|null     -default "nothing"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::tooltip {value} {
    # options : https://echarts.apache.org/en/option.html#tooltip
    #
    # value - Options described in proc ticklecharts::tooltip below.
    #
    # return dict tooltip options

    set d [dict get $value -tooltip]

    setdef options show               -validvalue {}               -type bool                   -default "True"
    setdef options trigger            -validvalue formatTrigger    -type str|null               -default "item"
    setdef options axisPointer        -validvalue {}               -type dict|null              -default [ticklecharts::axisPointer $d]
    setdef options showContent        -validvalue {}               -type bool                   -default "True"
    setdef options alwaysShowContent  -validvalue {}               -type bool|null              -default "False"
    setdef options triggerOn          -validvalue formatTriggerOn  -type str                    -default "mousemove|click"
    setdef options showDelay          -validvalue {}               -type num|null               -default "nothing"
    setdef options hideDelay          -validvalue {}               -type num|null               -default "nothing"
    setdef options enterable          -validvalue {}               -type bool|null              -default "nothing"
    setdef options renderMode         -validvalue formatRenderMode -type str|null               -default "nothing"
    setdef options confine            -validvalue formatConfine    -type bool|null              -default "nothing"
    setdef options appendToBody       -validvalue {}               -type bool|null              -default "nothing"
    setdef options className          -validvalue {}               -type str|null               -default "nothing"
    setdef options transitionDuration -validvalue {}               -type num|null               -default 0.4
    setdef options position           -validvalue formatPosition   -type str|list.d|jsfunc|null -default "nothing"
    setdef options formatter          -validvalue {}               -type str|jsfunc|null        -default "nothing"
    setdef options valueFormatter     -validvalue {}               -type str|jsfunc|null        -default "nothing"
    setdef options backgroundColor    -validvalue formatColor      -type str|null               -default "nothing"
    setdef options borderColor        -validvalue formatColor      -type str|null               -default "nothing"
    setdef options borderWidth        -validvalue {}               -type num|null               -default "nothing"
    setdef options padding            -validvalue {}               -type num|list.n|null        -default 5
    setdef options textStyle          -validvalue {}               -type dict|null              -default [ticklecharts::textStyle $d textStyle]
    setdef options extraCssText       -validvalue {}               -type str|null               -default "nothing"
    setdef options order              -validvalue formatOrder      -type str|null               -default "seriesAsc"
    #...

    set options [merge $options $d]

    return $options

}

proc ticklecharts::legend {value} {
    # options : https://echarts.apache.org/en/option.html#legend
    #
    # value - Options described in proc ticklecharts::legend below.
    #
    # return dict legend options

    set d [dict get $value -legend]

    setdef options type                  -validvalue formatLegendType      -type str             -default "plain"
    setdef options id                    -validvalue {}                    -type str|null        -default "nothing"
    setdef options show                  -validvalue {}                    -type bool            -default "True"
    setdef options zlevel                -validvalue {}                    -type num|null        -default "nothing"
    setdef options z                     -validvalue {}                    -type num             -default 2
    setdef options left                  -validvalue formatLeft            -type str|num|null    -default "center"
    setdef options top                   -validvalue formatTop             -type str|num|null    -default "auto"
    setdef options right                 -validvalue formatRight           -type str|num|null    -default "auto"
    setdef options bottom                -validvalue {}                    -type str|num|null    -default "auto"
    setdef options width                 -validvalue {}                    -type str|num|null    -default "auto"
    setdef options height                -validvalue {}                    -type str|num|null    -default "auto"
    setdef options orient                -validvalue formatOrient          -type str             -default "horizontal"
    setdef options align                 -validvalue formatAlign           -type str             -default "auto"
    setdef options padding               -validvalue {}                    -type num|list.n      -default 5
    setdef options itemGap               -validvalue {}                    -type num             -default 10
    setdef options itemWidth             -validvalue {}                    -type num             -default 25
    setdef options itemHeight            -validvalue {}                    -type num             -default 14
    setdef options itemStyle             -validvalue {}                    -type dict|null       -default [ticklecharts::itemStyle $d]
    setdef options lineStyle             -validvalue {}                    -type dict|null       -default [ticklecharts::lineStyle $d]
    setdef options symbolRotate          -validvalue {}                    -type str|num         -default "inherit"
    setdef options formatter             -validvalue {}                    -type str|jsfunc|null -default "nothing"
    setdef options selectedMode          -validvalue {}                    -type bool|str        -default "True"
    setdef options inactiveColor         -validvalue formatColor           -type str             -default "rgb(204, 204, 204)"
    setdef options inactiveBorderColor   -validvalue formatColor           -type str             -default "rgb(204, 204, 204)"
    setdef options inactiveBorderWidth   -validvalue formatColor           -type str             -default "auto"
    setdef options selected              -validvalue {}                    -type jsfunc|null     -default "nothing"
    setdef options textStyle             -validvalue {}                    -type dict|null       -default [ticklecharts::textStyle $d textStyle]
    setdef options icon                  -validvalue {}                    -type str|null        -default "nothing"
    setdef options backgroundColor       -validvalue formatColor           -type str|null        -default "transparent"
    setdef options borderWidth           -validvalue {}                    -type num             -default 0
    setdef options borderRadius          -validvalue {}                    -type num             -default 0
    setdef options shadowBlur            -validvalue {}                    -type num|null        -default "nothing"
    setdef options shadowColor           -validvalue formatColor           -type str|null        -default "nothing"
    setdef options shadowOffsetX         -validvalue {}                    -type num|null        -default "nothing"
    setdef options shadowOffsetY         -validvalue {}                    -type num|null        -default "nothing"
    setdef options scrollDataIndex       -validvalue {}                    -type num|null        -default "nothing"
    setdef options pageButtonItemGap     -validvalue {}                    -type num             -default 5
    setdef options pageButtonGap         -validvalue {}                    -type num|null        -default "nothing"
    setdef options pageButtonPosition    -validvalue formatPButtonPosition -type str|null        -default "nothing"
    setdef options pageFormatter         -validvalue {}                    -type str|jsfunc|null -default "nothing"
    setdef options pageIconColor         -validvalue formatColor           -type str             -default "rgb(47, 69, 84)"
    setdef options pageIconInactiveColor -validvalue formatColor           -type str             -default "rgb(170, 170, 170)"
    setdef options pageIconSize          -validvalue {}                    -type num|list.n      -default 15
    
    # not fully supported...
    setdef options data                  -validvalue {}                    -type list.d|null     -default "nothing"
    #...

    if {[dict exists $d dataLegendItem]} {
        set options [dict remove $options data]
        setdef options data -validvalue {} -type list.o -default [ticklecharts::LegendItem $d]
    }

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::polar {value} {
    # options : https://echarts.apache.org/en/option.html#polar
    #
    # value - Options described in proc ticklecharts::polar below.
    #
    # return dict polar options

    set d [dict get $value -polar]

    setdef options id     -validvalue {} -type str|null            -default "nothing"
    setdef options zlevel -validvalue {} -type num|null            -default "nothing"
    setdef options z      -validvalue {} -type num                 -default 2
    setdef options center -validvalue {} -type list.d|null         -default "nothing"
    setdef options radius -validvalue {} -type str|num|list.d|null -default "nothing"
    #...

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::visualMap {value} {
    # options : https://echarts.apache.org/en/option.html#visualMap
    #
    # value - Options described in proc ticklecharts::visualMap below.
    #
    # return dict visualMap options

    set d [dict get $value -visualMap]

    if {![dict exists $d type]} {
        error "visualMap type shoud be specified... 'continuous' or 'piecewise'"
    }

    switch -exact -- [dict get $d type] {
        continuous {
            setdef options type            -validvalue {}                   -type str             -default [dict get $d type]
            setdef options id              -validvalue {}                   -type str|null        -default "nothing"
            setdef options min             -validvalue {}                   -type num|null        -default "nothing"
            setdef options max             -validvalue {}                   -type num|null        -default "nothing"
            setdef options range           -validvalue {}                   -type list.n|null     -default "nothing"
            setdef options calculable      -validvalue {}                   -type bool|null       -default "False"
            setdef options realtime        -validvalue {}                   -type bool|null       -default "True"
            setdef options inverse         -validvalue {}                   -type bool|null       -default "False"
            setdef options precision       -validvalue {}                   -type num|null        -default 0
            setdef options itemWidth       -validvalue {}                   -type num|null        -default 20
            setdef options itemHeight      -validvalue {}                   -type num|null        -default 140
            setdef options align           -validvalue formatVisualMapAlign -type str|null        -default "auto"
            setdef options text            -validvalue {}                   -type list.s|null     -default "nothing"
            setdef options textGap         -validvalue {}                   -type num|null        -default 10
            setdef options show            -validvalue {}                   -type bool            -default "True"
            setdef options dimension       -validvalue {}                   -type num|null        -default "nothing"
            setdef options seriesIndex     -validvalue {}                   -type num|list.d|null -default "nothing"
            setdef options hoverLink       -validvalue {}                   -type bool            -default "True"
            setdef options inRange         -validvalue {}                   -type dict|null       -default [ticklecharts::inRange $d]
            setdef options outOfRange      -validvalue {}                   -type dict|null       -default [ticklecharts::outOfRange $d]
            setdef options controller      -validvalue {}                   -type dict|null       -default [ticklecharts::controller $d]
            setdef options zlevel          -validvalue {}                   -type num             -default 0
            setdef options z               -validvalue {}                   -type num             -default 4
            setdef options left            -validvalue formatLeft           -type num|str|null    -default "auto"
            setdef options top             -validvalue formatTop            -type num|str|null    -default "auto"
            setdef options right           -validvalue formatRight          -type num|str|null    -default "auto"
            setdef options bottom          -validvalue formatBottom         -type num|str|null    -default "auto"
            setdef options orient          -validvalue formatOrient         -type str             -default "vertical"
            setdef options padding         -validvalue {}                   -type list.n|num      -default 5
            setdef options backgroundColor -validvalue formatColor          -type str             -default "rgba(0,0,0,0)"
            setdef options borderColor     -validvalue formatColor          -type str             -default "#ccc"
            setdef options borderWidth     -validvalue {}                   -type num             -default 0
            setdef options color           -validvalue formatColor          -type list.s|null     -default "nothing"
            setdef options textStyle       -validvalue {}                   -type dict|null       -default [ticklecharts::textStyle $d textStyle]
            setdef options formatter       -validvalue {}                   -type str|jsfunc|null -default "nothing"
            setdef options handleIcon      -validvalue {}                   -type str|null        -default "nothing"
            setdef options handleSize      -validvalue {}                   -type str|num|null    -default "120%"
            setdef options handleStyle     -validvalue {}                   -type dict|null       -default [ticklecharts::handleStyle $d]
            setdef options indicatorIcon   -validvalue {}                   -type str|null        -default "circle"
            setdef options indicatorSize   -validvalue {}                   -type str|num|null    -default "50%"
            setdef options indicatorStyle  -validvalue {}                   -type dict|null       -default [ticklecharts::indicatorStyle $d]
            #...
        }
        piecewise {
            setdef options type            -validvalue {}                   -type str             -default [dict get $d type]
            setdef options id              -validvalue {}                   -type str|null        -default "nothing"
            setdef options splitNumber     -validvalue {}                   -type num|null        -default 5
            setdef options pieces          -validvalue {}                   -type list.o|null     -default [ticklecharts::piecesItem $d]
            setdef options categories      -validvalue {}                   -type list.s|null     -default "nothing"
            setdef options min             -validvalue {}                   -type num|null        -default "nothing"
            setdef options max             -validvalue {}                   -type num|null        -default "nothing"
            setdef options minOpen         -validvalue {}                   -type bool|null       -default "nothing"
            setdef options maxOpen         -validvalue {}                   -type bool|null       -default "nothing"
            setdef options selectedMode    -validvalue formatSelectedMode   -type str|null        -default "multiple"
            setdef options inverse         -validvalue {}                   -type bool|null       -default "False"
            setdef options precision       -validvalue {}                   -type num|null        -default 0
            setdef options itemWidth       -validvalue {}                   -type num|null        -default 20
            setdef options itemHeight      -validvalue {}                   -type num|null        -default 14
            setdef options align           -validvalue formatVisualMapAlign -type str|null        -default "auto"
            setdef options text            -validvalue {}                   -type list.s|null     -default "nothing"
            setdef options textGap         -validvalue {}                   -type num|null        -default 10
            setdef options showLabel       -validvalue {}                   -type bool|null       -default "nothing"
            setdef options itemGap         -validvalue {}                   -type num|null        -default 10
            setdef options itemSymbol      -validvalue formatItemSymbol     -type str|null        -default "roundRect"
            setdef options show            -validvalue {}                   -type bool            -default "True"
            setdef options dimension       -validvalue {}                   -type num|null        -default "nothing"
            setdef options seriesIndex     -validvalue {}                   -type num|list.d|null -default "nothing"
            setdef options hoverLink       -validvalue {}                   -type bool            -default "True"
            setdef options inRange         -validvalue {}                   -type dict|null       -default [ticklecharts::inRange $d]
            setdef options outOfRange      -validvalue {}                   -type dict|null       -default [ticklecharts::outOfRange $d]
            setdef options controller      -validvalue {}                   -type dict|null       -default [ticklecharts::controller $d]
            setdef options zlevel          -validvalue {}                   -type num             -default 0
            setdef options z               -validvalue {}                   -type num             -default 4
            setdef options left            -validvalue formatLeft           -type num|str|null    -default "auto"
            setdef options top             -validvalue formatTop            -type num|str|null    -default "auto"
            setdef options right           -validvalue formatRight          -type num|str|null    -default "auto"
            setdef options bottom          -validvalue formatBottom         -type num|str|null    -default "auto"
            setdef options padding         -validvalue {}                   -type list.n|num      -default 5
            setdef options backgroundColor -validvalue formatColor          -type str             -default "rgba(0,0,0,0)"
            setdef options borderColor     -validvalue formatColor          -type str             -default "#ccc"
            setdef options borderWidth     -validvalue {}                   -type num             -default 0
            setdef options color           -validvalue formatColor          -type list.s|null     -default "nothing"
            setdef options textStyle       -validvalue {}                   -type dict|null       -default [ticklecharts::textStyle $d textStyle]
            setdef options formatter       -validvalue {}                   -type str|jsfunc|null -default "nothing"
            #...
        }
        default {
            error "Type name shoud be 'continuous' or 'piecewise'"
        }
    }
    
    # remove key
    set d [dict remove $d pieces]
    #...

    set options [merge $options $d]
    
    return $options

}

proc ticklecharts::toolbox {value} {
    # options : https://echarts.apache.org/en/option.html#toolbox
    #
    # value - Options described in proc ticklecharts::toolbox below.
    #
    # return dict toolbox options

    set d [dict get $value -toolbox]

    setdef options id         -validvalue {}           -type str|null      -default "nothing"
    setdef options show       -validvalue {}           -type bool          -default "True"
    setdef options orient     -validvalue formatOrient -type str           -default "horizontal"
    setdef options itemSize   -validvalue {}           -type num           -default 15
    setdef options itemGap    -validvalue {}           -type num           -default 10
    setdef options showTitle  -validvalue {}           -type bool          -default "True"
    setdef options feature    -validvalue {}           -type dict|null     -default [ticklecharts::feature $d]
    setdef options iconStyle  -validvalue {}           -type dict|null     -default [ticklecharts::iconStyle $d "toolbox"]
    setdef options emphasis   -validvalue {}           -type dict|null     -default [ticklecharts::iconEmphasis $d]
    setdef options zlevel     -validvalue {}           -type num|null      -default "nothing"
    setdef options z          -validvalue {}           -type num           -default 2
    setdef options left       -validvalue formatLeft   -type str|num|null  -default "nothing"
    setdef options top        -validvalue formatTop    -type str|num|null  -default "auto"
    setdef options right      -validvalue formatRight  -type str|num|null  -default "auto"
    setdef options bottom     -validvalue formatBottom -type str|num|null  -default "nothing"
    setdef options width      -validvalue {}           -type str|num|null  -default "auto"
    setdef options height     -validvalue {}           -type str|num|null  -default "auto"
    # not supported yet...
    # setdef options tooltip  -validvalue {} -type dict|null     -default "nothing"
    
    
    # remove key
    set d [dict remove $d feature iconStyle emphasis]
    #...

    set options [merge $options $d]
    
    return $options

}
