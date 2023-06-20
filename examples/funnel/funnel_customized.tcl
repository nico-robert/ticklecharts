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

$chart Add "funnelSeries" -name "Expected" \
                          -left "10%" \
                          -top "10%" \
                          -width "80%" \
                          -label {show True formatter {"{b}Expected"}} \
                          -labelLine {show false} \
                          -itemStyle {opacity 0.7} \
                          -emphasis  {label {position "inside" formatter {"{b}Expected: {c}%"}}} \
                          -dataItem {
                                    {value 60 name Visit}
                                    {value 40 name Inquiry}
                                    {value 20 name Order}
                                    {value 80 name Click}
                                    {value 100 name Show}
                                }

$chart Add "funnelSeries" -name "Actual" \
                          -left "10%" \
                          -top "10%" \
                          -width "80%" \
                          -maxSize "80%" \
                          -label {show True position "inside" formatter {"{c}%"} color "#fff"} \
                          -itemStyle {opacity 0.5 borderColor "#fff" borderWidth 2} \
                          -emphasis  {label {position "inside" formatter {"{b}Actual: {c}%"}}} \
                          -dataItem {
                                    {value 30 name Visit}
                                    {value 10 name Inquiry}
                                    {value 5 name Order}
                                    {value 80 name Click}
                                    {value 80 name Show}
                                } \
                          -z 100
                          # Ensure outer shape will not be over inner shape when hover (z = 100).
                       

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename