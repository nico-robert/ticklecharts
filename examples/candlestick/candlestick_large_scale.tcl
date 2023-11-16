lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : re-working 'dataset' class should be a list of list...
# v3.0 : Fixes bug (or not !) with echarts version 5.4.1... when borderColor is set with itemStyle
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

proc commify number {
    # From wiki (always !!) 
    # https://wiki.tcl-lang.org/page/commas+added+to+numbers
    #
    regsub -all \\d(?=(\\d{3})+([regexp -inline {\.\d*$} $number]$)) $number {\0,}
}

proc getSign {data dataIndex openVal closeVal closeDimIdx} {
    
    if {$openVal > $closeVal} {
        return -1
    } elseif {$openVal < $closeVal} {
        return 1
    } else {
        if {$dataIndex > 0} {
            set d [expr {$dataIndex - 1}]
            if {[lindex $data $d $closeDimIdx] <= $closeVal} {
                return 1
            } else {
                return -1
            }
        } else {
            return 1
        }
    }
}

proc generateOHLC {count} {

    set data {}
    set base [clock scan {2011-01-01<n?>0:0:0} -format {%Y-%m-%d<n?>%H:%M:%S}]
    set baseValue [expr {rand() * 12000}]
    set dayRange 12

    for {set i 0} {$i < $count} {incr i} {
        set baseValue [expr {$baseValue + rand() * 20 - 10}]
        set boxVals {}
        for {set j 0} {$j < 4} {incr j} {
            lappend boxVals [expr {(rand() - 0.5) * $dayRange + $baseValue}]
        }

        set boxVals [lsort $boxVals]
        set openIdx [expr {round(rand() * 3)}]
        set closeIdx [expr {round(rand() * 2)}]

        if {$closeIdx == $openIdx} {
            incr closeIdx
        }

        set volumn [expr {[lindex $boxVals 3] * (1000 + rand() * 500)}]

        set cc [clock scan {+60 seconds} -base $base]

        set a [clock format $cc -format {%Y-%m-%d<n?>%H:%M:%S}]
        set b [format %.2f [lindex $boxVals $openIdx]]
        set c [format %.2f [lindex $boxVals 3]]
        set d [format %.2f [lindex $boxVals 0]]
        set e [format %.2f [lindex $boxVals $closeIdx]]
        set f [format %.0f $volumn]
        set g [getSign $data $i [lindex $boxVals $openIdx] [lindex $boxVals $closeIdx] 4]

        lappend data [list $a $b $c $d $e $f $g]

        set base $cc

    }

    return $data
}

set upColor "#ec0000"
set upBorderColor "#8A0000"
set downColor "#00da3c"
set downBorderColor "#008F28"
set dataCount 2000

set source [generateOHLC $dataCount]
set dset   [ticklecharts::dataset new [list source $source]]

set layout [ticklecharts::Gridlayout new]

$layout SetGlobalOptions -title [list text "Data Amount : [commify $dataCount]"] \
                         -tooltip  {trigger "axis" axisPointer {type "line"}} \
                         -toolbox {feature {dataZoom {yAxisIndex "False"}}} \
                         -dataset $dset \
                         -visualMap {type "piecewise" show "False" seriesIndex 1 dimension 6 pieces {{value 1 color "#ec0000"} {value -1 color "#00da3c"}}} \
                         -dataZoom [list [list type "inside" xAxisIndex [list {0 1}] start 10 end 100] [list type "slider" show "True" xAxisIndex [list {0 1}] bottom 10 start 10 end 100]]

set candlestick [ticklecharts::chart new]

$candlestick Xaxis -type "category" -boundaryGap "False" \
             -axisLine {onZero "False"} -splitLine {show "False"} \
             -min "dataMin" -max "dataMax"

$candlestick Yaxis -scale "True" -splitArea {show "True"}

$candlestick Add "candlestickSeries" -itemStyle [list color $upColor color0 $downColor borderColor $upBorderColor borderColor0 $downBorderColor] \
                                     -encode [list x 0 y [list {1 4 3 2}]]


set bar [ticklecharts::chart new]

$bar Xaxis -type "category" -boundaryGap "False" -gridIndex 1 \
           -axisLine {onZero "False"} -splitLine {show "False"} \
           -axisTick {show "False"} -axisLabel {show "False"} \
           -min "dataMin" -max "dataMax"

$bar Yaxis -scale "True" -gridIndex 1 -splitNumber 2 \
           -axisLabel {show "False"} -axisLine {show "False"} \
           -axisTick {show "False"} -splitLine {show "False"}

if {[ticklecharts::vCompare $::ticklecharts::echarts_version "5.3.0"] >= 0} {
    set itemS {color "#7fbe9e" borderColor null}
} else {
    set itemS {color "#7fbe9e"}
}

$bar Add "barSeries" -name "Volume" \
                     -xAxisIndex 1 \
                     -yAxisIndex 1 \
                     -itemStyle $itemS \
                     -large "True" \
                     -encode {x 0 y 5}

$layout Add $candlestick -left "10%" -right "10%" -bottom 200
$layout Add $bar         -left "10%" -right "10%" -height 80 -bottom 80

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px

# problem source all.tcl...
$layout destroy