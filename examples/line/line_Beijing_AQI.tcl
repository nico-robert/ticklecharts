lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Add dataZoom
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/aqi-beijing.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    set chart [ticklecharts::chart new]

    $chart SetOptions -title {text "Beijing AQI" subtext "Json data from : https://github.com/apache/echarts-examples" left "1%"} \
                    -tooltip {trigger "axis"} \
                    -grid {left "5%" right "15%" bottom "10%"} \
                    -visualMap {
                                type "piecewise"
                                top 50
                                right 10
                                pieces {
                                    {gt 0 lte 50 color "#93CE07"}
                                    {gt 50 lte 100 color "#FBDB0F"}
                                    {gt 100 lte 150 color "#FC7D02"}
                                    {gt 150 lte 200 color "#FD0100"}
                                    {gt 200 lte 300 color "#AA069F"}
                                    {gt 300 color "#AC3B2A"}
                                }
                                outOfRange {color "#999"}
                                } \
                    -dataZoom {
                                {type "slider" show "True" startValue "2014-06-01"}
                                {type "inside"}
                            }

    $chart Xaxis -data [list [lmap a $datajson {lindex $a 0}]]
    $chart Yaxis

    $chart Add "lineSeries" -name "Beijing AQI" \
                        -data [list [lmap a $datajson {lindex $a 1}]] \
                        -markLine {silent "True" lineStyle {color "#333" type "dashed" dashOffset 1 width 1} \
                                        data {
                                            objectItem {yAxis 50}
                                            objectItem {yAxis 100}
                                            objectItem {yAxis 150}
                                            objectItem {yAxis 200}
                                            objectItem {yAxis 300}
                                        }
                                    }

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 800px
} on error {result options} {
    puts stderr "[info script] : $result"
}

