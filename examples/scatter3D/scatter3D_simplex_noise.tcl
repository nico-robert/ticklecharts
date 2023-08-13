lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

array set GRAD3 {
    0 1
    1 1
    2 0
    3 -1
    4 1
    5 0
    6 1
    7 -1
    8 0
    9 -1
    10 -1
    11 0
    12 1
    13 0
    14 1
    15 -1
    16 0
    17 1
    18 1
    19 0
    20 -1
    21 -1
    22 0
    23 -1
    24 0
    25 1
    26 1
    27 0
    28 -1
    29 1
    30 0
    31 1
    32 -1
    33 0
    34 -1
    35 -1
}

set F3 [expr {1.0 / 3.0}]
set G3 [expr {1.0 / 6.0}]

proc generateData {} {
    set data {}
    for {set i 0} {$i <= 20} {incr i} {
        for {set j 0} {$j <= 20} {incr j} {
            for {set k 0} {$k <= 20} {incr k} {
                set value [noise3D [expr {$i / 10.}] [expr {$j / 10.}] [expr {$k / 10.}]]
                lappend data [list $i $j $k [expr {$value * 2 + 4}]]
            }
        }
    }

    return $data   
}

# 'https://fastly.jsdelivr.net/npm/simplex-noise@2.4.0/simplex-noise.js'
proc buildPermutationTable {random} {
    for {set i 0} {$i < 256} {incr i} {
        set p($i) $i
    }

    for {set i 0} {$i < 255} {incr i} {
        set r [expr {$i + int(rand() * (256 - $i))}]
        set aux $p($i)
        set p($i) $p($r)
        set p($r) $aux
    }

    return [array get p]    
}


proc SimplexNoise {random} {
    global P PERM PERMMOD12

    array set P [buildPermutationTable $random]

    for {set i 0} {$i < 512} {incr i} {
        set PERM($i) $P([expr {$i & 255}])
        set PERMMOD12($i) [expr {$PERM($i) % 12}]
    }
}

