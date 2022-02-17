lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set pie [ticklecharts::chart new]

$pie SetOptions -title {text "Referer of a Website" subtext "Fake Data" left "center"} \
                -tooltip {show "True" trigger "item"} \
                -legend {orient "vertical" left "left"}


$pie AddPieSeries -name "Access From" -radius "50%" \
                  -datapieitem {
                      {value 1048 name "Search Engine"}
                      {value 735 name "Direct"}
                      {value 580 name "Email"}
                      {value 484 name "Union Ads"}
                      {value 300 name "Video Ads"}
                      } \
                 -emphasis {itemStyle {shadowBlur 10 shadowOffsetX 0 shadowColor "rgba(0, 0, 0, 0.5)"}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$pie render -outfile [file join $dirname $fbasename.html] -title $fbasename