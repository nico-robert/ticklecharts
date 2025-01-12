lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'center' by 'middle' for visualMap top flag
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/house-price-area2.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    set chart [ticklecharts::chart new]

    $chart SetOptions -title {text "Dispersion of house price based on the area" subtext "Json data from : https://github.com/apache/echarts-examples" left "center" top 0} \
                    -tooltip {trigger "item" axisPointer {type "cross"}} \
                    -grid {left "5%" right "15%" bottom "10%"} \
                    -visualMap [list \
                                type continuous min 15202 max 159980 \
                                dimension 1 orient vertical right 10 top middle \
                                text [list {HIGH LOW}] calculable true \
                                inRange [list color [list {#f2c31a #24b7f2}]] \
                    ]
                
    $chart Xaxis -type "value"
    $chart Yaxis

    $chart Add "scatterSeries" -name "price-area" -symbolSize 5 \
                            -data $datajson

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 800px
} on error {result options} {
    puts stderr "[info script] : $result"
}