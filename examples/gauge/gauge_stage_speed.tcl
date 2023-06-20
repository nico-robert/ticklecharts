lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Set new 'Add' method for chart series + use substitution for formatter property 
#        Note : map list substitution + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)
# v4.0 : Replaces '-dataGaugeItem' by '-dataItem' (both properties are available).

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
               
$chart Add "gaugeSeries" -axisLine   [list lineStyle [list width 30 color $js]] \
                         -pointer    {itemStyle {color "auto" borderColor "nothing"}} \
                         -axisTick   {distance -30 length 8 lineStyle {color "#fff" width 2}} \
                         -splitLine  {distance -30 length 30 lineStyle {width 2 color "#fff"}} \
                         -axisLabel  {color "auto" distance 40 fontSize 20} \
                         -detail     {valueAnimation "True" color "auto" formatter {"{value} km/h"}} \
                         -dataItem   {{value 70}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename