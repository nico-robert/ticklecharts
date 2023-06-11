lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
#        Move '-color' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set colors [list {"#5470C6" "#EE6666"}]

set jsformat [ticklecharts::jsfunc new {function (params) {
                    return (
                      'Precipitation  ' +
                      params.value +
                      (params.seriesData.length ? '：' + params.seriesData[0].data : '')
                    );
                  }
                }]

set line1 [ticklecharts::chart new]

$line1 SetOptions -color $colors \
                  -tooltip {trigger "none" axisPointer {type "cross"}} \
                  -legend {}
                                
$line1 Xaxis -axisTick {show True alignWithLabel "True"} -position top \
             -axisLine [list show True onZero false lineStyle [list color [lindex {*}$colors 0]]] \
             -axisPointer [list label [list formatter $jsformat]] \
             -data [list {2016-1 2016-2 2016-3 2016-4 2016-5 2016-6 2016-7 2016-8 2016-9 2016-10 2016-11 2016-12}]
             
$line1 Xaxis -axisTick {show True alignWithLabel "True"} -position bottom \
             -axisLine [list show True onZero false lineStyle [list color [lindex {*}$colors 1]]] \
             -axisPointer [list label [list formatter $jsformat]] \
             -data [list {2015-1 2015-2 2015-3 2015-4 2015-5 2015-6 2015-7 2015-8 2015-9 2015-10 2015-11 2015-12}]
             
$line1 Yaxis

$line1 Add "lineSeries" -data [list {2.6 5.9 9.0 26.4 28.7 70.7 175.6 182.2 48.7 18.8 6.0 2.3}] \
                        -name "Precipitation(2015)" \
                        -smooth "True" \
                        -emphasis {focus "series"}
                   
$line1 Add "lineSeries" -data [list {3.9 5.9 11.1 18.7 48.3 69.2 231.6 46.6 55.4 18.4 10.3 0.7}] \
                        -name "Precipitation(2016)" \
                        -smooth "True" \
                        -emphasis {focus "series"}
             
               

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$line1 Render -outfile [file join $dirname $fbasename.html] -title $fbasename