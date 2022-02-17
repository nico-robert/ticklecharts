lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new -animation "false"]

$chart SetOptions -title {text "Radial Polar Bar Label Position (middle)"} \
                  -polar [list radius [list {30 "80%"}]] \
                  -tooltip {}

$chart RadiusAxis -max 4
$chart AngleAxis  -type "category" \
                  -data [list {a b c d}] \
                  -startAngle 75

$chart AddBarSeries -data [list {2 1.2 2.4 3.6}] \
                    -coordinateSystem "polar" \
                    -label {show "True" position "middle" formatter "<0123>b<0125>: <0123>c<0125>"}
                    

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename