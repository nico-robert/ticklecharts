lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : replace '-data' by '-dataGraphItem' to keep the same logic for dictionnary data (-data flag is still active)
# v3.0 : Move '-animationDurationUpdate', '-animationEasingUpdate' from constructor to 'SetOptions' method with v3.0.1
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Replaces '-dataGraphItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -animationDurationUpdate 1500 \
                  -animationEasingUpdate "quinticInOut" \
                  -title {text "Basic Graph"} \
                  -tooltip {}

$chart Add "graphSeries" -layout "none" \
                         -symbolSize 50 \
                         -roam "True" \
                         -label {show "True"} \
                         -edgeSymbol     [list {circle arrow}] \
                         -edgeSymbolSize [list {4 10}] \
                         -edgeLabel {fontSize 20} \
                         -dataItem {
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