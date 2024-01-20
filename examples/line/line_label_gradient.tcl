lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# source: https://www.makeapie.cn/echarts_content/xXbP45bsC.html
set chart [ticklecharts::chart new]

# add 'eColor' class for tooltip axisPointer color.
set ec [ticklecharts::eColor new {
        type "linear"
        x 0
        y 0
        x2 0
        y2 1
        colorStops {
            {offset 0   color "rgba(0, 255, 233, 0.01)"}
            {offset 0.5 color "rgba(255, 255, 255,1)"}
            {offset 1   color "rgba(0, 255, 233, 0.01)"}
        }
        global false
    }
]

set jscolor [ticklecharts::jsfunc new {
        new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: 'rgba(108,80,243,0.3)'
            },
            {
                offset: 1,
                color: 'rgba(108,80,243,0)'
            }
        ], false)
    }
]

set jscolor1 [ticklecharts::jsfunc new {
        new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: 'rgba(0,202,149,0.3)'
            },
            {
                offset: 1,
                color: 'rgba(0,202,149,0)'
            }
        ], false)
    }
]

$chart SetOptions -backgroundColor "#080b30" \
                  -title {
                    text "Tcl + Echarts"
                    textStyle {color "#fff" fontSize 20}
                    top "5%"
                    left center
                  } \
                  -tooltip [list \
                    trigger "axis" \
                    axisPointer [list \
                        lineStyle [list color $ec] \
                    ] \
                  ] \
                  -grid {top 15% left 5% right 5% bottom 15%}

$chart Xaxis -type "category" \
             -axisLine {show true} \
             -splitArea {areaStyle {color #f00}} \
             -axisLabel {color #fff} \
             -splitLine {show false} \
             -boundaryGap false \
             -data [list {A B C D E F}]

$chart Yaxis -type "value" \
             -min 0 \
             -splitNumber 4 \
             -splitLine {show true lineStyle {color "rgba(255,255,255,0.1)"}} \
             -axisLine {show false} \
             -axisLabel {show false margin 20 color "#d1e6eb"} \
             -axisTick {show false}


$chart Add "lineSeries" -showAllSymbol true \
                        -data {{502.84 205.97 332.79 281.55 398.35 214.02}} \
                        -symbol circle \
                        -symbolSize 25 \
                        -lineStyle {
                            color "#6c50f3" shadowColor "rgba(0, 0, 0, .3)" shadowBlur 0
                            shadowOffsetY 5 shadowOffsetX 5
                        } \
                        -label {show true position top color #6c50f3} \
                        -itemStyle {
                            color "#6c50f3" shadowColor "rgba(0, 0, 0, .3)" shadowBlur 0
                            shadowOffsetY 2 shadowOffsetX 2 borderColor "#fff" borderWidth 3
                        } \
                        -tooltip {show false} \
                        -areaStyle [list \
                            color $jscolor \
                            shadowColor "rgba(108,80,243, 0.9)" \
                            shadowBlur 20 \
                        ]

$chart Add "lineSeries" -showAllSymbol true \
                        -data {{281.55 398.35 214.02 179.55 289.57 356.14}} \
                        -symbol circle \
                        -symbolSize 25 \
                        -lineStyle {
                            color "#00ca95" shadowColor "rgba(0, 0, 0, .3)" shadowBlur 0
                            shadowOffsetY 5 shadowOffsetX 5
                        } \
                        -label {show true position top color #00ca95} \
                        -itemStyle {
                            color "#00ca95" shadowColor "rgba(0, 0, 0, .3)" shadowBlur 0
                            shadowOffsetY 2 shadowOffsetX 2 borderColor "#fff" borderWidth 3
                        } \
                        -tooltip {show false} \
                        -areaStyle [list \
                            color $jscolor1 \
                            shadowColor "rgba(0,202,149, 0.9)" \
                            shadowBlur 20 \
                        ]



set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -width 1300px -height 900px -title $fbasename
