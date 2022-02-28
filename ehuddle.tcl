# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

oo::class create ticklecharts::ehuddle {
    variable _huddle ; # list huddle value
    variable _js     ; # dict javascript value

    constructor {} {
        # init variable.
        set _huddle {}
        set _js [dict create]
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
            error "bad args... llength shoud be greater than 1"
        }

        set lhuddle {}
        lassign $args key data

        if {![ticklecharts::Isdict $data]} {

            lassign [split $key "="] type keyvalue

            if {$data eq "nothing"} {return}

            switch -exact -- $type {
                "@B"    {set value [huddle boolean $data]}
                "@S"    {set value [huddle string $data]}
                "@N"    {set value [huddle number $data]}
                "@NULL" {set value [huddle null]}
                "@LS"   {set value [huddle list {*}[join $data]]}
                "@LN"   {
                            set listv {}
                            set l [llength {*}$data]
                            if {$l == 1} {
                                foreach val [lindex {*}$data 0] {
                                    lappend listv [huddle number $val]
                                }
                            } else {
                                foreach val {*}$data {
                                    lappend listv [huddle list {*}[lmap a $val {huddle number $a}]]
                                }
                            }
                            set value [huddle list {*}$listv]
                        }
                "@LD"   {
                            set listv {}
                            set l [llength {*}$data]
                            if {$l == 1} {
                                foreach val [lindex {*}$data 0] {
                                    if {[string is double $val]} {
                                        lappend listv [huddle number $val]
                                    } else {
                                        lappend listv [huddle string $val]
                                    }
                                }
                            } else {
                                foreach val {*}$data {
                                    lappend listv [huddle list {*}[lmap a $val {
                                        if {[string is double $a]} {
                                            huddle number $a
                                        } else {
                                            huddle string $a
                                        }
                                    }]]
                                }
                            }
                            set value [huddle list {*}$listv]
                        }
                "@DO" {set value [huddle list $data]}
                "@JS" {
                    set cc [clock clicks]
                    dict set _js $cc [$data get]
                    set value [huddle string [string map {\" ""} "%JS${cc}%"]]
                }

                default {error "1 Unknown type '$type' specified for '$keyvalue'"}
            }

            lassign [info level 0] obj

            if {[info object isa object $obj] == 1} {
                lappend _huddle [huddle create $keyvalue $value]
                return
            } else {
                return [list $keyvalue $value]
            }
        }

        set mydict [dict create {*}$data]

        dict for {subkey info} $mydict {

            if {![ticklecharts::Isdict $info]} {

                lassign [split $subkey "="] type subkeyvalue
                set lko 0

                if {$info eq "nothing"} {continue}
                
                switch -exact -- $type {
                    "@B"    {set value [huddle boolean $info]}
                    "@S"    {set value [huddle string $info]}
                    "@N"    {set value [huddle number $info]}
                    "@NULL" {set value [huddle null]}
                    "@LS"   {set value [huddle list {*}[join $info]]}
                    "@LN"   {
                                set listv {}
                                set l [llength {*}$info]
                                if {$l == 1} {
                                    foreach val [lindex {*}$info 0] {
                                        lappend listv [huddle number $val]
                                    }
                                } else {
                                    foreach val {*}$info {
                                        lappend listv [huddle list {*}[lmap a $val {huddle number $a}]]
                                    }
                                }
                                set value [huddle list {*}$listv]
                            }
                    "@LD"   {
                                set listv {}
                                set l [llength {*}$info]
                                if {$l == 1} {
                                    foreach val [lindex {*}$info 0] {
                                        if {[string is double $val]} {
                                            lappend listv [huddle number $val]
                                        } else {
                                            lappend listv [huddle string $val]
                                        }
                                    }
                                } else {
                                    foreach val {*}$info {
                                        lappend listv [huddle list {*}[lmap a $val {
                                            if {[string is double $a]} {
                                                huddle number $a
                                            } else {
                                                huddle string $a
                                            }

                                        }]]
                                    }
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
                                        "@B"    -
                                        "@S"    - 
                                        "@N"    - 
                                        "@NULL" -
                                        "@LS"   - 
                                        "@LD"   - 
                                        "@LN"  {lappend subdata {*}[my set $k $val]}
                                        default {error "6 Unknown type '$subtype' specified for '$subkeyvalue1'"}
                                }
                            }

                            if {$type eq "@AO"} {
                                lappend lhuddle [huddle create {*}$subdata]
                            } else {
                                lappend lhuddle $subkeyvalue [huddle list [huddle create {*}$subdata]]
                            }
                        }
                    }
                    "@JS" {
                        set cc [clock clicks]
                        dict set _js $cc [$info get]
                        set value [huddle string [string map {\" ""} "%JS${cc}%"]]
                    }

                    default {error "2 Unknown type '$type' specified for '$subkeyvalue'"}
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
                                            "@D"   {
                                                    set dlist {}
                                                    foreach vald $vk {
                                                        set llist {}
                                                        foreach {subkeyvald subvald} $vald {       
                                                            set subdata {}
                                                            lassign [split $subkeyvald "="] subtype subkeyvalue1
                                                            switch -exact -- $subtype {
                                                                    "@L"    {lappend subdata $subkeyvalue1 [huddle create {*}[my set $subkeyvald $subvald]]}
                                                                    "@B"    -
                                                                    "@S"    - 
                                                                    "@N"    - 
                                                                    "@NULL" -
                                                                    "@LS"   - 
                                                                    "@LD"   - 
                                                                    "@LN"  {lappend subdata {*}[my set $subkeyvald $subvald]}
                                                                    default {error "7 Unknown type '$subtype' specified for '$subkeyvalue1'"}
                                                            }

                                                            if {$subdata ne ""} {
                                                                append llist "$subdata "
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
                        set subdata {}
                        set subdatalist {}

                        foreach value $info {

                            foreach {k val} $value {
                                lassign [split $k "="] subtype subkeyvalue1

                                switch -exact -- $subtype {
                                        "@L"    {lappend subdata $subkeyvalue1 [huddle create {*}[my set $k $val]]}
                                        "@B"    -
                                        "@S"    -
                                        "@N"    -
                                        "@NULL" -
                                        "@LS"   -
                                        "@LD"   -
                                        "@LN"  {lappend subdata {*}[my set $k $val]}
                                        default {error "5 Unknown type '$subtype' specified for '$subkeyvalue1'"}
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

                    default {error "3 Unknown type '$type' specified for '$subkey'"}
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
                
            default {error "4 Unknown type '$type' specified for '$key'"}
        }

        if {[info object isa object $obj] == 1} {
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
        # append huddle to global huddle. 
    
        set newhuddle [ticklecharts::ehuddle new]
        lassign [split $key "="] type valkey
        
        foreach {k val} $value {
            $newhuddle set $k $val
        }
        
        if {$valkey in [my keys]} {
            set h [my extract]
            set index [huddle llength [huddle get $h $valkey]]
            huddle set h $valkey $index [$newhuddle extract]
        } else {
            [self] set $key {}
            set h [my extract]

            if {$type eq "@L"} {
                huddle set h $valkey [$newhuddle extract]
            } else {
                huddle set h $valkey 0 [$newhuddle extract]
            }
        }

        # add js class
        if {[llength $_js]} {
            set t [$newhuddle js]
            if {$t ne ""} {
                # add jsfunc to global _js...
                set _js [dict merge $_js $t]
            }
        } else {
            set _js [$newhuddle js]
        }
        
        # destroy...
        $newhuddle destroy
        
        # add huddle list
        lappend _huddle $h
    }

    method llength {} {
        # Returns the length of huddle instance
        return [llength $_huddle]
    }
    
    method get {} {
        # Returns the value of huddle instance
        return {*}$_huddle
    }

    method keys {} {
        # Returns the keys of huddle instance
        if {[my llength]} {
            return [huddle keys [my extract]]
        } else {
            return ""
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
    
    method js {} {
        # Returns javascript dict
        return $_js
    }

    method toJSON {} {
        # Transform huddle to JSON
        # map javascript dict in JSON
        # replace special chars by space... etc.
        # 
        # Returns JSON
        set lstringmap {
            <@!> " "
            <s!> ""
            <#!> ""
            <#?> "#"
            <n?> "\n"
            <0123> \{
            <0125> \}
            <091> \[
            <093> \]
            \\/ /
        }

        dict for {key info} $_js {
            if {$key eq ""} {continue}
            append lstringmap " {\"%JS${key}%\",} $info {\"%JS${key}%\"} $info"
        }

        return [string map $lstringmap [huddle jsondump [my extract]]]
    }
    
}