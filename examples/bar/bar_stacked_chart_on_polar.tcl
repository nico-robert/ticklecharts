lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
#        Move '-animation' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -animation "False" \
                  -polar {} \
                  -legend {}

$chart RadiusAxis -data [list {"Mon" "Tue" "Wed" "Thu"}] -type "category" -z 10
$chart AngleAxis

$chart Add "barSeries" -data [list {1 2 3 4}] \
                       -coordinateSystem "polar" \
                       -name "A" \
                       -stack "a" \
                       -emphasis {focus "series"}
                    
$chart Add "barSeries" -data [list {2 4 6 8}] \
                       -coordinateSystem "polar" \
                       -name "B" \
                       -stack "a" \
                       -emphasis {focus "series"}
                    
$chart Add "barSeries" -data [list {1 2 3 4}] \
                       -coordinateSystem "polar" \
                       -name "C" \
                       -stack "a" \
                       -emphasis {focus "series"}
                    

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename