lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : re-working 'dataset' class should be a list of list...
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Removes unnecessary 'list of list' for dataset class.
# v5.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.

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
set dset [ticklecharts::dataset new [list source $source sourceHeader "True"]]

# These series are in the first grid.
set bar [ticklecharts::chart new]
$bar SetOptions -legend {} -tooltip {} -dataset $dset

$bar Xaxis -type "category"
$bar Yaxis
$bar Add "barSeries"
$bar Add "barSeries"
$bar Add "barSeries"


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$bar Render -outfile [file join $dirname $fbasename.html] -title $fbasename
