# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {
    namespace export setdef merge Type InfoNameProc EchartsOptsTheme
}

proc ticklecharts::htmlmap {htmloptions} {
    # Html options.
    #
    # htmloptions  - Options described below.
    #
    # -width      - size chart
    # -height     - size chart
    # -renderer   - 'canvas' or 'svg'
    # -jschartvar - name js variable chart
    # -divid      - name id div html
    # -title      - title html
    # -jsecharts  - script echarts
    # -jsvar      - name variable js
    #
    # Returns list map html

    lappend mapoptions [format {%%width%% %s}      [lrange [dict get $htmloptions -width]  0 end-1]]
    lappend mapoptions [format {%%height%% %s}     [lrange [dict get $htmloptions -height] 0 end-1]]
    lappend mapoptions [format {%%renderer%% %s}   [lrange [dict get $htmloptions -renderer] 0 end-1]]
    lappend mapoptions [format {%%jsecharts%% %s}  [lrange [dict get $htmloptions -jsecharts]  0 end-1]]
    lappend mapoptions [format {%%jschartvar%% %s} [lrange [dict get $htmloptions -jschartvar]  0 end-1]]
    lappend mapoptions [format {%%divid%% %s}      [lrange [dict get $htmloptions -divid]  0 end-1]]
    lappend mapoptions [format {%%title%% %s}      [lrange [dict get $htmloptions -title]  0 end-1]]
    lappend mapoptions [format {%%jsvar%% %s}      [lrange [dict get $htmloptions -jsvar]  0 end-1]]

    set html [ticklecharts::readhtmltemplate]
    return [string map [join $mapoptions] $html]

}


proc ticklecharts::readhtmltemplate {} {
    # Open and read html template
    #
    # Returns html file list

    set fp [open $::ticklecharts::htmltemplate r]
    set html [read $fp]
    close $fp
    
    return $html
}


proc ticklecharts::HuddleType {type} {
    # Transform dict type to huddle echarts type
    #
    # type  - dict options type.
    #
    # Returns huddle echarts type

    switch -exact -- $type {
        str    {set htype @S}
        num    {set htype @N}
        bool   {set htype @B}
        list.s {set htype @LS}
        list.n {set htype @LN}
        list.d {set htype @LD}
        list.j {set htype @LJ}
        null   {set htype @NULL}
        dict   {set htype @L}
        list.o {set htype @DO}
        dict.o {set htype @LO}
        jsfunc {set htype @JS}
        default {error "no type for '$type'"}
    }

    return $htype
}

proc ticklecharts::TypeClass {obj} {
    # Name of class
    #
    # obj  - Instance.
    #
    # Returns name of class or nothing.

    return [info object class $obj]
}

proc ticklecharts::IsaObject {obj} {
    # Check if variable 'obj' is an object
    #
    # obj  - Instance.
    #
    # Returns True or False.

    return [info object isa object $obj]
}

proc ticklecharts::TclType value {
    # Guess the type of the value (2nd time...)
    # 
    # value - string (everything is string !!!)
    #
    # Returns type of value

    if {$value eq "nothing" || $value eq "null"} {
        return null
    }
    
    if {[string is integer -strict $value]} {
        return num
    }

    if {[string is double -strict $value]} {
        return num
    }    

    if {[string is boolean -strict $value]} {
        return bool
    }

    if {([string first "\{" $value] > -1) && ([string last "\}" $value] > -1) && [llength $value] > 1} {
        return list
    }

    if {[ticklecharts::IsaObject $value] && [$value gettype] eq "jsfunc"} {
        return jsfunc
    }

    return str
}

proc ticklecharts::IsList value {
    # Guess if value is a list (again and again !!)
    # 
    # value - string (everything is string !!!)
    #
    # Returns type of value
    
    if {![catch {llength {*}$value}] && [llength {*}$value] > 1} {
        return list
    } else {
        return [ticklecharts::TclType $value]
    }

}

proc ticklecharts::Type value {
    # Guess the type of the value (1st time if ticklecharts::TclType is string)
    # from https://rosettacode.org/wiki/JSON#Tcl
    # not the best way !!
    # Controls only 2 types dict or list
    # 
    # value - string (everything is string !!!)
    #
    # Returns type of value
    
    regexp {^value is a (.*?) with a refcount} \
    [::tcl::unsupported::representation $value] -> type
    
    switch $type {
        dict {
            return dict
        }
        list {
            return [ticklecharts::IsList $value]
        }
        default {
            return [ticklecharts::TclType $value]
        }
    }
}

proc ticklecharts::optsToEchartsHuddle {options} {
    # Transform a dict to echartshuddle format...
    # Level one
    # 
    # options - dict options
    #
    # Returns list (echartshuddle)
    
    set opts {}

    dict for {key info} $options {
        lassign $info value type
        
        set key   [string map {- ""} $key]
        set htype [ticklecharts::HuddleType $type]

        switch -exact -- $type {
            dict -
            dict.o {
                append opts [format " ${htype}=$key {%s}" [ticklecharts::dictToEchartsHuddle $value]]
            }
            list.o {
                set l {}
                foreach val $value {
                    lappend l [ticklecharts::dictToEchartsHuddle $val]
                }
                append opts [format " ${htype}=$key {%s}" [list @AO $l]]
            }
            list.s {
                append opts [format " ${htype}=$key {%s}" $value]
            }
            list.j {
                set l {}
                foreach val $value {
                    lappend l [ticklecharts::dictToEchartsHuddle [dict create $key $val]]
                }
                append opts [format " ${htype}=$key {%s}" [list $l]]
            }
            default {
                append opts [format " ${htype}=$key {%s}" [list $value]]
            }
        }
    }
    
    return $opts
}

proc ticklecharts::dictToEchartsHuddle {options} {
    # Transform a dict to echartshuddle format...
    # Level two
    # 
    # options - dict options
    #
    # Returns list (echartshuddle)

    set d [dict create {*}$options]
    set opts {}
    
    dict for {subkey subinfo} $options {
        lassign $subinfo svalue type
        
        set htype [ticklecharts::HuddleType $type]
       
        switch -exact -- $type {
            dict {
                append opts [format " ${htype}=$subkey %s" [list [ticklecharts::dictToEchartsHuddle $svalue]]]
            }
            dict.o {
                append opts [format " ${htype}=$subkey {%s}" [list [ticklecharts::dictToEchartsHuddle $svalue]]]
            }
            list.s {
                append opts [format " ${htype}=$subkey {%s}" $svalue]
            }
            list.d -
            list.n {
                append opts [format " ${htype}=$subkey {{%s}}" $svalue]
            }
            list.o {
                set l {}
                foreach val $svalue {
                    if {[lindex $val end] eq "list.o"} {
                        set tt {}
                        foreach vv [join [lrange $val 0 end-1]] {
                            lappend tt [ticklecharts::dictToEchartsHuddle $vv]
                        }
                        lappend l [list @D $tt]
                        continue
                    }
                    
                    lappend l [ticklecharts::dictToEchartsHuddle $val]
                }
                append opts [format " ${htype}=$subkey {%s}" [list @AO $l]]
            }
            default {
                append opts [format " ${htype}=$subkey %s" $svalue]
            }
        }
        
    }

    return $opts
}

proc ticklecharts::setdef {d key args} {
    # Set dict definition with value type and default value
    # An error exception is raised if args value is not found
    # 
    # d    - dict
    # key  - dict key
    # args - type + default value
    #
    # Returns dictionary

    upvar 1 $d dictionary

    foreach {k value} $args {
        switch -exact -- $k {
            "-validvalue" {set validvalue $value}
            "-type"       {set type       $value}
            "-default"    {set default    $value}
            default       {error "Unknown key '$k' specified"}
            }
    }

    dict set dictionary $key [list $default $type $validvalue]
}

proc ticklecharts::MatchType {mytype type keyt} {
    # Guess type follow optional list
    # 
    # mytype - type
    # type   - list default type
    # keyt   - upvar key type 
    #
    # Returns true if mytype is found , false otherwise

    upvar 1 $keyt typekey
    
    foreach valtype [split $type "|"] {
        if {[string match *$mytype* "$valtype"]} {
            set typekey $valtype
            return 1
        }
    }
    
    return 0
}

proc ticklecharts::keyCompare {d other} {
    # Compare keys... output warning message if key name doesn't exist 
    # in key default option...
    #
    # d      - dict
    # other  - list values
    #
    # Returns nothing

    if {![ticklecharts::Isdict $other] || $other eq ""} {
        return {}
    }

    set catch 0

    if {![catch {info level 3} proclevel]} {
        if {![string match -nocase ticklecharts::* [lindex $proclevel 0]]} {
            set proclevel [info level 2]
        }
    } else {
        set proclevel [info level 2] ; set catch 1
    }

    set infoproc [lindex $proclevel 0]

    if {[string match {::oo::Obj[0-9]*} $infoproc] && !$catch} {
        set method [lindex [info level 2] 1] ; # name method I hope... 
        set infoproc "ticklecharts::[$infoproc gettype]::$method"
    }

    set keys1 [dict keys $d]

    foreach k [dict keys $other] {
        # special case : insert 'dummy' as name of key for theming...
        if {[string match -nocase *item $k] || [string match -nocase *dummy $k]} {continue}
        if {$k ni $keys1} {
            puts "warning ($infoproc): \"$k\" flag is not in '[join $keys1 ", "]' or not supported..."
        }
    }

    return {}
}

proc ticklecharts::merge {d other} {
    # merge 2 dictionnaries and control the type of value
    # An error exception is raised if type of value doesn't match
    #
    # d      - dict (default option)
    # other  - list values
    #
    # Returns a new dictionary

    # Compare keys... output warning message if key name doesn't exist 
    # in key default option...
    ticklecharts::keyCompare $d $other

    set _dict [dict create]
    
    dict for {key info} $d {
        lassign $info value type validvalue

        # force string value for this key below
        # if value is boolean or double...
        if {$key eq "-name" || $key eq "name"} {
            if {[dict exists $other $key]} {
                set namevalue [dict get $other $key]
                # Force string representation.
                if {[Type $namevalue] ne "str"} {
                    dict set other $key [string cat $namevalue "<s!>"]
                }
            }
        }

        if {[dict exists $other $key]} {
        
            set mytype [Type [dict get $other $key]]
            
            # check type in default list
            if {![ticklecharts::MatchType $mytype $type typekey]} {
                error "bad type 1 for this key '$key'= $mytype should be :$type"
            }

            # REMINDER: use 'dict remove' for this...
            if {$typekey in [list "dict" "dict.o" "list.o"]} {
                error "dict, dict.o, list.o shouldn't not be present in 'other' dict..."
            }

            set value [dict get $other $key]

            # Verification of certain values (especially for string types)
            formatEcharts $validvalue $value $key

            if {$typekey eq "str"} {
                set value [ticklecharts::MapSpaceString $value]
            }

            dict set _dict $key $value $typekey

        } else {
        
            set mytype [Type $value]
            
            # check type in default list
            if {![ticklecharts::MatchType $mytype $type typekey]} {
                error "bad type 2 for this key '$key'= $mytype should be :$type"
            }

            if {$typekey eq "str"} {
                set value [ticklecharts::MapSpaceString $value]
            }
                    
            dict set _dict $key $value $typekey
        }
    }
    
    return $_dict
}

