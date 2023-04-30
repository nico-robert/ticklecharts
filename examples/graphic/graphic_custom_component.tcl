lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'center' by 'middle' for children top flag
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v4.0 : Set new 'Add' method for chart series.
#        Set showAllSymbol to 'nothing' to avoid trace warning.
#        Note : Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see Add' method below)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set js  [ticklecharts::jsfunc new {"Temperature : <br/>{b}km : {c}°C"}]
set js1 [ticklecharts::jsfunc new {"{value} °C"}]
set js2 [ticklecharts::jsfunc new {"{value} km"}]

set chart [ticklecharts::chart new]

$chart SetOptions -legend [list data [list {"Altitude (km) vs Temperature (°C)" ""}]] \
                  -tooltip [list trigger axis formatter $js] \
                  -grid {left 3% right 4% bottom 3% containLabel True}

$chart Xaxis -type "value" \
             -axisLabel [list formatter $js1]

$chart Yaxis -type "category" \
             -axisLine {onZero false} \
             -axisLabel [list formatter $js2] \
             -boundaryGap True \
             -data [list {0 10 20 30 40 50 60 70 80}]

$chart Add "graphic" -elements {
                            {
                                type group rotation 0.785398163397448 bounding "raw" right 110 bottom 110 z 100
                                children {
                                            {type rect left center top middle z 100 shape {width 400 height 50} style {fill "rgba(0,0,0,0.3)"}}
                                            {type text left center top middle z 100 style {fill "#fff" text "ECHARTS LINE CHART" font "bold 26px sans-serif"}}
                                        }
                            }
                            {
                                type group left 10% top middle
                                children {
                                            {
                                                type rect z 100 left center top middle
                                                shape {width 240 height 90}
                                                style {fill #fff stroke #555 lineWidth 1 shadowBlur 8 shadowOffsetX 3 shadowOffsetY 3 shadowColor "rgba(0,0,0,0.2)"}
                                            }
                                            {
                                                type text z 100 left center top middle
                                                style {
                                                    fill #333
                                                    width 220
                                                    overflow "break"
                                                    text "xAxis represents temperature in °C, yAxis represents altitude in km, An image watermark in the upper right, This text block can be placed in any place"
                                                    font "14px Microsoft YaHei"
                                                    }
                                            }
                                        }
                            }
}

$chart Add "lineSeries" -name "graphic" \
                        -smooth True \
                        -showAllSymbol "nothing" \
                        -data [list {15 -50 -56.5 -46.5 -22.1 -2.5 -27.7 -55.7 -76.5}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -jschartvar "mychart" \
              -divid "id_chart"