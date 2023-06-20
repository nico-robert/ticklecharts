lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datapieitem' by '-dataPieItem' +
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataPieItem' by '-dataItem' (both properties are available).

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

$pie Add "pieSeries" -name "echarts pie" \
                     -radius "55%" -center [list {40% 50%}] \
                     -emphasis {itemStyle {shadowBlur 10 shadowOffsetX 0 shadowColor "rgba(0, 0, 0, 0.5)"}} \
                     -dataItem $data

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$pie Render -outfile [file join $dirname $fbasename.html] -title $fbasename

