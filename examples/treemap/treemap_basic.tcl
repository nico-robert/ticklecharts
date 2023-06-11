lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}


set chart [ticklecharts::chart new]

$chart Add "treeMapSeries" -data {
                                {name nodeA value 10 children {{name nodeAa value 4} {name nodeAb value 6}}}
                                {name nodeB value 20 children {{name nodeBa value 20 children {{name nodeBa1 value 20}}}}}
                           }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename