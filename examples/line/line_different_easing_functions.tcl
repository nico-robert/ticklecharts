lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

proc line_linear {k} {
    return $k
}

proc line_quadraticIn {k} {
    return [expr {$k * $k}]
}

proc line_quadraticOut {k} {
    return [expr {$k * (2 - $k)}]
}

proc line_quadraticInOut {k} {
    set k [expr {$k * 2}]
    if {$k < 1} {
        return [expr {0.5 * $k * $k}]
    }
    set k [expr {$k - 1}] ; # --k
    return [expr {-0.5 * ($k * ($k - 2) - 1)}]
}

proc line_cubicIn {k} {
    return [expr {$k * $k * $k}]
}

proc line_cubicOut {k} {
    set k [expr {$k - 1}] ; # --k
    return [expr {$k * $k * $k + 1}]
}

proc line_cubicInOut {k} {
    set k [expr {$k * 2}]
    if {$k < 1} {
        return [expr {0.5 * $k * $k * $k}]
    }
    set k [expr {$k - 2}]
    return [expr {0.5 * ($k * $k * $k + 2)}]
}

proc line_quarticIn {k} {
    return [expr {$k * $k * $k * $k}]
}

proc line_quarticOut {k} {
    set k [expr {$k - 1}]  ; # --k
    return [expr {1 - $k * $k * $k * $k}]
}

proc line_quarticInOut {k} {
    set k [expr {$k * 2}]
    if {$k < 1} {
        return [expr {0.5 * $k * $k * $k * $k}]
    }
    set k [expr {$k - 2}]
    return [expr {-0.5 * ($k * $k * $k * $k - 2)}]
}

proc line_quinticIn {k} {
    return [expr {$k * $k * $k * $k * $k}]
}

proc line_quinticInOut {k} {
    set k [expr {$k * 2}]
    if {$k < 1} {
        return [expr {0.5 * $k * $k * $k * $k}]
    }
    set k [expr {$k - 2}]
    return [expr {0.5 * ($k * $k * $k * $k * $k + 2)}]
}

proc line_sinusoidalIn {k} {
    return [expr {1 - cos(($k * acos(-1)) / 2.)}]
}

proc line_sinusoidalOut {k} {
    return [expr {sin(($k * acos(-1)) / 2.)}]
}

proc line_sinusoidalInOut {k} {
    return [expr {0.5 * (1 - cos(acos(-1) * $k))}]
}

proc line_exponentialIn {k} {
    return [expr {$k == 0 ? 0 : pow(1024, $k - 1)}]
}

proc line_exponentialOut {k} {
    return [expr {$k == 1 ? 1 : 1 - pow(2, -10 * $k)}]
}

proc line_exponentialInOut {k} {
    if {$k == 0} {
        return 0
    }
    if {$k == 1} {
        return 1
    }
    set k [expr {$k * 2}]
    if {$k < 1} {
        return [expr {0.5 * pow(1024, $k - 1)}]
    }
    return [expr {0.5 * (-pow(2, -10 * ($k - 1)) + 2)}]
}

proc line_circularIn {k} {
    return [expr {1 - sqrt(1 - $k * $k)}]
}

proc line_circularOut {k} {
    return [expr {sqrt(1 - ($k - 1) * $k)}]
}

proc line_circularInOut {k} {
    set k [expr {$k * 2}]
    if {$k < 1} {
        return [expr {-0.5 * (sqrt(1 - $k * $k) - 1)}]
    }
    set k [expr {$k - 2}]
    return [expr {0.5 * (sqrt(1 - $k * $k) + 1)}]
}

proc line_elasticIn {k} {
    set a 0.1
    set p 0.4
    if {$k == 0} {
        return 0
    }
    if {$k == 1} {
        return 1
    }
    if {!$a || $a < 1} {
        set a 1
        set s [expr {$p / 4.}]
    } else {
        set s [expr {($p * asin(1 / double($a))) / (2 * acos(-1))}]
    }
    set k [expr {$k - 1}]
    return [expr {($a * pow(2, 10 * $k) * sin((($k - $s) * (2 * acos(-1))) / double($p))) * -1}]
}

proc line_elasticOut {k} {
    set a 0.1
    set p 0.4
    if {$k == 0} {
        return 0
    }
    if {$k == 1} {
        return 1
    }
    if {!$a || $a < 1} {
        set a 1
        set s [expr {$p / 4.}]
    } else {
        set s [expr {($p * asin(1 / double($a))) / (2 * acos(-1))}]
    }
    return [expr {($a * pow(2, -10 * $k) * sin((($k - $s) * (2 * acos(-1))) / double($p)) + 1)}]
}

