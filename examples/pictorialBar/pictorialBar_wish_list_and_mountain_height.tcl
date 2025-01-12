lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Move '-backgroundColor', '-animationEasing' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Set new 'Add' method for chart series + uses substitution for formatter property.
#        Note : map list formatter + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)
# v4.0 : Use '-dataItem' property for pictorialBarSeries instead of '-data' (both are accepted).
#        Use base64 encode instead of plain image.
# v5.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}

    # upload image from github
    http::register https 443 [list ::tls::socket -autoservername true]
    set token_kil [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/img/hill-Kilimanjaro.png]
    set token_qomo [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/img/hill-Qomolangma.png]

    set encodedData(token_kil)   [binary encode base64 [::http::data $token_kil]]
    set encodedData(token_qomo)  [binary encode base64 [::http::data $token_qomo]]

    set paperDataURI {
        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
    }

    set js [ticklecharts::jsfunc new {function (dataIndex, params) {
                        return params.index * 30;
                    }
                }]

    set picBar [ticklecharts::chart new]

    $picBar SetOptions -backgroundColor "#0f375f" \
                       -animationEasing "elasticOut" \
                       -tooltip {} \
                       -legend {textStyle {color "#ddd"}}

    $picBar Xaxis -data [list {"Christmas Wish List" "" "Qomolangma" "Kilimanjaro"}] \
                  -axisTick {show "False"} \
                  -axisLine {show "False"} \
                  -axisLabel {margin 20 color "#ddd" fontSize 14}


    $picBar Yaxis -splitLine {show "False"} \
                  -axisTick {show "False"} \
                  -axisLine {show "False"} \
                  -axisLabel {show "False"}

    
    set datapicItem {}

    lappend datapicItem [list value 13000 \
                              symbol [format {image://data:image/png;base64,%s} [string trim $paperDataURI]] \
                              symbolRepeat true \
                              symbolSize [list {130% 20%}] \
                              symbolOffset [list {0 10}] \
                              symbolMargin "-30%" \
                              animationDelay $js
                        ]

    lappend datapicItem {value "null" symbol "none"}


    lappend datapicItem [list value 8844 \
                              symbol [format {image://data:image/png;base64,%s} $encodedData(token_kil)] \
                              symbolSize [list {200% 105%}] \
                              symbolPosition "end" \
                        ]

    lappend datapicItem [list value 5895 \
                              symbol [format {image://data:image/png;base64,%s} $encodedData(token_qomo)] \
                              symbolSize [list {200% 105%}] \
                              symbolPosition "end" \
                        ]

    $picBar Add "pictorialBarSeries" -name "All" \
                                     -emphasis {scale "True"} \
                                     -symbolRepeatDirection "end" \
                                     -label {show True position top formatter {"{c} m"} fontSize 16 color "#e54035"} \
                                     -markLine [list symbol [list {"none" "none"}] label {show false} lineStyle {color "#e54035" width 2 type "dashed" dashOffset 1} data {objectItem {yAxis 8844}}] \
                                     -dataItem $datapicItem


    $picBar Add "pictorialBarSeries" -name "All" \
                                     -barGap "-100%" \
                                     -symbol "circle" \
                                     -itemStyle {color "#185491"} \
                                     -silent "True" \
                                     -symbolOffset [list {0 "50%"}] \
                                     -z "-10" \
                                     -dataItem [list \
                                        [list value 1 symbolSize [list {150% 50}]] \
                                        [list value "null"] \
                                        [list value 1 symbolSize [list {200% 50}]] \
                                        [list value 1 symbolSize [list {200% 50}]] \
                                    ]

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $picBar Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px
} on error {result options} {
    puts stderr "[info script] : $result"
}

