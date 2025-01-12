# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::formatEcharts {formattype value key type} {
    # Verification of certain values (especially for string types) 
    # In order to respect the values according to the Echarts documentation.
    #
    # formattype - format type of validation.
    # value      - value to be verified.
    # key        - key flag.
    # type       - type of value.
    #
    # Returns nothing or raise an error if the value does
    # not match the default values or does not exactly conform
    # to a range of values.
    variable echarts_version

    if {$formattype eq ""} {
        return {}
    }

    if {$type eq "str.e"} {
        set value [$value get]
        set type  "str"
    }

    if {$value in {nothing null}} {
        return {}
    }
    
    set nameproc [ticklecharts::getLevelProperties [expr {[info level] - 1}]]

    switch -exact -- $formattype {

        formatTarget {
            # possible values...
            set validvalue {self blank}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTextAlign {
            # possible values...
            set validvalue {auto left right center}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatVerticalTextAlign {
            # possible values...
            set validvalue {auto top bottom middle}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatBarCategoryGap -
        formatBarGap {
            # possible values...
            if {![regexp {^[-0-9.]+%$} $value]} {
                errorEFormat "$key\($nameproc) : The gap between bars between different series,\
                    is a percent value like '30%', which means 30% of the bar width.\
                    Set barGap as '-100%' can overlap bars that belong to different series,\
                    which is useful when making a series of bar be background."
            }
        }

        formatLeft {
            # possible values...
            lappend validvalue {^auto$|^left$|^center$|^right$}
            lappend validvalue {^[0-9.]+%$}
            lappend validvalue {^[0-9.]+$}

            set match 0
            foreach re $validvalue {
                if {[regexp $re $value]} {
                    set match 1 ; break
                }
            }

            if {!$match} {
                errorEFormat "$key\($nameproc) : value can be instant pixel value like 20;\
                    it can also be a percentage value relative to container width like '20%';\
                    and it can also be 'auto', left', 'center', or 'right'"
            }
        }

        formatERight -
        formatELeft {
            # possible values...
            lappend validvalue {^left$|^center$|^right$}
            lappend validvalue {^[0-9.]+%$}
            lappend validvalue {^[0-9.]+$}

            set match 0
            foreach re $validvalue {
                if {[regexp $re $value]} {
                    set match 1 ; break
                }
            }

            if {!$match} {
                errorEFormat "$key\($nameproc) : Pixel value. For example, can be a number 30, means 30px.\
                    Percent value: For example, can be a string '33%', means the final result\
                    should be calculated by this value and the height of its parent.\
                    'center': means position the element in the middle of according to its parent.\
                    Only one between left and right can work."
            }
        }

        formatETop -
        formatEBottom {
            # possible values...
            lappend validvalue {^top$|^middle$|^bottom$}
            lappend validvalue {^[0-9.]+%$}
            lappend validvalue {^[0-9.]+$}

            set match 0
            foreach re $validvalue {
                if {[regexp $re $value]} {
                    set match 1 ; break
                }
            }

            if {!$match} {
                errorEFormat "$key\($nameproc) : Pixel value. For example, can be a number 30, means 30px.\
                    Percent value: For example, can be a string '33%', means the final result\
                    should be calculated by this value and the height of its parent.\
                    'middle': means position the element in the middle of according to its parent.\
                    Only one between top and bottom can work."
            }
        }

        formatTop {
            # possible values...
            lappend validvalue {^auto$|^top$|^middle$|^bottom$}
            lappend validvalue {^[0-9.]+%$}
            lappend validvalue {^[0-9.]+$}

            set match 0
            foreach re $validvalue {
                if {[regexp $re $value]} {
                    set match 1 ; break
                }
            }

            if {!$match} {
                errorEFormat "$key\($nameproc) value can be instant pixel value like 20;\
                    it can also be a percentage value relative to container width like '20%';\
                    and it can also be 'auto', top', 'middle', or 'bottom'"
            }
        }

        formatBottom - 
        formatRight {
            # possible values...
            lappend validvalue {^auto$}
            lappend validvalue {^[0-9.]+%$}
            lappend validvalue {^[0-9.]+$}

            set match 0
            foreach re $validvalue {
                if {[regexp $re $value]} {
                    set match 1 ; break
                }
            }

            if {!$match} {
                errorEFormat "$key\($nameproc) value can be instant pixel value like 20;\
                    it can also be a percentage value relative to container width like '20%'."
            }
        }

        formatColor {
            if {$type in {list list.e}} {
                if {$type eq "list.e"} {
                    set value [$value get]
                }
                if {[llength $value] == 1} {
                    set value {*}$value
                }
                foreach val $value {
                    ticklecharts::formatEcharts $formattype $val $key [ticklecharts::typeOf $val]
                }
            }
            if {$type eq "str"} {
                # possible values...
                lappend validvalue {^white$|^black$|^red$|^blue$|^green$|^transparent$|^inherit$|^source$|^gradient$}
                lappend validvalue {^#[a-zA-Z0-9]{3,6}$}
                lappend validvalue {^rgb\(\s*([0-9]+),\s*([0-9]+),\s*([0-9]+)\)$}
                lappend validvalue {^rgba\(\s*([0-9]+),\s*([0-9]+),\s*([0-9]+),\s*(?:1|0?\.[0-9]+)\)$}
                lappend validvalue {^hsl\(\s*(\d+)\s*,\s*(\d+(?:\.\d+)?%)\s*,\s*(\d+(?:\.\d+)?%)\)$}
                lappend validvalue {^auto$}

                set match 0
                foreach re $validvalue {
                    if {[regexp $re $value]} {
                        set match 1 ; break
                    }
                }

                if {!$match} {
                    errorEFormat "$key\($nameproc). Color can be represented in RGB, for example 'rgb(128, 128, 128)'.\
                        RGBA can be used when you need alpha channel, for example 'rgba(128, 128, 128, 0.5)'.\
                        You may also use hexadecimal format, for example '#ccc'. The current value is '$value'"
                }
            }
        }

        formatFontStyle {
            # possible values...
            set validvalue {normal italic oblique}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatFontWeight {
            # possible values...
            if {$type eq "str"} {
                set validvalue {normal bold bolder lighter}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatBorderType    -
        formatCrossStyle    -
        formatLineStyleType -
        formatTextBorderType {
            # possible values...
            if {$type eq "str"} {
                set validvalue {inherit solid dashed dotted}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatOverflow {
            # possible values...
            set validvalue {truncate break breakAll none}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTrigger {
            # possible values...
            set validvalue {item axis none}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatExpandTriggerOn {
            # possible values...
            set validvalue {mousemove click}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }
        formatTriggerOn {
            # possible values...
            set validvalue {mousemove click mousemove|click none}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatRenderMode {
            # possible values...
            set validvalue {html richText}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatConfine {
            # possible values...
            if {$type eq "str"} {
                set validvalue {inside top left right bottom}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                            for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatOrder {
            # possible values...
            set validvalue {seriesAsc seriesDesc valueAsc valueDesc}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatAxisPointerType {
            # possible values...
            set validvalue {line shadow none cross}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatAxisPointerAxis {
            # possible values...
            set validvalue {auto x y radius angle}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatAEasing {
            # possible values...
            # see https://echarts.apache.org/examples/en/editor.html?c=line-easing
            set validvalue {
                linear quadraticIn quadraticOut quadraticInOut cubicIn
                cubicOut cubicInOut quarticIn quarticOut quarticInOut
                quinticIn quinticOut quinticInOut sinusoidalIn sinusoidalOut
                sinusoidalInOut exponentialIn exponentialOut exponentialInOut
                circularIn circularOut circularInOut elasticIn elasticOut
                elasticInOut backIn backOut backInOut bounceIn bounceOut
                bounceInOut
            }
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatCap {
            # possible values...
            set validvalue {inherit butt round square}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatJoin {
            # possible values...
            set validvalue {bevel round miter}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatOpacity {
            # possible values...
            if {$type eq "num"} {
                if {![expr {$value >= 0 && $value <= 1}]} {
                    errorEFormat "'$value' should be between '0' and '1'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatLegendType {
            # possible values...
            set validvalue {plain scroll}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatOrient {
            # possible values...
            set validvalue {horizontal vertical}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatAlign -
        formatVisualMapAlign {
            # possible values...
            set validvalue {auto left right}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatSelectedMode {
            # possible values...
            if {$type eq "str"} {
                if {[ticklecharts::vCompare $echarts_version "5.3.0"] >= 0} {
                    set validvalue {multiple single series}
                } else {
                    set validvalue {multiple single}
                }

                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatItemSymbol {
            if {$type in {list list.e}} {
                if {$type eq "list.e"} {
                    set value [$value get]
                }
                if {[llength $value] == 1} {
                    set value {*}$value
                }
                foreach val $value {
                    ticklecharts::formatEcharts $formattype $val $key [ticklecharts::typeOf $val]
                }
            }
            # possible values...
            if {$type eq "str"} {
                set validvalue {emptyCircle circle rect roundRect triangle diamond pin arrow none image://* path://*}
                set match 0
                foreach val $validvalue {
                    if {[string match $val $value]} {
                        set match 1 ; break
                    }
                }
                if {!$match} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatColorBy {
            # possible values...
            set validvalue {series data}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatCSYS {
            # possible values...
            set validvalue {cartesian2d polar geo}

            switch -exact -- [ticklecharts::whichSeries? $nameproc] {
                "themeRiverSeries" {set validvalue "single"}
                "parallelSeries"   {set validvalue "parallel"}
                "graphSeries"      {append validvalue " calendar none"}
                "pieSeries"        {append validvalue " calendar none gmap"}
                "heatmapSeries"    {append validvalue " calendar gmap"}
                "scatterSeries"    {append validvalue " calendar gmap"}
                "linesSeries"      {set validvalue {cartesian2d gmap geo}}
                "surfaceSeries"    -
                "line3DSeries"     {set validvalue "cartesian3D"}
                "lines3DSeries"    {set validvalue {geo3D globe}}
                "scatter3DSeries"  -
                "bar3DSeries"      {set validvalue {cartesian3D geo3D globe}}
            }

            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatSampling {
            # possible values...
            set validvalue {lttb average max min sum}
            if {[ticklecharts::vCompare $echarts_version "5.5.0"] >= 0} {
                append validvalue " minmax"
            }
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatPChunkMode {
            # possible values...
            set validvalue {sequential mod}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatSMonotone {
            # possible values...
            set validvalue {x y}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatPadangle -
        formatStartangle {
            # possible values...
            if {![expr {$value >= 0 && $value <= 360}]} {
                errorEFormat "'$value' should be between '0' and '360'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatEndangle {
            # possible values...
            if {([ticklecharts::whichSeries? $nameproc] eq "pieSeries") && ($type eq "str")} {
                if {$value ne "auto"} {
                    errorEFormat "'$value' should be 'auto'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            } else {
                if {![expr {$value <= 0 && $value >= -360}]} {
                    errorEFormat "'$value' should be between '0' and '-360'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatAType {
            # possible values...
            set validvalue {expansion scale}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatATypeUpdate {
            # possible values...
            set validvalue {expansion transition}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatSort {
            # possible values...
            if {$type eq "str"} {
                set validvalue {descending ascending none desc asc}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatFunnelAlign {
            # possible values...
            set validvalue {center left right right}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatPosition {
            # possible values...
            if {$type eq "str"} {
                set validvalue {
                        top left right bottom inside insideLeft insideRight insideTop
                        insideBottom insideTopLeft insideBottomLeft insideTopRight insideBottomRight
                    }

                switch -exact -- [ticklecharts::whichSeries? $nameproc] {
                    "barSeries" {
                        if {[ticklecharts::vCompare $echarts_version "5.2.0"] >= 0} {
                            append validvalue " start insideStart middle insideEnd end"
                        }
                    }
                    "sunburstSeries" {append validvalue " outside"}
                    "pieSeries"      {set validvalue {outside inside inner center outer}}
                }

                if {[string match "*calendar*" $nameproc]} {
                    set validvalue {start end}
                }

                if {[string match "*Series.markLine*" $nameproc]} {
                    set validvalue {
                            start middle end insideStart insideStartTop insideStartBottom
                            insideMiddle insideMiddleTop insideMiddleBottom
                            insideEnd insideEndTop insideEndBottom
                        }
                }

                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatMoveOverlap {
            # possible values...
            set validvalue {shiftX shiftY}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatBlurScope {
            # possible values...
            set validvalue {none coordinateSystem series global}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatType {
            # possible values...
            set validvalue {value category time log}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatNameLocation {
            # possible values...
            set validvalue {start middle center end}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatShape {
            # possible values...
            set validvalue {polygon circle}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatEdgeShape {
            # possible values...
            set validvalue {curve polyline}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatXAxisPosition {
            # possible values...
            set validvalue {top bottom}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatYAxisPosition {
            # possible values...
            set validvalue {left right}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatShowAllSymbol {
            # possible values...
            if {$type eq "str"} {
                set validvalue {auto}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatCursor {
            # possible values...
            set validvalue {
                pointer crosshair help move progress text wait e-resize
                ne-resize nw-resize n-resize se-resize sw-resize s-resize w-resize
            }
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatBounding {
            # possible values...
            set validvalue {all raw}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatFocus {
            # possible values...
            set validvalue {none self series ancestor descendant adjacency}

            if {[ticklecharts::whichSeries? $nameproc] eq "treeSeries"} {
                if {[ticklecharts::vCompare $echarts_version "5.3.3"] >= 0} {
                    set validvalue {none ancestor descendant relative}
                } else {
                    set validvalue {none ancestor descendant}
                }
            }
            if {[ticklecharts::whichSeries? $nameproc] eq "sankeySeries"} {
                if {[ticklecharts::vCompare $echarts_version "5.4.3"] >= 0} {
                    set validvalue {none self series adjacency trajectory}
                } else {
                    set validvalue {none self series adjacency}
                }
            }
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatShapeSmooth {
            # possible values...
            if {$type eq "str"} {
                set validvalue {spline}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatDivideShape {
            # possible values...
            set validvalue {split clone}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatInterval {
            # possible values...
            if {$type eq "str"} {
                set validvalue {auto}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatAlignTo {
            # possible values...
            set validvalue {none labelLine edge}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatRoseType {
            # possible values...
            if {$type eq "str"} {
                set validvalue {radius area}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatStep {
            # possible values...
            if {$type eq "str"} {
                set validvalue {start middle end}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatEdgeLabelPosition {
            # possible values...
            set validvalue {start middle end}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatEbrushType {
            # possible values...
            set validvalue {stroke fill}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatRenderer {
            # possible values...
            set validvalue {canvas svg}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatSaveAsImg {
            # possible values...
            set validvalue {png jpg svg}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatFilterMode {
            # possible values...
            set validvalue {filter weakFilter empty none}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTextPosition {
            # possible values...
            set validvalue {left right top bottom}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatNodeClick {
            # possible values...
            set validvalue {rootToNode link}

            if {[ticklecharts::whichSeries? $nameproc] eq "treemapSeries"} {
                set validvalue {link zoomToNode}
            }

            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatRotate {
            # possible values...
            if {$type eq "str"} {
                set validvalue {radial tangential}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            } elseif {$type eq "num"} {
                if {![expr {$value >= -90 && $value <= 90}]} {
                    errorEFormat "'$value' should be between '-90' and '90'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatLayout {
            # possible values...
            set validvalue {orthogonal radial}

            if {[ticklecharts::whichSeries? $nameproc] eq "graphSeries"} {
                set validvalue {none circular force}
            }

            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTreeOrient {
            # possible values...
            set validvalue {LR RL TB BT}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatEForkPosition  {
            # possible values...
            if {![regexp {^[0-9.]+%$} $value]} {
                errorEFormat "'$value' should be be between\['0%', '100%'\]\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatRoam {
            # possible values...
            if {$type eq "str"} {
                set validvalue {scale move}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatNodeAlign {
            # possible values...
            set validvalue {left right justify}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatMaxMin {
            # possible values...
            if {![expr {$value >= 0 && $value <= 100}]} {
                errorEFormat "'$value' should be between '0' and '100'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatZoomMW {
            # possible values...
            if {$type eq "str"} {
                set validvalue {shift ctrl alt}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatTransform {
            # possible values...
            set validvalue {filter sort ecSimpleTransform:aggregate ecStat:regression boxplot}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatDimType {
            # possible values...
            set validvalue {number float int ordinal time}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatSeriesLayout {
            # possible values...
            set validvalue {row column}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatSourceHeader {
            # possible values...
            if {$type eq "str"} {
                set validvalue {undefined auto}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatSymbolPosition {
            # possible values...
            set validvalue {start end center}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatSymbolRepeat {
            # possible values...
            if {$type eq "str"} {
                set validvalue {fixed}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatSelectorPos -
        formatsymbolRepeatDirs {
            # possible values...
            set validvalue {start end}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatBrushIndex -
        formatToolBox {
            # possible values...
            set validvalue {rect polygon keep clear}

            if {$type in {list list.e}} {
                if {$type eq "list.e"} {
                    set value [$value get]
                }
                if {[llength $value] == 1} {
                    set value {*}$value
                }
                foreach val $value {
                    if {$val ni $validvalue} {
                        errorEFormat "'$value' should be '[eFormat $validvalue]'\
                            for this key: '$key' in '$nameproc' level procedure."
                    }
                }
            }
        }

        formatBrushLink {
            # possible values...
            if {$type eq "str"} {
                set validvalue {all none}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatBrushTypes {
            # possible values...
            set validvalue {rect polygon lineX lineY}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatBrushMode {
            # possible values...
            set validvalue {single multiple}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatBrushMode {
            # possible values...
            set validvalue {debounces fixRate}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTimelineType {
            # possible values...
            set validvalue {slider}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTimelineAxisType {
            # possible values...
            set validvalue {time category value}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTimelineMerge {
            if {$type in {list list.e}} {
                if {$type eq "list.e"} {
                    set value [$value get]
                }
                if {[llength $value] == 1} {
                    set value {*}$value
                }
                foreach val $value {
                    ticklecharts::formatEcharts $formattype $val $key [ticklecharts::typeOf $val]
                }
            }
            if {$type eq "str"} {
                # possible values...
                set validvalue {xAxis series}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatTimelinePosition {
            # possible values...
            set validvalue {left right}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTimelineIcon {
            set validvalue {image://* path://*}
            set match 0
            foreach val $validvalue {
                if {[string match $val $value]} {
                    set match 1 ; break
                }
            }
            if {!$match} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatWCshape {
            # possible values...
            set validvalue {
                circle cardioid diamond triangle-forward triangle
                pentagon triangle-upright star square
            }
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatDataBox {
            if {$type eq "list.e"} {set value [$value get]}
            foreach val $value {
                if {[llength $val] != 5} {
                    errorEFormat "'val' should be a list of 5 elements :\
                        \[min,  Q1,  median (or Q2),  Q3,  max\]\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatColorMapping {
            # possible values...
            set validvalue {value index id}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatStackStrategy {
            # possible values...
            set validvalue {samesign all positive negative}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatAreaStyleOrigin {
            # possible values...
            if {$type eq "str"} {
                set validvalue {auto start end}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatBRadius {
            # possible values...
            if {$type in {list list.e}} {
                if {$type eq "list.e"} {
                    set value [$value get]
                }
                if {[llength $value] == 1} {
                    set value {*}$value
                }
                set len [llength $value]

                if {[ticklecharts::vCompare $echarts_version "5.3.0"] < 0} {
                    if {$len != 2} {
                        errorEFormat "length of list should be equal to 2\
                            for this key: '$key' in '$nameproc' level procedure."
                    }
                }
                if {[ticklecharts::vCompare $echarts_version "5.3.0"] >= 0} {
                    if {![expr {$len == 2 || $len == 4}]} {
                        errorEFormat "length of list should be equal to 2 or 4\
                            for this key: '$key' in '$nameproc' level procedure."
                    }
                }
            }
        }

        formatSEffectOn {
            # possible values...
            set validvalue {render emphasis}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatGaugeALrotate {
            # possible values...
            if {$type eq "str"} {
                set validvalue {radial tangential}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
            if {$type eq "num"} {
                if {![expr {$value >= -90 && $value <= 90}]} {
                    errorEFormat "'$value' should be between '-90' and '90'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatAxisPointerStatus -
        formatAPStatus {
            # possible values...
            set validvalue {show hide}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatNameMap {
            # possible values...
            if {$type eq "str"} {
                if {[ticklecharts::vCompare $echarts_version "5.2.2"] >= 0} {
                    if {[string toupper $value] ne $value} {
                        errorEFormat "Case sensitive is not respected for '$value'\
                            for this key: '$key' in '$nameproc' level procedure."
                    }
                }
                if {[ticklecharts::vCompare $echarts_version "5.2.2"] < 0} {
                    if {[string tolower $value] ne $value} {
                        errorEFormat "Case sensitive is not respected for '$value'\
                            for this key: '$key' in '$nameproc' level procedure."
                    }
                }
            }
        }

        formatTypeColor {
            # possible values...
            set validvalue {linear radial}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatColorRepeat {
            # possible values...
            set validvalue {repeat-x repeat-y no-repeat repeat}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatBevelSize -
        formatRangeTrailLength - 
        formatRangeSymbolSize {
            # possible values...
            if {![expr {$value >= 0 && $value <= 1}]} {
                errorEFormat "'$value' should be between '0' and '1'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatRangeRotation {
            # possible values... (in radians)
            if {![expr {$value >= -3.141592 && $value <= 3.141592}]} {
                errorEFormat "'$value' should be between '-Pi()' and 'Pi()'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatMapTypeID {
            # possible values...
            if {$type eq "str"} {
                set validvalue {roadmap satellite hybrid terrain}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatBlendM {
            # possible values...
            set validvalue {source-over lighter}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatDQuality    -
        formatSSAOQuality -
        formatShadowQuality {
            # possible values...
            set validvalue {low medium high ultra}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatProjection3D {
            # possible values...
            set validvalue {perspective orthogonal orthographic}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatDirection3D {
            # possible values...
            set validvalue {cw ccw}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatMouseButton {
            # possible values...
            set validvalue {left middle right}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatShading3D {
            # possible values...
            set validvalue {color lambert realistic}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTypeLayers {
            # possible values...
            set validvalue {overlay blend}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatBlendTo {
            # possible values...
            set validvalue {albedo emission}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatalignL {
            # possible values...
            set validvalue {left center right}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatValignL {
            # possible values...
            set validvalue {top middle bottom}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatTypeBar      - formatTypeLine    - formatTypePie         -
        formatTypeFunnel   - formatTypeRadar   - formatTypeHeatmap     -
        formatTypeSunburst - formatTypeTree    - formatTypeTRiver      -
        formatTypeSankey   - formatTypePBar    - formatTypeCandlestick -
        formatTypeGauge    - formatTypeGraph   - formatTypeWCloud      -
        formatTypeBoxplot  - formatTypeTreemap - formatTypeMap         -
        formatTypeLines    - formatTypeBar3D   - formatTypeL3D         -
        formatTypeSurf     - formatTypeSc3D    - formatTypeLs3D        - 
        formatTypeScatter {
            # possible values...
            switch -exact -- $formattype {
                formatTypeBar          {set validvalue "bar"}
                formatTypeLine         {set validvalue "line"}
                formatTypePie          {set validvalue "pie"}
                formatTypeFunnel       {set validvalue "funnel"}
                formatTypeRadar        {set validvalue "radar"}
                formatTypeHeatmap      {set validvalue "heatmap"}
                formatTypeSunburst     {set validvalue "sunburst"}
                formatTypeTree         {set validvalue "tree"}
                formatTypeTRiver       {set validvalue "themeRiver"}
                formatTypeSankey       {set validvalue "sankey"}
                formatTypePBar         {set validvalue "pictorialBar"}
                formatTypeGauge        {set validvalue "gauge"}
                formatTypeGraph        {set validvalue "graph"}
                formatTypeWCloud       {set validvalue "wordCloud"}
                formatTypeBoxplot      {set validvalue "boxplot"}
                formatTypeTreemap      {set validvalue "treemap"}
                formatTypeCandlestick  {set validvalue "candlestick"}
                formatTypeScatter      {set validvalue {scatter effectScatter}}
                formatTypeMap          {set validvalue "map"}
                formatTypeLines        {set validvalue "lines"}
                formatTypeBar3D        {set validvalue "bar3D"}
                formatTypeL3D          {set validvalue "line3D"}
                formatTypeSurf         {set validvalue "surface"}
                formatTypeSc3D         {set validvalue "scatter3D"}
                formatTypeLs3D         {set validvalue "lines3D"}
            }
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatIBwidth {
            # possible values...
            if {$type eq "str"} {
                set validvalue {auto inherit}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatRendSnap {
            # possible values...
            set validvalue {base64 png svg}
            if {$value ni $validvalue} {
                errorEFormat "'$value' should be '[eFormat $validvalue]'\
                    for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatExcludeC {
            if {$type eq "list.e"} {
                set value [$value get]
            }
            if {[llength $value] == 1} {
                set value {*}$value
            }
            set validvalue {title toolbox visualMap legend dataZoom}
            foreach val $value {
                if {$val ni $validvalue} {
                    errorEFormat "'$val' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatTimeout {
            # possible values...
            if {![expr {$value >= 200 && $value <= 2000}]} {
                errorEFormat "'$value' should be between '200' and '2000'\
                    milliseconds for this key: '$key' in '$nameproc' level procedure."
            }
        }

        formatMin {
            # possible values...
            if {$type eq "str"} {
                set validvalue {dataMin}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }

        formatMax {
            # possible values...
            if {$type eq "str"} {
                set validvalue {dataMax}
                if {$value ni $validvalue} {
                    errorEFormat "'$value' should be '[eFormat $validvalue]'\
                        for this key: '$key' in '$nameproc' level procedure."
                }
            }
        }
    }

    return {}
}

proc ticklecharts::eFormat {values} {
    # Formatting possible values.
    #
    # values - list.
    #
    # Returns a formatted list.
    if {[llength $values] <= 1} {
        return $values
    }

    set newl [lsort -dictionary $values]
    set newl [format {%s or %s} \
        [join [lrange $newl 0 end-1] ", "] \
        [lindex $newl end] \
    ]

    return $newl
}

proc ticklecharts::errorEFormat {msg} {
    # Returns an error message related 
    # to the incorrect format of the property.
    #
    # msg - string error message.
    #
    # Raise an error.
    return -level [info level] \
           -code error "wrong # eformat: $msg"
}