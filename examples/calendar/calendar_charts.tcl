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
    {"2022-02-27" 985}
}
set idx 0
foreach val $graphData {
    lappend links [list source $idx target [expr {$idx + 1}]]
    incr idx
}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {position "top"} \
                  -calendar [list \
                            {
                                orient "vertical" cellSize 40
                                yearLabel {margin 40}
                                dayLabel {firstDay 1 nameMap "CN"}
                                monthLabel {nameMap "CN" margin 20}
                                range "2022-02"
                            } \
                            {
                                orient "vertical" cellSize 40 left 460
                                yearLabel {margin 40}
                                monthLabel {margin 20}
                                range "2022-01"
                            } \
                            {
                                orient "vertical" cellSize 40 top 350
                                yearLabel {margin 40}
                                monthLabel {margin 20}
                                range "2022-03"
                            } \
                            [list \
                                orient "vertical" cellSize 40 left 460 top 350 \
                                yearLabel {margin 40} \
                                dayLabel [list firstDay 1 nameMap [list {Sun Mon Tue Wed Thu Fri Sat}]] \
                                monthLabel {margin 20 nameMap "CN"} \
                                range "2022-04" \
                            ] \
                  ] \
                  -visualMap [list \
                                [list \
                                    type "continuous" \
                                    seriesIndex [list {2 3 4}] \
                                    calculable true \
                                    orient "horizontal" \
                                    min 0 max 1000 \
                                    left "55%" bottom 20 \
                                ] \
                                [list \
                                    type "continuous" \
                                    seriesIndex 1 \
                                    orient "horizontal" \
                                    min 0 max 1000 \
                                    left "10%" bottom 20 \
                                    inRange [list color "rgb(128,128,128)" opacity [list {0 0.3}]] \
                                    controller [list inRange [list opacity [list {0.3 0.6}]] outOfRange {color "#ccc"}] \
                                ] \
                            ]

$chart Add "graphSeries" -edgeSymbol [list {none arrow}] \
                         -coordinateSystem "calendar" \
                         -links $links \
                         -data $graphData \
                         -symbolSize 10 \
                         -calendarIndex 0

$chart Add "heatmapSeries" -coordinateSystem "calendar" \
                           -data [list {*}[getVirtualData 2022]]

# js func
set js1 [ticklecharts::jsfunc new {
        function (val) {
            return val[1] / 40;
        }
}]

$chart Add "scatterSeries" -type "effectScatter" \
                           -coordinateSystem "calendar" \
                           -calendarIndex 1 \
                           -symbolSize $js1 \
                           -data [list {*}[getVirtualData 2022]]

# js func
set js2 [ticklecharts::jsfunc new {
        function (val) {
            return val[1] / 60;
        }
}]

$chart Add "scatterSeries" -type "scatter" \
                           -coordinateSystem "calendar" \
                           -calendarIndex 2 \
                           -symbolSize $js2 \
                           -data [list {*}[getVirtualData 2022]]

$chart Add "heatmapSeries" -coordinateSystem "calendar" \
                           -calendarIndex 3 \
                           -data [list {*}[getVirtualData 2022]]


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px