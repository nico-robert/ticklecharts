# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

# timeline class, which provides functions like switching and playing
# between multiple ECharts options.

oo::class create ticklecharts::timeline {
    variable _h          ; # huddle
    variable _data       ; # list data value
    variable _charts     ; # list charts
    variable _opts       ; # list options timeline
    variable _baseOption ; # list base options timeline
    variable _options    ; # list charts options timeline
    variable _jschartvar ; # js variable chart

    constructor {args} {
        # Initializes a new timeline Class.
        #
        # args - Options described below.
        #
        # -theme  - name theme see : theme.tcl
        #
        ticklecharts::setTheme $args ; # theme options
        set _data       {}
        set _charts     {}
        set _opts       {}
        set _baseOption {}
        set _options    {}
    }
}

oo::define ticklecharts::timeline {

    method getType {} {
        # Returns type.
        return "timeline"
    }

    method charts {} {
        # Gets list charts.
        return $_charts
    }

    method baseOption {} {
        # Gets list base options.
        return $_baseOption
    }

    method track {} {
        # Compares properties.
        #
        # Returns nothing
        foreach chart [my charts] {
            $chart track
        }
        return {}
    }

    method SetOptions {args} {
        # options : https://echarts.apache.org/en/option.html#timeline
        #
        # args - Options described in proc ticklecharts::timelineOpts below.
        #
        # Returns nothing

        if {[llength $args] % 2} {
            error "wrong # args: [self] SetOptions \$args must have\
                   an even number of elements."
        }

        set _opts {}
        lappend _opts "@L=timeline" [ticklecharts::timelineOpts $args]

        return {}
    }

    method Add {chart args} {
        # Add data dict to timeline options.
        #
        # Returns nothing

        if {![llength $args]} {
             error "wrong # args: 'timeline' arguments should not be equal\
                    to 0 for the 'Add' method."
        }

        if {[$chart getType] ni {chart chart3D gridlayout}} {
            error "wrong # args: First argument for 'Add' method\
                   should be a 'chart', 'chart3D' or 'gridlayout' class."
        }

        lappend _data [ticklecharts::timelineItem $args]
        lappend _charts $chart

        return {}
    }

    method ToHuddle {} {
        # Transform list to ehudlle.
        #
        # Returns nothing

        # init ehuddle.
        set _h [ticklecharts::ehuddle new]

        # timeline data
        set key      [lindex $_opts 0]
        set dataopts [lindex $_opts 1]

        # Insert data to timeline options
        lappend timeline_opts $key [linsert \
            $dataopts end {*}[format "-data {{%s} list.o}" $_data] \
        ]

        # Retrieves global option keys and deletes them.
        set optsglob [ticklecharts::globalOptions {}]
        set keysoptsglob [dict keys [ticklecharts::optsToEchartsHuddle [$optsglob get]]]

        # Add keys from 'SetOptions' ticklecharts::chart* method
        foreach class {"chart" "chart3D"} {
            lappend infomethod [lindex [ticklecharts::classDef $class SetOptions] 1]
        }
        foreach linebody [split $infomethod "\n"] {
            if {[string match {*@*} $linebody]} {
                set keyopts [lindex $linebody 2]
                set hType [string range $keyopts 0 2]
                if {$hType in {@D= @L=}} {
                    lappend keysoptsglob $keyopts
                }
            }
        }

        # Gets the first chart.
        set optschart [[lindex [my charts] 0] options]

        # Removes keys global for 'baseOption'.
        set _baseOption {}
        foreach {key value} $optschart {
            if {$key in $keysoptsglob} {
                continue
            }
            lappend _baseOption $key $value
        }

        # Add 'timeline' options to huddle 'baseOption'.
        foreach {key value} $timeline_opts {
            set f [ticklecharts::optsToEchartsHuddle $value]
            lappend _baseOption $key [list {*}$f]
        }
        # Add 'baseOption' key.
        $_h append "@L=baseOption" $_baseOption

        # Add all charts to 'option' key.
        set _options {}
        foreach chart [my charts] {
            set option {}
            foreach {key value} [$chart options] {
                lappend option $key $value
            }
            $_h append "@D=options" $option
            lappend _options $option
        }

        return {}
    }

    # Copy shared methods definition from 'ticklecharts::chart' class :
    #
    #   Render  - Export timeline html.
    #   toHTML  - Export chart as HTML fragment.
    #   toJSON  - Returns json timeline data.
    #   get     - Gets huddle object.
    #   options - Gets chart(s) list options.
    # ...
    foreach method {Render toHTML toJSON get options} {
        method $method {*}[ticklecharts::classDef "chart" $method]
    }

    # export of methods
    export Add SetOptions Render

}

proc ticklecharts::timelineOpts {value} {
    # timeline options.
    #
    # Returns dict options

    setdef options -show              -minversion 5  -validvalue {}                      -type bool             -default "True"
    setdef options -type              -minversion 5  -validvalue formatTimelineType      -type str              -default "slider"
    setdef options -axisType          -minversion 5  -validvalue formatTimelineAxisType  -type str              -default "time"
    setdef options -currentIndex      -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options -autoPlay          -minversion 5  -validvalue {}                      -type bool|null        -default "nothing"
    setdef options -rewind            -minversion 5  -validvalue {}                      -type bool|null        -default "nothing"
    setdef options -loop              -minversion 5  -validvalue {}                      -type bool             -default "True"
    setdef options -playInterval      -minversion 5  -validvalue {}                      -type num              -default 1000
    setdef options -realtime          -minversion 5  -validvalue {}                      -type bool             -default "True"
    setdef options -replaceMerge      -minversion 5  -validvalue formatTimelineMerge     -type str|list.s|null  -default "nothing"
    setdef options -controlPosition   -minversion 5  -validvalue formatTimelinePosition  -type str              -default "left"
    setdef options -width             -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options -zlevel            -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options -z                 -minversion 5  -validvalue {}                      -type num              -default 2
    setdef options -left              -minversion 5  -validvalue formatLeft              -type str|num|null     -default "nothing"
    setdef options -top               -minversion 5  -validvalue formatTop               -type str|num|null     -default "nothing"
    setdef options -right             -minversion 5  -validvalue formatRight             -type str|num|null     -default "nothing"
    setdef options -bottom            -minversion 5  -validvalue formatBottom            -type str|num|null     -default "nothing"
    setdef options -padding           -minversion 5  -validvalue {}                      -type num|list.n       -default 5
    setdef options -orient            -minversion 5  -validvalue formatOrient            -type str              -default "horizontal"
    setdef options -inverse           -minversion 5  -validvalue {}                      -type bool|null        -default "nothing"
    setdef options -itemSymbol        -minversion 5  -validvalue formatItemSymbol        -type str|null         -default "emptyCircle"
    setdef options -symbolSize        -minversion 5  -validvalue {}                      -type num|list.n       -default 10
    setdef options -symbolRotate      -minversion 5  -validvalue {}                      -type num|null         -default "nothing"
    setdef options -symbolKeepAspect  -minversion 5  -validvalue {}                      -type bool|null        -default "nothing"
    setdef options -symbolOffset      -minversion 5  -validvalue {}                      -type list.n|null      -default "nothing"
    setdef options -lineStyle         -minversion 5  -validvalue {}                      -type dict|null        -default [ticklecharts::lineStyle $value]
    setdef options -label             -minversion 5  -validvalue {}                      -type dict|null        -default [ticklecharts::label $value]
    setdef options -itemStyle         -minversion 5  -validvalue {}                      -type dict|null        -default [ticklecharts::itemStyle $value]
    setdef options -checkpointStyle   -minversion 5  -validvalue {}                      -type dict|null        -default [ticklecharts::checkPointStyle $value]
    setdef options -controlStyle      -minversion 5  -validvalue {}                      -type dict|null        -default [ticklecharts::controlStyle $value]
    setdef options -progress          -minversion 5  -validvalue {}                      -type dict|null        -default [ticklecharts::progress $value]
    setdef options -emphasis          -minversion 5  -validvalue {}                      -type dict|null        -default [ticklecharts::emphasis $value]
    #...

    # remove key(s)...
    set value [dict remove $value -lineStyle -label -itemStyle \
                                  -checkpointStyle -controlStyle \
                                  -progress -emphasis]

    set options [merge $options $value]

    return $options
}

proc ticklecharts::timelineItem {value} {
    # timeline item options.
    #
    # Returns dict options

    if {[llength $value] % 2} {
        ticklecharts::errorEvenArgs
    }

    if {![dict exists $value -data]} {
        error "wrong # args: Property '-data' not defined for\
              '[ticklecharts::getLevelProperties [info level]]'"
    }

    set d [dict get $value -data]

    if {![dict exists $d value]} {
        ticklecharts::errorKeyArgs -data value
    }

    # Force string value for this key below.
    set typeOf [ticklecharts::typeOf [dict get $d value]]
    if {$typeOf ni {str str.e}} {
        dict set d value [new estr [dict get $d value]]
    }

    setdef options value       -minversion 5  -validvalue {}               -type str|null    -default "nothing"
    setdef options symbol      -minversion 5  -validvalue formatItemSymbol -type str|null    -default "nothing"
    setdef options symbolSize  -minversion 5  -validvalue {}               -type num|null    -default "nothing"
    setdef options tooltip     -minversion 5  -validvalue {}               -type dict|null   -default [ticklecharts::tooltip $d]

    # remove key(s)...
    set d [dict remove $d tooltip]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::istimelineClass {value} {
    # Check if value is timeline class.
    #
    # value - obj or string
    #
    # Returns true if 'value' is a timeline class, 
    # false otherwise.
    return [expr {
            [ticklecharts::isAObject $value] && 
            [string match "*::timeline" [ticklecharts::typeOfClass $value]]
        }
    ]
}
