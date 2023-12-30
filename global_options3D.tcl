# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::globalOptions3D {value} {
    # Global options chart 3D
    #
    # value - Options described below.
    #
    # Returns dict options

    if {[llength $value] % 2} ticklecharts::errorEvenArgs

    setdef options -darkMode         -minversion 5  -validvalue {}            -type bool.t|null               -default [echartsOptsTheme darkMode]
    setdef options -backgroundColor  -minversion 5  -validvalue formatColor   -type str.t|jsfunc|e.color|null -default [echartsOptsTheme backgroundColor]
    setdef options -color            -minversion 5  -validvalue formatColor   -type list.st|null              -default [echartsOptsTheme color]

    set options [merge $options $value]

    return [new edict $options]
}

proc ticklecharts::grid3D {value} {
    # options : https://echarts.apache.org/en/option-gl.html#grid3D
    #
    # value - Options described in proc ticklecharts::grid3D below.
    #
    # Returns dict grid3D options

    # Gets key value.
    set d [ticklecharts::getValue $value "-grid3D"]

    setdef options show                   -minversion 5  -validvalue {}           -type bool|null        -default "nothing"
    setdef options boxWidth               -minversion 5  -validvalue {}           -type num|null         -default 100
    setdef options boxHeight              -minversion 5  -validvalue {}           -type num|null         -default 100
    setdef options boxDepth               -minversion 5  -validvalue {}           -type num|null         -default 100
    setdef options axisLine               -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::axisLine3D $d]
    setdef options axisLabel              -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::axisLabel3D $d]
    setdef options axisTick               -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::axisTick3D $d]
    setdef options splitLine              -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::splitLine3D $d]
    setdef options splitArea              -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::splitArea3D $d]
    setdef options axisPointer            -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::axisPointer3D $d]
    setdef options environment            -minversion 5  -validvalue {}           -type str|jsfunc|null  -default "auto"
    setdef options light                  -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::light3D $d]
    setdef options postEffect             -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::postEffect3D $d]
    setdef options temporalSuperSampling  -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::temporalSuperSampling3D $d]
    setdef options viewControl            -minversion 5  -validvalue {}           -type dict|null        -default [ticklecharts::viewControl3D $d]
    setdef options zlevel                 -minversion 5  -validvalue {}           -type num|null         -default -10
    setdef options left                   -minversion 5  -validvalue formatLeft   -type str|num|null     -default "nothing"
    setdef options top                    -minversion 5  -validvalue formatTop    -type str|num|null     -default "nothing"
    setdef options right                  -minversion 5  -validvalue formatRight  -type str|num|null     -default "nothing"
    setdef options bottom                 -minversion 5  -validvalue formatBottom -type str|num|null     -default "nothing"
    setdef options width                  -minversion 5  -validvalue {}           -type str|num|null     -default "nothing"
    setdef options height                 -minversion 5  -validvalue {}           -type str|num|null     -default "nothing"
    #...

    # remove key(s)...
    set d [dict remove $d axisLine axisTick light postEffect temporalSuperSampling \
                          axisLabel splitLine axisPointer viewControl \
                          splitArea nameTextStyle]

    set options [merge $options $d]

    return [new edict $options]
}

proc ticklecharts::globe {value} {
    # options : https://echarts.apache.org/en/option-gl.html#globe
    #
    # value - Options described in proc ticklecharts::globe below.
    #
    # Returns dict globe options

    # Gets key value.
    set d [ticklecharts::getValue $value "-globe"]

    setdef options show                   -minversion 5  -validvalue {}               -type bool             -default "True"
    setdef options zlevel                 -minversion 5  -validvalue {}               -type num|null         -default -10
    setdef options left                   -minversion 5  -validvalue formatLeft       -type str|num|null     -default "nothing"
    setdef options top                    -minversion 5  -validvalue formatTop        -type str|num|null     -default "nothing"
    setdef options right                  -minversion 5  -validvalue formatRight      -type str|num|null     -default "nothing"
    setdef options bottom                 -minversion 5  -validvalue formatBottom     -type str|num|null     -default "nothing"
    setdef options width                  -minversion 5  -validvalue {}               -type str|num|null     -default "nothing"
    setdef options height                 -minversion 5  -validvalue {}               -type str|num|null     -default "nothing"
    setdef options globeRadius            -minversion 5  -validvalue {}               -type num|null         -default 100
    setdef options globeOuterRadius       -minversion 5  -validvalue {}               -type num|null         -default 150
    setdef options environment            -minversion 5  -validvalue {}               -type str|jsfunc|null  -default "auto"
    setdef options baseTexture            -minversion 5  -validvalue {}               -type str|jsfunc|null  -default "nothing"
    setdef options heightTexture          -minversion 5  -validvalue {}               -type str|jsfunc|null  -default "nothing"
    setdef options displacementTexture    -minversion 5  -validvalue {}               -type str|jsfunc|null  -default "nothing"
    setdef options displacementScale      -minversion 5  -validvalue {}               -type num|null         -default 0
    setdef options displacementQuality    -minversion 5  -validvalue formatDQuality   -type str              -default "medium"
    setdef options shading                -minversion 5  -validvalue formatShading3D  -type str|null         -default "nothing"
    setdef options realisticMaterial      -minversion 5  -validvalue {}               -type dict|null        -default [ticklecharts::realisticMaterial3D $d]
    setdef options lambertMaterial        -minversion 5  -validvalue {}               -type dict|null        -default [ticklecharts::lambertMaterial3D $d]
    setdef options colorMaterial          -minversion 5  -validvalue {}               -type dict|null        -default [ticklecharts::colorMaterial3D $d]
    setdef options light                  -minversion 5  -validvalue {}               -type dict|null        -default [ticklecharts::light3D $d]
    setdef options atmosphere             -minversion 5  -validvalue {}               -type dict|null        -default [ticklecharts::atmosphere3D $d]
    setdef options postEffect             -minversion 5  -validvalue {}               -type dict|null        -default [ticklecharts::postEffect3D $d]
    setdef options temporalSuperSampling  -minversion 5  -validvalue {}               -type dict|null        -default [ticklecharts::temporalSuperSampling3D $d]
    setdef options viewControl            -minversion 5  -validvalue {}               -type dict|null        -default [ticklecharts::viewControl3D $d]
    setdef options layers                 -minversion 5  -validvalue {}               -type list.o|null      -default [ticklecharts::layers3D $d]
    #...

    # remove key(s)...
    set d [dict remove $d realisticMaterial lambertMaterial colorMaterial light \
                          atmosphere postEffect temporalSuperSampling viewControl layers]

    set options [merge $options $d]

    return [new edict $options]
}