# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

# timeline class, which provides functions like switching and playing
# between multiple ECharts options.

oo::class create ticklecharts::timeline {
    variable _base    ; # huddle
    variable _data    ; # list data value
    variable _charts  ; # list charts
    variable _opts    ; # list options timeline

    constructor {args} {
        # Initializes a new timeline Class.
        set opts_theme [ticklecharts::theme $args]
        set _data    {}
        set _charts  {}
        set _opts    {}
    }
}

oo::define ticklecharts::timeline {
    
    method gettype {} {
        # Returns type
        return "timeline"
    }

    method get {} {
        # Gets huddle object
        return $_base
    }

    method SetOptions {args} {
        # options : https://echarts.apache.org/en/option.html#timeline
        #
        # args - Options described in proc ticklecharts::timelineOpts below.
        #
        # return nothing

        set _opts {}
        lappend _opts "@L=timeline" [ticklecharts::timelineOpts $args]

        return {}
    }

    method Add {chart args} {
        # Add data dict to timeline options
        #
        # return nothing

        if {[llength $args] == 0} {
            error "data should be present... for timeline option"
        }

        if {![expr {[$chart gettype] eq "chart" || [$chart gettype] eq "gridlayout"}]} {
            error "first argument for 'Add' method should be a 'chart' or 'gridlayout' class."
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
        set optsglob [ticklecharts::globaloptions {}]
        set keysoptsglob [dict keys [ticklecharts::optsToEchartsHuddle $optsglob]]

        # add keys from 'SetOptions' ticklecharts::chart  method
        set infomethod [lindex [info class definition ticklecharts::chart "SetOptions"] 1]
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
        foreach chart $_charts {
            set optschart [$chart options]

            set option {}

            foreach {key value} $optschart {
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

    method render {args} {
        # Export chart to html.
        #
        # args - Options described below.
        #
        # -title      - header title html
        # -width      - size html canvas
        # -height     - size html canvas
        # -renderer   - 'canvas' or 'svg'
        # -jschartvar - name chart var
        # -divid      - name id var
        # -outfile    - full path html (by default in [info script]/render.html)
        # -jsecharts  - full path echarts.min.js (by default cdn script)
        # -jsvar      - name js var
        # -script     - list data (jsfunc), jsfunc.
        # -class      - container.
        # -style      - css style.
        #
        # Returns full path html file.

        set opts_html [ticklecharts::htmloptions $args]
        my timelineToHuddle ; # transform to huddle
        set myhuddle [my get]
        set json     [$myhuddle toJSON] ; # jsondump

        set newhtml    [ticklecharts::htmlmap $myhuddle $opts_html]
        set outputfile [lindex [dict get $opts_html -outfile] 0]
        set jsvar      [lindex [dict get $opts_html -jsvar] 0]

        set fp [open $outputfile w+]
        puts $fp [string map [list %json% "var $jsvar = $json"] $newhtml]
        close $fp
        
        if {$::ticklecharts::htmlstdout} {
            puts [format {html:%s} $outputfile]
        }

        return $outputfile
    }

    # To keep the same logic of naming methods for ticklecharts 
    # the first letter in capital letter...
    forward Render my render

    # export method
    export Add SetOptions Render

}


