proc createNodes {count} {
    set nodes {}
    for {set i 0} {$i < $count} {incr i} {
        lappend nodes [list id $i]
    }
    return $nodes
}

proc createEdges {count} {
    set edges {}
    if {$count == 2} {
        return [list {0 1}]
    }
    for {set i 0} {$i < $count} {incr i} {
        lappend edges [list $i [expr {($i + 1) % $count}]]
    }
    return $edges
}

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : replace '-data' by '-dataGraphItem' to keep the same logic for dictionnary data (-data flag is still active)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set datas {}

for {set i 0} {$i < 16} {incr i} {
    lappend datas [list nodes [createNodes [expr {$i + 2}]] edges [createEdges [expr {$i + 2}]]]
}

set chart [ticklecharts::chart new]

set idx 0
foreach val $datas {
    $chart AddGraphSeries -layout "force" \
                          -animation "False" \
                          -left  [format {%s%%} [expr {($idx % 4) * 25}]] \
                          -top   [format {%s%%} [expr {($idx / 4) * 25}]] \
                          -width  "25%" \
                          -height "25%" \
                          -dataGraphItem [lindex $val 1] \
                          -force {repulsion 60 edgeLength 2} \
                          -edges [lmap v [lindex $val 3] {format {source %s<s!> target %s<s!>} [lindex $v 0] [lindex $v 1]}]
    incr idx
}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 900px