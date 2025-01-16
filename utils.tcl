# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::htmlMap {h html htmloptions} {
    # Set options in html string.
    #
    # h            - huddle object.
    # html         - template html.
    # htmloptions  - html string map options.
    #
    # Returns list map html

    # Formats html options.
    # Doesn't care about attributes in the html file.
    foreach {key info} $htmloptions {
        lassign $info value type
        if {$value eq "nothing"} {continue}
        switch -exact -- $type {
            bool {
                # Force string to lower for boolean value.
                set value [string tolower $value]
            }
            jsfunc - list.d {
                set value $info
            }
        }
        set key [string trim [string map {"-" ""} $key]]
        set key [string cat % $key %]

        dict set mapoptions $key $value
    }

    # If '%style%' attribute is present in html file but 
    # '-style' is not present in dict options, add it to my options.
    # Note : '-width' or/and '-height' must be in dict options.
    set style "%style%"
    if {![dict exists $mapoptions $style]} {
        set width [expr {
            [dict exists $mapoptions "%width%"]
                ? [dict get $mapoptions "%width%"]
                : "nothing"
            }
        ]
        set height [expr {
            [dict exists $mapoptions "%height%"]
                ? [dict get $mapoptions "%height%"]
                : "nothing"
            }
        ]

        if {($width ne "nothing") && ($height ne "nothing")} {
            dict set mapoptions $style [format {width:%s; height:%s;} $width $height]
        } elseif {($width ne "nothing") && ($height eq "nothing")} {
            dict set mapoptions $style [format {width:%s;} $width]
        } elseif {($width eq "nothing") && ($height ne "nothing")} {
            dict set mapoptions $style [format {height:%s;} $height]
        }
    }

    # Add or not js script(s) in html template.
    set html [ticklecharts::setJsScript $html $h mapoptions]

    return [string map $mapoptions $html]
}

proc ticklecharts::setJsScript {html h mapoptions} {
    # Set js script(s) in html template file.
    #
    # html       - template html string.
    # h          - ehuddle object.
    # mapoptions - html dict map options.
    #
    # Returns html
    variable gapiscript ; variable keyGMAPI
    variable wcscript
    variable gmscript
    variable eGLscript

    upvar 1 $mapoptions hoptions

    # Add gmap script + Google maps API if 'gmap' option is defined.
    # Add a comment in html template file if Google key API is not defined.
    # Add 'wordcloud' script if defined.
    # Add 'GL' script if 'series 3D' type is defined.
    # Base html format.
    set jsScript {}
    set frmt {<script type="text/javascript" src="%s"></script>}
    set keys [$h keys]
    # gmap.js
    if {"gmap" in $keys} {
        lappend jsScript [jsfunc new [format $frmt $gapiscript] -header]
        if {$keyGMAPI eq "??"} {
            lappend jsScript [jsfunc new {
                <!-- please replace '??' with your own API key -->
                } -header]
        }
        lappend jsScript [jsfunc new [format $frmt $gmscript] -header]
    }
    # wordCloud.js
    if {"wordCloud" in [$h getTypeSeries]} {
        lappend jsScript [jsfunc new [format $frmt $wcscript] -header]
    }
    # GL.js
    if {"globe" in $keys} {
        lappend jsScript [jsfunc new [format $frmt $eGLscript] -header]
    } else {
        foreach series3D {
            line3D scatter3D bar3D lines3D map3D 
            surface polygons3D scatterGL graphGL flowGL
            } {
            if {$series3D in [$h getTypeSeries]} {
                lappend jsScript [jsfunc new [format $frmt $eGLscript] -header]
                break
            }
        }
    }

    if {[llength $jsScript]} {
        if {[dict exists $hoptions "%script%"]} {
            set script [lindex [dict get $hoptions "%script%"] 0]
            dict set hoptions "%script%" [format {{{%s}} list.d} \
                                         [linsert {*}$script end {*}$jsScript]]
        } else {
            dict set hoptions "%script%" [format {{{%s}} list.d} $jsScript]
        }
    }

    if {[dict exists $hoptions "%script%"]} {
        set html [ticklecharts::addJsScript $html [dict get $hoptions "%script%"]]
    }

    return $html
}

proc ticklecharts::addJsScript {html value} {
    # Add js script(s) in html template file.
    #
    # html  - template html string.
    # value - list jsfunc class or jsfunc class.
    #
    # Returns html

    lassign $value js type

    switch -exact -- $type {
        jsfunc  {
            set indent 0
            switch -exact -- [$js position] {
                start  {set item "%jschartvar%"}
                end    {set item "%json%"}
                header {set item "%jsecharts%" ; set indent 3}
                null   {set item "%jschartvar%"}
            }
            if {[set f [lsearch $html *$item*]] < 0} {
                # Inserting a script, variable, function, etc. in the html file is
                # based on a search for a string if this is not found,
                # an error is generated.
                return -level [info level] -code error "Not possible to\
                    find '$item' string in the html template file."
            }
            set listHtml [linsert $html $f+1 \
                         [format [list %-${indent}s %s] "" [join [$js get]]]]
        }
        list.d {
            set listHtml $html
            foreach script {*}[lreverse $js] {
                set indent 0
                # Insert Jsfunc.
                if {[ticklecharts::typeOf $script] eq "jsfunc"} {
                    switch -exact -- [$script position] {
                        start  {set item "%jschartvar%"}
                        end    {set item "%json%"}
                        header {set item "%jsecharts%" ; set indent 3}
                        null   {set item "%jschartvar%"}
                    }
                    if {[set f [lsearch $listHtml *$item*]] < 0} {
                        # Look at the comment above.
                        return -level [info level] -code error "Not possible to\
                            find '$item' string in the html template file."
                    }
                    set listHtml [linsert $listHtml $f+1 \
                                 [format [list %-${indent}s %s] \
                                 "" [join [$script get]]]]
                } else {
                    error "wrong # args: should be a 'jsfunc'\
                           class in list data script."
                }
            }
        }
    }

    return $listHtml
}

proc ticklecharts::readHTMLTemplate {template} {
    # Opens and reads html template.
    #
    # template  - template html.
    #
    # Returns html file|string as a list.

    if {[file isfile $template]} {
        try {
            set fp   [open $template r]
            set html [split [read $fp] "\n"]
        } on error {result options} {
            error [dict get $options -errorinfo]
        } finally {
            catch {close $fp}
        }
    } else {
        set html [split $template "\n"]
    }

    # %json% attribute should be defined in html template.
    if {[lsearch $html *%json%*] < 0} {
        return -level [info level] \
                -code error  "wrong # html: '%json%' attribute\
                should be defined in html file or string 'template'"
    }

    return $html
}

proc ticklecharts::ehuddleType {type} {
    # Transform dict type to huddle echarts type.
    #
    # type  - dict options type.
    #
    # Returns huddle echarts type

    switch -exact -- $type {
        str.t     - str     {set htype @S}
        str.et    - str.e   {set htype @SE}
        num.t     - num     {set htype @N}
        bool.t    - bool    {set htype @B}
        list.st   - list.s  -
        elist.st  - elist.s {set htype @LS}
        list.nt   - list.n  -
        elist.nt  - elist.n {set htype @LN}
        list.dt   - list.d  -
        elist.dt  - elist.d {set htype @LD}
        e.color   - dict    {set htype @L}
        list.o    - elist.o {set htype @DO}
        list.j              {set htype @LJ}
        null                {set htype @NULL}
        struct.d            {set htype @L}
        struct.ld           {set htype @D}
        jsfunc              {set htype @JS}
        default             {error "no type for '$type'"}
    }

    return $htype
}

proc ticklecharts::typeOfClass {obj} {
    # Name of class.
    #
    # obj  - Instance.
    #
    # Returns name of class or nothing.
    return [info object class $obj]
}

proc ticklecharts::isAObject {obj} {
    # Check if variable 'obj' is an object.
    #
    # obj  - Instance.
    #
    # Returns true or false.
    return [info object isa object $obj]
}

proc ticklecharts::classDef {name method} {
    # Info class definition.
    #
    # name   - class name
    # method - method name
    #
    # Returns the class method definition.
    return [info class definition $name $method]
}

proc ticklecharts::typeOf {value} {
    # Guess the type of the value.
    # 
    # value - string (everything is string !!!)
    #
    # Returns type of value

    if {$value eq "nothing" || $value eq "null"} {
        return null
    }

    if {[string is double -strict $value] ||
        [string is integer -strict $value]} {
        return num
    }

    if {[string equal -nocase "true" $value] ||
        [string equal -nocase "false" $value]} {
        return bool
    }

    if {[ticklecharts::isListOfList $value]} {
        return list
    }

    if {[ticklecharts::isAObject $value]} {
        switch -glob -- [ticklecharts::typeOfClass $value] {
            *::jsfunc  {return jsfunc}
            *::eColor  {return e.color}
            *::eList   {return list.e}
            *::eDict   {return dict}
            *::eString {return str.e}
            *::eStruct {return struct}
        }
    }

    return str
}

proc ticklecharts::optsToEchartsHuddle {options} {
    # Transform a dict to echartshuddle format.
    # 
    # options - dict options
    #
    # Returns ehuddle format.
    if {[llength $options] % 2} ticklecharts::errorEvenArgs

    set opts {}

    foreach {key info} $options {
        lassign $info value type

        if {[string match "-*" $key]} {
            set key [string range $key 1 end]
        }
        set htype [ticklecharts::ehuddleType $type]

        switch -exact -- $type {
            dict {
                if {![ticklecharts::iseDictClass $value]} {
                    error "should be a 'eDict' class."
                }
                append opts [format " ${htype}=$key {%s}" \
                    [optsToEchartsHuddle [$value get]] \
                ]
            }
            list.o - elist.o {
                set l {}
                foreach val $value {
                    if {[lindex $val end] eq "list.o"} {
                        set lo {}
                        foreach vlo [join [lrange $val 0 end-1]] {
                            if {[ticklecharts::iseDictClass $vlo]} {
                                lappend lo [optsToEchartsHuddle [$vlo get]]
                            } elseif {[ticklecharts::iseStructClass $vlo]} {
                                lappend lo [optsToEchartsHuddle [$vlo get]]
                            } else {
                                lappend lo [optsToEchartsHuddle $vlo]
                            }
                        }
                        lappend l [list @A $lo]
                    } else {
                        if {[ticklecharts::iseDictClass $val]} {
                            lappend l [optsToEchartsHuddle [$val get]]
                        } elseif {[ticklecharts::iseStructClass $val]} {
                            lappend l [optsToEchartsHuddle [$val get]]
                        } else {
                            lappend l [optsToEchartsHuddle $val]
                        }
                    }
                }
                append opts [format " ${htype}=$key {%s}" [list @AO $l]]
            }
            list.st - list.s {
                append opts [format " ${htype}=$key {%s}" $value]
            }
            elist.st - elist.s {
                append opts [format " ${htype}=$key {%s}" [$value get]]
            }
            list.dt - list.d - list.nt - list.n {
                append opts [format " ${htype}=$key {%s}" [list $value]]
            }
            elist.dt - elist.d - elist.nt - elist.n {
                if {[$value lType] eq "elist.n"} {
                    set htype "@LPN"
                }
                append opts [format " ${htype}=$key {%s}" [list [$value get]]]
            }
            list.j {
                set l {}
                foreach val $value {
                    lappend l [optsToEchartsHuddle [list $key $val]]
                }
                append opts [format " ${htype}=$key {%s}" $l]
            }
            e.color - struct.d - struct.ld {
                append opts [format " ${htype}=$key {%s}" \
                    [optsToEchartsHuddle [$value get]] \
                ]
            }
            default {
                append opts [format " ${htype}=$key %s" $value]
            }
        }
    }

    return $opts
}

proc ticklecharts::setdef {d key args} {
    # Set dict definition with value type and default value.
    # An error exception is raised if args value is not found.
    # 
    # d    - dict
    # key  - dict key
    # args - type, default, version, validvalue, trace.
    #
    # Returns dictionary
    variable echarts_version
    variable wc_version
    variable gmap_version

    upvar 1 $d _dict

    # Distinguishes between the 3 libraries.
    set versionLib $echarts_version ; # for Echarts see ticklecharts.tcl
    set trace no

    foreach {k value} $args {
        switch -exact -- $k {
            -minWCversion {set minversion $value ; set versionLib $wc_version}
            -minGMversion {set minversion $value ; set versionLib $gmap_version}
            -minversion   {set minversion $value}
            -validvalue   {set validvalue $value}
            -type         {set type       $value}
            -trace        {set trace      $value}
            -default      {set default    $value}
            default       {error "Unknown key '$k' specified"}
        }
    }

    dict set _dict $key [list $default $type $validvalue $minversion $versionLib $trace]
}

proc ticklecharts::matchTypeOf {mytype type keyt} {
    # Guess type, follow optional list.
    # 
    # mytype - type
    # type   - list default type
    # keyt   - upvar key type
    #
    # Returns true if mytype is found, 
    # false otherwise.

    switch -exact -- $mytype {
        str.e {
            # If variable 'mytype' is a eString class,
            # replaces default values 'type' by new type.
            set type [join [lmap val [split $type "|"] {
                switch -exact -- $val {
                    str     {set val str.e}
                    str.t   {set val str.et}
                    default {set val}
                }
            }] "|"]
        }
        struct {
            # If variable 'mytype' is a eStruct class,
            # replaces default values 'type' by new type.
            upvar 1 value obj
            if {[catch {$obj sType} sType]} {
                error "wrong # args: $sType"
            }
            set mytype $sType
            set lmap [list struct $sType]
            set type [string map $lmap $type]
        }
        list.e {
            # If variable 'mytype' is a eList class,
            # replaces default values 'type' by new type.
            upvar 1 value obj
            if {[catch {$obj lType} lType]} {
                error "wrong # args: $lType"
            }
            set mytype $lType
            # Only valid for replace these type list.d, list.dt,
            # list.s, list.st, list.n or list.nt.
            switch -exact -- $lType {
                elist {
                    set type [string map [list "list" $lType] $type]
                }
                elist.d - elist.s - elist.n {
                    set lmap [list \
                        list.nt ${lType}t list.n $lType \
                        list.st ${lType}t list.s $lType \
                        list.dt ${lType}t list.d $lType \
                    ]
                    set type [string map $lmap $type]
                }
            }
        }
    }

    upvar 1 $keyt typekey

    foreach valtype [split $type "|"] {
        if {[string match $mytype* $valtype]} {
            set typekey $valtype
            return 1
        }
    }

    return 0
}

