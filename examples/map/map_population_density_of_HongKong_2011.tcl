lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.
# v3.0 : Replaces '-dataMapItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# source :
# https://stackoverflow.com/questions/34761689/read-local-text-file-function-not-return-string-type-but-a-void-type
set js [ticklecharts::jsfunc new {
    var geoJson;
    var rawFile = new XMLHttpRequest();
    rawFile.open("GET", "https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/geo/HK.json", false);
    rawFile.onreadystatechange = function () {
      if (rawFile.readyState === 4) {
        if (rawFile.status === 200 || rawFile.status == 0) {
          geoJson = rawFile.responseText;
        }
      }
    }
  rawFile.send(null);
  echarts.registerMap('HK', { geoJson: geoJson });
} -start]

set jsf [ticklecharts::jsfunc new {"{b}<br/>{c} (p / km2)"}]

set chart [ticklecharts::chart new]

$chart SetOptions -title {
                        text "Population Density of Hong Kong (2011)"
                        subtext "Data from Wikipedia"
                        sublink "http://zh.wikipedia.org/wiki/%E9%A6%99%E6%B8%AF%E8%A1%8C%E6%94%BF%E5%8D%80%E5%8A%83#cite_note-12"
                    } \
                  -tooltip [list trigger "item" formatter $jsf] \
                  -toolbox {show "True" orient "vertical" left "right" top "middle" feature {dataView {readOnly "False"} restore {} saveAsImage {}}} \
                  -visualMap [list type "continuous" top "middle" min 800 max 50000 text [list {High Low}] realtime false calculable true inRange [list color [list {rgb(135,206,250) rgb(255,255,0) rgb(255,69,0)}]]]


$chart Add "mapSeries" -name "香港18区人口密度" -map "HK" -label {show "True"} \
                       -dataItem {
                           {name 中西区 value 20057.34 }
                           {name 湾仔 value 15477.48 }
                           {name 东区 value 31686.1 }
                           {name 南区 value 6992.6 }
                           {name 油尖旺 value 44045.49 }
                           {name 深水埗 value 40689.64 }
                           {name 九龙城 value 37659.78 }
                           {name 黄大仙 value 45180.97 }
                           {name 观塘 value 55204.26 }
                           {name 葵青 value 21900.9 }
                           {name 荃湾 value 4918.26 }
                           {name 屯门 value 5881.84 }
                           {name 元朗 value 4178.01 }
                           {name 北区 value 2227.92 }
                           {name 大埔 value 2180.98 }
                           {name 沙田 value 9172.94 }
                           {name 西贡 value 3368 }
                           {name 离岛 value 806.98 }
                       } \
                       -nameMap {
                           "Central and Western" "中西区"
                           "Eastern" "东区"
                           "Islands" "离岛"
                           "Kowloon City" "九龙城"
                           "Kwai Tsing" "葵青"
                           "Kwun Tong" "观塘"
                           "North" "北区"
                           "Sai Kung" "西贡"
                           "Sha Tin" "沙田"
                           "Sham Shui Po" "深水埗"
                           "Southern" "南区"
                           "Tai Po" "大埔"
                           "Tsuen Wan" "荃湾"
                           "Tuen Mun" "屯门"
                           "Wan Chai" "湾仔"
                           "Wong Tai Sin" "黄大仙"
                           "Yau Tsim Mong" "油尖旺"
                           "Yuen Long" "元朗"
                       }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -width 1500px \
              -height 900px \
              -script $js