proc ticklecharts::MapSpaceString {value} {
    # Replace 'spaces' by symbol '<@!>' if present 
    # Replace '#'      by symbol '<#?>' if present 
    # for string type...
    #
    # value - string
    #
    # Returns mapped string
    return [string map {" " <@!> # <#?>} $value]
}

proc ticklecharts::Isdict {value} {
    # Check if the value is a dictionnary
    #
    # value - dict
    #
    # Returns true if 'value' is a dictionnary, otherwise false.
    return [expr {![catch {dict size $value}]}]
}

proc ticklecharts::InfoOptions {key {indent 0}} {
    # Gets default options according to key procedure
    #
    # key    - dict
    # indent - format stdout
    #
    # Returns default value and type to stdout.

    set key [string map {"-" ""} $key]
    set l [split [info body ticklecharts::$key] "\n"]
    set listmap {"setdef" "" "options" ""}

    foreach val [lsearch -all -inline $l *setdef*] {
        
        if {[string first "#" [string trim $val]] == -1 && [string match {*\[ticklecharts::*} $val]} {

            set str [string range $val 0 [expr {[string first "-default" $val] - 1}]]
            puts [format "%${indent}s %s" "" [string trim [string map $listmap $str]]]

            if {[regexp {ticklecharts::([A-Za-z]+)\s} $val -> match]} {
                ticklecharts::InfoOptions $match [expr {$indent - 2}]
            }
        } else {
            puts [format "%${indent}s %s" "" [string trim [string map $listmap $val]]]
        }

    }
}

proc ticklecharts::InfoNameProc {level name} {
    # Gets name of proc follow level
    #
    # level  - level number
    # name   - name proc without namespace
    #
    # Returns True if name match with current namespace/level, False otherwise.

    lassign [info level $level] infonameproc

    return [string match *$name $infonameproc]
}

proc ticklecharts::EchartsOptsTheme {name} {
    # Gets default theme value
    #
    # name   - name theme option
    #
    # Returns value.

    return [dict get $::ticklecharts::opts_theme $name]
}

proc ticklecharts::dictIsNotNothing {d} {
    # Check if the dictionary contains only null values
    #
    # d   - dict
    #
    # Returns True if all values are null, False otherwise.

    dict for {key info} $d {
        if {$info ne "null"} {
            return 0
        }
    }

    return 1
}

proc ticklecharts::keyDictExists {basekey d key} {
    # Check if keyname exists in dict
    #
    # d   - dict
    # key - upvar name
    #
    # Returns True if key name match, False otherwise.

    upvar 1 $key name

    foreach bkey [list $basekey [format {-%s} $basekey]] {
        if {[dict exists $d $bkey]} {
            set name $bkey
            return 1
        }
    }

    return 0
}

proc ticklecharts::listNs {{parentns ::}} {
    # From https://wiki.tcl-lang.org/page/namespace
    #
    # Returns list of all namespaces.
    set result {}
    foreach ns [namespace children $parentns] {
        lappend result {*}[listNs $ns] $ns
    }
    return $result
}

proc ticklecharts::eHuddleCritcl {bool} {
    # Replaces some huddle procedures by C functions,
    # with help of critcl package https://andreas-kupries.github.io/critcl/
    #
    # bool - true or false 
    #
    # Returns Nothing
    if {$bool} {
        if {![catch {uplevel 1 [list source [file join $::ticklecharts::dir ehuddlecrit.tcl]]} infocrit]} {
            # Replace 'if {[isHuddle $key]} {...}' by 'if {[huddle::isHuddle $key]} {...}'
            # Problem if full namespace is not included... 
            proc ::huddle::types::dict::create {args} {
                if {[llength $args] % 2} {error {wrong # args: should be "huddle create ?key value ...?"}}
                set resultL [dict create]
                
                foreach {key value} $args {
                    if {[huddle::isHuddle $key]} {
                        foreach {tag src} [unwrap $key] break
                        if {$tag ne "string"} {error "The key '$key' must a string literal or huddle string" }
                        set key $src
                    }
                    dict set resultL $key [argument_to_node $value]
                }
                return [wrap [list D $resultL]]
            }

            # JsonDump
            rename ::huddle::jsondump "" ; # delete proc
            rename ticklecharts::critJsonDump ::huddle::jsondump
            # RetrieveHuddle
            rename ::huddle::retrieve_huddle "" ; # delete proc
            rename critRetrieveHuddle ::huddle::retrieve_huddle
            # IsHuddle
            rename ::huddle::isHuddle "" ; # delete proc
            rename critIsHuddle ::huddle::isHuddle
            # huddle list
            rename ::huddle::types::list::List "" ; # delete proc
            rename ticklecharts::critHList ::huddle::types::list::List

            # ehuddle procedures :
            rename ::ticklecharts::ehuddleListMap "" ; # delete proc
            rename critHuddleListMap ::ticklecharts::ehuddleListMap

            rename ::ticklecharts::ehuddleListInsert "" ; # delete proc
            rename critHuddleListInsert ::ticklecharts::ehuddleListInsert

        } else {
            puts "warning : $infocrit"
        }
    }

    return {}
}