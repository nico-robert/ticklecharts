lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Add ParallelAxis as method instead of a option.
# v3.0 : Move '-animation' from constructor to 'SetOptions' method with v3.0.1
# v4.0 : Update example with the new 'Add' method for chart series.
# v5.0 : Update of 'ParallelAxis' method with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without. (v3.2.3)

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

proc retrieveScatterData {data dimX dimY} {
    set result {}
    for {set i 0} {$i < [llength $data]} {incr i} {
        lappend result [list [lindex $data $i $dimX] \
                             [lindex $data $i $dimY] \
                             {*}[lrepeat 5 "-"] \
                             [lindex $data $i $::CATEGORY_DIM]]
    }

    return $result
}

proc generateGrids {layout data} {

    set index 0
    
    for {set i 0} {$i < $::CATEGORY_DIM_COUNT} {incr i} {
        for {set j 0} {$j < $::CATEGORY_DIM_COUNT} {incr j} {
            if {($::CATEGORY_DIM_COUNT - $i + $j) >= $::CATEGORY_DIM_COUNT} {
                continue
            }

            set scatter [ticklecharts::chart new]
            
            set show [expr {($j == 0) ? true : false}]
            $scatter Xaxis -type "value" -splitNumber 3 -position "top" -axisLine [list show $show onZero "False"] \
                           -axisTick [list show $show inside "True"] \
                           -axisLabel [list show $show] \
                           -gridIndex $index -scale "True"

            set show [expr {($i == $::CATEGORY_DIM_COUNT - 1) ? true : false}]
            $scatter Yaxis -type "value" -splitNumber 3 -position "right" -axisLine [list show $show onZero "False"] \
                           -axisTick [list show $show inside "True"] \
                           -axisLabel [list show $show] \
                           -gridIndex $index -scale "True"

            $scatter Add "scatterSeries" -symbolSize $::SYMBOL_SIZE \
                                         -xAxisIndex $index \
                                         -yAxisIndex $index \
                                         -data [list {*}[retrieveScatterData $data $i $j]]

            
            $layout Add $scatter -left   [format {%s%%} [expr {$::BASE_LEFT + $i * ($::GRID_WIDTH + $::GAP)}]] \
                                 -top    [format {%s%%} [expr {$::BASE_TOP + $j * ($::GRID_HEIGHT + $::GAP)}]] \
                                 -width  [format {%s%%} $::GRID_WIDTH] \
                                 -height [format {%s%%} $::GRID_HEIGHT]

            incr index
        }
        
    }
    
}

set schema {
    { name AQIindex index: 1 text "AQI" }
    { name PM25 index: 2 text "PM 2.5" }
    { name PM10 index: 3 text "PM 10" }
    { name CO index: 4 text "CO" }
    { name NO2 index: 5 text "NO₂" }
    { name SO2 index: 6 text "SO₂" }
    { name 等级 index: 7 text "等级" }
  }

set rawData {
    {55 9 56 0.46 18 6 "良" "北京"}
    {25 11 21 0.65 34 9 "优" "北京"}
    {56 7 63 0.3 14 5 "良" "北京"}
    {33 7 29 0.33 16 6 "优" "北京"}
    {42 24 44 0.76 40 16 "优" "北京"}
    {82 58 90 1.77 68 33 "良" "北京"}
    {74 49 77 1.46 48 27 "良" "北京"}
    {78 55 80 1.29 59 29 "良" "北京"}
    {267 216 280 4.8 108 64 "重度" "北京"}
    {185 127 216 2.52 61 27 "中度" "北京"}
    {39 19 38 0.57 31 15 "优" "北京"}
    {41 11 40 0.43 21 7 "优" "北京"}
    {64 38 74 1.04 46 22 "良" "北京"}
    {108 79 120 1.7 75 41 "轻度" "北京"}
    {108 63 116 1.48 44 26 "轻度" "北京"}
    {33 6 29 0.34 13 5 "优" "北京"}
    {94 66 110 1.54 62 31 "良" "北京"}
    {186 142 192 3.88 93 79 "中度" "北京"}
    {57 31 54 0.96 32 14 "良" "北京"}
    {22 8 17 0.48 23 10 "优" "北京"}
    {39 15 36 0.61 29 13 "优" "北京"}
    {94 69 114 2.08 73 39 "良" "北京"}
    {99 73 110 2.43 76 48 "良" "北京"}
    {31 12 30 0.5 32 16 "优" "北京"}
    {42 27 43 1 53 22 "优" "北京"}
    {154 117 157 3.05 92 58 "中度" "北京"}
    {234 185 230 4.09 123 69 "重度" "北京"}
    {160 120 186 2.77 91 50 "中度" "北京"}
    {134 96 165 2.76 83 41 "轻度" "北京"}
    {52 24 60 1.03 50 21 "良" "北京"}
    {46 5 49 0.28 10 6 "优" "北京"}
    {26 37 27 1.163 27 13 "优" "广州"}
    {85 62 71 1.195 60 8 "良" "广州"}
    {78 38 74 1.363 37 7 "良" "广州"}
    {21 21 36 0.634 40 9 "优" "广州"}
    {41 42 46 0.915 81 13 "优" "广州"}
    {56 52 69 1.067 92 16 "良" "广州"}
    {64 30 28 0.924 51 2 "良" "广州"}
    {55 48 74 1.236 75 26 "良" "广州"}
    {76 85 113 1.237 114 27 "良" "广州"}
    {91 81 104 1.041 56 40 "良" "广州"}
    {84 39 60 0.964 25 11 "良" "广州"}
    {64 51 101 0.862 58 23 "良" "广州"}
    {70 69 120 1.198 65 36 "良" "广州"}
    {77 105 178 2.549 64 16 "良" "广州"}
    {109 68 87 0.996 74 29 "轻度" "广州"}
    {73 68 97 0.905 51 34 "良" "广州"}
    {54 27 47 0.592 53 12 "良" "广州"}
    {51 61 97 0.811 65 19 "良" "广州"}
    {91 71 121 1.374 43 18 "良" "广州"}
    {73 102 182 2.787 44 19 "良" "广州"}
    {73 50 76 0.717 31 20 "良" "广州"}
    {84 94 140 2.238 68 18 "良" "广州"}
    {93 77 104 1.165 53 7 "良" "广州"}
    {99 130 227 3.97 55 15 "良" "广州"}
    {146 84 139 1.094 40 17 "轻度" "广州"}
    {113 108 137 1.481 48 15 "轻度" "广州"}
    {81 48 62 1.619 26 3 "良" "广州"}
    {56 48 68 1.336 37 9 "良" "广州"}
    {82 92 174 3.29 0 13 "良" "广州"}
    {106 116 188 3.628 101 16 "轻度" "广州"}
    {118 50 0 1.383 76 11 "轻度" "广州"}
    {91 45 125 0.82 34 23 "良" "上海"}
    {65 27 78 0.86 45 29 "良" "上海"}
    {83 60 84 1.09 73 27 "良" "上海"}
    {109 81 121 1.28 68 51 "轻度" "上海"}
    {106 77 114 1.07 55 51 "轻度" "上海"}
    {109 81 121 1.28 68 51 "轻度" "上海"}
    {106 77 114 1.07 55 51 "轻度" "上海"}
    {89 65 78 0.86 51 26 "良" "上海"}
    {53 33 47 0.64 50 17 "良" "上海"}
    {80 55 80 1.01 75 24 "良" "上海"}
    {117 81 124 1.03 45 24 "轻度" "上海"}
    {99 71 142 1.1 62 42 "良" "上海"}
    {95 69 130 1.28 74 50 "良" "上海"}
    {116 87 131 1.47 84 40 "轻度" "上海"}
    {108 80 121 1.3 85 37 "轻度" "上海"}
    {134 83 167 1.16 57 43 "轻度" "上海"}
    {79 43 107 1.05 59 37 "良" "上海"}
    {71 46 89 0.86 64 25 "良" "上海"}
    {97 71 113 1.17 88 31 "良" "上海"}
    {84 57 91 0.85 55 31 "良" "上海"}
    {87 63 101 0.9 56 41 "良" "上海"}
    {104 77 119 1.09 73 48 "轻度" "上海"}
    {87 62 100 1 72 28 "良" "上海"}
    {168 128 172 1.49 97 56 "中度" "上海"}
    {65 45 51 0.74 39 17 "良" "上海"}
    {39 24 38 0.61 47 17 "优" "上海"}
    {39 24 39 0.59 50 19 "优" "上海"}
    {93 68 96 1.05 79 29 "良" "上海"}
    {188 143 197 1.66 99 51 "中度" "上海"}
    {174 131 174 1.55 108 50 "中度" "上海"}
    {187 143 201 1.39 89 53 "中度" "上海"}
}

set CATEGORY_DIM_COUNT 6
set GAP 2
set BASE_LEFT 5
set BASE_TOP 10

set GRID_WIDTH [expr {(100 - $BASE_LEFT - $GAP) / double($CATEGORY_DIM_COUNT) - $GAP}]
set GRID_HEIGHT [expr {(100 - $BASE_TOP - $GAP) / double($CATEGORY_DIM_COUNT) - $GAP}]
set CATEGORY_DIM 7
set SYMBOL_SIZE 4

set layout [ticklecharts::Gridlayout new]

$layout SetGlobalOptions -animation "False" \
                         -visualMap [list type "piecewise" show "True" categories [list {"北京" "上海" "广州"}] \
                                     dimension $CATEGORY_DIM \
                                     orient "horizontal" \
                                     inRange [list color [list {"#51689b" "#ce5c5c" "#fbc357"}]] \
                                     outOfRange {color "#ddd"} \
                                     top 0 left "center" \
                                     ] \
                         -tooltip {trigger "item"} \
                         -brush {brushLink "all" inBrush {opacity 1}}


set parallel [ticklecharts::chart new]

$parallel SetOptions -parallel {
        left 2% right 18% bottom 5% height 30% width 55% 
        parallelAxisDefault {
            type value name "AQI指数" nameLocation "end" nameGap 20 splitNumber 3 nameTextStyle {fontSize 14 verticalAlign "middle"}
            axisLine {show "True" lineStyle {color "#555"}} axisTick {lineStyle {color "#555"}} splitLine {show "False"}
            axisLabel {color "#555"}
        }
    }
$parallel ParallelAxis [list \
    [list dim 0 name [dict get [lindex $schema 0] text]] \
    [list dim 1 name [dict get [lindex $schema 1] text] ] \
    [list dim 2 name [dict get [lindex $schema 2] text] ] \
    [list dim 3 name [dict get [lindex $schema 3] text] ] \
    [list dim 4 name [dict get [lindex $schema 4] text] ] \
    [list dim 5 name [dict get [lindex $schema 5] text] ] \
    [list dim 6 name [dict get [lindex $schema 6] text] type "category" data {{"优" "良" "轻度" "中度" "重度" "严重"}}] \
]


$parallel Add "parallelSeries" -name "parallel" -smooth "True" -lineStyle {width 1 opacity 0.3} -data [list {*}$rawData]

generateGrids $layout $rawData

$layout Add $parallel -bottom "60%" -width "30%" -left "5%"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1200px -height 900px