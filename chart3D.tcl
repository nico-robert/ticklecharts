# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

oo::class create ticklecharts::chart3D {
    superclass ticklecharts::chart

    variable _echartshchart3D  ; # huddle
    variable _options3D        ; # list options chart3D
    variable _opts3D_global    ; # list global options chart
    variable _dataset          ; # dataset chart3D

    constructor {args} {
        # Initializes a new chart3D Class.
        #
        # args - Options described below.
        #
        # -theme  - name theme see : theme.tcl
        #
        ticklecharts::setTheme $args ; # theme options
        set _opts3D_global {}
        set _options3D     {}
        set _dataset       {}
    }
}

oo::define ticklecharts::chart3D {

    method get {} {
        # Gets huddle object
        return $_echartshchart3D
    }

    method options {} {
        # Gets chart3D list options
        return $_options3D
    }

    method globalOptions {} {
        # Note : This variable can be empty.
        #
        # Returns global options.
        return $_opts3D_global
    }

    method getType {} {
        # Gets type class
        return "chart3D"
    }

    method dataset {} {
        # Note : This variable can be empty.
        #
        # Returns dataset
        return $_dataset
    }

    method getOptions {args} {
        # args - Options described below.
        #
        # -series         - name of series
        # -option         - name of option
        # -globalOptions  - global options (no value required)
        # -axis           - name of axis
        #
        # Returns default and options type
        # according to a key (name of procedure)
        # If nothing is found then returns an empty string.

        # superclass ticklecharts::chart
        next {*}$args
    }

    method keys {} {
        # Returns keys without type.

        # superclass ticklecharts::chart
        next
    }

    method chart3DToHuddle {} {
        # Transform list to ehudlle
        #
        # Returns nothing

        set opts [my options]

        # If globalOptions is not defined, adds global options first...
        if {![llength [my globalOptions]]} {
            set optsg  [ticklecharts::globalOptions3D {}]
            set optsEH [ticklecharts::optsToEchartsHuddle [$optsg get]]
            set opts   [linsert $opts 0 {*}$optsEH]
        }

        # init ehuddle.
        set _echartshchart3D [ticklecharts::ehuddle new]

        foreach {key value} $opts {

            if {[string match {*series} $key]} {
                $_echartshchart3D append $key $value
            } elseif {[string match {*dataZoom} $key]} {
                $_echartshchart3D append $key $value
            } elseif {[string match {*visualMap} $key]} {
                $_echartshchart3D append $key $value
            } elseif {[string match {*dataset} $key]} {
                $_echartshchart3D append $key $value
            } else {
                $_echartshchart3D set $key $value
            }
        }

        return {}
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

    method toJSON {} {
        # Returns json chart data.
        my chart3DToHuddle ; # transform to huddle

        # ehuddle jsondump
        return [[my get] toJSON]
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

        lappend _options3D @D=xAxis3D [list {*}$f]

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

        lappend _options3D @D=yAxis3D [list {*}$f]

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

        lappend _options3D @D=zAxis3D [list {*}$f]

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

        lappend _options3D @D=series [list {*}$f]

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

        lappend _options3D @D=series [list {*}$f]

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

        lappend _options3D @D=series [list {*}$f]

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

        lappend _options3D @D=series [list {*}$f]

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
        # this way of writing to add a 3D series... To ensure conformity with other
        # classes (layout, timeline)
        #
        # Returns nothing

        if {[llength [lrange $args 1 end]] % 2} {
            error "item list for '\[self] Add '[lindex $args 0]' method...'\
                   must have an even number of elements."
        }

        switch -exact -- [lindex $args 0] {
            "line3DSeries"    {my AddLine3DSeries     {*}[lrange $args 1 end]}
            "bar3DSeries"     {my AddBar3DSeries      {*}[lrange $args 1 end]}
            "surfaceSeries"   {my AddSurfaceSeries    {*}[lrange $args 1 end]}
            "scatter3DSeries" {my AddScatter3DSeries  {*}[lrange $args 1 end]}
            default         {
                set lb [info class definition [self class] [self method]]
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
                error "First argument should be (case sensitive):'$series'\
                       instead of '[lindex $args 0]'"
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
            error "[self] SetOptions \$args must have an even number of elements..."
        }

        set opts {}

        # Set options from chart '2D' class...
        set c [ticklecharts::chart new]

        # remove options 3D even if this option is not defined.
        set args2D [dict remove $args "-grid3D" "-globe"]
        $c SetOptions {*}$args2D

        # get base keys
        set optsg [ticklecharts::globalOptions {}]
        set g2Dopts [string map {- ""} [dict keys [$optsg get]]]
        set key2d {}

        foreach {key info} [$c options] {
            lassign [split $key "="] _ k
            if {$k in $g2Dopts} {continue}
            lappend _options3D $key $info
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

        # delete keys from args to avoid warning for global options
        set keyList [list {*}[dict keys $opts] {*}$key2d]
        set keyopts [lmap k $keyList {lassign [split $k "="] _ key ; format -%s $key}]
        set newDict [dict remove $args {*}$keyopts]

        # Adds global 3D options first
        if {![llength [my globalOptions]]} {
            set optsg          [ticklecharts::globalOptions3D $newDict]
            set _opts3D_global [ticklecharts::optsToEchartsHuddle [$optsg get]]
            set _options3D     [linsert $_options3D 0 {*}$_opts3D_global]
        }

        foreach {key value} $opts {
            if {[ticklecharts::iseDictClass $value] || [ticklecharts::iseListClass $value]} {
                set f [ticklecharts::optsToEchartsHuddle [$value get]]
                lappend _options3D $key [list {*}$f]
            } else {
                error "should be an object... eDict or eList for this key: '$key'"
            }
        }

        return {}
    }

    # export of methods
    export AddLine3DSeries AddBar3DSeries AddSurfaceSeries AddScatter3DSeries \
           Xaxis3D Yaxis3D Zaxis3D SetOptions Render RenderTsb Add

}