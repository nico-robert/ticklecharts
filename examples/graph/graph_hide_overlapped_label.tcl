lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : replace '-data' by '-dataGraphItem' to keep the same logic for dictionnary data (-data flag is still active)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataGraphItem' by '-dataItem' (both properties are available).
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
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/les-miserables.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    set chart [ticklecharts::chart new]

    $chart SetOptions -tooltip {} \
                      -legend [list dataLegendItem [dict get $datajson categories]]

    $chart Add "graphSeries" -name "Les Miserables" \
                             -layout "none" \
                             -dataItem [dict get $datajson nodes] \
                             -links [dict get $datajson links] \
                             -categories [dict get $datajson categories] \
                             -roam "True" \
                             -label {position "right" formatter {"{b}"}} \
                             -labelLayout {hideOverlap "True"} \
                             -scaleLimit {min 0.4 max 2} \
                             -lineStyle {color "source" curveness 0.3}

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 1200px -width 1200px

} on error {result options} {
    puts stderr "[info script] : $result"
}

