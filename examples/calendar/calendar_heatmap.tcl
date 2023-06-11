proc getVirtualData {year} {
    set date [clock scan "$year-01-01" -format {%Y-%m-%d}] 
    set end  [clock scan "$year-12-31" -format {%Y-%m-%d}] 

    set dayTime [expr {3600 * 24}]

    set data {}

    for {set time $date} {$time <= $end} {incr time $dayTime} {
        lappend data [list [clock format $time -format %Y-%m-%d] [expr {floor(rand() * 10000)}]]
    }

    return $data
}

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title {top 30 left "center" text "Daily Step Count"} \
                  -tooltip {} \
                  -visualMap {type "piecewise" min 0 max 10000 left "center" top 65 orient "horizontal"} \
                  -calendar [list \
                                range 2022 left 30 top 120 right 30 \
                                itemStyle {borderWidth 0.5} yearLabel {show false} cellSize [list {"auto" 13}] \
                            ]

$chart Add "heatmapSeries" -coordinateSystem "calendar" -data [list {*}[getVirtualData 2022]]


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px