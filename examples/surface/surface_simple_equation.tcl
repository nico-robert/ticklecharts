lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set js [ticklecharts::jsfunc new {function (x, y) {
          if (Math.abs(x) < 0.1 && Math.abs(y) < 0.1) {
            return '-';
          }
          return Math.sin(x * Math.PI) * Math.sin(y * Math.PI);
        }
    }]

set chart3D [ticklecharts::chart3D new]

$chart3D SetOptions -tooltip {} \
                    -grid3D {viewControl {}} \
                    -visualMap  [list \
                                type "continuous" \
                                show "False" \
                                dimension 2 \
                                min -1 max 1 \
                                inRange [list color [list {#313695 #4575b4 #74add1 #abd9e9 #e0f3f8 #ffffbf #fee090 #fdae61 #f46d43 #d73027 #a50026}]] \
                            ]

$chart3D Xaxis3D -type "value"
$chart3D Yaxis3D -type "value"
$chart3D Zaxis3D -type "value"

$chart3D Add "surfaceSeries" -wireframe {} \
                             -equation [list \
                               x {step 0.05} \
                               y {step 0.05} \
                               z $js \
                             ]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart3D Render -outfile [file join $dirname $fbasename.html] \
                -title $fbasename