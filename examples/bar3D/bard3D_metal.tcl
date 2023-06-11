lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

proc generateData {} {
    set data {}

    for {set i 0} {$i <= 20} {incr i} {
        for {set j 0} {$j <= 20} {incr j} {
            lappend data [list $i $j [expr {rand() * 2 + 4}]]
        }
    }
    return $data
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart3D [ticklecharts::chart3D new]

$chart3D SetOptions -tooltip {} \
                    -grid3D [list \
                            environment "#000" \
                            axisPointer {show "False"} \
                            postEffect {enable "True" SSAO {enable "True" radius 5}} \
                            light [list main {intensity 3} ambientCubemap [list texture "https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/pisa.hdr" exposure 1 diffuseIntensity 0.5 specularIntensity 2]] \
                            ]

$chart3D Xaxis3D -type "value"
$chart3D Yaxis3D -type "value"
$chart3D Zaxis3D -type "value" -min 0 -max 10

$chart3D Add "bar3DSeries" -data [generateData] \
                           -barSize 4 \
                           -bevelSize 0.4 \
                           -bevelSmoothness 4 \
                           -shading "realistic" \
                           -realisticMaterial {roughness 0.3 metalness 1} \
                           -label {show "False" textStyle {fontSize 16 borderWidth 1}} \
                           -itemStyle {color "#ccc"} \
                           -emphasis {label {show "False"}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart3D Render -outfile [file join $dirname $fbasename.html] \
                    -title $fbasename



