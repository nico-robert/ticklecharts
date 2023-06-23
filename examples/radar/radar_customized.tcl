lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : delete 'show' key it's not a key option... in areaStyle flag
#        + rename 'render' to 'Render' (Note : The first letter in capital letter)
# v3.0 : Rename '-dataradaritem' by '-dataRadarItem'
#        Move '-color' from constructor to 'SetOptions' method with v3.0.1
# v4.0 : Set new 'Add' method for chart series + uses substitution for formatter property.
#        Note : map list formatter + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)
# v5.0 : Replaces '-dataRadarItem' by '-dataItem' (both properties are available).
#        Replaces '-indicatoritem' by '-indicatorItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set js [ticklecharts::jsfunc new {function (params) {
                                return params.value;
                                }
                                }]

set js_RadialGradient [ticklecharts::jsfunc new {new echarts.graphic.RadialGradient(0.1, 0.6, 1, [
                                {
                                    color: 'rgba(255, 145, 124, 0.1)',
                                    offset: 0
                                },
                                {
                                    color: 'rgba(255, 145, 124, 0.9)',
                                    offset: 1
                                }
                                ])
                                }]

set chart [ticklecharts::chart new]

$chart SetOptions -color [list {#67F9D8 #FFE434 #56A3F1 #FF917C}] \
                  -title {text "Customized Radar Chart"} \
                  -legend {}

$chart RadarCoordinate -indicatorItem {
                                        {name "Indicator1"}
                                        {name "Indicator2"}
                                        {name "Indicator3"}
                                        {name "Indicator4"}
                                        {name "Indicator5"}
                                        {name "Indicator6"}
                                    } \
                        -center [list {25% 50%}] \
                        -shape "circle" \
                        -splitNumber 4 \
                        -radius 120 \
                        -axisName {color "#428BD4" formatter {"【{value}】"}} \
                        -splitLine {lineStyle {color "rgba(211, 253, 250, 0.8)"}} \
                        -splitArea [list show true areaStyle [list color [list {#77EADF #26C3BE #64AFE9 #428BD4}] \
                                                                   shadowColor "rgba(0, 0, 0, 0.2)" \
                                                                   shadowBlur 10 opacity 1]] \
                        -axisLine {show true lineStyle {color "rgba(211, 253, 250, 0.8)"}}

$chart RadarCoordinate -indicatorItem {
                                        {name "Indicator1" max 150}
                                        {name "Indicator2" max 150}
                                        {name "Indicator3" max 150}
                                        {name "Indicator4" max 120}
                                        {name "Indicator5" max 108}
                                        {name "Indicator6" max 72}
                                    } \
                        -center [list {75% 50%}] \
                        -radius 120 \
                        -axisName [list color "#fff" backgroundColor "#666" borderRadius 3 padding [list {3 5}]]

$chart Add "radarSeries" -emphasis {lineStyle {width 4}} \
                         -dataItem [list \
                                            [list name "Data A" \
                                                  value [list {100 8 0.4 -80 2000}] \
                                            ] \
                                            [list name "Data B" \
                                                  value [list {60 5 0.3 -100 1500}] \
                                                  areaStyle {color "rgba(255, 228, 52, 0.6)"} \
                                            ] \
                                     ]

# delete 'show "true"' in AddRadarSeries(areaStyle) method
$chart Add "radarSeries" -radarIndex 1 \
                         -dataItem [list \
                                            [list name "Data C" \
                                                  value [list {120 118 130 100 99 70}] \
                                                  symbol rect \
                                                  symbolSize 12 \
                                                  lineStyle {type "dashed"} \
                                                  label [list show true formatter $js] \
                                            ] \
                                            [list name "Data D" \
                                                  value [list {100 93 50 90 70 60}] \
                                                  areaStyle [list color $js_RadialGradient] \
                                            ] \
                                     ]




set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename