# test all files...
lappend auto_path [file dirname [file dirname [file dirname [file normalize [info script]]]]]

package require ticklecharts

# set theme if you want...
set ::ticklecharts::theme "basic"

foreach chartfile [glob -directory [file dirname [info script]] -types f *.tcl] {
    if {[file tail $chartfile] eq "all.tcl"} {continue}
    source $chartfile
}