lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set pie [ticklecharts::chart new]

$pie SetOptions -tooltip {show "True" trigger "item"} \
                -legend {top "5%" left "center"}

$pie Add "pieSeries" -name "Access From" -radius [list {"40%" "70%"}] \
                     -avoidLabelOverlap "False" \
                     -padAngle 5 \
                     -itemStyle {borderRadius 10} \
                     -label     {show "False" position "center"} \
                     -emphasis  {label {show "True" fontSize 25 fontWeight "bold"}} \
                     -labelLine {show "False"} \
                     -dataItem {
                         {value 1048 name "Search Engine"}
                         {value 735 name "Direct"}
                         {value 580 name "Email"}
                         {value 484 name "Union Ads"}
                         {value 300 name "Video Ads"}
                     }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$pie Render -outfile [file join $dirname $fbasename.html] -title $fbasename