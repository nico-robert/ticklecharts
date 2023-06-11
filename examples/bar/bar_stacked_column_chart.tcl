lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : delete -chartWidth key it's not a key option...
#        + rename 'render' to 'Render' (Note : The first letter in capital letter)
# v3.0 : Update example with the new 'Add' method for chart series.


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip [list show "True" trigger "axis" axisPointer {type "shadow"}] \
                -legend {} \
                -grid {left "3%" right "4%" bottom "3%" containLabel "True"}
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}]
$chart Yaxis
           

$chart Add "barSeries" -name "Direct" \
                       -data [list {320 332 301 334 390 330 320}] \
                       -emphasis {focus "series"}

$chart Add "barSeries" -name "Email" \
                       -stack "Ad" \
                       -data [list {120 132 101 134 90 230 210}] \
                       -emphasis {focus "series"}

$chart Add "barSeries" -name "Union Ads" \
                       -stack "Ad" \
                       -data [list {220 182 191 234 290 330 310}] \
                       -emphasis {focus "series"}

$chart Add "barSeries" -name "Video Ads" \
                       -stack "Ad" \
                       -data [list {150 232 201 154 190 330 410}] \
                       -emphasis {focus "series"}         

$chart Add "barSeries" -name "Search Engine" \
                       -data [list {862 1018 964 1026 1679 1600 1570}] \
                       -emphasis {focus "series"} \
                       -markLine {lineStyle {type "dashed"} data {lineItem {{type "min"} {type "max"}}}}

# delete '-chartWidth 5' in AddBarSeries method               
$chart Add "barSeries" -name "Baidu" \
                       -stack "Search Engine" \
                       -data [list {620 732 701 734 1090 1130 1120}] \
                       -emphasis {focus "series"}

$chart Add "barSeries" -name "Google" \
                       -stack "Search Engine" \
                       -data [list {120 132 101 134 290 230 220}] \
                       -emphasis {focus "series"}

$chart Add "barSeries" -name "Bing" \
                       -stack "Search Engine" \
                       -data [list {60 72 71 74 190 130 110}] \
                       -emphasis {focus "series"}

$chart Add "barSeries" -name "Others" \
                       -stack "Search Engine" \
                       -data [list {62 82 91 84 109 110 120}] \
                       -emphasis {focus "series"}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename