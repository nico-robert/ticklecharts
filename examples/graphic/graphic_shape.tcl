lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart AddGraphic -elements [list \
                            {
                                type circle bounding "raw" z 100 right 300 bottom 160
                                shape {
                                    r 80
                                }
                                style {
                                    fill "gray"
                                }
                            } \
                            {
                                type arc bounding "raw" z 100 right 600 bottom 160
                                shape {
                                    r 80
                                    endAngle 3.14
                                }
                                style {
                                    fill "blue"
                                }
                            } \
                            {
                                type rect left center bottom 100 z 100
                                shape {width 400 height 50}
                                style {fill "rgba(0,0,0,0.3)"}
                            } \
                            {
                                type line right 100 bottom 100 z 100
                                shape {x1 0 y1 0 x2 0 y2 300}
                                style {stroke "red" lineWidth 3}
                            } \
                            {
                                type bezierCurve right 150 bottom 100 z 100
                                shape {x1 0 y1 0 x2 0 y2 300 cpx1 10 cpx2 30 cpy1 50 cpy2 100}
                                style {stroke "magenta" lineWidth 3}
                            } \
                            {
                                type ring left 100 bottom 300 z 100
                                shape {cx 50 cy 100 r 50 r0 40}
                                style {stroke "green" fill "yellow" lineWidth 3}
                            } \
                            [list \
                                type polyline bounding "raw" z 100 right 400 bottom 200 \
                                shape [list \
                                    points [list {200 90} {50 60} {80 100} {60 300}] \
                                ] \
                                style {
                                    fill "green"
                                }
                            ] \
                            ]
               
$chart Xaxis -data [list {A B C D E F}]
$chart Yaxis

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename


