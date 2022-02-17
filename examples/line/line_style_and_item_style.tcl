lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart Xaxis -data [list {Mon Tue Wed Thu Fri Sat Sun}]
$chart Yaxis
$chart AddLineSeries -data [list {120 200 150 80 70 110 130}] \
                     -symbol "triangle" \
                     -symbolSize 20 \
                     -lineStyle {color "#5470C6" width 4 type "dashed"} \
                     -itemStyle {borderWidth 3 borderColor "#EE6666" color "yellow"}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename