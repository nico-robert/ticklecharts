lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set jscolor1 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0,color: "rgb(128, 255, 165)"},
                {offset: 1,color: "rgb(1, 191, 236)"}]),
                }]

set jscolor2 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0,color: "rgb(0, 221, 255)"},
                {offset: 1,color: "rgb(77, 119, 255)"}]),
                }]

set jscolor3 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0,color: "rgb(55, 162, 255)"},
                {offset: 1,color: "rgb(116, 21, 219)"}]),
                }]

set jscolor4 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0,color: "rgb(255, 0, 135)"},
                {offset: 1,color: "rgb(135, 0, 157)"}]),
                }]

set jscolor5 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0,color: "rgb(255, 191, 0)"},
                {offset: 1,color: "rgb(224, 62, 76)"}]),
                }]

set chart [ticklecharts::chart new]

$chart SetOptions -title   {text "Stacked aera gradient chart"} \
                 -legend  {show True} \
                 -tooltip {show True trigger "axis" axisPointer {type "cross" label {backgroundColor "#6a7985"}}} \
                 -grid {left "3%" right "4%" bottom "3%" containLabel "True"}
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] -boundaryGap "False"
$chart Yaxis
$chart Add "lineSeries" -name "chart 1" \
                        -data [list {140 232 101 264 90 340 250}] \
                        -areaStyle [list opacity 0.8 color $jscolor1] \
                        -emphasis {focus "series"} \
                        -smooth True \
                        -stack "Total" \
                        -showSymbol "False" \
                        -lineStyle {width 0}

$chart Add "lineSeries" -name "chart 2" \
                        -data [list {120 282 111 234 220 340 310}] \
                        -areaStyle [list opacity 0.8 color $jscolor2] \
                        -emphasis {focus "series"} \
                        -smooth True \
                        -stack "Total" \
                        -showSymbol "False" \
                        -lineStyle {width 0}
    
$chart Add "lineSeries" -name "chart 3" \
                        -data [list {320 132 201 334 190 130 220}] \
                        -areaStyle [list opacity 0.8 color $jscolor3] \
                        -emphasis {focus "series"} \
                        -smooth True \
                        -stack "Total" \
                        -showSymbol "False" \
                        -lineStyle {width 0}
    
$chart Add "lineSeries" -name "chart 4" \
                        -data [list {220 402 231 134 190 230 120}] \
                        -areaStyle [list opacity 0.8 color $jscolor4] \
                        -emphasis {focus "series"} \
                        -smooth True \
                        -stack "Total" \
                        -showSymbol "False" \
                        -lineStyle {width 0}

$chart Add "lineSeries" -name "chart 5" \
                        -data [list {220 302 181 234 210 290 150}] \
                        -areaStyle [list opacity 0.8 color $jscolor5] \
                        -emphasis {focus "series"} \
                        -smooth True \
                        -stack "Total" \
                        -showSymbol "False" \
                        -lineStyle {width 0}


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename