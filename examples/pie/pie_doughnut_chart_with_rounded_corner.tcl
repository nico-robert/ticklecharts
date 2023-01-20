lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datapieitem' by '-dataPieItem' +
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set pie [ticklecharts::chart new]

$pie SetOptions -tooltip {show "True" trigger "item"} \
                -legend {top "5%" left "center"}


$pie AddPieSeries -name "Access From" -radius [list {"40%" "70%"}] \
                  -avoidLabelOverlap "False" \
                  -itemStyle {borderRadius 10 borderColor "#fff" borderWidth 2} \
                  -label     {show "False" position "center"} \
                  -emphasis  {label {show "True" fontSize 25 fontWeight "bold"}} \
                  -labelLine {show "False"} \
                  -dataPieItem {
                      {value 1048 name "Search Engine"}
                      {value 735 name "Direct"}
                      {value 580 name "Email"}
                      {value 484 name "Union Ads"}
                      {value 300 name "Video Ads"}
                      }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$pie Render -outfile [file join $dirname $fbasename.html] -title $fbasename