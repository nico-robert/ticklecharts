lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {trigger item triggerOn "mousemove"}
               
$chart Add "sankeySeries" -bottom "10%" -emphasis {focus "adjacency"} \
                          -data {{name a} {name b} {name a1} {name b1} {name c} {name e}} \
                          -links {
                              {source a target a1 value 5}
                              {source e target b value 3}
                              {source a target b1 value 3}
                              {source b1 target a1 value 1}
                              {source b1 target c value 2}
                              {source b target c value 1}
                              } \
                          -orient vertical -label {position top} \
                          -lineStyle {color "source" curveness 0.5}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
