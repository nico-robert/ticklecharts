lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

proc generateLineData {} {

    for {set i 0} {$i < 7} {incr i} {
        lappend items [expr {rand() * 500}]
    }

    # The type should be specified when
    # the return value is a list or a string.
    # To do this, use 'eString' or 'eList' classes.
    return [new elist.n $items]
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# Adds a theme so that you don't have to write 
# the default values for global options. (animation, background etc...)
set chart [ticklecharts::chart new -theme dark]

# Init a new structure (should be a dict representation)
# Each key must have a corresponding type.
# Below the list :
# {str num str.e null bool list.n list.s struct proc}
# For 'proc' and 'struct' a command or sructure should exist.
# Note: 
#   'generateLineData' is the name of procedure.
#   'list.dict' (optional argument) allows to generate a JSON schema like 
#    this : mainKey:[{key: value, key1: value1, ...,}]
new estruct my_Lineseries1 {
    data   proc.generateLineData
    type   str
    name   str
    smooth bool
} list.dict

# Init a new structure for xAxis and yAxis properties.
new estruct my_Xaxis {
    data list.s
}
new estruct my_Yaxis {
    type str
}

# Build the structure to add to JSON schema.
# You can reuse a command from the ticklecharts package (global_options.tcl)
new estruct myStruct_1 {
    title  proc.ticklecharts::title
    xAxis  struct.my_Xaxis
    yAxis  struct.my_Yaxis
    series struct.my_Lineseries1
}

# Sets properties for each keys:
# Be careful :
# The type is not checked against what you have 
# specified in the structure.
# By example : if 'type' property is a number 
#              and you have written 'foo' for example. 
#              The JSON output will be : 
#               > {'type': foo} instead of {'type': 'foo'} 
$my_Xaxis setdef {data {{Mon Tue Wed Thu Fri Sat Sun}}}
$my_Yaxis setdef {type "value"}

# Sets properties for 'my_Lineseries1' structure:
# Note : 'data' property type is an command without argument(s) 
#          > proc generateLineData {} {...}
#          To avoid the error of incorrect numbers of arguments 
#          in the structure definition, the value must be an empty string.
$my_Lineseries1 setdef [list type "line" name "myLineStructJSON1" data {} smooth true]

# Sets properties for each keys:
$myStruct_1 setdef [subst {
        title  {-title {text "Build your own JSON!" subtext "with eStruct class:"}}
        xAxis  $my_Xaxis
        yAxis  $my_Yaxis 
        series $my_Lineseries1
    }
]

# Adds the structure to 'AddJSON' method
$chart AddJSON $myStruct_1

# Define a new structure for add a new series
# It would have been possible to reuse the first structure series.
new estruct my_Lineseries2 {
    data   proc.generateLineData
    type   str
    name   str
    smooth bool
} list.dict

$my_Lineseries2 setdef [list type "line" name "myLineStructJSON2" data {} smooth true]

new estruct myStruct_2 {
    series struct.my_Lineseries2
}

$myStruct_2 setdef [list series $my_Lineseries2]

# Adds the new structure to 'AddJSON' method
$chart AddJSON $myStruct_2

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -title "Magic Structure!" \
              -outfile [file join $dirname $fbasename.html]