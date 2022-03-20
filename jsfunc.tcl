# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

oo::class create ticklecharts::jsfunc {
    variable _jsfunc

    constructor {args} {
        # Initializes a new jsfunc Class.
        #
        # args - javascript function.
        #
        # javascript function
        #
        set jsf [string trim [join $args]]

        # delete comma at the end if exists...
        # since I added jsfunc as huddle type 
        if {[string range $jsf end end] eq ","} {
            set jsf [string range $jsf 0 end-1]
        }

        set _jsfunc [list $jsf]

    }
}

oo::define ticklecharts::jsfunc {
    method get {} {
        # Returns js list
        return $_jsfunc
    }
    
    method gettype {} {
        # Returns type
        return "jsfunc"
    }

}