lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# source: https://www.makeapie.cn/echarts_content/xJjnxsQM4h.html
set ec [ticklecharts::eColor new {
        type "linear"
        x 0
        y 0
        x2 0
        y2 1
        colorStops {
            {offset 0 color "rgba(0,255,245,0.5)"}
            {offset 1 color "#43bafe"}
        }
        global false
    }
]

set ec1 [ticklecharts::eColor new {
        type "linear"
        x 0
        y 0
        x2 0
        y2 1
        colorStops {
            {offset 0 color "rgba(255,204,0,0.5)"}
            {offset 1 color "#ff7800"}
        }
        global false
    }
]

set ec2 [ticklecharts::eColor new {
        type "linear"
        x 0
        y 0
        x2 0
        y2 1
        colorStops {
            {offset 0 color "rgba(185,183,255,0.5)"}
            {offset 1 color "#e9a5ff"}
        }
        global false
    }
]

set picBar [ticklecharts::chart new]


$picBar SetOptions -backgroundColor "#0e202d" \
                   -title {
                        text "第三采油厂"
                        subtext "总数: 599"
                        textStyle {
                            color "#fff"
                            fontSize 20
                        }
                        subtextStyle {
                            color "#999"
                            fontSize 16
                        }
                        top "0%"
                        left center
                   } \
                   -grid {top 200 bottom 150} \
                   -tooltip {}

$picBar Xaxis -data {{"关井数" "开井数" "不在线"}} -axisTick {show false} \
              -axisLine {show false} \
              -axisLabel {interval 0 color #beceff fontSize 20 margin 80}

$picBar Yaxis -splitLine {show false} -axisTick {show false} -axisLine {show false} \
              -axisLabel {show false}


$picBar Add "pictorialBarSeries" -symbolSize {{100 45}} \
                                 -symbolOffset {{0 -20}} \
                                 -z 12 \
                                 -dataItem {
                                    {name "关井数" value 981 symbolPosition end itemStyle {color "#00fff5"}}
                                    {name "开井数" value 1000 symbolPosition end itemStyle {color "#ffcc00"}}
                                    {name "不在线" value 900 symbolPosition end itemStyle {color "#b9b7ff"}}
                                 }

$picBar Add "pictorialBarSeries" -symbolSize {{100 45}} \
                                 -symbolOffset {{0 24}} \
                                 -z 12 \
                                 -dataItem {
                                    {name "关井数" value 981 itemStyle {color "#43bafe"}}
                                    {name "开井数" value 1000 itemStyle {color "#ff7800"}}
                                    {name "不在线" value 900 itemStyle {color "#e9a5ff"}}
                                 }

$picBar Add "pictorialBarSeries" -symbolSize {{150 75}} \
                                 -symbolOffset {{0 44}} \
                                 -z 12 \
                                 -dataItem {
                                    {name "关井数" value 981 itemStyle {color "transparent" borderColor #43bafe borderWidth 5}}
                                    {name "开井数" value 1000 itemStyle {color "transparent" borderColor #ff7800 borderWidth 5}}
                                    {name "不在线" value 900 itemStyle {color "transparent" borderColor #e9a5ff borderWidth 5}}
                                 }

$picBar Add "pictorialBarSeries" -symbolSize {{200 100}} \
                                 -symbolOffset {{0 62}} \
                                 -z 10 \
                                 -dataItem {
                                    {name "关井数" value 981 itemStyle {color "transparent" borderColor #43bafe borderWidth 5 borderType dashed}}
                                    {name "开井数" value 1000 itemStyle {color "transparent" borderColor #ff7800 borderWidth 5 borderType dashed}}
                                    {name "不在线" value 900 itemStyle {color "transparent" borderColor #e9a5ff borderWidth 5 borderType dashed}}
                                 }

$picBar Add "barSeries" -silent true -barWidth 100 -barGap -100% \
                        -dataItem [subst {
                            {name 关井数 value 981 label {show true position top distance 40 color "#00fff5" fontSize 40} itemStyle {color $ec}}
                            {name 开井数 value 1000 label {show true position top distance 40 color "#ffcc00" fontSize 40} itemStyle {color $ec1}}
                            {name 不在线 value 900 label {show true position top distance 40 color "#b9b7ff" fontSize 40} itemStyle {color $ec2}}
                        }]

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$picBar Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width 1400px -height 900px