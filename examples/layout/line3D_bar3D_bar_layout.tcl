lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

set dataLine {}

set r 2
for {set t 0} {$t < 25} {set t [expr {$t + 0.1}]} {
    set x [expr {$r * cos($t)}]
    set y [expr {$r * sin($t)}]
    set z $t
    lappend dataLine [list $x $y $z]
}

set dataBar {}

for {set j 0} {$j <= 10} {incr j} {
    lappend dataBar [list 0.1 $j [expr {rand() * 4}]]
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set layout [ticklecharts::Gridlayout new]

$layout SetGlobalOptions -legend {top "2%" left "center"} \
                         -tooltip {}


# bar 2d
set bar [ticklecharts::chart new]

$bar Xaxis -data [list {A B C D E}]
$bar Yaxis
$bar Add "barSeries" -data [list {50 6 80 120 30}]
$bar Add "barSeries" -data [list {20 30 50 100 25}]

#line 3d
set line3D [ticklecharts::chart3D new]

$line3D SetOptions -grid3D {boxWidth 50 boxHeight 40 boxDepth 50 viewControl {projection "orthographic"}}

$line3D Xaxis3D -type "value"
$line3D Yaxis3D -type "value"
$line3D Zaxis3D -type "value"

$line3D Add "line3DSeries" -data $dataLine -lineStyle {width 5}

#Bar 3d
set bar3D [ticklecharts::chart3D new]

$bar3D SetOptions -grid3D {
                          boxWidth 50 boxHeight 40 boxDepth 50
                          viewControl {} light {main {shadow "True" shadowQuality "ultra" intensity 1.5}}
                        }

$bar3D Xaxis3D -type "value" -max 0.2
$bar3D Yaxis3D -type "value"
$bar3D Zaxis3D -type "value"

$bar3D Add "bar3DSeries" -data $dataBar \
                         -shading "lambert" \
                         -barSize 2.5


$layout Add $line3D -top "1%" -width "45%" -left "5%"
$layout Add $bar3D  -top "1%" -width "45%" -left "55%"
$layout Add $bar    -bottom "5%" -width "50%" -height "20%" -left "center"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] \
               -title $fbasename \
               -width 1700px \
               -height 1050px

set dataLine {} ; set dataBar {} ; $layout destroy