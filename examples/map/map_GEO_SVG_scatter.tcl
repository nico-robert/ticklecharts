lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# source :
# https://stackoverflow.com/questions/34761689/read-local-text-file-function-not-return-string-type-but-a-void-type
set js [ticklecharts::jsfunc new {
    var svg;
    var rawFile = new XMLHttpRequest();
    rawFile.open("GET", "https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/geo/Map_of_Iceland.svg", false);
    rawFile.onreadystatechange = function () {
      if (rawFile.readyState === 4) {
        if (rawFile.status === 200 || rawFile.status == 0) {
          svg = rawFile.responseText;
        }
      }
    }
  rawFile.send(null);
  echarts.registerMap('iceland_svg', { svg: svg });
    
} -start]

set jsscatter [ticklecharts::jsfunc new {
        function (params) {
          return (params[2] / 100) * 15 + 5;
        }
}]

set jsend [ticklecharts::jsfunc new {
    mychart.getZr().on('click', function (params) {
      var pixelPoint = [params.offsetX, params.offsetY];
      var dataPoint = mychart.convertFromPixel({ geoIndex: 0 }, pixelPoint);
      console.log(dataPoint);
    });
} -end]

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {} \
                  -geo {tooltip {show "true"} map "iceland_svg" roam "True"}

$chart Add "scatterSeries" -type "effectScatter" -coordinateSystem "geo" -geoIndex 0 -symbolSize $jsscatter \
                           -itemStyle {color "#b02a02"} -encode {tooltip 2} \
                           -data [list \
                               {488.2358421078053 459.70913833075736 100} \
                               {770.3415644319939 757.9672194986475 30} \
                               {1180.0329284196291 743.6141808346214 80} \
                               {894.03790632245 1188.1985153835008 61} \
                               {1372.98925630313 477.3839988649537 70} \
                               {1378.62251255796 935.6708486282843 81} \
                           ]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -width 1500px \
              -height 900px \
              -script [list [list $js $jsend]] \
              -jschartvar "mychart"