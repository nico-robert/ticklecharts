lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
#        Move '-animation' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Set new 'Add' method for chart series.
#        Set showAllSymbol to 'nothing' to avoid trace warning.
#        Note : Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see Add' method below)

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

set chart [ticklecharts::chart new]

$chart SetOptions -animation "False" \
                  -grid {top 40 left 50 right 40 bottom 50}
               
$chart Xaxis -type "null" -name "x" -min -50 -max 50 -minorTick {show "True"} -minorSplitLine {show "True"}
$chart Yaxis -type "null" -name "y" -min -20 -max 45 -minorTick {show "True"} -minorSplitLine {show "True"}

$chart Add "lineSeries" -data [generateData] \
                        -showSymbol "False" \
                        -showAllSymbol "nothing" \
                        -clip "True"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
