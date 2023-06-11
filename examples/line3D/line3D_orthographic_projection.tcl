lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v3.0 : Update example with the new 'Add' method for chart series.

set data {}

for {set t 0} {$t < 25} {set t [expr {$t + 0.001}]} {
    set x [expr {(1 + 0.25 * cos(75 * $t)) * cos($t)}]
    set y [expr {(1 + 0.25 * cos(75 * $t)) * sin($t)}]
    set z [expr {$t + 2.0 * sin(75 * $t)}]
    lappend data [list $x $y $z]
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart3D [ticklecharts::chart3D new]

$chart3D SetOptions -tooltip {} \
                    -grid3D {viewControl {projection "orthographic"}} \
                    -visualMap  [list \
                                type "continuous" \
                                show "False" \
                                dimension 2 \
                                min 0 max 30 \
                                inRange [list color [list {#313695 #4575b4 #74add1 #abd9e9 #e0f3f8 #ffffbf #fee090 #fdae61 #f46d43 #d73027 #a50026}]] \
                            ]

$chart3D Xaxis3D -type "value"
$chart3D Yaxis3D -type "value"
$chart3D Zaxis3D -type "value"

$chart3D Add "line3DSeries" -data $data -lineStyle {width 4}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart3D Render -outfile [file join $dirname $fbasename.html] \
                -title $fbasename