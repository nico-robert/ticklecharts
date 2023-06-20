lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datapieitem' by '-dataPieItem' +
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataPieItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set pie [ticklecharts::chart new]

$pie SetOptions -title {text "Referer of a Website" subtext "Fake Data" left "center"} \
                -tooltip {show "True" trigger "item"} \
                -legend {orient "vertical" left "left"}


$pie Add "pieSeries" -name "Access From" -radius "50%" \
                     -dataItem {
                         {value 1048 name "Search Engine"}
                         {value 735 name "Direct"}
                         {value 580 name "Email"}
                         {value 484 name "Union Ads"}
                         {value 300 name "Video Ads"}
                     } \
                     -emphasis {itemStyle {shadowBlur 10 shadowOffsetX 0 shadowColor "rgba(0, 0, 0, 0.5)"}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$pie Render -outfile [file join $dirname $fbasename.html] -title $fbasename