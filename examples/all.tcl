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

# funnel
foreach chartfile [glob -directory [file join [file dirname [info script]] funnel] -types f *.tcl] {
    source $chartfile
}

# radar
foreach chartfile [glob -directory [file join [file dirname [info script]] radar] -types f *.tcl] {
    source $chartfile
}

# scatter
foreach chartfile [glob -directory [file join [file dirname [info script]] scatter] -types f *.tcl] {
    source $chartfile
}

# heatmap
foreach chartfile [glob -directory [file join [file dirname [info script]] heatmap] -types f *.tcl] {
    source $chartfile
}

# graphic
foreach chartfile [glob -directory [file join [file dirname [info script]] graphic] -types f *.tcl] {
    source $chartfile
}

# sunburst
foreach chartfile [glob -directory [file join [file dirname [info script]] sunburst] -types f *.tcl] {
    source $chartfile
}

# tree
foreach chartfile [glob -directory [file join [file dirname [info script]] tree] -types f *.tcl] {
    source $chartfile
}

# themeRiver
foreach chartfile [glob -directory [file join [file dirname [info script]] themeriver] -types f *.tcl] {
    source $chartfile
}

# sankey
foreach chartfile [glob -directory [file join [file dirname [info script]] sankey] -types f *.tcl] {
    source $chartfile
}

# layout
foreach chartfile [glob -directory [file join [file dirname [info script]] layout] -types f *.tcl] {
    source $chartfile
}

# dataset
foreach chartfile [glob -directory [file join [file dirname [info script]] dataset] -types f *.tcl] {
    source $chartfile
}

# pictorialBar
foreach chartfile [glob -directory [file join [file dirname [info script]] pictorialBar] -types f *.tcl] {
    source $chartfile
}