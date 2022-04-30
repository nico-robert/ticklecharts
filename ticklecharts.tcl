# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
# ticklEcharts - Tcl wrapper for Apache ECharts. (https://echarts.apache.org/en/index.html)

# 08-02-2022 : v1.0 Initial release
# 16-02-2022 : v1.1
               # Add pie chart + visualMap.
               # Add demos line + pie + visualMap.
               # Bug fixes.
               # Add options.
# 19-02-2022 : v1.2
               # Add funnel chart + markArea.
               # Add markArea + funnel examples.
# 20-02-2022 : v1.3
               # Add radar chart.
               # Add radar, pie, layout examples.
# 22-02-2022 : v1.4
               # Add scatter + effectScatter chart.
               # Add scatter examples + line step example.
               # Add ::ticklecharts::htmlstdout variable to control stdout
               # for render html output.
# 28-02-2022 : v1.5
               # Add heatmap chart.
               # Add heatmap examples.
               # Add 'deleteseries' method to delete serie chart.
               # Update README to explain `deleteseries` and `getoptions` methods.
# 06-03-2022 : v1.5.1
               # Add graphic (rect, circle, arc, line, text...)
               # Add graphic examples.
# 20-03-2022 : v1.5.2
               # Add toolbox option (A group of utility tools... Save as image, Zoom, Data view...)
               # Update chart examples to include toolbox utility.
               # Add examples with json data from apache echarts-examples (require http, tls, json packages from tcllib)
               # Add 'jsfunc' as huddle type, instead of using a 'string map' and 'dictionary' combination.
               # Patch for huddle.tcl (v0.3) 'proc ::huddle::jsondump'.
               # Add 'Render' method to keep the same logic of naming methods for ticklecharts,
               # the first letter in capital letter... Note : 'render' method is still active.
# 02-04-2022 : v1.5.3
               # Add '-validvalue' flag to respect the values by default according to the Echarts documentation (especially for string types) 
               # Update examples to reflect the changes.
# 04-04-2022 : v1.6
               # Add sunburst chart.
               # Add sunburst examples + correction line chart label position example.
# 07-04-2022 : v1.7
               # Add tree chart.
               # Add tree examples.
# 09-04-2022 : v1.8
               # Add themeRiver chart + singleAxis option.
               # Add themeRiver examples.
# 09-04-2022 : v1.8.1
               # Fix bug on adding multiple axis (xAxis, yAxis...). Not included in version 1.7
# 11-04-2022 : v1.9
               # Add sankey chart.
               # Add sankey examples.
# 16-04-2022 : v1.9.1
               # Added procedure to check if the options match the default values,
               # output warning message if option name doesn't exist or not supported.
               # Update chart examples to avoid warnings messages.
# 19-04-2022 : v1.9.2
               # Add dataZoom option (For zooming a specific area)
               # Add or update chart examples to include `dataZoom` option.
               # Fix bug for theming features.
# 30-04-2022 : v1.9.3
               # Add `dataset` option
               # Add chart examples to include `dataset` option.

package require Tcl 8.6
package require huddle 0.3

set dir [file dirname [file normalize [info script]]]

source [file join $dir utils.tcl]
source [file join $dir chart.tcl]
source [file join $dir ehuddle.tcl]
source [file join $dir eformat.tcl]
source [file join $dir jsfunc.tcl]
source [file join $dir layout.tcl]
source [file join $dir global_options.tcl]
source [file join $dir series.tcl]
source [file join $dir options.tcl]
source [file join $dir theme.tcl]
source [file join $dir dataset.tcl]

namespace eval ticklecharts {

    variable version 1.9.3
    variable echarts_version 5.2.2
    variable dir $dir
    variable theme "basic"
    variable htmlstdout 1
    variable opts_theme {}
    variable htmltemplate [file join $dir html template.html]
    variable script "https://cdn.jsdelivr.net/npm/echarts@${echarts_version}/dist/echarts.min.js"

}

namespace import ticklecharts::setdef ticklecharts::merge ticklecharts::Type \
                 ticklecharts::InfoNameProc ticklecharts::formatEcharts \
                 ticklecharts::EchartsOptsTheme

package provide ticklecharts $::ticklecharts::version