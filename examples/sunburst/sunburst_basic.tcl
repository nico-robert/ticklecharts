lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart Add "sunburstSeries" -radius [list {0 90%}] \
                            -label {rotate "radial"} \
                            -data {
                                    {
                                        name "Grandpa" children {
                                                                {
                                                                    name "Uncle Leo" value 15 children {
                                                                                                        {name "Cousin Jack" value 2}
                                                                                                        {name "Cousin Mary" value 5 children {{name "Jackson" value 2}}}
                                                                                                        {name "Cousin Ben" value 4}
                                                                                                    }
                                                                }
                                                                {
                                                                    name "Father" value 10 children {
                                                                                                    {name "Me" value 5}
                                                                                                    {name "Brother Peter" value 1}
                                                                                                    }
                                                                }
                                                            }
                                                            
                                    }
                                    {
                                        name "Nancy" children {
                                                                {name "Uncle Nike" children {
                                                                                             {name "Cousin Betty" value 1}
                                                                                             {name "Cousin Jenny" value 2}
                                                                                            }
                                                                }
                                                            }
                                    }
                                }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 800px
