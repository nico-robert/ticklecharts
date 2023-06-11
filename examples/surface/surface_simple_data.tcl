lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

proc float_range {start end step} {
    set temp {}
    while 1 {
        if {$start < $end} {
            lappend temp $start
            set start [expr {$start + $step}]
        } else {
            break
        }
    }
    return $temp
}

proc surface3d_data {} {
    set data {}
    foreach t0 [float_range -3 3 0.1] {
        set y $t0
        foreach t1 [float_range -3 3 0.1] {
            set x $t1
            set z [expr {$x**2 + $y}]
            lappend data [list $x $y $z]
        }
    }
    return $data
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart3D [ticklecharts::chart3D new]

$chart3D SetOptions -tooltip {} \
                    -grid3D {viewControl {}} \
                    -visualMap  [list \
                                type "continuous" \
                                show "False" \
                                dimension 1 \
                                min -1 max 1 \
                                inRange [list color [list {#313695 #4575b4 #74add1 #abd9e9 #e0f3f8 #ffffbf #fee090 #fdae61 #f46d43 #d73027 #a50026}]] \
                            ]

$chart3D Xaxis3D -type "value"
$chart3D Yaxis3D -type "value"
$chart3D Zaxis3D -type "value"

$chart3D Add "surfaceSeries" -wireframe {} \
                             -data [surface3d_data]


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart3D Render -outfile [file join $dirname $fbasename.html] \
                -title $fbasename

