lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.
# v3.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.

set dimensions {product 2015 2016 2017}

# set source as 'eList class' to declare an 'array object'
set source [new elist {
      {product "Matcha Latte" "2015" 43.3 "2016" 85.8 "2017" 93.7}
      {product "Milk Tea" "2015" 83.1 "2016" 73.4 "2017" 55.1 }
      {product "Cheese Cocoa" "2015" 86.4 "2016" 65.2 "2017" 82.5 }
      {product "Walnut Brownie" "2015" 72.4 "2016" 53.9 "2017" 39.1}
    }
]

# dataset class
set dset [ticklecharts::dataset new [list dimensions $dimensions source $source]]

set chart [ticklecharts::chart new]

$chart SetOptions -legend {} -tooltip {} -dataset $dset
               
$chart Xaxis -type "category"
$chart Yaxis -type "value"

# Declare several bar series, each will be mapped
# to a column of dataset.source by default.
$chart Add "barSeries"
$chart Add "barSeries"
$chart Add "barSeries"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename