lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Rename '-datapieitem' by '-dataPieItem' +
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Update example with the new 'Add' method for chart series.
# v4.0 : Replaces '-dataPieItem' by '-dataItem' (both properties are available).
#        Replaces 'richitem' by 'richItem' (both properties are available).

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set pie [ticklecharts::chart new]

set tooltipjs   [ticklecharts::jsfunc new {"{a} <br/>{b}: {c} ({d}%)"}]
set formatterjs [ticklecharts::jsfunc new {"{a|{a}}{abg|}\n{hr|}\n  {b|{b}：}{c}  {per|{d}%}  "}]


$pie SetOptions -tooltip [list trigger "item" formatter $tooltipjs]

$pie Add "pieSeries" -name "Access From" -selectedMode "single" -radius [list {0 30%}] \
                     -label {position "inner" fontSize 14} -labelLine {show false} \
                     -dataItem {
                                {value 1548 name "Search Engine"}
                                {value 775 name "Direct"}
                                {value 679 name "Marketing" selected "True"}
                      }

$pie Add "pieSeries" -name "Access From" -selectedMode "single" -radius [list {45% 60%}] \
                     -labelLine {show "True" length 30} \
                     -label [list lineHeight "null" formatter $formatterjs backgroundColor "#F6F8FC" borderColor "#8C8D8E" \
                               borderWidth 1 borderRadius 4 \
                               richItem [list \
                                   a   {color "#6E7079" lineHeight 22 align "center"} \
                                   hr  {borderColor "#8C8D8E" width "100%" borderWidth 1 height 0} \
                                   b   {color "#4C5058" fontSize 14 fontWeight "bold" lineHeight 30} \
                                   per [list color "#fff" backgroundColor "#4C5058" padding [list {3 4}] borderRadius 4] \
                               ]
                     ] \
                     -dataItem {
                                   {value 1048 name "Baidu"}
                                   {value 335 name "Direct"}
                                   {value 310 name "Email"}
                                   {value 251 name "Google"}
                                   {value 234 name "Union Ads"}
                                   {value 147 name "Bing"}
                                   {value 135 name "Video Ads"}
                                   {value 102 name "Others"}
                         }

set fbasename [file rootname [file tail [info script]]]
set dirname   [file dirname [info script]]

$pie Render -outfile [file join $dirname $fbasename.html] -title $fbasename -width "1586px" -height "766px"