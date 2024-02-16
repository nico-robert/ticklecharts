# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {
    namespace ensemble create -command ::new
    namespace export elist elist.n elist.s edict estr
}

oo::class create ticklecharts::eList {
    variable _elist
    variable _type

    constructor {value type} {
        # Initializes a new eList Class.
        #
        set _elist $value
        set _type  $type
    }
}

oo::define ticklecharts::eList {
    method get {} {
        # Returns list
        return $_elist
    }

    method getType {} {
        # Returns class type
        return "eList"
    }

    method lType {} {
        # Returns type list
        return $_type
    }
}

foreach ptype {elist elist.n elist.s} {
    # This procedure substitutes a pure Tcl list.
    # It can replace these list types :
    #   - list.s (list string)
    #   - list.n (list integer)
    #   - list.d (list integer || string or both)
    # 
    # args - list tcl
    #
    # example :
    # new elist {1 2 3 4 5}
    # new elist {1 "a" 2 "b"}
    # new elist {"a" "b" "c"}
    # new elist {"a" "b"} {1 2}
    #
    # Note : 
    # It is also possible to force the list type, 
    # which replaces the list.d type and avoids 
    # checking all the values in the list. 
    # This is useful for improving performance 
    # when we are certain of the type to be integrated. 
    #
    # Returns a eList object.
    set tlist [string map {e ""} $ptype]
    proc ticklecharts::${ptype} {args} [string map [list %tlist% $tlist] {
            return [ticklecharts::eList new $args %tlist%]
        }
    ]
}

proc ticklecharts::iseListClass {value} {
    # Check if value is eList class.
    #
    # value - obj or string
    #
    # Returns true if 'value' is a eList class, 
    # false otherwise.
    return [expr {
            [string match {::oo::Obj[0-9]*} $value] && 
            [string match "*::eList" [ticklecharts::typeOfClass $value]]
        }
    ]
}

oo::class create ticklecharts::eDict {
    variable _edict

    constructor {d} {
        # Initializes a new eList Class.
        #
        set _edict $d
    }
}

oo::define ticklecharts::eDict {
    method get {} {
        # Returns dict
        return $_edict
    }

    method getType {} {
        # Returns type
        return "eDict"
    }
}

proc ticklecharts::edict {value} {
    # This procedure substitutes a pure Tcl dict.
    # 
    # value - dict tcl
    #
    # example :
    # new edict {key value key1 value1 ...}
    #
    # Returns a eDict object.

    if {![ticklecharts::isDict $value]} {
        error "should be a dict representation..."
    }

    return [ticklecharts::eDict new $value]
}

proc ticklecharts::iseDictClass {value} {
    # Check if value is eDict class.
    #
    # value - obj or string
    #
    # Returns true if 'value' is a eDict class, 
    # false otherwise.
    return [expr {
            [string match {::oo::Obj[0-9]*} $value] && 
            [string match "*::eDict" [ticklecharts::typeOfClass $value]]
        }
    ]
}

oo::class create ticklecharts::eString {
    variable _estring

    constructor {str} {
        # Initializes a new eString Class.
        #
        set _estring $str
    }
}

oo::define ticklecharts::eString {
    method get {} {
        # Returns string
        return $_estring
    }

    method getType {} {
        # Returns type
        return "eString"
    }
}

proc ticklecharts::estr {str} {
    # This procedure substitutes a pure Tcl string.
    # 
    # str - string
    #
    # Returns a eString object.
    return [ticklecharts::eString new $str]
}

proc ticklecharts::iseStringClass {value} {
    # Check if value is eString class.
    #
    # value - obj or string
    #
    # Returns true if 'value' is a eString class, 
    # false otherwise.
    return [expr {
            [string match {::oo::Obj[0-9]*} $value] && 
            [string match "*::eString" [ticklecharts::typeOfClass $value]]
        }
    ]
}