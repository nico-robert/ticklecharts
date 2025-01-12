lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.
# v3.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/product.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    set chart [ticklecharts::chart new]

    $chart SetOptions -title {text "Sankey Diagram"} \
                      -tooltip {trigger "item" triggerOn "mousemove"}


    $chart Add "sankeySeries" -data [dict get $datajson nodes] -links [dict get $datajson links] \
                              -emphasis {focus "adjacency"} \
                              -levels {
                                  {depth 0 itemStyle {color "#fbb4ae"} lineStyle {color "source" opacity 0.6}}
                                  {depth 1 itemStyle {color "#b3cde3"} lineStyle {color "source" opacity 0.6}}
                                  {depth 2 itemStyle {color "#ccebc5"} lineStyle {color "source" opacity 0.6}}
                                  {depth 3 itemStyle {color "#decbe4"} lineStyle {color "source" opacity 0.6}}
                                  } \
                              -lineStyle {curveness 0.5 opacity 0.2}
            

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 800px
} on error {result options} {
    puts stderr "[info script] : $result"
}

