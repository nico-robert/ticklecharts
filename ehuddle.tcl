# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

# add jsfunc huddle type
namespace eval ::huddle::types::jsfunc {
    variable settings 
    
    # type definition
    set settings {
                    publicMethods {jsfunc}
                    tag jsf
                    isContainer no
                }
            
    proc jsfunc {arg} {
        return [wrap [list jsf $arg]]
    }
    
    proc equal {jsf1 jsf2} {
        return [string equal $jsf1 $jsf2]
    }

    proc jsondump {huddle_object offset newline nextoff} {
        return [join [lindex $huddle_object 1 1]]
    }
}

oo::class create ticklecharts::ehuddle {
    variable _huddle ; # list huddle value

    constructor {} {
        # init variable.
        set _huddle {}
    }
}

oo::define ticklecharts::ehuddle {

    method set {args} {
        # set dict option to huddle instance
        # 
        # args - dict options from chart class
        #
        # Returns huddle

        if {[llength $args] % 2} {
            error "args list must have an even number of elements..."
        }

        set lhuddle {}
        lassign $args key data

        if {![ticklecharts::isdict $data]} {

            lassign [split $key "="] type keyvalue

            if {$data eq "nothing"} {return {}}
            # Transform key to huddle type...
            #
            switch -exact -- $type {
                "@B"    {set value [huddle boolean $data]}
                "@S"    {set value [huddle string $data]}
                "@N"    {set value [huddle number $data]}
                "@NULL" {set value [huddle null]}
                "@LS"   {set value [huddle list {*}[join $data]]}
                "@LN"   {
                            set listv [ticklecharts::ehuddleListNum $data]
                            set value [huddle list {*}$listv]
                        }
                "@LD"   {
                            if {[llength {*}$data] == 1} {
                                set listv [ticklecharts::ehuddleListInsert $data]
                            } else {
                                set listv [ticklecharts::ehuddleListMap $data]
                            }
                            set value [huddle list {*}$listv]
                        }
                "@LJ" {
                    set subH {}
                    foreach var {*}$data {
                        lassign $var k vvv 
                        lassign [split $k "="] type kk
                        switch -exact -- $type {
                            "@LS"   {set h [huddle list {*}[join $vvv]]}
                            "@L"    {lappend subH [huddle create {*}[my set $k $vvv]]}
                            default {error "no @LJ type '$type' specified for '$keyvalue'"}
                        }
                    }

                    set value [huddle append h {*}$subH]

                    }
                "@JS" {set value [huddle jsfunc [$data get]]}
                default {error "(1) Unknown type '$type' specified for '$keyvalue'"}
            }

            lassign [info level 0] obj

            if {[ticklecharts::isAObject $obj]} {
                lappend _huddle [huddle create $keyvalue $value]
                return {}
            } else {
                return [list $keyvalue $value]
            }
        }

        set mydict [dict create {*}$data]
        # second level data can be transformed into a dictionary
        #
        dict for {subkey info} $mydict {
            # Guess if info is a dictionary
            #
            if {![ticklecharts::isdict $info]} {

                lassign [split $subkey "="] type subkeyvalue
                set lko 0

                if {$info eq "nothing"} {continue}
                # Transform key to huddle type...
                #
                switch -exact -- $type {
                    "@B"    {set value [huddle boolean $info]}
                    "@S"    {set value [huddle string $info]}
                    "@N"    {set value [huddle number $info]}
                    "@NULL" {set value [huddle null]}
                    "@LS"   {set value [huddle list {*}[join $info]]}
                    "@LN"   {
                                set listv [ticklecharts::ehuddleListNum $info]
                                set value [huddle list {*}$listv]
                            }
                    "@LD"   {
                                if {[llength {*}$info] == 1} {
                                    set listv [ticklecharts::ehuddleListInsert $info]
                                } else {
                                    set listv [ticklecharts::ehuddleListMap $info]
                                }
                                set value [huddle list {*}$listv]
                            }
                    "@AO"   -
                    "@LO"  {
                        set lko 1
                        foreach value $info {

                            set subdata {}
                            foreach {k val} $value {
                                lassign [split $k "="] subtype subkeyvalue1

                                switch -exact -- $subtype {
                                    "@L"    {lappend subdata $subkeyvalue1 [huddle create {*}[my set $k $val]]}
                                    "@DO"   {lappend subdata {*}[my set $k $value]}
                                    "@B"    -
                                    "@S"    - 
                                    "@N"    - 
                                    "@NULL" -
                                    "@JS"   -
                                    "@LS"   - 
                                    "@LD"   - 
                                    "@LN"  {lappend subdata {*}[my set $k $val]}
                                    default {error "(6) Unknown type '$subtype' specified for '$subkeyvalue1'"}
                                }
                            }

                            if {$type eq "@AO"} {
                                lappend lhuddle [huddle create {*}$subdata]
                            } else {
                                lappend lhuddle $subkeyvalue [huddle list [huddle create {*}$subdata]]
                            }
                        }
                    }
                    "@JS" {set value [huddle jsfunc [$info get]]}
                    default {error "(2) Unknown type '$type' specified for '$subkeyvalue'"}
                }

                if {!$lko} {
                    lappend lhuddle $subkeyvalue $value
                }

            } else {
                lassign [split $subkey "="] type subkeyvalue

                switch -exact -- $type {
                    "@L"   {lappend lhuddle $subkeyvalue [huddle create {*}[my set $subkey $info]]}
                    "@D"   {lappend lhuddle $subkeyvalue [huddle list [huddle create {*}[my set $subkey $info]]]}
                    "@DO"  {

                            set subdata {}
                            foreach {k val} $info  {
                            
                                if {$k ne "@AO"} {
                                    error "key value must be @AO instead of '$k'"
                                }

                                set suv {}
                                foreach vv $val {
                                    set subdatalist {}
                                    foreach {sk vk} $vv {
                                        lassign [split $sk "="] subtype subkeyvalue1

                                        switch -exact -- $subtype {
                                            "@L"   {lappend subdatalist $subkeyvalue1 [huddle create {*}[my set $sk $vk]]}
                                            "@DO"  {lappend subdatalist {*}[my set $sk $vv]}
                                            "@D"   {
                                                    set dlist {}
                                                    foreach vald $vk {
                                                        set llist {}
                                                        foreach {subkeyvald subvald} $vald {
                                                            set _subdata {}
                                                            lassign [split $subkeyvald "="] subtype subkeyvalue1
                                                            switch -exact -- $subtype {
                                                                "@L"    {lappend _subdata $subkeyvalue1 [huddle create {*}[my set $subkeyvald $subvald]]}
                                                                "@B"    -
                                                                "@S"    - 
                                                                "@N"    - 
                                                                "@NULL" -
                                                                "@JS"   -
                                                                "@LS"   - 
                                                                "@LD"   - 
                                                                "@LN"  {lappend _subdata {*}[my set $subkeyvald $subvald]}
                                                                default {error "(7) Unknown type '$subtype' specified for '$subkeyvalue1'"}
                                                            }

                                                            if {$_subdata ne ""} {
                                                                append llist "$_subdata "
                                                            }
                                                        }
                                                        lappend dlist [huddle create {*}$llist]
                                                    }

                                                    lappend suv [huddle list {*}$dlist]
                                            }
                                            default {lappend subdatalist {*}[my set $sk $vk]}
                                        }
                                    }

                                    if {[llength $subdatalist]} {
                                        lappend suv [huddle create {*}$subdatalist]
                                    }
                                }
                                lappend subdata {*}$suv
                            }
                            lappend lhuddle $subkeyvalue [huddle list {*}$subdata]

                        }
                    "@AO"  -
                    "@LO"  {
                        set subdata     {}
                        set subdatalist {}
                        foreach value $info {
                            foreach {k val} $value {
                                lassign [split $k "="] subtype subkeyvalue1
                                switch -exact -- $subtype {
                                    "@L"    {lappend subdata $subkeyvalue1 [huddle create {*}[my set $k $val]]}
                                    "@DO"   {lappend subdata {*}[my set $k $value]}
                                    "@B"    -
                                    "@S"    -
                                    "@N"    -
                                    "@NULL" -
                                    "@JS"   -
                                    "@LS"   -
                                    "@LD"   -
                                    "@LN"  {lappend subdata {*}[my set $k $val]}
                                    default {error "(5) Unknown type '$subtype' specified for '$subkeyvalue1'"}
                                }
                            }

                            if {$type eq "@AO"} {
                                lappend lhuddle [huddle create {*}$subdata]
                            } else {
                                lappend subdatalist [huddle create {*}$subdata]
                            }
                            set subdata {}
                        }
                        if {$type eq "@LO"} {
                            lappend lhuddle $subkeyvalue [huddle list {*}$subdatalist]
                        }
                    }
                    default {error "(3) Unknown type '$type' specified for '$subkey'"}
                }
            }
        }

        lassign [split $key "="] type keyvalue
        lassign [info level 0] obj

        switch -exact -- $type {
            "@L"   {
                    set h [huddle create $keyvalue [huddle create {*}$lhuddle]]
                }
            "@D"   {
                    set h [huddle create $keyvalue [huddle list [huddle create {*}$lhuddle]]]
                }
            "@DO"  {
                    set h [huddle create $keyvalue [huddle list {*}$lhuddle]]
                }
                
            default {error "(4) Unknown type '$type' specified for '$key'"}
        }

        if {[ticklecharts::isAObject $obj]} {
            # append to global huddle.
            lappend _huddle $h
        }

        return $lhuddle
    }

    method extract {} {
        # Combine huddle
        return [huddle combine {*}$_huddle]
    }

    method append {key value} {
        # append dict option to huddle instance or
        # set huddle if key doesn't exist...
        # 
        # key   - dict key
        # value - dict value
        #
        # append huddle to global '_huddle'. 
    
        set _h [ticklecharts::ehuddle new]
        lassign [split $key "="] type valkey

        # special case for timeline class
        set infolevel2 [lindex [info level 2] 1]
        set timeline [expr {($infolevel2 eq "timelineToHuddle") ? 1 : 0}]

        set listk {}
        foreach {k val} $value {
            if {$timeline} {
                if {[string match {*@D=*} $k] && ($k in $listk)} {
                    $_h append $k $val
                } else {
                    $_h set $k $val 
                }
                lappend listk $k
            } else {
                $_h set $k $val
            }
        }

        if {$valkey in [my keys]} {
            set h [my extract]
            set index [huddle llength [huddle get $h $valkey]]
            huddle set h $valkey $index [$_h extract]
        } else {
            [self] set $key {}
            set h [my extract]

            if {$type eq "@L"} {
                huddle set h $valkey [$_h extract]
            } else {
                huddle set h $valkey 0 [$_h extract]
            }
        }
        
        # destroy...
        $_h destroy

        # set new huddle list
        set _huddle [list $h]

        return {}
    }

    method llength {} {
        # Returns the length of huddle instance
        return [llength $_huddle]
    }
    
    method get {} {
        # Returns the value of huddle instance
        return $_huddle
    }

    method keys {} {
        # Returns the keys of huddle instance
        if {[my llength]} {
            return [huddle keys [my extract]]
        } else {
            return {}
        }
    }
    
    method llengthkeys {key} {
        # Returns the length follow key
        # 
        # key - huddle key
        if {$key in [my keys]} {
            return [huddle llength [huddle get [my extract] $key]]
        } else {
            return 0
        }
    }

    method toJSON {} {
        # Transform huddle to JSON
        # replace special chars by space... etc.
        # 
        # Returns JSON
        set lstringmap {
            <@!> " "
            <s!> ""
            <#!> ""
            <#?> "#"
            <n?> "\\n"
            <0123> \{
            <0125> \}
            <091> \[
            <093> \]
            \\/ /
        }
        return [string map $lstringmap [huddle jsondump [my extract]]]
    }
}

proc ticklecharts::ehuddle_num val {
    # To avoid checking 2 times that the value is a numeric
    # with wrap proc hudlle inside huddle.tcl
    #
    # Returns format hudlle num
    return [format "HUDDLE {num %s}" $val]
}

proc ticklecharts::ehuddleListNum data {
    # Map tcl list to huddle format list number
    #
    # Returns huddle list
    set listv {}

    if {[llength {*}$data] == 1} {
        foreach val [lindex {*}$data 0] {
            lappend listv [huddle number $val]
        }
    } else {
        foreach val {*}$data {
            lappend listv [huddle list {*}[lmap v $val {huddle number $v}]]
        }
    }

    return $listv
}

proc ticklecharts::ehuddleListMap data {
    # Map tcl list to huddle format list
    #
    # Returns huddle list
    set listv {}

    foreach val {*}$data {
        lappend listv [huddle list {*}[lmap v $val {
            if {[string is double -strict $v]} {
                ticklecharts::ehuddle_num $v
            } else {
                huddle string $v
            }
        }]]
    }

    return $listv
}

proc ticklecharts::ehuddleListInsert data {
    # Transform tcl list to huddle list
    #
    # Returns huddle list
    set listv {}

    foreach val [lindex {*}$data 0] {
        if {[string is double -strict $val]} {
            lappend listv [ticklecharts::ehuddle_num $val]
        } else {
            lappend listv [huddle string $val]
        }
    }

    return $listv
}

proc ticklecharts::eHuddleCritcl {bool} {
    # Replaces some huddle procedures by C functions,
    # with help of critcl package https://andreas-kupries.github.io/critcl/
    #
    # bool - true or false 
    #
    # Returns Nothing
    variable edir

    if {$bool} {
        if {![catch {uplevel 1 [list source [file join $edir ehuddlecrit.tcl]]} infocrit]} {
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

# Add jsfunc as hudlle type
huddle addType ::huddle::types::jsfunc