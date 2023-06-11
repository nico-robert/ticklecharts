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
    rawFile.open("GET", "https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/geo/Veins_Medical_Diagram_clip_art.svg", false);
    rawFile.onreadystatechange = function () {
      if (rawFile.readyState === 4) {
        if (rawFile.status === 200 || rawFile.status == 0) {
          svg = rawFile.responseText;
        }
      }
    }
  rawFile.send(null);
  echarts.registerMap('organ_diagram', { svg: svg });
    
} -start]

set jsend [ticklecharts::jsfunc new {
    mychart.on('mouseover', { seriesIndex: 0 }, function (event) {
      mychart.dispatchAction({
        type: 'highlight',
        geoIndex: 0,
        name: event.name
      });
    });
    mychart.on('mouseout', { seriesIndex: 0 }, function (event) {
      mychart.dispatchAction({
        type: 'downplay',
        geoIndex: 0,
        name: event.name
      });
    });
} -end]

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {} \
                  -geo {
                        left 10 right "50%" map "organ_diagram" selectedMode "multiple" roam "false"
                        emphasis {focus "self" itemStyle {color "null"} label {position "bottom" distance 0 textBorderColor "#fff" textBorderWidth 2}}
                        blur {}
                        select {itemStyle {color "#b50205"} label {show "False" textBorderColor "#fff" textBorderWidth 2}}
                    } \
                   -grid {left "60%" top "20%" bottom "20%"}

$chart Xaxis -type "value"
$chart Yaxis -type "category" -data [list {heart large-intestine small-intestine spleen kidney lung liver}] -boundaryGap "True"

$chart Add "barSeries" -emphasis {focus "self"} -data [list {121 321 141 52 198 289 139}]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -width 1500px \
              -height 900px \
              -script [list [list $js $jsend]] \
              -jschartvar "mychart"