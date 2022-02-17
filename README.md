ticklEcharts - chart library
================
Tcl wrapper for [Apache ECharts](https://echarts.apache.org/en/index.html) (JavaScript Visualization library).
Dependencies :
-------------------------
`huddle` package from [Tcllib](https://www.tcl.tk/software/tcllib/)
Usage :
-------------------------

```tcl
package require ticklecharts

set chart [ticklecharts::chart new]
$chart SetOptions ; # can be omitted
$chart Xaxis -data [list {Mon Tue Wed Thu Fri Sat Sun}]
$chart Yaxis
$chart AddLineSeries -data [list {150 230 224 218 135 147 260}]

$chart render
```
![Basic line chart](images/line_basic_chart.png)
```tcl
# Initializes a new Chart Class
set chart [ticklecharts::chart new]
```
##### :heavy_check_mark: Arguments available :
| args | Type | Description
| ------ | ------ | ------
| _-backgroundColor_ | string | canvas color background (hex, rgb, rgba color)
| _-color_ | list of list | list series chart colors should be a list of list like this : `[list {red blue green}]`
| _-animation_ | boolean | chart animation (default `True`)
| _-others_ | _ | animation sub options (see proc: `ticklecharts::globaloptions` in `global_options.tcl`)
| _-theme_ | string value | set the default theme for chart instance (default `basic`) possible values: `vintage,westeros,wonderland,dark`
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
$chart render
```
##### :heavy_check_mark: Arguments available :
| args | Description
| ------ | ------
| _-title_ | header title html
| _-width_ | size html canvas  (default value : `900px`)
| _-height_ | size html canvas (default value : `500px`)
| _-render_ | 'canvas' or 'svg' (default value : `canvas`)
| _-jschartvar_ | name chart var (default value : `chart_[clock clicks]`) 
| _-divid_ | name id var (default value : `id_[clock clicks]`) 
| _-outfile_ | full path html (output by default in `[info script]/render.html`)
| _-jsecharts_ | full path `echarts.min.js` (by default `cdn` script)
| _-jsvar_ | name js var (default value : `option`)

```tcl
# Demo
$chart render -width "1200px" -height "800px" -render "svg"
```
Data :
-------------------------
`-data` in _series_ can be written like this : 
```tcl
# Demo
$chart AddLineSeries -data [list {Mon 150} {Tue 230} {Wed 224} {... ...}]
# Mon = X value
# 150 = Y value
# And now -data in Xaxis method can be deleted and written like this :
$chart Xaxis
```
With `-datalineitem` (for _lineseries_) flag :
```tcl
# Additional options on the graph... see ticklecharts::LineItem in options.tcl
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

Javascript function :
-------------------------
It's possible to add a javascript function to json data for this :
```tcl
# Initializes a new jsfunc Class
ticklecharts::jsfunc new {function}
```
This function will be able to be inserted directly into the `JSON` data and will also create a `jsfunc` type
```tcl
# Demo
set js [ticklecharts::jsfunc new {function (value, index) {
                                return value + ' (C°)';
                                },
                                }]
# html result :
"axisLabel": {
  "margin": 8,
  "formatter": function (value, index) {
                          return value + ' (C°)';
                          },
  "showMinLabel": null
}
```
Examples :
-------------------------
See **[examples](/examples)** for all demos...

```tcl
# line + bar on same canvas...
package require ticklecharts

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {show True trigger "axis" axisPointer {type "cross" crossStyle {color "#999"}}} \
                  -grid {left "3%" right "4%" bottom "3%" containLabel "True"} \
                  -legend {}
               
$chart Xaxis -data [list {"Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"}] \
             -axisPointer {type "shadow"}

# special char '<0123>' = '{' and '<0125>' = '}'   
$chart Yaxis -name "Precipitation" -min 0 -max 250 -interval 50 \
                                   -axisLabel {formatter "<0123>value<0125> ml"}
$chart Yaxis -name "Temperature"   -min 0 -max 25  -interval 5 \
                                   -axisLabel {formatter "<0123>value<0125> °C"}


$chart AddBarSeries -name "Evaporation" \
                    -data [list {2.0 4.9 7.0 23.2 25.6 76.7 135.6 162.2 32.6 20.0 6.4 3.3}]
                    
$chart AddBarSeries -name "Precipitation" \
                    -data [list {2.6 5.9 9.0 26.4 28.7 70.7 175.6 182.2 48.7 18.8 6.0 2.3}]                    
                    
$chart AddLineSeries -name "Temperature" \
                     -yAxisIndex 1 \
                     -data [list {2.0 2.2 3.3 4.5 6.3 10.2 20.3 23.4 23.0 16.5 12.0 6.2}]


set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$chart render -outfile [file join $dirname $fbasename.html] -title $fbasename
```
![line and bar mixed](images/line_and_bar_mixed.png)

```tcl
# demo layout line + bar + pie...
set num  {1 2 3 4 5}
set num1 {2 3.6 6 2 10}
set num2 {4 6.6 8 10 15}

set js [ticklecharts::jsfunc new {function (value, index) {
                                return value + ' (C°)';
                                },
                                }]

set line [ticklecharts::chart new]
                  
$line SetOptions -title   {text "layout line + bar + pie charts..."} \
                 -tooltip {show "True"} \
                 -legend {top "56%" left "20%"}    
    
$line Xaxis -data [list $num] -boundaryGap "False"
$line Yaxis
$line AddLineSeries -data [list $num]  -areaStyle {} -smooth true
$line AddLineSeries -data [list $num1] -smooth true

set bar [ticklecharts::chart new]

$bar SetOptions -legend {top "2%" left "20%"}

$bar Xaxis -data [list {A B C D E}] \
            -axisLabel [dict create show "True" formatter $js]
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

$layout render -outfile [file join $dirname $fbasename.html] \
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
- [ ] radar
- [ ] dataZoom
- [x] visualMap
- [x] tooltip
- [ ] axisPointer
- [ ] toolbox
- [ ] brush
- [ ] geo
- [ ] parallel
- [ ] parallelAxis
- [ ] singleAxis
- [ ] timeline
- [ ] graphic
- [ ] calendar
- [ ] dataset
- [ ] aria
- **Series :**
- [x] line
- [x] bar
- [x] pie
- [ ] scatter
- [ ] effectScatter
- [ ] radar
- [ ] tree
- [ ] treemap
- [ ] sunburst
- [ ] boxplot
- [ ] candlestick
- [ ] heatmap
- [ ] map
- [ ] parallel
- [ ] lines
- [ ] graph
- [ ] sankey
- [ ] funnel
- [ ] gauge
- [ ] pictorialBar
- [ ] themeRiver
- [ ] custom

License :
-------------------------
**ticklEcharts** is covered under the terms of the [MIT](LICENSE) license.

Release :
-------------------------
*  **08-02-2022** : 1.0
    - Initial release.
*  **16-02-2022** : 1.1
    - Add pie chart + visualMap.
    - Add demos line + pie + visualMap
    - Bug fixes
    - Add options