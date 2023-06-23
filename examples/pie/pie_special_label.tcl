lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : image path correction
# v3.0 : Rename '-datapieitem' by '-dataPieItem' + 
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Replaces '-dataPieItem' by '-dataItem' (both properties are available).
#        Replaces 'richitem' by 'richItem' (both properties are available).

# image dir
set imagedir ../../images

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set pie [ticklecharts::chart new]

#js function...
set tooltipjs [ticklecharts::jsfunc new {"{a} <br/>{b} : {c} ({d}%)"}]
set js [ticklecharts::jsfunc new {
                        [
                        '{title|{b}}{abg|}',
                        '  {weatherHead|Weather}{valueHead|Days}{rateHead|Percent}',
                        '{hr|}',
                        '  {Sunny|}{value|202}{rate|55.3%}',
                        '  {Cloudy|}{value|142}{rate|38.9%}',
                        '  {Showers|}{value|21}{rate|5.8%}'
                        ].join('\n'),
                                    }
            ]

set data [list \
          [list value 1548 name "CityE" label \
          [list lineHeight 20 formatter $js backgroundColor "#eee" borderColor "#777" borderWidth 1 borderRadius 4 \
                richItem [list \
                    title       [list color "#eee" align "center"] \
                    abg         [list backgroundColor "#333" width "100%" align "right" height 25 borderRadius [list {4 4 0 0}]] \
                    Sunny       [list height 30 align "left" backgroundColor [list image [file join $imagedir sunny.png]]] \
                    Cloudy      [list height 30 align "left" backgroundColor [list image [file join $imagedir cloudy.png]]] \
                    Showers     [list height 30 align "left" backgroundColor [list image [file join $imagedir showers.png]]] \
                    weatherHead [list height 24 align "left" color "#333"] \
                    hr          [list height 0 width "100%" borderColor "#777" borderWidth 0.5] \
                    value       [list  color "#333" width 20 align "left" padding [list {0 20 0 30}]] \
                    valueHead   [list  color "#333" width 20 align "center" padding [list {0 20 0 30}]] \
                    rate        [list  color "#333" width 40 align "right" padding [list {0 10 0 0}]] \
                    rateHead    [list  color "#333" width 40 align "center" padding [list {0 10 0 0}]] \
                ]
            ]] \
            [list value 735 name "CityC"] \
            [list value 510 name "CityD"] \
            [list value 434 name "CityB"] \
            [list value 335 name "CityA"] \
         ]

$pie SetOptions -title  {text "Weather Statistics" subtext "Fake Data" left "center"} \
                -legend {bottom 10 left "center"} \
                -tooltip [list trigger "item" formatter $tooltipjs]

$pie Add "pieSeries" -radius "65%" -center [list {50% 50%}] -selectedMode "single" \
                     -emphasis  {itemStyle {shadowBlur 10 shadowOffsetX 0 shadowColor "rgba(0, 0, 0, 0.5)"}} \
                     -dataItem $data

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$pie Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width "1586px" -height "766px"