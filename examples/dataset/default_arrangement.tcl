lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : re-working 'dataset' class should be a list of list...
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Removes unnecessary 'list of list' for dataset class.
# v6.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set dimensions {"product" "2012" "2013" "2014" "2015" "2016" "2017"}

set source {
        {"Milk Tea" 86.5 92.1 85.7 83.1 73.4 55.1}
        {"Matcha Latte" 41.1 30.4 65.1 53.3 83.8 98.7}
        {"Cheese Cocoa" 24.1 67.2 79.5 86.4 65.2 82.5}
        {"Walnut Brownie" 55.2 67.1 69.2 72.4 53.9 39.1}
      }

# dataset class
set dset [ticklecharts::dataset new [list dimensions $dimensions source $source]]

set chart [ticklecharts::chart new]

$chart SetOptions -legend {} -tooltip {} -dataset $dset


$chart Add "pieSeries" -radius 20% -center [list {25% 30%}] ; # No encode specified, by default, it is '2012'
$chart Add "pieSeries" -radius 20% -center [list {75% 30%}] -encode {itemName "product" value "2013"}
$chart Add "pieSeries" -radius 20% -center [list {25% 75%}] -encode {itemName "product" value "2014"}
$chart Add "pieSeries" -radius 20% -center [list {75% 75%}] -encode {itemName "product" value "2015"}


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 900px