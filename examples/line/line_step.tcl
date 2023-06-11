lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title   {text "Step Line"} \
                  -tooltip {trigger "axis"} \
                  -legend  {} \
                  -grid    {left "3%" right "4%" bottom "3%" containLabel true}
               
$chart Xaxis -data [list {Mon Tue Wed Thu Fri Sat Sun}]
$chart Yaxis
$chart Add "lineSeries" -name "Step Start" \
                        -step "start" \
                        -data [list {120 132 101 134 90 230 210}]
                     
$chart Add "lineSeries" -name "Step Middle" \
                        -step "middle" \
                        -data [list {220 282 201 234 290 430 410}]            

$chart Add "lineSeries" -name "Step End" \
                        -step "end" \
                        -data [list {450 432 401 454 590 530 510}]                        

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
