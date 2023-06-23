lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-dataradaritem' by '-dataRadarItem' + 
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataRadarItem' by '-dataItem' (both properties are available).
#        Replaces '-indicatoritem' by '-indicatorItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# bar
set bar [ticklecharts::chart new]
               
$bar Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}]
$bar Yaxis
$bar Add "barSeries" -data [list {120 200 150 80 70 110 130}]

# radar
set radar [ticklecharts::chart new]

$radar SetOptions -title {text "Bar / Radar Chart Layout..."} \
                  -legend {left 48%}

$radar RadarCoordinate -radius 190 \
                       -indicatorItem {
                                        {name "Sales" max 6500}
                                        {name "Administration" max 16000}
                                        {name "Information Technology" max 30000}
                                        {name "Customer Support" max 38000}
                                        {name "Development" max 52000}
                                        {name "Marketing" max 25000}
                                    } 

$radar Add "radarSeries" -name "Budget vs spending" \
                         -dataItem [list \
                                [list name "Allocated Budget" value [list {4200 3000 20000 35000 50000 18000}]] \
                                [list name "Actual Spending" value [list {5000 14000 28000 26000 42000 21000}]] \
                        ]

set layout [ticklecharts::Gridlayout new]
$layout Add $bar   -bottom "60%" -width "30%" -left "5%"
$layout Add $radar -center [list {55% 25%}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] \
               -title $fbasename \
               -width 1900px \
               -height 1000px
