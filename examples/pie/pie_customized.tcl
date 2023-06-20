lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datapieitem' by '-dataPieItem' +
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
#        Move '-backgroundColor' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataPieItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set js [ticklecharts::jsfunc new {function (idx) {return Math.random() * 200;}}]

set pie [ticklecharts::chart new]

$pie SetOptions -backgroundColor "rgb(44, 52, 60)" \
                -tooltip {trigger "item"} \
                -title   {text "Customized Pie" left "center" top 20 textStyle {color "#ccc"}} \
                -visualMap [list type "continuous" show false min 80 max 600 inRange [list colorLightness [list {0 1}]]]


$pie Add "pieSeries" -name "Access From" -radius "55%" \
                     -roseType "radius" \
                     -label     {show true color "rgba(255, 255, 255, 0.3)"} \
                     -labelLine {show true lineStyle {color "rgba(255, 255, 255, 0.3)"} smooth 0.2 length 10 length2 20} \
                     -itemStyle {color "#c23531" shadowBlur 200 shadowColor "rgba(0, 0, 0, 0.5)"} \
                     -animationType "scale" -animationEasing "elasticOut" -animationDelay $js \
                     -dataItem {
                         {value 400 name "Search Engine"}
                         {value 335 name "Direct"}
                         {value 310 name "Email"}
                         {value 274 name "Union Ads"}
                         {value 235 name "Video Ads"}
                         }

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$pie Render -outfile [file join $dirname $fbasename.html] -title $fbasename