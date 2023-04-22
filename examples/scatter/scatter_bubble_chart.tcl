lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : delete 'show' key it's not a key option... in emphasis flag
#        + rename 'render' to 'Render' (Note : The first letter in capital letter)
# v3.0 : Move '-backgroundColor' from constructor to 'SetOptions' method with v3.0.1
# v4.0 : Set new 'Add' method for chart series + use substitution for formatter property 
#        Note : map list substitution + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)

set data {
  {
    {28604 77 17096869 "Australia" 1990}
    {31163 77.4 27662440 "Canada" 1990}
    {1516 68 1154605773 "China" 1990}
    {13670 74.7 10582082 "Cuba" 1990}
    {28599 75 4986705 "Finland" 1990}
    {29476 77.1 56943299 "France" 1990}
    {31476 75.4 78958237 "Germany" 1990}
    {28666 78.1 254830 "Iceland" 1990}
    {1777 57.7 870601776 "India" 1990}
    {29550 79.1 122249285 "Japan" 1990}
    {2076 67.9 20194354 "North Korea" 1990}
    {12087 72 42972254 "South Korea" 1990}
    {24021 75.4 3397534 "New Zealand" 1990}
    {43296 76.8 4240375 "Norway" 1990}
    {10088 70.8 38195258 "Poland" 1990}
    {19349 69.6 147568552 "Russia" 1990}
    {10670 67.3 53994605 "Turkey" 1990}
    {26424 75.7 57110117 "United Kingdom" 1990}
    {37062 75.4 252847810 "United States" 1990}
  }
  {
    {44056 81.8 23968973 "Australia" 2015}
    {43294 81.7 35939927 "Canada" 2015}
    {13334 76.9 1376048943 "China" 2015}
    {21291 78.5 11389562 "Cuba" 2015}
    {38923 80.8 5503457 "Finland" 2015}
    {37599 81.9 64395345 "France" 2015}
    {44053 81.1 80688545 "Germany" 2015}
    {42182 82.8 329425 "Iceland" 2015}
    {5903 66.8 1311050527 "India" 2015}
    {36162 83.5 126573481 "Japan" 2015}
    {1390 71.4 25155317 "North Korea" 2015}
    {34644 80.7 50293439 "South Korea" 2015}
    {34186 80.6 4528526 "New Zealand" 2015}
    {64304 81.6 5210967 "Norway" 2015}
    {24787 77.3 38611794 "Poland" 2015}
    {23038 73.13 143456918 "Russia" 2015}
    {19360 76.5 78665830 "Turkey" 2015}
    {38225 81.4 64715810 "United Kingdom" 2015}
    {53354 79.1 321773631 "United States" 2015}
  }
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}


# js function
set jsbackcolor [ticklecharts::jsfunc new {new echarts.graphic.RadialGradient(0.3, 0.3, 0.8, [
                                            {offset: 0, color: "#f7f8fa"},
                                            {offset: 1, color: "#cdd0d5"}
                                          ])
                                        }]

set jssymbolSize [ticklecharts::jsfunc new {function (data) {return Math.sqrt(data[2]) / 5e2;}}]

set jsitem [ticklecharts::jsfunc new {new echarts.graphic.RadialGradient(0.4, 0.3, 1, [
                                            {offset: 0, color: "rgb(251, 118, 123)"},
                                            {offset: 1, color: "rgb(204, 46, 72)"}
                                            ])
                                        }]

set jsitem1 [ticklecharts::jsfunc new {new echarts.graphic.RadialGradient(0.4, 0.3, 1, [
                                            {offset: 0, color: "rgb(129, 227, 238)"},
                                            {offset: 1, color: "rgb(25, 183, 207)"}
                                            ])
                                        }]

set chart [ticklecharts::chart new]

$chart SetOptions -backgroundColor $jsbackcolor \
                  -title {text "Life Expectancy and GDP by Country" left "5%" top "3%"} \
                  -legend {right "10%" top "3%"} \
                  -grid {left "8%" top "10%"}

$chart Xaxis -splitLine {show True lineStyle {type dashed}} -type "value"
$chart Yaxis -splitLine {show True lineStyle {type dashed}} -scale "True"

# delete 'show "true"' in scatterSeries(emphasis) method
$chart Add "scatterSeries" -name "1990" \
                           -symbolSize $jssymbolSize \
                           -data [lindex $data 0] \
                           -emphasis [list focus "series" label [list show true position top formatter {"{@[3]}"}]] \
                           -itemStyle [list shadowBlur 10 shadowColor "rgba(120, 36, 50, 0.5)" shadowOffsetY 5 color $jsitem borderColor null opacity 0.75]

$chart Add "scatterSeries" -name "2015" \
                           -symbolSize $jssymbolSize \
                           -data [lindex $data 1] \
                           -emphasis [list focus "series" label [list show true position top formatter {"{@[3]}"}]] \
                           -itemStyle [list shadowBlur 10 shadowColor "rgba(120, 36, 50, 0.5)" shadowOffsetY 5 color $jsitem1 borderColor null opacity 0.75]
                        
set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename  