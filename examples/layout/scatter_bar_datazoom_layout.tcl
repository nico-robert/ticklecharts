proc dataRand {max} {
    return [format %.3f [expr {rand() * $max}]]
}

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : init data1 (problem source all.tcl)
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
#        Move '-animation' from constructor to 'SetOptions' method with v3.0.1
#        Delete bar formatter for '-axisLabel'
# v4.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set js [ticklecharts::jsfunc new {function (val) {
                                    return val[2] * 40;
                                    },
                                }]

set data1 {}

for {set i 0} {$i < 500} {incr i} {
    lappend data1 [list [dataRand 15] [dataRand 10] [dataRand 1]]
}

# scatter
set scatter [ticklecharts::chart new]

$scatter SetOptions -animation false \
                    -legend [list data [list {scatter scatter2 scatter3}]] \
                    -tooltip {show "True"} \
                    -dataZoom [list \
                            [list type "slider" show "True" xAxisIndex [list {0 0}] start 1 end 35 bottom "53%" left "2%" right "2%"] \
                            [list type "slider" show "True" yAxisIndex [list {0 0}] start 29 end 26 left "2%"] \
                            [list type "inside" xAxisIndex [list {0 0}] start 1 end 35] \
                            [list type "inside" yAxisIndex [list {0 0}] start 29 end 36] \
                            ]

$scatter Xaxis -type "value" -min "dataMin" -max "dataMax" -splitLine {show "True"}
$scatter Yaxis -type "value" -min "dataMin" -max "dataMax" -splitLine {show "True"}

$scatter Add "scatterSeries" -name "scatter" -itemStyle {opacity 0.8 borderColor nothing} -data $data1 -symbolSize $js

# bar
set bar [ticklecharts::chart new]

$bar SetOptions -dataZoom [list \
                            [list type "slider" show "True" xAxisIndex [list {1 1}] left "2%" right "2%"] \
                            [list type "inside" xAxisIndex [list {1 1}]] \
                            ]

$bar Xaxis -type "category" -data [list {A B C D E}] \
           -axisLabel {show "True"}
$bar Yaxis -type "value"
$bar Add "barSeries" -data [list {50 6 80 120 30}]


set layout [ticklecharts::Gridlayout new]
$layout Add $scatter -bottom "60%" -width "85%" -left "10%" -right "15%"
$layout Add $bar     -top    "60%" -width "100%" -left "5%"


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 1000px -width 1000px
          
