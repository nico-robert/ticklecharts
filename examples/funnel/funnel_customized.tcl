lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datafunnelitem' by '-dataFunnelItem' + 
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title {text "Funnel"} \
                  -tooltip {trigger item formatter "<0123>a<0125> <br/><0123>b<0125> : <0123>c<0125>%"} \
                  -legend {}
               

$chart AddFunnelSeries -name "Expected" \
                       -left "10%" \
                       -top "10%" \
                       -width "80%" \
                       -label {show True formatter "<0123>b<0125>Expected"} \
                       -labelLine {show false} \
                       -itemStyle {opacity 0.7} \
                       -emphasis  {label {position "inside" formatter "<0123>b<0125>Expected: <0123>c<0125>%"}} \
                       -dataFunnelItem {
                                            {value 60 name Visit}
                                            {value 40 name Inquiry}
                                            {value 20 name Order}
                                            {value 80 name Click}
                                            {value 100 name Show}
                                        }

$chart AddFunnelSeries -name "Actual" \
                       -left "10%" \
                       -top "10%" \
                       -width "80%" \
                       -maxSize "80%" \
                       -label {show True position "inside" formatter "<0123>c<0125>%" color "#fff"} \
                       -itemStyle {opacity 0.5 borderColor "#fff" borderWidth 2} \
                       -emphasis  {label {position "inside" formatter "<0123>b<0125>Actual: <0123>c<0125>%"}} \
                       -dataFunnelItem {
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