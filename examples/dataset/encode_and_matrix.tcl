lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : destroy layout class (problem source all.tcl...)
# v3.0 : re-working 'dataset' class should be a list of list...
# v4.0 : Set new 'Add' method for chart series + adds a 'edict' class for dataset.dimension property (3.1.3).
#        Note : v3.0 version > Since some versions this is no longer quite true, it can be a simple list.
#        Note : Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)
# v5.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.
# v6.0 : Add eStruct class to dataset dimension for testing.
# v7.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

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

    set sizeValue "57%"
    set symbolSize 2.5

    # Adds eDict + eStruct classes (only for test)
    # Note : Values are arbitrary, that does not matter 
    # on the graphic result.
    new estruct struct_dim {
        name:str "test_struct"
        type:str "number"
    }
    set dimensions [list "Income" "Life Expectancy" "Population" "Country" \
                         {name "Year" type "ordinal"} \
                         [new edict {name "dummy" type "number"}] \
                         $struct_dim]

    # dataset class
    set dset [ticklecharts::dataset new [list dimensions $dimensions source $datajson]]

    # layout
    set layout [ticklecharts::Gridlayout new]
    $layout SetGlobalOptions -tooltip {} -toolbox {left "center" feature {dataZoom {}}} -dataset $dset

    # new scatter
    set scatter1 [ticklecharts::chart new]

    $scatter1 Xaxis -type "value" -name "Income" -axisLabel {rotate 50 interval 0}
    $scatter1 Yaxis -type "value" -name "Life Expectancys"

    $scatter1 Add "scatterSeries" -name "Scatter 1" \
                                  -symbolSize $symbolSize \
                                  -encode [list x "Income" y "Life Expectancy" tooltip [list {0 1 2 3 4}]]
    
    # new scatter
    set scatter2 [ticklecharts::chart new]

    $scatter2 Xaxis -type "category" -name "Country" -boundaryGap "false" -axisLabel {rotate 50 interval 0}
    $scatter2 Yaxis -type "value" -name "Income"

    $scatter2 Add "scatterSeries" -name "Scatter 2" \
                                  -symbolSize $symbolSize \
                                  -encode [list x "Country" y "Income" tooltip [list {0 1 2 3 4}]]
    
    # new scatter
    set scatter3 [ticklecharts::chart new]

    $scatter3 Xaxis -type "value" -name "Income" -axisLabel {rotate 50 interval 0}
    $scatter3 Yaxis -type "value" -name "Population"
    $scatter3 Add "scatterSeries" -name "Scatter 3" \
                                  -symbolSize $symbolSize \
                                  -encode [list x "Income" y "Population" tooltip [list {0 1 2 3 4}]]
    
    # new scatter
    set scatter4 [ticklecharts::chart new]

    $scatter4 Xaxis -type "value" -name "Life Expectancy" -axisLabel {rotate 50 interval 0}
    $scatter4 Yaxis -type "value" -name "Population"
    $scatter4 Add "scatterSeries" -name "Scatter 4" \
                                  -symbolSize $symbolSize \
                                  -encode [list x "Life Expectancy" y "Population" tooltip [list {0 1 2 3 4}]]

    $layout Add $scatter1 -right $sizeValue -bottom $sizeValue
    $layout Add $scatter2 -left  $sizeValue -bottom $sizeValue
    $layout Add $scatter3 -right $sizeValue -top $sizeValue
    $layout Add $scatter4 -left  $sizeValue -top $sizeValue

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $layout Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 800px

    # problem source all.tcl
    $layout destroy

} on error {result options} {
    puts stderr "[info script] : $result"
}

