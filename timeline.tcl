# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

# timeline class, which provides functions like switching and playing
# between multiple ECharts options.

oo::class create ticklecharts::timeline {
    superclass ticklecharts::chart

    variable _base    ; # huddle
    variable _data    ; # list data value
    variable _charts  ; # list charts
    variable _opts    ; # list options timeline

    constructor {args} {
        # Initializes a new timeline Class.
        #
        # args - Options described below.
        #
        # -theme  - name theme see : theme.tcl
        #
        ticklecharts::setTheme $args ; # theme options
        set _data    {}
        set _charts  {}
        set _opts    {}
    }
}

oo::define ticklecharts::timeline {

    method getType {} {
        # Returns type
        return "timeline"
    }

    method get {} {
        # Gets huddle object
        return $_base
    }

    method charts {} {
        # Gets list charts.
        return $_charts
    }

    method SetOptions {args} {
        # options : https://echarts.apache.org/en/option.html#timeline
        #
        # args - Options described in proc ticklecharts::timelineOpts below.
        #
        # Returns nothing

        set _opts {}
        lappend _opts "@L=timeline" [ticklecharts::timelineOpts $args]

        return {}
    }

    method Add {chart args} {
        # Add data dict to timeline options
        #
        # Returns nothing

        if {[llength $args] == 0} {
             error "wrong # args: timeline arguments should not be equal\
                                  to 0 for the 'Add' method."
        }

        if {![expr {[$chart getType] eq "chart" || [$chart getType] eq "chart3D" ||
                    [$chart getType] eq "gridlayout"}]} {
            error "First argument for 'Add' method should be a 'chart',\
                  'chart3D' or 'gridlayout' class."
        }

        lappend _data [ticklecharts::timelineItem $args]
        lappend _charts $chart

        return {}
    }

    method timelineToHuddle {} {
        # Transform list to ehudlle
        #
        # Returns nothing

        # init ehuddle.
        set _base [ticklecharts::ehuddle new]

        # timeline data
        set key      [lindex $_opts 0]
        set dataopts [lindex $_opts 1]

        # Insert data to timeline options
        lappend timeline_opts $key [linsert $dataopts end {*}[format "-data {{%s} list.o}" $_data]]

        # get keys from global options & remove...
        set optsglob [ticklecharts::globalOptions {}]
        set keysoptsglob [dict keys [ticklecharts::optsToEchartsHuddle [$optsglob get]]]

        # add keys from 'SetOptions' ticklecharts::chart*  method
        lappend infomethod [lindex [info class definition ticklecharts::chart   "SetOptions"] 1]
        lappend infomethod [lindex [info class definition ticklecharts::chart3D "SetOptions"] 1]
        foreach linebody [split $infomethod "\n"] {
            if {[string match {*@*} $linebody]} {
                set keyopts [lindex $linebody 2]
                if {[string range $keyopts 0 2] eq "@D=" || [string range $keyopts 0 2] eq "@L="} {
                    lappend keysoptsglob $keyopts
                }
            }
        }

        # get first chart
        set optschart [[lindex $_charts 0] options]

        # remove keys global for baseOption...
        foreach {key value} $optschart {
            if {$key in $keysoptsglob} {
                continue
            }
            lappend baseOption $key $value
        }

        # add timeline options to huddle baseOption.
        foreach {key value} $timeline_opts {
            set f [ticklecharts::optsToEchartsHuddle $value]
            lappend baseOption $key [list {*}$f]
        }
        # Add baseOption
        $_base append "@L=baseOption" $baseOption

        # add all charts to 'option' key
        foreach chart [my charts] {
            set option {}

            foreach {key value} [$chart options] {
                lappend option $key $value
            }

            $_base append "@D=options" $option
        }

        return {}
    }

    method toJSON {} {
        # Returns json timeline data.
        my timelineToHuddle ; # transform to huddle

        # ehuddle jsondump
        return [[my get] toJSON]
    }

    method RenderTsb {args} {
        # Export chart to Taygete Scrap Book.
        # https://www.androwish.org/home/dir?name=undroid/tsb
        #
        # Be careful the tsb.tcl file should be sourced...
        #
        # args - Options described below.
        #
        # -renderer - 'canvas' or 'svg'
        # -height   - size html canvas
        # -merge    - If false, all of the current components
        #             will be removed and new components will
        #             be created according to the new option.
        #             (false by default)
        # -evalJSON - Two possibilities 'JSON.parse' or 'eval' 
        #             to insert an JSON obj in Tsb Webview.
        #             'eval' JSON obj is not recommended (security reasons).
        #             JSON.parse is safe but 'function', 'js variable'
        #             in JSON obj are not supported.
        #             (false by default)
        #
        # Returns nothing.

        # superclass ticklecharts::chart
        next {*}$args
    }

    method Render {args} {
        # Export chart to html.
        #
        # args - Options described below.
        #
        # -title      - header title html
        # -width      - container's width
        # -height     - container's height
        # -renderer   - 'canvas' or 'svg'
        # -jschartvar - name chart var
        # -divid      - name id var
        # -outfile    - full path html (by default in [info script]/render.html)
        # -jsecharts  - full path echarts.min.js (by default cdn script)
        # -jsvar      - name js var
        # -script     - list data (jsfunc), jsfunc.
        # -class      - container.
        # -style      - css style.
        # -template   - template (file or string).
        #
        # Returns full path html file.

        # superclass ticklecharts::chart
        next {*}$args
    }

    # export of methods
    export Add SetOptions Render RenderTsb

}

proc ticklecharts::timelineOpts {value} {
    # timeline options
    #
    # Returns dict options

    if {[llength $value] % 2} {
        error "\[self\] SetOptions \$value must have an even number of elements..."
    }

    setdef options -show                -minversion 5  -validvalue {}                      -type bool                 -default "True"
    setdef options -type                -minversion 5  -validvalue formatTimelineType      -type str                  -default "slider"
    setdef options -axisType            -minversion 5  -validvalue formatTimelineAxisType  -type str                  -default "time"
    setdef options -currentIndex        -minversion 5  -validvalue {}                      -type num|null             -default "nothing"
    setdef options -autoPlay            -minversion 5  -validvalue {}                      -type bool|null            -default "nothing"
    setdef options -rewind              -minversion 5  -validvalue {}                      -type bool|null            -default "nothing"
    setdef options -loop                -minversion 5  -validvalue {}                      -type bool                 -default "True"
    setdef options -playInterval        -minversion 5  -validvalue {}                      -type num                  -default 1000
    setdef options -realtime            -minversion 5  -validvalue {}                      -type bool                 -default "True"
    setdef options -replaceMerge        -minversion 5  -validvalue formatTimelineMerge     -type str|list.s|null      -default "nothing"
    setdef options -controlPosition     -minversion 5  -validvalue formatTimelinePosition  -type str                  -default "left"
    setdef options -width               -minversion 5  -validvalue {}                      -type num|null             -default "nothing"
    setdef options -zlevel              -minversion 5  -validvalue {}                      -type num|null             -default "nothing"
    setdef options -z                   -minversion 5  -validvalue {}                      -type num                  -default 2
    setdef options -left                -minversion 5  -validvalue formatLeft              -type str|num|null         -default "nothing"
    setdef options -top                 -minversion 5  -validvalue formatTop               -type str|num|null         -default "nothing"
    setdef options -right               -minversion 5  -validvalue formatRight             -type str|num|null         -default "nothing"
    setdef options -bottom              -minversion 5  -validvalue formatBottom            -type str|num|null         -default "nothing"
    setdef options -padding             -minversion 5  -validvalue {}                      -type num|list.n           -default 5
    setdef options -orient              -minversion 5  -validvalue formatOrient            -type str                  -default "horizontal"
    setdef options -inverse             -minversion 5  -validvalue {}                      -type bool|null            -default "nothing"
    setdef options -itemSymbol          -minversion 5  -validvalue formatItemSymbol        -type str|null             -default "emptyCircle"
    setdef options -symbolSize          -minversion 5  -validvalue {}                      -type num|list.n           -default 10
    setdef options -symbolRotate        -minversion 5  -validvalue {}                      -type num|null             -default "nothing"
    setdef options -symbolKeepAspect    -minversion 5  -validvalue {}                      -type bool|null            -default "nothing"
    setdef options -symbolOffset        -minversion 5  -validvalue {}                      -type list.n|null          -default "nothing"
    setdef options -lineStyle           -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::lineStyle $value]
    setdef options -label               -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::label $value]
    setdef options -itemStyle           -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::itemStyle $value]
    setdef options -checkpointStyle     -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::checkPointStyle $value]
    setdef options -controlStyle        -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::controlStyle $value]
    setdef options -progress            -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::progress $value]
    setdef options -emphasis            -minversion 5  -validvalue {}                      -type dict|null            -default [ticklecharts::emphasis $value]
    #...

    # remove key(s)...
    set value [dict remove $value -lineStyle -label -itemStyle \
                                      -checkpointStyle -controlStyle \
                                      -progress -emphasis]

    set options [merge $options $value]

    return $options
}

proc ticklecharts::timelineItem {value} {
    # timeline item options
    #
    # Returns dict options

    if {[llength $value] % 2} {
        ticklecharts::errorEvenArgs
    }

    if {![dict exists $value -data]} {
        error "Property '-data' not defined for\
              '[ticklecharts::getLevelProperties [info level]]'"
    }

    set d [dict get $value -data]

    if {![dict exists $d value]} {
        ticklecharts::errorKeyArgs -data value
    }

    # force string value for this key below
    # with 'eString' class.
    set typeOf [ticklecharts::typeOf [dict get $d value]]
    if {$typeOf ne "str"} {
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
    # Check if value is timeline class
    #
    # value - obj or string
    #
    # Returns true if 'value' is a timeline class, false otherwise.
    return [expr {
            [ticklecharts::isAObject $value] && 
            [string match "*::timeline" [ticklecharts::typeOfClass $value]]
        }
    ]
}
