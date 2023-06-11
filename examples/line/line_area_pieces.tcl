lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -visualMap {
                            type "piecewise"
                            show "False"
                            dimension 0
                            seriesIndex 0
                            pieces {
                                {gt 1 lt 3 color "rgba(0, 0, 180, 0.4)"}
                                {gt 5 lt 7 color "rgba(0, 0, 180, 0.4)"}
                            }
                            }
                            
                
$chart Xaxis -boundaryGap "False"
$chart Yaxis -boundaryGap [list {0 30%}]

$chart Add "lineSeries" -smooth 0.6 -symbol "none" \
                        -lineStyle {color #5470C6 width 5} \
                        -areaStyle {} \
                        -data [list {2019-10-10 200} \
                                    {2019-10-11 560} \
                                    {2019-10-12 750} \
                                    {2019-10-13 580} \
                                    {2019-10-14 250} \
                                    {2019-10-15 300} \
                                    {2019-10-16 450} \
                                    {2019-10-17 300} \
                                    {2019-10-18 100} \
                                    ] \
                        -markLine [list symbol [list {none none}] label {show false} \
                                        data {
                                           objectItem {xAxis 1}
                                           objectItem {xAxis 3}
                                           objectItem {xAxis 5}
                                           objectItem {xAxis 7}
                                        }
                                        ]
                                    

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename