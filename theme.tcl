# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::theme {value} {
    # Set default value for theme. (https://echarts.apache.org/en/theme-builder.html)
    # An error exception is raised if name of theme is not found
    # 
    # value - dict
    #
    # set global theme ticklecharts
    variable theme

    if {[dict exists $value -theme]} {
        set t [dict get $value -theme]
    } else {
        set t $theme
    }
    
    set ticklecharts::opts_theme [dict create]
    
    switch -exact -- $t {
        vintage {
            dict set ticklecharts::opts_theme color                      [list {#d87c7c #919e8b #d7ab82 #6e7074 #61a0a8 #efa18d #787464 #cc7e63 #724e58 #4b565b}]
            dict set ticklecharts::opts_theme backgroundColor            "rgba(254,248,239,1)"
            dict set ticklecharts::opts_theme titleColor                 #333333
            dict set ticklecharts::opts_theme subtitleColor              #aaaaaa
            dict set ticklecharts::opts_theme textColor                  #333
            dict set ticklecharts::opts_theme markTextColor              #eeeeee
            dict set ticklecharts::opts_theme borderColor                #ccc
            dict set ticklecharts::opts_theme borderWidth                0
            dict set ticklecharts::opts_theme legendTextColor            #333333
            dict set ticklecharts::opts_theme lineWidth                  2
            dict set ticklecharts::opts_theme symbolSize                 4
            dict set ticklecharts::opts_theme symbol                     "emptyCircle"
            dict set ticklecharts::opts_theme symbolBorderWidth          1
            dict set ticklecharts::opts_theme lineSmooth                 false
            dict set ticklecharts::opts_theme graphLineWidth             1
            dict set ticklecharts::opts_theme graphLineColor             "#aaa"
            dict set ticklecharts::opts_theme axisLineShow               true
            dict set ticklecharts::opts_theme axisLineColor              "#333"
            dict set ticklecharts::opts_theme axisTickShow               true
            dict set ticklecharts::opts_theme axisTickColor              "#333"
            dict set ticklecharts::opts_theme axisLabelShow              true
            dict set ticklecharts::opts_theme axisLabelColor             "#333"
            dict set ticklecharts::opts_theme splitLineShow              true
            dict set ticklecharts::opts_theme splitLineColor             "#ccc"
            dict set ticklecharts::opts_theme splitAreaShow              true
            dict set ticklecharts::opts_theme splitAreaColor             [list {rgba(250,250,250,0.3) rgba(200,200,200,0.3)}]
            dict set ticklecharts::opts_theme toolboxColor               "#999999"
            dict set ticklecharts::opts_theme toolboxEmphasisColor       "#666666"
            dict set ticklecharts::opts_theme tooltipAxisColor           "#cccccc"
            dict set ticklecharts::opts_theme tooltipAxisWidth           1
            dict set ticklecharts::opts_theme timelineLineColor          "#293c55"
            dict set ticklecharts::opts_theme timelineLineWidth          1
            dict set ticklecharts::opts_theme timelineItemColor          "#293c55"
            dict set ticklecharts::opts_theme timelineItemColorE         "#293c55"
            dict set ticklecharts::opts_theme timelineCheckColor         "#e43c59"
            dict set ticklecharts::opts_theme timelineCheckBorderColor   "#c23531"
            dict set ticklecharts::opts_theme timelineItemBorderWidth    1
            dict set ticklecharts::opts_theme timelineControlColor       "#293c55"
            dict set ticklecharts::opts_theme timelineControlBorderColor "#293c55"
            dict set ticklecharts::opts_theme timelineControlBorderWidth 0.5
            dict set ticklecharts::opts_theme timelineLabelColor         "#293c55"
            dict set ticklecharts::opts_theme datazoomBackgroundColor    "rgba(47,69,84,0)"
            dict set ticklecharts::opts_theme datazoomDataColor          "rgba(47,69,84,0.3)"
            dict set ticklecharts::opts_theme datazoomFillColor          "rgba(167,183,204,0.4)"
            dict set ticklecharts::opts_theme datazoomHandleColor        "#a7b7cc"
            dict set ticklecharts::opts_theme datazoomHandleWidth        100
            dict set ticklecharts::opts_theme datazoomLabelColor         "#333333"
            dict set ticklecharts::opts_theme axisXgridlineShow          false
            dict set ticklecharts::opts_theme axisYgridlineShow          true
        }
        westeros {
            dict set ticklecharts::opts_theme color                      [list {#516b91 #59c4e6 #edafda #93b7e3 #a5e7f0 #cbb0e3}]
            dict set ticklecharts::opts_theme backgroundColor            "rgba(0,0,0,0)"
            dict set ticklecharts::opts_theme titleColor                 #516b91
            dict set ticklecharts::opts_theme subtitleColor              #93b7e3
            dict set ticklecharts::opts_theme textColor                  #333
            dict set ticklecharts::opts_theme markTextColor              #eeeeee
            dict set ticklecharts::opts_theme borderColor                #ccc
            dict set ticklecharts::opts_theme borderWidth                0
            dict set ticklecharts::opts_theme legendTextColor            #999999
            dict set ticklecharts::opts_theme lineWidth                  2
            dict set ticklecharts::opts_theme symbolSize                 6
            dict set ticklecharts::opts_theme symbol                     "emptyCircle"
            dict set ticklecharts::opts_theme symbolBorderWidth          2
            dict set ticklecharts::opts_theme lineSmooth                 true
            dict set ticklecharts::opts_theme graphLineWidth             1
            dict set ticklecharts::opts_theme graphLineColor             "#aaa"
            dict set ticklecharts::opts_theme axisLineShow               true
            dict set ticklecharts::opts_theme axisLineColor              "#cccccc"
            dict set ticklecharts::opts_theme axisTickShow               false
            dict set ticklecharts::opts_theme axisTickColor              "#333"
            dict set ticklecharts::opts_theme axisLabelShow              true
            dict set ticklecharts::opts_theme axisLabelColor             "#999999"
            dict set ticklecharts::opts_theme splitLineShow              true
            dict set ticklecharts::opts_theme splitLineColor             "#eeeeee"
            dict set ticklecharts::opts_theme splitAreaShow              false
            dict set ticklecharts::opts_theme splitAreaColor             [list {rgba(250,250,250,0.05) rgba(200,200,200,0.02)}]
            dict set ticklecharts::opts_theme toolboxColor               "#999999"
            dict set ticklecharts::opts_theme toolboxEmphasisColor       "#666666"
            dict set ticklecharts::opts_theme tooltipAxisColor           "#cccccc"
            dict set ticklecharts::opts_theme tooltipAxisWidth           1
            dict set ticklecharts::opts_theme timelineLineColor          "#8fd3e8"
            dict set ticklecharts::opts_theme timelineLineWidth          1
            dict set ticklecharts::opts_theme timelineItemColor          "#8fd3e8"
            dict set ticklecharts::opts_theme timelineItemColorE         "#8fd3e8"
            dict set ticklecharts::opts_theme timelineCheckColor         "#8fd3e8"
            dict set ticklecharts::opts_theme timelineCheckBorderColor   "#8a7ca8"
            dict set ticklecharts::opts_theme timelineItemBorderWidth    1
            dict set ticklecharts::opts_theme timelineControlColor       "#8fd3e8"
            dict set ticklecharts::opts_theme timelineControlBorderColor "#8fd3e8"
            dict set ticklecharts::opts_theme timelineControlBorderWidth 0.5
            dict set ticklecharts::opts_theme timelineLabelColor         "#8fd3e8"
            dict set ticklecharts::opts_theme datazoomBackgroundColor    "rgba(0,0,0,0)"
            dict set ticklecharts::opts_theme datazoomDataColor          "rgba(255,255,255,0.3)"
            dict set ticklecharts::opts_theme datazoomFillColor          "rgba(167,183,204,0.4)"
            dict set ticklecharts::opts_theme datazoomHandleColor        "#a7b7cc"
            dict set ticklecharts::opts_theme datazoomHandleWidth        100
            dict set ticklecharts::opts_theme datazoomLabelColor         "#333"
            dict set ticklecharts::opts_theme axisXgridlineShow          false
            dict set ticklecharts::opts_theme axisYgridlineShow          true
        }
        wonderland {
            dict set ticklecharts::opts_theme color                      [list {#4ea397 #22c3aa #7bd9a5 #d0648a #f58db2 #f2b3c9}]
            dict set ticklecharts::opts_theme backgroundColor            "rgba(255,255,255,0)"
            dict set ticklecharts::opts_theme titleColor                 #666666
            dict set ticklecharts::opts_theme subtitleColor              #999999
            dict set ticklecharts::opts_theme textColor                  #333
            dict set ticklecharts::opts_theme markTextColor              #ffffff
            dict set ticklecharts::opts_theme borderColor                #ccc
            dict set ticklecharts::opts_theme borderWidth                0
            dict set ticklecharts::opts_theme legendTextColor            #999999
            dict set ticklecharts::opts_theme lineWidth                  3
            dict set ticklecharts::opts_theme symbolSize                 8
            dict set ticklecharts::opts_theme symbol                     "emptyCircle"
            dict set ticklecharts::opts_theme symbolBorderWidth          2
            dict set ticklecharts::opts_theme lineSmooth                 false
            dict set ticklecharts::opts_theme graphLineWidth             1
            dict set ticklecharts::opts_theme graphLineColor             "#cccccc"
            dict set ticklecharts::opts_theme axisLineShow               true
            dict set ticklecharts::opts_theme axisLineColor              "#cccccc"
            dict set ticklecharts::opts_theme axisTickShow               false
            dict set ticklecharts::opts_theme axisTickColor              "#333"
            dict set ticklecharts::opts_theme axisLabelShow              true
            dict set ticklecharts::opts_theme axisLabelColor             "#999999"
            dict set ticklecharts::opts_theme splitLineShow              true
            dict set ticklecharts::opts_theme splitLineColor             "#eeeeee"
            dict set ticklecharts::opts_theme splitAreaShow              false
            dict set ticklecharts::opts_theme splitAreaColor             [list {rgba(250,250,250,0.05) rgba(200,200,200,0.02)}]
            dict set ticklecharts::opts_theme toolboxColor               "#999999"
            dict set ticklecharts::opts_theme toolboxEmphasisColor       "#666666"
            dict set ticklecharts::opts_theme tooltipAxisColor           "#cccccc"
            dict set ticklecharts::opts_theme tooltipAxisWidth           1
            dict set ticklecharts::opts_theme timelineLineColor          "#4ea397"
            dict set ticklecharts::opts_theme timelineLineWidth          1
            dict set ticklecharts::opts_theme timelineItemColor          "#4ea397"
            dict set ticklecharts::opts_theme timelineItemColorE         "#4ea397"
            dict set ticklecharts::opts_theme timelineCheckColor         "#4ea397"
            dict set ticklecharts::opts_theme timelineCheckBorderColor   "#3cebd2"
            dict set ticklecharts::opts_theme timelineItemBorderWidth    1
            dict set ticklecharts::opts_theme timelineControlColor       "#4ea397"
            dict set ticklecharts::opts_theme timelineControlBorderColor "#4ea397"
            dict set ticklecharts::opts_theme timelineControlBorderWidth 0.5
            dict set ticklecharts::opts_theme timelineLabelColor         "#4ea397"
            dict set ticklecharts::opts_theme datazoomBackgroundColor    "rgba(255,255,255,0)"
            dict set ticklecharts::opts_theme datazoomDataColor          "rgba(222,222,222,1)"
            dict set ticklecharts::opts_theme datazoomFillColor          "rgba(114,230,212,0.25)"
            dict set ticklecharts::opts_theme datazoomHandleColor        "#cccccc"
            dict set ticklecharts::opts_theme datazoomHandleWidth        100
            dict set ticklecharts::opts_theme datazoomLabelColor         "#999999"
            dict set ticklecharts::opts_theme axisXgridlineShow          false
            dict set ticklecharts::opts_theme axisYgridlineShow          true
        }
        dark {
            dict set ticklecharts::opts_theme color                      [list {#dd6b66 #759aa0 #e69d87 #8dc1a9 #ea7e53 #eedd78 #73a373 #73b9bc #7289ab #91ca8c #f49f42}]
            dict set ticklecharts::opts_theme backgroundColor            "rgba(51,51,51,1)"
            dict set ticklecharts::opts_theme titleColor                 #eeeeee
            dict set ticklecharts::opts_theme subtitleColor              #aaaaaa
            dict set ticklecharts::opts_theme textColor                  #333
            dict set ticklecharts::opts_theme markTextColor              #eee
            dict set ticklecharts::opts_theme borderColor                #ccc
            dict set ticklecharts::opts_theme borderWidth                0
            dict set ticklecharts::opts_theme legendTextColor            #eeeeee
            dict set ticklecharts::opts_theme lineWidth                  2
            dict set ticklecharts::opts_theme symbolSize                 4
            dict set ticklecharts::opts_theme symbol                     "circle"
            dict set ticklecharts::opts_theme symbolBorderWidth          1
            dict set ticklecharts::opts_theme lineSmooth                 false
            dict set ticklecharts::opts_theme graphLineWidth             1
            dict set ticklecharts::opts_theme graphLineColor             "#aaa"
            dict set ticklecharts::opts_theme axisLineShow               true
            dict set ticklecharts::opts_theme axisLineColor              "#eeeeee"
            dict set ticklecharts::opts_theme axisTickShow               true
            dict set ticklecharts::opts_theme axisTickColor              "#eeeeee"
            dict set ticklecharts::opts_theme axisLabelShow              true
            dict set ticklecharts::opts_theme axisLabelColor             "#eeeeee"
            dict set ticklecharts::opts_theme splitLineShow              true
            dict set ticklecharts::opts_theme splitLineColor             "#aaaaaa"
            dict set ticklecharts::opts_theme splitAreaShow              false
            dict set ticklecharts::opts_theme splitAreaColor             [list {rgba(250,250,250,0.3) rgba(200,200,200,0.3)}]
            dict set ticklecharts::opts_theme toolboxColor               "#999999"
            dict set ticklecharts::opts_theme toolboxEmphasisColor       "#666666"
            dict set ticklecharts::opts_theme tooltipAxisColor           "#eeeeee"
            dict set ticklecharts::opts_theme tooltipAxisWidth           1
            dict set ticklecharts::opts_theme timelineLineColor          "#eeeeee"
            dict set ticklecharts::opts_theme timelineLineWidth          1
            dict set ticklecharts::opts_theme timelineItemColor          "#a9334c"
            dict set ticklecharts::opts_theme timelineItemColorE         "#dd6b66"
            dict set ticklecharts::opts_theme timelineCheckColor         "#e43c59"
            dict set ticklecharts::opts_theme timelineCheckBorderColor   "#c23531"
            dict set ticklecharts::opts_theme timelineItemBorderWidth    1
            dict set ticklecharts::opts_theme timelineControlColor       "#eeeeee"
            dict set ticklecharts::opts_theme timelineControlBorderColor "#eeeeee"
            dict set ticklecharts::opts_theme timelineControlBorderWidth 0.5
            dict set ticklecharts::opts_theme timelineLabelColor         "#eeeeee"
            dict set ticklecharts::opts_theme datazoomBackgroundColor    "rgba(47,69,84,0)"
            dict set ticklecharts::opts_theme datazoomDataColor          "rgba(255,255,255,0.3)"
            dict set ticklecharts::opts_theme datazoomFillColor          "rgba(167,183,204,0.4)"
            dict set ticklecharts::opts_theme datazoomHandleColor        "#a7b7cc"
            dict set ticklecharts::opts_theme datazoomHandleWidth        100
            dict set ticklecharts::opts_theme datazoomLabelColor         "#eeeeee"
            dict set ticklecharts::opts_theme axisXgridlineShow          true
            dict set ticklecharts::opts_theme axisYgridlineShow          true
        }
        basic {
            dict set ticklecharts::opts_theme color                      [list {#5470c6 #91cc75 #fac858 #ee6666 #73c0de #3ba272 #fc8452 #9a60b4 #ea7ccc}]
            dict set ticklecharts::opts_theme backgroundColor            "rgba(0,0,0,0)"
            dict set ticklecharts::opts_theme symbol                     "emptyCircle"
            dict set ticklecharts::opts_theme symbolSize                 3
            dict set ticklecharts::opts_theme lineWidth                  2
            dict set ticklecharts::opts_theme lineSmooth                 false
            dict set ticklecharts::opts_theme splitAreaColor             [list {rgba(250,250,250,0.05) rgba(200,200,200,0.02)}]
            dict set ticklecharts::opts_theme axisLineShow               false
            dict set ticklecharts::opts_theme axisLineColor              "nothing"
            dict set ticklecharts::opts_theme axisTickShow               false
            dict set ticklecharts::opts_theme axisLabelShow              true
            dict set ticklecharts::opts_theme axisLabelColor             "nothing"
            dict set ticklecharts::opts_theme splitLineColor             "nothing"
            dict set ticklecharts::opts_theme titleColor                 "nothing"
            dict set ticklecharts::opts_theme subtitleColor              "nothing"
            dict set ticklecharts::opts_theme graphLineWidth             1
            dict set ticklecharts::opts_theme axisXgridlineShow          false
            dict set ticklecharts::opts_theme axisYgridlineShow          true
            dict set ticklecharts::opts_theme timelineLineColor          "#dae1f5"
            dict set ticklecharts::opts_theme timelineLineWidth          1
            dict set ticklecharts::opts_theme timelineItemColor          "#a4b1d7"
            dict set ticklecharts::opts_theme timelineItemColorE         "#a4b1d7"
            dict set ticklecharts::opts_theme timelineCheckColor         "#316bf3"
            dict set ticklecharts::opts_theme timelineCheckBorderColor   "#ffffff"
            dict set ticklecharts::opts_theme timelineItemBorderWidth    1
            dict set ticklecharts::opts_theme timelineControlColor       "#a4b1d7"
            dict set ticklecharts::opts_theme timelineControlBorderColor "#a4b1d7"
            dict set ticklecharts::opts_theme timelineControlBorderWidth 0.5
            dict set ticklecharts::opts_theme timelineLabelColor         "#eeeeee"
            dict set ticklecharts::opts_theme datazoomBackgroundColor    "rgba(47,69,84,0)"
            dict set ticklecharts::opts_theme datazoomFillColor          "rgba(47,69,84,0.25)"
        }
        default {error "theme not specified..."}
    }
    
    set ticklecharts::theme $t
   
}