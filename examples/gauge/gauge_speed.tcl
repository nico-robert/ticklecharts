lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataGaugeItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart Add "gaugeSeries" -progress  {show "True" width 18} \
                         -axisLine  {show "True" lineStyle {width 18}} \
                         -axisTick  {show "False"} \
                         -splitLine {length 15 lineStyle {width 2 color "#999"}} \
                         -axisLabel {distance 25 color "#999" fontSize 20} \
                         -anchor    {show "True" showAbove "True" size 25 itemStyle {borderWidth 10}} \
                         -title     {show "False"} \
                         -detail    [list valueAnimation "True" fontSize 80 offsetCenter [list {0 "70%"}]] \
                         -dataItem  {{value 70}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename