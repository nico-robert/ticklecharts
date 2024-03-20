# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {
    namespace ensemble create -command ::new
    namespace export elist elist.n elist.s elist.o elist.d edict estr estruct
}

oo::class create ticklecharts::eList {
    variable _elist
    variable _type

    constructor {value type} {
        # Initializes a new eList Class.
        #
        if {$type eq "list.o"} {
            set re {bool|str|num|dict|list.n|null|jsfunc|e.color|list.s}
            if {[lsearch -regexp -index 1 $value $re] < 0} {
                error "'list.o' should be a typed list."
            }
        }

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

foreach ptype {elist elist.n elist.s elist.o elist.d} {
    # This procedure substitutes a pure Tcl list.
    # It can replace these list types :
    #   - list.s (list string)
    #   - list.n (list integer)
    #   - list.d (list integer || string or both)
    #   - list.o ({list of list})
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

oo::class create ticklecharts::eStruct {
    variable _estruct
    variable _options
    variable _stype
    variable _varname

    constructor {name value stype} {
        # Initializes a new eStruct Class.
        #
        set _options {}
        set _stype $stype
        set _varname $name

        set _estruct $value

        foreach {key type} $_estruct {

            if {$type in {
                str num str.e null bool list.n
                list.s e.color jsfunc list.e list.d
            }} {
                continue
            }

            if {[string match {proc.*} $type] } {
                set cmd [string map {proc. ""} $type]

                if {[string range $cmd 0 1] ne "::"} {
                    set cmd ::$cmd
                }

                if {[info procs $cmd] eq ""} {
                    error "'$cmd' command should exist."
                }
                dict set _estruct $key $cmd
                continue
            }

            if {[string match {struct.*} $type] } {
                set struct [string map {struct. ""} $type]
                upvar 2 $struct obj
                if {![info exists obj] || ![ticklecharts::iseStructClass $obj]} {
                    error "'$struct' structure should exist."
                }

                dict set _estruct $key $obj
                continue
            }
            error "'$type' should be a 'eStruct' class, str, num,\
                   str.e, bool, list.n, list.s, e.color, jsfunc,\
                   list.e, list.d, procedure or null type"
        }
    }
}

oo::define ticklecharts::eStruct {
    method getType {} {
        # Returns type.
        return "eStruct"
    }

    method struct {} {
        # Returns the dict struct.
        return $_estruct
    }

    method name {} {
        # Returns name's struct.
        return $_varname
    }

    method get {} {
        # Returns dict options.

        if {![dict size $_options]} {
            error "The dictionary struct '[my name]'\
                   options are empty."
        }
        return $_options
    }

    method sType {} {
        # Returns struct type.
        return $_stype
    }

    method toHuddle {} {
        # Returns options in huddle format.

        set opts   [ticklecharts::optsToEchartsHuddle [my get]]
        set h      [ticklecharts::ehuddle new]
        set huddle [$h set {*}$opts]
        $h destroy

        # huddle object
        switch -exact -- [my sType] {
            dict      {set hobj [lindex [huddle create {*}$huddle] 1]}
            list.dict {set hobj [lindex [huddle list [huddle create {*}$huddle]] 1]}
            default   {error "'[my sType]' not supported"}
        }

        return $hobj
    }

    method setdef {value} {
        # Sets dict struct value.
        #
        # value - dict value
        #
        # Returns nothing.

        if {[llength $value] % 2} {
            error "wrong # args: item list for '[self method]'\
                   method must have an even number of elements."
        }

        foreach {key info} $value {

            if {![dict exists [my struct] $key]} {
                error "'$key' key not present in struct '[my name]' keys:\
                       '[join [dict keys [my struct]] ", "]'"
            }

            if {[ticklecharts::iseStructClass $info]} {

                if {[dict get [my struct] $key] ne $info} {
                    error "struct obj doesn't match with 'base' structure"
                }

                set type [$info sType]
                set info [new edict [$info get]]

            } elseif {[info procs [dict get [my struct] $key]] ne ""} {

                if {$info eq ""} {
                    # no arguments
                    set info [[dict get [my struct] $key]]
                } else {
                    set info [[dict get [my struct] $key] $info]
                }

                set t [ticklecharts::typeOf $info]
                if {$t eq "list.e"} {
                    set type [$info lType]
                    set info [$info get]
                } else {
                    set type $t
                }

            } else {
                set type [dict get [my struct] $key]
            }

            # dict info : value type validvalue minversion versionLib trace.
            dict set _options $key [list $info $type {} {} {} no]
        }

        return {}
    }
}

proc ticklecharts::estruct {name value {type "dict"}} {
    # Build eStruct class.
    # 
    # name  - var name
    # value - dict tcl
    # type  - struct type
    #
    #
    # Returns nothing.

    if {![ticklecharts::isDict $value]} {
        error "should be a dict representation..."
    }

    upvar 1 $name obj

    set obj [ticklecharts::eStruct new $name $value $type]

    return {}
}

proc ticklecharts::iseStructClass {value} {
    # Check if value is a eStruct class.
    #
    # value - obj or string
    #
    # Returns true if 'value' is a eStruct class, 
    # false otherwise.
    return [expr {
            [string match {::oo::Obj[0-9]*} $value] && 
            [string match "*::eStruct" [ticklecharts::typeOfClass $value]]
        }
    ]
}