proc ticklecharts::keyCompare {d other} {
    # Compares the keys of dictionaries.
    # Output warning message if key name doesn't exist, 
    # in key default option.
    #
    # d      - dict
    # other  - list values
    #
    # Returns nothing

    if {$other eq "" || ![ticklecharts::isDict $other]} {
        return {}
    }

    set keys1 [dict keys $d]
    set limit 5 ; set j 1

    foreach k [dict keys $other] {
        # Special case for 'dummy' key for theming.
        if {[string match -nocase *dummy $k]} {continue}
        if {$k ni $keys1} {
            if {$j > $limit} {
                return -level [info level] -code error \
                    "The warning limit for key comparison has been exceeded."
            }
            set level    [expr {[info level] - 1}]
            set infoproc [ticklecharts::getLevelProperties $level]
            puts stderr "warning($infoproc): '$k' property is not in\
                        '[join [lsort -dict $keys1] ", "]' or not supported."
            incr j
        }
    }

    return {}
}

proc ticklecharts::merge {d other} {
    # Merge 2 dictionaries and control the type of value.
    # An error exception is raised if type of value doesn't match.
    #
    # d      - dict (default option(s))
    # other  - list values
    #
    # Returns a new dictionary
    variable minProperties

    # Output warning message if key name doesn't exist 
    # in key default option.
    ticklecharts::keyCompare $d $other

    set _dict [dict create]

    dict for {key info} $d {
        lassign $info value type validvalue minversion versionLib trace

        # Force string value for this keys below
        # if value is boolean or double.
        if {$key in {-id id -name name}} {
            if {[dict exists $other $key]} {
                set namevalue [dict get $other $key]
                # Force string representation.
                if {[ticklecharts::typeOf $namevalue] ni {str str.e null}} {
                    dict set other $key [new estr $namevalue]
                }
            }
        }

        # Several versions for same key.
        set multiversions 0
        if {[string match {*:*} $minversion]} {
            set multiversions 1
            set vtype [split $type ":"]
            set lvers [split $minversion ":"]

            if {[llength $lvers] != [llength $vtype]} {
                error "Each versions must matched with a type of keys."
            }

            if {[lsort -dictionary $lvers] ne $lvers} {
                error "Each versions must be in ascending order."
            }

            set i 0 ; set version "nothing" ; set save_v "0.0.0"
            foreach v $lvers {
                if {[ticklecharts::vCompare $v $versionLib] <= 0} {
                    # Replaces the type of key according to echarts key version
                    if {[ticklecharts::vCompare $v $save_v] >= 0} {
                        set version $v
                        set type [lindex $vtype $i]
                    }
                }
                set save_v $v
                incr i
            }
            # All versions were not found, probably 'ticklecharts::echarts_version'
            # variable version is lower.
            if {$version eq "nothing"} {
                puts stderr "warning(multi-versions): no versions found for '$key' property,\
                            it will not be taken into account."
                continue
            }
            set minversion $version
        }

        set vcompare [ticklecharts::vCompare $minversion $versionLib]

        if {[dict exists $other $key]} {

            if {$vcompare > 0} {
                puts stderr "warning(version): '$key' property is not supported with version\
                            '$versionLib' (minimum version = '$minversion'),\
                            it will not be taken into account."
                continue
            }

            # REMINDER ME: use 'dict remove' for this.
            if {$type in {dict|null dict list.o|null list.o}} {
                error "wrong # type: default values for type dict or list.o\
                       shouldn't not be defined in 'other' dict for '$key' key property."
            }

            set value  [dict get $other $key]
            set mytype [ticklecharts::typeOf $value]

            # Check type in default list
            if {![ticklecharts::matchTypeOf $mytype $type typekey]} {
                errorType "set" $key $mytype $type $minversion $multiversions
            }

            # Verification of certain values (especially for string types)
            ticklecharts::formatEcharts $validvalue $value $key $mytype

        } else {
            # Does not take this key, depending on the version used.
            if {$vcompare > 0} {continue}

            set mytype [ticklecharts::typeOf $value]

            # Check type in default list
            if {![ticklecharts::matchTypeOf $mytype $type typekey]} {
                errorType "default" $key $mytype $type $minversion $multiversions
            }
            # Minimum properties:
            # Only write values that are defined in the *.tcl file.
            # Be careful, properties in the *.tcl file must be implicitly marked.
            if {$minProperties} {
                if {
                    $key ni {-type -name -id} && $typekey ni {
                    dict list.o list.j str.t str.et list.st
                    elist.st elist.nt elist.dt list.dt
                    list.nt bool.t num.t
                    }
                } {continue}
            }
        }

        # Adds trace key.
        if {$trace} {
            ticklecharts::getTraceLevelProperties [info level] $key $value
        }

        # Replaces spaces by special characters.
        if {$typekey in {str str.t}} {
            set value [ticklecharts::mapSpaceString $value]
            if {$value eq ""} {
                # To avoid the incorrect number of arguments
                # error for the ehuddle class.
                set value "{}"
            }
        }

        dict set _dict $key [list $value $typekey]
    }

    return $_dict
}

proc ticklecharts::vCompare {version1 version2} {
    # Checking the version used, compared to the minimum version.
    #
    # version1 - num version
    # version2 - num version
    #
    # Returns -1 if 'version1' is an earlier version than 'version2',
    # 0 if they are equal, and 1 if 'version1' is later than 'version2'.

    if {$version1 eq ""} {
        return 0
    }

    return [package vcompare $version1 $version2]
}

proc ticklecharts::mapSpaceString {value} {
    # Replaces 'space' character by ascii 
    # character '\040' if defined.
    #
    # value - string
    #
    # Returns mapped string.
    return [string map {" " "\\040"} $value]
}

proc ticklecharts::isDict {value} {
    # Check if the value is a dictionary.
    #
    # value - dict
    #
    # Returns true, otherwise false.
    return [expr {![catch {dict size $value}]}]
}

proc ticklecharts::infoOptions {key {indent 0}} {
    # Gets default options according to key procedure.
    #
    # key    - dict
    # indent - format
    #
    # Returns default value and type.

    set key  [string map {"-" ""} $key]
    set body [split [info body ticklecharts::$key] "\n"]
    set listmap {"setdef" "" "options" ""}
    ldset {buffer ifnP copyifnP dataInfo} -to {}
    ldset {info switch} -to 0

    for {set i 0} {$i < [llength $body]} {incr i} {
        # Find command in body.
        set val [lindex $body $i]
        if {[string match {*infoNameProc*} $val]} {
            set info 1 ; set cmd {} ; set switch 0
            regsub -all {[{}\[\]]} $val {} map
            foreach index [lsearch -all $map *infoNameProc*] {
                lappend cmd [lindex $map $index+2]
            }
            set ifnP "**[join $cmd " || "]**"
            set cmd {}
        }

        if {[string match {*whichSeries*} $val]} {
            set info 1 ; set cmd {} ; set switch 0
            regsub -all {[{}\[\]]} $val {} map
            # case operator (in & eq).
            if {[string match {* in *} $val]} {
                foreach index [lsearch -all $map *whichSeries*] {
                    if {[lrange $map $index+3 end] eq ""} {
                        # find next line
                        regsub -all {[{}]} [lindex $body $i+1] {} mapb
                        if {[string match {*Series*} $mapb]} {lappend cmd $mapb}
                        continue
                    }
                    lappend cmd [lrange $map $index+3 end]
                }
                set ifnP "**[join {*}$cmd " || "]**"
                set cmd {}
            }
            if {[string match {* eq *} $val]} {
                foreach index [lsearch -all $map *whichSeries*] {
                    lappend cmd [lindex $map $index+3]
                }
                set ifnP "**[join $cmd " || "]**"
                set cmd {}
            }
            # case switch command.
            if {[string match {*switch*} $val]} {
                set switch 1
            }
        }

        if {$switch} {
            if {[string match {*Series\" \{*} $val] && 
               ![string match {*switch*} $val]} {
                regsub -all {[{}\[\]]} $val {} map
                foreach index [lsearch -all $map *Series*] {
                    lappend cmd [lindex $map $index]
                }
                set ifnP "**[join $cmd " || "]**"
                set cmd {}
            }
        }

        # append line body if command
        if {$info} {append buffer $val}

        # Guess if command is over.
        if {[info complete $buffer] && $buffer ne ""} {
            # omit if 'setdef' is not defined.
            if {[lsearch $buffer *setdef*] > -1} {
                lappend dataInfo [format "%${indent}s \}" ""]
            }
            ldset {buffer ifnP copyifnP} -to {}
            set info 0
        }

        if {[string match {*setdef*} $val]} {
            if {([string first "#" [string trim $val]] == -1) && 
                [string match {*\[ticklecharts::*} $val]} {
                set str [string range $val 0 [expr {[string first "-default" $val] - 1}]]
                set map [string trim [string map $listmap $str]]

                if {$ifnP ne ""} {
                    if {$ifnP ne $copyifnP} {
                        lappend dataInfo [format "%${indent}s %s \{" "" $ifnP]
                    }
                    set newIndent [expr {$indent - 4}]
                    lappend dataInfo [format "%${newIndent}s %s" "" $map]
                } else {
                    lappend dataInfo [format "%${indent}s %s" "" $map]
                }

                # bug 'infinite loop?'. Add test to get if $match is not equal to current $key (name proc)
                if {[regexp {ticklecharts::([A-Za-z0-9]+)\s} $val -> match] && $match ne $key} {
                    lappend dataInfo [ticklecharts::infoOptions $match [expr {$indent - 2}]]
                }
            } else {
                set map [string trim [string map $listmap $val]]
                if {$ifnP ne ""} {
                    if {$ifnP ne $copyifnP} {
                        lappend dataInfo [format "%${indent}s %s \{" "" $ifnP]
                    }
                    set newIndent [expr {$indent - 4}]
                    lappend dataInfo [format "%${newIndent}s %s" "" $map]
                } else {
                    lappend dataInfo [format "%${indent}s %s" "" $map]
                }
            }

            set copyifnP $ifnP
        }
    }

    return [join $dataInfo "\n"]
}

proc ticklecharts::infoNameProc {levelP name} {
    # Gets name of proc follow level.
    #
    # levelP - properties
    # name   - Name to be found in properties
    #
    # Returns true if name match with current 
    # level properties, false otherwise.

    return [string match $name $levelP]
}

proc ticklecharts::echartsOptsTheme {name} {
    # Gets default theme value
    #
    # name   - name theme option
    #
    # Returns value.
    variable opts_theme

    return [dict get $opts_theme $name]
}

proc ticklecharts::keysOptsThemeExists {name} {
    # Gets if key theme exists.
    #
    # name   - name theme option
    #
    # Returns true, false otherwise.
    variable opts_theme

    return [dict exists $opts_theme $name]
}

proc ticklecharts::keyDictExists {basekey d key} {
    # Check if key exists in dict.
    #
    # d   - dict
    # key - upvar name
    #
    # Returns true if key name exists,
    # false otherwise.

    upvar 1 $key name

    foreach bkey [list $basekey [format {-%s} $basekey]] {
        if {[dict exists $d $bkey]} {
            set name $bkey
            return 1
        }
    }

    return 0
}

proc ticklecharts::getValue {value key} {
    # Get the value of key.
    # Raise an error if item value is not even.
    #
    # value - dict value
    # key   - key item value
    #
    # Returns dict value.

    set d [dict get $value $key]

    if {[llength $d] % 2} {
        uplevel 1 [list ticklecharts::errorEvenArgs $key]
    }

    return $d
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

proc ticklecharts::keyValueIsListOfList {value key} {
    # Checks if key 'value' is of type list of list.
    #
    # value - list options
    # key   - key option
    #
    # Returns true if key value is a list of list,
    # false otherwise.

    set lflag [lsearch $value *$key*]
    set range [lindex $value $lflag+1]

    return [ticklecharts::isListOfList $range]
}

proc ticklecharts::isListOfList {args} {
    # Checks if the 'value' is of type list of list.
    #
    # args - list
    #
    # Returns true if value is a list of list,
    # false otherwise.

    # Cleans up the list of braces, spaces.
    regsub -all -line {(^\s+)|(\s+$)|\n|\t} $args {} str

    return [expr {
            [string range $str 0 1] eq "\{\{" &&
            [string range $str end-1 end] eq "\}\}"
        }
    ]
}

proc ticklecharts::uuid {} {
    # source   : https://stackoverflow.com
    # question : how-do-i-create-a-guid-uuid
    # Ported from javascript to Tcl
    #
    # Returns a Universally Unique IDentifier.
    set d    [clock seconds]
    set d2   [clock microseconds]
    set uuid {}

    set template "xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx"

    foreach c [split $template ""] {
        if {$c == "4"} {
            append uuid $c ; continue
        }
        set r [expr {int(rand() * 16)}]
        if {$d > 0} {
            set r [expr {($d + $r) % 16 | 0}]
            set d [expr {int($d / 16.)}]
        } else {
            set r  [expr {($d2 + $r) % 16 | 0}]
            set d2 [expr {int($d2 / 16.)}]
        }

        if {$c eq "x"} {
            append uuid [format %x $r]
        } else {
            append uuid [format %x [expr {$r & 0x3 | 0x8}]]
        }
    }

    return $uuid
}

proc ticklecharts::getLevelProperties {level} {
    # Gets name level procedure
    #
    # level - num level procedure
    #
    # Returns list name of procs.
    set properties {}

    for {set i $level} {$i > 0} {incr i -1} {
        set name [lindex [info level $i] 0]
        if {[string match {ticklecharts::*} $name]} {
            set property [string map {ticklecharts:: ""} $name]
            if {$property ni $properties} {
                lappend properties $property
            }
        }
    }

    return [join [lreverse $properties] "."]
}

proc ticklecharts::checkJsFunc {opts method} {
    # Guess if options contains a function, variable
    # javascript for 'self method'.
    #
    # opts   - list options
    # method - name method
    #
    # Returns nothing if my list contains no
    # javascript code, an error otherwise.

    set map [string map {"{" "" "}" ""} $opts]

    foreach index [lsearch -all $map @JS=*] {
        set value [lindex $map $index+1]
        switch -glob -- [$value get] {
            *function* -
            *new*echarts.* {
                return -level [info level] -code error \
                    "wrong # js: 'function', 'variable', etc.\
                    inside 'Json data' is not\
                    supported with '$method' method."
            }
        }
    }

    return {}
}

proc ticklecharts::procDefaultValue {proc key} {
    # Gets default procedure key value 
    #
    # proc - name procedure
    # key  - dict key
    #
    # Returns default key value or 'nothing'.

    set myProc [split [info body ticklecharts::$proc] \n]

    if {[set lineProc [lsearch $myProc *$key*]] > -1} {
        set opts [lindex $myProc $lineProc]
        if {[set d [lsearch -exact $opts -default]] > -1} {
            set value [lindex $opts $d+1]
            # Special case when default value is an variable.
            if {[string range $value 0 0] eq "$"} {
                set var   [string range $value 1 end]
                set value [uplevel 1 [list set $var]]
            }
            return $value
        }
    }

    return {}
}

proc ticklecharts::whichSeries? {levelP} {
    # Returns name series (I hope so !).

    return [lindex [split $levelP "."] 0]
}

proc ticklecharts::IsItTrue? {key args} {
    # Remove properties if key is set to false.
    #
    # key  - dict key
    # args - see below
    #
    # Returns nothing.
    variable minProperties

    if {$minProperties} {return {}}

    foreach {k info} $args {
        switch -exact -- $k {
            -value   {upvar 1 $info value}
            -dopts   {upvar 1 $info options}
            -remove  {set opts $info}
            default  {error "Unknown key '$k' specified"}
        }
    }

    set isTrue 1
    # The 'key' should be present in the both dictionaries.
    if {[dict exists $value $key] && [dict exists $options $key]} {
        set val [dict get $value $key]
        if {([ticklecharts::typeOf $val] eq "bool") && !$val} {
            set isTrue 0
        }
    }

    # Checks whether the default value for
    # the 'key' is also set to false.
    if {$isTrue} {
        if {[dict exists $options $key] && ![dict exists $value $key]} {
            set val [lindex [dict get $options $key] 0]
            if {([ticklecharts::typeOf $val] eq "bool") && !$val} {
                set isTrue 0
            }
        }
    }

    # Set keys to nothing for default dictionary 
    # if 'opts' variable is equal to 'not_needed'.
    # Remove keys if the opts value contains a list of keys to be removed.
    if {!$isTrue} {
        if {$opts eq "not_needed"} {
            set kopts   [dict keys $options]
            set delkeys [lsearch -inline -all -not -exact $kopts $key]
            foreach k $delkeys {
                if {[dict exists $value $k]} {continue}
                dict set options $k {nothing null {} {} {} no}
            }
        } else {
            set value   [dict remove $value   {*}$opts]
            set options [dict remove $options {*}$opts]
        }
    }

    return {}
}

proc ticklecharts::isURL? {url} {
    # Checks whether the url is valid.
    #
    # url - string
    #
    # Returns true if url is valid,
    # false otherwise.
    return [regexp {^(https:|http:|www\.)\S*} $url]
}

proc ticklecharts::urlExists? {url} {
    # Checks whether the url exists, when 'checkURL' variable
    # is set to True. 'curl' util for testing.
    # I suppose if available for all platforms.
    # Platform tested :
    # - Windows 10
    # - MacOS
    #
    # url - string
    #
    # Returns nothing if is Ok, a warning message if url 
    # doesn't exists or 'curl' util is not defined.

    # no download...
    # source : https://stackoverflow.com/
    # Question : how-to-check-if-an-url-exists-with-the-shell-and-probably-curl
    set cmd [list curl --silent --head --fail $url]
    if {[catch {exec {*}$cmd 2>@1} msg]} {
        puts stderr "warning(url): $msg"
    }

    return {}
}

proc ticklecharts::errorEvenArgs {{k "nothing"}} {
    # Error number of elements.
    #
    # k - optional value indicates the value of the key.
    # 
    # Raise an error.
    set level  [uplevel 1 {info level}]
    set levelP [ticklecharts::getLevelProperties $level]

    set msg "wrong # args: item list for\
            '$levelP' must have an even number of elements."

    if {$k ne "nothing"} {
        set proc [lindex [split $levelP "."] end]
        set itemList "False"
        if {[string match {-*Item} $k] || [string match {*Item} $proc]} {
            set itemList "True"
        }

        set hmsg [ticklecharts::infoErrorProc $proc $k $itemList]
        if {$hmsg ne ""} {
            set msg "wrong # args: item list for\
                    '$levelP' should be a dictionary format : $hmsg"
        }
    }

    return -level [info level] -code error $msg
}

proc ticklecharts::infoErrorProc {body k itemList} {
    # Try to provide more information on errors.
    #
    # body     - procedure.
    # k        - value of the key.
    # itemList - indicates whether it's a list of list.
    # 
    # Returns a message as a string.
    ldset {opts msg} -to {}

    if {[catch {info body $body} procBody]} {
        return {}
    }

    foreach line [split $procBody "\n"] {
        set line [string trim $line]
        if {
            [string match {setdef *} $line] ||
            [string match {*::setdef *} $line]
        } {
            set info [lindex $line 2]
            if {$info ni {id -id}} {
                lappend opts [lindex $line 2]
                if {[llength $opts] > 2} {break}
            }
        }
    }

    if {[llength $opts]} {
        # Format message.
        if {$itemList} {
            set start "$k \{"
            set end   "...\} \{...\}"
        } else {
            set start "$k "
            set end   "..."
        }

        foreach var $opts {
            if {[string index $var 0] ne "-"} {
                set start "$start\{"
                set end   "$end\}"
                break
            }
        }

        append msg $start
        foreach var $opts {
            append msg "?'$var' ?value "
        }
        set msg [string trim $msg]
        append msg $end
    }

    return $msg
}

proc ticklecharts::errorKeyArgs {property value} {
    # Error key item.
    #
    # property - name key
    # value    - name
    #
    # Raise an error.
    set level  [uplevel 1 {info level}]
    set levelP [ticklecharts::getLevelProperties $level]

    return -level [info level] \
           -code error "wrong # args: key '$value' must be defined\
                        in item property '$property' for '$levelP'."
}

proc ::oo::Helpers::classvar {name} {
    # Class variable
    # Link the caller’s locals to the class’s variables.
    # source : https://wiki.tcl-lang.org/page/TclOO+Tricks
    #
    # name - variable
    #
    # Returns nothing
    set ns [uplevel 1 {my getONSClass}]
    set vs [list $name $name]

    tailcall namespace upvar $ns {*}$vs

    return {}
}

if {[ticklecharts::vCompare [package present Tcl] 8.7] < 0} {
    proc ::oo::Helpers::callback {method args} {
        # Callbacks method.
        # source : https://wiki.tcl-lang.org/page/TclOO+Tricks
        list [uplevel 1 {namespace which my}] $method {*}$args
    }
}

proc ticklecharts::unsetVars {obj} {
    # Deletes all variables when the current script
    # is sourced.
    #
    # obj - object
    #
    # Returns nothing
    if {[$obj getType] in {timeline gridlayout}} {
        foreach ch [$obj charts] {
            ticklecharts::unsetVars $ch
        }
    } else {
        set cNs [$obj getONSClass]
        unset {*}[info vars ${cNs}::*]
    }

    return {}
}

proc ticklecharts::isSourced {script} {
    # Checks if current script is sourced.
    #
    # script - current script
    #
    # Returns true if current script is sourced,
    # false otherwise.
    return [expr {
        [info exists ::argv0] &&
        !([file tail $script] eq [file tail $::argv0])
    }]
}

proc ticklecharts::itemKey {keySeries value} {
    # Find item key property.
    #
    # keySeries - list item keys
    # value     - dict
    #
    # Returns the name of key if found, 
    # otherwise nothing.
    foreach key $keySeries {
        if {[dict exists $value $key]} {
            return $key
        }
    }

    return {}
}

proc ticklecharts::ldset {varList to default} {
    # Defines the default value in a variable list.
    #
    # varList  - list variables
    # to       - not used
    # default  - default value
    #
    # Returns nothing.
    foreach var $varList {
        upvar $var variable
        set variable $default
    }

    return {}
}

proc ticklecharts::errorType {what key mytype type minversion multiversions} {
    # Error message for incorrect type.
    #
    # what           - message type
    # key            - dict key
    # mytype         - type found by the typeOf function
    # type           - default list type (*|*)
    # minversion     - minimum version
    # multiversions  - boolean value for multi-versions
    #
    # Throws an error.
    set type [string map {.t "" .st ".s" .dt ".d" .nt ".n"} $type]
    switch -exact -- $mytype {
        str.e  {set mytype "str"}
        list.e {
            upvar 1 value obj
            if {[catch {$obj lType} mytype]} {
                error "wrong # etype($what) : $mytype"
            }
        }
    }

    # Info level procedure.
    set level  [info level]
    set levelP [ticklecharts::getLevelProperties $level]

    # Reformats the default list 'type' for easier reading.
    set t [split $type "|"]
    if {[llength $t] > 1} {
        set type [format {%s or %s} \
            [join [lrange $t 0 end-1] ", "] [lindex $t end] \
        ]
    }

    if {$multiversions} {
        return -level $level -code error "wrong # etype($what): property '$key'\
            for this '$minversion' version should be '$type' instead of '$mytype'\
            in '$levelP' level procedure."
    } else {
        return -level $level -code error "wrong # etype($what): property '$key'\
            should be '$type' instead of '$mytype' for '$levelP' level procedure."
    }
}