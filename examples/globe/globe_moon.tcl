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
    set moon_base  [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/moon-base.jpg]
    set moon_bump  [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/moon-bump.jpg]
    set starfield  [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/starfield.jpg]

    set encodedData(moon_base) [binary encode base64 [::http::data $moon_base]]
    set encodedData(moon_bump) [binary encode base64 [::http::data $moon_bump]]
    set encodedData(starfield) [binary encode base64 [::http::data $starfield]]

    set globe [ticklecharts::chart3D new]

    $globe SetOptions -globe [list \
                        baseTexture   [format {data:image/jpg;base64,%s} $encodedData(moon_base)] \
                        heightTexture [format {data:image/jpg;base64,%s} $encodedData(moon_bump)] \
                        displacementScale 0.05 \
                        displacementQuality "medium" \
                        environment [format {data:image/jpg;base64,%s} $encodedData(starfield)] \
                        shading "realistic" \
                        realisticMaterial {roughness 0.8 metalness 0} \
                        postEffect {
                            enable "True" 
                            SSAO {
                                enable "True"
                                radius 2
                                intensity 1
                                quality "high"
                            }
                        } \
                        temporalSuperSampling {enable "True"} \
                        light {
                            ambient {intensity 0} 
                            main {intensity 1.5 shadow "True"} 
                            ambientCubemap {
                                texture "https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data-gl/asset/pisa.hdr"
                                exposure 0
                                diffuseIntensity 0.02
                            }
                        } \
                        viewControl {autoRotate "True"} \
                      ]

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $globe Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px
} on error {result options} {
    puts stderr "[info script] : $result"
}