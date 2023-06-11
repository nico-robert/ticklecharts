proc dataRand {max} {
    return [format %.3f [expr {rand() * $max}]]
}

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : init data1, data2, data3 (problem source all.tcl)
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
#        Move '-animation' from constructor to 'SetOptions' method with v3.0.1
# v4.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set js [ticklecharts::jsfunc new {function (val) {
                                    return val[2] * 40;
                                    },
                                }]

set data1 {} ; set data2 {} ; set data3 {}

for {set i 0} {$i < 500} {incr i} {
    lappend data1 [list [dataRand 15] [dataRand 10] [dataRand 1]]
    lappend data2 [list [dataRand 10] [dataRand 10] [dataRand 1]]
    lappend data3 [list [dataRand 15] [dataRand 10] [dataRand 1]]
}

set chart [ticklecharts::chart new]

$chart SetOptions -animation false \
                  -legend [list data [list {scatter scatter2 scatter3}]] \
                  -tooltip {show "True"} \
                  -dataZoom {
                            {type "slider" show "True" xAxisIndex 0 start 1 end 35}
                            {type "slider" show "True" yAxisIndex 0 start 29 end 26}
                            {type "inside" xAxisIndex 0 start 1 end 35}
                            {type "inside" yAxisIndex 0 start 29 end 36}
                            }

$chart Xaxis -type "value" -min "dataMin" -max "dataMax" -splitLine {show "True"}
$chart Yaxis -type "value" -min "dataMin" -max "dataMax" -splitLine {show "True"}

$chart Add "scatterSeries" -name "scatter"  -itemStyle {opacity 0.8 borderColor nothing} -data $data1 -symbolSize $js
$chart Add "scatterSeries" -name "scatter2" -itemStyle {opacity 0.8 borderColor nothing} -data $data2 -symbolSize $js
$chart Add "scatterSeries" -name "scatter3" -itemStyle {opacity 0.8 borderColor nothing} -data $data3 -symbolSize $js

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
          
