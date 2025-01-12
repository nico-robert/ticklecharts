lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Update example with the new 'Add' method for chart series.
# v3.0 : Load exact 'tls' package version for Tcl8.6 according to my env.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

try {
    # https://wiki.tcl-lang.org/page/HTTPS
    #
    package require http 2
    if {[catch {package require -exact tls 1.7.22}]} {package require tls 1.7}
    package require json

    http::register https 443 [list ::tls::socket -autoservername true]
    set token [http::geturl https://raw.githubusercontent.com/apache/echarts-examples/gh-pages/public/data/asset/data/disk.tree.json]

    set htmldata [::http::data $token]
    set datajson [json::json2dict $htmldata]

    # js var
    set js [ticklecharts::jsfunc new {
            const formatUtil = echarts.format;
        } -start]

    # tooltip formatter
    set tooltip [ticklecharts::jsfunc new {
        function (info) {
          var value = info.value;
          var treePathInfo = info.treePathInfo;
          var treePath = [];
          for (var i = 1; i < treePathInfo.length; i++) {
            treePath.push(treePathInfo[i].name);
          }
          return [
            '<div class="tooltip-title">' +
              formatUtil.encodeHTML(treePath.join('/')) +
              '</div>',
            'Disk Usage: ' + formatUtil.addCommas(value) + ' KB'
          ].join('');
        }
    }]

    set chart [ticklecharts::chart new]

    $chart SetOptions -title {text "Disk Usage" left "center"} \
                      -tooltip [list formatter $tooltip]
     
    $chart Add "treeMapSeries" -name "Disk Usage" \
                               -visibleMin 300 \
                               -label {show "True" formatter {"{b}"}} \
                               -itemStyle {borderColor "#fff"} \
                               -data $datajson \
                               -levels [list \
                                   {itemStyle {borderWidth 0 gapWidth 5}} \
                                   {itemStyle {gapWidth 1}} \
                                   [list colorSaturation [list {0.35 0.5}] itemStyle {gapWidth 1 borderColorSaturation 0.6}] \
                               ]

    set fbasename [file rootname [file tail [info script]]]
    set dirname [file dirname [info script]]

    $chart Render -outfile [file join $dirname $fbasename.html] \
                  -title $fbasename \
                  -width 1500px \
                  -height 900px \
                  -script $js

} on error {result options} {
    puts stderr "[info script] : $result"
}