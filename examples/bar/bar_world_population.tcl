lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip [list show True trigger "axis" axisPointer {type "shadow"}] \
                -grid {left "3%" right "4%" bottom "3%" containLabel "True"} \
                -title {text "World Population"}
               
$chart Xaxis -type "value" \
           -boundaryGap [list {0 0.01}]
           
$chart Yaxis -data [list {"Brazil" "Indonesia" "USA" "India" "China" "World"}] \
           -type "category" \
           -boundaryGap "True"


$chart Add "barSeries" -name "2011" -data [list {18203 23489 29034 104970 131744 630230}] 
$chart Add "barSeries" -name "2012" -data [list {19325 23438 31000 121594 134141 681807}] 


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename