# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.

oo::class create ticklecharts::jsfunc {
    variable _jsfunc
    variable _type

    constructor {args} {
        # Initializes a new jsfunc Class.
        # Add comma at the end if not present.
        #
        # args - Options described below.
        #
        # javascript function
        #
        set _type "jsfunc"
        set jsf [string trim [join $args]]

        if {[string range $jsf end end] ne ","} {
            set jsf [string cat $jsf ","]
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
        return $_type
    }

}