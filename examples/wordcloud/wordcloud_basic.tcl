lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : bump to 'v2.1.0' echarts-wordcloud
# v3.0 : Delete 'echarts-wordcloud.js' with jsfunc. It is inserted automatically when writing the html file.
# v4.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v5.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

set js [ticklecharts::jsfunc new {
                function () {
                    return 'rgb(' + [
                        Math.round(Math.random() * 160),
                        Math.round(Math.random() * 160),
                        Math.round(Math.random() * 160)
                    ].join(',') + ')';
                }
          }]

$chart SetOptions -tooltip {}

$chart Add "wordCloudSeries" -gridSize 2 \
                             -sizeRange [list {12 50}] \
                             -shape "pentagon" \
                             -width  600 \
                             -height 400 \
                             -drawOutOfBound "True" \
                             -textStyle [list color $js] \
                             -dataWCItem {
                               {name "Sam S Club" value 10000}
                               {name "Macys" value 6181}
                               {name "Amy Schumer" value 4386}
                               {name "Jurassic World" value 4055}
                               {name "Charter Communications" value 2467}
                               {name "Chick Fil A" value 2244}
                               {name "Planet Fitness" value 1898}
                               {name "Pitch Perfect" value 1484}
                               {name "Express" value 1112}
                               {name "Home" value 965}
                               {name "Johnny Depp" value 847}
                               {name "Lena Dunham" value 582}
                               {name "Lewis Hamilton" value 555}
                               {name "KXAN" value 550}
                               {name "Mary Ellen Mark" value 462}
                               {name "Farrah Abraham" value 366}
                               {name "Rita Ora" value 360}
                               {name "Serena Williams" value 282}
                               {name "NCAA baseball tournament" value 273}
                               {name "Point Break" value 265}
                             }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename