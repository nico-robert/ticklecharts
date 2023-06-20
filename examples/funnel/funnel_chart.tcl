lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datafunnelitem' by '-dataFunnelItem' + 
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Set new 'Add' method for chart series + use substitution for formatter property 
#        Note : map list substitution + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)
# v4.0 : Replaces '-dataFunnelItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title {text "Funnel"} \
                  -tooltip {trigger item formatter {"{a} <br/>{b} : {c}%"}} \
                  -legend {}

$chart Add "funnelSeries" -name "Funnel" \
                          -left "10%" \
                          -top 60 \
                          -bottom 60 \
                          -width "80%" \
                          -min 0 \
                          -max 100 \
                          -gap 2 \
                          -label {show True position "inside"} \
                          -labelLine {length 10 lineStyle {width 1 type "solid"}} \
                          -itemStyle {borderColor "#fff" borderWidth 1} \
                          -emphasis  {label {fontSize 20}} \
                          -dataItem {
                                    {value 60 name Visit}
                                    {value 40 name Inquiry}
                                    {value 20 name Order}
                                    {value 80 name Click}
                                    {value 100 name Show}
                                }


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
