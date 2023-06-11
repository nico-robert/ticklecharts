lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : delete -chartWidth key it's not a key option...
#        + rename 'render' to 'Render' (Note : The first letter in capital letter)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {show True trigger "axis" axisPointer {type "shadow"}} \
                -grid {left "3%" right "4%" bottom "3%" containLabel "True"}
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] -axisTick {show "True" alignWithLabel "True"}
$chart Yaxis

# delete '-chartWidth "60%"' in AddBarSeries method
$chart Add "barSeries" -name "Direct" \
                       -data [list {10 52 200 334 390 330 220}]


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename