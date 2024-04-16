# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {
    namespace eval ::new {
        namespace ensemble create -map {
            elist   ::ticklecharts::elist   elist.n ::ticklecharts::elist.n
            elist.s ::ticklecharts::elist.s elist.o ::ticklecharts::elist.o
            elist.d ::ticklecharts::elist.d edict   ::ticklecharts::edict
            estr    ::ticklecharts::estr    estruct ::ticklecharts::estruct
        }
    }
}

oo::class create ticklecharts::eList {
    variable _elist
    variable _type

    constructor {value type} {
        # Initializes a new eList Class.
        #
        if {$type eq "list.o"} {
            set re {\s(bool|str|num|dict|list\.[nse]|null|jsfunc|e\.color|str\.e)$}
            foreach val $value {
                if {[llength $val] % 2} ticklecharts::errorEvenArgs
                set match [lsearch -all -regexp $val $re]
                if {($match eq "") || ([llength $match] != ([llength $val] / 2))} {
                    error "'list.o' should be a typed list."
                }
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
    #   - list.o ({key1 {value 'type'} key2 {...}})
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
        error "wrong # args: Should be a dict\
               representation."
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
    variable _options
    variable _stype
    variable _varname

    constructor {name value stype} {
        # Initializes a new eStruct Class.
        #
        set _options {}
        set _stype $stype
        set _varname $name

        foreach {key info} $value {
            lassign [split $key ":"] k type

            if {
                ($type eq "") || $type ni {
                str num str.e null bool list.n struct
                list.s e.color jsfunc list.d dict list.o}
            } {
                error "wrong # args: 'type' should be a struct,\
                       str, num, str.e, bool, list.n, list.s,\
                       e.color, jsfunc, list.d, list.o, dict or null type\
                       instead of '$type'."
            }

            switch -exact -- $type {
                struct {
                    if {![ticklecharts::iseStructClass $info]} {
                        error "wrong # args: Should be a 'eStruct'\
                               class if type 'struct' is specified."
                    }

                    set type [$info sType]
                }
                dict {
                    if {![ticklecharts::iseDictClass $info]} {
                        error "wrong # args: Should be a 'eDict'\
                               class if type 'dict' is specified."
                    }
                }
                list.d - list.n - list.s - list.o {
                    if {[ticklecharts::iseListClass $info]} {
                        set mylType [$info lType]
                        if {$mylType ne $type} {
                            error "type for 'eList' class doesn't\
                                   match with '$key' type"
                        }
                        if {$mylType eq "list.o"} {set info [$info get]}
                    }
                }
                str.e {
                    if {![ticklecharts::iseStringClass $info]} {
                        error "wrong # args: Should be a 'eString'\
                               class if type 'str.e' is specified."
                    }
                }
                jsfunc {
                    if {[ticklecharts::typeOf $info] ne "jsfunc"} {
                        error "wrong # args: Should be a 'jsfunc'\
                               class if type 'jsfunc' is specified."
                    }
                }
                e.color {
                    if {[ticklecharts::typeOf $info] ne "e.color"} {
                        error "wrong # args: Should be a 'e.color'\
                               class if type 'e.color' is specified."
                    }
                }
                str {
                    # Replaces spaces by special characters.
                    set info [ticklecharts::mapSpaceString $info]
                    if {$info eq ""} {
                        # To avoid the incorrect number of arguments
                        # error for the ehuddle class.
                        set info "{}"
                    }
                }
            }
            lappend _options $k [list $info $type]
        }
    }
}

oo::define ticklecharts::eStruct {
    method getType {} {
        # Returns type.
        return "eStruct"
    }

    method name {} {
        # Returns name's structure.
        return $_varname
    }

    method get {} {
        # Returns dict options.

        if {![llength $_options]} {
            error "The dictionary struct '[my name]' options are empty."
        }
        return $_options
    }

    method sType {} {
        # Returns the structure type.
        return $_stype
    }

    method toHuddle {} {
        # Returns huddle object.
        set opts   [ticklecharts::optsToEchartsHuddle [my get]]
        set h      [ticklecharts::ehuddle new]
        set huddle [$h set {*}$opts]
        $h destroy

        # huddle object
        switch -exact -- [my sType] {
            struct.d  {set hobj [lindex [huddle create {*}$huddle] 1]}
            struct.ld {set hobj [lindex [huddle list [huddle create {*}$huddle]] 1]}
            default   {error "'[my sType]' not supported [self method]"}
        }

        return $hobj
    }
}

proc ticklecharts::estruct {name value {type "struct.d"}} {
    # Build eStruct class.
    # 
    # name  - var name
    # value - dict tcl
    # type  - struct type
    #
    #
    # Returns nothing.
    if {![ticklecharts::isDict $value]} {
        error "wrong # args: Should be a dict\
               representation."
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