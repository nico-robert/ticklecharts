lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set num  {1 2 3 4 5}
set num1 {2 3.6 6 2 10}
set num2 {4 6.6 8 10 15}

set js [ticklecharts::jsfunc new {function (value, index) {
                                return value + ' (C°)';
                                },
                                }]

set line [ticklecharts::chart new]
                  
$line SetOptions -title   {text "layout line + bar..."} \
                 -tooltip {show "True"}          
    
$line Xaxis -data [list $num] -boundaryGap "False"
$line Yaxis
$line Add "lineSeries" -data [list $num]  -areaStyle {} -smooth true
$line Add "lineSeries" -data [list $num1] -smooth true

set bar [ticklecharts::chart new]
$bar Xaxis -data [list {A B C D E}] \
            -axisLabel [dict create show "True" formatter $js]
$bar Yaxis
$bar Add "barSeries" -data [list {50 6 80 120 30}]
$bar Add "barSeries" -data [list {20 30 50 100 25}]


set layout [ticklecharts::Gridlayout new]
$layout Add $bar  -bottom "60%" -width "30%" -left "5%"
$layout Add $line -top    "60%" -width "30%" -left "5%"
$layout Add $bar  -width "55%"  -right "5%"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] \
               -title $fbasename \
               -width 1900px \
               -height 1000px