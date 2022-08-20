# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

# This class allows you to add multiple charts on the same div...
# The charts are not necessarily of the same type.
# The first chart needs to be a graph with an x/y axis.

oo::class create ticklecharts::Gridlayout {
    variable _layout     ; # huddle
    variable _indexchart ; # grid index chart
    variable _options    ; # list options chart
    variable _keyglob    ; # global key options
    variable _dataset    ; 

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
        # theme options
        set opts_theme [ticklecharts::theme $args]
        # global options : animation, chart color...
        set opts_global [ticklecharts::globaloptions $args]
        set _options    {}
        set _keyglob    {}
        set _dataset    {}
        set _indexchart -1

        lappend _options {*}[ticklecharts::optsToEchartsHuddle $opts_global]

    }
}

oo::define ticklecharts::Gridlayout {

    method get {} {
        # Gets huddle object
        return $_layout
    }

    method globalKeyOptions {} {
        # Gets global key options
        return $_keyglob
    }

    method dataset {} {
        # Gets dataset
        return $_dataset
    }

    method gettype {} {
        # Returns type of class
        return "gridlayout"
    }

    method Add {chart {args ""}} {
        # Add charts to layout
        #
        # chart - chart object
        # args  - Options described below (optional).
        #
        # -top    - Distance between grid component and the top side of the container. (% or number)
        # -bottom - Distance between grid component and the bottom side of the container. (% or number)
        # -left   - Distance between grid component and the left side of the container. (% or number)
        # -right  - Distance between grid component and the right side of the container. (% or number)
        # -width  - Width of grid component. Adaptive by default. (% or number)
        # -height - Height of grid component. Adaptive by default. (% or number)
        # -center - Center position of Polar coordinate, the first of which is the horizontal position, 
        #           and the second is the vertical position. (array)
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

        # not supported yet...
        if {"graphic" in $keys} {
            error "graphic not supported..."
        }
        
        if {("grid" ni $keys) && ($args eq "")} {
            error "charts must have a grid key if no options..."
        }

        incr _indexchart
        set g 0
        set layoutkeys {
                series radiusAxis angleAxis xAxis yAxis grid title polar
                radar legend tooltip visualMap toolbox singleAxis dataZoom dataset
                parallelAxis parallel brush
            }

        foreach {key opts} [$chart options] {

            switch -glob -- $key {
                *legend  {
                    # Find data name in series if data legend is not specified...
                    if {[lsearch [dict keys $opts] *data] == -1 || [lsearch [dict keys $opts] @NULL=data] > -1} {
                        set data_name {}
                        foreach series_opts [lsearch -all [$chart options] *=series] {
                            set myserie [lindex [$chart options] [expr {$series_opts + 1}]]
                            
                            # if item data...
                            if {[dict exists $myserie @DO=data @AO]} {
                                foreach data_item [dict get $myserie @DO=data @AO] {
                                    if {[dict exists $data_item @S=name]} {
                                        lappend data_name [dict get $data_item @S=name]
                                    } else {
                                        if {[dict get $myserie @S=name] ni $data_name} {
                                            lappend data_name [dict get $myserie @S=name]
                                        }
                                    }
                                }
                            } else {
                                lappend data_name [dict get $myserie @S=name]
                            }

                        }
                        # add data name in legend...
                        dict set opts @LS=data [list $data_name]
                    }

                }
                *series  {
                    # force index axis chart... if exists...
                    set xindex [lsearch -inline [dict keys $opts] *xAxisIndex]
                    if {[dict exists $opts $xindex] && [dict get $opts $xindex] eq "nothing"} {
                        dict set opts @N=xAxisIndex $_indexchart
                    }

                    set yindex [lsearch -inline [dict keys $opts] *yAxisIndex]
                    if {[dict exists $opts $yindex] && [dict get $opts $yindex] eq "nothing"} {
                        dict set opts @N=yAxisIndex $_indexchart
                    }
                    
                    set stack [lsearch -inline [dict keys $opts] *stack]
                    if {[dict exists $opts $stack] && [dict get $opts $stack] ne "null"} {
                        set value [dict get $opts $stack]
                        dict set opts $stack [ticklecharts::MapSpaceString "$value $_indexchart"]
                    }

                    # replace 'center' flag if exists by the one in args if exists...
                    set coordinatecenter [lsearch -inline [dict keys $opts] *center]
                    if {[dict exists $opts $coordinatecenter]} {
                        if {[info exists center]} {
                            set mytype [Type $center]
                            if {$mytype ne "list"} {
                                error "'center' flag must be a list"
                            }
                            dict set opts @LD=center [list $center]

                        }
                    }

                    # set position in serie instead of grid... for 'funnel' & 'sankey' chart
                    if {[dict get $opts @S=type] eq "funnel" || [dict get $opts @S=type] eq "sankey"} {
                        set g 1
                        foreach val {top bottom left right width height} {
                            if {[info exists [set val]]} {
                                set myvalue [expr $[set val]]
                                set mytype [Type $myvalue]

                                switch -- $mytype {
                                    "str" {dict set opts @S=$val $myvalue}
                                    "num" {dict set opts @N=$val $myvalue}
                                    default {error "$val must be a str or a float... now is $mytype"}
                                }
                            }
                        }
                    }
                
                }
                *radar -
                *polar {
                    set coordinatecenter [lsearch -inline [dict keys $opts] *center]
                    if {[info exists center]} {
                        set mytype [Type $center]
                        if {$mytype ne "list"} {
                            error "'center' flag must be a list"
                        }
                        dict set opts @LD=center [list $center]

                    }

                }
                *visualMap {
                    dict set opts @N=seriesIndex $_indexchart
                }
                *xAxis -
                *yAxis  {
                    set gridindex [lsearch -inline [dict keys $opts] *gridIndex]
                    dict set opts $gridindex $_indexchart
                }
                *singleAxis -
                *grid  {
                    set g 1
                    foreach val {top bottom left right width height} {
                        if {[info exists [set val]]} {
                            set myvalue [expr $[set val]]
                            set mytype [Type $myvalue]

                            switch -- $mytype {
                                "str" {dict set opts @S=$val $myvalue}
                                "num" {dict set opts @N=$val $myvalue}
                                default {error "$val must be a str or a float... now is $mytype"}
                            }
                        }
                    }
                }
            }

            if {$key in [my globalKeyOptions]} {
                puts "warning(ticklecharts::Gridlayout): '$key' in chart class is already\
                     activated with 'SetGlobalOptions' method\
                     it is not taken into account..."
                continue
            }
            # remove key global options 
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
        # Error if yes , not possible.
        set keypolar [lsearch [dict keys $_options] *polar]
        if {!$_indexchart && $keypolar > -1} {
            error "'Polar' mode should not be added first..."
        }

        # Check if radar key exists in first place
        # Error if yes , not possible.
        set keyradar [lsearch [dict keys $_options] *radar]
        if {!$_indexchart && $keyradar > -1} {
            error "'Radar' mode should not be added first..."
        }

        # Check if pie, sunburst, themeriver, sankey chart type exists in first place
        # Error if yes, not possible.
        if {[dict exists $_options @D=series @S=type]} {
            if {!$_indexchart} {
                switch -exact -- [dict get $_options @D=series @S=type]  {
                    pie        {error "'Pie' chart should not be added first..."}
                    sunburst   {error "'Sunburst' chart should not be added first..."}
                    themeRiver {error "'ThemeRiver' chart should not be added first..."}
                    sankey     {error "'Sankey' chart should not be added first..."}
                    gauge      {error "'Gauge' chart should not be added first..."}
                }
            }
        }

        return {}
    }

    method layoutToHuddle {} {
        # Transform list layout to hudlle
        #
        # Returns nothing

        # init ehuddle.
        set _layout [ticklecharts::ehuddle new]

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

        return {}

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
        #
        # Returns full path html file.

        set opts_html [ticklecharts::htmloptions $args]
        my layoutToHuddle ; # transform to huddle
        set myhuddle [my get]
        set json     [$myhuddle toJSON] ; # jsondump

        set newhtml    [ticklecharts::htmlmap $opts_html]
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

    method toJSON {} {
        # Returns json chart data.
        my layoutToHuddle ; # transform to huddle
        
        # ehuddle jsondump
        return [[my get] toJSON]
    }

    method SetGlobalOptions {args} {
        # Set global options for all charts class
        #
        # Returns nothing
        set c [ticklecharts::chart new]
        set c_opts [$c keys]
        $c SetOptions {*}$args

        foreach {key info} [$c options] {
            # remove key global options 
            # priority to layout class...
            lassign [split $key "="] type k
            if {$k in $c_opts} {continue}

            lappend _options $key $info
            lappend _keyglob $key
        }

        # check if chart has dataset.
        # save is yes...
        if {[$c dataset] ne ""} {
            set _dataset [$c dataset]
        }

        # destroy...
        $c destroy

        return {}
        
    }

    # To keep the same logic of naming methods for ticklecharts 
    # the first letter in capital letter...
    forward Render my render

    # export method
    export Add Render SetGlobalOptions
    
}

proc ticklecharts::gridlayoutHasDataSetObj {dts} {
    # Check if gridlayout has dataset class
    # only for chart class
    #
    # dts - upvar
    #
    # Returns True if 'dataset' class is present, False otherwise.
    upvar 1 $dts dataset

    foreach obj [concat [ticklecharts::listNs] "::"] {
        if {[ticklecharts::IsaObject $obj]} {
            if {[info object class $obj] eq "::ticklecharts::Gridlayout"} {
                if {[$obj dataset] ne ""} {
                    set dataset [$obj dataset]
                    return 1
                }
            }
        }
    } 

    return 0
}