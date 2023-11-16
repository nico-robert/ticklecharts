lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v3.0 : Set new 'Add' method for chart series + uses substitution for formatter property.
#        Note : map list formatter + Add***Series will be deleted in the next major release, 
#               in favor of this writing. (see formatter property + 'Add' method below)
# v4.0 : Update of the dataset class example with key property without the minus sign at the beginning.
#        Note : Both are accepted, with or without.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}


set source {
    {850 740 900 1070 930 850 950 980 980 880 1000 980 930 650 760 810 1000 1000 960 960}
    {960 940 960 940 880 800 850 880 900 840 830 790 810 880 880 830 800 790 760 800}
    {880 880 880 860 720 720 620 860 970 950 880 910 850 870 840 840 850 840 840 840}
    {890 810 810 820 800 770 760 740 750 760 910 920 890 860 880 720 840 850 850 780}
    {890 840 780 810 760 810 790 810 820 850 870 870 810 740 810 940 950 800 810 870}
}

set dset [ticklecharts::dataset new [list \
                                        [list source $source] \
                                        [list transform {{type "boxplot" config {itemNameFormatter {"expr {value}"}}}}] \
                                        [list fromDatasetIndex 1 fromTransformResult 1]
                                    ] \
]

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {trigger "item" axisPointer {type "shadow"}} \
                  -grid {left 10% right 10% bottom 15%} \
                  -dataset $dset \
                  -title {text "Michelson-Morley Experiment" left "center"}


$chart Xaxis -type "category" \
             -boundaryGap "True" \
             -nameGap 30 \
             -splitArea {show "False"} \
             -splitLine {show "False"}

$chart Yaxis -type "value" \
             -name "km/s minus 299,000" \
             -splitArea {show "True"}

$chart Add "boxPlotSeries" -name "boxplot" \
                           -datasetIndex 1

$chart Add "scatterSeries" -name "outlier" \
                           -datasetIndex 2

$chart Add "graphic" -elements {
                                {
                                type group left 10% top 90%
                                children {
                                            {
                                                type rect z 100 left center top middle
                                                shape {width 220 height 50}
                                                style {fill #fff stroke #555 lineWidth 1}
                                            }
                                            {
                                                type text z 100 left center top middle
                                                style {
                                                    fill #333
                                                    width 130
                                                    overflow "break"
                                                    text "upper: Q3 + 1.5 * IQR lower: Q1 - 1.5 * IQR"
                                                    font "14px Microsoft YaHei"
                                                    }
                                            }
                                        }
                                    }
                                }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -width 1500px -height 530px