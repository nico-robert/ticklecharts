lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datafunnelitem' by '-dataFunnelItem' +
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# line
set line [ticklecharts::chart new]
               
$line Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}]
$line Yaxis
$line AddLineSeries -data [list {120 200 150 80 70 110 130}]

# funnel
set funnel [ticklecharts::chart new]

$funnel AddFunnelSeries -name "Funnel" \
                       -width "30%" \
                       -height "30%" \
                       -min 0 \
                       -max 100 \
                       -sort none \
                       -label {show True position "inside"} \
                       -labelLine {length 10 lineStyle {width 1 type "solid"}} \
                       -itemStyle {borderColor "#fff" borderWidth 1} \
                       -emphasis  {label {fontSize 20}} \
                       -dataFunnelItem {
                                        {value 120 name Mon}
                                        {value 200 name Tue}
                                        {value 150 name Wed}
                                        {value 80 name Thu}
                                        {value 70 name Fri}
                                        {value 110 name Sat}
                                        {value 130 name Sun}
                                        }

set layout [ticklecharts::Gridlayout new]
$layout Add $line   -bottom "60%" -width "30%" -left "5%"
$layout Add $funnel -top "50%" -left "5%"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] \
               -title $fbasename \
               -width 1900px \
               -height 1000px
