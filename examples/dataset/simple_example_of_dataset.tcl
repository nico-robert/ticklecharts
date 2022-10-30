lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : re-working 'dataset' class should be a list of list...

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set source {
        {"product" "2015" "2016" "2017"}
        {"Matcha Latte" 43.3 85.8 93.7}
        {"Milk Tea" 83.1 73.4 55.1}
        {"Cheese Cocoa" 86.4 65.2 82.5}
        {"Walnut Brownie" 72.4 53.9 39.1}
      }

# dataset class
set dset [ticklecharts::dataset new [list [list -source $source -sourceHeader "true"]]]

# These series are in the first grid.
set bar [ticklecharts::chart new]
$bar SetOptions -legend {} -tooltip {} -dataset $dset

$bar Xaxis -type "category"
$bar Yaxis
$bar AddBarSeries
$bar AddBarSeries
$bar AddBarSeries


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$bar Render -outfile [file join $dirname $fbasename.html] -title $fbasename
