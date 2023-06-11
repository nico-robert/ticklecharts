lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

proc generateData {} {
    set data {}

    for {set i 0} {$i <= 10} {incr i} {
        for {set j 0} {$j <= 10} {incr j} {
            lappend data [list $i $j [expr {rand() * 4}]]
        }
    }
    return $data
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart3D [ticklecharts::chart3D new]

$chart3D SetOptions -grid3D {viewControl {} light {main {shadow "True" shadowQuality "ultra" intensity 1.5}}}

$chart3D Xaxis3D -type "value"
$chart3D Yaxis3D -type "value"
$chart3D Zaxis3D -type "value"


for {set i 0} {$i < 10} {incr i} {
    $chart3D Add "bar3DSeries" -data [generateData] \
                               -stack "stack" \
                               -shading "lambert" \
                               -emphasis {label {show "False"}}
}


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart3D Render -outfile [file join $dirname $fbasename.html] \
                -title $fbasename