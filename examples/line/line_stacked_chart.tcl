# v1.0 : Initial example
# v2.0 : Add toolbox utility + rename 'render' to 'Render' (Note : The first letter in capital letter)
# v3.0 : Update example with the new 'Add' method for chart series.

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title   {text "Stacked chart"} \
                 -legend  {show True} \
                 -tooltip {show True trigger "axis"} \
                 -toolbox {feature {saveAsImage {}}}
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] -boundaryGap "False"
$chart Yaxis
$chart Add "lineSeries" -name "Email" \
                        -stack "Total" \
                        -data [list {120 132 101 134 90 230 210}]

$chart Add "lineSeries" -name "Union Ads" \
                        -stack "Total" \
                        -data [list {220 182 191 234 290 330 310}]
    
$chart Add "lineSeries" -name "Video Ads" \
                        -stack "Total" \
                        -data [list {150 232 201 154 190 330 410}]
    
$chart Add "lineSeries" -name "Direct" \
                        -stack "Total" \
                        -data [list {320 332 301 334 390 330 320}]

$chart Add "lineSeries" -name "Search Engine" \
                        -stack "Total" \
                        -data [list {820 932 901 934 1290 1330 1320}]


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename