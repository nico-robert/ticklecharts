# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
# ticklEcharts - Tcl wrapper for Apache ECharts. (https://echarts.apache.org/en/index.html)

# 08-Feb-2022 : v1.0 Initial release
# 16-Feb-2022 : v1.1
               # Add pie chart + visualMap.
               # Add demos line + pie + visualMap.
               # Bug fixes.
               # Add options.
# 19-Feb-2022 : v1.2
               # Add funnel chart + markArea.
               # Add markArea + funnel examples.
# 20-Feb-2022 : v1.3
               # Add radar chart.
               # Add radar, pie, layout examples.
# 22-Feb-2022 : v1.4
               # Add scatter + effectScatter chart.
               # Add scatter examples + line step example.
               # Add ::ticklecharts::htmlstdout variable to control stdout
               # for render html output.
# 28-Feb-2022 : v1.5
               # Add heatmap chart.
               # Add heatmap examples.
               # Add 'deleteseries' method to delete series chart.
               # Update README to explain `deleteseries` and `getoptions` methods.
# 06-Mar-2022 : v1.5.1
               # Add graphic (rect, circle, arc, line, text...)
               # Add graphic examples.
# 20-Mar-2022 : v1.5.2
               # Add toolbox option (A group of utility tools... Save as image, Zoom, Data view...)
               # Update chart examples to include toolbox utility.
               # Add examples with json data from apache echarts-examples (require http, tls, json packages from tcllib)
               # Add 'jsfunc' as huddle type, instead of using a 'string map' and 'dictionary' combination.
               # Patch for huddle.tcl (v0.3) 'proc ::huddle::jsondump'.
               # Add 'Render' method to keep the same logic of naming methods for ticklecharts,
               # the first letter in capital letter... Note : 'render' method is still active.
# 02-Apr-2022 : v1.5.3
               # Add '-validvalue' flag to respect the values by default according to the Echarts documentation (especially for string types) 
               # Update examples to reflect the changes.
# 04-Apr-2022 : v1.6
               # Add sunburst chart.
               # Add sunburst examples + correction line chart label position example.
# 07-Apr-2022 : v1.7
               # Add tree chart.
               # Add tree examples.
# 09-Apr-2022 : v1.8
               # Add themeRiver chart + singleAxis option.
               # Add themeRiver examples.
# 09-Apr-2022 : v1.8.1
               # Fix bug on adding multiple axis (xAxis, yAxis...). Not included in version 1.7
# 11-Apr-2022 : v1.9
               # Add sankey chart.
               # Add sankey examples.
# 16-Apr-2022 : v1.9.1
               # Added procedure to check if the options match the default values,
               # output warning message if option name doesn't exist or not supported.
               # Update chart examples to avoid warnings messages.
# 19-Apr-2022 : v1.9.2
               # Add dataZoom option (For zooming a specific area)
               # Add or update chart examples to include `dataZoom` option.
               # Fix bug for theming features.
# 30-Apr-2022 : v1.9.3
               # Add `dataset` option
               # Add chart examples to include `dataset` option.
# 04-May-2022 : v1.9.4
               # Add `pictorialBar` chart.
               # Add pictorialBar examples.
# 12-May-2022 : v1.9.5
               # Add `candlestick` chart.
               # Add candlestick examples.
# 26-May-2022 : v2.0.1
               # Replaces some huddle/ehuddle procedures by C functions,
               # with help of critcl package https://andreas-kupries.github.io/critcl/
               # Critcl package should be available and this command 'ticklecharts::eHuddleCritcl' should be set to valid Tcl boolean value.
               # Note : If a huddle type is added, it will not be supported, additional changes are expected.
               # Incompatibility -render flag renamed to -renderer (flag option to set `canvas` or `svg` renderer).
# 26-Jun-2022 : v2.1
               # Add `parallel` chart.
               # Add `parallel` examples. 
               # Add `brush` option (To select part of data from a chart to display in detail...)
# 27-Jun-2022 : v2.1.1
               # Add parallelAxis as method instead of a option. Update examples to reflect this change.
# 02-Aug-2022 : v2.2
               # Add `timeline` option (provides switching between charts)
               # Add timeline examples.
# 20-Aug-2022 : v2.3
               # Add `gauge` chart.
               # Add `gauge` examples.
               # Move huddle patch (0.3) proc from ehuddle.tcl to a new separate file (huddle_patch.tcl).
               # Cosmetic changes.
               # Add `toJSON` method for `timeline`class.
# 05-Sep-2022 : v2.3.1
               # Code refactoring
# 14-Oct-2022 : v2.4
               # Add `graph` chart.
               # Add `graph` examples.
# 21-Oct-2022 : v2.5
               # Add echarts-wordcloud (https://github.com/ecomfe/echarts-wordcloud).
               # Add `wordCloud` examples.
               # Adds the possibility to add one or more js script to the html template file.
# 30-Oct-2022 : v2.6
               # Add `boxplot` chart.
               # Add `boxplot` examples.
               # Incompatibility with previous version for 'dataset' class , dataset now accepts multiple 'source' for the same class.
               # Update 'dataset' examples to reflect this change.
# 07-Nov-2022 : v2.7
               # Add `treemap` chart.
               # Add `treemap` examples.
               # Add `axisPointer` option.
               # Add `-minversion` flag in args option, to control if the key or type is supported in current `Echarts` version, 
               # output `warning` message if it is not supported.
# 12-Nov-2022 : v2.8
               # Add `map` chart.
               # Add `map` examples.
               # Add `geo` option.
# 26-Nov-2022 : v2.8.1
               # Add `calendar` option.
               # Add `calendar` examples.
               # For `color` and `backgroundColor` properties, adds `eColor` class see 
               # pie_texture.tcl example(examples/pie/pie_textture.tcl).
# 02-Dec-2022 : v2.8.2
               # Bump to `v2.1.0` for echarts-wordcloud, update examples to reflect this changes.
               # Add `aria` option.
               # Add `aria` example.
               # Cosmetic changes.
# 08-Dec-2022 : v2.9
               # Add `gmap` extension(https://github.com/plainheart/echarts-extension-gmap). (_Note_: A Google Key API is required)
               # Add `lines` chart.
               # Add `lines` examples.
               # Cosmetic changes.
# 18-Dec-2022 : v2.9.1
               # The result of the ticklecharts::infoOptions command on the stdout is deleted, in favor of a result of a command.
               # New global variable `::ticklecharts::minProperties` see Global variables(#Globalvariables) section for detail.
               # `-class` and `-style` are added in `Render` method to control the class name and style respectively (_Note_ : `template.html` file is modified).
               # Cosmetic changes.
# 03-Jan-2023 : v2.9.2
               # Code refactoring
               # Update LICENSE year.
               # 'echarts-wordcloud.js' is inserted automatically when writing the html file. Update `wordcloud` examples to reflect this changes.
               # Cosmetic changes.
               # Add global options (useUTC, hoverLayerThreshold...) 
# 04-Feb-2023 : v3.0.1
               # Bump to `v5.4.1` for Echarts.
               # Add Echarts GL (3D)
               # Add `bar3D`, `line3D` and `surface` series.
               # Add `bar3D`, `line3D` and `surface` examples.
               # `::ticklecharts::theme` variable is supported with `::ticklecharts::minProperties` variable.
               # **Incompatibility** :
                    #  `render` method is no longer supported, it is replaced by `Render` method (Note the first letter in capital letter...).
                    #  `getoptions` method is renamed `getOptions`.
                    #  `gettype` method is renamed `getType` (internal method).
                    #  Rename `basic` theme to `custom` theme.
                    #  `theme.tcl` file has been completely reworked.
                    # Several options are no longer supported when initializing the `ticklecharts::chart` class, 
                    # all of these options are initialized in `Setoptions` method now.
                  # To keep the same `Echarts` logic, some _ticklEcharts_ properties are renamed :
                    # `-databaritem` is renamed `-dataBarItem`.
                    # `-datalineitem` is renamed `-dataLineItem`.
                    # `-datapieitem` is renamed `-dataPieItem`.
                    # `-datafunnelitem` is renamed `-dataFunnelItem`.
                    # `-dataradaritem` is renamed `-dataRadarItem`.
                    # `-datacandlestickitem` is renamed `-dataCandlestickItem`.
# 04-Mar-2023 : v3.1
                # Code refactoring.
                # `::tcl::unsupported::representation` Tcl command is replaced, in favor of 2 news class :
                # ticklecharts::eDict` (Internal class to replace `dict` Tcl command when initializing)
                # `ticklecharts::eList` (This class can replace the `list` Tcl command see [eListline.tcl](examples/line/eListline.tcl) to know
                # why this class has been implemented for certain cases...)
                # list.data (`list.d`) accepts now `null` values. (`set property [list {"string" 1 "null"}]` -> JSON result = `["string", 1, null]`)
# 22-Mar-2023 : v3.1.1
                # Support array for `dataset` dimension (with `ticklecharts::eList` class).
                # Adds a new method `RenderTsb` to interact with Taygete Scrap Book (https://wiki.tcl-lang.org/page/Taygete+Scrap+Book).
# 02-May-2023 : v3.1.2
                # Adds new `Add` method for `chart` and `chart3D` classes (To reflect this changes some examples + README file have been updated).   
                   # e.g : To add a `pie series` you should write like this : `$chart Add "pieSeries" -data ...` instead of      
                   # `$chart AddPieSeries -data ...` (Note: the `main` method is still active)   
                   #     Note : Probably that in my `next` major release, I would choose this way of writing to add a series...   
                   #     To ensure conformity with other classes (`Gridlayout`, `timeline`)
                # `RenderTsb` method has been updated :
                   #     New argument `-evalJSON` has been added (see [this file](examples/tsb/README.md) for detail).
                   #     This new minor release allows to load an entire `JS script` instead of `https://` link.
                # Adds a `trace` command for series (The goal here is to find if certain values match each other).   
                   # Currently only supported for `line` series.
                # Adds a new command `ticklecharts::urlExists?` + global variable `::ticklecharts::checkURL`   
                   # to verify if URL exists (disabled by default) when the num version changed. Uses `curl` command (Available for Windows and Mac OS)
                # Fixed a bug for the `multiversion` property, when the num version is lower than the `-minversion` property.
                # `pkgIndex.tcl` file has been completely reworked.
                # Cosmetic changes.
# 16-May-2023 : v3.1.3
                # Adds a new class `ticklecharts::eString` to replace a string.
                # Invoke `superclass` method for `chart3D`, `timeline` and `Gridlayout` classes.
                # Fixed a bug when the keys have a space `critcl::cproc critHuddleDump`.
                # dataset class support `ticklecharts::eDict` class for `-dimensions` property.
                # Keeps updating some examples to set new `Add` method for chart series.
                # Cosmetic changes.
# 24-Jun-2023 : v3.1.4
                # Update all examples with new `Add` method for chart series (The main method `AddXXXSeries` is still active).
                # A new argument `-template` for `Render` method has been added. This new argument can be used to   
                #   replace the html template file `template.html` with a string. See [this file](examples/scatter/scatter_logarithmic_regression.tcl) for detail.
                # A new property `-dataItem` has been added for item data, to replace this writing   
                #  `-dataXXXItem` (`XXX` refers to name series). All examples have been updated (The main method `-dataXXXItem` is still active).
                # list.data (`list.d`) accepts now this class `ticklecharts::eString`
                # Fixed a bug with the `superclass` method for timeline class.
                # `template.html` has been updated.
                # Cosmetic changes.
# 08-Jul-2023 : v3.1.5
                # Fixed a bug introduced with version 3.1.2, when Render method's argument have spaces in options.
                # Adds a series index for trace series command.
                # Cosmetic changes.

package require Tcl 8.6
package require huddle 0.3

namespace eval ticklecharts {
    variable version         3.1.5 ; # ticklEcharts version
    variable echarts_version 5.4.1 ; # Echarts version    (https://echarts.apache.org/en/changelog.html#v5-4-1)
    variable gl_version      2.0.9 ; # Echarts GL version (https://github.com/ecomfe/echarts-gl)
    variable wc_version      2.1.0 ; # wordCloud version  (https://github.com/ecomfe/echarts-wordcloud)
    variable gmap_version    1.5.0 ; # gmap version       (https://github.com/plainheart/echarts-extension-gmap)
    variable keyGMAPI        "??"  ; # Please replace '??' with your own API key.
    variable edir            [file dirname [file normalize [info script]]]
    variable theme           "custom"
    variable htmlstdout      "True"
    variable minProperties   "False"
    variable tsbIsReady      "False" ; # Tsb package.
    variable checkURL        "False" ; # Checks if a URL exists.
    variable htmltemplate    [file join $edir html template.html]
    variable escript         "https://cdn.jsdelivr.net/npm/echarts@${echarts_version}/dist/echarts.min.js"
    variable eGLscript       "https://cdn.jsdelivr.net/npm/echarts-gl@${gl_version}/dist/echarts-gl.min.js"
    variable wcscript        "https://cdn.jsdelivr.net/npm/echarts-wordcloud@${wc_version}/dist/echarts-wordcloud.min.js"
    variable gmscript        "https://cdn.jsdelivr.net/npm/echarts-extension-gmap@${gmap_version}/dist/echarts-extension-gmap.min.js"
    variable gapiscript      "https://maps.googleapis.com/maps/api/js?key=${keyGMAPI}"
}

package provide ticklecharts $::ticklecharts::version