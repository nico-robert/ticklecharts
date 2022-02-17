# test all files...
lappend auto_path [file dirname [file dirname [file dirname [file normalize [info script]]]]]

package require ticklecharts

# set theme if you want...
# set ::ticklecharts::theme "basic"

# bar
foreach chartfile [glob -directory [file join [file dirname [info script]] bar] -types f *.tcl] {
    source $chartfile
}

# line
foreach chartfile [glob -directory [file join [file dirname [info script]] line] -types f *.tcl] {
    source $chartfile
}

# pie
foreach chartfile [glob -directory [file join [file dirname [info script]] pie] -types f *.tcl] {
    source $chartfile
}

# layout
foreach chartfile [glob -directory [file join [file dirname [info script]] layout] -types f *.tcl] {
    source $chartfile
}