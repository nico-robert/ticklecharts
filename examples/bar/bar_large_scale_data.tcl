lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

proc commify number {
    # From wiki (always !!) 
    # https://wiki.tcl-lang.org/page/commas+added+to+numbers
    regsub -all \\d(?=(\\d{3})+([regexp -inline {\.\d*$} $number]$)) $number {\0,}
}

proc next {idx} {
    global smallBaseValue baseValue

    set smallBaseValue [expr {($idx % 30) ? [expr {rand() * 700}] : [expr {$smallBaseValue + rand() * 500 - 250}]}]
    set  baseValue [expr {$baseValue + rand() * 20 - 10}]

    return [expr {max(0, round($baseValue + $smallBaseValue) + 3000)}]

}


proc generateData {count} {
    global base

    for {set i 0} {$i < $count} {incr i} {

        lappend categoryData [clock format $base -format {%Y-%m-%d<n?>%H:%M:%S}]
        lappend valueData [format %.2f [next $i]]
        set base [clock scan {+1000 seconds} -base $base]
    }

    return [list $categoryData $valueData]
}

set baseValue [expr {rand() * 1000}]
set base [clock scan {2011-01-01<n?>0:0:0} -format {%Y-%m-%d<n?>%H:%M:%S}]
set smallBaseValue 0

set dataCount 5000

lassign [generateData $dataCount] categoryData valueData


# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

$chart SetOptions -title [list text "Large scale data Bar : [commify $dataCount]" left 10] \
                  -toolbox {feature {dataZoom {yAxisIndex false} saveAsImage {pixelRatio 2}}} \
                  -tooltip {trigger "axis" axisPointer {type shadow}} \
                  -grid {bottom 90} \
                  -dataZoom {
                                {type "inside"}
                                {type "slider" show "True"}
                            }
               
$chart Xaxis -type "category" -silent "false" -splitLine {show "False"} -splitArea {show "False"} -data [list $categoryData]
$chart Yaxis -type "value"    -splitArea {show "False"}


$chart Add "barSeries" -name "Fake Data" \
                       -data [list $valueData] \
                       -large "True"


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1900px -height 1200px
