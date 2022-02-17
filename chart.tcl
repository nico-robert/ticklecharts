# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.

oo::class create ticklecharts::chart {
    variable _echartshchart   ; # huddle
    variable _options         ; # list options chart
    variable _indexlineseries ; # index line serie
    variable _indexbarseries  ; # index bar serie
    variable _indexpieseries  ; # index pie serie

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

    method chartToHuddle {} {
        # Transform list to hudlle
        #
        # Returns nothing
        set mixed [my ismixed]
        
        foreach {key opts} $_options {

            if {[string match {*series} $key]} {
                $_echartshchart append $key $opts
            } elseif {[regexp {xAxis|yAxis} $key] && $mixed} {
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

    method Xaxis {args} {
        # Init X axis chart
        #
        # args - Options described below.
        #
        # get default value options : [self] getoptions setXAxis
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
        # get default value options : [self] getoptions setYAxis
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
        # get default value options : [self] getoptions SetRadiusAxis
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
        # get default value options : [self] getoptions SetAngleAxis
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
    
    
    method AddBarSeries {args} {
        # Add data serie chart (use only for bar chart)
        #
        # args - Options described below.
        #
        # get default value options : [self] getoptions barseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-bar
        #
        # Returns nothing      
        incr _indexlineseries

        set options [ticklecharts::barseries $_indexlineseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }
    
    method AddLineSeries {args} {
        # Add data serie chart (use only for line chart)
        #
        # args - Options described below.
        #
        # get default value options : [self] getoptions lineseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-line
        #
        # Returns nothing     
        incr _indexbarseries

        set options [ticklecharts::lineseries $_indexbarseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }

    method AddPieSeries {args} {
        # Add data serie chart (use only for line chart)
        #
        # args - Options described below.
        #
        # get default value options : [self] getoptions pieseries
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-pie
        #
        # Returns nothing     
        incr _indexpieseries

        set options [ticklecharts::pieseries $_indexpieseries $args]
        set f [ticklecharts::OptsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

    }
    
    method SetOptions {args} {
        # Add options chart (available for all charts)
        #
        # args - Options described below.
        # 
        # -title     - title options  (https://echarts.apache.org/en/option.html#title)
        # -polar     - polar options  (https://echarts.apache.org/en/option.html#polar)
        # -legend    - legend options (https://echarts.apache.org/en/option.html#legend)
        # -tooltip   - polar options  (https://echarts.apache.org/en/option.html#tooltip)
        # -grid      - grid options   (https://echarts.apache.org/en/option.html#grid)
        # -visualMap - grid options   (https://echarts.apache.org/en/option.html#visualMap)
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
        
        foreach {skey svalue} $opts {
        
            set f [ticklecharts::OptsToEchartsHuddle $svalue]
            lappend _options $skey [list {*}$f]

        }

    }
    # export method
    export AddBarSeries AddLineSeries AddPieSeries
    export Xaxis Yaxis RadiusAxis AngleAxis SetOptions
}

