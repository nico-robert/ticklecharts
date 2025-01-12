lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.
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
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/life-expectancy-table.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    set dimensions {"Income" "Life Expectancy" "Population" "Country" {name "Year" type "ordinal"}}

    # dataset class
    set dset [ticklecharts::dataset new [list dimensions $dimensions source $datajson]]

    set chart3D [ticklecharts::chart3D new]

    $chart3D SetOptions -grid3D {} \
                        -dataset $dset

    $chart3D Xaxis3D -type "category"
    $chart3D Yaxis3D
    $chart3D Zaxis3D

    $chart3D Add "scatter3DSeries" -symbolSize 2.5 \
                                   -encode [list x "Country" y "Life Expectancy" z "Income" tooltip [list {0 1 2 3 4}]]

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart3D Render -outfile [file join $dirname $fbasename.html] \
                    -title $fbasename

} on error {result options} {
    puts stderr "[info script] : $result"
}