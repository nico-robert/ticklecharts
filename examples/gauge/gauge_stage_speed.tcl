lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

set js [ticklecharts::jsfunc new {
            [
              [0.3, '#67e0e3'],
              [0.7, '#37a2da'],
              [1, '#fd666d']
            ]
          }]
               
$chart AddGaugeSeries -axisLine      [list lineStyle [list width 30 color $js]] \
                      -pointer       {itemStyle {color "auto" borderColor "nothing"}} \
                      -axisTick      {distance -30 length 8 lineStyle {color "#fff" width 2}} \
                      -splitLine     {distance -30 length 30 lineStyle {width 2 color "#fff"}} \
                      -axisLabel     {color "auto" distance 40 fontSize 20} \
                      -detail        {valueAnimation "true" color "auto" formatter {<0123>value<0125> km/h}} \
                      -dataGaugeItem {{value 70}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename