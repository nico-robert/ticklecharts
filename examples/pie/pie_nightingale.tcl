lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Typo 'aera' should be 'area'...

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set js [ticklecharts::jsfunc new {"{a} <br/>{b} : {c} ({d}%)"}]

set pie [ticklecharts::chart new]

$pie SetOptions -tooltip [list show "True" trigger "item" formatter $js] \
                -title {text "Nightingale Chart" subtext "Fake Data" left "center"} \
                -legend {top "bottom" left "center"}


$pie AddPieSeries -name "Radius Mode" -radius [list {20 140}] -center [list {25% 50%}] \
                  -roseType "radius" \
                  -itemStyle {borderRadius 5} \
                  -label     {show "False"} \
                  -emphasis  {label {show "True"}} \
                  -datapieitem {
                      {value 40 name "rose 1"}
                      {value 33 name "rose 2"}
                      {value 28 name "rose 3"}
                      {value 22 name "rose 4"}
                      {value 20 name "rose 5"}
                      {value 15 name "rose 6"}
                      {value 12 name "rose 7"}
                      {value 10 name "rose 8"}
                      }

$pie AddPieSeries -name "Area Mode" -radius [list {20 140}] -center [list {75% 50%}] \
                  -roseType "area" \
                  -itemStyle {borderRadius 5} \
                  -datapieitem {
                      {value 30 name "rose 1"}
                      {value 28 name "rose 2"}
                      {value 26 name "rose 3"}
                      {value 24 name "rose 4"}
                      {value 22 name "rose 5"}
                      {value 20 name "rose 6"}
                      {value 18 name "rose 7"}
                      {value 16 name "rose 8"}
                      }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$pie render -outfile [file join $dirname $fbasename.html] -title $fbasename