lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Add ParallelAxis as method instead of a option.
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Update of 'ParallelAxis' method with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without. (v3.2.3)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart ParallelAxis {
    {dim 0 name "Price"}
    {dim 1 name "Net Weight"}
    {dim 2 name "Amount"}
    {dim 3 name "Score" type "category" data {{Excellent Good OK Bad}}}
}

$chart Add "parallelSeries" -lineStyle {width 4 opacity 0.5} \
                            -data [list {12.99 100 82 Good} {9.99 80 77 OK} {20 120 60 Excellent}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename