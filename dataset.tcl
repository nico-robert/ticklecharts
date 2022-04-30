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
    variable _transform
    variable _dimension

    constructor {args} {
        # Initializes a new dataset Class.
        #
        # args - dataset args.
        #
        if {![dict exists $args -source]} {
            error "'-source' shoud be specified... for dataset"
        }

        set _transform "nothing"
        set _dimension "nothing"

        setdef options -id                   -validvalue {}                 -type str|null          -default "nothing"
        setdef options -sourceHeader         -validvalue formatSourceHeader -type str|bool|num|null -default "nothing"
        setdef options -dimensions           -validvalue {}                 -type list.j|null       -default [my dimensions $args]
        setdef options -source               -validvalue {}                 -type list.d            -default [my setSource $args]
        setdef options -transform            -validvalue {}                 -type dict|null         -default [my transform $args]
        setdef options -fromDatasetIndex     -validvalue {}                 -type num|null          -default "nothing"
        setdef options -fromDatasetId        -validvalue {}                 -type str|null          -default "nothing"
        setdef options -fromTransformResult  -validvalue {}                 -type num|null          -default "nothing"

        set d       [dict remove $args -source -transform -dimensions]
        set options [dict remove $options -transform]

        # set dataset...
        set _dataset [merge $options $d]

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

    method transformed {} {
        # Returns data transformed
        return $_transform
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
            if {[ticklecharts::Isdict $dim] && [llength $dim] > 2} {

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
        # Returns nothing

        if {![dict exists $value -transform]} {
            return
        }

        foreach item [dict get $value -transform] {

            setdef options type   -validvalue formatTransform -type str       -default "filter"
            setdef options config -validvalue {}              -type dict|null -default [ticklecharts::config $item]
            setdef options print  -validvalue {}              -type bool      -default "False"

            lappend opts [list -transform [list [merge $options $item] dict]]
            
            set options {}

        }

        set _transform $opts

        return

    }

    method setSource {value} {
        # source dataset
        #
        # value - dict
        #
        # Returns source

        if {![dict exists $value -source]} {
            error "'-source' should be specified..."
        }

        return [dict get $value -source]
    }
}

