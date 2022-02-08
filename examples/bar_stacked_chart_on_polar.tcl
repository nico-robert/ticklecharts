lappend auto_path [file dirname [file dirname [file dirname [file normalize [info script]]]]]


if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new -animation "false"]

$chart SetOptions -polar {} \
                  -legend {}

$chart RadiusAxis -data [list {"Mon" "Tue" "Wed" "Thu"}] -type "category" -z 10
$chart AngleAxis

$chart AddBarSeries -data [list {1 2 3 4}] \
                    -coordinateSystem "polar" \
                    -name "A" \
                    -stack "a" \
                    -emphasis {focus "series"}
                    
$chart AddBarSeries -data [list {2 4 6 8}] \
                    -coordinateSystem "polar" \
                    -name "B" \
                    -stack "a" \
                    -emphasis {focus "series"}
                    
$chart AddBarSeries -data [list {1 2 3 4}] \
                    -coordinateSystem "polar" \
                    -name "C" \
                    -stack "a" \
                    -emphasis {focus "series"}
                    

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename