# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::globalOptions {value} {
    # Global options chart
    #
    # value - Options described below.
    #
    # Returns dict options

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -darkMode                -minversion 5  -validvalue {}            -type bool.t|null               -trace no   -default [echartsOptsTheme darkMode]
    setdef options -backgroundColor         -minversion 5  -validvalue formatColor   -type str.t|jsfunc|e.color|null -trace no   -default [echartsOptsTheme backgroundColor]
    setdef options -color                   -minversion 5  -validvalue formatColor   -type list.st|e.color|null      -trace no   -default [echartsOptsTheme color]
    setdef options -animation               -minversion 5  -validvalue {}            -type bool|null                 -trace yes  -default "True"
    setdef options -animationDuration       -minversion 5  -validvalue {}            -type num|null                  -trace no   -default 1000
    setdef options -animationDurationUpdate -minversion 5  -validvalue {}            -type num|null                  -trace no   -default 500
    setdef options -animationDelayUpdate    -minversion 5  -validvalue {}            -type jsfunc|null               -trace no   -default "nothing"
    setdef options -animationEasing         -minversion 5  -validvalue formatAEasing -type str|null                  -trace no   -default "cubicInOut"
    setdef options -animationEasingUpdate   -minversion 5  -validvalue formatAEasing -type str|null                  -trace no   -default "cubicInOut"
    setdef options -animationThreshold      -minversion 5  -validvalue {}            -type num|null                  -trace no   -default 2000
    setdef options -progressiveThreshold    -minversion 5  -validvalue {}            -type num|null                  -trace no   -default 3000
    setdef options -hoverLayerThreshold     -minversion 5  -validvalue {}            -type num|null                  -trace no   -default "nothing"
    setdef options -useUTC                  -minversion 5  -validvalue {}            -type bool|null                 -trace no   -default "nothing"
    setdef options -blendMode               -minversion 5  -validvalue formatBlendM  -type str|null                  -trace no   -default "nothing"

    set options [merge $options $value]

    return [new edict $options]
}

proc ticklecharts::renderOptions {value method} { 
    # Global options for render's methods
    #
    # value  - Options described below.
    # method - name method.
    #
    # Returns options values

    variable minProperties
    variable escript
    variable htmltemplate

    # Required values set minProperties to false.
    set minP $minProperties ; set minProperties 0

    # Generate random number generator.
    set uuid [ticklecharts::uuid]
    # Default output html.
    set outfile [file join [file dirname [info script]] render.html]

    switch -exact -- $method  {
        "RenderTsb" {
            # Global options for 'Taygete Scrap Book' method.
            setdef options -height     -minversion {}  -validvalue {}             -type str.n|num          -default "500px"
            setdef options -renderer   -minversion {}  -validvalue formatRenderer -type str.n              -default "canvas"
            setdef options -merge      -minversion {}  -validvalue {}             -type bool               -default "False"
            setdef options -evalJSON   -minversion {}  -validvalue {}             -type bool               -default "False"
        }
        "RenderJupyter" {
            # Global options for 'Jupyter' method.
            setdef options -width      -minversion {}  -validvalue {}             -type str.n|num          -default "100%"
            setdef options -height     -minversion {}  -validvalue {}             -type str.n|num          -default "500px"
            setdef options -renderer   -minversion {}  -validvalue formatRenderer -type str.n              -default "canvas"
        }
        "SnapShot" {
            # Global options for 'SnapShot' method.
            set ext [expr {[dict exists $value -renderer] ? [dict get $value -renderer] : "png"}]
            setdef options -address           -minversion {}  -validvalue {}             -type str.n       -default "127.0.0.1"
            setdef options -port              -minversion {}  -validvalue {}             -type num         -default 8888
            setdef options -exe               -minversion {}  -validvalue {}             -type str.n       -default "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
            setdef options -html              -minversion {}  -validvalue {}             -type str.n|null  -default "nothing"
            setdef options -renderer          -minversion {}  -validvalue formatRendSnap -type str.n       -default "png"
            setdef options -outfile           -minversion {}  -validvalue {}             -type str.n       -default [file rootname $outfile].$ext
            setdef options -excludecomponents -minversion {}  -validvalue formatExcludeC -type list.s|null -default "nothing"
            setdef options -timeout           -minversion {}  -validvalue formatTimeout  -type num         -default 400
        }
        default {
            # Global options for other methods.
            setdef options -title      -minversion {}  -validvalue {}             -type str.n              -default "ticklEcharts !!!"
            setdef options -width      -minversion {}  -validvalue {}             -type str.n|num          -default "900px"
            setdef options -height     -minversion {}  -validvalue {}             -type str.n|num          -default "500px"
            setdef options -renderer   -minversion {}  -validvalue formatRenderer -type str.n              -default "canvas"
            setdef options -jschartvar -minversion {}  -validvalue {}             -type str.n              -default [format "chart_%s" $uuid]
            setdef options -divid      -minversion {}  -validvalue {}             -type str.n              -default [format "id_%s" $uuid]
            setdef options -jsecharts  -minversion {}  -validvalue {}             -type str.n              -default $escript
            setdef options -jsvar      -minversion {}  -validvalue {}             -type str.n              -default [format "option_%s" $uuid]
            setdef options -script     -minversion {}  -validvalue {}             -type list.d|jsfunc|null -default "nothing"
            setdef options -class      -minversion {}  -validvalue {}             -type str.n              -default "chart-container"
            setdef options -style      -minversion {}  -validvalue {}             -type str.n|null         -default "nothing"
            setdef options -template   -minversion {}  -validvalue {}             -type str.n              -default $htmltemplate
            if {$method eq "Render"} {
            setdef options -outfile    -minversion {}  -validvalue {}             -type str.n              -default $outfile
            }
        }
    }

    set options [merge $options $value]

    set minProperties $minP

    return $options
}

proc ticklecharts::title {value} {
    # options : https://echarts.apache.org/en/option.html#title
    #
    # value - Options described in proc ticklecharts::title below.
    #
    # Returns dict title options

    # Gets key value.
    set d [ticklecharts::getValue $value "-title"]

    setdef options id                -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
    setdef options show              -minversion 5  -validvalue {}                      -type bool        -default "True"
    setdef options text              -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
    setdef options link              -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
    setdef options target            -minversion 5  -validvalue formatTarget            -type str         -default "blank"
    setdef options textStyle         -minversion 5  -validvalue {}                      -type dict|null   -default [ticklecharts::textStyle $d textStyle]
    setdef options subtext           -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
    setdef options sublink           -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
    setdef options subtarget         -minversion 5  -validvalue formatTarget            -type str         -default "blank"
    setdef options subtextStyle      -minversion 5  -validvalue {}                      -type dict|null   -default [ticklecharts::textStyle $d subtextStyle]
    setdef options textAlign         -minversion 5  -validvalue formatTextAlign         -type str|null    -default "null"
    setdef options textVerticalAlign -minversion 5  -validvalue formatVerticalTextAlign -type str         -default "auto"
    setdef options triggerEvent      -minversion 5  -validvalue {}                      -type bool|null   -default "nothing"
    setdef options padding           -minversion 5  -validvalue {}                      -type num|list.n  -default 5
    setdef options itemGap           -minversion 5  -validvalue {}                      -type num         -default 10
    setdef options zlevel            -minversion 5  -validvalue {}                      -type num|null    -default "nothing"
    setdef options z                 -minversion 5  -validvalue {}                      -type num         -default 2
    setdef options left              -minversion 5  -validvalue formatLeft              -type str|num     -default "auto"
    setdef options top               -minversion 5  -validvalue formatTop               -type str|num     -default "auto"
    setdef options right             -minversion 5  -validvalue formatRight             -type str|num     -default "auto"
    setdef options bottom            -minversion 5  -validvalue formatBottom            -type str|num     -default "auto"
    setdef options backgroundColor   -minversion 5  -validvalue formatColor             -type e.color|str -default "transparent"
    setdef options borderColor       -minversion 5  -validvalue formatColor             -type str         -default "transparent"
    setdef options borderWidth       -minversion 5  -validvalue {}                      -type num         -default 1
    setdef options borderRadius      -minversion 5  -validvalue {}                      -type num|list.n  -default 0
    setdef options shadowBlur        -minversion 5  -validvalue {}                      -type num|null    -default "nothing"
    setdef options shadowColor       -minversion 5  -validvalue formatColor             -type str|null    -default "nothing"
    setdef options shadowOffsetX     -minversion 5  -validvalue {}                      -type num|null    -default "nothing"
    setdef options shadowOffsetY     -minversion 5  -validvalue {}                      -type num|null    -default "nothing"
    #...

    # Force string representation for 'text' and 'subtext' keys if exists.
    foreach key {text subtext} {
        if {[dict exists $d $key]} {
            set val [dict get $d $key]
            if {[ticklecharts::typeOf $val] ni {str str.e}} {
                dict set d $key [new estr $val]
            }
        }
    }

    # remove key(s)...
    set d [dict remove $d textStyle subtextStyle]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::grid {value} {
    # options : https://echarts.apache.org/en/option.html#grid
    #
    # value - Options described in proc ticklecharts::grid below.
    #
    # Returns dict grid options

    # Gets key value.
    set d [ticklecharts::getValue $value "-grid"]

    setdef options id              -minversion 5  -validvalue {}           -type str|null         -default "nothing"
    setdef options show            -minversion 5  -validvalue {}           -type bool|null        -default "nothing"
    setdef options zlevel          -minversion 5  -validvalue {}           -type num|null         -default "nothing"
    setdef options z               -minversion 5  -validvalue {}           -type num|null         -default "nothing"
    setdef options left            -minversion 5  -validvalue formatLeft   -type str|num|null     -default "nothing"
    setdef options top             -minversion 5  -validvalue formatTop    -type str|num|null     -default "nothing"
    setdef options right           -minversion 5  -validvalue formatRight  -type str|num|null     -default "nothing"
    setdef options bottom          -minversion 5  -validvalue formatBottom -type str|num|null     -default "nothing"
    setdef options width           -minversion 5  -validvalue {}           -type str|num|null     -default "nothing"
    setdef options height          -minversion 5  -validvalue {}           -type str|num|null     -default "nothing"
    setdef options containLabel    -minversion 5  -validvalue {}           -type bool|null        -default "nothing"
    setdef options backgroundColor -minversion 5  -validvalue formatColor  -type e.color|str|null -default "nothing"
    setdef options borderColor     -minversion 5  -validvalue formatColor  -type str|null         -default "nothing"
    setdef options borderWidth     -minversion 5  -validvalue {}           -type num|null         -default "nothing"
    setdef options shadowBlur      -minversion 5  -validvalue {}           -type num|null         -default "nothing"
    setdef options shadowColor     -minversion 5  -validvalue formatColor  -type str|null         -default "nothing"
    setdef options shadowOffsetX   -minversion 5  -validvalue {}           -type num|null         -default "nothing"
    setdef options shadowOffsetY   -minversion 5  -validvalue {}           -type num|null         -default "nothing"
    setdef options tooltip         -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::tooltip $d]
    #...

    # remove key(s)...
    set d [dict remove $d tooltip]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::tooltip {value} {
    # options : https://echarts.apache.org/en/option.html#tooltip
    #
    # value - Options described in proc ticklecharts::tooltip below.
    #
    # Returns dict tooltip options

    if {![ticklecharts::keyDictExists "tooltip" $value key]} {
        return "nothing"
    }

    # Gets key value.
    set d [ticklecharts::getValue $value $key]

    setdef options show               -minversion 5       -validvalue {}               -type bool                   -default "True"
    setdef options trigger            -minversion 5       -validvalue formatTrigger    -type str|null               -default "item"
    setdef options axisPointer        -minversion 5       -validvalue {}               -type dict|null              -default [ticklecharts::axisPointer $d]
    setdef options showContent        -minversion 5       -validvalue {}               -type bool                   -default "True"
    setdef options alwaysShowContent  -minversion 5       -validvalue {}               -type bool|null              -default "False"
    setdef options triggerOn          -minversion 5       -validvalue formatTriggerOn  -type str                    -default "mousemove|click"
    setdef options showDelay          -minversion 5       -validvalue {}               -type num|null               -default "nothing"
    setdef options hideDelay          -minversion 5       -validvalue {}               -type num|null               -default "nothing"
    setdef options enterable          -minversion 5       -validvalue {}               -type bool|null              -default "nothing"
    setdef options renderMode         -minversion 5       -validvalue formatRenderMode -type str|null               -default "nothing"
    setdef options confine            -minversion 5       -validvalue formatConfine    -type bool|null              -default "nothing"
    setdef options appendTo           -minversion "5.5.0" -validvalue {}               -type str|jsfunc|null        -default "nothing"
    setdef options appendToBody       -minversion 5       -validvalue {}               -type bool|null              -default "nothing"
    setdef options className          -minversion 5       -validvalue {}               -type str|null               -default "nothing"
    setdef options transitionDuration -minversion 5       -validvalue {}               -type num|null               -default 0.4
    setdef options position           -minversion 5       -validvalue formatPosition   -type str|list.d|jsfunc|null -default "nothing"
    setdef options formatter          -minversion 5       -validvalue {}               -type str|jsfunc|null        -default "nothing"
    setdef options valueFormatter     -minversion "5.3.0" -validvalue {}               -type str|jsfunc|null        -default "nothing"
    setdef options backgroundColor    -minversion 5       -validvalue formatColor      -type e.color|str|null       -default "nothing"
    setdef options borderColor        -minversion 5       -validvalue formatColor      -type str|null               -default "nothing"
    setdef options borderWidth        -minversion 5       -validvalue {}               -type num|null               -default "nothing"
    setdef options padding            -minversion 5       -validvalue {}               -type num|list.n|null        -default 5
    setdef options textStyle          -minversion 5       -validvalue {}               -type dict|null              -default [ticklecharts::textStyle $d textStyle]
    setdef options extraCssText       -minversion 5       -validvalue {}               -type str|null               -default "nothing"
    setdef options order              -minversion 5       -validvalue formatOrder      -type str|null               -default "seriesAsc"
    #...

    # remove key(s)...
    set d [dict remove $d axisPointer textStyle]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::legend {value} {
    # options : https://echarts.apache.org/en/option.html#legend
    #
    # value - Options described in proc ticklecharts::legend below.
    #
    # Returns dict legend options

    # Gets key value.
    set d [ticklecharts::getValue $value "-legend"]

    setdef options type                    -minversion 5  -validvalue formatLegendType      -type str                 -trace no  -default "plain"
    setdef options id                      -minversion 5  -validvalue {}                    -type str|null            -trace no  -default "nothing"
    setdef options show                    -minversion 5  -validvalue {}                    -type bool                -trace no  -default "True"
    setdef options zlevel                  -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options z                       -minversion 5  -validvalue {}                    -type num                 -trace no  -default 2
    setdef options left                    -minversion 5  -validvalue formatLeft            -type str|num|null        -trace no  -default "center"
    setdef options top                     -minversion 5  -validvalue formatTop             -type str|num|null        -trace no  -default "auto"
    setdef options right                   -minversion 5  -validvalue formatRight           -type str|num|null        -trace no  -default "auto"
    setdef options bottom                  -minversion 5  -validvalue {}                    -type str|num|null        -trace no  -default "auto"
    setdef options width                   -minversion 5  -validvalue {}                    -type str|num|null        -trace no  -default "auto"
    setdef options height                  -minversion 5  -validvalue {}                    -type str|num|null        -trace no  -default "auto"
    setdef options orient                  -minversion 5  -validvalue formatOrient          -type str                 -trace no  -default "horizontal"
    setdef options align                   -minversion 5  -validvalue formatAlign           -type str                 -trace no  -default "auto"
    setdef options padding                 -minversion 5  -validvalue {}                    -type num|list.n          -trace no  -default 5
    setdef options itemGap                 -minversion 5  -validvalue {}                    -type num                 -trace no  -default 10
    setdef options itemWidth               -minversion 5  -validvalue {}                    -type num                 -trace no  -default 25
    setdef options itemHeight              -minversion 5  -validvalue {}                    -type num                 -trace no  -default 14
    setdef options itemStyle               -minversion 5  -validvalue {}                    -type dict|null           -trace no  -default [ticklecharts::itemStyle $d]
    setdef options lineStyle               -minversion 5  -validvalue {}                    -type dict|null           -trace no  -default [ticklecharts::lineStyle $d]
    setdef options symbolRotate            -minversion 5  -validvalue {}                    -type str|num             -trace no  -default "inherit"
    setdef options formatter               -minversion 5  -validvalue {}                    -type str|jsfunc|null     -trace no  -default "nothing"
    setdef options selectedMode            -minversion 5  -validvalue {}                    -type bool|str            -trace no  -default "True"
    setdef options inactiveColor           -minversion 5  -validvalue formatColor           -type str                 -trace no  -default "rgb(204, 204, 204)"
    setdef options inactiveBorderColor     -minversion 5  -validvalue formatColor           -type str                 -trace no  -default "rgb(204, 204, 204)"
    setdef options inactiveBorderWidth     -minversion 5  -validvalue formatColor           -type str                 -trace no  -default "auto"
    setdef options selected                -minversion 5  -validvalue {}                    -type jsfunc|struct|null  -trace no  -default "nothing"
    setdef options textStyle               -minversion 5  -validvalue {}                    -type dict|null           -trace no  -default [ticklecharts::textStyle $d textStyle]
    setdef options tooltip                 -minversion 5  -validvalue {}                    -type dict|null           -trace no  -default [ticklecharts::tooltip $d]
    setdef options icon                    -minversion 5  -validvalue {}                    -type str|null            -trace no  -default "nothing"
    setdef options backgroundColor         -minversion 5  -validvalue formatColor           -type e.color|str|null    -trace no  -default "transparent"
    setdef options borderWidth             -minversion 5  -validvalue {}                    -type num                 -trace no  -default 0
    setdef options borderRadius            -minversion 5  -validvalue {}                    -type num                 -trace no  -default 0
    setdef options shadowBlur              -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options shadowColor             -minversion 5  -validvalue formatColor           -type str|null            -trace no  -default "nothing"
    setdef options shadowOffsetX           -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options shadowOffsetY           -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options scrollDataIndex         -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options pageButtonItemGap       -minversion 5  -validvalue {}                    -type num                 -trace no  -default 5
    setdef options pageButtonGap           -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options pageButtonPosition      -minversion 5  -validvalue formatPButtonPosition -type str|null            -trace no  -default "nothing"
    setdef options pageFormatter           -minversion 5  -validvalue {}                    -type str|jsfunc|null     -trace no  -default "nothing"
    setdef options pageIcons               -minversion 5  -validvalue {}                    -type dict|null           -trace no  -default [ticklecharts::pageIcons $d]
    setdef options pageIconColor           -minversion 5  -validvalue formatColor           -type str                 -trace no  -default "rgb(47, 69, 84)"
    setdef options pageIconInactiveColor   -minversion 5  -validvalue formatColor           -type str                 -trace no  -default "rgb(170, 170, 170)"
    setdef options pageIconSize            -minversion 5  -validvalue {}                    -type num|list.n          -trace no  -default 15
    setdef options pageTextStyle           -minversion 5  -validvalue {}                    -type dict|null           -trace no  -default [ticklecharts::pageTextStyle $d]
    setdef options animation               -minversion 5  -validvalue {}                    -type bool|null           -trace yes -default "nothing"
    setdef options animationDurationUpdate -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options emphasis                -minversion 5  -validvalue {}                    -type dict|null           -trace no  -default [ticklecharts::emphasis $d]
    setdef options selector                -minversion 5  -validvalue {}                    -type bool|list.d|null    -trace no  -default "nothing"
    setdef options selectorLabel           -minversion 5  -validvalue {}                    -type dict|null           -trace no  -default [ticklecharts::selectorLabel $d]
    setdef options selectorPosition        -minversion 5  -validvalue formatSelectorPos     -type str|null            -trace no  -default "nothing"
    setdef options selectorItemGap         -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options selectorButtonGap       -minversion 5  -validvalue {}                    -type num|null            -trace no  -default "nothing"
    setdef options data                    -minversion 5  -validvalue {}                    -type list.d|null         -trace no  -default "nothing"
    #...

    if {[dict exists $d dataLegendItem]} {
        setdef options data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::legendItem $d]
    }

    # remove key(s)...
    set d [dict remove $d itemStyle lineStyle textStyle \
                          dataLegendItem pageTextStyle \
                          selectorLabel emphasis]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::polar {value} {
    # options : https://echarts.apache.org/en/option.html#polar
    #
    # value - Options described in proc ticklecharts::polar below.
    #
    # Returns dict polar options

    # Gets key value.
    set d [ticklecharts::getValue $value "-polar"]

    setdef options id     -minversion 5  -validvalue {} -type str|null            -default "nothing"
    setdef options zlevel -minversion 5  -validvalue {} -type num|null            -default "nothing"
    setdef options z      -minversion 5  -validvalue {} -type num                 -default 2
    setdef options center -minversion 5  -validvalue {} -type list.d|null         -default "nothing"
    setdef options radius -minversion 5  -validvalue {} -type str|num|list.d|null -default "nothing"
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::visualMap {value} {
    # options : https://echarts.apache.org/en/option.html#visualMap
    #
    # value - Options described in proc ticklecharts::visualMap below.
    #
    # Returns dict visualMap options

    # Gets key value.
    set d [ticklecharts::getValue $value "-visualMap"]

    if {![dict exists $d type]} {
        error "visualMap 'type' should be specified... 'continuous' or 'piecewise'"
    }

    switch -exact -- [dict get $d type] {
        continuous {
            setdef options type            -minversion 5  -validvalue {}                   -type str                 -default "continuous"
            setdef options id              -minversion 5  -validvalue {}                   -type str|null            -default "nothing"
            setdef options min             -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
            setdef options max             -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
            setdef options range           -minversion 5  -validvalue {}                   -type list.n|null         -default "nothing"
            setdef options calculable      -minversion 5  -validvalue {}                   -type bool|null           -default "False"
            setdef options realtime        -minversion 5  -validvalue {}                   -type bool|null           -default "True"
            setdef options inverse         -minversion 5  -validvalue {}                   -type bool|null           -default "False"
            setdef options precision       -minversion 5  -validvalue {}                   -type num|null            -default 0
            setdef options itemWidth       -minversion 5  -validvalue {}                   -type num|null            -default 20
            setdef options itemHeight      -minversion 5  -validvalue {}                   -type num|null            -default 140
            setdef options align           -minversion 5  -validvalue formatVisualMapAlign -type str|null            -default "auto"
            setdef options text            -minversion 5  -validvalue {}                   -type list.s|null         -default "nothing"
            setdef options textGap         -minversion 5  -validvalue {}                   -type num|null            -default 10
            setdef options show            -minversion 5  -validvalue {}                   -type bool                -default "True"
            setdef options dimension       -minversion 5  -validvalue {}                   -type num|null            -default "nothing"
            setdef options seriesIndex     -minversion 5  -validvalue {}                   -type num|list.d|null     -default "nothing"
            setdef options hoverLink       -minversion 5  -validvalue {}                   -type bool                -default "True"
            setdef options inRange         -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::inRange $d]
            setdef options outOfRange      -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::outOfRange $d]
            setdef options controller      -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::controller $d]
            setdef options zlevel          -minversion 5  -validvalue {}                   -type num                 -default 0
            setdef options z               -minversion 5  -validvalue {}                   -type num                 -default 4
            setdef options left            -minversion 5  -validvalue formatLeft           -type num|str|null        -default "auto"
            setdef options top             -minversion 5  -validvalue formatTop            -type num|str|null        -default "auto"
            setdef options right           -minversion 5  -validvalue formatRight          -type num|str|null        -default "auto"
            setdef options bottom          -minversion 5  -validvalue formatBottom         -type num|str|null        -default "auto"
            setdef options orient          -minversion 5  -validvalue formatOrient         -type str                 -default "vertical"
            setdef options padding         -minversion 5  -validvalue {}                   -type list.n|num          -default 5
            setdef options backgroundColor -minversion 5  -validvalue formatColor          -type e.color|str         -default "rgba(0,0,0,0)"
            setdef options borderColor     -minversion 5  -validvalue formatColor          -type str                 -default "#ccc"
            setdef options borderWidth     -minversion 5  -validvalue {}                   -type num                 -default 0
            setdef options color           -minversion 5  -validvalue formatColor          -type e.color|list.s|null -default "nothing"
            setdef options textStyle       -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::textStyle $d textStyle]
            setdef options formatter       -minversion 5  -validvalue {}                   -type str|jsfunc|null     -default "nothing"
            setdef options handleIcon      -minversion 5  -validvalue {}                   -type str|null            -default "nothing"
            setdef options handleSize      -minversion 5  -validvalue {}                   -type str|num|null        -default "120%"
            setdef options handleStyle     -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::handleStyle $d]
            setdef options indicatorIcon   -minversion 5  -validvalue {}                   -type str|null            -default "circle"
            setdef options indicatorSize   -minversion 5  -validvalue {}                   -type str|num|null        -default "50%"
            setdef options indicatorStyle  -minversion 5  -validvalue {}                   -type dict|null           -default [ticklecharts::indicatorStyle $d]
            #...
        }
        piecewise {
            setdef options type            -minversion 5             -validvalue {}                   -type str                    -default "piecewise"
            setdef options id              -minversion 5             -validvalue {}                   -type str|null               -default "nothing"
            setdef options splitNumber     -minversion 5             -validvalue {}                   -type num|null               -default 5
            setdef options pieces          -minversion 5             -validvalue {}                   -type list.o|null            -default [ticklecharts::piecesItem $d]
            setdef options categories      -minversion 5             -validvalue {}                   -type list.s|null            -default "nothing"
            setdef options realtime        -minversion 5             -validvalue {}                   -type bool|null              -default "nothing"
            setdef options orient          -minversion 5             -validvalue formatOrient         -type str|null               -default "nothing"
            setdef options min             -minversion 5             -validvalue {}                   -type num|null               -default "nothing"
            setdef options max             -minversion 5             -validvalue {}                   -type num|null               -default "nothing"
            setdef options minOpen         -minversion 5             -validvalue {}                   -type bool|null              -default "nothing"
            setdef options maxOpen         -minversion 5             -validvalue {}                   -type bool|null              -default "nothing"
            setdef options selectedMode    -minversion "5.0.0:5.3.3" -validvalue formatSelectedMode   -type str|null:str|bool|null -default "multiple"
            setdef options inverse         -minversion 5             -validvalue {}                   -type bool|null              -default "False"
            setdef options precision       -minversion 5             -validvalue {}                   -type num|null               -default 0
            setdef options itemWidth       -minversion 5             -validvalue {}                   -type num|null               -default 20
            setdef options itemHeight      -minversion 5             -validvalue {}                   -type num|null               -default 14
            setdef options align           -minversion 5             -validvalue formatVisualMapAlign -type str|null               -default "auto"
            setdef options text            -minversion 5             -validvalue {}                   -type list.s|null            -default "nothing"
            setdef options textGap         -minversion 5             -validvalue {}                   -type num|null               -default 10
            setdef options showLabel       -minversion 5             -validvalue {}                   -type bool|null              -default "nothing"
            setdef options itemGap         -minversion 5             -validvalue {}                   -type num|null               -default 10
            setdef options itemSymbol      -minversion 5             -validvalue formatItemSymbol     -type str|null               -default "roundRect"
            setdef options show            -minversion 5             -validvalue {}                   -type bool                   -default "True"
            setdef options dimension       -minversion 5             -validvalue {}                   -type num|null               -default "nothing"
            setdef options seriesIndex     -minversion 5             -validvalue {}                   -type num|list.d|null        -default "nothing"
            setdef options hoverLink       -minversion 5             -validvalue {}                   -type bool                   -default "True"
            setdef options inRange         -minversion 5             -validvalue {}                   -type dict|null              -default [ticklecharts::inRange $d]
            setdef options outOfRange      -minversion 5             -validvalue {}                   -type dict|null              -default [ticklecharts::outOfRange $d]
            setdef options controller      -minversion 5             -validvalue {}                   -type dict|null              -default [ticklecharts::controller $d]
            setdef options zlevel          -minversion 5             -validvalue {}                   -type num                    -default 0
            setdef options z               -minversion 5             -validvalue {}                   -type num                    -default 4
            setdef options left            -minversion 5             -validvalue formatLeft           -type num|str|null           -default "auto"
            setdef options top             -minversion 5             -validvalue formatTop            -type num|str|null           -default "auto"
            setdef options right           -minversion 5             -validvalue formatRight          -type num|str|null           -default "auto"
            setdef options bottom          -minversion 5             -validvalue formatBottom         -type num|str|null           -default "auto"
            setdef options padding         -minversion 5             -validvalue {}                   -type list.n|num             -default 5
            setdef options backgroundColor -minversion 5             -validvalue formatColor          -type e.color|str            -default "rgba(0,0,0,0)"
            setdef options borderColor     -minversion 5             -validvalue formatColor          -type str                    -default "#ccc"
            setdef options borderWidth     -minversion 5             -validvalue {}                   -type num                    -default 0
            setdef options color           -minversion 5             -validvalue formatColor          -type e.color|list.s|null    -default "nothing"
            setdef options textStyle       -minversion 5             -validvalue {}                   -type dict|null              -default [ticklecharts::textStyle $d textStyle]
            setdef options formatter       -minversion 5             -validvalue {}                   -type str|jsfunc|null        -default "nothing"
            #...
        }
        default {
            error "Type name should be 'continuous' or 'piecewise'"
        }
    }
    #...

    # remove key(s)...
    set d [dict remove $d pieces inRange outOfRange controller textStyle handleStyle indicatorStyle]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::toolbox {value} {
    # options : https://echarts.apache.org/en/option.html#toolbox
    #
    # value - Options described in proc ticklecharts::toolbox below.
    #
    # Returns dict toolbox options

    # Gets key value.
    set d [ticklecharts::getValue $value "-toolbox"]

    setdef options id         -minversion 5  -validvalue {}           -type str|null      -default "nothing"
    setdef options show       -minversion 5  -validvalue {}           -type bool          -default "True"
    setdef options orient     -minversion 5  -validvalue formatOrient -type str           -default "horizontal"
    setdef options itemSize   -minversion 5  -validvalue {}           -type num           -default 15
    setdef options itemGap    -minversion 5  -validvalue {}           -type num           -default 10
    setdef options showTitle  -minversion 5  -validvalue {}           -type bool          -default "True"
    setdef options feature    -minversion 5  -validvalue {}           -type dict|null     -default [ticklecharts::feature $d]
    setdef options iconStyle  -minversion 5  -validvalue {}           -type dict|null     -default [ticklecharts::iconStyle $d "toolbox"]
    setdef options emphasis   -minversion 5  -validvalue {}           -type dict|null     -default [ticklecharts::iconEmphasis $d]
    setdef options zlevel     -minversion 5  -validvalue {}           -type num|null      -default "nothing"
    setdef options z          -minversion 5  -validvalue {}           -type num           -default 2
    setdef options left       -minversion 5  -validvalue formatLeft   -type str|num|null  -default "nothing"
    setdef options top        -minversion 5  -validvalue formatTop    -type str|num|null  -default "auto"
    setdef options right      -minversion 5  -validvalue formatRight  -type str|num|null  -default "auto"
    setdef options bottom     -minversion 5  -validvalue formatBottom -type str|num|null  -default "nothing"
    setdef options width      -minversion 5  -validvalue {}           -type str|num|null  -default "auto"
    setdef options height     -minversion 5  -validvalue {}           -type str|num|null  -default "auto"
    # not supported yet...
    # setdef options tooltip  -minversion 5  -validvalue {} -type dict|null     -default "nothing"

    # remove key(s)...
    set d [dict remove $d feature iconStyle emphasis]
    #...

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::dataZoom {value} {
    # options : https://echarts.apache.org/en/option.html#dataZoom
    #
    # value - Options described in proc ticklecharts::dataZoom below.
    #
    # Returns dict dataZoom options

    # Gets key value.
    set d [ticklecharts::getValue $value "-dataZoom"]

    if {![dict exists $d type]} {
        error "dataZoom 'type' should be specified... 'inside' or 'slider'"
    }

    switch -exact -- [dict get $d type] {
        inside {
            setdef options type                    -minversion 5       -validvalue {}               -type str             -default "inside"
            setdef options id                      -minversion 5       -validvalue {}               -type str|null        -default "nothing"
            setdef options disabled                -minversion 5       -validvalue {}               -type bool            -default "False"
            setdef options xAxisIndex              -minversion 5       -validvalue {}               -type list.d|num|null -default "nothing"
            setdef options yAxisIndex              -minversion 5       -validvalue {}               -type list.d|num|null -default "nothing"
            setdef options radiusAxisIndex         -minversion 5       -validvalue {}               -type list.d|num|null -default "nothing"
            setdef options angleAxisIndex          -minversion 5       -validvalue {}               -type list.d|num|null -default "nothing"
            setdef options filterMode              -minversion 5       -validvalue formatFilterMode -type str             -default "filter"
            setdef options start                   -minversion 5       -validvalue formatMaxMin     -type num|null        -default "nothing"
            setdef options end                     -minversion 5       -validvalue formatMaxMin     -type num|null        -default "nothing"
            setdef options startValue              -minversion 5       -validvalue {}               -type str|num|null    -default "nothing"
            setdef options endValue                -minversion 5       -validvalue {}               -type str|num|null    -default "nothing"
            setdef options minSpan                 -minversion 5       -validvalue formatMaxMin     -type num|null        -default "nothing"
            setdef options maxSpan                 -minversion 5       -validvalue formatMaxMin     -type num|null        -default "nothing"
            setdef options minValueSpan            -minversion 5       -validvalue {}               -type str|num|null    -default "nothing"
            setdef options maxValueSpan            -minversion 5       -validvalue {}               -type str|num|null    -default "nothing"
            setdef options orient                  -minversion 5       -validvalue formatOrient     -type str             -default "horizontal"
            setdef options zoomLock                -minversion 5       -validvalue {}               -type bool|null       -default "nothing"
            setdef options throttle                -minversion 5       -validvalue {}               -type num             -default 100
            setdef options rangeMode               -minversion 5       -validvalue {}               -type list.d|null     -default "nothing"
            setdef options zoomOnMouseWheel        -minversion 5       -validvalue formatZoomMW     -type bool|str        -default "True"
            setdef options moveOnMouseMove         -minversion 5       -validvalue formatZoomMW     -type bool|str        -default "True"
            setdef options moveOnMouseWheel        -minversion 5       -validvalue formatZoomMW     -type bool|str        -default "False"
            setdef options preventDefaultMouseMove -minversion 5       -validvalue {}               -type bool            -default "True"
            #...
        }
        slider {
            setdef options type                   -minversion 5        -validvalue {}               -type str             -default "slider"
            setdef options id                     -minversion 5        -validvalue {}               -type str|null        -default "nothing"
            setdef options show                   -minversion 5        -validvalue {}               -type bool            -default "False"
            setdef options backgroundColor        -minversion 5        -validvalue formatColor      -type e.color|str.t   -default [echartsOptsTheme dataZoom.backgroundColor]
            setdef options dataBackground         -minversion 5        -validvalue {}               -type dict|null       -default [ticklecharts::dataBackground $d]
            setdef options selectedDataBackground -minversion 5        -validvalue {}               -type dict|null       -default [ticklecharts::selectedDataBackground $d]
            setdef options fillerColor            -minversion 5        -validvalue formatColor      -type str.t|null      -default [echartsOptsTheme dataZoom.fillerColor]
            setdef options borderColor            -minversion 5        -validvalue formatColor      -type str.t|null      -default [echartsOptsTheme dataZoom.borderColor]
            setdef options handleIcon             -minversion 5        -validvalue {}               -type str             -default "M8.2,13.6V3.9H6.3v9.7H3.1v14.9h3.3v9.7h1.8v-9.7h3.3V13.6H8.2z\
                                                                                                                                    M9.7,24.4H4.8v-1.4h4.9V24.4z M9.7,19.1H4.8v-1.4h4.9V19.1z"
            setdef options handleSize             -minversion 5        -validvalue {}               -type str|num         -default "100%"
            setdef options handleStyle            -minversion 5        -validvalue {}               -type dict|null       -default [ticklecharts::handleStyle $d]
            setdef options moveHandleIcon         -minversion 5        -validvalue {}               -type str             -default "M-320.9-50L-320.9-50c18.1,0,27.1,9,27.1,27.1V85.7c0,18.1-9,27.1-27.1,27.1l0,\
                                                                                                                                    0c-18.1,0-27.1-9-27.1-27.1V-22.9C-348-41-339-50-320.9-50z M-212.3-50L-212.3-50c18.1,\
                                                                                                                                    0,27.1,9,27.1,27.1V85.7c0,18.1-9,27.1-27.1,27.1l0,0c-18.1,\
                                                                                                                                    0-27.1-9-27.1-27.1V-22.9C-239.4-41-230.4-50-212.3-50z M-103.7-50L-103.7-50c18.1,\
                                                                                                                                    0,27.1,9,27.1,27.1V85.7c0,18.1-9,27.1-27.1,27.1l0,\
                                                                                                                                    0c-18.1,0-27.1-9-27.1-27.1V-22.9C-130.9-41-121.8-50-103.7-50z"
            setdef options moveHandleSize         -minversion 5        -validvalue {}               -type num             -default 3
            setdef options moveHandleStyle        -minversion 5        -validvalue {}               -type dict|null       -default [ticklecharts::moveHandleStyle $d]
            setdef options labelPrecision         -minversion 5        -validvalue {}               -type str|num         -default "auto"
            setdef options labelFormatter         -minversion 5        -validvalue {}               -type str|jsfunc|null -default "nothing"
            setdef options showDetail             -minversion 5        -validvalue {}               -type bool            -default "True"
            setdef options showDataShadow         -minversion 5        -validvalue {}               -type str             -default "auto"
            setdef options realtime               -minversion 5        -validvalue {}               -type bool            -default "True"
            setdef options textStyle              -minversion 5        -validvalue {}               -type dict|null       -default [ticklecharts::textStyle $d "textStyle"]
            setdef options xAxisIndex             -minversion 5        -validvalue {}               -type list.d|num|null -default "nothing"
            setdef options yAxisIndex             -minversion 5        -validvalue {}               -type list.d|num|null -default "nothing"
            setdef options radiusAxisIndex        -minversion 5        -validvalue {}               -type list.d|num|null -default "nothing"
            setdef options angleAxisIndex         -minversion 5        -validvalue {}               -type list.d|num|null -default "nothing"
            setdef options filterMode             -minversion 5        -validvalue formatFilterMode -type str             -default "filter"
            setdef options start                  -minversion 5        -validvalue formatMaxMin     -type num|null        -default "nothing"
            setdef options end                    -minversion 5        -validvalue formatMaxMin     -type num|null        -default "nothing"
            setdef options startValue             -minversion 5        -validvalue {}               -type str|num|null    -default "nothing"
            setdef options endValue               -minversion 5        -validvalue {}               -type str|num|null    -default "nothing"
            setdef options minSpan                -minversion 5        -validvalue formatMaxMin     -type num|null        -default "nothing"
            setdef options maxSpan                -minversion 5        -validvalue formatMaxMin     -type num|null        -default "nothing"
            setdef options minValueSpan           -minversion 5        -validvalue {}               -type str|num|null    -default "nothing"
            setdef options maxValueSpan           -minversion 5        -validvalue {}               -type str|num|null    -default "nothing"
            setdef options orient                 -minversion 5        -validvalue formatOrient     -type str|null        -default "nothing"
            setdef options zoomLock               -minversion 5        -validvalue {}               -type bool|null       -default "nothing"
            setdef options throttle               -minversion 5        -validvalue {}               -type num             -default 100
            setdef options rangeMode              -minversion 5        -validvalue {}               -type list.d|null     -default "nothing"
            setdef options zlevel                 -minversion 5        -validvalue {}               -type num|null        -default "nothing"
            setdef options z                      -minversion 5        -validvalue {}               -type num             -default 2
            setdef options left                   -minversion 5        -validvalue formatLeft       -type str|num|null    -default "nothing"
            setdef options top                    -minversion 5        -validvalue formatTop        -type str|num|null    -default "nothing"
            setdef options right                  -minversion 5        -validvalue formatRight      -type str|num|null    -default "nothing"
            setdef options bottom                 -minversion 5        -validvalue formatBottom     -type str|num|null    -default "nothing"
            setdef options width                  -minversion 5        -validvalue {}               -type str|num|null    -default "nothing"
            setdef options height                 -minversion 5        -validvalue {}               -type str|num|null    -default "nothing"
            setdef options brushSelect            -minversion 5        -validvalue {}               -type bool            -default "True"
            setdef options brushStyle             -minversion 5        -validvalue {}               -type dict|null       -default [ticklecharts::brushStyle $d]
            setdef options handleLabel            -minversion "5.6.0"  -validvalue {}               -type dict|null       -default [ticklecharts::handleLabel $d]
            # not supported yet...
            # setdef options emphasis             -minversion 5        -validvalue {}               -type dict|null       -default [ticklecharts::emphasis $d]
            #...
        }
        default {
            error "Type name should be 'inside' or 'slider' for 'dataZoom' property."
        }
    }

    # remove key(s)...
    set d [dict remove $d dataBackground selectedDataBackground \
                          moveHandleStyle textStyle brushStyle emphasis handleLabel]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::parallel {value} {
    # options : https://echarts.apache.org/en/option.html#parallel
    #
    # value - Options described in proc ticklecharts::parallel below.
    #
    # Returns dict parallel options

    # Gets key value.
    set d [ticklecharts::getValue $value "-parallel"]

    setdef options id                  -minversion 5  -validvalue {}                    -type str|null      -default "nothing"
    setdef options zlevel              -minversion 5  -validvalue {}                    -type num|null      -default "nothing"
    setdef options z                   -minversion 5  -validvalue {}                    -type num           -default 2
    setdef options left                -minversion 5  -validvalue formatLeft            -type str|num|null  -default "nothing"
    setdef options top                 -minversion 5  -validvalue formatTop             -type str|num|null  -default "nothing"
    setdef options right               -minversion 5  -validvalue formatRight           -type str|num|null  -default "auto"
    setdef options bottom              -minversion 5  -validvalue formatBottom          -type str|num|null  -default "nothing"
    setdef options width               -minversion 5  -validvalue {}                    -type str|num|null  -default "auto"
    setdef options height              -minversion 5  -validvalue {}                    -type str|num|null  -default "auto"
    setdef options layout              -minversion 5  -validvalue formatOrient          -type str           -default "horizontal"
    setdef options axisExpandable      -minversion 5  -validvalue {}                    -type bool          -default "False"
    setdef options axisExpandCenter    -minversion 5  -validvalue {}                    -type num|null      -default "nothing"
    setdef options axisExpandCount     -minversion 5  -validvalue {}                    -type num|null      -default "nothing"
    setdef options axisExpandWidth     -minversion 5  -validvalue {}                    -type num|null      -default 50
    setdef options axisExpandTriggerOn -minversion 5  -validvalue formatExpandTriggerOn -type str           -default "click"
    setdef options parallelAxisDefault -minversion 5  -validvalue {}                    -type dict|null     -default [ticklecharts::parallelAxisDefault $d]
    #...

    # remove key(s)...
    set d [dict remove $d parallelAxisDefault]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::brush {value} {
    # options : https://echarts.apache.org/en/option.html#brush
    #
    # value - Options described in proc ticklecharts::brush below.
    #
    # Returns dict brush options

    # Gets key value.
    set d [ticklecharts::getValue $value "-brush"]

    setdef options id             -minversion 5  -validvalue {}                    -type str|null             -default "nothing"
    setdef options toolbox        -minversion 5  -validvalue formatToolBox         -type list.s               -default [list {rect polygon keep clear}]
    setdef options brushLink      -minversion 5  -validvalue formatBrushLink       -type str|list.n|null      -default "all"
    setdef options geoIndex       -minversion 5  -validvalue formatBrushIndex      -type str|list.n|num|null  -default "nothing"
    setdef options xAxisIndex     -minversion 5  -validvalue formatBrushIndex      -type str|list.n|num|null  -default "nothing"
    setdef options yAxisIndex     -minversion 5  -validvalue formatBrushIndex      -type str|list.n|num|null  -default "nothing"
    setdef options brushType      -minversion 5  -validvalue formatBrushType       -type str                  -default "rect"
    setdef options brushMode      -minversion 5  -validvalue formatBrushMode       -type str                  -default "single"
    setdef options transformable  -minversion 5  -validvalue {}                    -type bool|null            -default "True"
    setdef options brushStyle     -minversion 5  -validvalue {}                    -type dict|null            -default [ticklecharts::brushStyleItem $d]
    setdef options throttleType   -minversion 5  -validvalue formatThrottle        -type str                  -default "fixRate"
    setdef options throttleDelay  -minversion 5  -validvalue {}                    -type num|null             -default "nothing"
    setdef options removeOnClick  -minversion 5  -validvalue {}                    -type bool|null            -default "True"
    setdef options inBrush        -minversion 5  -validvalue {}                    -type dict|null            -default [ticklecharts::brushVisual "inBrush" $d]
    setdef options outOfBrush     -minversion 5  -validvalue {}                    -type dict|null            -default [ticklecharts::brushVisual "outOfBrush" $d]
    setdef options z              -minversion 5  -validvalue {}                    -type num                  -default 10000
    #...

    # remove key(s)...
    set d [dict remove $d brushStyle inBrush outOfBrush]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::axisPointerGlobal {value} {
    # options : https://echarts.apache.org/en/option.html#axisPointer
    #
    # value - Options described in proc ticklecharts::axisPointerGlobal below.
    #
    # Returns dict axisPointer options

    # Gets key value.
    set d [ticklecharts::getValue $value "-axisPointer"]

    setdef options id               -minversion 5       -validvalue {}                    -type str|null        -default "nothing"
    setdef options show             -minversion 5       -validvalue {}                    -type bool            -default "True"
    setdef options type             -minversion 5       -validvalue formatAxisPointerType -type str             -default "line"
    setdef options snap             -minversion 5       -validvalue {}                    -type bool|null       -default "nothing"
    setdef options z                -minversion 5       -validvalue {}                    -type num|null        -default "nothing"
    setdef options label            -minversion 5       -validvalue {}                    -type dict|null       -default [ticklecharts::label $d]
    setdef options lineStyle        -minversion 5       -validvalue {}                    -type dict|null       -default [ticklecharts::lineStyle $d]
    setdef options shadowStyle      -minversion 5       -validvalue {}                    -type dict|null       -default [ticklecharts::shadowStyle $d]
    setdef options triggerTooltip   -minversion 5       -validvalue {}                    -type bool            -default "True"
    setdef options triggerEmphasis  -minversion "5.4.3" -validvalue {}                    -type bool|null       -default "nothing"
    setdef options value            -minversion 5       -validvalue {}                    -type num|null        -default "nothing"
    setdef options status           -minversion 5       -validvalue formatAPStatus        -type str|null        -default "nothing"
    setdef options handle           -minversion 5       -validvalue {}                    -type dict|null       -default [ticklecharts::handle $d]
    setdef options link             -minversion 5       -validvalue {}                    -type list.o|null     -default [ticklecharts::linkAxisPointerItem $d]
    setdef options triggerOn        -minversion 5       -validvalue formatTriggerOn       -type str             -default "mousemove|click"
    #...

    # remove key(s)...
    set d [dict remove $d label lineStyle shadowStyle handle link]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::geo {value} {
    # options : https://echarts.apache.org/en/option.html#geo
    #
    # value - Options described in proc ticklecharts::geo below.
    #
    # Returns dict geo options

    # Gets key value.
    set d [ticklecharts::getValue $value "-geo"]

    setdef options id              -minversion 5        -validvalue {}                  -type str|null       -default "nothing"
    setdef options show            -minversion 5        -validvalue {}                  -type bool           -default "True"
    setdef options map             -minversion 5        -validvalue {}                  -type str|null       -default "nothing"
    setdef options roam            -minversion 5        -validvalue formatRoam          -type str|bool       -default "True"
    setdef options projection      -minversion "5.3.0"  -validvalue {}                  -type dict|null      -default [ticklecharts::projection $d]
    setdef options center          -minversion 5        -validvalue {}                  -type list.n|null    -default "nothing"
    setdef options aspectScale     -minversion 5        -validvalue {}                  -type num|null       -default "nothing"
    setdef options boundingCoords  -minversion 5        -validvalue {}                  -type list.n|null    -default "nothing"
    setdef options zoom            -minversion 5        -validvalue {}                  -type num            -default 1
    setdef options scaleLimit      -minversion 5        -validvalue {}                  -type dict|null      -default [ticklecharts::scaleLimit $d]
    setdef options nameMap         -minversion 5        -validvalue {}                  -type dict|null      -default [ticklecharts::nameMap $d]
    setdef options nameProperty    -minversion 5        -validvalue {}                  -type str|null       -default "nothing"
    setdef options selectedMode    -minversion 5        -validvalue formatSelectedMode  -type bool|str|null  -default "False"
    setdef options label           -minversion 5        -validvalue {}                  -type dict|null      -default [ticklecharts::label $d]
    setdef options itemStyle       -minversion 5        -validvalue {}                  -type dict|null      -default [ticklecharts::itemStyle $d]
    setdef options emphasis        -minversion 5        -validvalue {}                  -type dict|null      -default [ticklecharts::emphasis $d]
    setdef options select          -minversion 5        -validvalue {}                  -type dict|null      -default [ticklecharts::select $d]
    setdef options blur            -minversion "5.1.0"  -validvalue {}                  -type dict|null      -default [ticklecharts::blur $d]
    setdef options zlevel          -minversion 5        -validvalue {}                  -type num            -default 0
    setdef options z               -minversion 5        -validvalue {}                  -type num            -default 2
    setdef options left            -minversion 5        -validvalue formatLeft          -type num|str        -default "auto"
    setdef options top             -minversion 5        -validvalue formatTop           -type num|str        -default "auto"
    setdef options right           -minversion 5        -validvalue formatRight         -type num|str        -default "auto"
    setdef options bottom          -minversion 5        -validvalue formatBottom        -type num|str        -default "auto"
    setdef options layoutCenter    -minversion 5        -validvalue {}                  -type list.d|null    -default "nothing"
    setdef options layoutSize      -minversion 5        -validvalue {}                  -type num|str|null   -default "nothing"
    setdef options regions         -minversion 5        -validvalue {}                  -type list.o|null    -default [ticklecharts::regionsItem $d]
    setdef options silent          -minversion 5        -validvalue {}                  -type bool           -default "False"
    setdef options tooltip         -minversion 5        -validvalue {}                  -type dict|null      -default [ticklecharts::tooltip $d]
    #...

    # remove key(s)...
    set d [dict remove $d projection scaleLimit nameMap label itemStyle \
                          emphasis select blur regions tooltip]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::calendar {value} {
    # options : https://echarts.apache.org/en/option.html#calendar
    #
    # value - Options described in proc ticklecharts::calendar below.
    #
    # Returns dict calendar options

    # Gets key value.
    set d [ticklecharts::getValue $value "-calendar"]

    setdef options id          -minversion 5  -validvalue {}            -type str|null              -default "nothing"
    setdef options zlevel      -minversion 5  -validvalue {}            -type num                   -default 0
    setdef options z           -minversion 5  -validvalue {}            -type num                   -default 2
    setdef options left        -minversion 5  -validvalue formatLeft    -type num|str|null          -default "nothing"
    setdef options top         -minversion 5  -validvalue formatTop     -type num|str|null          -default "nothing"
    setdef options right       -minversion 5  -validvalue formatRight   -type num|str|null          -default "nothing"
    setdef options bottom      -minversion 5  -validvalue formatBottom  -type num|str|null          -default "nothing"
    setdef options width       -minversion 5  -validvalue {}            -type str|num|null          -default "nothing"
    setdef options height      -minversion 5  -validvalue {}            -type str|num|null          -default "nothing"
    setdef options range       -minversion 5  -validvalue {}            -type str|num|list.d|null   -default "auto"
    setdef options cellSize    -minversion 5  -validvalue {}            -type str|num|list.d|null   -default "nothing"
    setdef options orient      -minversion 5  -validvalue formatOrient  -type str                   -default "horizontal"
    setdef options splitLine   -minversion 5  -validvalue {}            -type dict|null             -default [ticklecharts::splitLine $d]
    setdef options itemStyle   -minversion 5  -validvalue {}            -type dict|null             -default [ticklecharts::itemStyle $d]
    setdef options dayLabel    -minversion 5  -validvalue {}            -type dict|null             -default [ticklecharts::calendarLabel $d "dayLabel"]
    setdef options monthLabel  -minversion 5  -validvalue {}            -type dict|null             -default [ticklecharts::calendarLabel $d "monthLabel"]
    setdef options yearLabel   -minversion 5  -validvalue {}            -type dict|null             -default [ticklecharts::calendarLabel $d "yearLabel"]
    setdef options silent      -minversion 5  -validvalue {}            -type bool                  -default "False"
    #...

    # remove key(s)...
    set d [dict remove $d splitLine itemStyle dayLabel monthLabel yearLabel]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::aria {value} {
    # options : https://echarts.apache.org/en/option.html#aria
    #
    # value - Options described in proc ticklecharts::aria below.
    #
    # Returns dict aria options

    # Gets key value.
    set d [ticklecharts::getValue $value "-aria"]

    setdef options enabled   -minversion 5   -validvalue {}   -type bool       -default "True"
    setdef options label     -minversion 5   -validvalue {}   -type dict|null  -default [ticklecharts::ariaLabel $d]
    setdef options decal     -minversion 5   -validvalue {}   -type dict|null  -default [ticklecharts::ariaDecal $d]
    #...

    # remove key(s)...
    set d [dict remove $d label decal]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::gmap {value} {
    # options : https://github.com/plainheart/echarts-extension-gmap
    # + https://developers.google.com/maps/documentation/javascript/reference/map#MapOptions
    #
    # value - Options described in proc ticklecharts::gmap below.
    #
    # Returns dict bmap options

    # Gets key value.
    set d [ticklecharts::getValue $value "-gmap"]

    setdef options center              -minGMversion 1.4.0 -validvalue {}           -type list.n         -default {}
    setdef options zoom                -minGMversion 1.4.0 -validvalue {}           -type num            -default 5
    setdef options roam                -minGMversion 1.4.0 -validvalue {}           -type bool           -default "False"
    setdef options renderOnMoving      -minGMversion 1.4.0 -validvalue {}           -type bool           -default "True"
    setdef options echartsLayerZIndex  -minGMversion 1.4.0 -validvalue {}           -type num            -default 2000
    # google maps API
    setdef options backgroundColor     -minversion {} -validvalue formatColor      -type str|null        -default "nothing"
    setdef options disableDefaultUI    -minversion {} -validvalue {}               -type bool|null       -default "nothing"
    setdef options zoomControl         -minversion {} -validvalue {}               -type bool|null       -default "nothing"
    setdef options mapTypeControl      -minversion {} -validvalue {}               -type bool|null       -default "nothing"
    setdef options scaleControl        -minversion {} -validvalue {}               -type bool|null       -default "nothing"
    setdef options streetViewControl   -minversion {} -validvalue {}               -type bool|null       -default "nothing"
    setdef options rotateControl       -minversion {} -validvalue {}               -type bool|null       -default "nothing"
    setdef options fullscreenControl   -minversion {} -validvalue {}               -type bool|null       -default "nothing"
    setdef options mapTypeId           -minversion {} -validvalue formatMapTypeID  -type str|jsfunc|null -default "roadmap"
    setdef options styles              -minversion {} -validvalue {}               -type list.o|null     -default [ticklecharts::mapGStyle $d]
    #...

    # remove key(s)...
    set d [dict remove $d styles]

    set options [merge $options $d]

    return [new edict $options]
}