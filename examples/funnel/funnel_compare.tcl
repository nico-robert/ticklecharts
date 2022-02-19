lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title {text "Funnel Compare" subtext "Fake Data" left "left" top "bottom"} \
                  -tooltip {trigger item formatter "<0123>a<0125> <br/><0123>b<0125> : <0123>c<0125>%"} \
                  -legend {orient "vertical" left "left"}
               

$chart AddFunnelSeries -name "ExpectFunneled" \
                       -left "5%" \
                       -top "50%" \
                       -width "40%" \
                       -height "45%" \
                       -funnelAlign "right" \
                       -datafunnelitem {
                                            {value 60 name "Prod C"}
                                            {value 30 name "Prod D"}
                                            {value 10 name "Prod E"}
                                            {value 80 name "Prod B"}
                                            {value 100 name "Prod A"}
                                        }

$chart AddFunnelSeries -name "Pyramid" \
                       -left "5%" \
                       -top "5%" \
                       -width "40%" \
                       -height "45%" \
                       -funnelAlign "right" \
                       -sort "ascending" \
                       -datafunnelitem {
                                            {value 60 name "Prod C"}
                                            {value 30 name "Prod D"}
                                            {value 10 name "Prod E"}
                                            {value 80 name "Prod B"}
                                            {value 100 name "Prod A"}
                                        }

$chart AddFunnelSeries -name "Funnel" \
                       -left "55%" \
                       -top "5%" \
                       -width "40%" \
                       -height "45%" \
                       -funnelAlign "left" \
                       -datafunnelitem {
                                            {value 60 name "Prod C"}
                                            {value 30 name "Prod D"}
                                            {value 10 name "Prod E"}
                                            {value 80 name "Prod B"}
                                            {value 100 name "Prod A"}
                                        }
                                
$chart AddFunnelSeries -name "Pyramid" \
                       -left "55%" \
                       -top "50%" \
                       -width "40%" \
                       -height "45%" \
                       -funnelAlign "left" \
                       -sort "ascending" \
                       -datafunnelitem {
                                            {value 60 name "Prod C"}
                                            {value 30 name "Prod D"}
                                            {value 10 name "Prod E"}
                                            {value 80 name "Prod B"}
                                            {value 100 name "Prod A"}
                                        }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename
