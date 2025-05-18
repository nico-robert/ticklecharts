# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {
    # Adds jsfunc as huddle type.
    namespace eval ::huddle::types::jsfunc {
        variable settings 

        # type definition
        set settings {
            publicMethods "jsfunc" 
            tag "jsf" 
            isContainer "no"
        }

        proc jsfunc {arg} {
            return [wrap [list jsf $arg]]
        }

        proc jsondump {huddle_object offset newline nextoff} {
            return [join [lindex $huddle_object 1 1]]
        }

    }; ::huddle::addType ::huddle::types::jsfunc

    # Adds elist.n as huddle type.
    namespace eval ::huddle::types::listPn {
        variable settings 

        # type definition
        set settings {
            publicMethods "lpn" 
            tag "LPN" 
            isContainer "yes"
        }

        proc lpn {arg} {
            return [wrap [list LPN $arg]]
        }

        proc jsondump {huddle_object offset newline nextoff} {
            set nlof "$newline$nextoff"

            set data [get_src $huddle_object]

            if {[llength $data] == 1} {
                return "\[$nlof[join {*}$data ,$nlof]$nlof\]"
            } else {
                set listv {}
                foreach val $data {
                    lappend listv "\[$nlof[join $val ,$nlof]$nlof\]"
                }
                return "\[$nlof[join $listv ,$nlof]$nlof\]"
            }
        }

    }; ::huddle::addType ::huddle::types::listPn
}

oo::class create ticklecharts::ehuddle {
    variable _huddle ; # list huddle value
    variable _series ; # list type series

    constructor {} {
        # init variables.
        set _huddle {}
        set _series {}
    }
}

oo::define ticklecharts::ehuddle {

    method set {args} {
        # set dict option to huddle instance
        # 
        # args - dict options
        #
        # Returns huddle

        if {[llength $args] % 2} {
            error "wrong # args: 'ehuddle' list must have an\
                   even number of elements."
        }

        set lhuddle {}

        foreach {key info} $args {

            lassign [split $key "="] type keyvalue

            if {$info eq "nothing"} {continue}
            # Transform key to huddle type.
            #
            switch -exact -- $type {
                "@B"    {set value [list HUDDLE [list b [string tolower $info]]]}
                "@S"    {set value [list HUDDLE [list s $info]]}
                "@N"    {set value [list HUDDLE [list num $info]]}
                "@NULL" {set value [list HUDDLE null]}
                "@SE"   {set value [list HUDDLE [list s [$info get]]]}
                "@LS"   {
                        if {[llength $info] == 1} {
                            set info [join $info]
                        }
                        set value [format {HUDDLE {L {%s}}} [ \
                            lmap str $info {list s $str} \
                        ]]
                    }
                "@LN"   {
                        set listv [ticklecharts::ehuddleListNum $info]
                        set value [format {HUDDLE {L {%s}}} $listv]
                    }
                "@LPN"  {set value [huddle lpn {*}$info]}
                "@LD"   {
                        if {[llength {*}$info] == 1} {
                            set listv [ticklecharts::ehuddleListInsert $info]
                        } else {
                            set listv [ticklecharts::ehuddleListMap $info]
                        }
                        set value [format {HUDDLE {L {%s}}} $listv]
                    }
                "@LJ"   {
                        set subH {}
                        foreach var $info {
                            lassign $var vk vinfo 
                            lassign [split $vk "="] vtype _
                            switch -exact -- $vtype {
                                "@LS"   {set h [huddle list {*}[join $vinfo]]}
                                "@L"    {lappend subH [huddle create {*}[my set {*}$vinfo]]}
                                "@D"    {lappend subH [huddle list [huddle create {*}[my set {*}$vinfo]]]}
                                default {error "'@LJ' subtype '$vtype' not supported for '$keyvalue'."}
                            }
                        }
                        set value [huddle append h {*}$subH]
                    }
                "@JS"   {set value [huddle jsfunc [$info get]]}
                "@D"    {set value [huddle list [huddle create {*}[my set {*}$info]]]}
                "@L"    {set value [huddle create {*}[my set {*}$info]]}
                "@AO"   {
                        set suv {}
                        foreach vv $info {
                            set subdatalist {}
                            foreach {sk vk} $vv {
                                lassign [split $sk "="] subtype _
                                switch -exact -- $subtype {
                                    "@A" {
                                        set dlist {}
                                        foreach vald $vk {
                                            set subdata [my set {*}$vald]
                                            lappend dlist [huddle create {*}$subdata]
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
                        set value $suv
                    }
                "@DO"   {
                        set subdata {}
                        foreach {k val} $info {
                            if {$k ne "@AO"} {
                                error "Key value must be @AO instead of '$k'."
                            }
                            lappend subdata {*}[lindex [my set $k $val] end]
                        }
                        set value [huddle list {*}$subdata]
                    }
                default {error "Unknown type '$type' specified for '$keyvalue'."}
            }
            lappend lhuddle $keyvalue $value
        }

        lassign [info level 0] obj

        if {[ticklecharts::isAObject $obj]} {
            lappend _huddle [huddle create {*}$lhuddle]
        }

        return $lhuddle
    }

    method extract {} {
        # Combine huddle
        if {[my llength] == 1} {
            return {*}$_huddle
        }

        return [huddle combine {*}$_huddle]
    }

    method append {key value} {
        # append dict option to huddle instance or
        # set huddle if key doesn't exist.
        # 
        # key   - dict key
        # value - dict value
        #
        # append huddle to global '_huddle'. 

        set eh [ticklecharts::ehuddle new]
        lassign [split $key "="] type valkey

        # special case for timeline class
        lassign [self caller] _ obj method
        if {([$obj getType] eq "timeline") && ($method eq "ToHuddle")} {
            set listk {}
            foreach {k val} $value {
                if {[string match {*@D=*} $k] && ($k in $listk)} {
                    $eh append $k $val
                } else {
                    $eh set $k $val
                }
                lappend listk $k
            }
        } else {
            $eh set {*}$value
        }

        if {$valkey in [my keys]} {
            set h [my extract]
            set index [huddle llength [huddle get $h $valkey]]
            huddle set h $valkey $index [$eh extract]
        } else {
            [self] set $key {}
            set h [my extract]

            if {$type eq "@L"} {
                huddle set h $valkey [$eh extract]
            } else {
                huddle set h $valkey 0 [$eh extract]
            }
        }

        # Add series type.
        if {[string match {*=series*} $key]} {
            if {[dict exists $value "@S=type"]} {
                lappend _series [dict get $value "@S=type"]
            }
        }

        # destroy.
        $eh destroy

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

    method getType {} {
        # Returns type of class
        return "ehuddle"
    }

    method getTypeSeries {} {
        # Returns list type series.
        return [lsort -unique $_series]
    }

    method keys {} {
        # Returns the keys of huddle instance
        if {[my llength]} {
            return [huddle keys [my extract]]
        } else {
            return {}
        }
    }

    method dump {} {
        # Transform huddle to JSON
        # replace special chars by space, etc.
        # 
        # Returns JSON
        set lstringmap {
            <@!> " "
            <s!> ""
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

proc ticklecharts::ehuddleNum val {
    # Returns format hudlle num.
    if {[ticklecharts::typeOf $val] ne "num"} {
        error "wrong # args(ehuddleNum): '$val' is not a number."
    }

    return [list num $val]
}

proc ticklecharts::ehuddleListNum {data} {
    # Map tcl list to huddle list format number
    #
    # data     - list num
    # 
    # Returns huddle list
    set listv {}

    if {[llength {*}$data] == 1} {
        foreach val [lindex {*}$data 0] {
            lappend listv [ticklecharts::ehuddleNum $val]
        }
    } else {
        foreach val {*}$data {
            lappend listv [list L [\
                lmap v $val {ticklecharts::ehuddleNum $v} \
            ]]
        }
    }

    return $listv
}

proc ticklecharts::ehuddleListMap data {
    # Map tcl list
    #
    # data - list
    # 
    # Returns huddle format list
    set listv {}

    foreach val {*}$data {
        lappend listv [format {L {%s}} [lmap v $val {
                    switch -exact -- [ticklecharts::typeOf $v] {
                        num     {list num $v}
                        null    {list null}
                        str.e   {list s [$v get]}
                        struct  {$v structHuddle}
                        default {list s $v}
                    }
                }
            ]
        ]
    }

    return $listv
}

proc ticklecharts::ehuddleListInsert data {
    # Transform tcl list
    #
    # data - list
    # 
    # Returns huddle list
    set listv {}

    foreach val [lindex {*}$data 0] {
        switch -exact -- [ticklecharts::typeOf $val] {
            num     {lappend listv [list num $val]}
            null    {lappend listv [list null]}
            str.e   {lappend listv [list s [$val get]]}
            struct  {lappend listv [$val structHuddle]}
            default {lappend listv [list s $val]}
        }
    }

    return $listv
}

proc ticklecharts::eHuddleCritcl {bool} {
    # Replaces some huddle procedures by C functions,
    # with help of critcl package https://andreas-kupries.github.io/critcl/
    #
    # bool - boolean value
    #
    # Returns Nothing
    variable edir

    if {$bool} {
        if {![catch {
            uplevel 1 [list source [file join $edir ehuddlecrit.tcl]]
        } infocrit]
        } {
            # JsonDump
            rename ::huddle::jsondump "" ; # delete proc
            rename critJsonDump ::huddle::jsondump
            # RetrieveHuddle
            rename ::huddle::retrieve_huddle "" ; # delete proc
            rename critRetrieveHuddle ::huddle::retrieve_huddle
            # IsHuddle
            rename ::huddle::isHuddle "" ; # delete proc
            rename critIsHuddle ::isHuddle
            # huddle list
            rename ::huddle::types::list::List "" ; # delete proc
            rename critHList ::huddle::types::list::List

            # ehuddle procedures :
            rename ehuddleListMap "" ; # delete proc
            rename critHuddleListMap ehuddleListMap
            rename ehuddleListInsert "" ; # delete proc
            rename critHuddleListInsert ehuddleListInsert

            proc eHuddleCritcl {bool} {
                # Procedure already activated.
                # Output a message to say that it is already running.
                #
                puts stderr "'ticklecharts::eHuddleCritcl' procedure\
                             is already activated."
            }
        } else {
            puts stderr "warning(eHuddleCrit): $infocrit"
        }
    }

    return {}
}