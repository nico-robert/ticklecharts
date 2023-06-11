lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title  {text "Rainfall vs Evaporation" subtext "Fake Data"} \
                 -legend  {} \
                 -tooltip {show True trigger "axis"}
               
$chart Xaxis -data [list {"Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"}] 
$chart Yaxis

$chart Add "barSeries" -name "Rainfall" \
                       -data [list {2.0 4.9 7.0 23.2 25.6 76.7 135.6 162.2 32.6 20.0 6.4 3.3}] \
                       -markPoint {data {{type max name "Max"} {type min name "Min"}}} \
                       -markLine  {data {objectItem {type average name "Avg"}}}
                
$chart Add "barSeries" -name "Evaporation" \
                       -data [list {2.6 5.9 9.0 26.4 28.7 70.7 175.6 182.2 48.7 18.8 6.0 2.3}] \
                       -markPoint {data {
                                   {name "Max" value 182.2 xAxis 7 yAxis 183}
                                   {name "Min" value 2.3 xAxis 11 yAxis 3}
                               }
                           } \
                       -markLine  {data {objectItem {type average name "Avg"}}}  

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename