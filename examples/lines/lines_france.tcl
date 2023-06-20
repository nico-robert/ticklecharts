lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.
# v3.0 : Replaces '-dataLinesItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# add header 'France.js' from : https://github.com/echarts-maps/echarts-countries-js
set header [ticklecharts::jsfunc new {
                            <script type="text/javascript" src="https://echarts-maps.github.io/echarts-countries-js/echarts-countries-js/France.js"></script>
                        } -header
            ]


set chart [ticklecharts::chart new]
# echarts.registerMap = "法国" 

$chart SetOptions -geo {map "法国" roam "True" itemStyle {color "#323c48" borderColor "#111"}}


$chart Add "linesSeries" -name "Arrow" \
                         -coordinateSystem "geo" \
                         -large "False" \
                         -progressiveThreshold 3000 \
                         -progressive 400 \
                         -polyline "False" \
                         -zlevel 3 \
                         -effect {
                                   show "True"
                                   trailLength 0.5
                                   period 4
                                   color "red"
                                   symbol "arrow"
                                   symbolSize 6
                                 } \
                         -symbolSize 12 \
                         -symbol [list {none arrow}] \
                         -dataItem [list \
                                           [list coords [list \
                                                       {-1.4724319938245576 43.49308776293058} \
                                                       {2.34960965438873 48.860204769341884} \
                                                   ] \
                                           ] \
                                           [list coords [list \
                                                       {2.34960965438873 48.860204769341884} \
                                                       {5.372546427576347 43.29511510366016} \
                                                   ] \
                                           ] \
                                           [list coords [list \
                                                       {5.372546427576347 43.29511510366016} \
                                                       {-1.4724319938245576 43.49308776293058} \
                                                   ] \
                                           ] \
                         ] \
                         -lineStyle {width 1 opacity 1 curveness 0.2 type solid}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -width 1500px \
              -height 900px \
              -script $header