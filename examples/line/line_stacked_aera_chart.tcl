lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'center' by 'middle' for label verticalAlign flag
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v4.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title   {text "Stacked aera chart"} \
                 -legend  {show True} \
                 -tooltip {show True trigger "axis" axisPointer {type "cross" label {backgroundColor "#6a7985"}}} \
                 -grid {left "3%" right "4%" bottom "3%" containLabel "True"}
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] -boundaryGap "False"
$chart Yaxis
$chart Add "lineSeries" -name "Email" \
                        -data [list {120 132 101 134 90 230 210}] \
                        -areaStyle {} \
                        -stack "Total" \
                        -emphasis {focus "series"}

$chart Add "lineSeries" -name "Union Ads" \
                        -data [list {220 182 191 234 290 330 310}] \
                        -areaStyle {} \
                        -stack "Total" \
                        -emphasis {focus "series"}
    
$chart Add "lineSeries" -name "Video Ads" \
                        -data [list {150 232 201 154 190 330 410}] \
                        -areaStyle {} \
                        -stack "Total" \
                        -emphasis {focus "series"}
    
$chart Add "lineSeries" -name "Direct" \
                        -data [list {320 332 301 334 390 330 320}] \
                        -areaStyle {} \
                        -stack "Total" \
                        -emphasis {focus "series"}

$chart Add "lineSeries" -name "Search Engine" \
                        -data [list {820 932 901 934 1290 1330 1320}] \
                        -areaStyle {} \
                        -stack "Total" \
                        -emphasis {focus "series"} \
                        -label {show "True" position "top" verticalAlign "middle" align "center" color "nothing"}


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename