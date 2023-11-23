lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-databaritem' by '-dataBarItem' & `-datalineitem' by '-dataLineItem'
#        Move '-backgroundColor' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataBarItem' by '-dataItem' (both properties are available).
#        Replaces '-dataLineItem' by '-dataItem' (both properties are available).
# v5.0 : Use '-dataItem' property for pictorialBarSeries instead of '-data' (both are accepted).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set base [clock seconds]

for {set i 1} {$i < 20} {incr i} {
    lappend category [clock format $base -format {%d-%m-%Y}]
    set now [clock scan {+1 days} -base $base]
    set b [expr {rand() * 200}]
    lappend barData $b
    lappend lineData [list value [expr {(rand() * 200) + $b}]] ; # add data item instead data only
    set base $now
}

set jscolor1 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0,color: "#14c8d4"},
                {offset: 1,color: "#43eec6"}]),
                }]

set jscolor2 [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0,color: "rgba(20,200,212,0.5)"},
                {offset: 0.2,color: "rgba(20,200,212,0.2)"},
                {offset: 1,color: "rgba(20,200,212,0)"}]),
                }]

set picBar [ticklecharts::chart new]


$picBar SetOptions -backgroundColor "#0f375f" \
                   -tooltip {trigger "axis" axisPointer {type "shadow"}} \
                   -legend [list data [list {"line" "bar"}] textStyle {fontSize 12 fontWeight "normal" color "#ccc"}]


$picBar Xaxis -data [list $category] -axisLine {show "True" lineStyle {color "#ccc"}}
$picBar Yaxis -splitLine {show "False"} -axisLine {lineStyle {color "#ccc"}}


$picBar Add "lineSeries" -name "line" -smooth "True" \
                         -dataItem $lineData \
                         -showAllSymbol "True" \
                         -symbol "emptyCircle" \
                         -symbolSize 15

$picBar Add "barSeries" -name "bar" -barWidth 10 \
                        -itemStyle [list borderRadius 5 color $jscolor1 borderColor "nothing"] \
                        -data [list $barData] -z "-12"

$picBar Add "barSeries" -name "line" -barWidth 10 -barGap "-100%" \
                        -itemStyle [list color $jscolor2 borderColor "nothing"] \
                        -dataItem $lineData -z "-12"

$picBar Add "pictorialBarSeries" -name "dotted" -symbol "rect" -itemStyle {borderColor "nothing" color "#0f375f"} \
                                 -symbolRepeat "True" \
                                 -symbolSize [list {12 4}] \
                                 -symbolMargin 1 \
                                 -z "-10" \
                                 -dataItem $lineData


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$picBar Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px