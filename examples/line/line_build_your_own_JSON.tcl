lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

proc generateLineData {} {

    for {set i 0} {$i < 7} {incr i} {
        lappend items [expr {rand() * 500}]
    }

    return [new elist $items]
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# Adds a theme so that you don't have to write 
# the default values for global options. (animation, background etc...)
set chart [ticklecharts::chart new -theme dark]

# Sets a new structure (should be a dict representation)
# Each key must have a corresponding type.
# For 'struct' type, a structure class should exist.
# Note: 
#   'list.dict' (optional argument) allows to generate a JSON schema like 
#    this : mainKey:[{key: value, key1: value1, ...,}]
#    'dict' (default value) generate a JSON schema like 
#    this : mainKey:{key: value, key1: value1, ...,}

# Be careful :
# The type is not checked against what you have 
# specified in the structure.
# By example : if 'type' property is a number 
#              and you have written 'foo' for example. 
#              The JSON output will be : 
#               > {'type': foo} instead of {'type': 'foo'} 

new estruct lineseries1 [subst {
    data:list.n [generateLineData]
    type:str    "line"
    name:str    "myLineStructJSON1"
    smooth:bool "true"
}] list.dict

# Sets a new structure for xAxis and yAxis properties.
new estruct Xaxis {
    data:list.s {{Mon Tue Wed Thu Fri Sat Sun}}
}
new estruct Yaxis {
    type:str "value"
}

# Build the structure to add to JSON schema.
new estruct myStruct_1 [subst {
    title:dict    [ticklecharts::title {-title {text "Build your own JSON!" subtext "with eStruct class:"}}]
    xAxis:struct  $Xaxis
    yAxis:struct  $Yaxis
    series:struct $lineseries1
}]

# Adds the structure to 'AddJSON' method
$chart AddJSON $myStruct_1

# Define a new structure for add a new series
new estruct lineseries2 [subst {
    data:list.n [generateLineData]
    type:str    "line"
    name:str    "myLineStructJSON2"
    smooth:bool "true"
}]

new estruct myStruct_2 [list series:struct $lineseries2]

# Adds the new structure to 'AddJSON' method
$chart AddJSON $myStruct_2

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -title "Magic Structure!" \
              -outfile [file join $dirname $fbasename.html]