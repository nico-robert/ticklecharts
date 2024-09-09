# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {
    namespace ensemble create -command ::new -subcommands {
        elist elist.n elist.s elist.o elist.d edict estr estruct
    }
}

oo::class create ticklecharts::eList {
    variable _elist
    variable _type

    constructor {value type} {
        # Initializes a new eList Class.
        #
        if {$type eq "elist.o"} {
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
    # example :
    # new elist.n {1 2 3 4 5}
    # new elist.s {1 2 3 4 5} > force JSON string values ["1", "2", "3", ...].
    #
    # Returns a eList object.
    proc ticklecharts::${ptype} {args} [string map [list %tlist% $ptype] {
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
            # In case there are two dots in the key name.
            set key  [string trim $key]
            set sk   [split $key ":"]
            set type [lindex $sk end]
            set len  [expr {[string length $type] + 1}]
            set k    [string range $key 0 end-$len]
            # In case there are spaces in the key.
            set k [ticklecharts::mapSpaceString $k]

            if {
                ($type eq "") || $type ni {
                    elist.d elist.o elist.n elist.s
                    str num str.e null bool list.n struct
                    list.s e.color jsfunc list.d dict
                }
            } {
                error "wrong # args: 'type' should be a struct,\
                       str, num, str.e, bool, list.n, list.s,\
                       elist.d, elist.o, elist.n, elist.s,\
                       e.color, jsfunc, list.d, dict or null type\
                       instead of '$type'."
            }

            switch -exact -- $type {
                struct {
                    if {![ticklecharts::iseStructClass $info]} {
                        error "wrong # args: Should be a 'eStruct'\
                               class if type '$type' is specified\
                               for '$k' property in struct '$name'."
                    }
                    set type [$info sType]
                }
                dict {
                    if {![ticklecharts::iseDictClass $info]} {
                        error "wrong # args: Should be a 'eDict'\
                               class if type 'dict' is specified."
                    }
                }
                elist.d - elist.o - elist.n - elist.s {
                    if {![ticklecharts::iseListClass $info]} {
                        error "wrong # args: Should be a 'eList'\
                               class if type '$type' is specified\
                               for '$k' property in struct '$name'."
                    }
                    set mylType [$info lType]
                    if {$mylType ne $type} {
                        error "Type in structure for 'eList' class doesn't\
                               match with '$type' subtype for '$k' property\
                               in struct '$name'."
                    }
                    if {$mylType eq "elist.o"} {set info [$info get]}
                }
                list.d - list.o - list.n - list.s {
                    if {![ticklecharts::isListOfList $info]} {
                        error "'$type' should be a list of list\
                                for '$k' property in struct '$name'."
                    }
                }
                str.e {
                    if {![ticklecharts::iseStringClass $info]} {
                        error "wrong # args: Should be a 'eString'\
                               class if type 'str.e' is specified\
                               for '$k' property in struct '$name'."
                    }
                }
                jsfunc {
                    if {[ticklecharts::typeOf $info] ne "jsfunc"} {
                        error "wrong # args: Should be a 'jsfunc'\
                               class if type 'jsfunc' is specified\
                               for '$k' property in struct '$name'."
                    }
                }
                e.color {
                    if {[ticklecharts::typeOf $info] ne "e.color"} {
                        error "wrong # args: Should be a 'e.color'\
                               class if type 'e.color' is specified\
                               for '$k' property in struct '$name'."
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

    method structHuddle {} {
        # Returns huddle object.
        set opts   [ticklecharts::optsToEchartsHuddle [my get]]
        set h      [ticklecharts::ehuddle new]
        set huddle [$h set {*}$opts]
        $h destroy

        # huddle object
        switch -exact -- [my sType] {
            struct.d  {set hobj [lindex [huddle create {*}$huddle] 1]}
            struct.ld {set hobj [lindex [huddle list [huddle create {*}$huddle]] 1]}
            default   {error "'[my sType]' not supported for '[self method]'"}
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