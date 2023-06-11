lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Init 'data' variable
# v3.0 : Update example with the new 'Add' method for chart series.s

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set data {}
set base [clock scan {03/09/1968} -format {%d/%m/%Y}]
lappend data [expr {rand() * 300}]

for {set i 1} {$i < 20000} {incr i} {
    set now [clock scan {+1 days} -base $base]
    lappend date [clock format [clock scan {+1 months} -base $now] -format {%d/%m/%Y}]
    lappend data [expr round((rand() - 0.5) * 20 + [lindex $data [expr {$i - 1}]])]
    set base $now
}

set js [ticklecharts::jsfunc new {function (pt) {
                                    return [pt[0], '10%'];
                                    }
                                }]
                        
set jscolor [ticklecharts::jsfunc new {new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0,color: "rgb(255, 158, 68)"},
                {offset: 1,color: "rgb(255, 70, 131)"}]),
                }]

set chart [ticklecharts::chart new]

$chart SetOptions -title {text "Large Area Chart" left "center"} \
                  -toolbox {feature {dataZoom {yAxisIndex "none"} restore {} saveAsImage {}}} \
                  -tooltip [list trigger "axis" position $js] \
                  -dataZoom {
                                {type "inside" start 0 end 10}
                                {type "slider" show "True" start 0 end 10}
                            }
               
$chart Xaxis -type "category" -boundaryGap "false" -data [list $date]
$chart Yaxis -type "value"    -boundaryGap [list {0 "100%"}]


$chart Add "lineSeries" -name "Fake Data" -data [list $data] \
                        -symbol "none" \
                        -sampling "lttb" \
                        -itemStyle {color "rgb(255, 70, 131)"} \
                        -areaStyle [list color $jscolor] 


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
