lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

proc fakerRandomValue {min max} {

    set range [expr {$max - $min}]
    return [expr {int(rand() * $range) + $min}]
}

proc dataPie {} {
    
    foreach name {C++ Tcl Python Java Perl JavaScript} {
        lappend data [list value [fakerRandomValue 350 500] name $name]
    }
    return $data
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set timeline [ticklecharts::timeline new]
$timeline SetOptions -axisType "category"

for {set i 2019} {$i < 2023} {incr i} {
    set pie [ticklecharts::chart new]

    $pie SetOptions -title [list text "Data $i"]

    $pie AddPieSeries -radius [list {"30%" "55%"}] -roseType "radius" \
                      -datapieitem [dataPie]

    $timeline Add $pie -data [list value "Data $i"]

}
           
set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$timeline Render -outfile [file join $dirname $fbasename.html] -title $fbasename
