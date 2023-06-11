lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]
               
$chart Add "sunburstSeries" -radius [list {15% 80%}] \
                            -sort null \
                            -emphasis {focus ancestor} \
                            -label {rotate radial show false} \
                            -itemStyle {color #ddd borderWidth 2} \
                            -data {
                                {
                                    children {
                                                {
                                                    value 5 children {
                                                    {value 1 itemStyle {color "#F54F4A"}}
                                                    {value 2 children {{value 1 itemStyle {color "#FF8C75"}}}}
                                                    {children {{value 1}}}
                                                    }
                                                    itemStyle {color "#F54F4A"}
                                                }
                                                {
                                                    value 10 children {
                                                        {value 6 children {
                                                            {value 1 itemStyle {color "#F54F4A"}}
                                                            {value 1}
                                                            {value 1 itemStyle {color "#FF8C75"}}
                                                            {value 1}
                                                            }
                                                            itemStyle {color "#FFB499"}
                                                        }
                                                        {value 2 children {
                                                            {value 1}
                                                            }
                                                            itemStyle {color "#FFB499"}
                                                        }
                                                        {children {
                                                            {value 1 itemStyle {color "#FF8C75"}}
                                                            }
                                                        }
                                                    }
                                                    itemStyle {color "#F54F4A"}
                                                }
                                            }
                                    itemStyle {color "#F54F4A"}
                                }
                                {
                                    value 9 children {
                                                        {
                                                            value 4 children {
                                                                {value 2 itemStyle {color "#FF8C75"}}
                                                                {children {{value 1 itemStyle {color "#F54F4A"}}}}
                                                            }
                                                            itemStyle {color "#F54F4A"}
                                                        }
                                                        {
                                                            children {
                                                                {value 3 children {
                                                                    {value 1}
                                                                    {value 1 itemStyle {color "#FF8C75"}}
                                                                    }
                                                                }
                                                            }
                                                            itemStyle {color "#FFB499"}
                                                        }
                                                    }
                                    itemStyle {color "#FF8C75"}
                                }
                                {
                                    value 7 children {
                                                        {
                                                            children {
                                                                {value 1 itemStyle {color "#FFB499"}}
                                                                {value 3 children {
                                                                    {value 1 itemStyle {color "#FF8C75"}}
                                                                    {value 1}
                                                                    }
                                                                itemStyle {color "#FF8C75"}
                                                                }
                                                            }
                                                            itemStyle {color "#FFB499"}
                                                        }
                                                        {
                                                            value 2 children {
                                                                {value 1}
                                                                {value 1 itemStyle {color "#F54F4A"}}
                                                            }
                                                            itemStyle {color "#F54F4A"}
                                                        }
                                                    }
                                    itemStyle {color "#F54F4A"}
                                }
                                {
                                    children {
                                                    {
                                                        value 6 children {
                                                            {value 1 itemStyle {color "#FF8C75"}}
                                                            {value 2 children {
                                                                {value 2 itemStyle {color "#FF8C75"}}
                                                                }
                                                            itemStyle {color "#F54F4A"}
                                                            }
                                                            {value 1 itemStyle {color "#FFB499"}}
                                                        }
                                                        itemStyle {color "#FFB499"}
                                                    }
                                                    {
                                                        value 3 children {
                                                            {value 1}
                                                            {children {{value 1 itemStyle {color "#FF8C75"}}}}
                                                            {value 1}
                                                        }
                                                        itemStyle {color "#FFB499"}
                                                    }
                                                }
                                    itemStyle {color "#F54F4A"}
                                }
                            }
                             

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 800px
