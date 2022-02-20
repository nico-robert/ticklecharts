lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title {text "Basic Radar Chart"} \
                  -legend {}

$chart RadarCoordinate -indicatoritem {
                                        {name "Sales" max 6500}
                                        {name "Administration" max 16000}
                                        {name "Information Technology" max 30000}
                                        {name "Customer Support" max 38000}
                                        {name "Development" max 52000}
                                        {name "Marketing" max 25000}
                                    } 

$chart AddRadarSeries -name "Budget vs spending" \
                      -dataradaritem [list \
                                            [list name "Allocated Budget" value [list {4200 3000 20000 35000 50000 18000}]] \
                                            [list name "Actual Spending" value [list {5000 14000 28000 26000 42000 21000}]] \
                                     ]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename
