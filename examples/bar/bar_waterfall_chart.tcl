lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

set js [ticklecharts::jsfunc new {function (params) {
                 var tar = params[1];
                 return tar.name + '<br/>' + tar.seriesName + ' : ' + tar.value;},
                }]

$chart SetOptions -tooltip [list show True trigger "axis" axisPointer {type "shadow"} formatter $js] \
                -grid {left "3%" right "4%" bottom "3%" containLabel "True"} \
                -title {text "Waterfall Chart" subtext "Living Expenses in Shenzhen"}
               
$chart Xaxis -data [list {"Total" "Rent" "Utilities" "Transportation" "Meals" "Other"}] \
           -splitLine {show false}
$chart Yaxis
$chart Add "barSeries" -name "Placeholder" \
                       -itemStyle {borderColor "transparent" color "transparent"} \
                       -data [list {0 1700 1400 1200 300 0}] \
                       -stack "Total" \
                       -emphasis {itemStyle {borderColor "transparent" color "transparent"}}

$chart Add "barSeries" -name "Life Cost" \
                       -data [list {2900 1200 300 200 900 300}] \
                       -stack "Total" \
                       -label {show "True" position "inside"}
               

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename