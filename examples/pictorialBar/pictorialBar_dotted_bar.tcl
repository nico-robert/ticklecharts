lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

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

set picBar [ticklecharts::chart new -backgroundColor "#0f375f"]


$picBar SetOptions -tooltip {trigger "axis" axisPointer {type "shadow"}} \
                   -legend [list data [list {"line" "bar"}] textStyle {fontSize 12 fontWeight "normal" color "#ccc"}]


$picBar Xaxis -data [list $category] -axisLine {show "True" lineStyle {color "#ccc"}}
$picBar Yaxis -splitLine {show "False"} -axisLine {lineStyle {color "#ccc"}}


$picBar AddLineSeries -name "line" -smooth "True" \
                      -datalineitem $lineData \
                      -showAllSymbol "True" \
                      -symbol "emptyCircle" \
                      -symbolSize 15

$picBar AddBarSeries -name "bar" -barWidth 10 \
                     -itemStyle [list borderRadius 5 color $jscolor1 borderColor "nothing"] \
                     -data [list $barData] -z "-12"

$picBar AddBarSeries -name "line" -barWidth 10 -barGap "-100%" \
                     -itemStyle [list color $jscolor2 borderColor "nothing"] \
                     -databaritem $lineData -z "-12"

$picBar AddPictorialBarSeries -name "dotted" -symbol "rect" -itemStyle {borderColor "nothing" color "#0f375f"} \
                              -symbolRepeat "True" \
                              -symbolSize [list {12 4}] \
                              -symbolMargin 1 \
                              -z "-10" \
                              -data $lineData


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$picBar Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px