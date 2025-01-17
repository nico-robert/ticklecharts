# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

oo::class create ticklecharts::chart {
    variable _h           ; # huddle
    variable _options     ; # list options chart
    variable _opts_global ; # list global options chart
    variable _dataset     ; # dataset chart
    variable _trace       ; # trace properties chart
    variable _jschartvar  ; # js variable chart

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
        set _trace       {}

        # Guess if current script has a 'Gridlayout' dataset.
        if {[ticklecharts::gridlayoutHasDataSetObj dataset]} {
            set _dataset $dataset
        }
    }
}

oo::define ticklecharts::chart {

    method getONSClass {} {
        # Returns the name of the internal 
        # namespace of the object.
        return [info object namespace [self class]]
    }

    method get {} {
        # Gets huddle object.
        return $_h
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

    method setTrace {levelP value} {
        # Sets trace properties.
        #
        # levelP - level properties
        # value  - value properties
        #
        # Returns nothing
        lappend _trace $levelP $value

        return {}
    }

    method getTrace {} {
        # Returns trace properties.
        return $_trace
    }

    method track {} {
        # Compares properties.
        #
        # Returns nothing
        ticklecharts::track [my getTrace]

        return {}
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
        return [expr {[llength $ktype] > 1}]
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
                    # No value required.
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
                default {
                    error "Unknown key '$key' specified, should be '-series',\
                          '-option', '-globalOptions' or '-axis' property."
                }
            }

            if {$value eq ""} {
                error "A value should be specified with key property."
            }

            set info $value ; break
        }

        foreach method $methods {
            if {[catch {ticklecharts::classDef $typeOfClass $method} infomethod]} {continue}
            foreach linebody [split $infomethod "\n"] {
                regsub -all {[{}\[\]]} $linebody {} linebody
                set linebody [string trim $linebody]
                if {[string match -nocase "*ticklecharts::$info*" $linebody]} {
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
        set i -1 ; set j 0
        foreach {key opts} [my options] {
            if {[string match {*series} $key]} {
                if {[incr i] == $index} {
                    set _options [lreplace [my options] $j $j+1]
                    break
                }
            }
            incr j 2
        }

        return {}
    }

    method ToHuddle {} {
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
        set _h [ticklecharts::ehuddle new]

        foreach {key value} $opts {

            if {[string match {*series} $key]} {
                $_h append $key $value
            } elseif {[string match {*dataZoom} $key]} {
                $_h append $key $value
            } elseif {[string match {*calendar} $key]} {
                $_h append $key $value
            } elseif {[string match {*visualMap} $key]} {
                $_h append $key $value
            } elseif {[string match {*parallelAxis} $key]} {
                $_h append $key $value
            } elseif {[string match {*dataset} $key]} {
                $_h append $key $value
            } elseif {[regexp {xAxis|yAxis|radar} $key] && $mixed} {
                $_h append $key $value
            } else {
                $_h set $key $value
            }
        }

        return {}
    }

    method Render {args} {
        # Export chart to HTML file.
        #
        # args - Options described below.
        #
        # -outfile - full path HTML (default: [info script]/render.html)
        # Note : See 'toHTML' method for others properties.
        #
        # Returns full path HTML file.

        if {[llength $args] % 2} {
            error "wrong # args: should be \"[self] [self method]\
                   ?-title title? ...\""
        }

        # Gets arguments options
        set opts [ticklecharts::renderOptions $args [self method]]
        set outputFile [lindex [dict get $opts -outfile] 0]

        # Writes data in the HTML file.
        try {
            set fp   [open $outputFile w+]
            puts $fp [my toHTML {*}$opts]
        } on error {result options} {
            error [dict get $options -errorinfo]
        } finally {
            catch {close $fp}
        }

        if {$::ticklecharts::htmlstdout} {
            puts [format {html:%s} [file nativename $outputFile]]
        }

        # Deletes link variables when the current script is sourced.
        if {[ticklecharts::isSourced [info script]]} {
            ticklecharts::unsetVars [self]
        }

        return $outputFile
    }

    method toHTML {args} {
	    # Export chart as HTML fragment.
        #
        # args - Options described below.
        #
        # -title      - header title html
        # -width      - container's width
        # -height     - container's height
        # -renderer   - 'canvas' or 'svg'
        # -jschartvar - name chart var
        # -divid      - name id var
        # -jsecharts  - full path echarts.min.js (default: cdn script)
        # -jsvar      - name js var
        # -script     - list data (jsfunc), jsfunc.
        # -class      - container.
        # -style      - css style.
        # -template   - template (file or string).
        #
        # Returns HTML as a string

        if {[llength $args] % 2} {
            error "wrong # args: should be \"[self] [self method]\
                   ?-title title? ...\""
        }

        set json [my toJSON] ; # jsondump

        # Check if the method was invoked from 
        # inside another object method.
        if {![catch {self caller} infoCaller]} {
            set methodCall [lindex $infoCaller 2]
            set opts $args
        } else {
            # Gets arguments options
            set methodCall "nothing"
            set opts [ticklecharts::renderOptions $args [self method]]
        }

        set template [lindex [dict get $opts -template] 0]
        # Read html template
        if {$methodCall ne "RenderJupyter"} {
            set template [ticklecharts::readHTMLTemplate $template]
        }

        # SVG renderer is not supported with Echarts GL.
        set renderer [lindex [dict get $opts -renderer] 0]
        if {$renderer eq "svg"} {
            if {[my getType] eq "chart3D" || "globe" in [[my get] keys] ||
                [regexp {3D|surface|GL} [[my get] getTypeSeries]]} {
                error "wrong # args: 'svg' renderer is not supported\
                       with echarts-gl."
            }
        }

        # Save variable.
        set _jschartvar [lindex [dict get $opts -jschartvar] 0]

        set newhtml [ticklecharts::htmlMap [my get] $template $opts]

        # Replaces json data in and return HTML.
        return [string map [list %json% $json] [join $newhtml "\n"]]
    }

    method toJSON {} {
        # Returns json chart data.
        my track    ; # Compares properties values with each other.
        my ToHuddle ; # Transforms to huddle.

        # ehuddle jsondump
        return [[my get] dump]
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
        classvar indexxAxis

        set options [ticklecharts::xAxis [incr indexxAxis] [self] $args]
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
        classvar indexyAxis

        set options [ticklecharts::yAxis [incr indexyAxis] [self] $args]
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
        classvar indexradarC

        set options [ticklecharts::radarCoordinate [incr indexradarC] $args]
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

        set options [ticklecharts::singleAxis $args]
        set f [ticklecharts::optsToEchartsHuddle $options]

        lappend _options @D=singleAxis [list {*}$f]

        return {}
    }

    method ParallelAxis {value} {
        # Init ParallelAxis (available only for parallel chart)
        #
        # value - Options described below.
        #
        # gets default option values : [self] getOptions -axis Parallel
        # or
        # from doc : https://echarts.apache.org/en/option.html#parallelAxis
        #
        # Returns nothing

        foreach axis [ticklecharts::parallelAxis $value] {
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

    method AddJSON {struct {args ""}} {
        # Build your own JSON.
        #
        # This method can be used to add a structure to JSON
        # By default the structure will be added at the end,
        # but this can be changed by adding the '-parent' property.
        #
        # struct  - eStruct class
        # args    - Options described below (optional).
        # -parent : Allows you to add data to the structure.
        # and allows you to make a choice if several elements are found 
        # with an index (optional).
        #
        # Returns nothing

        if {![ticklecharts::iseStructClass $struct]} {
            error "wrong # args : '$struct' should be a\
                   eStruct class for '[self method]' method."
        }

        if {[dict exists $args -parent]} {
            set parent [dict get $args -parent]
            set i 0 ; set lLindex {}

            foreach child [split $parent "."] {
                # Removes num index if present
                regsub -line {\([0-9]+\)$} $child {} c

                set re [list (@D=|@L=|@DO=)$c]
                set l  [lindex $_options $lLindex]
                set index [lsearch -all -regexp $l $re]

                if {[llength $index] > 1} {
                    if {[regexp {\(([0-9]+)\)$} $child -> myindex]} {
                        set index [lindex $index $myindex]
                    } else {
                        set index [lindex $index end]
                    }
                }

                if {$index eq ""} {
                    error "wrong # args : '$parent' property\
                           doesn't exists."
                }

                if {[string match {@DO=*} [lindex $l $index]]} {
                    error "wrong # args : '@DO=*' type key\
                           is not supported."
                }

                set i [expr {$index + 1}] ; lappend lLindex $i
            }

            set options [$struct get]
            set f [ticklecharts::optsToEchartsHuddle $options]

            lappend lLindex "end+1"
            foreach elem $f {lset _options $lLindex $elem}

        } else {
            set options [$struct get]
            set f [ticklecharts::optsToEchartsHuddle $options]
            lappend _options {*}$f
        }

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
        # this way of writing to add a series, to ensure conformity with other
        # classes (layout, timeline)
        #
        # Returns nothing

        if {[llength [lrange $args 1 end]] % 2} {
            error "wrong # args: [self] Add '[lindex $args 0]'\
                   method must have an even number of elements."
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
                set lb [ticklecharts::classDef [self class] [self method]]
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
                error "wrong # args: First argument for '[self method]' method should\
                       be (case sensitive): '$series' instead of '[lindex $args 0]'"
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
            error "wrong # args: [self] SetOptions \$args must have\
                   an even number of elements."
        }

        set opts {}

        if {[dict exists $args -dataset]} {
            set dts [dict get $args -dataset]
            if {![ticklecharts::isdatasetClass $dts]} {
                error "Property '-dataset' should be a 'dataset' Class."
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
            # Keep compatibility with previous versions.
            # 'visualMap' now accepts 'multiple' lists or 'one' like before.
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
            # Keep compatibility with previous versions.
            # 'dataZoom' now accepts 'one' list or 'multiple' lists like before.
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
                error "wrong # args: Should be an object\
                      'eDict' or 'eList' for this key '$key'."
            }
        }

        return {}
    }

    # export of methods
    export AddBarSeries AddLineSeries AddPieSeries AddFunnelSeries AddRadarSeries AddScatterSeries \
           AddHeatmapSeries AddGraphic AddSunburstSeries AddTreeSeries AddThemeRiverSeries AddSankeySeries \
           Xaxis Yaxis RadiusAxis RadarCoordinate AngleAxis SetOptions SingleAxis Render AddPictorialBarSeries \
           AddCandlestickSeries AddParallelSeries ParallelAxis AddGaugeSeries AddGraphSeries AddWordCloudSeries \
           AddBoxPlotSeries AddTreeMapSeries AddMapSeries AddLinesSeries Add AddJSON
}