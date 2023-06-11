# v1.0 : Initial example
# v2.0 : Add toolbox utility + rename 'render' to 'Render' (Note : The first letter in capital letter)
# v3.0 : Replace 'center' by 'middle' for toolbox top position
# v4.0 : Update example with the new 'Add' method for chart series.

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip [list show True trigger "axis" axisPointer {type "shadow"}] \
                  -legend {} \
                  -grid {left "3%" right "4%" bottom "3%" containLabel "True"} \
                  -toolbox [list orient vertical left right top middle \
                            feature [list \
                            dataView {readOnly false} magicType [list type [list {line bar stack}]] \
                            restore {} saveAsImage {}] \
                            ]

               
$chart Xaxis -type "value"
$chart Yaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] -type "category" -boundaryGap "True"
           

$chart Add "barSeries" -name "Direct" \
                       -stack "total" \
                       -label {show "True"} \
                       -data [list {320 302 301 334 390 330 320}] \
                       -emphasis {focus "series"}
               
               
$chart Add "barSeries" -name "Mail Ad" \
                       -stack "total" \
                       -label {show "True"} \
                       -data [list {120 132 101 134 90 230 210}] \
                       -emphasis {focus "series"}
               
$chart Add "barSeries" -name "Affiliate Ad" \
                       -stack "total" \
                       -label {show "True"} \
                       -data [list {220 182 191 234 290 330 310}] \
                       -emphasis {focus "series"}
               
$chart Add "barSeries" -name "Video Ad" \
                       -stack "total" \
                       -label {show "True"} \
                       -data [list {150 212 201 154 190 330 410}] \
                       -emphasis {focus "series"}         

$chart Add "barSeries" -name "Search Engine" \
                       -stack "total" \
                       -label {show "True"} \
                       -data [list {820 832 901 934 1290 1330 1320}] \
                       -emphasis {focus "series"}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename