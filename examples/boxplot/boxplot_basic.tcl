lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart Xaxis -type "category" -boundaryGap "True" -nameGap 30 -splitArea {show "False"} -splitLine {show "False"}
$chart Yaxis -type "value" -splitArea {show "True"}

$chart Add "boxPlotSeries" -name "boxplot" \
                           -data [list {2 5 10 15 30} {3 5 10 15 20} {4 5 12 15 20} {5 8 12 20 23}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename