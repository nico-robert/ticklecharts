proc fakerRandomValue {min max} {
    set range [expr {$max - $min}]
    return [expr {int(rand() * $range) + $min}]
}

proc dateMap {start end} {
    for {set i $start} {$i < $end} {incr i} {
        lappend data $i
    }
    return $data
}

proc dateMapValue {start end} {
    for {set i $start} {$i < $end} {incr i} {
        lappend data [fakerRandomValue 0 100]
    }
    return $data
}

lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0  : Initial example
# v2.0  : destroy all 'gridlayout' for source all.tcl + init set theme to basic
# v3.0  : Set theme on timeline Class instead layout Class.
#         Problem with tooltip when theming is set, correction 'textStyle' in file option.tcl
# v4.0  : add try command
# v5.0  : Rename '-datapieitem' by '-dataPieItem'
# v6.0  : Rename 'basic' theme to 'custom'
# v7.0  : adds myTheme variable
# v8.0  : adds splitline + label color
# v9.0  : Update example with the new 'Add' method for chart series.
# v10.0 : Replaces '-dataMapItem' by '-dataItem' (both properties are available).

# example from pyecharts-gallery-master... (modify)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set myTheme $::ticklecharts::theme

try {

    # add header 'France.js' from : https://github.com/echarts-maps/echarts-countries-js
    set header [ticklecharts::jsfunc new {
                                <script type="text/javascript" src="https://echarts-maps.github.io/echarts-countries-js/echarts-countries-js/France.js"></script>
                            } -header
                ]

    set timeline [ticklecharts::timeline new -theme dark]
    $timeline SetOptions -axisType "category" -orient "vertical" -autoPlay "True" -playInterval 3000 \
                        -bottom 20 -top 20 -inverse "True" -left null -right 5 -width 60

    set regions {
        "Alsace–Champagne-Ardenne–Lorraine"
        "Aquitaine-Limousin-Poitou-Charentes"
        "Auvergne-Rhône-Alpes"
        "Bourgogne-Franche-Comté"
        "Brittany"
        "Centre-Val de Loire"
        "Corsica"
        "French Guiana"
        "Guadeloupe"
        "Ile-de-France"
        "Languedoc-Roussillon-Midi-Pyrénées"
        "Martinique"
        "Mayotte"
        "Nord-Pas-de-Calais and Picardy"
        "Normandy"
        "Pays de la Loire"
        "Provence-Alpes-Côte d'Azur"
        "Réunion"
    }

    set start 2002
    set end 2024

    set dmv [dateMapValue $start $end]
    set dM [dateMap $start $end]
    set jj 0

    for {set i $start} {$i < $end} {incr i} {

        set layout [ticklecharts::Gridlayout new]

        $layout SetGlobalOptions -tooltip {} \
                                -visualMap [list \
                                            type "continuous" orient "vertical" \
                                            top 2% min 100 max 6000 \
                                            text [list {"High" "Low"}] dimension 0 realtime true calculable true inRange [list color [list {#dbac00 #db6e00 #cf0000}]] \
                                        ]

        # add data
        set data {}
        for {set j 0} {$j < 18} {incr j} {
            lappend data [fakerRandomValue 100 6000]
        }

        set dataItem [list \
                        [list name [lindex $regions 0] value [lindex $data 0]] \
                        [list name [lindex $regions 1] value [lindex $data 1]] \
                        [list name [lindex $regions 2] value [lindex $data 2]] \
                        [list name [lindex $regions 3] value [lindex $data 3]] \
                        [list name [lindex $regions 4] value [lindex $data 4]] \
                        [list name [lindex $regions 5] value [lindex $data 5]] \
                        [list name [lindex $regions 6] value [lindex $data 6]] \
                        [list name [lindex $regions 7] value [lindex $data 7]] \
                        [list name [lindex $regions 8] value [lindex $data 8]] \
                        [list name [lindex $regions 9] value [lindex $data 9]] \
                        [list name [lindex $regions 10] value [lindex $data 10]] \
                        [list name [lindex $regions 11] value [lindex $data 11]] \
                        [list name [lindex $regions 12] value [lindex $data 12]] \
                        [list name [lindex $regions 13] value [lindex $data 13]] \
                        [list name [lindex $regions 14] value [lindex $data 14]] \
                        [list name [lindex $regions 15] value [lindex $data 15]] \
                        [list name [lindex $regions 16] value [lindex $data 16]] \
                        [list name [lindex $regions 17] value [lindex $data 17]] \
                    ]

        set map [ticklecharts::chart new]
        # echarts.registerMap = "法国" 
        $map Add "mapSeries" -map "法国" -label {show "False"} \
                             -dataItem $dataItem

        set bar [ticklecharts::chart new]

        $bar Xaxis -type "value" -splitLine {show "True"}
        $bar Yaxis -data [list $regions] -type "category" -boundaryGap "True"
            
        $bar Add "barSeries" -data [list $data] \
                             -emphasis {focus "series"}


        set pie [ticklecharts::chart new]

        $pie Add "pieSeries" -radius "17%" \
                             -dataItem $dataItem


        set line [ticklecharts::chart new]
        
        $line Xaxis -data [list $dM]
        $line Yaxis -splitLine {show "True"}
        $line Add "lineSeries" -data [list $dmv] \
                               -markPoint [list \
                                            data [list \
                                                    [list name "Max" value [lindex $dmv $jj] xAxis $jj yAxis [lindex $dmv $jj] label {color "#100C2A"} itemStyle {color "#dbac00" borderColor "#dbac00"}] \
                                                ] \
                                        ]

        $layout Add $bar  -left  "15%" -bottom 20% -width 300 -height 360
        $layout Add $line -right "7%" -bottom 20% -width 370 -height 300
        $layout Add $pie  -center [list {79% 10%}]
        $layout Add $map  -top middle -left "center"
        

        $timeline Add $layout -data [list value "$i"]
        lappend llayout $layout

        incr jj
    }

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $timeline Render -outfile [file join $dirname $fbasename.html] \
                -title $fbasename \
                -width 1500px \
                -height 900px \
                -script $header

    # destroy for source all.tcl
    lmap ll $llayout {$ll destroy}

} on error {result options} {
    puts stderr "[info script] : $result"
} finally {
    # set theme
    set ::ticklecharts::theme $myTheme
}