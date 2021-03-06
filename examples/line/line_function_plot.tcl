lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

proc func x {
    set x [expr {$x / 10.}]
    return [expr {sin($x) * cos($x * 2 + 1) * sin($x * 3 + 2) * 50}]
}

proc generateData {} {
    set data {}
    for {set i -50} {$i <= 50} {set i [expr {$i + 0.1}]} {
        lappend data [list $i [func $i]]
    }

    return $data
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new -animation "false"]

$chart SetOptions -grid {top 40 left 50 right 40 bottom 50}
               
$chart Xaxis -type "null" -name "x" -min -50 -max 50 -minorTick {show "True"} -minorSplitLine {show "True"}
$chart Yaxis -type "null" -name "y" -min -20 -max 45 -minorTick {show "True"} -minorSplitLine {show "True"}

$chart AddLineSeries -data [generateData] \
                     -showSymbol "False" \
                     -clip "True"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename
