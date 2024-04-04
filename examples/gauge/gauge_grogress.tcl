lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataGaugeItem' by '-dataItem' (both properties are available).
#        Replaces 'richitem' by 'richItem' (both properties are available).
# v5.0 : Update example with an structure for 'rich' property.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

set js [ticklecharts::jsfunc new {
            function (value) {
                return '{value|' + value.toFixed(0) + '}{unit|km/h}';
            }
          }]

# Define a new structure for 'value' property.
new estruct value {
    color:str "#777"
    fontStyle:str "normal"
    fontWeight:str "bolder"
    fontFamily:str "sans-serif"
    fontSize:num 50
    borderType:str "solid"
    textBorderType:str "solid"
    textShadowColor:str "transparent"
}
# Define a new structure for 'unit' property.
new estruct unit {
    color:str "#999"
    fontStyle:str "normal"
    fontWeight:str "normal"
    fontFamily:str "sans-serif"
    fontSize:num 20
    borderType:str "solid"
    padding:list.n {{0 0 -20 10}}
    textBorderType:str "solid"
    textShadowColor:str "transparent"
}

# Assembly
new estruct richStruct [subst {
    value:struct $value
    unit:struct  $unit
}]
               
$chart Add "gaugeSeries" -startAngle 180 -endAngle 0 -min 0 -max 240 -splitNumber 12 \
                         -itemStyle     {color "#58D9F9" shadowColor "rgba(0,138,255,0.45)" borderColor "nothing" shadowBlur 10 shadowOffsetX 2 shadowOffsetY 2} \
                         -progress      {show "True" roundCap "True" width 18} \
                         -pointer       {
                                         icon "path://M2090.36389,615.30999 L2090.36389,615.30999 C2091.48372,615.30999 2092.40383,616.194028 2092.44859,617.312956 L2096.90698,728.755929 C2097.05155,732.369577 2094.2393,735.416212 2090.62566,735.56078 C2090.53845,735.564269 2090.45117,735.566014 2090.36389,735.566014 L2090.36389,735.566014 C2086.74736,735.566014 2083.81557,732.63423 2083.81557,729.017692 C2083.81557,728.930412 2083.81732,728.84314 2083.82081,728.755929 L2088.2792,617.312956 C2088.32396,616.194028 2089.24407,615.30999 2090.36389,615.30999 Z"
                                         length "75%" 
                                         width 16
                                         } \
                         -axisLine      {roundCap "True" lineStyle {width 18}} \
                         -axisTick      {splitNumber 2 lineStyle {width 2 color #999}} \
                         -splitLine     {length 12 lineStyle {width 3 color "#999"}} \
                         -axisLabel     {distance 30 color "#999" fontSize 20} \
                         -title         {show "False"} \
                         -detail        [list \
                                            backgroundColor "#fff" borderColor #999 borderWidth 2  width "60%" \
                                            lineHeight 40 height 40 borderRadius 8 valueAnimation "True" \
                                            formatter $js offsetCenter [list {0 "35%"}] \
                                            rich $richStruct \
                                        ] \
                         -dataItem {{value 100}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px