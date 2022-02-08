# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.

oo::class create ticklecharts::Gridlayout {
    variable _layout ; # huddle
    variable _indexchart ; # grid index chart
    variable _options ; # list options chart

    constructor {args} {
        # Initializes a new layout Class.
        #
        # args - Options described below.
        #
        # -backgroundColor - chart color background
        # -color           - list chart color must be a list of list like this 
        #                    [list {red blue green}]
        # -animation       - chart animation (default True)
        # -others          - animation sub options see : global_options.tcl
        # -theme           - name theme see : theme.tcl
        #
        set _layout    [ticklecharts::ehuddle new]
        # theme options
        set opts_theme [ticklecharts::theme $args]
        # global options : animation, chart color...
        set opts_global [ticklecharts::globaloptions $args]
        set _options    {}
        set _indexchart -1

        lappend _options {*}[ticklecharts::OptsToEchartsHuddle $opts_global]

    }
}

oo::define ticklecharts::Gridlayout {

    method get {} {
        # Gets huddle object
        return $_layout
    }

    method Add {chart {args ""}} {
        # Add charts to layout
        #
        # chart - chart object
        # args  - Options described below.
        #
        # -top    - Distance between grid component and the top side of the container. (% or number)
        # -bottom - Distance between grid component and the bottom side of the container. (% or number)
        # -left   - Distance between grid component and the left side of the container. (% or number)
        # -right  - Distance between grid component and the right side of the container. (% or number)
        # -width  - Width of grid component. Adaptive by default. (% or number)
        # -height - Height of grid component. Adaptive by default. (% or number)
        # -center - Center position of Polar coordinate, the first of which is the horizontal position, and the second is the vertical position (array)
        #
        # Returns nothing
        foreach {key value} $args {
        
            if {$value eq ""} {
                error "No value specified for key '$key'"
            }
            
            if {[llength $value] != [llength $chart]} {
                error "llength charts must be equal with values of $key"
            }
            
            switch -exact -- $key {
                "-top"    {set top $value}
                "-bottom" {set bottom $value}
                "-left"   {set left $value}
                "-right"  {set right $value}
                "-width"  {set width $value}
                "-height" {set height $value}
                "-center" {set center $value}
                default {error "Unknown key '$key' specified"}
            }
        }
        
        set keys [$chart keys]

        if {"series" ni $keys} {
            error "charts must have a key 'series'"
        }
        
        if {("grid" ni $keys) && ($args eq "")} {
            error "charts must have a grid key if no options..."
        }

        incr _indexchart
        set g 0
        set layoutkeys {series radiusAxis angleAxis xAxis yAxis grid title polar legend tooltip}

        foreach {key opts} [$chart options] {

            switch -glob -- $key {
                *series  {
                    set xindex [lsearch -inline [dict keys $opts] *xAxisIndex]
                    set yindex [lsearch -inline [dict keys $opts] *yAxisIndex]
                    set stack [lsearch -inline [dict keys $opts] *stack]
                    
                    
                    dict remove $opts $xindex ; # delete key
                    dict set opts @N=xAxisIndex $_indexchart
                    dict remove $opts $yindex ; # delete key
                    dict set opts @N=yAxisIndex $_indexchart
                    
                    
                    if {[dict exists $opts $stack] && [dict get $opts $stack] ne "null"} {
                        set value [dict get $opts $stack]
                        dict set opts $stack [string map {" " "<@!>"} "$value $_indexchart"]
                    }
                
                }
                *polar {
                    set coordinatecenter [lsearch -inline [dict keys $opts] *center]
                    if {[info exists center]} {
                        set mytype [Type $center]
                        if {$mytype ne "list"} {
                            error "center must be a list"
                        }

                        dict remove $opts $coordinatecenter ; # delete key
                        dict set opts @LD=center [list $center]

                    }

                }
                *xAxis       -
                *yAxis  {
                    set gridindex [lsearch -inline [dict keys $opts] *gridIndex]
                    dict remove $opts $gridindex ; # delete key
                    dict set opts @N=gridIndex $_indexchart
                }
                *grid  {
                    set g 1
                    foreach val {top bottom left right width height} {
                        if {[info exists [set val]]} {
                            set position [lsearch -inline [dict keys $opts] *$val]
                            dict remove $opts $position ; # delete key
                            set myvalue [expr $[set val]]
                            set mytype [Type $myvalue]

                            switch -- $mytype {
                                "list" -
                                "str" {dict set opts @S=$val $myvalue}
                                "num" {dict set opts @N=$val $myvalue}
                                default {error "$val must be a str or a float... now is $mytype"}
                            }
                        }
                    }
                }
            }

            # remove global options 
            # priority to constructor...
            lassign [split $key "="] type k
            if {$k ni $layoutkeys} {continue}

            lappend _options $key $opts
        }

        # Check if grid is present
        # add grid option if no...
        if {!$g} {
            set f {}
            foreach val {top bottom left right width height} {
                if {[info exists [set val]]} {
                    set myvalue [expr $[set val]]
                    set mytype [Type $myvalue]
                    
                    switch -- $mytype {
                        "list" -
                        "str" {lappend f @S=$val $myvalue}
                        "num" {lappend f @N=$val $myvalue}
                        default {error "$val must be a str or a float... now is $mytype"}
                    }
                }
            }
            if {[llength $f]} {
                lappend _options @D=grid [list {*}$f]
            }
        }

        # Check if polar key exists in first place
        # Error if yes , not possible 
        set keypolar [lsearch [dict keys $_options] *polar]
        if {!$_indexchart && $keypolar > -1} {
            error "'Polar' mode should not be added first..."
        }

    }

    method layoutToHuddle {} {
        # Transform list layout to hudlle
        #
        # Returns nothing

        foreach {key opts} $_options {
            lassign [split $key "="] type value

            if {$type eq "@D" || $type eq "@L"} {
                $_layout append $key $opts
            } else {
                $_layout set $key $opts
            }
        }
        
        if {[$_layout llengthkeys "tooltip"] > 1} {
            error "several tooltip not supported..."
        }
    }
    
    method render {args} {
        # Export chart to html.
        #
        # args - Options described below.
        #
        # -title      - header title html
        # -width      - size html canvas
        # -height     - size html canvas
        # -render     - 'canvas' or 'svg'
        # -jschartvar - name chart var
        # -divid      - name id var
        # -outfile    - full path html (by default in [info script]/render.html)
        # -jsecharts  - full path echarts.min.js (by default cdn script)
        # -jsvar      - name js var
        #
        # # return full path html file + stdout.

        set opts_html [ticklecharts::htmloptions $args]
        my layoutToHuddle ; # transform to huddle
        set myhuddle [my get]
        set json     [$myhuddle toJSON]

        set newhtml    [ticklecharts::htmlmap $opts_html]
        set outputfile [lindex [dict get $opts_html -outfile] 0]
        set jsvar      [lindex [dict get $opts_html -jsvar] 0]

        set fp [open $outputfile w+]
        puts $fp [string map [list %json% "var $jsvar = $json"] $newhtml]
        close $fp

        puts [format {html:%s} $outputfile]

        return $outputfile

    }
    # export method
    export Add
    
}