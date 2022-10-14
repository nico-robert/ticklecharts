lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    package require tls 1.7
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/npmdepgraph.min10.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    set chart [ticklecharts::chart new -animationDurationUpdate 1500 -animationEasingUpdate "quinticInOut"]

    $chart SetOptions -title {text "NPM Dependencies"}

    $chart AddGraphSeries -layout "none" \
                          -data [lmap node [dict get $datajson nodes] {
                                format {x %s y %s id %s name %s symbolSize %s itemStyle {color %s borderColor "nothing"}} \
                                    [dict get $node x] \
                                    [dict get $node y] \
                                    [dict get $node id] \
                                    [dict get $node label] \
                                    [dict get $node size] \
                                    [dict get $node color]
                                }
                          ] \
                          -edges [lmap edge [dict get $datajson edges] {
                                format {source %s target %s} \
                                    [dict get $edge sourceID] \
                                    [dict get $edge targetID] 
                            }
                          ] \
                          -emphasis {focus "adjacency" label {position "right" show "True"}} \
                          -roam "True" \
                          -lineStyle {width 0.5 curveness 0.3 opacity 0.7}

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 1200px -width 1200px

} on error {result options} {
    puts stderr "[info script] : $result"
}

