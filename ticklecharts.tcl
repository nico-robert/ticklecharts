# Copyright (c) 2022 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
# ticklEcharts - Tcl wrapper for Apache ECharts. (https://echarts.apache.org/en/index.html)

# 08-02-2022 : v1.0   Initial release
# 16-02-2022 : v1.1
             # Add pie chart + visualMap.
             # Add demos line + pie + visualMap
             # Bug fixes
             # Add options

package require Tcl 8.6
package require huddle 0.3

set dir [file dirname [file normalize [info script]]]

source [file join $dir utils.tcl]
source [file join $dir chart.tcl]
source [file join $dir ehuddle.tcl]
source [file join $dir jsfunc.tcl]
source [file join $dir layout.tcl]
source [file join $dir global_options.tcl]
source [file join $dir series.tcl]
source [file join $dir options.tcl]
source [file join $dir theme.tcl]

namespace eval ticklecharts {

    variable version 1.1
    variable dir $dir
    variable theme "basic"
    variable opts_theme ""
    variable htmltemplate [file join $dir html template.html]
    variable script "https://cdn.jsdelivr.net/npm/echarts@5.2.2/dist/echarts.min.js"

}

namespace import ticklecharts::setdef ticklecharts::merge ticklecharts::Type

package provide ticklecharts $::ticklecharts::version