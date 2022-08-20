lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {formatter "<0123>a<0125> <br/><0123>b<0125> : <0123>c<0125>%"}
               
$chart AddGaugeSeries -detail {formatter "<0123>value<0125>"} -name "Pressure" -dataGaugeItem {{value 50 name "SCORE"}}


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename