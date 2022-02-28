# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.

namespace eval ticklecharts {
    namespace export setdef merge Type InfoNameProc
}

proc ticklecharts::htmlmap {htmloptions} {
    # Html options.
    #
    # htmloptions  - Options described below.
    #
    # -width      - size chart
    # -height     - size chart
    # -render     - 'canvas' or 'svg'
    # -jschartvar - name js variable chart
    # -divid      - name id div html
    # -title      - title html
    # -jsecharts  - script echarts
    # -jsvar      - name variable js
    #
    # Returns list map html

    lappend mapoptions [format {%%width%% %s}      [lrange [dict get $htmloptions -width]  0 end-1]]
    lappend mapoptions [format {%%height%% %s}     [lrange [dict get $htmloptions -height] 0 end-1]]
    lappend mapoptions [format {%%render%% %s}     [lrange [dict get $htmloptions -render] 0 end-1]]
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
        null   {set htype @NULL}
        dict   {set htype @L}
        list.o {set htype @DO}
        dict.o {set htype @LO}
        jsfunc {set htype @JS}
        default {error "no type for $type"}
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

    if {[ticklecharts::IsaObject $value] && 
        [string match {*jsfunc} [ticklecharts::TypeClass $value]]} {
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

proc ticklecharts::OptsToEchartsHuddle {options} {
    # Transform a dict to echartshuddle format...
    # Level 1
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
                append opts [format " ${htype}=$key {%s}" [ticklecharts::DictToEchartsHuddle $value]]
            }
            list.o {
                set l {}
                foreach val $value {
                    lappend l [ticklecharts::DictToEchartsHuddle $val]
                }
                append opts [format " ${htype}=$key {%s}" [list @AO $l]]
            }
            list.s {
                append opts [format " ${htype}=$key {%s}" $value]
            }
            default {
                append opts [format " ${htype}=$key {%s}" [list $value]]
            }
        }
    }
    
    return $opts
}

proc ticklecharts::DictToEchartsHuddle {options} {
    # Transform a dict to echartshuddle format...
    # Level 2
    # 
    # options - dict options
    #
    # Returns list (echartshuddle)

    set d [dict create {*}$options]
    set opts {}
    
    dict for {subkey subinfo} $options {
        lassign $subinfo svalue type
        
        set newtype [ticklecharts::HuddleType $type]
       
        switch -exact -- $type {
            "dict" {
                append opts [format " ${newtype}=$subkey %s" [list [ticklecharts::DictToEchartsHuddle $svalue]]]
            }
            "dict.o" {
                append opts [format " ${newtype}=$subkey {%s}" [list [ticklecharts::DictToEchartsHuddle $svalue]]]
            }
            "list.s" {
                append opts [format " ${newtype}=$subkey {%s}" $svalue]
            }
            "list.d" -
            "list.n" {
                append opts [format " ${newtype}=$subkey {{%s}}" $svalue]
            }
            "list.o" {
                set l {}
                foreach val $svalue {
                    if {[lindex $val end] eq "list.o"} {
                        set tt {}
                        foreach vv [join [lrange $val 0 end-1]] {
                            lappend tt [ticklecharts::DictToEchartsHuddle $vv]
                        }
                        lappend l [list @D $tt]
                        continue
                    }
                    
                    lappend l [ticklecharts::DictToEchartsHuddle $val]
                }
                append opts [format " ${newtype}=$subkey {%s}" [list @AO $l]]
            }
            default {
                append opts [format " ${newtype}=$subkey %s" $svalue]
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

    if {([lindex $args 0] ne "-type") && ([lindex $args 2] ne "-default")} {
        error "bad args..."
    }

    dict set dictionary $key [lindex $args 3] [lindex $args 1]
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

proc ticklecharts::merge {d other} {
    # merge 2 dictionnaries and control the type of value
    # An error exception is raised if type of value doesn't match
    #
    # d      - dict
    # other  - 2nd dict
    #
    # Returns dictionary

    set mydict [dict create]
    
    dict for {key info} $d {
   
        lassign $info value type
        
        # force string value for this key below
        # if value is boolean or double...
        if {$key eq "-name" || $key eq "name"} {
            if {[dict exists $other $key]} {
                set namevalue [dict get $other $key]
                if {[Type $namevalue] ne "str"} {
                    dict set other $key [string cat $namevalue "<s!>"]
                }
            }
        }

        if {[dict exists $other $key]} {
        
            set mytype [Type [dict get $other $key]]
            
            # check type list
            if {![ticklecharts::MatchType $mytype $type typekey]} {
                error "bad type 1 for this key '$key'= $mytype should be :$type"
            }

            if {$typekey eq "dict" || $typekey eq "dict.o"} {
                dict set mydict $key $value $typekey
            } else {
                set value [dict get $other $key]

                if {$typekey eq "str"} {
                    set value [ticklecharts::MapSpaceString $value]
                }
            
                dict set mydict $key $value $typekey
            }

        } else {
        
            set mytype [Type $value]
            
            # check type list
            if {![ticklecharts::MatchType $mytype $type typekey]} {
                error "bad type 2 for this key '$key'= $mytype should be :$type"
            }

            if {$typekey eq "str"} {
                set value [ticklecharts::MapSpaceString $value]
            }
                    
            dict set mydict $key $value $typekey
        }
    }
    
    return $mydict
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
    # indent - name proc without namespace
    #
    # Returns True if name match with current namespace/level, False otherwise .

    lassign [info level $level] infonameproc

    return [string match *$name $infonameproc]
}