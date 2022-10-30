# Copyright (c) 2022 Nicolas ROBERT.
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

    constructor {args} {
        # Initializes a new dataset Class.
        #
        # args - dataset args.
        #
        set _dimension "nothing"

        if {[llength $args] != 1} {
            error "args should be a list of 1 element for 'dataset' constructor..."
        }

        foreach item {*}$args {

            if {[llength $item] % 2} {
                error "item list must have an even number of elements..."
            }

            setdef options -id                   -validvalue {}                 -type str|null          -default "nothing"
            setdef options -sourceHeader         -validvalue formatSourceHeader -type str|bool|num|null -default "nothing"
            setdef options -dimensions           -validvalue {}                 -type list.j|null       -default [[self] dimensions $item]
            setdef options -source               -validvalue {}                 -type list.d|null       -default [[self] source $item]
            setdef options -transform            -validvalue {}                 -type list.o|null       -default [[self] transform $item]
            setdef options -fromDatasetIndex     -validvalue {}                 -type num|null          -default "nothing"
            setdef options -fromDatasetId        -validvalue {}                 -type str|null          -default "nothing"
            setdef options -fromTransformResult  -validvalue {}                 -type num|null          -default "nothing"

            set item  [dict remove $item -source -transform -dimensions]

            # set dataset...
            lappend opts [merge $options $item]
            set options {}
        }

        set _dataset [list {*}$opts]
    }
}

oo::define ticklecharts::dataset {
    method get {} {
        # Returns dataset
        return $_dataset
    }

    method gettype {} {
        # Returns type
        return "dataset"
    }

    method dim {} {
        # Returns data dim
        return $_dimension
    }

    method dimensions {value} {
        # Set dimension
        #
        # value - dict
        #
        # Returns dimension

        if {![dict exists $value -dimensions]} {
            return "nothing"
        }

        set d {}

        foreach dim [dict get $value -dimensions] {
            if {[ticklecharts::Isdict $dim] && [llength $dim] > 2 && 
               ([dict exists $dim value] || [dict exists $dim name] || [dict exists $dim type])} {

                setdef options name   -validvalue {}            -type str|null  -default "nothing"
                setdef options value  -validvalue {}            -type num|null  -default "nothing"
                setdef options type   -validvalue formatDimType -type str|null  -default "nothing"

                lappend d [list [merge $options $dim] dict] ; continue

            }
            lappend vald [ticklecharts::MapSpaceString $dim]
        }

        if {[llength $d] == 0} {
            set _dimension [list [list $vald list.s]]
        } else {
            set _dimension [join [list [list [list $vald list.s]] $d]]
        }

        return $_dimension
    }

    method transform {value} {
        # Transform dataset
        #
        # value - dict
        #
        # Returns list transform value(s)

        if {![dict exists $value -transform]} {
            return "nothing"
        }

        foreach item [dict get $value -transform] {

            setdef options type   -validvalue formatTransform -type str       -default "filter"
            setdef options config -validvalue {}              -type dict|null -default [ticklecharts::config $item]
            setdef options print  -validvalue {}              -type bool      -default "False"

            # Remove key(s)
            set item [dict remove $item config]

            lappend opts [merge $options $item]
            set options {}

        }

        return [list {*}$opts]

    }

    method source {value} {
        # source dataset
        #
        # value - dict
        #
        # Returns 'source' data value

        if {![dict exists $value -source]} {
            return "nothing"
        }

        return [dict get $value -source]
    }

}