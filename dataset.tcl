# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

# From 'Apache echarts documentation' :
# (https://echarts.apache.org/handbook/en/concepts/dataset/) :
#
# 'dataset' is a component dedicated to manage data. Although you can set
# the data in series.data for every series, we recommend you use the 'dataset'
# to manage the data since ECharts 4 so that the data can be reused by multiple 
# components and convenient for the separation of "data and configs". 
# After all, data is the most common part to be changed while other
# configurations will mostly not change at runtime.

oo::class create ticklecharts::dataset {
    variable _dataset
    variable _dimension

    constructor {value} {
        # Initializes a new dataset Class.
        #
        # value - dataset args.
        #
        set _dimension "nothing"

        # https://stackoverflow.com/questions/16131296/the-real-namespace-of-a-class
        set ns [namespace qualifiers [self class]]

        if {![ticklecharts::isListOfList $value]} {
            set value [list $value]
        }

        foreach line [split [lindex [info class constructor [self class]] 1] "\n"] {
            if {[string match {*-minversion [0-9]*} $line]} {
                # Adds minus sign to key to control 
                # Simply to check whether properties with a minus sign are also accepted.
                ${ns}::setdef options -[lindex $line 2] -minversion {} -validvalue {} -type null -default "nothing"
            }
        }

        foreach item $value {

            if {[llength $item] % 2} {
                error "dataset 'item' list must have an even number of elements."
            }

            # Keep compatibility with previous versions.
            # Removes the minus sign at the beginning of the key.
            # Note : Both are accepted, with or without.
            foreach {key info} $item {
                if {[string range $key 0 0] eq "-"} {
                    set item   [dict remove $item $key]
                    set newkey [string range $key 1 end]
                    dict set item $newkey $info
                }
            }

            set source [my source $item sType]

            ${ns}::setdef options id                   -minversion 5  -validvalue {}                 -type str|null          -default "nothing"
            ${ns}::setdef options sourceHeader         -minversion 5  -validvalue formatSourceHeader -type str|bool|num|null -default "nothing"
            ${ns}::setdef options dimensions           -minversion 5  -validvalue {}                 -type list.j|null       -default [my dimensions $item]
            ${ns}::setdef options source               -minversion 5  -validvalue {}                 -type list.$sType|null  -default $source
            ${ns}::setdef options transform            -minversion 5  -validvalue {}                 -type list.o|null       -default [my transform $item]
            ${ns}::setdef options fromDatasetIndex     -minversion 5  -validvalue {}                 -type num|null          -default "nothing"
            ${ns}::setdef options fromDatasetId        -minversion 5  -validvalue {}                 -type str|null          -default "nothing"
            ${ns}::setdef options fromTransformResult  -minversion 5  -validvalue {}                 -type num|null          -default "nothing"

            if {$sType eq "o"} {
                set item [dict remove $item transform dimensions source]
            } else {
                set item [dict remove $item transform dimensions]
            }

            # Set dataset.
            lappend opts [${ns}::merge $options $item]
            set options {}
        }

        set _dataset [list {*}$opts]
    }
}

