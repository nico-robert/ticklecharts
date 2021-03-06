lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}]
$chart Yaxis
$chart AddBarSeries -data [list {120 200 150 80 70 110 130}] \
                    -showBackground "True" \
                    -backgroundStyle {color "rgba(180, 180, 180, 0.2)"}


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename