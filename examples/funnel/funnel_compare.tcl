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

$chart SetOptions -title {text "Funnel Compare" subtext "Fake Data" left "left" top "bottom"} \
                  -tooltip {trigger item formatter {"{a} <br/>{b} : {c}%"}} \
                  -legend {orient "vertical" left "left"}
               

$chart Add "funnelSeries" -name "ExpectFunneled" \
                          -left "5%" \
                          -top "50%" \
                          -width "40%" \
                          -height "45%" \
                          -funnelAlign "right" \
                          -dataItem {
                                    {value 60 name "Prod C"}
                                    {value 30 name "Prod D"}
                                    {value 10 name "Prod E"}
                                    {value 80 name "Prod B"}
                                    {value 100 name "Prod A"}
                                }

$chart Add "funnelSeries" -name "Pyramid" \
                          -left "5%" \
                          -top "5%" \
                          -width "40%" \
                          -height "45%" \
                          -funnelAlign "right" \
                          -sort "ascending" \
                          -dataItem {
                                    {value 60 name "Prod C"}
                                    {value 30 name "Prod D"}
                                    {value 10 name "Prod E"}
                                    {value 80 name "Prod B"}
                                    {value 100 name "Prod A"}
                                }

$chart Add "funnelSeries" -name "Funnel" \
                          -left "55%" \
                          -top "5%" \
                          -width "40%" \
                          -height "45%" \
                          -funnelAlign "left" \
                          -dataItem {
                                    {value 60 name "Prod C"}
                                    {value 30 name "Prod D"}
                                    {value 10 name "Prod E"}
                                    {value 80 name "Prod B"}
                                    {value 100 name "Prod A"}
                                }
                                
$chart Add "funnelSeries" -name "Pyramid" \
                          -left "55%" \
                          -top "50%" \
                          -width "40%" \
                          -height "45%" \
                          -funnelAlign "left" \
                          -sort "ascending" \
                          -dataItem {
                                    {value 60 name "Prod C"}
                                    {value 30 name "Prod D"}
                                    {value 10 name "Prod E"}
                                    {value 80 name "Prod B"}
                                    {value 100 name "Prod A"}
                                }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
