lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : re-working 'dataset' class should be a list of list...
# v3.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set source {
          {"Product" "Sales" "Price" "Year"}
          {"Cake" 123 32 2011}
          {"Cereal" 231 14 2011}
          {"Tofu" 235 5 2011}
          {"Dumpling" 341 25 2011}
          {"Biscuit" 122 29 2011}
          {"Cake" 143 30 2012}
          {"Cereal" 201 19 2012}
          {"Tofu" 255 7 2012}
          {"Dumpling" 241 27 2012}
          {"Biscuit" 102 34 2012}
          {"Cake" 153 28 2013}
          {"Cereal" 181 21 2013}
          {"Tofu" 395 4 2013}
          {"Dumpling" 281 31 2013}
          {"Biscuit" 92 39 2013}
          {"Cake" 223 29 2014}
          {"Cereal" 211 17 2014}
          {"Tofu" 345 3 2014}
          {"Dumpling" 211 35 2014}
          {"Biscuit" 72 24 2014}
      }

# dataset class
set dset [ticklecharts::dataset new [list \
                                        [list source $source] \
                                        [list transform {{type "filter" config {dimension "Year" value 2011}}}] \
                                        [list transform {{type "filter" config {dimension "Year" value 2012}}}] \
                                        [list transform {{type "filter" config {dimension "Year" value 2013}}}] \
                                    ] \
]

set chart [ticklecharts::chart new]

$chart SetOptions -dataset $dset


$chart Add "pieSeries" -radius 50 -center [list {50% 25%}] -datasetIndex 1 
$chart Add "pieSeries" -radius 50 -center [list {50% 50%}] -datasetIndex 2
$chart Add "pieSeries" -radius 50 -center [list {50% 75%}] -datasetIndex 3


set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename -height 900px