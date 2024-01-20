lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

# source: https://www.makeapie.cn/echarts_content/x1-kIyaV6u.html
proc getParametricEquation {startRatio endRatio isSelected isHovered k height} {
    set midRatio    [expr {($startRatio + $endRatio) / 2.}]
    set startRadian [expr {$startRatio * 3.14 * 2}]
    set endRadian   [expr {$endRatio * 3.14 * 2}]
    set midRadian   [expr {$midRatio * 3.14 * 2}]

    if {$startRatio == 0 && $endRatio == 1} {
        set isSelected false
    }

    set hoverRate [expr {$isHovered ? 1.05 : 1}]
    set offsetX [expr {$isSelected ? cos($midRadian) * 0.1 : 0}]
    set offsetY [expr {$isSelected ? sin($midRadian) * 0.1 : 0}]


    dict set option u [list min -3.14 max [expr {3.14 * 3}] step [expr {3.14 / 32.}]]
    dict set option v [list min 0     max [expr {3.14 * 2}] step [expr {3.14 / 20.}]]


    set jsfuncX [ticklecharts::jsfunc new [subst {
        function(u, v) {
            if (u < $startRadian) {
                return $offsetX + Math.cos($startRadian) * (1 + Math.cos(v) * $k) * $hoverRate;
            }
            if (u > $endRadian ){
                return $offsetX + Math.cos($endRadian) * (1 + Math.cos(v) * $k) * $hoverRate;
            }
            return $offsetX + Math.cos(u) * (1 + Math.cos(v) * $k) * $hoverRate;
        },
        }]
    ]

    set jsfuncY [ticklecharts::jsfunc new [subst {
        function(u, v) {
            if (u < $startRadian) {
                return $offsetY + Math.sin($startRadian) * (1 + Math.cos(v) * $k) * $hoverRate;
            }
            if (u > $endRadian ){
                return $offsetY + Math.sin($endRadian) * (1 + Math.cos(v) * $k) * $hoverRate;
            }
            return $offsetY + Math.sin(u) * (1 + Math.cos(v) * $k) * $hoverRate;
        },
        }]
    ]

    set jsfuncZ [ticklecharts::jsfunc new [subst {
        function(u, v) {
            if (u < - Math.PI * 0.5 ) {
                return Math.sin(u);
            }
            if (u > Math.PI * 2.5 ){
                return Math.sin(u);
            }
            return Math.sin(v) > 0 ? 1*$height : -1;
        },
        }]
    ]

    dict set option x $jsfuncX
    dict set option y $jsfuncY
    dict set option z $jsfuncZ

    return $option
    
}

proc getPie3D {pieData internalDiameterRatio} {

    set k [expr {(1 - $internalDiameterRatio) / double(1 + $internalDiameterRatio)}]
    set sumValue 0
    set endValue 0
    set startValue 0
    set legendData {}
    set parametricEquation {}

    foreach item $pieData {
        set sumValue [expr {$sumValue + [dict get $item value]}]        
    }

    foreach item $pieData {
        set endValue [expr {$startValue + [dict get $item value]}]

        set startRatio [expr {$startValue / double($sumValue)}]
        set endRatio   [expr {$endValue / double($sumValue)}]
        lappend parametricEquation [getParametricEquation $startRatio $endRatio false false $k [dict get $item value]]
        set startValue $endValue

        lappend legendData [dict get $item name]

    }

    dict set option parametricEquation $parametricEquation
    dict set option legendData $legendData

    return $option

}


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart3D [ticklecharts::chart3D new]

set options {
    {name Tcl    value 1 itemStyle {opacity 0.8 color "rgb(0,127,244)"}}
    {name C++    value 1 itemStyle {opacity 0.8 color "rgb(255,150,230)"}}
    {name C      value 2 itemStyle {color "rgb(209,200,150)"}}
    {name Python value 1 itemStyle {opacity 0.8 color "rgb(209,126,23)"}}
}

set option [getPie3D $options 2]


$chart3D SetOptions -tooltip {} \
                    -legend [list \
                        show true \
                        textStyle {color #fff fontSize 26} \
                        data [list [dict get $option legendData]] \
                    ] \
                    -grid3D {
                        show false
                        boxHeight 20
                        bottom "50%"
                        environment "#021041" 
                        viewControl {
                            distance 300
                            alpha 25
                            beta 130
                        }
                    }
                    
$chart3D Xaxis3D -min -1 -max 1
$chart3D Yaxis3D -min -1 -max 1
$chart3D Zaxis3D -min -1 -max 1

set i 0
foreach serie [dict get $option parametricEquation] {
    $chart3D Add "surfaceSeries" -parametric "True" \
                                 -parametricEquation $serie \
                                 -itemStyle [dict get [lindex $options $i] itemStyle] \
                                 -wireframe {show false} \
                                 -name [dict get [lindex $options $i] name]
    incr i
}


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart3D Render -outfile [file join $dirname $fbasename.html] \
                -width 1300px -height 900px -title $fbasename
