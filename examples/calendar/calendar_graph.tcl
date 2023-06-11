proc getVirtualData {year} {
    set date [clock scan "$year-01-01" -format {%Y-%m-%d}] 
    set end  [clock scan {+1 years} -base $date] 

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

set graphData {
    {"2022-02-01" 260}
    {"2022-02-04" 200}
    {"2022-02-09" 279}
    {"2022-02-13" 847}
    {"2022-02-18" 241}
    {"2022-02-23" 411}
    {"2022-03-14" 985}
}
set idx 0
foreach val $graphData {
    lappend links [list source $idx target [expr {$idx + 1}]]
    incr idx
}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {} \
                  -calendar [list \
                                top "middle" left "center" orient "vertical" cellSize 40 \
                                yearLabel {margin 50 fontSize 30} \
                                dayLabel {firstDay 1 nameMap "CN"} \
                                monthLabel {nameMap "CN" margin 15 fontSize 20 color "#999"} \
                                range [list {"2022-02" "2022-03-31"}] \
                            ] \
                  -visualMap [list \
                                type "piecewise" \
                                seriesIndex 1 \
                                orient "horizontal" \
                                min 0 max 1000 \
                                left "center" bottom 20 \
                                inRange [list color [list {#5291FF #C7DBFF}]] \
                            ]

$chart Add "graphSeries" -edgeSymbol [list {none arrow}] \
                         -coordinateSystem "calendar" \
                         -links $links \
                         -data $graphData \
                         -z 20 \
                         -symbolSize 15 \
                         -calendarIndex 0 \
                         -itemStyle {
                           color "rgb(255,255,0)"
                           shadowBlur 9
                           shadowOffsetX 1.5
                           shadowOffsetY 3
                           shadowColor "#555"
                         } \
                         -lineStyle {
                           color "#D10E00"
                           width 1
                           opacity 1
                         }

$chart Add "heatmapSeries" -coordinateSystem "calendar" -data [list {*}[getVirtualData 2022]]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px