proc line_elasticInOut {k} {
    set a 0.1
    set p 0.4
    if {$k == 0} {
        return 0
    }
    if {$k == 1} {
        return 1
    }
    if {!$a || $a < 1} {
        set a 1
        set s [expr {$p / 4.}]
    } else {
        set s [expr {($p * asin(1 / double($a))) / (2 * acos(-1))}]
    }
    set k [expr {$k * 2}]

    if {$k < 1} {
        set k [expr {$k - 1}]
        return [expr {-0.5 * ($a * pow(2, 10 * $k) * sin((($k - $s) * (2 * acos(-1))) / double($p)))}]
    }
    set k [expr {$k - 1}]
    return [expr {$a * pow(2, -10 * $k) * sin((($k - $s) * (2 * acos(-1))) / double($p)) * 0.5 + 1}]
}

proc line_backIn {k} {
    set s 1.70158
    return [expr {$k * $k * (($s + 1) * $k - $s)}]
}

proc line_backOut {k} {
    set s 1.70158
    set k [expr {$k - 1}]
    return [expr {$k * $k * (($s + 1) * $k + $s) + 1}]
}

proc line_backInOut {k} {
    set k [expr {$k * 2}]
    set s [expr {1.70158 * 1.525}]
    if {$k < 1} {
        return [expr {0.5 * ($k * $k * (($s + 1) * $k - $s))}]
    }
    set k [expr {$k - 2}]
    return [expr {0.5 * ($k * $k * (($s + 1) * $k + $s) + 2)}]
}

proc line_bounceIn {k} {
    return [expr {1 - [line_bounceOut [expr {1 - $k}]]}]
}

proc line_bounceOut {k} {
    if {$k < (1 / 2.75)} {
        return [expr {7.5625 * $k * $k}]
    } elseif {$k < (2 / 2.75)} {
        set k [expr {$k - (1.5 / 2.75)}]
        return [expr {7.5625 * $k * $k + 0.75}]
    } elseif {$k < (2.5 / 2.75)} {
        set k [expr {$k - (2.25 / 2.75)}]
        return [expr {7.5625 * $k * $k + 0.9375}]
    } else {
        set k [expr {$k - (2.625 / 2.75)}]
        return [expr {7.5625 * $k * $k + 0.984375}]
    }
}

proc line_bounceInOut {k} {
    if {$k < 0.5} {
        return [line_bounceIn [expr {($k * 2) * 0.5}]]
    }
    return [line_bounceOut [expr {($k * 2 - 1) * 0.5 + 0.5}]]
}

proc parseFloat {string} {
    return [string map {% ""} $string]
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set minP $::ticklecharts::minProperties ; set ::ticklecharts::minProperties 1

set N_POINT 30
set len       [llength [info procs line_*]]
set rowNumber [expr {ceil(sqrt($len))}]
set count 0

set layout    [ticklecharts::Gridlayout new]

foreach func [lsort -dictionary [info procs line_*]] {
    set data {}
    for {set i 0} {$i <= $N_POINT} {incr i} {
        set x [expr {$i / double($N_POINT)}]
        set y [$func $x]
        lappend data [list $x $y]
    }

    lassign [split $func "_"] _ name

    set left   [string cat [expr {(($count % int($rowNumber)) / $rowNumber) * 100 + 0.5}] "%"]
    set top    [string cat [expr {(floor($count / $rowNumber) / $rowNumber) * 100 + 0.5}] "%"]
    set width  [string cat [expr {(1 / $rowNumber) * 100 - 1}] "%"]
    set height $width

    set title_left [string cat [expr {[parseFloat $left] + [parseFloat $width] / 2.}] "%"]
    set title_top  $top

    set line [ticklecharts::chart new]

    $line SetOptions -title [list left $title_left top $title_top textAlign "center" text $name textStyle {fontSize 12 fontWeight "normal"}] \
                     -grid {show "True" borderWidth 0 shadowColor "rgba(0, 0, 0, 0.3)" shadowBlur 2}
                             
    $line Xaxis -type "value" -show "False" -min 0 -max 1 -gridIndex $count
    $line Yaxis -type "value" -show "False" -min -0.4 -max 1.4 -gridIndex $count


    $line Add "lineSeries" -name $name  \
                           -xAxisIndex $count \
                           -yAxisIndex $count \
                           -data $data \
                           -showSymbol "False" \
                           -animationEasing $name \
                           -animationDuration 1000

    $layout Add $line -left   $left \
                      -top    $top \
                      -width  $width \
                      -height $height

    incr count

}

$layout SetGlobalOptions -title {text "Different Easing Functions" top "bottom" left "center"}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] \
               -title $fbasename \
               -width "1525px" \
               -height "1013px"

# init properties...
set ::ticklecharts::minProperties $minP