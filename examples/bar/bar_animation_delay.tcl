lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
#        Move '-animationEasing', '-animationDelayUpdate' from constructor to 'SetOptions' method with v3.0.1
# v3.0 : Update example with the new 'Add' method for chart series.

for {set i 0} {$i < 100} {incr i} {
    lappend xAxisData [string cat "A" $i]
    lappend data1     [expr {(sin($i / 5.) * ($i / 5 - 10) + $i / 6.) * 5}]
    lappend data2     [expr {(cos($i / 5.) * ($i / 5 - 10) + $i / 6.) * 5}]
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set aDUpdate [ticklecharts::jsfunc new {function (idx) {
                                return idx * 5;
                            }}]

set chart [ticklecharts::chart new]

$chart SetOptions -animationEasing "elasticOut" \
                  -animationDelayUpdate $aDUpdate \
                  -title {text "Bar Animation Delay"} \
                  -legend [list data [list {"bar" "bar2"}]] \
                  -toolbox [list feature [list magicType [list type [list {"stack" "_"}]] dataView {} saveAsImage {pixelRatio 2}]] \
                  -tooltip {}


$chart Xaxis -data [list $xAxisData] -splitLine {show "False"}
$chart Yaxis
$chart Add "barSeries" -name "bar" \
                       -data [list $data1] \
                       -emphasis {focus "series"} \
                       -animationDelay [ticklecharts::jsfunc new {function (idx) {
                                return idx * 10;
                            }}]

$chart Add "barSeries" -name "bar2" \
                       -data [list $data2] \
                       -emphasis {focus "series"} \
                       -animationDelay [ticklecharts::jsfunc new {function (idx) {
                                return idx * 10 + 100;
                            }}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename