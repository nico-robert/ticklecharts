# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

# This class allows you to add multiple charts on the same div.
# The charts are not necessarily of the same type.
# The first chart needs to be a graph with an x/y axis.

oo::class create ticklecharts::Gridlayout {
    variable _h            ; # huddle
    variable _indexchart2D ; # grid index chart2D
    variable _indexchart3D ; # grid index chart3D
    variable _options      ; # list options chart
    variable _charts2D     ; # list charts 2D
    variable _charts3D     ; # list charts 3D
    variable _opts_global  ; # global options
    variable _dataset      ; # dataset chart(s)
    variable _jschartvar   ; # js variable chart

    constructor {args} {
        # Initializes a new layout Class.
        #
        # args - Options described below.
        #
        # -theme  - name theme see : theme.tcl
        #
        ticklecharts::setTheme $args ; # theme options
        set _options      {}
        set _opts_global  {}
        set _dataset      {}
        set _charts2D     {}
        set _charts3D     {}
        set _indexchart2D -1
        set _indexchart3D -1
    }
}

oo::define ticklecharts::Gridlayout {

    method getType {} {
        # Returns type of class.
        return "gridlayout"
    }

    method getCharts {name} {
        # Returns a list of charts objects.
        #
        # name  - type of charts
        return [set _charts${name}]
    }

    method charts {} {
        # Gets list charts.
        return [list {*}[my getCharts "2D"] \
                     {*}[my getCharts "3D"]]
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

    method Add {chart {args ""}} {
        # Add charts to layout.
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
        if {[llength $args] % 2} {
            error "wrong # args: should be \"[self] [self method]\
                   \$chart ?-top top? ...\""
        }

        set argsopts [dict create]

        foreach {key value} $args {
            if {$value eq ""} {
                error "wrong # args: No value specified for\
                       this property '$key'"
            }

            switch -exact -- $key {
                "-top"    {dict set argsopts top    $value}
                "-bottom" {dict set argsopts bottom $value}
                "-left"   {dict set argsopts left   $value}
                "-right"  {dict set argsopts right  $value}
                "-width"  {dict set argsopts width  $value}
                "-height" {dict set argsopts height $value}
                "-center" {dict set argsopts center $value}
                default {
                    error "wrong # args: Unknown property '$key' specified,\
                          should be '-top, -bottom, -left, -right, -width,\
                          -height or -center'"
                }
            }
        }

        set keys [$chart keys]
        set chartType [$chart getType]

        if {"series" ni $keys} {
            error "\$chart must have a series property'"
        }

        # Not supported yet.
        if {"graphic" in $keys} {
            error "'graphic' key option is not supported."
        }

        if {([lsearch $keys grid*] == -1) && ($args eq "")} {
            error "\$chart must have a 'grid' argument if\
                   it's not present in 'chart' properties."
        }

        switch -exact -- $chartType {
            chart   {incr _indexchart2D ; lappend _charts2D $chart}
            chart3D {incr _indexchart3D ; lappend _charts3D $chart}
            default {error "Class '$chartType' not supported."}
        }

        set g 0 ; # variable for grid*
        # Gets global options.
        set optsg [ticklecharts::globalOptions {}]
        set gopts [string map {- ""} [dict keys [$optsg get]]]

        foreach {key opts} [$chart options] {
            switch -glob -- $key {
                *legend  {
                    # Find data name in series if data legend is not specified.
                    if {
                        ([lsearch [dict keys $opts] *data] == -1) ||
                        ([lsearch [dict keys $opts] @NULL=data] > -1)
                    } {
                        set data_name {}
                        foreach s_opts [lsearch -all [$chart options] *=series] {
                            set myserie [lindex [$chart options] $s_opts+1]
                            # if item data.
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
                        # Adds data name in legend.
                        dict set opts @LS=data [list $data_name]
                    }
                }
                *series  {
                    # Force index axis chart if exists or not.
                    # 2D
                    if {
                        [dict get $opts @S=type] in {
                            bar line scatter effectScatter heatmap pictorialBar 
                            candlestick graph boxplot lines
                        }
                    } {
                        set xindex [lsearch -inline [dict keys $opts] *xAxisIndex]
                        set yindex [lsearch -inline [dict keys $opts] *yAxisIndex]

                        if {[dict exists $opts $xindex]} {
                            if {[dict get $opts $xindex] eq "nothing"} {
                                dict set opts @N=xAxisIndex $_indexchart2D
                            } 
                        } else {
                            dict set opts @N=xAxisIndex $_indexchart2D
                        }

                        if {[dict exists $opts $yindex]} {
                            if {[dict get $opts $yindex] eq "nothing"} {
                                dict set opts @N=yAxisIndex $_indexchart2D
                            }
                        } else {
                            dict set opts @N=yAxisIndex $_indexchart2D
                        }
                    }

                    # 3D
                    if {[dict get $opts @S=type] in {bar3D line3D surface scatter3D}} {
                        set gridindex [lsearch -inline [dict keys $opts] *grid3DIndex]
                        if {[dict exists $opts $gridindex]} {
                            if {[dict get $opts $gridindex] eq "nothing"} {
                                dict set opts @N=grid3DIndex $_indexchart3D
                            } 
                        } else {
                            dict set opts @N=grid3DIndex $_indexchart3D
                        }
                    }

                    set stack [lsearch -inline [dict keys $opts] *stack]
                    if {[dict exists $opts $stack] && [dict get $opts $stack] ne "null"} {
                        set value [dict get $opts $stack]
                        if {[$chart getType] eq "chart3D"} {
                            set s "$value $_indexchart3D"
                        } else {
                            set s "$value $_indexchart2D"
                        }
                        dict set opts $stack [ticklecharts::mapSpaceString $s]
                    }

                    # Replace 'center' property if exists by the one in args if exists.
                    if {[dict get $opts @S=type] in {pie sunburst gauge}} {
                        if {[dict exists $argsopts "center"]} {
                            set center [dict get $argsopts "center"]
                            switch -exact -- [ticklecharts::typeOf $center] {
                                list    {dict set opts @LD=center [list $center]}
                                list.e  {dict set opts @LD=center [$center get]}
                                default {
                                    error "'center' property in the argument\
                                            options must be a 'list'"
                                }
                            }
                        }
                    }

                    # Set position in series instead of grid.
                    # For 'funnel', 'sankey', 'treemap', 'map' or 'wordCloud' chart
                    if {[dict get $opts @S=type] in {sankey funnel wordCloud treemap map}} {
                        set g 1
                        foreach val {top bottom left right width height} {
                            if {[dict exists $argsopts $val]} {
                                set myvalue [dict get $argsopts $val]
                                set mytype  [ticklecharts::typeOf $myvalue]
                                switch -exact -- $mytype {
                                    str     {dict set opts @S=$val $myvalue}
                                    str.e   {dict set opts @S=$val [$myvalue get]}
                                    num     {dict set opts @N=$val $myvalue}
                                    default {
                                        error "$val must be a string or a number,\
                                               currently this value is '$mytype'"
                                    }
                                }
                            }
                        }
                    }
                }
                *radar -
                *polar {
                    if {[dict exists $argsopts "center"]} {
                        set center [dict get $argsopts "center"]
                        switch -exact -- [ticklecharts::typeOf $center] {
                            list    {dict set opts @LD=center [list $center]}
                            list.e  {dict set opts @LD=center [$center get]}
                            default {
                                error "'center' property in the argument\
                                        options must be a 'list'"
                            }
                        }
                    }
                }
                *visualMap {
                    dict set opts @N=seriesIndex $_indexchart2D
                }
                *xAxis3D -
                *yAxis3D -
                *zAxis3D {
                    dict set opts @N=grid3DIndex $_indexchart3D
                }
                *xAxis -
                *yAxis  {
                    dict set opts @N=gridIndex $_indexchart2D
                }
                *singleAxis -
                *grid3D -
                *grid  {
                    set g 1
                    foreach val {top bottom left right width height} {
                        if {[dict exists $argsopts $val]} {
                            set myvalue [dict get $argsopts $val]
                            set mytype  [ticklecharts::typeOf $myvalue]
                            switch -exact -- $mytype {
                                str     {dict set opts @S=$val $myvalue}
                                str.e   {dict set opts @S=$val [$myvalue get]}
                                num     {dict set opts @N=$val $myvalue}
                                default {
                                    error "$val must be a string or a number,\
                                           currently this value is '$mytype'"
                                }
                            }
                        }
                    }
                }
            }

            # Remove key global options 
            lassign [split $key "="] _ k
            if {$k in $gopts} {continue}

            if {$key in [dict keys [my globalOptions]]} {
                puts stderr "warning([self class]): '$key' in\
                            '[ticklecharts::typeOfClass $chart]' is already\
                             activated with 'SetGlobalOptions' method\
                             it is not taken into account."
                continue
            }

            lappend _options $key $opts
        }

        # Check if grid is defined.
        # Add grid option if no.
        if {!$g} {
            set f {}
            foreach val {top bottom left right width height} {
                if {[dict exists $argsopts $val]} {
                    set myvalue [dict get $argsopts $val]
                    set mytype  [ticklecharts::typeOf $myvalue]
                    switch -exact -- $mytype {
                        str     {lappend f @S=$val $myvalue}
                        str.e   {lappend f @S=$val [$myvalue get]}
                        num     {lappend f @N=$val $myvalue}
                        default {
                            error "$val must be a string or a number,\
                                   currently this value is '$mytype'"
                        }
                    }
                }
            }
            if {[llength $f]} {
                switch -exact -- $chartType {
                    chart   {lappend _options @D=grid [list {*}$f]}
                    chart3D {lappend _options @D=grid3D [list {*}$f]}
                }
            }
        }

        # Check if polar key exists in first place
        # Error if yes, not possible.
        set keypolar [lsearch [dict keys $_options] *polar]
        if {!$_indexchart2D && $keypolar > -1} {
            error "'Polar' property should not be added first."
        }

        # Check if radar key exists in first place
        # Error if yes, not possible.
        set keyradar [lsearch [dict keys $_options] *radar]
        if {!$_indexchart2D && $keyradar > -1} {
            error "'Radar' property should not be added first."
        }

        # Check if pie, sunburst, themeriver, sankey series exists
        # in first place error if yes, not possible.
        if {[dict exists $_options @D=series @S=type]} {
            if {!$_indexchart2D} {
                set series [dict get $_options @D=series @S=type]
                if {
                    $series in {
                        pie sunburst themeRiver sankey gauge 
                        wordCloud treemap map lines
                    }
                } {
                    error "'$series' in Gridlayout class should not\
                           be added first."
                }
            }
        }

        return {}
    }

    method ToHuddle {} {
        # Transform list layout to hudlle.
        #
        # Returns nothing

        # Bug when several 'tooltip' < 5.3.0
        if {
            ([ticklecharts::vCompare $::ticklecharts::echarts_version "5.3.0"] == -1) && 
            ([llength [lsearch -all -exact [my options] @D=tooltip]] > 1)
        } {
            error "Several 'tooltips' are not supported\
                   with a version lower than '5.3.0'."
        }

        # Insert or not global options in the top of list.
        set match2D 0 ; set match3D 0
        if {![llength [my globalOptions]]} {
            # Priority chart 2D for global options
            foreach chart [my getCharts "2D"] {
                if {([$chart globalOptions] ne "") && !$match2D} {
                    set _options [linsert $_options 0 {*}[$chart globalOptions]]
                    set match2D 1
                } elseif {[$chart globalOptions] eq ""} {
                    # Default options.
                    set val [ticklecharts::procDefaultValue globalOptions -animation]
                    $chart setTrace globalOptions.animation $val
                }
            }
            if {!$match2D} {
                foreach chart [my getCharts "3D"] {
                    if {[$chart globalOptions] ne ""} {
                        set _options [linsert $_options 0 {*}[$chart globalOptions]]
                        set match3D 1 ; break
                    }
                }
            }
        }

        set opts [my options]

        # No global options adds if need.
        if {![llength [my globalOptions]] && !$match2D && !$match3D} {
            set optsg  [ticklecharts::globalOptions {}]
            set optsEH [ticklecharts::optsToEchartsHuddle [$optsg get]]
            set opts   [linsert $opts 0 {*}$optsEH]
            # Set trace animation on first chart
            foreach chart [my getCharts "2D"] {
                set val [ticklecharts::procDefaultValue globalOptions -animation]
                $chart setTrace globalOptions.animation $val
                break
            }
        }

        # Init ehuddle.
        set _h [ticklecharts::ehuddle new]

        foreach {key value} $opts {
            lassign [split $key "="] type _
            if {($type in {@D @L}) && ($value ne "")} {
                $_h append $key $value
            } else {
                $_h set $key $value
            }
        }

        return {}
    }

    method SetGlobalOptions {args} {
        # Set global options for all charts (2D + 3D) class.
        #
        # Returns nothing
        set c [ticklecharts::chart new]
        $c SetOptions {*}$args

        lappend _options     {*}[$c options]
        lappend _opts_global {*}[$c options]

        # Check if chart has dataset.
        # Save if yes.
        if {[$c dataset] ne ""} {
            set _dataset [$c dataset]
        }

        # destroy.
        $c destroy

        # Doesn't support 3D options
        set keys [dict keys $args]
        foreach opts3D {-grid3D -globe -geo3D -mapbox3D} {
            if {$opts3D in $keys} {
                error "$opts3D (options 3D) not supported\
                       with '[self method]' method"
            }
        }

        return {}
    }

    # Copy shared methods definition from 'ticklecharts::chart' class :
    #
    #   Render        - Export layout html.
    #   dataset       - Returns dataset.
    #   options       - Returns layout options.
    #   toJSON        - Returns json chart data.
    #   toHTML        - Export chart as HTML fragment.
    #   get           - Gets huddle object.
    #   globalOptions - Global options.
    # ...
    foreach method {Render dataset options toJSON toHTML get globalOptions} {
        method $method {*}[ticklecharts::classDef "chart" $method]
    }

    # export of methods
    export Add Render SetGlobalOptions
}

proc ticklecharts::isGridlayoutClass {value} {
    # Check if value is Gridlayout class.
    #
    # value - obj or string
    #
    # Returns true if 'value' is a Gridlayout class, false otherwise.
    return [expr {
            [ticklecharts::isAObject $value] && 
            [string match "*::Gridlayout" [ticklecharts::typeOfClass $value]]
        }
    ]
}

proc ticklecharts::gridlayoutHasDataSetObj {dts} {
    # Check if gridlayout has dataset class
    # only for 'chart' & 'chart3D' classes.
    #
    # dts - upvar
    #
    # Returns True if 'dataset' class is defined, False otherwise.
    upvar 1 $dts dataset

    foreach obj [concat [ticklecharts::listNs] "::"] {
        if {[ticklecharts::isGridlayoutClass $obj]} {
            if {[$obj dataset] ne ""} {
                set dataset [$obj dataset]
                return 1
            }
        }
    }

    return 0
}