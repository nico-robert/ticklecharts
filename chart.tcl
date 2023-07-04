# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

oo::class create ticklecharts::chart {
    variable _echartshchart  ; # huddle
    variable _options        ; # list options chart
    variable _opts_global    ; # list global options chart
    variable _dataset        ; # dataset chart

    constructor {args} {
        # Initializes a new Chart Class.
        #
        # args - Options described below.
        #
        # -theme  - name theme see : theme.tcl
        #
        ticklecharts::setTheme $args ; # theme options
        set _opts_global {}
        set _options     {}
        set _dataset     {}

        # Guess if current script has a 'Gridlayout' dataset.
        if {[ticklecharts::gridlayoutHasDataSetObj dataset]} {
            set _dataset $dataset
        }
    }
}

oo::define ticklecharts::chart {

    method get {} {
        # Gets huddle object.
        return $_echartshchart
    }

    method options {} {
        # Gets chart list options.
        return $_options
    }

    method globalOptions {} {
        # Note : This variable can be empty.
        #
        # Returns global options.
        return $_opts_global
    }

    method getType {} {
        # Gets type class.
        return "chart"
    }

    method dataset {} {
        # Note : This variable can be empty.
        #
        # Returns dataset
        return $_dataset
    }

    method isMixed {} {
        # Check if series options 
        # have severals types (line, bar...).
        #
        # Returns true if severals types, otherwise false.
        set ktype {}

        foreach {key opts} [my options] {
            if {[string match {*series} $key]} {
                if {[dict exists $opts @S=type]} {
                    lappend ktype [dict get $opts @S=type]
                }
            }
        }
        return [expr {([llength $ktype] > 1) ? 1 : 0}]
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
        # according to a key (name of procedure).
        # If nothing is found then returns an empty string.

        set typeOfClass [ticklecharts::typeOfClass [self]]
        set methodClass [info class methods $typeOfClass]

        foreach {key value} $args {
            switch -exact -- $key {
                "-series" {
                    set methods [lsearch -all -inline -nocase $methodClass *series*]
                    lappend methods [lsearch -all -inline -nocase $methodClass *graphic*]
                }
                "-option" {
                    set methods {SetOptions}
                }
                "-globalOptions" {
                    # no value required...
                    if {[my getType] eq "chart3D"} {
                        return [ticklecharts::infoOptions "globalOptions3D"]
                    } else {
                        return [ticklecharts::infoOptions "globalOptions"]
                    }
                }
                "-axis" {
                    set methods [lsearch -all -inline -nocase $methodClass *axis*]
                    lappend methods [lsearch -all -inline -nocase $methodClass *coordinate*]
                }
                default {error "Unknown key '$key' specified"}
            }

            if {$value eq ""} {
                error "A value should be specified..."
            }

            set info $value
        }

        foreach method $methods {
            if {[catch {info class definition $typeOfClass $method} infomethod]} {continue}
            foreach linebody [split $infomethod "\n"] {
                set linebody [string map [list \{ "" \} "" \] "" \[ ""] $linebody]
                set linebody [string trim $linebody]
                if {[string match -nocase "*ticklecharts::*$info*" $linebody]} {
                    if {[regexp {ticklecharts::([A-Za-z0-9]+)\s} $linebody -> match]} {
                        return [ticklecharts::infoOptions $match]
                    }
                }
            }
        }

        return {}
    }

    method keys {} {
        # Returns keys without type.
        set k {}
        foreach {key opts} [my options] {
            lappend k [lindex [split $key "="] 1]
        }

        return $k
    }

    method deleteSeries {index} {
        # Delete series by index.
        #
        # Returns nothing
        set i -1 ; set j 0 ; set k 0
        foreach {key opts} [my options] {
            if {[string match {*series} $key]} {
                if {[incr i] == $index} {
                    set k 1 ; break
                }
            }
            incr j 2
        }

        if {$k} {set _options [lreplace [my options] $j [expr {$j + 1}]]}

        return {}
    }

    method chartToHuddle {} {
        # Transform list to ehudlle.
        #
        # Returns nothing

        set opts [my options]

        # If globalOptions is not defined, adds global options first...
        if {![llength [my globalOptions]]} {
            set optsg  [ticklecharts::globalOptions {}]
            set optsEH [ticklecharts::optsToEchartsHuddle [$optsg get]]
            set opts   [linsert $opts 0 {*}$optsEH]
        }

        set mixed [my isMixed]

        # init ehuddle.
        set _echartshchart [ticklecharts::ehuddle new]

        foreach {key value} $opts {

            if {[string match {*series} $key]} {
                $_echartshchart append $key $value
            } elseif {[string match {*dataZoom} $key]} {
                $_echartshchart append $key $value
            } elseif {[string match {*calendar} $key]} {
                $_echartshchart append $key $value
            } elseif {[string match {*visualMap} $key]} {
                $_echartshchart append $key $value
            } elseif {[string match {*parallelAxis} $key]} {
                $_echartshchart append $key $value
            } elseif {[string match {*dataset} $key]} {
                $_echartshchart append $key $value
            } elseif {[regexp {xAxis|yAxis|radar} $key] && $mixed} {
                $_echartshchart append $key $value
            } else {
                $_echartshchart set $key $value
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

        if {!$::ticklecharts::tsbIsReady} {
            error "::tsb file should be sourced..."
        }

        if {[llength $args] % 2} {
            error "wrong # args: should be '[self] RenderTsb'\
                   ?-renderer renderer? ..."
        }

        set json [my toJSON] ; # jsondump

        set opts_tsb [ticklecharts::tsbOptions $args]
        set height   [lindex [dict get $opts_tsb -height] 0]
        set renderer [lindex [dict get $opts_tsb -renderer] 0]
        set merge    [lindex [dict get $opts_tsb -merge] 0]
        set evalJSON [lindex [dict get $opts_tsb -evalJSON] 0]

        if {!$evalJSON} {
            if {[my getType] eq "timeline"} {
                foreach c [my charts] {ticklecharts::checkJsFunc [$c options]} 
            } else {
                ticklecharts::checkJsFunc [my options]
            }
        }

        set uuid $::ticklecharts::etsb::uuid
        # load if necessary 'echarts' js script...
        #
        set type ""
        foreach script {escript eGLscript wcscript} {
            set ejs [set ::ticklecharts::$script]
            if {[dict exists $::ticklecharts::etsb::path $script]} {
                set type "text"
            } else {
                if {[ticklecharts::isURL? $ejs]} {
                    set type "source"
                } else {
                    # If I understand, it is not possible to insert 
                    # a local file directly with the 'src' attribute in Webview.
                    #
                    try {
                        set f [open $ejs r] ; # read *.js file
                        set ejs [read $f] ; close $f
                        # write full js script... inside tsb
                        set ::ticklecharts::$script $ejs
                        set type "text"
                        dict incr ::ticklecharts::etsb::path $script
                    } on error {result options} {
                        error [dict get $options -errorinfo]
                    }
                }
            }
            $::W call eSrc $ejs [format {%s_%s} $script $uuid] $type
        }
        set idEDiv [format {id_%s%s} $uuid $::ID]
        # set div + echarts height
        #
        $::W call eDiv $idEDiv $height
        # 
        after 100 [list $::W call eSeries \
                                  $idEDiv $json \
                                  $renderer $merge \
                                  $evalJSON]

        set ::ticklecharts::theme "custom"

        return {}
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

        if {[llength $args] % 2} {
            error "wrong # args: should be '[self] Render'\
                   ?-title title? ..."
        }

        set json [my toJSON] ; # jsondump
        # arguments options
        set opts_html  [ticklecharts::htmlOptions $args]
        set outputFile [lindex [dict get $opts_html -outfile] 0]
        set jsvar      [lindex [dict get $opts_html -jsvar] 0]
        set template   [lindex [dict get $opts_html -template] 0]

        # Read html template
        set htemplate [ticklecharts::readHTMLTemplate $template]
        set newhtml   [ticklecharts::htmlMap [my get] $htemplate $opts_html]

        # Replaces json data in html...
        set jsonData [string map [list %json% $json] $newhtml]

        try {
            set   fp [open $outputFile w+]
            puts  $fp $jsonData
            close $fp
        } on error {result options} {
            error [dict get $options -errorinfo]
        }

        if {$::ticklecharts::htmlstdout} {
            puts [format {html:%s} [file nativename $outputFile]]
        }

        return $outputFile
    }

    method toJSON {} {
        # Returns json chart data.
        my chartToHuddle ; # transform to huddle

        # ehuddle jsondump
        return [[my get] toJSON]
    }

    method Xaxis {args} {
        # Init X axis chart
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis X
        # or
        # from doc : https://echarts.apache.org/en/option.html#xAxis
        #
        # Returns nothing
        set mykeys [my keys]

        if {"radiusAxis" in $mykeys || "angleAxis" in $mykeys} {
            error "radiusAxis or angleAxis not supported with 'Xaxis'"
        }

        set options [ticklecharts::xAxis [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=xAxis [list {*}$f]

        return {}
    }

    method Yaxis {args} {
        # Init Y axis chart
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis Y
        # or
        # from doc : https://echarts.apache.org/en/option.html#yAxis
        #
        # Returns nothing
        set mykeys [my keys]

        if {"radiusAxis" in $mykeys || "angleAxis" in $mykeys} {
            error "radiusAxis or angleAxis not supported with 'Yaxis'"
        }

        set options [ticklecharts::yAxis [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=yAxis [list {*}$f]

        return {}
    }

    method RadiusAxis {args} {
        # Init Radius axis chart (available only for polar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis Radius
        # or
        # from doc : https://echarts.apache.org/en/option.html#radiusAxis
        #
        # Returns nothing
        set mykeys [my keys]

        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'radiusAxis'"
        }

        set options [ticklecharts::radiusAxis $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @L=radiusAxis [list {*}$f]

        return {}
    }

    method AngleAxis {args} {
        # Init Angle axis chart (available only for polar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis Angle
        # or
        # from doc : https://echarts.apache.org/en/option.html#angleAxis
        #
        # Returns nothing
        set mykeys [my keys]

        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'angleAxis'"
        }

        set options [ticklecharts::angleAxis $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @L=angleAxis [list {*}$f]

        return {}
    }

    method AddGraphic {args} {
        # Add elements (text, rect, circle...) to chart
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -serie Graphic
        # or
        # from doc : https://echarts.apache.org/en/option.html#graphic
        #
        # Returns nothing

        set options [ticklecharts::graphic $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @L=graphic [list {*}$f]

        return {}
    }

    method RadarCoordinate {args} {
        # Init Radar coordinate (available only for radar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis RadarCoordinate
        # or
        # from doc : https://echarts.apache.org/en/option.html#radar
        #
        # Returns nothing
        set mykeys [my keys]

        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'Radar coordinate'"
        }

        set options [ticklecharts::radarCoordinate $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=radar [list {*}$f]

        return {}
    }

    method SingleAxis {args} {
        # Init singleAxis
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis Single
        # or
        # from doc : https://echarts.apache.org/en/option.html#singleAxis
        #
        # Returns nothing
        set mykeys [my keys]

        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'SingleAxis'"
        }

        set options [ticklecharts::singleAxis $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=singleAxis [list {*}$f]

        return {}
    }

    method ParallelAxis {args} {
        # Init ParallelAxis (available only for parallel chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -axis Parallel
        # or
        # from doc : https://echarts.apache.org/en/option.html#parallelAxis
        #
        # Returns nothing
        set mykeys [my keys]

        if {"xAxis" in $mykeys || "yAxis" in $mykeys} {
            error "xAxis or yAxis not supported with 'parallelAxis'"
        }

        set options [ticklecharts::parallelAxis $args]
        foreach axis $options {
            set f [ticklecharts::optsToEchartsHuddle $axis]
            lappend _options @D=parallelAxis [list {*}$f]
        }

        return {}
    }

    method AddBarSeries {args} {
        # Add data series chart (use only for bar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series bar
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-bar
        #
        # Returns nothing
        classvar indexbarseries

        set options [ticklecharts::barSeries [incr indexbarseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddLineSeries {args} {
        # Add data series chart (use only for line chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series line
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-line
        #
        # Returns nothing
        classvar indexlineseries

        set options [ticklecharts::lineSeries [incr indexlineseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddPieSeries {args} {
        # Add data series chart (use only for pie chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series pie
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-pie
        #
        # Returns nothing
        classvar indexpieseries

        set options [ticklecharts::pieSeries [incr indexpieseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddFunnelSeries {args} {
        # Add data series chart (use only for funnel chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series funnel
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-funnel
        #
        # Returns nothing
        classvar indexfunnelseries

        set options [ticklecharts::funnelSeries [incr indexfunnelseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddRadarSeries {args} {
        # Add data series chart (use only for radar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series radar
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-radar
        #
        # Returns nothing
        classvar indexradarseries

        set options [ticklecharts::radarSeries [incr indexradarseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddScatterSeries {args} {
        # Add data series chart (use only for scatter chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series scatter
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-scatter
        #
        # Returns nothing
        classvar indexscatterseries

        set options [ticklecharts::scatterSeries [incr indexscatterseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddHeatmapSeries {args} {
        # Add data series chart (use only for heatmap chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series heatmap
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-heatmap
        #
        # Returns nothing
        classvar indexheatmapseries

        set options [ticklecharts::heatmapSeries [incr indexheatmapseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddSunburstSeries {args} {
        # Add data series chart (use only for sunburst chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series sunburst
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-sunburst
        #
        # Returns nothing
        classvar indexsunburstseries

        set options [ticklecharts::sunburstSeries [incr indexsunburstseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddTreeSeries {args} {
        # Add data series chart (use only for tree chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series tree
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-tree
        #
        # Returns nothing
        classvar indextreeseries

        set options [ticklecharts::treeSeries [incr indextreeseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddThemeRiverSeries {args} {
        # Add data series chart (use only for themeRiver chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series themeRiver
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-themeriver
        #
        # Returns nothing
        classvar indexthemeriverseries

        set options [ticklecharts::themeRiverSeries [incr indexthemeriverseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddSankeySeries {args} {
        # Add data series chart (use only for Sankey chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series sankey
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-sankey
        #
        # Returns nothing
        classvar indexsankeyseries

        set options [ticklecharts::sankeySeries [incr indexsankeyseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddPictorialBarSeries {args} {
        # Add data series chart (use only for pictorialBar chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series pictorialBar
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-pictorialBar
        #
        # Returns nothing
        classvar indexpictorialbarseries

        set options [ticklecharts::pictorialBarSeries [incr indexpictorialbarseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddCandlestickSeries {args} {
        # Add data series chart (use only for candlestick chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series candlestick
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-candlesticks
        #
        # Returns nothing 
        classvar indexcandlestickseries

        set options [ticklecharts::candlestickSeries [incr indexcandlestickseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddParallelSeries {args} {
        # Add data series chart (use only for parallel chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series parallel
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-parallel
        #
        # Returns nothing
        classvar indexparallelseries

        set options [ticklecharts::parallelSeries [incr indexparallelseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddGaugeSeries {args} {
        # Add data series chart (use only for gauge chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series gauge
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-gauge
        #
        # Returns nothing
        classvar indexgaugeseries

        set options [ticklecharts::gaugeSeries [incr indexgaugeseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddGraphSeries {args} {
        # Add data series chart (use only for graph chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series graph
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-graph
        #
        # Returns nothing
        classvar indexgraphseries

        set options [ticklecharts::graphSeries [incr indexgraphseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddWordCloudSeries {args} {
        # Add data series chart (use only for wordCloud chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series wordcloud
        # or
        # from doc : https://github.com/ecomfe/echarts-wordcloud
        #
        # Returns nothing
        classvar indexwordCloudseries

        set options [ticklecharts::wordcloudSeries [incr indexwordCloudseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddBoxPlotSeries {args} {
        # Add data series chart (use only for boxplot chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series boxplot
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-boxplot
        #
        # Returns nothing
        classvar indexboxplotseries

        set options [ticklecharts::boxplotSeries [incr indexboxplotseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddTreeMapSeries {args} {
        # Add data series chart (use only for treemap chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series treemap
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-treemap
        #
        # Returns nothing
        classvar indextreemapseries

        set options [ticklecharts::treemapSeries [incr indextreemapseries] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddMapSeries {args} {
        # Add data series chart (use only for map chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series map
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-map
        #
        # Returns nothing
        classvar indexmapseries

        set options [ticklecharts::mapSeries [incr indexmapseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method AddLinesSeries {args} {
        # Add data series chart (use only for lines chart)
        #
        # args - Options described below.
        #
        # gets default option values : [self] getOptions -series lines
        # or
        # from doc : https://echarts.apache.org/en/option.html#series-lines
        #
        # Returns nothing
        classvar indexlinesseries

        set options [ticklecharts::linesSeries [incr indexlinesseries] [self] $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=series [list {*}$f]

        return {}
    }

    method Add {args} {
        # This method is identical to methods for adding series, it is a 
        # different way of writing it.
        #
        # The first argument takes the name of the series to be added
        # By example to add a line series, you should write like this :
        # > $chart Add "lineSeries" -data ...
        # It is the same thing that main method.
        #
        # Note : Probably that in my next major release, I would choose
        # this way of writing to add a series... To ensure conformity with other
        # classes (layout, timeline)
        #
        # Returns nothing

        if {[llength [lrange $args 1 end]] % 2} {
            error "item list for '\[self] Add '[lindex $args 0]' method...'\
                   must have an even number of elements."
        }

        switch -exact -- [lindex $args 0] {
            "barSeries"          {my AddBarSeries           {*}[lrange $args 1 end]}
            "lineSeries"         {my AddLineSeries          {*}[lrange $args 1 end]}
            "pieSeries"          {my AddPieSeries           {*}[lrange $args 1 end]}
            "funnelSeries"       {my AddFunnelSeries        {*}[lrange $args 1 end]}
            "radarSeries"        {my AddRadarSeries         {*}[lrange $args 1 end]}
            "scatterSeries"      {my AddScatterSeries       {*}[lrange $args 1 end]}
            "heatmapSeries"      {my AddHeatmapSeries       {*}[lrange $args 1 end]}
            "graphic"            {my AddGraphic             {*}[lrange $args 1 end]}
            "sunburstSeries"     {my AddSunburstSeries      {*}[lrange $args 1 end]}
            "treeSeries"         {my AddTreeSeries          {*}[lrange $args 1 end]}
            "themeRiverSeries"   {my AddThemeRiverSeries    {*}[lrange $args 1 end]}
            "sankeySeries"       {my AddSankeySeries        {*}[lrange $args 1 end]}
            "pictorialBarSeries" {my AddPictorialBarSeries  {*}[lrange $args 1 end]}
            "candlestickSeries"  {my AddCandlestickSeries   {*}[lrange $args 1 end]}
            "parallelSeries"     {my AddParallelSeries      {*}[lrange $args 1 end]}
            "gaugeSeries"        {my AddGaugeSeries         {*}[lrange $args 1 end]}
            "graphSeries"        {my AddGraphSeries         {*}[lrange $args 1 end]}
            "wCSeries"           -
            "wordCloudSeries"    {my AddWordCloudSeries     {*}[lrange $args 1 end]}
            "boxPlotSeries"      {my AddBoxPlotSeries       {*}[lrange $args 1 end]}
            "treeMapSeries"      {my AddTreeMapSeries       {*}[lrange $args 1 end]}
            "mapSeries"          {my AddMapSeries           {*}[lrange $args 1 end]}
            "linesSeries"        {my AddLinesSeries         {*}[lrange $args 1 end]}
            default              {
                set lb [info class definition [self class] [self method]]
                set series {}
                foreach line [split $lb "\n"] {
                    set line [string trim $line]
                    if {[regexp {\"([a-zA-Z]+)\"\s+(\{my|-)} $line -> case]} {
                        lappend series $case
                    }
                }
                set series [lsort -dictionary $series]
                set series [format {%s or %s} \
                           [join [lrange $series 0 end-1] ", "] \
                           [lindex $series end]]
                error "First argument should be (case sensitive): '$series'\
                       instead of '[lindex $args 0]'"
            }
        }

        return {}
    }

    method SetOptions {args} {
        # Add options chart (available for all charts)
        #
        # gets default option values e.g : [self] getOptions -option toolbox
        #
        # args - Options described below.
        # 
        # Global options :
        # -darkMode                - https://echarts.apache.org/en/option.html#darkMode
        # -backgroundColor         - https://echarts.apache.org/en/option.html#backgroundColor
        # -color                   - https://echarts.apache.org/en/option.html#color
        # -animation               - https://echarts.apache.org/en/option.html#animation
        # -animationDuration       - https://echarts.apache.org/en/option.html#animationDuration
        # -animationDurationUpdate - https://echarts.apache.org/en/option.html#animationDurationUpdate
        # -animationDelayUpdate    - https://echarts.apache.org/en/option.html#animationDelayUpdate
        # -animationEasing         - https://echarts.apache.org/en/option.html#animationEasing
        # -animationEasingUpdate   - https://echarts.apache.org/en/option.html#animationEasingUpdate
        # -animationThreshold      - https://echarts.apache.org/en/option.html#animationThreshold
        # -progressiveThreshold    - https://echarts.apache.org/en/option.html#progressiveThreshold
        # -hoverLayerThreshold     - https://echarts.apache.org/en/option.html#hoverLayerThreshold
        # -useUTC                  - https://echarts.apache.org/en/option.html#useUTC
        # -blendMode               - https://echarts.apache.org/en/option.html#blendMode
        # Options :
        # -dataset                 - https://echarts.apache.org/en/option.html#dataset
        # -title                   - https://echarts.apache.org/en/option.html#title
        # -polar                   - https://echarts.apache.org/en/option.html#polar
        # -legend                  - https://echarts.apache.org/en/option.html#legend
        # -tooltip                 - https://echarts.apache.org/en/option.html#tooltip
        # -grid                    - https://echarts.apache.org/en/option.html#grid
        # -visualMap               - https://echarts.apache.org/en/option.html#visualMap
        # -toolbox                 - https://echarts.apache.org/en/option.html#toolbox
        # -dataZoom                - https://echarts.apache.org/en/option.html#dataZoom
        # -parallel                - https://echarts.apache.org/en/option.html#parallel
        # -brush                   - https://echarts.apache.org/en/option.html#brush
        # -axisPointer             - https://echarts.apache.org/en/option.html#axisPointer
        # -geo                     - https://echarts.apache.org/en/option.html#geo
        # -calendar                - https://echarts.apache.org/en/option.html#calendar
        # -aria                    - https://echarts.apache.org/en/option.html#aria
        # -gmap                    - https://github.com/plainheart/echarts-extension-gmap
        #
        # Returns nothing
        if {[llength $args] % 2} {
            error "[self] SetOptions \$args must have an even number of elements..."
        }

        set opts {}

        if {[dict exists $args -dataset]} {
            set dts [dict get $args -dataset]
            if {![ticklecharts::isdatasetClass $dts]} {
                error "key value '-dataset' should be a 'dataset' Class..."
            }

            foreach itemD [$dts get] {
                lappend opts "@D=dataset" [new edict $itemD]
            }

            # set dataset chart instance.
            set _dataset $dts
        }

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
            # v2.8.1
            # keep compatibility with previous versions...
            # 'visualMap' now accepts 'multiple' lists or 'one' like before...
            set key "-visualMap"
            if {![ticklecharts::keyValueIsListOfList $args $key]} {
                dict set args $key [list [dict get $args $key]]
            }
            foreach mapValue [dict get $args $key] {
                lappend opts "@D=visualMap" [ticklecharts::visualMap [list $key $mapValue]]
            }
        }

        if {[dict exists $args -toolbox]} {
            lappend opts "@L=toolbox" [ticklecharts::toolbox $args]
        }

        if {[dict exists $args -dataZoom]} {
            # v3.0.1
            # keep compatibility with previous versions...
            # 'dataZoom' now accepts 'one' list or 'multiple' lists like before...
            set key "-dataZoom"
            if {![ticklecharts::keyValueIsListOfList $args $key]} {
                dict set args $key [list [dict get $args $key]]
            }
            foreach itemZ [dict get $args $key] {
                lappend opts "@D=dataZoom" [ticklecharts::dataZoom [list $key $itemZ]]
            }
        }

        if {[dict exists $args -parallel]} {
            lappend opts "@D=parallel" [ticklecharts::parallel $args]
        }

        if {[dict exists $args -brush]} {
            lappend opts "@L=brush" [ticklecharts::brush $args]
        }

        if {[dict exists $args -axisPointer]} {
            lappend opts "@L=axisPointer" [ticklecharts::axisPointerGlobal $args]
        }

        if {[dict exists $args -geo]} {
            lappend opts "@L=geo" [ticklecharts::geo $args]
        }

        if {[dict exists $args -calendar]} {
            set key "-calendar"
            if {![ticklecharts::keyValueIsListOfList $args $key]} {
                dict set args $key [list [dict get $args $key]]
            }
            foreach cValue [dict get $args $key] {
                lappend opts "@D=calendar" [ticklecharts::calendar [list $key $cValue]]
            }
        }

        if {[dict exists $args -aria]} {
            lappend opts "@L=aria" [ticklecharts::aria $args]
        }

        if {[dict exists $args -gmap]} {
            lappend opts "@L=gmap" [ticklecharts::gmap $args]
        }

        # delete keys from args to avoid warning for global options
        set keyopts [lmap k [dict keys $opts] {lassign [split $k "="] _ key ; format -%s $key}]
        set args [dict remove $args {*}$keyopts]

        # Adds global options first 
        if {![llength [my globalOptions]]} {
            set optsg        [ticklecharts::globalOptions $args]
            set _opts_global [ticklecharts::optsToEchartsHuddle [$optsg get]]
            lappend _options {*}$_opts_global
        }

        foreach {key value} $opts {
            if {[ticklecharts::iseDictClass $value] || [ticklecharts::iseListClass $value]} {
                set f [ticklecharts::optsToEchartsHuddle [$value get]]
                lappend _options $key [list {*}$f]
            } else {
                error "should be an object... eDict or eList for this key: '$key'"
            }
        }

        return {}
    }

    # export of methods
    export AddBarSeries AddLineSeries AddPieSeries AddFunnelSeries AddRadarSeries AddScatterSeries \
           AddHeatmapSeries AddGraphic AddSunburstSeries AddTreeSeries AddThemeRiverSeries AddSankeySeries \
           Xaxis Yaxis RadiusAxis RadarCoordinate AngleAxis SetOptions SingleAxis Render AddPictorialBarSeries \
           AddCandlestickSeries AddParallelSeries ParallelAxis AddGaugeSeries AddGraphSeries AddWordCloudSeries \
           AddBoxPlotSeries AddTreeMapSeries AddMapSeries AddLinesSeries RenderTsb Add
}