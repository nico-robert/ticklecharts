lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

# Replace Tcl list command by eList class...
#   > $chart Xaxis -data [list {Mon Tue Wed Thu Fri Sat Sun}]        
$chart Xaxis -data [new elist {Mon Tue Wed Thu Fri Sat Sun}]

# getOptions for Xaxis method :
#   > puts [$chart getOptions -axis X]
# Result :
#  -axisLine       -minversion 5  -validvalue {}                  -type dict|null
#    ...
#    symbol          -minversion 5  -validvalue formatItemSymbol -type str|list.s|null -default "null"
#    symbolSize      -minversion 5  -validvalue {}               -type list.n|null     -default "nothing"
#    ...

# Adds 'symbolSyze' property to 'axisLine'.
# 'axisLine.symbolSize' accepts a list of num values (list.n)
#   $chart Xaxis -axisLine [list symbolSize [list {10}]]
#   You should see this error :
#       Error : bad type(set) for this key 'symbolSize'= num should be :list.n|null
#   To avoid this error use 'eList class' like this :
$chart Xaxis -axisLine [list symbolSize [new elist {10}]]
# Json result :
    # ...
    #   "axisLine": {
    #     "show": true,
    #     "onZero": true,
    #     "symbol": null,
    #     // result symbolSize
    #     "symbolSize": [10]
    #   },

$chart Yaxis
# we would have also applied this class here...
$chart Add "lineSeries" -data [list {150 230 224 218 135 147 260}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
