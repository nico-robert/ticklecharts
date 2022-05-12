lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart Xaxis -data [list {"2017-10-24" "2017-10-25" "2017-10-26" "2017-10-27"}]
$chart Yaxis
$chart AddCandlestickSeries -data [list {20 34 10 38} {40 35 30 50} {31 38 33 44} {38 15 5 42}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename