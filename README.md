ticklEcharts - chart library
==========================
Tcl wrapper for [Apache ECharts](https://echarts.apache.org/en/index.html) (JavaScript Visualization library).

Dependencies :
-------------------------

`huddle` package from [Tcllib](https://core.tcl-lang.org/tcllib/doc/trunk/embedded/index.md)

Usage :
-------------------------

```tcl
package require ticklecharts

set chart [ticklecharts::chart new]

$chart Xaxis -data [list {Mon Tue Wed Thu Fri Sat Sun}]
$chart Yaxis
$chart AddLineSeries -data [list {150 230 224 218 135 147 260}]

$chart Render
```
![Basic line chart](images/line_basic_chart.png)
```tcl
# Initializes a new 2D Chart Class
set chart [ticklecharts::chart new]
```
##### :heavy_check_mark: Arguments available :
| args | Type | Description
| ------ | ------ | ------
| _-backgroundColor_ | str \| jsfunc \| e.color | Canvas color background (hex, rgb, rgba color)
| _-color_ | list.s \| e.color | Colors series (default `Echarts Color Theme`)
| _-animation_ | boolean | chart animation (default `True`)
| _-others_ | _ | animation sub options (see proc: `ticklecharts::globalOptions` in `global_options.tcl`)
| _-theme_ | str | set the default theme for chart instance (default `basic`) possible values: `vintage,westeros,wonderland,dark`
```tcl
# Demo
set chart [ticklecharts::chart new -color [list {red blue green}] -animation "False" -theme "vintage"]
```
```tcl
# Initializes X axis with values
$chart Xaxis -data [list {Mon Tue Wed Thu Fri Sat Sun}]
```
:warning: Important `-data` option should be a `[list {...}]` and not `{{...}}`
```tcl
# Initializes Y axis
$chart Yaxis
```
```tcl
# Initializes line series
$chart AddLineSeries -data [list {150 230 224 218 135 147 260}]
```
Here `-data` corresponds to the Y values. (:warning: `-data` option should be a `[list {...}]` and not `{{...}}`)

```tcl
# Export chart to html
$chart Render
```
##### :heavy_check_mark: Arguments available :
| args | Description
| ------ | ------
| _-title_ | header title html (default value : `"ticklEcharts !!!"`)
| _-width_ | size html canvas  (default value : `900px`)
| _-height_ | size html canvas (default value : `500px`)
| _-renderer_ | `canvas` or `svg` (default value : `canvas`)
| _-jschartvar_ | name chart var (default value : `chart_[clock clicks]`) 
| _-divid_ | name id var (default value : `id_[clock clicks]`) 
| _-outfile_ | full path html file (output by default in `[info script]/render.html`)
| _-jsecharts_ | full path `echarts.min.js` file (by default `cdn` script)
| _-jsvar_ | name js var (default value : `option`)
| _-script_ | jsfunc (default value : `"null"`)
| _-class_ | Class container (default value : `"chart-container"`)
| _-style_ | Css style (default value : `width:'-width'; height:'-height';`)

```tcl
# Demo
$chart Render -width "1200px" -height "800px" -renderer "svg"
```
Data :
-------------------------
`-data` in _series_, can be written like this : 
```tcl
# Demo
$chart AddLineSeries -data [list {Mon 150} {Tue 230} {Wed 224} {... ...}]
# Mon = X value
# 150 = Y value
# And now -data in Xaxis method can be deleted and written like this :
$chart Xaxis
```
`-datalineitem` (for _lineseries_) flag :
```tcl
# Additional options on the graph... see ticklecharts::lineItem in options.tcl
$chart AddLineSeries -datalineitem {
                                {name "Mon" value 150}
                                {name "Tue" value 230}
                                {name "Wed" value 224}
                                {name "Thu" value 218}
                                {name "Fri" value 135}
                                {name "Sat" value 147}
                                {name "Sun" value 260}
                                }
```
With `dataset` class :
```tcl
set data {
        {"Day" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}
        {"value" 150 230 224 218 135 147 260}
        }

# Init dataset class.
# Note : Starting from version '2.6', it is possible to add several 'source' for the same class.
set obj [ticklecharts::dataset new [list [list -source $data -sourceHeader "True"]]]

# Add 'obj' dataset to chart class. 
$chart SetOptions -dataset $obj
# Add line series.
$chart Xaxis
$chart Yaxis
$chart AddLineSeries -seriesLayoutBy "row"
```
Useful methods :
-------------------------

1. Get default _options_ according to a `key` (name of procedure) :
```tcl
# e.g for series :
$chart getoptions -series line
# e.g for axis :
$chart getoptions -axis X
# get all options for 'title' :
$chart getoptions -option title
# output :
id                -minversion 5  -validvalue {}                      -type str|null   -default "nothing"
show              -minversion 5  -validvalue {}                      -type bool       -default "True"
text              -minversion 5  -validvalue {}                      -type str|null   -default "nothing"
link              -minversion 5  -validvalue {}                      -type str|null   -default "nothing"
target            -minversion 5  -validvalue formatTarget            -type str        -default "blank"
textStyle         -minversion 5  -validvalue {}                      -type dict|null
  color                -minversion 5  -validvalue formatColor          -type e.color|str|null -default $color
  fontStyle            -minversion 5  -validvalue formatFontStyle      -type str              -default "normal"
  fontWeight           -minversion 5  -validvalue formatFontWeight     -type str|num          -default $fontWeight
  fontFamily           -minversion 5  -validvalue {}                   -type str              -default "sans-serif"
  fontSize             -minversion 5  -validvalue {}                   -type num              -default $fontSize
  lineHeight           -minversion 5  -validvalue {}                   -type num|null         -default "nothing"
  width                -minversion 5  -validvalue {}                   -type num              -default 100
  height               -minversion 5  -validvalue {}                   -type num              -default 50
  textBorderColor      -minversion 5  -validvalue {}                   -type str|null         -default "null"
  textBorderWidth      -minversion 5  -validvalue {}                   -type num              -default 0
  textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n   -default "solid"
  textBorderDashOffset -minversion 5  -validvalue {}                   -type num              -default 0
  textShadowColor      -minversion 5  -validvalue formatColor          -type str              -default "transparent"
  textShadowBlur       -minversion 5  -validvalue {}                   -type num              -default 0
  textShadowOffsetX    -minversion 5  -validvalue {}                   -type num              -default 0
  textShadowOffsetY    -minversion 5  -validvalue {}                   -type num              -default 0
  overflow             -minversion 5  -validvalue formatOverflow       -type str|null         -default "null"
  ellipsis             -minversion 5  -validvalue {}                   -type str              -default "..."
subtext           -minversion 5  -validvalue {}                      -type str|null   -default "nothing"
sublink           -minversion 5  -validvalue {}                      -type str|null   -default "nothing"
 ...
 ...
# following options voluntarily deleted... 
```
2. Delete _series_ by index:
```tcl
$chart AddLineSeries -data [list {1 2 3 4}]
$chart AddBarSeries  -data [list {4 5 6 7}]

# Delete bar series :
$chart deleteseries 1
```
3. Gets _json_ data :
```tcl
$chart toJSON
```

Javascript function :
-------------------------
* **Add a javascript function to json** :
```tcl
# Initializes a new jsfunc Class
ticklecharts::jsfunc new {args}
```
This function will be able to be inserted directly into the `JSON` data and will also create a new type `jsfunc`.
```tcl
# Demo
set js [ticklecharts::jsfunc new {function (value, index) {
                                return value + ' (C°)';
                                },
                                }]

$chart Xaxis -axisLabel [list show "True" \
                              margin 8 \
                              formatter $js \
                              showMinLabel "null" \
                              ... ]

# Echarts 'json' result :
"axisLabel": {
  "show": true,
  "margin": 8,
  "formatter": function (value, index) {
                          return value + ' (C°)';
                          },
  "showMinLabel": null,
  ...
}
```
*  **formatter** :
    - Accepts a _javascript_ function_ most times. For basic _format_, `formatter` supports string template like this :
    > formatter `'{b0}: {c0}<br />{b1}: {c1}'`
    
    - In Tcl you can use _substitution_ e.g.:
    > formatter `{"{b0}: {c0}<br />{b1}: {c1}"}`
    
    - Or use list map to replace some `Tcl` special chars e.g.:
    > formatter `"<0123>b0<0125>: <0123>c0<0125><br /><0123>b1<0125>: <0123>c1<0125>"`

    | Symbol        | Map      |
    | ------------- | ---------|
    | `{`           | <0123>   |
    | `}`           | <0125>   |
    | `[`           | <091>    |
    | `]`           | <093>    |
*  **Add a js script, variable... in html template file** :
```tcl
# Initializes a new jsfunc Class
ticklecharts::jsfunc new {args} -start? -end? -header?  
```
Combined with `Render` method and `-script` flag, you can add a js script (`jsfunc` class) to html template file.  
For this add :
- `-start` : To place your script at the beginning of the file. 
- `-end` : To place your script at the end of the file. 
- `-header`: To place your script in the file header.
```tcl
# Demo
set js [ticklecharts::jsfunc new {
                                var maskImage = new Image();
                                maskImage.src = './logo.png';
                                } -start
                            ]
set header [ticklecharts::jsfunc new {
                        <script type="text/javascript" src="tcl.js"></script>
                    } -header
            ]
...
$chart Render -outfile demo.html -title demo -script [list [list $js $header]]
```
```js
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>demo</title>
    <script type="text/javascript" src="echarts.min.js"></script>
    // -header script...
    <script type="text/javascript" src="tcl.js"></script>
  </head>
  <body>
    <div id="main" class="chart-container" style="width:900px; height:500px;"></div>
    <script>
        var chart = echarts.init(document.getElementById('main'), null, {renderer: 'canvas'});
        // -start script...
        var maskImage = new Image();
        maskImage.src = './logo.png';
        var option = {
            "backgroundColor": "rgba(0,0,0,0)",
            "color": [
            ...
            ],
            "maskImage": maskImage,
            ...
        }
    ...
    </script>
  </body>
</html>
```

Performance :
-------------------------
Since version **2**, some _huddle/ehuddle_ procedures can be replaced by functions written in C with help of [critcl](https://andreas-kupries.github.io/critcl/).  
Critcl package should be available and this command `ticklecharts::eHuddleCritcl` should be set to valid `Tcl_boolean` value.  
You may be processing important data and if you want to gain speed, this command can be useful, below how to use it :
```tcl
package require ticklecharts

# load critcl package
# compile & replace...
# Note : A warning message may be displayed on your console
# if there was a problem compiling or loading critcl package
ticklecharts::eHuddleCritcl True

source examples/candlestick/candlestick_large_scale.tcl ; # dataCount set to 200,000
#             | This run (Mac Os Core i7)
#    pure Tcl |   25354915 microseconds per iteration 
#    critcl   |    3514165 microseconds per iteration (≃7x faster)
```
`Note` : _No advantage to use this command with small data..._

Global variables :
-------------------------
```tcl
package require ticklecharts

# Set theme... with variable
# Or with class : ticklecharts::(Gridlayout|chart|timeline) new -theme "vintage"
set ::ticklecharts::theme "vintage" ; # default "basic" 

# Minimum properties...
# Only write values that are defined in the *.tcl file. (Benefit : performance + minifying your HTML files)
# Be careful, properties in the *.tcl file must be implicitly marked.
# Note : 'theme' other than 'basic' is not supported (yet) when 'minProperties' variable is set to 'True'.
set ::ticklecharts::minProperties "True" ; # default "False"

# Output 'render.html' full path to stdout. 
set ::ticklecharts::htmlstdout "False" ; # default "True"

# Google API Key 
# Note : To use the Google map API 'gmap' a valid key is required.
set ::ticklecharts::keyGMAPI "??" ; # Please replace '??' with your own API key.

# Set versions for js script.
# Note : Num version (@X.X.X) should be present in js path .If no pattern matches, the script path is left unchanged.
set ::ticklecharts::echarts_version "X.X.X" ; # Echarts version
set ::ticklecharts::gmap_version    "X.X.X" ; # gmap version
```
`Note` : _All the above variables can be modified in the `ticklecharts.tcl` file_.

Examples :
-------------------------
See **[examples](/examples)** for all demos (from [Apache Echarts examples](https://echarts.apache.org/examples/en/index.html))

```tcl
# line + bar on same canvas...
package require ticklecharts

# init chart class...
set chart [ticklecharts::chart new]

# Set options :
$chart SetOptions -tooltip {show True trigger "axis" axisPointer {type "cross" crossStyle {color "#999"}}} \
                  -grid {left "3%" right "4%" bottom "3%" containLabel "True"} \
                  -legend {}
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] \
             -axisPointer {type "shadow"}

# ticklecharts::jsfunc...
$chart Yaxis -name "Precipitation" -position "left" -min 0 -max 250 -interval 50 \
                                   -axisLabel {formatter "<0123>value<0125> ml"}
$chart Yaxis -name "Temperature"   -position "right" -min 0 -max 25  -interval 5 \
                                   -axisLabel {formatter "<0123>value<0125> °C"}

# Add bars...
$chart AddBarSeries -name "Evaporation" \
                    -data [list {2.0 4.9 7.0 23.2 25.6 76.7 135.6 162.2 32.6 20.0 6.4 3.3}]
                    
$chart AddBarSeries -name "Precipitation" \
                    -data [list {2.6 5.9 9.0 26.4 28.7 70.7 175.6 182.2 48.7 18.8 6.0 2.3}]                    

# Add line...                    
$chart AddLineSeries -name "Temperature" \
                     -yAxisIndex 1 \
                     -data [list {2.0 2.2 3.3 4.5 6.3 10.2 20.3 23.4 23.0 16.5 12.0 6.2}]


set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

# Save to html...
$chart Render -outfile [file join $dirname $fbasename.html] -title $fbasename
```
![line and bar mixed](images/line_and_bar_mixed.png)

```tcl
# demo layout line + bar + pie...
set data0 {1 2 3 4 5}
set data1 {2 3.6 6 2 10}

set js [ticklecharts::jsfunc new {
                function (value, index) {
                    return value + ' (C°)';
                },
            }]

set line [ticklecharts::chart new]
                  
$line SetOptions -title   {text "layout line + bar + pie charts..."} \
                 -tooltip {show "True"} \
                 -legend {top "56%" left "20%"}    
    
$line Xaxis -data [list $data0] -boundaryGap "False"
$line Yaxis
$line AddLineSeries -data [list $data0]  -areaStyle {} -smooth true
$line AddLineSeries -data [list $data1] -smooth true

set bar [ticklecharts::chart new]

$bar SetOptions -legend {top "2%" left "20%"}

$bar Xaxis -data [list {A B C D E}] \
            -axisLabel [list show "True" formatter $js]
$bar Yaxis
$bar AddBarSeries -data [list {50 6 80 120 30}]
$bar AddBarSeries -data [list {20 30 50 100 25}]

set pie [ticklecharts::chart new]

$pie SetOptions -legend {top "6%" left "65%"} 

$pie AddPieSeries -name "Access From" -radius [list {"50%" "70%"}] \
                  -labelLine {show "True"} \
                  -datapieitem {
                      {value 1048 name "C++"}
                      {value 300 name "Tcl"}
                      {value 580 name "Javascript"}
                      {value 484 name "Python"}
                      {value 735 name "C"}
                    }


set layout [ticklecharts::Gridlayout new]
$layout Add $bar  -bottom "60%" -width "40%" -left "5%"
$layout Add $line -top    "60%" -width "40%" -left "5%"
$layout Add $pie  -center [list {75% 50%}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] \
               -title $fbasename \
               -width 1700px \
               -height 1000px
```
![line, bar and pie layout](images/line_bar_pie_layout.png)

#### Currently chart and options supported are :
- **Global options :**
- [x] title
- [x] legend
- [x] grid
- [x] xaxis
- [x] yaxis
- [x] polar
- [x] radiusAxis
- [x] angleAxis
- [x] radar
- [x] dataZoom
- [x] visualMap
- [x] tooltip
- [x] axisPointer
- [x] toolbox
- [x] brush
- [x] geo
- [x] parallel
- [x] parallelAxis
- [x] singleAxis
- [x] timeline
- [x] graphic
- [x] calendar
- [x] dataset
- [x] aria
- **Series :**
- [x] line
- [x] bar
- [x] pie
- [x] scatter
- [x] effectScatter
- [x] radar
- [x] tree
- [x] treemap
- [x] sunburst
- [x] boxplot
- [x] candlestick
- [x] heatmap
- [x] map
- [x] parallel
- [X] lines
- [x] graph
- [x] sankey
- [x] funnel
- [x] gauge
- [x] pictorialBar
- [x] themeRiver
- [ ] custom (see _note_ below)
- [x] wordCloud

> **Note** _custom_ series : This series contains a lot of _Javascript_ codes, I don’t think it’s interesting to write it in this package.  
 If you are interested, please report to the github issue tracker.

#### Gallery :
![Photo gallery](images/all.gif)

License :
-------------------------
**ticklEcharts** is covered under the terms of the [MIT](LICENSE) license.

Release :
-------------------------
*  **08-Feb-2022** : 1.0
    - Initial release.
*  **16-Feb-2022** : 1.1
    - Add pie chart + visualMap.
    - Add demos line + pie + visualMap.
    - Bug fixes.
    - Add options.
*  **19-Feb-2022** : 1.2
    - Add funnel chart + markArea.
    - Add markArea + funnel examples.
*  **20-Feb-2022** : 1.3
    - Add radar chart.
    - Add radar, pie, layout examples.
*  **22-Feb-2022** : 1.4
    - Add scatter + effectScatter chart.
    - Add scatter examples + line step example.
    - Add `::ticklecharts::htmlstdout` variable to control _stdout_
	  for render html output.
*  **28-Feb-2022** : 1.5
    - Add heatmap chart.
    - Add heatmap examples.
    - Add `deleteseries` method to delete series chart.
    - Update README to explain `deleteseries` and `getoptions` methods.
*  **06-Mar-2022** : 1.5.1
    - Add graphic (rect, circle, arc, line, text...)
    - Add graphic examples.
*  **20-Mar-2022** : 1.5.2
    - Add `toolbox`option (A group of utility tools... Save as image, Zoom, Data view...)
    - Update chart examples to include toolbox utility.
    - Add examples with json data from [github apache echarts-examples](https://github.com/apache/echarts-examples) (require `http`, `json` packages from Tcllib) + `tls` package.
    - Add `jsfunc` as huddle `type`, instead of using a `string map` and `dictionary` combination.
    - Patch for huddle.tcl (v0.3) `proc ::huddle::jsondump`.
    - Add `Render` method to keep the same logic of naming methods for ticklecharts,
    the first letter in capital letter... _Note_ : `render` method is still active.
*  **02-Apr-2022** : 1.5.3
    - Add `-validvalue` flag to respect the values by default according to the Echarts documentation (especially for string types).
    - Update examples to reflect the changes.
*  **04-Apr-2022** : 1.6
    - Add `sunburst` chart.
    - Add `sunburst` examples + correction `line` chart label position example.
*  **07-Apr-2022** : 1.7
    - Add `tree` chart.
    - Add `tree` examples.
*  **09-Apr-2022** : 1.8
    - Add `themeRiver` chart + `singleAxis` option.
    - Add `themeRiver` examples.
*  **09-Apr-2022** : 1.8.1
    - Fix bug on adding multiple axis (xAxis, yAxis...). Not included in version `1.7`
*  **11-Apr-2022** : 1.9
    - Add `sankey` chart.
    - Add `sankey` examples.
*  **16-Apr-2022** : 1.9.1
    - Added procedure to check if the options match the default values, output `warning` message if option name doesn't exist or not supported.
    - Update chart examples to avoid warnings messages.
*  **19-Apr-2022** : 1.9.2
    - Add `dataZoom` option (For zooming a specific area...)
    - Add or update chart examples to include `dataZoom` option.
    - Fix bug for theming features.
*  **30-Apr-2022** : 1.9.3
    - Add `dataset` option.
    - Add chart examples to include `dataset` option.
*  **04-May-2022** : 1.9.4
    - Add `pictorialBar` chart.
    - Add `pictorialBar` examples.
*  **12-May-2022** : 1.9.5
    - Add `candlestick` chart.
    - Add `candlestick` examples.
*  **26-May-2022** : 2.0.1
    - Replaces some _huddle/ehuddle_ procedures by _C_ functions, with help of [critcl](https://andreas-kupries.github.io/critcl/) package.
    - **Incompatibility** : `-render` flag renamed to `-renderer` (flag option to set `canvas` or `svg` renderer).
*  **26-Jun-2022** : 2.1
    - Add `parallel` chart.
    - Add `parallel` examples.
    - Add `brush` option (To select part of data from a chart to display in detail...)
*  **27-Jun-2022** : 2.1.1
    - Add `parallelAxis` as method instead of a option. Update examples to reflect this change.
*  **02-Aug-2022** : 2.2
    - Add `timeline` option (provides switching between charts).
    - Add `timeline` examples.
*  **20-Aug-2022** : 2.3
    - Add `gauge` chart.
    - Add `gauge` examples.
    - Move huddle patch (0.3) proc from ehuddle.tcl to a new separate file (huddle_patch.tcl).
    - Cosmetic changes.
    - Add `toJSON` method for `timeline`class.
*  **05-Sep-2022** : 2.3.1
    - Code refactoring
*  **14-Oct-2022** : 2.4
    - Add `graph` chart.
    - Add `graph` examples.
*  **21-Oct-2022** : 2.5
    - Add [echarts-wordcloud](https://github.com/ecomfe/echarts-wordcloud).
    - Add `wordCloud` examples.
    - Adds the possibility to add one or more js script(s) to the html template file.
*  **30-Oct-2022** : 2.6
    - Add `boxplot` chart.
    - Add `boxplot` examples.
    - **Incompatibility** with previous version for `dataset` class, `dataset` now accepts multiple `source` for the same class.
    - Update `dataset` examples to reflect this change.
*  **07-Nov-2022** : 2.7
    - Add `treemap` chart.
    - Add `treemap` examples.
    - Add `axisPointer` option
    - Add `-minversion` flag in args option, to control if the _key_ or _type_ is supported in current `Echarts` version, 
      output `warning` message if it is not supported.
*  **12-Nov-2022** : 2.8
    - Add `map` chart.
    - Add `map` examples.
    - Add `geo` option
*  **25-Nov-2022** : 2.8.1
    - Add `calendar` option.
    - Add `calendar` examples.
    - For `color` and `backgroundColor` properties, adds `eColor` Class  
      see [pie_texture.tcl example](examples/pie/pie_texture.tcl) in `examples/pie` folder.
*  **02-Dec-2022** : 2.8.2
    - Bump to `v2.1.0` for echarts-wordcloud, update examples to reflect this changes.
    - Add `aria` option.
    - Add `aria` example.
    - Cosmetic changes.
*  **08-Dec-2022** : 2.9
    - Add `gmap` [extension](https://github.com/plainheart/echarts-extension-gmap). (_Note_: A Google Key API is required)
    - Add `gmap` examples.
    - Add `lines` chart.
    - Add `lines` examples.
    - Cosmetic changes.
*  **18-Dec-2022** : 2.9.1
    - The result of the `ticklecharts::infoOptions` _command_ on the `stdout` is deleted, in favor of a result of a _command_.
    - New global variable `::ticklecharts::minProperties` see [Global variables](#Globalvariables) section for detail.
    - `-class` and `-style` are added in `Render` method to control the class name and style respectively (_Note_ : `template.html` file is modified).
    - Cosmetic changes.
*  **03-Jan-2023** : 2.9.2
    - Code refactoring.
    - Update LICENSE year.
    - `echarts-wordcloud.js` is inserted automatically when writing the html file. Update `wordcloud` examples to reflect this changes.
    - Cosmetic changes.
    - Add global options (useUTC, hoverLayerThreshold...)