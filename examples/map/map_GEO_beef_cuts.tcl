lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.
# v3.0 : Replaces '-dataMapItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# source :
# https://stackoverflow.com/questions/34761689/read-local-text-file-function-not-return-string-type-but-a-void-type
set js [ticklecharts::jsfunc new {
    var svg;
    var rawFile = new XMLHttpRequest();
    rawFile.open("GET", "https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/geo/Beef_cuts_France.svg", false);
    rawFile.onreadystatechange = function () {
      if (rawFile.readyState === 4) {
        if (rawFile.status === 200 || rawFile.status == 0) {
          svg = rawFile.responseText;
        }
      }
    }
  rawFile.send(null);
  echarts.registerMap('Beef_cuts_France', { svg: svg });
    
} -start]

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {} \
                  -visualMap [list \
                                type "continuous" orient "horizontal" \
                                left center bottom 10% min 5 max 100 \
                                text [list {"" Price}] realtime true calculable true inRange [list color [list {#dbac00 #db6e00 #cf0000}]] \
                            ]

$chart Add "mapSeries" -name "French Beef Cuts" -map "Beef_cuts_France" -roam true -emphasis {label {show "False"}} \
                       -selectedMode false \
                       -dataItem {
                           {name "Queue" value 15 }
                           {name "Langue" value 35 }
                           {name "Plat de joue" value 15 }
                           {name "Gros bout de poitrine" value 25 }
                           {name "Jumeau à pot-au-feu" value 45 }
                           {name "Onglet" value 85 }
                           {name "Plat de tranche" value 25 }
                           {name "Araignée" value 15 }
                           {name "Gîte à la noix" value 55 }
                           {name "Bavette d'aloyau" value 25 }
                           {name "Tende de tranche" value 65 }
                           {name "Rond de gîte" value 45 }
                           {name "Bavettede de flanchet" value 85 }
                           {name "Flanchet" value 35 }
                           {name "Hampe" value 75 }
                           {name "Plat de côtes" value 65 }
                           {name "Tendron Milieu de poitrine" value 65 }
                           {name "Macreuse à pot-au-feu" value 85 }
                           {name "Rumsteck" value 75 }
                           {name "Faux-filet" value 65 }
                           {name "Côtes Entrecôtes" value 55 }
                           {name "Basses côtes" value 45 }
                           {name "Collier" value 85 }
                           {name "Jumeau à biftek" value 15 }
                           {name "Paleron" value 65 }
                           {name "Macreuse à bifteck" value 45 }
                           {name "Gîte" value 85 }
                           {name "Aiguillette baronne" value 65 }
                           {name "Filet" value 95 }
                       }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
                  -title $fbasename \
                  -width 1500px \
                  -height 900px \
                  -script $js
