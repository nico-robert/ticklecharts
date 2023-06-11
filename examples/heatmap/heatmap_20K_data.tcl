lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : delete -animation in AddHeatmapSeries method it's not a key option
#        + rename 'render' to 'Render' (Note : The first letter in capital letter)
# v3.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

# This isn't a very good seeding function, but it works ok. It supports 2^16
# different seed values. Write something better if you need more seeds.
proc seed {seed} {
    if {$seed > 0 && $seed < 1} {
        set seed [expr {$seed * 65536}]
    }

    set seed [expr {round($seed)}]
    if {$seed < 256} {
        set seed [expr {$seed | $seed << 8}]
    }

    for {set i 0} {$i < 256} {incr i} {
        if {$i & 1} {
            set v [expr {[lindex $::p $i] ^ ($seed & 255)}]
        } else {
            set v [expr {[lindex $::p $i] ^ (($seed >> 8) & 255)}]
        }

        set ::perm($i) $v
        set ::perm([expr {$i + 256}]) $v
        set ::gradP($i) [lindex $::grad3 [expr {$v % 12}]]
        set ::gradP([expr {$i + 256}]) $::gradP($i)

    }
}
# Perlin noise stuff
proc fade {t} {
    return [expr {$t * $t * $t * ($t * ($t * 6 - 15) + 10)}]
}

proc lerp {a b t} {
    return [expr {(1 - $t) * $a + $t * $b}]
}

# 2D Perlin Noise
proc perlin2 {x y} {
    set X [expr {int($x)}]
    set Y [expr {int($y)}]

    set x [expr {$x - $X}]
    set y [expr {$y - $Y}]

    set X [expr {$X & 255}]
    set Y [expr {$Y & 255}]

    set n00 [$::gradP([expr {$X + $::perm($Y)}]) dot2 $x $y]
    set n01 [$::gradP([expr {$X + $::perm([expr {$Y + 1}])}]) dot2 $x [expr {$y - 1}]]
    set n10 [$::gradP([expr {$X + 1 + $::perm($Y)}]) dot2 [expr {$x - 1}] $y]
    set n11 [$::gradP([expr {$X + 1 + $::perm([expr {$Y + 1}])}]) dot2 [expr {$x - 1}] [expr {$y - 1}]]


    set u [fade $x]

    return [lerp [lerp $n00 $n10 $u] [lerp $n01 $n11 $u] [fade $y]]
}

proc generateData {} {

    set lx 200
    set ly 100

    for {set i 0} {$i <= $lx} {incr i} {
        for {set j 0} {$j <= $ly} {incr j} {
            set var1 [expr {$i / 40.}]
            set var2 [expr {$j / 20.}]
            lappend data [list $i $j [expr {[perlin2 $var1 $var2] + 0.5}]]
        }
        lappend xdata $i
    }

    for {set j 0} {$j < $ly} {incr j} {
        lappend ydata $j
    }

    return [list $data $xdata $ydata]
    
}

#  perlin noise helper from https://github.com/josephg/noisejs
# problem source all.tcl
catch {
    oo::class create Grad {
        variable _x _y _z
        constructor {x y z} {
            set _x $x
            set _y $y
            set _z $z
        }
    }

    oo::define Grad {
        method dot2 {x y} {
            return [expr {($_x * $x) + ($_y * $y)}]
        }
        method dot3 {x y z} {
            return [expr {($_x * $x) + ($_y * $y) + ($_z * $z)}]
        }
    }
}

set grad3 [list \
  [Grad new 1 1 0] \
  [Grad new -1 1 0] \
  [Grad new 1 -1 0] \
  [Grad new -1 -1 0] \
  [Grad new 1 0 1] \
  [Grad new -1 0 1] \
  [Grad new 1 0 -1] \
  [Grad new -1 0 -1] \
  [Grad new 0 1 1] \
  [Grad new 0 -1 1] \
  [Grad new 0 1 -1] \
  [Grad new 0 -1 -1] \
]

set p {
  151 160 137 91 90 15 131 13 201 95 96 53 194 233 7 225 140
  36 103 30 69 142 8 99 37 240 21 10 23 190 6 148 247 120
  234 75 0 26 197 62 94 252 219 203 117 35 11 32 57 177 33
  88 237 149 56 87 174 20 125 136 171 168 68 175 74 165 71
  134 139 48 27 166 77 146 158 231 83 111 229 122 60 211 133
  230 220 105 92 41 55 46 245 40 244 102 143 54 65 25 63 161
  1 216 80 73 209 76 132 187 208 89 18 169 200 196 135 130
  116 188 159 86 164 100 109 198 173 186 3 64 52 217 226 250
  124 123 5 202 38 147 118 126 255 82 85 212 207 206 59 227
  47 16 58 17 182 189 28 42 223 183 170 213 119 248 152 2 44
  154 163 70 221 153 101 155 167 43 172 9 129 22 39 253 19 98
  108 110 79 113 224 232 178 185 112 104 218 246 97 228 251 34
  242 193 238 210 144 12 191 179 162 241 81 51 145 235 249 14
  239 107 49 192 214 31 181 199 106 157 184 84 204 176 115 121
  50 45 127 4 150 254 138 236 205 93 222 114 67 29 24 72 243
  141 128 195 78 66 215 61 156 180
}

# init variable
seed [expr {rand()}]

# compute
lassign [generateData] data xdata ydata

set chart [ticklecharts::chart new]

$chart SetOptions -tooltip {position top} \
                  -visualMap [list type "continuous" calculable true \
                                   realtime false \
                                   min 0 max 1 inRange [list color [list {#313695 #4575b4 #74add1 #abd9e9
                                                                          #e0f3f8 #ffffbf
                                                                          #fee090 #fdae61
                                                                          #f46d43 #f46d43
                                                                          #a50026
                                                                    }]]]
               
$chart Xaxis -type "category" -data [list $xdata]
$chart Yaxis -type "category" -data [list $ydata] -boundaryGap "True"

# delete '-animation false' in AddHeatmapSeries method
$chart Add "heatmapSeries" -name "Gaussian" \
                           -data $data \
                           -progressive 1000 \
                           -emphasis {itemStyle {borderColor #333 borderWidth 1}}

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -jschartvar "mychart" \
              -divid "id_chart" \
              -width 1500px \
              -height 1000px