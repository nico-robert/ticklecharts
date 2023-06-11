lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set js [ticklecharts::jsfunc new {function (param) {
                                var depth = param.treePathInfo.length;
                                if (depth === 2) {
                                return 'radial';
                                } else if (depth === 3) {
                                return 'tangential';
                                } else if (depth === 4) {
                                return '0';
                                }
                                return '';
                             }}]

set chart [ticklecharts::chart new]
               
$chart Add "sunburstSeries" -radius [list {15% 80%}] \
                            -sort null \
                            -emphasis {focus ancestor} \
                            -data {
                                {
                                    value 8 children {
                                                      {value 4 children {{value 2} {value 1} {value 1} {value 0.5}}}
                                                      {value 2}
                                                    }
                                                        
                                }
                                {
                                    value 4 children {{children {{value 2}}}}
                                }
                                {
                                    value 4 children {{children {{value 2}}}}
                                }
                                {
                                    value 3 children {{children {{value 1}}}}
                                }
                             } \
                            -label [list color "#000" textBorderColor "#fff" textBorderWidth 2 formatter $js] \
                            -levels {
                                {} 
                                {itemStyle {color "#CD4949"} label {rotate "radial"}}
                                {itemStyle {color "#F47251"} label {rotate "tangential"}}
                                {itemStyle {color "#FFC75F"} label {rotate 0}}
                                }
                             

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 800px
