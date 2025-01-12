lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/data/flights.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]
    set airports [dict get $datajson airports]
    set routes   {}
    set dataItem {}
    set data [dict get $datajson routes]

    foreach val $data {
        set val1 [lindex $val 1]
        set val2 [lindex $val 2]

        # Should be a list of coordinates like this {{20.565 35.565} {0.000 -50.5050}}
        lappend dataItem [list \
                    coords [list [list [lindex $airports $val1 3] [lindex $airports $val1 4]] [list [lindex $airports $val2 3] [lindex $airports $val2 4]]] \
                ]
    }

    set chart3D [ticklecharts::chart3D new]

    $chart3D SetOptions -backgroundColor "white" \
                        -globe {
                            baseTexture   "https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/world.topo.bathy.200401.jpg"
                            heightTexture "https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/bathymetry_bw_composite_4k.jpg"
                            shading "lambert"
                            light {ambient {intensity 0.4} main {intensity 0.4}}
                            viewControl {autoRotate "False"}
                        }

    $chart3D Add "lines3DSeries" -coordinateSystem "globe" \
                                 -dataItem $dataItem \
                                 -blendMode "lighter" \
                                 -lineStyle {width 1 color "rgb(50, 50, 150)" opacity 0.1}

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart3D Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px

} on error {result options} {
    puts stderr "[info script] : $result"
}