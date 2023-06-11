lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'gray' string color by 'rgb' gray match
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v4.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart Add "graphic" -elements {
                            {
                                type image bounding "raw" right 110 bottom 110 z 100
                                style {
                                    image "https://echarts.apache.org/zh/images/favicon.png"
                                    width 80
                                    height 80
                                }
                            }
                            {
                                type image bounding "raw" right 300 bottom 110 z 100
                                style {
                                    image "https://www.tcl-lang.org/images/plume.png"
                                    width 80
                                    height 80
                                }
                            }
                            {
                                type text right 220 bottom 120 z 100
                                style {
                                    overflow "break"
                                    fill "rgb(128,128,128)"
                                    text "+"
                                    fontSize 75
                                    }
                            }
                        }
               
$chart Xaxis -data [list {Mon Tue Wed Thu Fri Sat Sun}]
$chart Yaxis
$chart Add "lineSeries" -data [list {150 230 224 218 135 147 260}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
