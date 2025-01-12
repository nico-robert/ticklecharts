lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : replace '-data' by '-dataGraphItem' to keep the same logic for dictionnary data (-data flag is still active)
# v3.0 : Since v3.0.1 '-dataZoom' can be written like this -dataZoom {key "value"} instead of -dataZoom {{key "value"}} (for one list)
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Replaces '-dataGraphItem' by '-dataItem' (both properties are available).
# v6.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/life-expectancy.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    set chart [ticklecharts::chart new]

    $chart SetOptions -visualMap {type "piecewise" show "False" min 0 max 100 dimension 1} \
                      -legend [list data [list [dict get $datajson counties]] selectedMode "single" right 100] \
                      -grid {left 0 bottom 0 containLabel "True" top 80} \
                      -toolbox {feature {dataZoom {}}} \
                      -dataZoom {type "inside"}

    $chart Xaxis -type "value"
    $chart Yaxis -type "value" -scale "True"

    foreach country [dict get $datajson counties] {
        set d {}
        set links {}
        foreach data [dict get $datajson series] {
            
            foreach item $data {
                if {$country eq [lindex $item 3]} {
                    
                    if {([lindex $item 4] % 20 == 0) && ([lindex $item 4] > 1940)} {
                        set s "True"
                    } else {
                        set s "False"
                    }

                    lappend d [list \
                                label    [list show $s position "top"] \
                                emphasis {label {show "True"}} \
                                name     [lindex $item 4] \
                                value    [list $item] \
                              ]
                }
            }
        }

        for {set idx 0} {$idx < [llength $d]} {incr idx} {
            lappend links [list source $idx target [expr {$idx + 1}]]
        }

        $chart Add "graphSeries" -name $country \
                                 -coordinateSystem "cartesian2d" \
                                 -dataItem $d \
                                 -links $links \
                                 -edgeSymbol [list {"none" "arrow"}] \
                                 -edgeSymbolSize 5 \
                                 -legendHoverLink "False" \
                                 -lineStyle {color "#333"} \
                                 -itemStyle {borderWidth 1 borderColor "#333"} \
                                 -label {color "#333" position "right"} \
                                 -symbolSize 10
    }

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 1200px -width 1200px

} on error {result options} {
    puts stderr "[info script] : $result"
}

