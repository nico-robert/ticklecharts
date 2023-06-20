lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datapieitem' by '-dataPieItem'
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataScatterItem' by '-dataItem' (both properties are available).
#        Replaces '-dataPieItem' by '-dataItem' (both properties are available).
#        Replaces '-dataLinesItem' by '-dataItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set oldversion $::ticklecharts::echarts_version
# set minimum Echarts version for '-coordinateSystem' supported with pie series
if {[ticklecharts::vCompare $::ticklecharts::echarts_version "5.4.0"] == -1} {
    set ::ticklecharts::echarts_version "5.4.0"
}

# you can set your Key Google API here or in ticklecharts.tcl (variable keyGMAPI)
set ::ticklecharts::keyGMAPI "??"

set chart [ticklecharts::chart new]

# center = [lng, lat]
# For 'mapTypeId', 'styles' see : https://developers.google.com/maps/documentation/javascript/reference/map#MapOptions 
$chart SetOptions -tooltip {} \
                  -gmap [list \
                            center [list {2.00 46.00}] \
                            zoom 6.5 \
                            roam "True" \
                            disableDefaultUI "True" \
                            mapTypeId "roadmap" \
                            styles {
                                        {elementType "geometry" stylers {{color "#004981"}}}
                                        {elementType "labels" stylers {{visibility "off"}}}
                                        {elementType "labels.icon" stylers {{visibility "off"}}}
                                        {elementType "labels.text.fill" stylers {{visibility "off"}}}
                                        {featureType "road" elementType "geometry.fill" stylers {{visibility "off"}}}
                                        {featureType "water" elementType "geometry" stylers {{color "#044161"}}}
                                        {featureType "administrative" elementType "geometry" stylers {{visibility "on"} {color "#24b0e2"}}}
                                   }
]

# value : [lng, lat]
$chart Add "scatterSeries" -name "City" -symbolSize 15 \
                           -coordinateSystem "gmap" \
                           -type "effectScatter" \
                           -dataItem [list \
                                        [list name "Bayonne" value [list {-1.4724319938245576 43.49308776293058}]] \
                                        [list name "Paris" value [list {2.34960965438873 48.860204769341884}]] \
                                        [list name "Marseille" value [list {5.372546427576347 43.29511510366016}]] \
                                    ] \
                           -itemStyle {color "#f4e925" shadowBlur 10 shadowColor #333}


# center : [lng, lat]
$chart Add "pieSeries" -name "pie" \
                       -coordinateSystem "gmap" \
                       -selectedOffset 30 \
                       -center [list {-6.43676598655016 46.12723458558478}] \
                       -radius 90 \
                       -dataItem {
                         {value 300 name "Bayonne"}
                         {value 735 name "Paris"}
                         {value 580 name "Marseille"}
                       }

# coords : start point = [lng, lat], end point [lng, lat]
$chart Add "linesSeries" -name "Arrow" \
                         -coordinateSystem "gmap" \
                         -large "False" \
                         -progressiveThreshold 3000 \
                         -progressive 400 \
                         -polyline "False" \
                         -effect {
                                   show "True"
                                   trailLength 0.5
                                   period 4
                                   color "red"
                                   symbol "arrow"
                                   symbolSize 10
                                 } \
                         -symbolSize 12 \
                         -symbol [list {none arrow}] \
                         -dataItem [list \
                                           [list coords [list \
                                                       {-1.4724319938245576 43.49308776293058} \
                                                       {2.34960965438873 48.860204769341884} \
                                                   ] \
                                           ] \
                                           [list coords [list \
                                                       {2.34960965438873 48.860204769341884} \
                                                       {5.372546427576347 43.29511510366016} \
                                                   ] \
                                           ] \
                                           [list coords [list \
                                                       {5.372546427576347 43.29511510366016} \
                                                       {-1.4724319938245576 43.49308776293058} \
                                                   ] \
                                           ] \
                         ] \
                         -lineStyle {width 1 opacity 1 curveness 0.2 type solid}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -width 1500px \
              -height 900px

# set origin variable
set ::ticklecharts::echarts_version $oldversion
