proc getchild {value} {
    global namecollaspe

    if {![dict exists $value children]} {
        return ""
    }

    foreach item [dict get $value children] {
        if {[dict exists $item children]} {
            if {[expr {[llength [dict get $item children]] % 2}]} {
                if {[dict exists $item name]} {
                    lappend namecollaspe [dict get $item name]
                }
            }
        }
        getchild $item
    }
}

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
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/flare.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    # find child and collaspe tree if necessary...
    getchild $datajson

    foreach line [split $htmldata "\n"] {
        foreach valname $namecollaspe {
            if {[string match "*$valname*" $line]} {
                set line "$line \"collapsed\": true,"
                break
            }
        }
        lappend newdata $line
    }

    set chart [ticklecharts::chart new]

    $chart SetOptions -tooltip {trigger "item" triggerOn "mousemove"}
                
    $chart Add "treeSeries" -top "1%" -left "15%" -bottom "1%" -right "7%" -symbolSize 7 -orient "RL" \
                            -label {position "right" verticalAlign "middle" align "left"} \
                            -leaves {label {position "left" verticalAlign "middle" align "right"}} \
                            -emphasis {focus "descendant"} \
                            -expandAndCollapse "True" -animationDurationUpdate 750 -animationDuration 550 \
                            -data [list [json::json2dict [join $newdata "\n"]]]

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1500px -height 1500px

} on error {result options} {
    puts stderr "[info script] : $result"
}