oo::define ticklecharts::dataset {
    method get {} {
        # Returns dataset.
        return $_dataset
    }

    method getType {} {
        # Returns type.
        return "dataset"
    }

    method dim {} {
        # Returns data dimensions.
        return $_dimension
    }

    method dimensions {value} {
        # Set dimension.
        #
        # value - dict
        #
        # Returns dimension

        if {![ticklecharts::keyDictExists "dimensions" $value key]} {
            return "nothing"
        }

        set ns [namespace qualifiers [self class]]
        ticklecharts::ldset {d vald} -to ""
        
        # Note : The 'dim' variable can contain, a structure from the eStruct class, a dictionary 
        # from the eDict class, a simple string value or pure Tcl dictionary.
        foreach dim [dict get $value $key] {
            if {
                [ticklecharts::iseDictClass $dim] || ([ticklecharts::isDict $dim] && 
                ([dict exists $dim value] || [dict exists $dim name] || [dict exists $dim type]))
            } {
                if {[ticklecharts::iseDictClass $dim]} {set dim [$dim get]}

                ${ns}::setdef options name   -minversion 5  -validvalue {}            -type str|null  -default "nothing"
                ${ns}::setdef options value  -minversion 5  -validvalue {}            -type num|null  -default "nothing"
                ${ns}::setdef options type   -minversion 5  -validvalue formatDimType -type str|null  -default "nothing"

                lappend d [list [new edict [${ns}::merge $options $dim]] dict]

            } elseif {[ticklecharts::iseStructClass $dim]} {
                lappend d [list $dim [$dim sType]]
            } else {
                lappend vald [ticklecharts::mapSpaceString $dim]
            }
        }

        if {![llength $d]} {
            set _dimension [list [list $vald list.s]]
        } else {
            set _dimension [join [list [list [list $vald list.s]] $d]]
        }

        return $_dimension
    }

    method transform {value} {
        # Transform dataset.
        #
        # value - dict
        #
        # Returns list transform value(s)

        if {![ticklecharts::keyDictExists "transform" $value key]} {
            return "nothing"
        }

        set ns [namespace qualifiers [self class]]

        foreach item [dict get $value $key] {

            if {[llength $item] % 2} {
                error "transform 'item' list must have an even number of elements."
            }

            ${ns}::setdef options type   -minversion 5  -validvalue formatTransform -type str       -default "filter"
            ${ns}::setdef options config -minversion 5  -validvalue {}              -type dict|null -default [ticklecharts::config $item]
            ${ns}::setdef options print  -minversion 5  -validvalue {}              -type bool      -default "False"

            # Remove key(s)
            set item [dict remove $item config]

            lappend opts [${ns}::merge $options $item]
            set options {}

        }

        return [list {*}$opts]
    }

    method source {value t} {
        # Source dataset.
        #
        # value - dict
        # t     - upvar type
        #
        # Returns 'source' data value
        upvar 1 $t type
        set type "d"

        if {![ticklecharts::keyDictExists "source" $value key]} {
            return "nothing"
        }

        # 'source' support 2 types :
        # 1) 2d array, where dimension names can be provided in the first row/column,
        #       or do not provide, only data. :
        #       set source {
        #           {"score" "amount" "product"}
        #           {89.3 58212 "Matcha Latte"}
        #           {57.1 78254 "Milk Tea"}
        #           {74.4 41032 "Cheese Cocoa"}
        #           {50.1 12755 "Cheese Brownie"}
        #           {...}
        #       }
        # 2) "array of classes" format ('source' should be a 'elist class'): 
        #       Define the dimension of array. In cartesian coordinate system,
        #       if the type of x-axis is category, map the first dimension to
        #       x-axis by default, the second dimension to y-axis.
        #       You can also specify 'series.encode' to complete the map
        #       without specify dimensions. Please see below.
        #       set source {
        #           {product "Matcha Latte" "2015" 43.3 "2016" 85.8 "2017" 93.7}
        #           {product "Milk Tea" "2015" 83.1 "2016" 73.4 "2017" 55.1}
        #           {product "Cheese Cocoa" "2015" 86.4 "2016" 65.2 "2017" 82.5}
        #           {...}
        #       }

        set d  [dict get $value $key]
        set ns [namespace qualifiers [self class]]

        if {[ticklecharts::iseListClass $d]} {
            if {![ticklecharts::isListOfList {*}[$d get]]} {
                error "'source' should be a list of list."
            }
            foreach item {*}[$d get] {
                if {[llength $item] % 2} {
                    error "source 'item' list must have an even number of elements."
                }
                set k {}
                foreach {key info} $item {
                    if {[llength [lsearch -all -exact $item $key]] > 1} {
                        error "'$key' is duplicated in '$item'"
                    }

                    # Replaces spaces if present.
                    set mapKey [ticklecharts::mapSpaceString $key]
                    lappend k $key $mapKey 

                    set mytype [ticklecharts::typeOf $info]

                    if {$mytype ni {str num}} {
                        error "'$info' should be a string or num for this '$key' value."
                    }

                    ${ns}::setdef options $mapKey -minversion 5 -validvalue {} -type $mytype -default $info
                }

                lappend opts [${ns}::merge $options [string map $k $item]]
                set options {}
            }

            set type "o"
            return [list {*}$opts]

        } else {
            if {![ticklecharts::isListOfList $d]} {
                error "'source' should be a list of list."
            }
            return $d
        }
    }
}

proc ticklecharts::isdatasetClass {value} {
    # Check if the value is a 'dataset' class.
    #
    # value - obj or string
    #
    # Returns true if 'value' is a dataset class,
    # false otherwise.
    return [expr {
            [ticklecharts::isAObject $value] && 
            [string match "*::dataset" [ticklecharts::typeOfClass $value]]
        }
    ]
}