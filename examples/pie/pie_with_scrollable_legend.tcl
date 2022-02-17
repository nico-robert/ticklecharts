lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

proc mathRand {min max} {
    set range [expr {$max - $min + 1}]
    return [expr {$min + int(rand() * $range)}]
}

set js [ticklecharts::jsfunc new {"{a} <br/>{b} : {c} ({d}%)"}]

set pie [ticklecharts::chart new]

set data {}

for {set i 0} {$i < 40} {incr i} {
    set value [mathRand 10 100]
    lappend data [list value $value name "Tcl $value"]
}

$pie SetOptions -title {text "Pie scrollable legend" subtext "Fake Data" left "center"} \
                -legend {type "scroll" orient "vertical" right 10 top 20 bottom 20 left "null"} \
                -tooltip [list trigger "item" formatter $js]

$pie AddPieSeries -name "echarts pie" \
                  -radius "55%" -center [list {40% 50%}] \
                  -emphasis {itemStyle {shadowBlur 10 shadowOffsetX 0 shadowColor "rgba(0, 0, 0, 0.5)"}} \
                  -datapieitem $data

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$pie render -outfile [file join $dirname $fbasename.html] -title $fbasename

