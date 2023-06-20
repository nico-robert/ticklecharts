lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : replace '-data' by '-dataGraphItem' to keep the same logic for dictionnary data (-data flag is still active)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataGraphItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set axisData {Mon Tue Wed {Very Loooong Thu} Fri Sat Sun}
set i 0
set data  {}
set links {}
foreach val $axisData {
    lappend data [list value [expr {round(rand() * 1000 * ($i + 1))}]]
    lappend links [list source $i target [expr {$i + 1}]]
    incr i
}

set chart [ticklecharts::chart new]

$chart SetOptions -title {text "Graph on Cartesian"} -tooltip {}
$chart Xaxis -type "category" -boundaryGap "False" -data [list $axisData]
$chart Yaxis -type "value"

$chart Add "graphSeries" -layout "none" \
                         -coordinateSystem "cartesian2d" \
                         -symbolSize "40" \
                         -label {show "True"} \
                         -edgeSymbol     [list {circle arrow}] \
                         -edgeSymbolSize [list {4 10}] \
                         -dataItem $data \
                         -links $links \
                         -lineStyle {color "#2f4554"}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 900px