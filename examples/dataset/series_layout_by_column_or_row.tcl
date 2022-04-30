lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set source {
      {"product" "2012" "2013" "2014" "2015"}
      {"Matcha Latte" 41.1 30.4 65.1 53.3}
      {"Milk Tea" 86.5 92.1 85.7 83.1}
      {"Cheese Cocoa" 24.1 67.2 79.5 86.4}
      }

# dataset class
set dset [ticklecharts::dataset new -source $source -sourceHeader "true"]

# layout
set layout [ticklecharts::Gridlayout new]
$layout SetGlobalOptions -legend {} -tooltip {} -dataset $dset

# These series are in the first grid.
set bar [ticklecharts::chart new]

$bar Xaxis -type "category"
$bar Yaxis
$bar AddBarSeries -name "BarSerie1" -seriesLayoutBy "row"
$bar AddBarSeries -name "BarSerie2" -seriesLayoutBy "row"
$bar AddBarSeries -name "BarSerie3" -seriesLayoutBy "row"


# These series are in the second grid.
set bar1 [ticklecharts::chart new]

$bar1 Xaxis -type "category"
$bar1 Yaxis

$bar1 AddBarSeries -name "BarSerie4" -xAxisIndex 1 -yAxisIndex 1
$bar1 AddBarSeries -name "BarSerie5" -xAxisIndex 1 -yAxisIndex 1
$bar1 AddBarSeries -name "BarSerie6" -xAxisIndex 1 -yAxisIndex 1
$bar1 AddBarSeries -name "BarSerie7" -xAxisIndex 1 -yAxisIndex 1

$layout Add $bar  -bottom "55%"
$layout Add $bar1 -top "55%"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] -title $fbasename
