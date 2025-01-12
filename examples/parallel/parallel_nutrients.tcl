lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Add ParallelAxis as method instead of a option.
# v3.0 : Move '-backgroundColor', '-animation' from constructor to 'SetOptions' method with v3.0.1
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Update of 'ParallelAxis' method with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without. (v3.2.3)
# v6.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

 proc hsvToRgb {h s v} {
    # source : https://wiki.tcl-lang.org/page/HSV+and+RGB
    set Hi [expr { int( double($h) / 60 ) % 6 }]
    set f [expr { double($h) / 60 - $Hi }]
    set s [expr { double($s)/255 }]
    set v [expr { double($v)/255 }]
    set p [expr { double($v) * (1 - $s) }]
    set q [expr { double($v) * (1 - $f * $s) }]
    set t [expr { double($v) * (1 - (1 - $f) * $s) }]
    switch -- $Hi {
        0 {
            set r $v
            set g $t
            set b $p
        }
        1 {
            set r $q
            set g $v
            set b $p
        }
        2 {
            set r $p
            set g $v
            set b $t
        }
        3 {
            set r $p
            set g $q
            set b $v
        }
        4 {
            set r $t
            set g $p
            set b $v
        }
        5 {
            set r $v
            set g $p
            set b $q
        }
        default {
            error "Wrong Hi value in hsvToRgb procedure! This should never happen!"
        }
    }
    set r [expr {round($r*255)}]
    set g [expr {round($g*255)}]
    set b [expr {round($b*255)}]
    return [list $r $g $b]
 }

proc getRandomColor {} {
    # source : https://stackoverflow.com/questions/9256420/random-color-generator-that-generates-colors-that-can-be-visibly-differentiated
    set h [expr { int(256 * rand()) }]
    set s [expr { int(256 * rand()) }]
    set v [expr { int(256 * rand()) }]

    lassign [hsvToRgb $h $s $v] r g b

    return [format "#%02x%02x%02x" $r $g $b]
}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/nutrients.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    dict set indices name 0
    dict set indices group 1
    dict set indices id 16

    set schema {
        { name "name" index 0 }
        { name "group" index 1 }
        { name "protein" index 2 }
        { name "calcium" index 3 }
        { name "sodium" index 4 }
        { name "fiber" index 5 }
        { name "vitaminc" index 6 }
        { name "potassium" index 7 }
        { name "carbohydrate" index 8 }
        { name "sugars" index 9 }
        { name "fat" index 10 }
        { name "water" index 11 }
        { name "calories" index 12 }
        { name "saturated" index 13 }
        { name "monounsat" index 14 }
        { name "polyunsat" index 15 }
        { name "id" index 16 }
    }

    set groupMap {}

    foreach row $datajson {
        set groupName [lindex $row [dict get $indices group]]

        if {$groupMap ni $groupName} {
            dict set groupMap $groupName 1
        }
    }

    set newdatajson {}

    foreach row $datajson {
        set index -1
        foreach item $row {
            incr index
            if {$index != [dict get $indices name] && 
                $index != [dict get $indices group] &&
                $index != [dict get $indices id]
                } {
                if {[string is double $item]} {
                    set irow [expr double($item)]
                } else {
                    set irow 0
                }
                set row [lreplace $row $index $index $irow]
            }
        }
        lappend newdatajson $row
    }

    set groupCategories {}
    dict for {key info} $groupMap {
        lappend groupCategories $key
    }

    set hStep [expr {round(300 / double([llength $groupCategories] - 1))}]
    set groupColors {}
    for {set i 0} {$i < [llength $groupCategories]} {incr i} {
        lappend groupColors [getRandomColor]
    }


    set chart [ticklecharts::chart new]
                
    $chart SetOptions -backgroundColor "#333" \
                      -animation "False" \
                      -title {text "Groups" top 0 left 0 textStyle {color #fff}} \
                      -tooltip {padding 10 backgroundColor #222 borderColor #777 borderWidth 1} \
                      -visualMap [list type "piecewise" show "True" categories [list $groupCategories] \
                                     dimension [dict get $indices group] \
                                     inRange [list color [list $groupColors]] \
                                     outOfRange {color "#ccc"} \
                                     top 20 textStyle {fontWeight normal fontSize 12 color #fff} realtime "False" \
                                     ] \
                      -parallel {
                            left 280 top 20 width 400 layout "vertical" 
                            parallelAxisDefault {
                                type value name "nutrients" nameLocation "end" nameGap 20 nameTextStyle {color #fff fontSize 14 verticalAlign "middle"}
                                axisLine {show "True" lineStyle {color "#aaa"}} axisTick {lineStyle {color "#777"}} splitLine {show "False"}
                                axisLabel {color #fff} realtime "False"
                            }
                        }
    $chart ParallelAxis [list \
        [list dim 16 name [dict get [lindex $schema 16] name] scale "True" nameLocation "end"] \
        [list dim 2  name [dict get [lindex $schema 2] name] ] \
        [list dim 4  name [dict get [lindex $schema 4] name] ] \
        [list dim 3  name [dict get [lindex $schema 3] name] ] \
        [list dim 5  name [dict get [lindex $schema 5] name] ] \
        [list dim 6  name [dict get [lindex $schema 6] name] ] \
        [list dim 7  name [dict get [lindex $schema 7] name] ] \
        [list dim 8  name [dict get [lindex $schema 8] name]] \
        [list dim 9  name [dict get [lindex $schema 9] name]] \
        [list dim 10 name [dict get [lindex $schema 10] name]] \
        [list dim 11 name [dict get [lindex $schema 11] name]] \
        [list dim 12 name [dict get [lindex $schema 12] name]] \
        [list dim 13 name [dict get [lindex $schema 13] name]] \
        [list dim 14 name [dict get [lindex $schema 14] name]] \
        [list dim 15 name [dict get [lindex $schema 15] name]] \
    ]
    
    $chart Add "parallelSeries" -name "nutrients" \
                                -inactiveOpacity 0 \
                                -activeOpacity 0.01 \
                                -progressive 500 \
                                -smooth "True" \
                                -lineStyle {width 0.5 opacity 0.05} \
                                -data [list {*}$newdatajson]

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 800px

} on error {result options} {
    puts stderr "[info script]  $result"
}

