lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.
# v3.0 : Replaces 'richitem' by 'richItem' (both properties are available).
# v4.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set household_america_2012 113616229

proc cloneNodeInfo {node} {
    set newNode [dict create]

    dict set newNode name  [dict get $node name]
    dict set newNode id    [dict get $node id]
    dict set newNode value [dict get $node value]

    return $newNode
}

proc buildData {mode originList} {
    global household_america_2012

    set out {}

    foreach node $originList {
        set newNode [cloneNodeInfo $node]
        set value [dict get $newNode value]
        
        # '_' is considered as 'null' value
        set value0 [string map {null _} [lindex $value 0]]
        set value1 [string map {null _} [lindex $value 1]]
        set value2 [string map {null _} [lindex $value 2]]
        set value3 [expr {$value0 / double($household_america_2012)}]

        if {$mode == 1} {
            set tmp [string map {null _} [lindex $value 1]]
            set value1 [string map {null _} [lindex $value 0]]
            set value0 $tmp
        }

        dict set newNode value [list [list $value0 $value1 $value2 $value3]]

        if {[dict exists $node children]} {
            dict set newNode children [buildData $mode [dict get $node children]]
        }

        lappend out $newNode
    }

    return $out
}

proc getLevelOption {mode} {

    if {$mode == 2} {
        set color      [list {#c23531 #314656 #61a0a8 #dd8668 #91c7ae #6e7074 #61a0a8 #bda29a #44525d #c4ccd3}]
        set colorAlpha [list {0.5 1}]
    } else {
        set color      "null"
        set colorAlpha "null"
    }

    return [list \
                [list color $color colorMappingBy "id" itemStyle {borderWidth 3 gapWidth 3}] \
                [list colorAlpha $colorAlpha itemStyle {gapWidth 1}] \
            ]
}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/obama_budget_proposal_2012.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]
    set modes {"2012Budget" "2011Budget" "Growth"}

    set chart [ticklecharts::chart new]

    # -tooltip in this exmample is a callback function... not supported.
    $chart SetOptions -title {text "How 3.7 dollars Trillion is Spent" subtext "Obama’s 2012 Budget Proposal" left "center" top 5} \
                      -legend [list data [list $modes] selectedMode "single" top 55 itemGap 5 borderRadius 5]

    set arr1 {
        let arr = [
          '{name|' + params.name + '}',
          '{hr|}',
          '{budget|$ ' +
            echarts.format.addCommas(params.value[0]) +
            '} {label|budget}'
        ];
    }

    set arr {
        let arr = [
          '{name|' + params.name + '}',
          '{hr|}',
          '{budget|$ ' +
            echarts.format.addCommas(params.value[0]) +
            '} {label|budget}',
          '{household|$ ' +
              echarts.format.addCommas(+params.value[3].toFixed(4) * 1000) +
              '} {label|per household}'
        ];
    }

    set idx 0      
    foreach mode $modes {
        if {$idx != 1} {
            set js [ticklecharts::jsfunc new [subst {
                                function (params) {
                                    [set arr]
                                    // replace 'end of line character' by <n?>
                                    return arr.join('<n?>');
                                },
                        }]]
        } else {
            set js [ticklecharts::jsfunc new [subst {
                                function (params) {
                                    [set arr1]
                                    // replace 'end of line character' by <n?>
                                    return arr.join('<n?>');
                                },
                        }]]
        }

        $chart Add "treeMapSeries" -label [list \
                                        position "insideTopLeft" \
                                        formatter $js \
                                        richItem [list \
                                                budget {fontSize 22 lineHeight 30 color "rgb(255,255,0)"} \
                                                household {fontSize 14 color "#fff"} \
                                                label [list fontSize 9 backgroundColor rgba(0,0,0,0.3) color "#fff" borderRadius 2 padding [list {2 4}] lineHeight 25 align right] \
                                                name {fontSize 12 color "#fff"} \
                                                hr {width "100%" borderColor "rgba(255,255,255,0.2)" borderWidth 0.5 height 0 lineHeight 10} \
                                        ] \
                                    ] \
                                    -itemStyle {borderColor black} \
                                    -levels [getLevelOption $idx] \
                                    -name $mode \
                                    -top 80 \
                                    -visualDimension [expr {$idx == 2 ? 2 : "null"}] \
                                    -data [buildData $idx $datajson]

        incr idx
    }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
                  -title $fbasename \
                  -width 1800px \
                  -height 1100px 

} on error {result options} {
    puts stderr "[info script] : $result"
}