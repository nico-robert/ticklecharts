# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

oo::class create ticklecharts::chart3D {
    variable _h            ; # huddle
    variable _options      ; # list options chart3D
    variable _opts_global  ; # list global options chart
    variable _dataset      ; # dataset chart3D
    variable _trace        ; # trace properties chart
    variable _jschartvar   ; # js variable chart

    # See 'chart' class for further details on arguments.
    constructor {*}[info class constructor "ticklecharts::chart"]
}

oo::define ticklecharts::chart3D {

    method getType {} {
        # Gets type class
        return "chart3D"
    }

    method ToHuddle {} {
        # Transform list to ehudlle
        #
        # Returns nothing

        set opts [my options]

        # If globalOptions is not defined, adds global options first.
        if {![llength [my globalOptions]]} {
            set optsg  [ticklecharts::globalOptions3D {}]
            set optsEH [ticklecharts::optsToEchartsHuddle [$optsg get]]
            set opts   [linsert $opts 0 {*}$optsEH]
        }

        # init ehuddle.
        set _h [ticklecharts::ehuddle new]

        foreach {key value} $opts {

            if {[string match {*series} $key]} {
                $_h append $key $value
            } elseif {[string match {*dataZoom} $key]} {
                $_h append $key $value
            } elseif {[string match {*visualMap} $key]} {
                $_h append $key $value
            } elseif {[string match {*dataset} $key]} {
                $_h append $key $value
            } else {
                $_h set $key $value
            }
        }

        return {}
    }

    method Xaxis3D {args} {
        # Init X axis chart3D
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis X
        # or
        # from doc : https://echarts.apache.org/en/option-gl.html#xAxis3D
        #
        # Returns nothing

        set options [ticklecharts::xAxis3D $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=xAxis3D [list {*}$f]

        return {}
    }

    method Yaxis3D {args} {
        # Init Y axis chart3D
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis Y
        # or
        # from doc : https://echarts.apache.org/en/option-gl.html#yAxis3D
        #
        # Returns nothing

        set options [ticklecharts::yAxis3D $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=yAxis3D [list {*}$f]

        return {}
    }

    method Zaxis3D {args} {
        # Init Z axis chart3D
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis Z
        # or
        # from doc : https://echarts.apache.org/en/option-gl.html#zAxis3D
        #
        # Returns nothing

        set options [ticklecharts::zAxis3D $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=zAxis3D [list {*}$f]

        return {}
    }

    method AddLine3DSeries {args} {
        # Add data series chart (use only for line3D chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series line
        # or
        # from doc : https://echarts.apache.org/en/option-gl.html#series-line3D
        #
        # Returns nothing
        classvar indexline3Dseries

        set options [ticklecharts::line3DSeries [incr indexline3Dseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddBar3DSeries {args} {
        # Add data series chart (use only for bar3D chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series bar
        # or
        # from doc : https://echarts.apache.org/en/option-gl.html#series-bar3D
        #
        # Returns nothing
        classvar indexbar3Dseries

        set options [ticklecharts::bar3DSeries [incr indexbar3Dseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddSurfaceSeries {args} {
        # Add data series chart (use only for surface chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series surface
        # or
        # from doc : https://echarts.apache.org/en/option-gl.html#series-surface
        #
        # Returns nothing
        classvar indexsurfaceseries

        set options [ticklecharts::surfaceSeries [incr indexsurfaceseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddScatter3DSeries {args} {
        # Add data series chart (use only for scatter3D chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series scatter
        # or
        # from doc : https://echarts.apache.org/en/option-gl.html#series-scatter3D
        #
        # Returns nothing
        classvar indexscatter3Dseries

        set options [ticklecharts::scatter3DSeries [incr indexscatter3Dseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddLines3DSeries {args} {
        # Add data series chart (use only for lines3D chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series lines
        # or
        # from doc : https://echarts.apache.org/en/option-gl.html#series-lines3D
        #
        # Returns nothing
        classvar indexlines3Dseries

        set options [ticklecharts::lines3DSeries [incr indexlines3Dseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method Add {args} {
        # This method is identical to methods for adding series, it is a 
        # different way of writing it.
        #
        # The first argument takes the name of the series to be added
        # By example to add a Bar 3D series, you should write like this :
        # > $chart Add "bar3DSeries" -data ...
        # It is the same thing that main method.
        #
        # Note : Probably that in my next major release, I would choose
        # this way of writing to add a 3D series, to ensure conformity with other
        # classes (layout, timeline)
        #
        # Returns nothing

        if {[llength [lrange $args 1 end]] % 2} {
            error "wrong # args: Item for '\[self] Add '[lindex $args 0]'\
                   method must have an even number of elements."
        }

        switch -exact -- [lindex $args 0] {
            "line3DSeries"    {my AddLine3DSeries     {*}[lrange $args 1 end]}
            "bar3DSeries"     {my AddBar3DSeries      {*}[lrange $args 1 end]}
            "surfaceSeries"   {my AddSurfaceSeries    {*}[lrange $args 1 end]}
            "scatter3DSeries" {my AddScatter3DSeries  {*}[lrange $args 1 end]}
            "lines3DSeries"   {my AddLines3DSeries    {*}[lrange $args 1 end]}
            default         {
                set lb [ticklecharts::classDef [self class] [self method]]
                set series {}
                foreach line [split $lb "\n"] {
                    set line [string trim $line]
                    if {[regexp {\"([a-zA-Z0-9]+)\"\s+\{my} $line -> case]} {
                        lappend series $case
                    }
                }
                set series [lsort -dictionary $series]
                set series [format {%s or %s} \
                           [join [lrange $series 0 end-1] ", "] \
                           [lindex $series end]]
                error "wrong # args: First argument for '[self method]' method should\
                       be (case sensitive): '$series' instead of '[lindex $args 0]'"
            }
        }

        return {}
    }

    method SetOptions {args} {
        # Add options chart3D (available for all charts 3D)
        #
        # gets default option values e.g : [self] getOptions -option toolbox
        #
        # args - Options described below.
        #
        # -grid3D   - grid3D options  https://echarts.apache.org/en/option-gl.html#grid3D
        # -globe    - globe  options  https://echarts.apache.org/en/option-gl.html#globe
        #
        # Returns nothing
        if {[llength $args] % 2} {
            error "wrong # args: [self] SetOptions \$args must have\
                   an even number of elements."
        }

        set opts {}

        # Set options from chart '2D' class.
        set c [ticklecharts::chart new]

        # Remove options 3D even if this option is not defined.
        set args2D [dict remove $args "-grid3D" "-globe"]
        $c SetOptions {*}$args2D

        # get base keys
        set optsg [ticklecharts::globalOptions {}]
        set g2Dopts [string map {- ""} [dict keys [$optsg get]]]
        set key2d {}

        foreach {key info} [$c options] {
            lassign [split $key "="] _ k
            if {$k in $g2Dopts} {continue}
            lappend _options $key $info
            lappend key2d $key ;  # add keys 2D
        }

        if {[$c dataset] ne ""} {
            set _dataset [$c dataset]
        }

        $c destroy

        if {[dict exists $args -grid3D]} {
            lappend opts "@D=grid3D" [ticklecharts::grid3D $args]
        }

        if {[dict exists $args -globe]} {
            lappend opts "@L=globe" [ticklecharts::globe $args]
        }

        # Delete keys from args to avoid warning for global options
        set keyList [list {*}[dict keys $opts] {*}$key2d]
        set keyopts [lmap k $keyList {lassign [split $k "="] _ key ; format -%s $key}]
        set newDict [dict remove $args {*}$keyopts]

        # Adds global 3D options first
        if {![llength [my globalOptions]]} {
            set optsg        [ticklecharts::globalOptions3D $newDict]
            set _opts_global [ticklecharts::optsToEchartsHuddle [$optsg get]]
            set _options     [linsert $_options 0 {*}$_opts_global]
        }

        foreach {key value} $opts {
            if {[ticklecharts::iseDictClass $value] || [ticklecharts::iseListClass $value]} {
                set f [ticklecharts::optsToEchartsHuddle [$value get]]
                lappend _options $key [list {*}$f]
            } else {
                error "wrong # args: Should be an object\
                       'eDict' or 'eList' for this key '$key'."
            }
        }

        return {}
    }

    # Copy shared methods definition from 'ticklecharts::chart' class :
    #
    #   Render        - Export chart3D html.
    #   setTrace      - Sets trace properties.
    #   track         - Compares properties.
    #   toHTML        - Export chart as HTML fragment.
    #   dataset       - Returns dataset.
    #   options       - Gets chart3D list options.
    #   get           - Gets huddle object.
    #   toJSON        - Returns json chart data.
    #   getOptions    - Returns default and options type.
    #   keys          - Returns keys without type.
    #   deleteSeries  - Delete series by index.
    #   globalOptions - Returns global options. 
    #                   Note : This variable can be empty.
    #   AddJSON       - Build your own JSON.
    #   getONSClass   - Name of the internal namespace of the object.
    #   getTrace      - Returns trace properties.
    # ...
    foreach method {
        Render setTrace track toHTML options get toJSON getONSClass getTrace
        dataset getOptions keys deleteSeries globalOptions AddJSON
    } {
        method $method {*}[ticklecharts::classDef "chart" $method]
    }

    # export of methods
    export AddLine3DSeries AddBar3DSeries AddSurfaceSeries AddScatter3DSeries AddLines3DSeries \
           Xaxis3D Yaxis3D Zaxis3D SetOptions Render Add AddJSON

}