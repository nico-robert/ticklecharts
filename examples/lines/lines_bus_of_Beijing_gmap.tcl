proc busLine {data} {
    set hStep [expr {300 / double([llength $data] - 1)}]
    set idx 1
    set databus {}

    foreach line $data {
        set prevPt {}
        set points {}
        for {set i 0} {$i < [llength $line]} {incr i 2} {
            set pt [list [lindex $line $i] [lindex $line [expr {$i + 1}]]]
            if {$i > 0} {
                set pt [list [expr {[lindex $prevPt 0] + double([lindex $pt 0])}] [expr {[lindex $prevPt 1] + double([lindex $pt 1])}]]
            }

            set prevPt $pt
            lappend points [list [expr {[lindex $pt 0] / double(1e4)}] [expr {[lindex $pt 1] / double(1e4)}]]
        }

        set c [expr {round($hStep * $idx)}]
        set js [ticklecharts::jsfunc new [list echarts.color.modifyHSL('#5A94DF', $c)]]

        lappend databus [list coords $points lineStyle [list color $js width "nothing" opacity "nothing"]]
        incr idx
    }

    return $databus
}

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.
# v3.0 : Replaces '-dataLinesItem' by '-dataItem' (both properties are available).
# v4.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# you can set your Key Google API here or in ticklecharts.tcl (variable keyGMAPI)
set ::ticklecharts::keyGMAPI "??"

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/lines-bus.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]
    set busLine [busLine $datajson] ; # add data


    set chart [ticklecharts::chart new]

    # center = [lng, lat]
    # For 'mapTypeId', 'styles' see : https://developers.google.com/maps/documentation/javascript/reference/map#MapOptions 
    $chart SetOptions -tooltip {} \
                      -gmap [list \
                                center [list {116.46 39.92}] \
                                zoom 10 \
                                roam "True" \
                                disableDefaultUI "True" \
                                mapTypeId "roadmap" \
                                styles {
                                            {elementType "geometry" stylers {{color "#000102"}}}
                                            {elementType "labels" stylers {{visibility "off"}}}
                                            {elementType "labels.icon" stylers {{visibility "off"}}}
                                            {elementType "labels.text.fill" stylers {{visibility "off"}}}
                                            {featureType "road" elementType "geometry.fill" stylers {{visibility "off"}}}
                                            {featureType "water" elementType "geometry" stylers {{color "#031628"}}}
                                            {featureType "administrative" elementType "geometry" stylers {{visibility "on"} {color "#24b0e2"}}}
                                    }
                        ]

    $chart Add "linesSeries" -coordinateSystem "gmap" \
                             -polyline "True" \
                             -silent "True" \
                             -lineStyle {opacity 0.2 width 1} \
                             -progressiveThreshold 500 \
                             -progressive 200 \
                             -dataItem $busLine

    $chart Add "linesSeries" -coordinateSystem "gmap" \
                             -polyline "True" \
                             -silent "True" \
                             -lineStyle {width 0} \
                             -dataItem $busLine \
                             -effect {constantSpeed 20 show "True" trailLength 0.1 symbolSize 1.5 symbol "nothing"} \
                             -zlevel 1

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] \
                -title $fbasename \
                -width 1500px \
                -height 900px

} on error {result options} {
    puts stderr "[info script] : $result"
}