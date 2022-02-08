lappend auto_path [file dirname [file dirname [file dirname [file normalize [info script]]]]]


if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip [list show True trigger "axis" axisPointer {type "shadow"}] \
                  -grid {top 80 bottom 30} \
                  -title {text "Bar Chart with Negative Value"}
               
$chart Xaxis -type "value" -position "top" \
             -splitLine {lineStyle {type "dashed"}}
           
$chart Yaxis -axisLine    {show "False"} \
             -axisLabel   {show "False"} \
             -axisTick    {show "False"} \
             -splitLine   {show "False"} \
             -data        [list {"ten" "nine" "eight" "seven" "six" "five" "four" "three" "two" "one"}] \
             -type        "category" \
             -boundaryGap "True"
           

$chart AddBarSeries -name "Cost" -label [list show "True" formatter "<0123>b<0125>"] \
                            -stack "Total" \
                            -databaritem {
                                            {value -0.07 label {position "right"}}
                                            {value -0.09 label {position "right"}}
                                            {value 0.20}
                                            {value 0.44}
                                            {value -0.23 label {position "right"}}
                                            {value 0.08}
                                            {value -0.17 label {position "right"}}
                                            {value 0.47}
                                            {value -0.36 label {position "right"}}
                                            {value 0.18}
                                                        }


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename