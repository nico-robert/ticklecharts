lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
#        Move '-animation' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Set new 'Add' method for chart series + use substitution for formatter property 
#        Note : map list substitution + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -animation "False" \
                  -title {text "Tangential Polar Bar Label Position (middle)"} \
                  -polar [list radius [list {30 "80%"}]] \
                  -tooltip {}

$chart RadiusAxis -data [list {a b c d}] -type "category"
$chart AngleAxis  -max 4 -startAngle 75

$chart Add "barSeries" -data [list {2 1.2 2.4 3.6}] \
                       -coordinateSystem "polar" \
                       -label {show "True" position "middle" formatter {"{b}: {c}"}}
                    

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename