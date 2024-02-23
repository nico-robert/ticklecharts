# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::bar3DSeries {index chart value} {
    # options : https://echarts.apache.org/en/option-gl.html#series-bar3D
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::bar3DSeries below.
    #
    # Returns dict bar3DSeries options
    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -type                    -minversion 5       -validvalue formatTypeBar3D      -type str             -trace no   -default "bar3D"
    setdef options -name                    -minversion 5       -validvalue {}                   -type str             -trace no   -default "bar3DSeries_${index}"
    setdef options -coordinateSystem        -minversion 5       -validvalue formatCSYS           -type str             -trace no   -default "cartesian3D"    
    setdef options -grid3DIndex             -minversion 5       -validvalue {}                   -type num|null        -trace no   -default "nothing"
    setdef options -geo3DIndex              -minversion 5       -validvalue {}                   -type num|null        -trace no   -default "nothing"
    setdef options -globeIndex              -minversion 5       -validvalue {}                   -type num|null        -trace no   -default "nothing"
    setdef options -barSize                 -minversion 5       -validvalue {}                   -type num|null        -trace no   -default "nothing"
    setdef options -bevelSize               -minversion 5       -validvalue formatBevelSize      -type num|null        -trace no   -default "nothing"
    setdef options -bevelSmoothness         -minversion 5       -validvalue {}                   -type num|null        -trace no   -default "nothing"
    setdef options -stack                   -minversion 5       -validvalue {}                   -type str|null        -trace yes  -default "nothing"
    setdef options -stackStrategy           -minversion "5.3.3" -validvalue formatStackStrategy  -type str|null        -trace yes  -default "nothing"
    setdef options -minHeight               -minversion 5       -validvalue {}                   -type num|null        -trace no   -default "nothing"
    setdef options -itemStyle               -minversion 5       -validvalue {}                   -type dict|null       -trace no   -default [ticklecharts::itemStyle3D $value]
    setdef options -label                   -minversion 5       -validvalue {}                   -type dict|null       -trace no   -default [ticklecharts::label3D $value]
    setdef options -emphasis                -minversion 5       -validvalue {}                   -type dict|null       -trace no   -default [ticklecharts::emphasis3D $value]
    setdef options -data                    -minversion 5       -validvalue {}                   -type list.n          -trace no   -default {}
    setdef options -shading                 -minversion 5       -validvalue formatShading3D      -type str|null        -trace no   -default "nothing"
    setdef options -realisticMaterial       -minversion 5       -validvalue {}                   -type dict|null       -trace no   -default [ticklecharts::realisticMaterial3D $value]
    setdef options -lambertMaterial         -minversion 5       -validvalue {}                   -type dict|null       -trace no   -default [ticklecharts::lambertMaterial3D $value]
    setdef options -colorMaterial           -minversion 5       -validvalue {}                   -type dict|null       -trace no   -default [ticklecharts::colorMaterial3D $value]
    setdef options -zlevel                  -minversion 5       -validvalue {}                   -type num             -trace no   -default -10
    setdef options -silent                  -minversion 5       -validvalue {}                   -type bool            -trace no   -default "False"
    setdef options -animation               -minversion 5       -validvalue {}                   -type bool|null       -trace no   -default "True"
    setdef options -animationDurationUpdate -minversion 5       -validvalue {}                   -type num|jsfunc|null -trace no   -default 500
    setdef options -animationEasingUpdate   -minversion 5       -validvalue formatAEasing        -type str|null        -trace no   -default "cubicOut"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    # Both properties item are accepted.
    #   -dataBar3DItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataBar3DItem -dataItem} $value]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value $itemKey]} {
            error "'chart3D' Class cannot contains '-data', '-dataBar3DItem' or '-dataItem'\
                    when a class dataset is defined."
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class... if need
        # setdef options -dimensions    -minversion 5  -validvalue {}                 -type list.d|null      -default "nothing"
        setdef options  -dataGroupId    -minversion 5  -validvalue {}                 -type str|null         -default "nothing"
        setdef options  -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options  -encode         -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options  -datasetIndex   -minversion 5  -validvalue {}                 -type num|null         -default "nothing"

    } elseif {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart3D' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::bar3DItem $value $itemKey]
    } else {
        if {![dict exists $value -data]} {
            error "Property '-data' not defined for '[ticklecharts::getLevelProperties [info level]]'"
        }
    }

    # remove key(s)...
    set value [dict remove $value -itemStyle -label -emphasis \
                                  -realisticMaterial -lambertMaterial \
                                  -lambertMaterial $itemKey -encode]
                                
    set options [merge $options $value]

    return $options
}

proc ticklecharts::line3DSeries {index chart value} {
    # options : https://echarts.apache.org/en/option-gl.html#series-line3D
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::line3DSeries below.
    #
    # Returns dict line3DSeries options
    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -type                    -minversion 5  -validvalue formatTypeL3D  -type str             -default "line3D"
    setdef options -name                    -minversion 5  -validvalue {}             -type str             -default "line3Dseries_${index}"
    setdef options -coordinateSystem        -minversion 5  -validvalue formatCSYS     -type str             -default "cartesian3D"
    setdef options -grid3DIndex             -minversion 5  -validvalue {}             -type num|null        -default "nothing"
    setdef options -lineStyle               -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::lineStyle3D $value]
    setdef options -data                    -minversion 5  -validvalue {}             -type list.n          -default {}
    setdef options -zlevel                  -minversion 5  -validvalue {}             -type num             -default -10
    setdef options -silent                  -minversion 5  -validvalue {}             -type bool            -default "False"
    setdef options -animation               -minversion 5  -validvalue {}             -type bool|null       -default "nothing"
    setdef options -animationDurationUpdate -minversion 5  -validvalue {}             -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5  -validvalue formatAEasing  -type str|null        -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    # Both properties item are accepted.
    #   -dataLine3DItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataLine3DItem -dataItem} $value]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value $itemKey]} {
            error "'chart3D' Class cannot contains '-data', '-dataLine3DItem' or '-dataItem'\
                    when a class dataset is defined."
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class...
        # setdef options -dimensions     -minversion 5  -validvalue {}                 -type list.d|null      -default "nothing"
        setdef options   -dataGroupId    -minversion 5  -validvalue {}                 -type str|null         -default "nothing"
        setdef options   -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options   -encode         -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -minversion 5  -validvalue {}                 -type num|null         -default "nothing"

    } elseif {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart3D' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::line3DItem $value $itemKey]
    } else {
        if {![dict exists $value -data]} {
            error "Property '-data' not defined for '[ticklecharts::getLevelProperties [info level]]'"
        }
    }

    # remove key(s)...
    set value [dict remove $value -lineStyle -encode $itemKey]
                                
    set options [merge $options $value]

    return $options
}

proc ticklecharts::surfaceSeries {index value} {
    # options : https://echarts.apache.org/en/option-gl.html#series-line3D
    #
    # index - index series.
    # value - Options described in proc ticklecharts::surfaceSeries below.
    #
    # Returns dict surfaceSeries options
    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -type                    -minversion 5  -validvalue formatTypeSurf   -type str             -default "surface"
    setdef options -name                    -minversion 5  -validvalue {}               -type str             -default "surfaceseries_${index}"
    setdef options -coordinateSystem        -minversion 5  -validvalue formatCSYS       -type str             -default "cartesian3D"
    setdef options -grid3DIndex             -minversion 5  -validvalue {}               -type num|null        -default "nothing"
    setdef options -parametric              -minversion 5  -validvalue {}               -type bool|null       -default "nothing"
    setdef options -wireframe               -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::wireframe3D $value]
    setdef options -equation                -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::equation3D $value]
    setdef options -parametricEquation      -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::parametricEquation3D $value]
    setdef options -itemStyle               -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::itemStyle3D $value]
    setdef options -data                    -minversion 5  -validvalue {}               -type list.n|null     -default "nothing"
    setdef options -shading                 -minversion 5  -validvalue formatShading3D  -type str|null        -default "nothing"
    setdef options -realisticMaterial       -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::realisticMaterial3D $value]
    setdef options -lambertMaterial         -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::lambertMaterial3D $value]
    setdef options -colorMaterial           -minversion 5  -validvalue {}               -type dict|null       -default [ticklecharts::colorMaterial3D $value]    
    setdef options -zlevel                  -minversion 5  -validvalue {}               -type num             -default -10
    setdef options -silent                  -minversion 5  -validvalue {}               -type bool            -default "False"
    setdef options -animation               -minversion 5  -validvalue {}               -type bool|null       -default "nothing"
    setdef options -animationDurationUpdate -minversion 5  -validvalue {}               -type num|jsfunc|null -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5  -validvalue formatAEasing    -type str|null        -default "nothing"

    # Both properties item are accepted.
    #   -dataSurfaceItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataSurfaceItem -dataItem} $value]

    if {[dict exists $value $itemKey]} {
        foreach k {-data -equation -parametricEquation} {
            if {[dict exists $value $k]} {
                error "'chart3D' args cannot contains '$k' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
            }
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::surfaceItem $value $itemKey]
    }

    if {[dict exists $value -equation]} {
        foreach k [list -data $itemKey -parametricEquation] {
            if {[dict exists $value $k]} {
                error "'chart3D' args cannot contains '$k' and '-equation'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
            }
        }
    }

    if {[dict exists $value -parametricEquation]} {
        foreach k [list -data $itemKey -equation] {
            if {[dict exists $value $k]} {
                error "'chart3D' args cannot contains '$k' and '-parametricEquation'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
            }
        }
    }

    # remove key(s)...
    set value [dict remove $value -wireframe -equation -parametricEquation -itemStyle \
                                  -realisticMaterial -lambertMaterial -colorMaterial $itemKey]
                                
    set options [merge $options $value]

    return $options
}

proc ticklecharts::scatter3DSeries {index chart value} {
    # options : https://echarts.apache.org/en/option-gl.html#series-scatter3D
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::scatter3DSeries below.
    #
    # Returns dict scatter3DSeries options
    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -type                    -minversion 5  -validvalue formatTypeSc3D    -type str               -default "scatter3D"
    setdef options -name                    -minversion 5  -validvalue {}                -type str               -default "scatter3Dseries_${index}"
    setdef options -coordinateSystem        -minversion 5  -validvalue formatCSYS        -type str               -default "cartesian3D"
    setdef options -grid3DIndex             -minversion 5  -validvalue {}                -type num|null          -default "nothing"
    setdef options -geo3DIndex              -minversion 5  -validvalue {}                -type num|null          -default "nothing"
    setdef options -globeIndex              -minversion 5  -validvalue {}                -type num|null          -default "nothing"
    setdef options -symbol                  -minversion 5  -validvalue formatItemSymbol  -type str|jsfunc        -default "circle"
    setdef options -symbolSize              -minversion 5  -validvalue {}                -type num|jsfunc|list.n -default 10
    setdef options -itemStyle               -minversion 5  -validvalue {}                -type dict|null         -default [ticklecharts::itemStyle3D $value]
    setdef options -label                   -minversion 5  -validvalue {}                -type dict|null         -default [ticklecharts::label3D $value]
    setdef options -emphasis                -minversion 5  -validvalue {}                -type dict|null         -default [ticklecharts::emphasis3D $value]
    setdef options -data                    -minversion 5  -validvalue {}                -type list.n            -default {}
    setdef options -blendMode               -minversion 5  -validvalue formatBlendM      -type str|null          -default "nothing"
    setdef options -zlevel                  -minversion 5  -validvalue {}                -type num               -default -10
    setdef options -silent                  -minversion 5  -validvalue {}                -type bool              -default "False"
    setdef options -animation               -minversion 5  -validvalue {}                -type bool|null         -default "nothing"
    setdef options -animationDurationUpdate -minversion 5  -validvalue {}                -type num|jsfunc|null   -default "nothing"
    setdef options -animationEasingUpdate   -minversion 5  -validvalue formatAEasing     -type str|null          -default "nothing"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    # Both properties item are accepted.
    #   -dataScatter3DItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataScatter3DItem -dataItem} $value]

    if {$dataset ne ""} {
        if {[dict exists $value -data] || [dict exists $value $itemKey]} {
            error "'chart3D' Class cannot contains '-data', '-dataScatter3DItem' or '-dataItem'\
                    when a class dataset is defined."
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class...
        # setdef options -dimensions     -minversion 5  -validvalue {}                 -type list.d|null      -default "nothing"
        setdef options   -dataGroupId    -minversion 5  -validvalue {}                 -type str|null         -default "nothing"
        setdef options   -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options   -encode         -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -minversion 5  -validvalue {}                 -type num|null         -default "nothing"

    } elseif {[dict exists $value $itemKey]} {
        if {[dict exists $value -data]} {
            error "'chart3D' object cannot contains '-data' and '$itemKey'... for\
                   '[ticklecharts::getLevelProperties [info level]]'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::scatter3DItem $value $itemKey]
    } else {
        if {![dict exists $value -data]} {
            error "Property '-data' not defined for '[ticklecharts::getLevelProperties [info level]]'"
        }
    }

    # remove key(s)...
    set value [dict remove $value -encode -itemStyle -label -emphasis $itemKey]
                                
    set options [merge $options $value]

    return $options
}

proc ticklecharts::lines3DSeries {index chart value} {
    # options : https://echarts.apache.org/en/option-gl.html#series-lines3D
    #
    # index - index series.
    # chart - self.
    # value - Options described in proc ticklecharts::lines3DSeries below.
    #
    # Returns dict lines3DSeries options
    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -type                    -minversion 5  -validvalue formatTypeLs3D -type str             -default "lines3D"
    setdef options -name                    -minversion 5  -validvalue {}             -type str             -default "lines3Dseries_${index}"
    setdef options -coordinateSystem        -minversion 5  -validvalue formatCSYS     -type str             -default "geo3D"
    setdef options -geo3DIndex              -minversion 5  -validvalue {}             -type num|null        -default "nothing"
    setdef options -globeIndex              -minversion 5  -validvalue {}             -type num|null        -default "nothing"
    setdef options -polyline                -minversion 5  -validvalue {}             -type bool            -default "False"
    setdef options -blendMode               -minversion 5  -validvalue formatBlendM   -type str|null        -default "nothing"
    setdef options -lineStyle               -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::lineStyle3D $value]
    setdef options -effect                  -minversion 5  -validvalue {}             -type dict|null       -default [ticklecharts::effect3D $value]
    setdef options -data                    -minversion 5  -validvalue {}             -type list.n          -default {}
    setdef options -zlevel                  -minversion 5  -validvalue {}             -type num             -default -10
    setdef options -silent                  -minversion 5  -validvalue {}             -type bool            -default "False"

    # check if chart includes a dataset class
    set dataset [$chart dataset]

    # Both properties item are accepted.
    #   -dataLines3DItem
    #   -dataItem
    set itemKey [ticklecharts::itemKey {-dataLines3DItem -dataItem} $value]

    if {$dataset ne ""} {
        if {[dict exists $value $itemKey]} {
            error "'chart3D' Class cannot contains '$itemKey'\
                    when a class dataset is defined."
        }

        set options [dict remove $options -data]
        # set dimensions in dataset class...
        # setdef options -dimensions     -minversion 5  -validvalue {}                 -type list.d|null      -default "nothing"
        setdef options   -dataGroupId    -minversion 5  -validvalue {}                 -type str|null         -default "nothing"
        setdef options   -seriesLayoutBy -minversion 5  -validvalue formatSeriesLayout -type str|null         -default "nothing"
        setdef options   -encode         -minversion 5  -validvalue {}                 -type dict|null        -default [ticklecharts::encode $chart $value]
        setdef options   -datasetIndex   -minversion 5  -validvalue {}                 -type num|null         -default "nothing"

    } else {
        if {![dict exists $value $itemKey]} {
            error "'chart3D' object should contain '-dataLines3DItem' or '-dataItem'"
        }
        setdef options -data -minversion 5  -validvalue {} -type list.o -default [ticklecharts::lines3DItem $value $itemKey]
    }

    # remove key(s)...
    set value [dict remove $value -lineStyle -encode -effect $itemKey]
                                
    set options [merge $options $value]

    return $options
}