lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -polar {} \
                  -legend {}

$chart RadiusAxis -data [list {v w x y z}] -type "category" -z 10
$chart AngleAxis  -max 2 -startAngle 30 -splitLine {show "false"}

$chart AddBarSeries -data [list {4 3 2 1 0}] \
                    -coordinateSystem "polar" \
                    -name "Without Round Cap" \
                    -itemStyle {borderColor "red" opacity 0.8 borderWidth 1}
                    
$chart AddBarSeries -data [list {4 3 2 1 0}] \
                    -coordinateSystem "polar" \
                    -name "With Round Cap" \
                    -roundCap "true" \
                    -itemStyle {borderColor "green" opacity 0.8 borderWidth 1}
                    
                    

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename