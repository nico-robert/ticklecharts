lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : delete AddSankeySeries(-layout) it's not a key option.
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart Add "sankeySeries" -emphasis {focus "adjacency"} \
                          -data {{name a} {name b} {name a1} {name a2} {name b1} {name c}} \
                          -links {
                           {source a target a1 value 5}
                           {source a target a2 value 3}
                           {source b target b1 value 8}
                           {source a target b1 value 3}
                           {source b1 target a1 value 1}
                           {source b1 target c value 2}
                           }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
