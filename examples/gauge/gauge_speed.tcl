lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart AddGaugeSeries -progress      {show "True" width 18} \
                      -axisLine      {show "True" lineStyle {width 18}} \
                      -axisTick      {show "False"} \
                      -splitLine     {length 15 lineStyle {width 2 color "#999"}} \
                      -axisLabel     {distance 25 color "#999" fontSize 20} \
                      -anchor        {show "true" showAbove "true" size 25 itemStyle {borderWidth 10}} \
                      -title         {show "false"} \
                      -detail        [list valueAnimation "true" fontSize 80 offsetCenter [list {0 "70%"}]] \
                      -dataGaugeItem {{value 70}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename