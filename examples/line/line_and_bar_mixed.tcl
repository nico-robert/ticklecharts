lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : change position label right for second Yaxis (default left) 
#       + rename 'render' to 'Render' (Note : The first letter in capital letter)
# v3.0 : Set new 'Add' method for chart series + uses substitution for formatter property.
#        Note : map list formatter + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {show True trigger "axis" axisPointer {type "cross" crossStyle {color "#999"}}} \
                  -grid {left "3%" right "4%" bottom "3%" containLabel "True"} \
                  -legend {}
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] \
             -axisPointer {type "shadow"}
             
             
$chart Yaxis -name "Precipitation" \
             -position "left"  \
             -min 0 \
             -max 250 \
             -interval 50 \
             -axisLabel {formatter {"{value} ml"}}


$chart Yaxis -name "Temperature" \
             -position "right" \
             -min 0 \
             -max 25  \
             -interval 5 \
             -axisLabel {formatter {"{value} °C"}}


$chart Add "barSeries" -name "Evaporation" \
                       -data [list {2.0 4.9 7.0 23.2 25.6 76.7 135.6 162.2 32.6 20.0 6.4 3.3}]
                    
$chart Add "barSeries" -name "Precipitation" \
                       -data [list {2.6 5.9 9.0 26.4 28.7 70.7 175.6 182.2 48.7 18.8 6.0 2.3}]                    
                    
$chart Add "lineSeries" -name "Temperature" \
                        -yAxisIndex 1 \
                        -data [list {2.0 2.2 3.3 4.5 6.3 10.2 20.3 23.4 23.0 16.5 12.0 6.2}]


set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename