ticklEcharts
==========================
Tcl wrapper around [Apache ECharts](https://echarts.apache.org/en/index.html).

![Photo gallery](images/all.png)

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
$chart Add "lineSeries" -data [list {150 230 224 218 135 147 260}]

$chart Render
```
![Basic line chart](images/line_basic_chart.png)
```tcl
# Initializes a new 2D Chart Class
set chart [ticklecharts::chart new]
```
##### Argument available :
| args     | Description            | Default value
| ------   | ------                 | ------
| _-theme_ | Defines the theme name | `custom` (possible values: `vintage,westeros,wonderland,dark`)
```tcl
# Initializes X axis with values
$chart Xaxis -data [list {Mon Tue Wed Thu Fri Sat Sun}]
```
> [!IMPORTANT]  
>  `-data` _property_ should be a list of list `[list {...}]`
```tcl
# Initializes Y axis
$chart Yaxis
```
```tcl
# Initializes line series
# '-data' should be a list of list [list {...}]
$chart Add "lineSeries" -data [list {150 230 224 218 135 147 260}]
```
Here `-data` corresponds to the Y values.

```tcl
# Export chart to html file
$chart Render
```
##### Arguments available :
| args           | Description             | Default values
| ------         | ------                  | ------
| _-title_       | Header title html       | `"ticklEcharts !!!"`
| _-width_       | Container's width       | `"900px"`
| _-height_      | Container's height      | `"500px"`
| _-renderer_    | canvas or svg           | `"canvas"`
| _-jschartvar_  | Variable name chart     | `chart_[uuid]`
| _-divid_       | Name container's ID     | `id_[uuid]`
| _-outfile_     | Full path html file     | `'./render.html'`
| _-jsecharts_   | Full path echarts.js    | `https://cdn.jsdelivr.net/...`
| _-jsvar_       | js variable name        | `option_[uuid]`
| _-script_      | jsfunc class            | `'null'`
| _-class_       | Specify container's CSS | `"chart-container"`
| _-style_       | Inline style            | `"width:'-width'; height:'-height'";`
| _-template_    | file or string          | `'file'` (template.html)

```tcl
# Example properties :
$chart Render -width "1200px" -height "800px" -renderer "svg"
```
Data series :
-------------------------
`-data` (y values only) : 
```tcl
# Example for lineseries
$chart Add "lineSeries" -data [list {150 230 224 218 135 147 260}]
$chart Yaxis
```
`-data` (x, y values) : 
```tcl
# Example for lineseries
$chart Add "lineSeries" -data [list {Mon 150} {Tue 230} {Wed 224} {... ...}]
# Mon = X value
# 150 = Y value
# Now '-data' in Xaxis method is not included
$chart Xaxis
$chart Yaxis
```
`-dataItem` :
```tcl
# Example for lineseries
# Additional options are valid... See ticklecharts::lineItem in options.tcl
$chart Add "lineSeries" -dataItem {
                            {name "Mon" value 150}
                            {name "Tue" value 230}
                            {name "Wed" value 224}
                            {name "Thu" value 218}
                            {name "Fri" value 135}
                            {name "Sat" value 147}
                            {name "Sun" value 260}
                        }
```
`dataset` (class) :
```tcl
set data(0) {
    {"Day" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}
    {"value" 150 230 224 218 135 147 260}
}

# Init dataset class.
# Note : Starting from version '2.6', it is possible 
# to add several 'items' like this :
# > [list [list source $data(0) sourceHeader "True"] [list source $data(1) ...]]]
set obj [ticklecharts::dataset new [list source $data(0) sourceHeader "True"]]

# Add 'obj' dataset to chart class. 
$chart SetOptions -dataset $obj
# Add line series.
$chart Xaxis
$chart Yaxis
$chart Add "lineSeries" -seriesLayoutBy "row"
```
Useful methods :
-------------------------

1. Get default _options_ according to a `key` (name of procedure) :
```tcl
# e.g for series :
$chart getOptions -series lineSeries
# e.g for axis :
$chart getOptions -axis X
# e.g for global options :
$chart getOptions -globalOptions ; # no value required
# get all options for 'title' :
$chart getOptions -option title
# output :
 id                -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
 show              -minversion 5  -validvalue {}                      -type bool        -default "True"
 text              -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
 link              -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
 target            -minversion 5  -validvalue formatTarget            -type str         -default "blank"
 textStyle         -minversion 5  -validvalue {}                      -type dict|null
   color                -minversion 5  -validvalue formatColor          -type str.t|jsfunc|null -default $color
   fontStyle            -minversion 5  -validvalue formatFontStyle      -type str               -default "normal"
   fontWeight           -minversion 5  -validvalue formatFontWeight     -type str.t|num.t|null  -default $fontWeight
   fontFamily           -minversion 5  -validvalue {}                   -type str               -default "sans-serif"
   fontSize             -minversion 5  -validvalue {}                   -type num.t|null        -default $fontSize
   lineHeight           -minversion 5  -validvalue {}                   -type num|null          -default "nothing"
   width                -minversion 5  -validvalue {}                   -type num               -default 100
   height               -minversion 5  -validvalue {}                   -type num               -default 50
   textBorderColor      -minversion 5  -validvalue {}                   -type str|null          -default "null"
   textBorderWidth      -minversion 5  -validvalue {}                   -type num               -default 0
   textBorderType       -minversion 5  -validvalue formatTextBorderType -type str|num|list.n    -default "solid"
   textBorderDashOffset -minversion 5  -validvalue {}                   -type num               -default 0
   textShadowColor      -minversion 5  -validvalue formatColor          -type str               -default "transparent"
   textShadowBlur       -minversion 5  -validvalue {}                   -type num               -default 0
   textShadowOffsetX    -minversion 5  -validvalue {}                   -type num               -default 0
   textShadowOffsetY    -minversion 5  -validvalue {}                   -type num               -default 0
   overflow             -minversion 5  -validvalue formatOverflow       -type str|null          -default "null"
   ellipsis             -minversion 5  -validvalue {}                   -type str               -default "..."
   # ...
 subtext           -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
 sublink           -minversion 5  -validvalue {}                      -type str|null    -default "nothing"
 ...
 ...
# Following options voluntarily deleted... 
```
2. Delete _series_ by index:
```tcl
$chart Add "lineSeries" -data [list {1 2 3 4}]
$chart Add "barSeries"  -data [list {5 6 7 8}]

# Delete bar series :
$chart deleteSeries 1
```
3. Gets _json_ data :
```tcl
$chart toJSON
```
3. Export _chart_ as HTML fragment :
```tcl
$chart toHTML ?-template ?...
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

# 'json' result :
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
*  **formatter** (Accepts a _javascript function_ most times):
    - For basic _format_, `formatter` supports string template like this :
    > formatter `'{b0}: {c0}<br />{b1}: {c1}'`
    
    - Use Tcl _substitution_ e.g.:
    > formatter : `{"{b0}: {c0}<br />{b1}: {c1}"}`

    - Use ticklecharts::eString _class_ e.g.:
    > formatter : `[new estr "{b0}: {c0}<br />{b1}: {c1}"]`
    
    - (Deprecated) Use list map to replace some `Tcl` special chars e.g.:
    > formatter : `"<0123>b0<0125>: <0123>c0<0125><br /><0123>b1<0125>: <0123>c1<0125>"`

    | Symbol        | Map      
    | ------------- | ---------
    | `{`           | <0123>   
    | `}`           | <0125>   
    | `[`           | <091>    
    | `]`           | <093>    
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
#    critcl   |    6338728 microseconds per iteration (≃4x faster)
```
`Note` : _No advantage to use this command with small data..._

Global variables :
-------------------------
```tcl
package require ticklecharts

# Set theme... with variable
# Or with class : ticklecharts::(Gridlayout|chart|timeline|chart3D) new -theme "vintage"
set ::ticklecharts::theme "vintage" ; # default "custom" 

# Minimum properties...
# Only write values that are defined in the *.tcl file. (Benefit : performance + minifying your HTML files)
# Be careful, properties in the *.tcl file must be implicitly marked.
set ::ticklecharts::minProperties "True" ; # default "False"

# Output 'render.html' full path to stdout. 
set ::ticklecharts::htmlstdout "False" ; # default "True"

# Google API Key 
# Note : To use the Google map API 'gmap' a valid key is required.
set ::ticklecharts::keyGMAPI "??" ; # Please replace '??' with your own API key.

# Set versions for js script.
# Note : Num version (@X.X.X) should be defined in js path. If no pattern matches, the script path is left unchanged.
set ::ticklecharts::echarts_version "X.X.X" ; # Echarts version
set ::ticklecharts::gl_version      "X.X.X" ; # Echarts GL version
set ::ticklecharts::gmap_version    "X.X.X" ; # gmap version
set ::ticklecharts::wc_version      "X.X.X" ; # wordcloud version

 # Verify if a URL exists when Echarts version changed.
set ::ticklecharts::checkURL "True" ; # default "False"
```
`Note` : _All the above variables can be modified in the `ticklecharts.tcl` file_.

Examples :
-------------------------
See the **[examples](/examples)** folder for all demos (from [Apache Echarts examples](https://echarts.apache.org/examples/en/index.html))

![line and bar mixed](images/line_and_bar_mixed.png)
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

# Uses Tcl substitution for 'formatter' property...
$chart Yaxis -name "Precipitation" -position "left" -min 0 -max 250 -interval 50 \
                                   -axisLabel {formatter {"{value} ml"}}
$chart Yaxis -name "Temperature"   -position "right" -min 0 -max 25  -interval 5 \
                                   -axisLabel {formatter {"{value} °C"}}

# Add bars...
$chart Add "barSeries" -name "Evaporation" \
                       -data [list {2.0 4.9 7.0 23.2 25.6 76.7 135.6 162.2 32.6 20.0 6.4 3.3}]
                    
$chart Add "barSeries" -name "Precipitation" \
                       -data [list {2.6 5.9 9.0 26.4 28.7 70.7 175.6 182.2 48.7 18.8 6.0 2.3}]                    

# Add line...                    
$chart Add "lineSeries" -name "Temperature" \
                        -yAxisIndex 1 \
                        -data [list {2.0 2.2 3.3 4.5 6.3 10.2 20.3 23.4 23.0 16.5 12.0 6.2}]


$chart Render
```
![line, bar and pie layout](images/line_bar_pie_layout.png)
```tcl
# demo layout line + bar + pie...
set data(0) {1 2 3 4 5}
set data(1) {2 3.6 6 2 10}

set js [ticklecharts::jsfunc new {
                function (value, index) {
                    return value + ' (C°)';
                },
            }]

set line [ticklecharts::chart new]
                  
$line SetOptions -title   {text "layout line + bar + pie charts..."} \
                 -tooltip {show "True"} \
                 -legend {top "56%" left "20%"}    
    
$line Xaxis -data [list $data(0)] -boundaryGap "False"
$line Yaxis
$line Add "lineSeries" -data [list $data(0)] -areaStyle {} -smooth true
$line Add "lineSeries" -data [list $data(1)] -smooth true

set bar [ticklecharts::chart new]

$bar SetOptions -legend {top "2%" left "20%"}

$bar Xaxis -data [list {A B C D E}] \
           -axisLabel [list show "True" formatter $js]
$bar Yaxis
$bar Add "barSeries" -data [list {50 6 80 120 30}]
$bar Add "barSeries" -data [list {20 30 50 100 25}]

set pie [ticklecharts::chart new]

$pie SetOptions -legend {top "6%" left "65%"} 

$pie Add "pieSeries" -name "Access From" -radius [list {"50%" "70%"}] \
                     -labelLine {show "True"} \
                     -dataItem {
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

$layout Render
```
#### Currently chart and options supported are :
- **Global options :**
- [x] title
- [x] legend
- [x] grid
- [x] grid3D
- [x] xaxis
- [x] xaxis3D
- [x] yaxis
- [x] yaxis3D
- [x] zaxis3D
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
- [x] globe
- **Series :**
- [x] line
- [x] line3D
- [x] lines3D
- [x] bar
- [x] bar3D
- [x] pie
- [x] scatter
- [x] scatter3D
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
- [x] surface (3D)
- [x] funnel
- [x] gauge
- [x] pictorialBar
- [x] themeRiver
- [ ] custom (see _note_ below)
- [x] wordCloud

> [!NOTE]  
> _custom_ series contains a lot of _Javascript_ codes, I don’t think it’s interesting to write it in this package.  
> If you are interested, please report to the github issue tracker.

License :
-------------------------
**ticklEcharts** is covered under the terms of the [MIT](LICENSE) license.

Release :
-------------------------
*  **08-Feb-2022** : 1.0
    - Initial release.
*  **12-May-2022** : 1.9.5
    - Add `candlestick` chart.
    - Add `candlestick` examples.
*  **26-May-2022** : 2.0.1
    - Replaces some _huddle/ehuddle_ procedures by _C_ functions, with help of [critcl](https://andreas-kupries.github.io/critcl/) package.
    - **Incompatibility** : `-render` flag renamed to `-renderer` (flag option to set `canvas` or `svg` renderer).
*  **03-Jan-2023** : 2.9.2
    - Code refactoring.
    - Update LICENSE year.
    - `echarts-wordcloud.js` is inserted automatically when writing the html file. Update `wordcloud` examples to reflect this changes.
    - Cosmetic changes.
    - Add global options (useUTC, hoverLayerThreshold...)
*  **04-Feb-2023** : 3.0.1
    - Bump to `v5.4.1` for Echarts.
    - Add Echarts GL (3D)
    - Add `bar3D`, `line3D` and `surface` series.
    - Add `bar3D`, `line3D` and `surface` examples.
    - `::ticklecharts::theme` variable is supported with `::ticklecharts::minProperties` variable.
    - **Incompatibility** :
        - `render` method is no longer supported, it is replaced by `Render` method (Note the first letter in capital letter...).
        - `getoptions` method is renamed `getOptions`.
        - `deleteseries` method is renamed `deleteSeries`.
        - `gettype` method is renamed `getType` (internal method).
        -  Rename `basic` theme to `custom` theme.
        - `theme.tcl` file has been completely reworked.
        - Several options are no longer supported when initializing the `ticklecharts::chart` class, all of these options are initialized in `Setoptions` method now.
        - To keep the same `Echarts` logic, some _ticklEcharts_ properties are renamed :  
                - `-databaritem` is renamed `-dataBarItem`.  
                - `-datalineitem` is renamed `-dataLineItem`.  
                - `-datapieitem` is renamed `-dataPieItem`.  
                - `-datafunnelitem` is renamed `-dataFunnelItem`.  
                - `-dataradaritem` is renamed `-dataRadarItem`.  
                - `-datacandlestickitem` is renamed `-dataCandlestickItem`.  
*  **04-Mar-2023** : 3.1
    - Code refactoring.
    - `::tcl::unsupported::representation` Tcl command is replaced, in favor of 2 news class :
        - `ticklecharts::eDict` (Internal class to replace `dict` Tcl command when initializing)
        - `ticklecharts::eList` (This class can replace the `list` Tcl command see [line_eList.tcl](examples/line/line_eList.tcl) to know  
           why this class has been implemented for certain cases...)
    - list.data (`list.d`) accepts now `null` values. (`set property [list {"string" 1 "null"}]` -> JSON result = `["string", 1, null]`)
*  **22-Mar-2023** : 3.1.1
    - Support array for `dataset` dimension (with `ticklecharts::eList` class).
    - Adds a new method `RenderTsb` to interact with [Taygete Scrap Book](https://wiki.tcl-lang.org/page/Taygete+Scrap+Book) (see demo next link).
*  **02-May-2023** : 3.1.2
    - Adds new `Add` method for `chart` and `chart3D` classes (To reflect this changes some examples + README file have been updated).   
    e.g : To add a `pie series` you should write like this : `$chart Add "pieSeries" -data ...` instead of      
    `$chart AddPieSeries -data ...` (Note: the `main` method is still active)   
        - _Note_ : Probably that in my `next` major release, I would choose this way of writing to add a series...   
          To ensure conformity with other classes (`Gridlayout`, `timeline`)
    - `RenderTsb` method has been updated :
        - New argument `-evalJSON` has been added (see [this file](examples/tsb/README.md) for detail).
        - This new minor release allows to load an entire `JS script` instead of `https://` link.
    - Adds a `trace` command for series (The goal here is to find if certain values match each other).   
    Currently only supported for `line` series.
    - Adds a new command `ticklecharts::urlExists?` + global variable `::ticklecharts::checkURL`   
    to verify if URL exists (disabled by default) when the num version changed. Uses `curl` command (Available for Windows and Mac OS)
    - Fixed a bug for the `multiversion` property, when the num version is lower than the `-minversion` property.
    - `pkgIndex.tcl` file has been completely reworked.
    - Cosmetic changes.
*  **16-May-2023** : 3.1.3
    - Adds a new class `ticklecharts::eString` to replace a string.
    - Invoke `superclass` method for `chart3D`, `timeline` and `Gridlayout` classes.
    - Fixed a bug when the keys have a space `critcl::cproc critHuddleDump`.
    - dataset class support `ticklecharts::eDict` class for `-dimensions` property.
    - Keeps updating some examples to set new `Add` method for chart series.
    - Cosmetic changes.
*  **24-Jun-2023** : 3.1.4
    - Update all examples with new `Add` method for chart series (The main method `AddXXXSeries` is still active).
    - A new argument `-template` for `Render` method has been added. This new argument can be used to   
    replace the html template file `template.html` with a string. See [this file](examples/scatter/scatter_logarithmic_regression.tcl) for detail.
    - A new property `-dataItem` has been added for item data, to replace this writing   
    `-dataXXXItem` (`XXX` refers to name series). All examples have been updated (The main method `-dataXXXItem` is still active).
    - list.data (`list.d`) accepts now this class `ticklecharts::eString`
    - Fixed a bug with the `superclass` method for timeline class.
    - `template.html` has been updated.
    - Cosmetic changes.
*  **08-Jul-2023** : 3.1.5
    - Fixed a bug introduced with version 3.1.2, when Render method's argument have spaces in options.
    - Cosmetic changes.
*  **26-Sep-2023** : 3.2
    - Add `scatter3D` series.
    - Add `scatter3D` examples.
    - Add `globe` option.
    - A new method [RenderJupyter](examples/notebook/README.md) to interact with jupyter notebook has been added [#1](https://github.com/nico-robert/ticklecharts/pull/1).
    - Add [jupyter notebook](examples/notebook/ticklecharts.ipynb) example.
    - Code refactoring.
*  **19-Nov-2023** : 3.2.1
    - The `ticklecharts::etsb` package is now able to search for a version number other than the global variables.
    - Changes the format of the `dataset` key property, the missing minus sign at the beginning of a key is also accepted.
    - Add `globe` examples.
    - Cosmetic changes.