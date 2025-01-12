lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.
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
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/life-expectancy-table.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    set header [ticklecharts::jsfunc new {
                            <script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts-simple-transform/dist/ecSimpleTransform.min.js"></script>
                        } -header
                ]

    set registerTransform [ticklecharts::jsfunc new {echarts.registerTransform(ecSimpleTransform.aggregate);} -start]

    set detail [ticklecharts::jsfunc new {{"detail": false}}]

    # dataset class
    set dset [ticklecharts::dataset new [list \
                                            [list source $datajson sourceHeader "True" id "raw"] \
                                            [list id "since_year" fromDatasetId "raw" transform {{type "filter" config {dimension "Year" gte 1950}}}] \
                                            [list id "income_aggregate" fromDatasetId "since_year" transform {
                                                    {
                                                        type "ecSimpleTransform:aggregate" config {
                                                        resultDimensions {
                                                            {name "min" from "Income" method "min"}
                                                            {name "Q1" from "Income" method "Q1"}
                                                            {name "median" from "Income" method "median"}
                                                            {name "Q3" from "Income" method "Q3"}
                                                            {name "max" from "Income" method "max"}
                                                            {name "Country" from "Country"}
                                                        }
                                                        groupBy "Country"
                                                        }
                                                    }
                                                    {
                                                        type "sort"
                                                        config {dimension "Q3" order "asc"}
                                                    }
                                                }
                                            ] \
                                        ] \
    ]

    set chart [ticklecharts::chart new]

    $chart SetOptions -title {text "Income since 1950"} \
                      -tooltip {trigger "axis" confine "True"} \
                      -dataset $dset \
                      -legend [list selected $detail] \
                      -dataZoom {
                                    {type "inside"}
                                    {type "slider" show "True" height 20}
                                } \
                      -grid {bottom 100}

    $chart Xaxis -name "Income" -type "value" -nameLocation "middle" -nameGap 30 -scale "True"
    $chart Yaxis -type "category"


    $chart Add "boxPlotSeries" -name "boxplot" \
                               -datasetId "income_aggregate" \
                               -itemStyle {color "#b8c5f2" borderColor "nothing"} \
                               -encode [list \
                                   x [list {min Q1 median Q3 max}] \
                                   y "Country" \
                                   itemName "Country" \
                                   tooltip [list {min Q1 median Q3 max}] \
                               ]

    $chart Add "scatterSeries" -name "detail" \
                               -datasetId "since_year" \
                               -symbolSize 6 \
                               -tooltip {trigger "item"} \
                               -label {show "True" position "top" align "left" verticalAlign "middle" rotate 90 fontSize 12} \
                               -itemStyle {color "#d00000"} \
                               -encode [list \
                                   x "Income" \
                                   y "Country" \
                                   itemName "Year" \
                                   label "Year" \
                                   tooltip [list {Country Year Income}] \
                               ]


    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] \
                -title $fbasename \
                -script [list [list $header $registerTransform]] \
                -height 900px \
                -width 1000px

} on error {result options} {
    puts stderr "[info script] : $result"
}