proc noise3D {xin yin zin} {
    global P PERM PERMMOD12 GRAD3 F3 G3

    array set permMod12 [array get PERMMOD12]
    array set perm [array get PERM]
    array set grad3 [array get GRAD3]


    set s [expr {($xin + $yin + $zin) * $F3}]
    set i [expr {int($xin + $s)}]
    set j [expr {int($yin + $s)}]
    set k [expr {int($zin + $s)}]

    set t [expr {($i + $j + $k) * $G3}]
    set X0 [expr {$i - $t}] 
    set Y0 [expr {$j - $t}] 
    set Z0 [expr {$k - $t}]
    set x0 [expr {$xin - $X0}]
    set y0 [expr {$yin - $Y0}]
    set z0 [expr {$zin - $Z0}]

    if {$x0 >= $y0} {
        if {$y0 >= $z0} {
            set i1 1
            set j1 0
            set k1 0
            set i2 1
            set j2 1
            set k2 0
        } elseif {$x0 >= $z0} {
            set i1 1
            set j1 0
            set k1 0
            set i2 1
            set j2 0
            set k2 1
        } else {
            set i1 0
            set j1 0
            set k1 1
            set i2 1
            set j2 0
            set k2 1
        }
    } else {
        if {$y0 < $z0} {
            set i1 0
            set j1 0
            set k1 1
            set i2 0
            set j2 1
            set k2 1
        } elseif {$x0 < $z0} {
            set i1 0
            set j1 1
            set k1 0
            set i2 0
            set j2 1
            set k2 1
        } else {
            set i1 0
            set j1 1
            set k1 0
            set i2 1
            set j2 1
            set k2 0
        }
    }


    set x1 [expr {$x0 - $i1 + $G3}]
    set y1 [expr {$y0 - $j1 + $G3}]
    set z1 [expr {$z0 - $k1 + $G3}]
    set x2 [expr {$x0 - $i2 + 2.0 * $G3}]
    set y2 [expr {$y0 - $j2 + 2.0 * $G3}]
    set z2 [expr {$z0 - $k2 + 2.0 * $G3}]
    set x3 [expr {$x0 - 1.0 + 3.0 * $G3}]
    set y3 [expr {$y0 - 1.0 + 3.0 * $G3}]
    set z3 [expr {$z0 - 1.0 + 3.0 * $G3}]

    set ii [expr {$i & 255}]
    set jj [expr {$j & 255}]
    set kk [expr {$k & 255}]

    set t0 [expr {0.6 - $x0 * $x0 - $y0 * $y0 - $z0 * $z0}]

    if {$t0 < 0} {
        set n0 0.0
    } else {
        set gi0 [expr {$permMod12([expr {$ii + $perm([expr {$jj + $perm($kk)}])}]) * 3}]
        set t0 [expr {$t0 * $t0}]
        set n0 [expr {$t0 * $t0 * ($grad3($gi0) * $x0 + $grad3([expr {$gi0 + 1}]) * $y0 + $grad3([expr {$gi0 + 2}]) * $z0)}]
    }

    set t1 [expr {0.6 - $x1 * $x1 - $y1 * $y1 - $z1 * $z1}]

    if {$t1 < 0} {
        set n1 0.0
    } else {
        set gi1 [expr {$permMod12([expr {$ii + $i1 + $perm([expr {$jj + $j1 + $perm([expr {$kk + $k1}])}])}]) * 3}]
        set t1 [expr {$t1 * $t1}]
        set n1 [expr {$t1 * $t1 * ($grad3($gi1) * $x1 + $grad3([expr {$gi1 + 1}]) * $y1 + $grad3([expr {$gi1 + 2}]) * $z1)}]
    }

    set t2 [expr {0.6 - $x2 * $x2 - $y2 * $y2 - $z2 * $z2}]

    if {$t2 < 0} {
        set n2 0.0
    } else {
        set gi2 [expr {$permMod12([expr {$ii + $i2 + $perm([expr {$jj + $j2 + $perm([expr {$kk + $k2}])}])}]) * 3}]
        set t2 [expr {$t2 * $t2}]
        set n2 [expr {$t2 * $t2 * ($grad3($gi2) * $x2 + $grad3([expr {$gi2 + 1}]) * $y2 + $grad3([expr {$gi2 + 2}]) * $z2)}]
    }

    set t3 [expr {0.6 - $x3 * $x3 - $y3 * $y3 - $z3 * $z3}]

    if {$t3 < 0} {
        set n3 0.0
    } else {
        set gi3 [expr {$permMod12([expr {$ii + 1 + $perm([expr {$jj + 1 + $perm([expr {$kk + 1}])}])}]) * 3}]
        set t3 [expr {$t3 * $t3}]
        set n3 [expr {$t3 * $t3 * ($grad3($gi3) * $x3 + $grad3([expr {$gi3 + 1}]) * $y3 + $grad3([expr {$gi3 + 2}]) * $z3)}]
    }


    return [expr {32.0 * ($n0 + $n1 + $n2 + $n3)}]
}


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}


SimplexNoise [expr {rand()}]

# compute
set data [generateData]

set chart3D [ticklecharts::chart3D new -theme "dark"]

$chart3D SetOptions -visualMap {
                                type "continuous"
                                show "False"
                                min 2
                                max 6 
                                inRange {
                                    symbolSize {{0.5 15}}
                                    colorAlpha {{0.2 1}}
                                    color {
                                        {#313695 #4575b4 #74add1 #abd9e9 #e0f3f8 #ffffbf #fee090 #fdae61 #f46d43 #f46d43 #a50026}
                                        }
                                    }
                                } \
                    -grid3D {
                        axisLine {lineStyle {color #fff}}
                        axisPointer {show true lineStyle {color #fff}}
                        viewControl {projection "orthographic"}
                        boxWidth 90
                        boxHeight 90
                        boxDepth 90
                        }
               
$chart3D Xaxis3D -type "value"
$chart3D Yaxis3D -type "value"
$chart3D Zaxis3D -type "value"

$chart3D Add "scatter3DSeries" -data $data


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart3D Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px
