lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set jsheader [ticklecharts::jsfunc new {
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm//echarts-stat@latest/dist/ecStat.min.js"></script>
} -header]

set source {
        {28604 77 17096869 "Australia" 1990}
        {31163 77.4 27662440 "Canada" 1990}
        {1516 68 1154605773 "China" 1990}
        {13670 74.7 10582082 "Cuba" 1990}
        {28599 75 4986705 "Finland" 1990}
        {29476 77.1 56943299 "France" 1990}
        {31476 75.4 78958237 "Germany" 1990}
        {28666 78.1 254830 "Iceland" 1990}
        {1777 57.7 870601776 "India" 1990}
        {29550 79.1 122249285 "Japan" 1990}
        {2076 67.9 20194354 "North Korea" 1990}
        {12087 72 42972254 "South Korea" 1990}
        {24021 75.4 3397534 "New Zealand" 1990}
        {43296 76.8 4240375 "Norway" 1990}
        {10088 70.8 38195258 "Poland" 1990}
        {19349 69.6 147568552 "Russia" 1990}
        {10670 67.3 53994605 "Turkey" 1990}
        {26424 75.7 57110117 "United Kingdom" 1990}
        {37062 75.4 252847810 "United States" 1990}
        {44056 81.8 23968973 "Australia" 2015}
        {43294 81.7 35939927 "Canada" 2015}
        {13334 76.9 1376048943 "China" 2015}
        {21291 78.5 11389562 "Cuba" 2015}
        {38923 80.8 5503457 "Finland" 2015}
        {37599 81.9 64395345 "France" 2015}
        {44053 81.1 80688545 "Germany" 2015}
        {42182 82.8 329425 "Iceland" 2015}
        {5903 66.8 1311050527 "India" 2015}
        {36162 83.5 126573481 "Japan" 2015}
        {1390 71.4 25155317 "North Korea" 2015}
        {34644 80.7 50293439 "South Korea" 2015}
        {34186 80.6 4528526 "New Zealand" 2015}
        {64304 81.6 5210967 "Norway" 2015}
        {24787 77.3 38611794 "Poland" 2015}
        {23038 73.13 143456918 "Russia" 2015}
        {19360 76.5 78665830 "Turkey" 2015}
        {38225 81.4 64715810 "United Kingdom" 2015}
        {53354 79.1 321773631 "United States" 2015}
}

# dataset class
set dset [ticklecharts::dataset new [list \
                                        [list source $source] \
                                        [list transform {{type "filter" config {dimension 4 eq 1990}}}] \
                                        [list transform {{type "filter" config {dimension 4 eq 2015}}}] \
                                        [list transform {{type "ecStat:regression" config {method "logarithmic"}}}] \
                                    ] \
]

set chart [ticklecharts::chart new]

$chart SetOptions -title {
                    text "1990 and 2015 per capital life expectancy and GDP"
                    subtext "By ecStat.regression" 
                    sublink "https://github.com/ecomfe/echarts-stat"
                    left "center"
                  } \
                  -legend [list \
                      data [list [list [new estr 1990] [new estr 2015]]] \
                      bottom 10 \
                   ] \
                  -tooltip {
                      trigger "axis"
                      axisPointer {type "cross"} 
                  } \
                  -dataset $dset \
                  -visualMap {
                      type "continuous"
                      show "False"
                      dimension 2 
                      min 20000
                      max 1500000000
                      seriesIndex {{0 1}}
                      inRange {symbolSize {{10 70}}}
                  }

$chart Xaxis -type "value" -splitLine {lineStyle {type "dashed"}}
$chart Yaxis -type "value" -splitLine {lineStyle {type "dashed"}}

$chart Add "scatterSeries" -name 1990 -datasetIndex 1
$chart Add "scatterSeries" -name 2015 -datasetIndex 2
$chart Add "lineSeries"    -name "line" \
                           -smooth "True" \
                           -showAllSymbol "nothing" \
                           -datasetIndex 3 \
                           -symbolSize 0.1 \
                           -symbol "circle" \
                           -label {show "True" fontSize 16} \
                           -labelLayout {dx -20} \
                           -encode [list label 2 tooltip [new elist 1]]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

# Below an example of template string...
# Instead of file , the html template is in the form of a string.
# The only constraint is to have this string '%json%' to replace json data.
set template {
        <!DOCTYPE html>
        <html lang="en" style="height: 100%">
        <head>
          <meta charset="UTF-8">
          <title>%title%</title>
          <script type="text/javascript" src="%jsecharts%"></script>
        </head>
          <body style="height: 100%; margin: 0">
            <div id="container" style="height: 100%"></div>
            <script>
              var chart = echarts.init(document.getElementById("container"), null, {
                renderer: "canvas"
              });
              echarts.registerTransform(ecStat.transform.regression);
              var option = %json%;
              chart.setOption(option);
              window.addEventListener("resize", chart.resize);
            </script>
          </body>
        </html>
}

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -script [list [list $jsheader]] \
              -template $template ; # template string.