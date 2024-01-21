lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

set js [ticklecharts::jsfunc new {
    function(params) {
        var myColor = ['#eb2100', '#eb3600', '#d0570e', '#d0a00e', '#34da62', '#00e9db', '#00c0e9', '#0096f3', '#33CCFF', '#33FFCC'];
        var num = myColor.length;
        return myColor[params.dataIndex % num]
        },
}]

$chart SetOptions -backgroundColor "#0e2147" \
                  -grid {
                    left 25%
                    top 12%
                    right 25%
                    bottom 8%
                    containLabel "True"
                  }

$chart Xaxis -show "False" -type value
$chart Yaxis -axisTick {show false} -axisLine {show false} -offset 27 \
             -axisLabel {color "#ffffff" fontSize 16} \
             -data [list {VB.Net Python Ruby Python Nim Java C++ C JavaScript Tcl}] -type category

$chart Yaxis -axisTick {show false} -axisLine {show false} \
             -axisLabel {color "#ffffff" fontSize 0 margin 70} \
             -data [list {10 9 8 7 6 5 4 3 2 1}] -type category -position right 

$chart Yaxis -name "TOP 10" -nameGap 50 \
             -nameTextStyle {color "#ffffff" fontSize 30} \
             -axisLine {lineStyle {color rgba(0,0,0,0.001)}} -type category


$chart Add "barSeries" -yAxisIndex 0 \
                       -data [list {6647 7473 8190 8488 9491 11726 12745 13170 21319 24934}] \
                       -label {show true position "right" color "#ffffff" fontSize 16} \
                       -barWidth 12 \
                       -itemStyle [list color $js] -z 2

$chart Add "barSeries" -yAxisIndex 1 \
                       -data [list {99 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5 99.5}] \
                       -barWidth 20  -barGap "-100%" \
                       -itemStyle {color "#0e2147" borderRadius 5 borderColor null} -z 1

$chart Add "barSeries" -yAxisIndex 2 \
                       -data [list {100 100 100 100 100 100 100 100 100 100}] \
                       -barWidth 24 -barGap "-100%" \
                       -itemStyle [list color $js borderRadius 5 borderColor null] -z 0

$chart Add "scatterSeries" -animation "False" \
                           -data [list {0 0 0 0 0 0 0 0 0 0}] \
                           -yAxisIndex 2 -symbolSize 35 \
                           -itemStyle [list color $js opacity 1 borderColor null] -z 2

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename -width 1500px -height 900px
          
