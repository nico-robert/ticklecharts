# v1.0 : Initial example
# v2.0 : Add toolbox utility.
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v4.0 : Set new 'Add' method for chart series + uses substitution for formatter property.
#        Note : map list formatter + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title   {text "Temperature Change"} \
                 -legend  {show True} \
                 -tooltip {show True trigger "axis"} \
                 -toolbox [list feature [list \
                                        dataZoom {yAxisIndex "none"} \
                                        dataView {readOnly "False"} \
                                        magicType [list type [list {line bar}]] \
                                        restore {} \
                                        saveAsImage {} \
                                    ] \
                 ]
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] \
            -boundaryGap "False"
            
$chart Yaxis -axisLabel {formatter {"{value} °C"}}

                
$chart Add "lineSeries" -name "Highest" \
                -data [list {10 11 13 11 12 12 9}] \
                -markPoint {data {{type max name "Max"} {type min name "Min"}}} \
                -markLine  {data {objectItem {type average name "Avg"}}}
                
$chart Add "lineSeries" -name "Lowest" \
                -data [list {1 -2 2 5 3 2 0}] \
                -markPoint {data {{name "other" value -2 xAxis 1 yAxis 0}}} \
                -markLine {data {
                                objectItem {
                                    type average name "Avg"
                                }
                                lineItem {
                                    {symbol none x "90%" yAxis "max"} 
                                    {symbol circle label {position "start" formatter "Max"} type "max" name "other2"}
                                }
                            }
                        }  

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename