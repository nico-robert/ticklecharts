lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart SetOptions -parallelAxis [list {dim 0 name "Price"} {dim 1 name "Net Weight"} {dim 2 name "Amount"} \
                                      [list dim 3 name "Score" type "category" data [list [list Excellent Good OK Bad]]] \
                                ]

$chart AddParallelSeries -lineStyle {width 4 opacity 0.5} -data [list {12.99 100 82 Good} {9.99 80 77 OK} {20 120 60 Excellent}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename