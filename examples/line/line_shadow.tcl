lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

# https://www.makeapie.cn/echarts_content/x4SFfqL-2R.html
# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set colorList {#9E87FF #73DDFF #fe9a8b #F56948 #9E87FF}

set ec [ticklecharts::eColor new {
        type "linear"
        x  0
        y  0
        x2 0
        y2 1
        colorStops {
            {offset 0    color "#fff"}
            {offset 0.86 color "#fff"}
            {offset 0.86 color "#33c0cd"}
            {offset 1    color "#33c0cd"}
        }
        global false
    }
]

set jscolor [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 1, 0, 0, [
                {offset: 0,color: "#9effff"},
                {offset: 1,color: "#9E87FF"}]),
                }]

set jscolor1 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(1, 1, 0, 0, [
                {offset: 0,color: "#73DD39"},
                {offset: 1,color: "#73DDFF"}]),
                }]

set jscolor2 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 1, 0, [
                {offset: 0,color: "#fe9a"},
                {offset: 1,color: "#fe9a8b"}]),
                }]

set chart [ticklecharts::chart new]


$chart SetOptions -backgroundColor "#fff" \
                  -title {text "Sportswear" textStyle {fontSize 20 fontWeight 400} top 5% left 5%} \
                  -legend {icon "circle" top 5% right 5% itemWidth 6 itemGap 20 textStyle {color #556677}} \
                  -tooltip {
                    trigger "axis" axisPointer {
                      label {show true backgroundColor "#fff" color #556677 borderColor "rgb(0,0,0)" shadowColor "rgb(0,0,0)" shadowOffsetY 0}
                      lineStyle {width 0}
                    }
                    backgroundColor "#fff" 
                    textStyle {color #5c6c7c}
                    padding {{10 10}}
                    extraCssText "box-shadow: 1px 0 2px 0 rgba(163,163,163,0.5)"
                  } \
                  -grid {top 15%}

$chart Xaxis -type "category" \
             -data {{France USA China Portugal Spain Croatia Italy}} \
             -axisLine {lineStyle {color #DCE2E8}} \
             -axisTick {show false} \
             -axisLabel {interval 0 color #556677 fontSize 12 margin 15} \
             -axisPointer [list label [list padding {{0 0 10 0}} margin 15 fontSize 12 backgroundColor $ec]] \
             -boundaryGap false


$chart Yaxis -type "value" \
             -axisTick {show false} \
             -axisLine {show true lineStyle {color #DCE2E8}} \
             -axisLabel {color #556677} \
             -splitLine {show false}

$chart Yaxis -type "value" \
             -position "right" \
             -axisTick {show false} \
             -axisLabel {color #556677 formatter {"{value}"}} \
             -axisLine {show true lineStyle {color #DCE2E8}} \
             -splitLine {show false}


$chart Add "lineSeries" -name "Adidas" \
                        -data {{10 10 30 12 15 3 7}} \
                        -smooth true \
                        -yAxisIndex 0 \
                        -showSymbol false \
                        -lineStyle [list width 5 color $jscolor shadowColor "rgba(158,135,255, 0.3)" shadowBlur 10 shadowOffsetY 20] \
                        -itemStyle [list color [lindex $colorList 0] borderColor [lindex $colorList 0]]

$chart Add "lineSeries" -name "Nike" \
                        -data {{5 12 11 14 25 16 10}} \
                        -smooth true \
                        -yAxisIndex 0 \
                        -showSymbol false \
                        -lineStyle [list width 5 color $jscolor1 shadowColor "rgba(115,221,255, 0.3)" shadowBlur 10 shadowOffsetY 20] \
                        -itemStyle [list color [lindex $colorList 1] borderColor [lindex $colorList 1]]

$chart Add "lineSeries" -name "Patagonia" \
                        -data {{150 120 170 140 500 160 110}} \
                        -smooth true \
                        -yAxisIndex 1 \
                        -showSymbol false \
                        -lineStyle [list width 5 color $jscolor2 shadowColor "rgba(254,154,139, 0.3)" shadowBlur 10 shadowOffsetY 20] \
                        -itemStyle [list color [lindex $colorList 2] borderColor [lindex $colorList 2]]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -title "Magic ticklEcharts..." \
              -outfile [file join $dirname $fbasename.html]
