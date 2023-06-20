lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datapieitem' by '-dataPieItem' +
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataPieItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set pie [ticklecharts::chart new]

set data {
          {value 70 name "Apples"}
          {value 68 name "Strawberries"}
          {value 48 name "Bananas"}
          {value 40 name "Oranges"}
          {value 32 name "Pears"}
          {value 27 name "Pineapples"}
          {value 18 name "Grapes"}
        }

$pie SetOptions -title {text "Pie label alignTo" subtext "Fake Data" left "center"} 

$pie Add "pieSeries" -radius "25%" -center [list {50% 50%}] \
                     -label  {position "outer" alignTo "none" bleedMargin 5} \
                     -left 0 -right "66.6667%" -top 0 -bottom 0 \
                     -dataItem $data

$pie Add "pieSeries" -radius "25%" -center [list {50% 50%}] \
                    -label  {position "outer" alignTo "labelLine" bleedMargin 5} \
                    -left "33.3333%" -right "33.3333%" -top 0 -bottom 0 \
                    -dataItem $data

$pie Add "pieSeries" -radius "25%" -center [list {50% 50%}] \
                     -label  {position "outer" alignTo "edge" margin 20 edgeDistance "null"} \
                     -left "66.6667%" -right 0 -top 0 -bottom 0 \
                     -dataItem $data

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$pie Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width "1586px" -height "766px"
