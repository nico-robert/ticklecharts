lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Move '-animation' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set positions {
    start
    middle
    end
    insideStart
    insideStartTop
    insideStartBottom
    insideMiddle
    insideMiddleTop
    insideMiddleBottom
    insideEnd
    insideEndTop
    insideEndBottom
}

set markLine {}
set i 0

foreach pos $positions {
    lappend markLine "objectItem" [list name $pos yAxis [expr {1.8 - 0.2 * floor($i / 3.)}] label [list formatter {"{b}"} position $pos]]

    if {$pos ne "middle"} {
        set name [expr {$pos eq "insideMiddle" ? "insideMiddle / middle" : $pos}]

        lappend markLine "lineItem" [list \
                                        [list name "start: $pos" coord [list {0 0.3}] label [list formatter $name position $pos]] \
                                        [list name "end: $pos" coord [list {3 1}]] \
                                 ] \
    }
    incr i
}

set chart [ticklecharts::chart new]

$chart SetOptions -animation "False" \
                  -grid {top 30 left 60 right 60 bottom 40}
               
$chart Xaxis -data [list {A B C D E}] -boundaryGap "True" -splitArea {show "True"}
$chart Yaxis -max 2
$chart Add "lineSeries" -stack "all" \
                        -name "line" \
                        -symbolSize 6 \
                        -data [list {0.3 1.4 1.2 1 0.6}] \
                        -markLine [list data $markLine label [list distance [list {20 8}]]]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -width 1200px \
              -height 900px
