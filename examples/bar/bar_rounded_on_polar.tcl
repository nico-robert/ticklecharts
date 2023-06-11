lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -polar {} \
                  -legend {}

$chart RadiusAxis -data [list {v w x y z}] -type "category" -z 10
$chart AngleAxis  -max 2 -startAngle 30 -splitLine {show "False"}

$chart Add "barSeries" -data [list {4 3 2 1 0}] \
                       -coordinateSystem "polar" \
                       -name "Without Round Cap" \
                       -itemStyle {borderColor "red" opacity 0.8 borderWidth 1}
                    
$chart Add "barSeries" -data [list {4 3 2 1 0}] \
                       -coordinateSystem "polar" \
                       -name "With Round Cap" \
                       -roundCap "True" \
                       -itemStyle {borderColor "green" opacity 0.8 borderWidth 1}
                    
                    

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename