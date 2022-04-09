# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

oo::class create ticklecharts::chart {
    variable _echartshchart         ; # huddle
    variable _options               ; # list options chart
    variable _indexlineseries       ; # index line serie
    variable _indexbarseries        ; # index bar serie
    variable _indexpieseries        ; # index pie serie
    variable _indexfunnelseries     ; # index funnel serie
    variable _indexradarseries      ; # index radar serie
    variable _indexscatterseries    ; # index scatter serie
    variable _indexheatmapseries    ; # index heatmap serie
    variable _indexsunburstseries   ; # index sunburst serie
    variable _indextreeseries       ; # index tree serie
    variable _indexthemeriverseries ; # index themeriver serie

    constructor {args} {
        # Initializes a new Chart Class.
        #
        # args - Options described below.
        #
        # -backgroundColor - chart color background
        # -color           - list series chart colors should be a list of list like this 
        #                    [list {red blue green}]
        # -animation       - chart animation (default True)
        # -others          - animation sub options see : global_options.tcl
        # -theme           - name theme see : theme.tcl
        #
        set _echartshchart [ticklecharts::ehuddle new]
        # theme options
        set opts_theme     [ticklecharts::theme $args]
        # global options : animation, chart color...
        set opts_global    [ticklecharts::globaloptions $args]
        set _options       {}
        set _indexlineseries 0
        set _indexbarseries  0

        lappend _options {*}[ticklecharts::OptsToEchartsHuddle $opts_global]
    }
}

oo::define ticklecharts::chart {

    method get {} {
        # Gets huddle object
        return $_echartshchart
    }

    method options {} {
        # Gets chart list options
        return $_options
    }
    
    method ismixed {} {
        # Check if series options there is severals types (line, bar...)
        #
        # Returns true if severals types, otherwise false.
        set ktype {}
    
        foreach {key opts} $_options {
            if {[string match {*series} $key]} {
                if {[dict exists $opts @S=type]} {
                    lappend ktype [dict get $opts @S=type]
                }
            }
        }
        return [expr {([llength $ktype] > 1) ? 1 : 0}]

    }

    method getoptions {key} {
        # Returns default and options type according to a key (name of procedure).
        return [ticklecharts::InfoOptions $key]
    }

    method keys {} {
        # Returns keys without type.
        set k {}
        foreach {key opts} $_options {
            lappend k [lindex [split $key "="] 1]
        }

        return $k
    }

    method deleteseries {index} {
        # Delete series by index.
        #
        # Returns nothing
        set i -1 ; set j 0 ; set k 0
        foreach {key opts} $_options {
            if {[string match {*series} $key]} {
                if {[incr i] == $index} {
                    set k 1 ; break
                }
            }
            incr j 2
        }

        if {$k} {set _options [lreplace $_options $j [expr {$j + 1}]]}

        return
    }

    method chartToHuddle {} {
        # Transform list to ehudlle
        #
        # Returns nothing
        set mixed [my ismixed]
        # special case to append...
        set value {xAxis yAxis radar}
        
        foreach {key opts} $_options {

            if {[string match {*series} $key]} {
                $_echartshchart append $key $opts
            } elseif {($key in $value) && $mixed} {
                $_echartshchart append $key $opts
            } else {
                $_echartshchart set $key $opts
            }
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
        # return full path html file + stdout.
        
        set opts_html [ticklecharts::htmloptions $args]
        my chartToHuddle ; # transform to huddle
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

    method Xaxis {args} {
        # Init X axis chart
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions setXAxis
        # or
        # from doc : https://echarts.apache.org/en/option.html#xAxis
        #
        # Returns nothing
        set mykeys [my keys]

        if {"radiusAxis" in $mykeys || "angleAxis" in $mykeys} {
            error "radiusAxis or angleAxis not supported with 'Xaxis'"
        }
    
        set options [ticklecharts::setXAxis $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]
        
        lappend _options @D=xAxis [list {*}$f]

    }

    method Yaxis {args} {
        # Init Y axis chart
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions setYAxis
        # or
        # from doc : https://echarts.apache.org/en/option.html#yAxis
        #
        # Returns nothing
        set mykeys [my keys]

        if {"radiusAxis" in $mykeys || "angleAxis" in $mykeys} {
            error "radiusAxis or angleAxis not supported with 'Yaxis'"
        }
    
        set options [ticklecharts::setYAxis $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]
        
        lappend _options @D=yAxis [list {*}$f]
        
    }
    
    method RadiusAxis {args} {
        # Init Radius axis chart (available only for polar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions SetRadiusAxis
        # or
        # from doc : https://echarts.apache.org/en/option.html#radiusAxis
        #
        # Returns nothing    
        set mykeys [my keys]
    
        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'radiusAxis'"
        }
        
        set options [ticklecharts::SetRadiusAxis $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]
        
        lappend _options @L=radiusAxis [list {*}$f]

    }
    
    method AngleAxis {args} {
        # Init Angle axis chart (available only for polar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions SetAngleAxis
        # or
        # from doc : https://echarts.apache.org/en/option.html#angleAxis
        #
        # Returns nothing      
        set mykeys [my keys]
    
        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'angleAxis'"
        }
        
        set options [ticklecharts::SetAngleAxis $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]
        
        lappend _options @L=angleAxis [list {*}$f]

    }

    method AddGraphic {args} {
        # Add elements (text, rect, circle...) to chart
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions SetGraphic
        # or
        # from doc : https://echarts.apache.org/en/option.html#graphic
        #
        # Returns nothing      
        
        set options [ticklecharts::SetGraphic $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]
        
        lappend _options @L=graphic [list {*}$f]

    }

    method RadarCoordinate {args} {
        # Init Radar coordinate (available only for radar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions SetRadarCoordinate
        # or
        # from doc : https://echarts.apache.org/en/option.html#radar
        #
        # Returns nothing      
        set mykeys [my keys]
    
        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'Radar coordinate'"
        }
        
        set options [ticklecharts::SetRadarCoordinate $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]
        
        lappend _options @D=radar [list {*}$f]

    }

    method SingleAxis {args} {
        # Init singleAxis
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions SetSingleAxis
        # or
        # from doc : https://echarts.apache.org/en/option.html#singleAxis
        #
        # Returns nothing      
        set mykeys [my keys]
    
        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'SingleAxis'"
        }
        
        set options [ticklecharts::SetSingleAxis $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]
        
        lappend _options @D=singleAxis [list {*}$f]

    }
    
    
    method AddBarSeries {args} {
        # Add data serie chart (use only for bar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions barseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-bar
        #
        # Returns nothing      
        incr _indexbarseries

        set options [ticklecharts::barseries $_indexbarseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }
    
    method AddLineSeries {args} {
        # Add data serie chart (use only for line chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions lineseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-line
        #
        # Returns nothing     
        incr _indexlineseries

        set options [ticklecharts::lineseries $_indexlineseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }

    method AddPieSeries {args} {
        # Add data serie chart (use only for pie chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions pieseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-pie
        #
        # Returns nothing     
        incr _indexpieseries

        set options [ticklecharts::pieseries $_indexpieseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }

    method AddFunnelSeries {args} {
        # Add data serie chart (use only for funnel chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions funnelseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-funnel
        #
        # Returns nothing     
        incr _indexfunnelseries

        set options [ticklecharts::funnelseries $_indexfunnelseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }

    method AddRadarSeries {args} {
        # Add data serie chart (use only for radar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions radarseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-radar
        #
        # Returns nothing     
        incr _indexradarseries

        set options [ticklecharts::radarseries $_indexradarseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }
    
    method AddScatterSeries {args} {
        # Add data serie chart (use only for scatter chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions scatterseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-scatter
        #
        # Returns nothing     
        incr _indexscatterseries

        set options [ticklecharts::scatterseries $_indexscatterseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }

    method AddHeatmapSeries {args} {
        # Add data serie chart (use only for heatmap chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions heatmapseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-heatmap
        #
        # Returns nothing     
        incr _indexheatmapseries

        set options [ticklecharts::heatmapseries $_indexheatmapseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }

    method AddSunburstSeries {args} {
        # Add data serie chart (use only for sunburst chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions sunburstseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-sunburst
        #
        # Returns nothing     
        incr _indexsunburstseries

        set options [ticklecharts::sunburstseries $_indexsunburstseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }

    method AddTreeSeries {args} {
        # Add data serie chart (use only for tree chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions treeseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-tree
        #
        # Returns nothing     
        incr _indextreeseries

        set options [ticklecharts::treeseries $_indextreeseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }

    method AddThemeRiverSeries {args} {
        # Add data serie chart (use only for ThemeRiver chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getoptions themeriverseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-themeriver
        #
        # Returns nothing     
        incr _indexthemeriverseries

        set options [ticklecharts::themeriverseries $_indexthemeriverseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }
    
    method SetOptions {args} {
        # Add options chart (available for all charts)
        #
        # args - Options described below.
        # 
        # -title     - title options     https://echarts.apache.org/en/option.html#title
        # -polar     - polar options     https://echarts.apache.org/en/option.html#polar
        # -legend    - legend options    https://echarts.apache.org/en/option.html#legend
        # -tooltip   - polar options     https://echarts.apache.org/en/option.html#tooltip
        # -grid      - grid options      https://echarts.apache.org/en/option.html#grid
        # -visualMap - visualMap options https://echarts.apache.org/en/option.html#visualMap
        # -toolbox   - toolbox options   https://echarts.apache.org/en/option.html#toolbox
        #
        # Returns nothing    
        set opts {}
    
        if {[dict exists $args -title]} {
            lappend opts "@D=title" [ticklecharts::title $args]
        }
        
        if {[dict exists $args -polar]} {
            lappend opts "@L=polar" [ticklecharts::polar $args]
        }
        
        if {[dict exists $args -legend]} {
            lappend opts "@D=legend" [ticklecharts::legend $args]
        }
        
        if {[dict exists $args -tooltip]} {
            lappend opts "@D=tooltip" [ticklecharts::tooltip $args]
        }

        if {[dict exists $args -grid]} {
            lappend opts "@D=grid" [ticklecharts::grid $args]
        }
        
        if {[dict exists $args -visualMap]} {
            lappend opts "@D=visualMap" [ticklecharts::visualMap $args]
        }

        if {[dict exists $args -toolbox]} {
            lappend opts "@L=toolbox" [ticklecharts::toolbox $args]
        }
        
        foreach {key value} $opts {
            set f [ticklecharts::OptsToEchartsHuddle $value]
            lappend _options $key [list {*}$f]
        }

    }

    # To keep the same logic of naming methods for ticklecharts 
    # the first letter in capital letter...
    forward Render my render

    # export method
    export AddBarSeries AddLineSeries AddPieSeries AddFunnelSeries AddRadarSeries AddScatterSeries
    export AddHeatmapSeries AddGraphic AddSunburstSeries AddTreeSeries AddThemeRiverSeries Render
    export Xaxis Yaxis RadiusAxis RadarCoordinate AngleAxis SetOptions SingleAxis
}

