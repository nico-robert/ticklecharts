proc getVirtualData {year} {
    set date [clock scan "$year-01-01" -format {%Y-%m-%d}] 
    set end  [clock scan "$year-12-31" -format {%Y-%m-%d}] 

    set dayTime [expr {3600 * 24}]

    set data {}

    for {set time $date} {$time <= $end} {incr time $dayTime} {
        lappend data [list [clock format $time -format %Y-%m-%d] [expr {floor(rand() * 1000)}]]
    }

    return $data
}

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {position "top"} \
                  -visualMap {type "continuous" calculable true min 0 max 1000 left 670 top "middle"} \
                  -calendar [list \
                                {orient "vertical" range 2020} \
                                {orient "vertical" range 2021 left 300} \
                                [list orient "vertical" range 2022 left 520 bottom 10 dayLabel {margin 5} cellSize [list {20 "auto"}]] \
                            ]

$chart Add "heatmapSeries" -coordinateSystem "calendar" -calendarIndex 0 -data [list {*}[getVirtualData 2020]]
$chart Add "heatmapSeries" -coordinateSystem "calendar" -calendarIndex 1 -data [list {*}[getVirtualData 2021]]
$chart Add "heatmapSeries" -coordinateSystem "calendar" -calendarIndex 2 -data [list {*}[getVirtualData 2022]]


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 900px -height 1200px