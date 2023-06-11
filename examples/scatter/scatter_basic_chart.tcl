lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart Xaxis -type "value"
$chart Yaxis
$chart Add "scatterSeries" -symbolSize 20 \
                           -data [list {10.0 8.04} \
                                       {8.07 6.95} \
                                       {13.0 7.58} \
                                       {9.05 8.81} \
                                       {11.0 8.33} \
                                       {14.0 7.66} \
                                       {13.4 6.81} \
                                       {10.0 6.33} \
                                       {14.0 8.96} \
                                       {12.5 6.82} \
                                       {9.15 7.20} \
                                       {11.5 7.20} \
                                       {3.03 4.23} \
                                       {12.2 7.83} \
                                       {2.02 4.47} \
                                       {1.05 3.33} \
                                       {4.05 4.96} \
                                       {6.03 7.24} \
                                       {12.0 6.26} \
                                       {12.0 8.84} \
                                       {7.08 5.82} \
                                       {5.02 5.68} \
                                    ]     

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
          
