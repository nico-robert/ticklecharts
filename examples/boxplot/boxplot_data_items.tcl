lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataBoxPlotitem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart Xaxis -type "value" -splitArea {show "True"} -splitLine {show "False"}
$chart Yaxis -type "category" -boundaryGap "True" -nameGap 30 -splitArea {show "False"}

$chart Add "boxPlotSeries" -name "boxplot" \
                           -dataItem [list \
                                        [list value [list {2 5 10 15 29}] itemStyle {color "red"}] \
                                        [list value [list {1 5 10 15 20}] itemStyle {color "green"}] \
                                        [list value [list {8 9 10 15 26}] itemStyle {color "blue"}] \
                                    ]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename