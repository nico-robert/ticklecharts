lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new -animationDurationUpdate 1500 -animationEasingUpdate "quinticInOut"]

$chart SetOptions -title {text "Basic Graph"} -tooltip {}

$chart AddGraphSeries -layout "none" \
                      -symbolSize 50 \
                      -roam "True" \
                      -label {show "True"} \
                      -edgeSymbol     [list {circle arrow}] \
                      -edgeSymbolSize [list {4 10}] \
                      -edgeLabel {fontSize 20} \
                      -data {
                        {name "Node 1" x 300 y 300}
                        {name "Node 2" x 800 y 300}
                        {name "Node 3" x 550 y 100}
                        {name "Node 4" x 550 y 500}
                      } \
                      -links [list \
                        [list source 0 target 1 symbolSize [list {5 20}] label {show "True" fontSize "nothing" overflow "none"} lineStyle {width 5 curveness 0.2}] \
                        [list source "Node 2" target "Node 1" label {show "True" fontSize "nothing" overflow "none"} lineStyle {curveness 0.2}] \
                        [list source "Node 1" target "Node 3"] \
                        [list source "Node 2" target "Node 3"] \
                        [list source "Node 2" target "Node 4"] \
                        [list source "Node 1" target "Node 4"] \
                      ] \
                      -lineStyle {opacity 0.9 width 2 curveness 0}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename 