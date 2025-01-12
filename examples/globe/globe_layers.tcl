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

    # upload image from github
    http::register https 443 [list ::tls::socket -autoservername true]
    set earth      [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/earth.jpg]
    set starfield  [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/starfield.jpg]
    set bathymetry [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/bathymetry_bw_composite_4k.jpg]
    set night      [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/night.jpg]
    set clouds     [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/clouds.jpg]

    set encodedData(earth)      [binary encode base64 [::http::data $earth]]
    set encodedData(starfield)  [binary encode base64 [::http::data $starfield]]
    set encodedData(bathymetry) [binary encode base64 [::http::data $bathymetry]]
    set encodedData(night)      [binary encode base64 [::http::data $night]]
    set encodedData(clouds)     [binary encode base64 [::http::data $clouds]]

    set globe [ticklecharts::chart3D new]

    $globe SetOptions -backgroundColor "#000" \
                      -globe [list \
                        baseTexture   [format {data:image/jpg;base64,%s} $encodedData(earth)] \
                        heightTexture [format {data:image/jpg;base64,%s} $encodedData(bathymetry)] \
                        shading "lambert" \
                        displacementScale 0.1 \
                        environment [format {data:image/jpg;base64,%s} $encodedData(starfield)] \
                        atmosphere {show "True"} \
                        light {ambient {intensity 0.1} main {intensity 1.5}} \
                        layers [list \
                            [list type "blend" blendTo "emission" texture [format {data:image/jpg;base64,%s} $encodedData(night)]] \
                            [list type "overlay" shading "lambert" distance 5 texture [format {data:image/jpg;base64,%s} $encodedData(clouds)]] \
                        ] \
                      ]

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $globe Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px
} on error {result options} {
    puts stderr "[info script] : $result"
}