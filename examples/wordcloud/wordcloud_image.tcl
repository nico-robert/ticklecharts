lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : bump to 'v2.1.0' echarts-wordcloud
# v3.0 : Delete 'echarts-wordcloud.js' with jsfunc. It is inserted automatically when writing the html file.
# v4.0 : Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v5.0 : set jsvar in 'Render' method + fix bug in javascript function ($jschartvar variable was not initialized) 
# v6.0 : Update example with the new 'Add' method for chart series.

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}

set chart [ticklecharts::chart new]

set js [ticklecharts::jsfunc new {
                function () {
                    return 'rgb(' + [
                        Math.round(Math.random() * 200) + 50,
                        Math.round(Math.random() * 50),
                        Math.round(Math.random() * 50) + 50
                    ].join(',') + ')';
                }
          }]

set maskImage [ticklecharts::jsfunc new {maskImage}]

set jschartvar chart_wordCloud
set jsvar option

set var [ticklecharts::jsfunc new [subst -nocommands {
                    var maskImage = new Image();
                    maskImage.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAVAAAAEdCAYAAABaLj9rAAAACXBIWXMAABcSAAAXEgFnn9JSAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJ\
                                     bWFnZVJlYWR5ccllPAAAEdpJREFUeNrs3ctxG8e6B/AxynvxREA6AvJWeU84AJfojbeCIjAdgeEITEUgeOvNpcoBGNy7ylQEl4zgihHoTJsfJIqiSDzm0T3z+1Xh0K8\
                                     jAj2Y/3z9mJ6v3r9/X1GWP779fq/+cRR/O42fB/FK0r8/3OFX3NSvyzt/v4yfV6vXj3//eeVIMHZfCdCsg/IoQvEoXikYjzN6i9cRqMs7wbp05BCg9BGWd1/HBX+ct3e\
                                     C9VKoIkBpIzCnd17PBv6RL2JYIIXpsg7Vd74FCFDWDcyDCMqTkQTmOoGawvS8DtNL3xAEKA9VmbMIzEMt8kXXd8L0XHMgQIVmqjT3tcjG0gqAc2GKAB1X93wWL6HZfJie\
                                     6eYjQIcXnKvQPNYanXTzz6IyvdIcCNByq83TCM5nWqQXv9evheVRCNBygnMawflca2RVlc7rIF1oCgRovt30FJxm0fN1E937M+tLEaD5BOe8MilUYpAujJMiQAUn20vjpK\
                                     cqUgSo4ETXHgGaZXBO4yQzxjnwIK1DdK4pEKDNBOdB/WNRWcM5JtfRrXeHEwJ0y+Dci676Tw7/aF1EkLq7CQG6QXieRNVpATzJq+p2HanxUQSo7jq69QjQZsPzNLrsqk4e8\
                                     6Z+zVSjCFBVJ9u5iRBVjTLeAFV1siOL8BlfgMYMe6o6bfjBrq6jGl1qCr5kMqDwnFa3T4IUnjQh3ZH2V/29mmsKBl2Bxpf8F4eTlqR1oye69AwqQKPLngb8TRTRtjTBNLX4n\
                                     kF04ePhbZfCk46kCcl/YtMZKDdA40u8rOycRPde19+/hWagyC688U4yYVyUsgI0rvwvHDYy8TZC9EpTCNCcg3Mvuuz27CQ3JpdGLPsxUOFJ5tLk0jLWISNAswrP1Uy78CT3E\
                                     P3LDL0ufG7huazcz05ZXnpOvQpUeMJ2XqtEBajwBCFKSQEqPBGiCFDhCUJUgApPEKJ8Se+z8LHO80p4MnA/eFSICrSN8FR5MgaL6GkhQBuTwtMiecZgdceSEBWgjVSfC+HJ\
                                     CEN0ET0vBOjW4Tmv7KrEOB1GzwsBulV4zir7eTLyELUp8zB0OgtvuRJ84ucf//7zTDMI0HXCM437pJ2VPIYDPvrOs+d14ddxLjzh8/PCpJIAfar6nFeengkP+Xd5k2YQoF\
                                     8Kz2ll0ggekyaVjIUWqNUxULdpwkaMh6pAP3EuPGH988V4qABdVZ+nlXFP2MS/dypphpF34a33hJ1YHzryCnQhPGFr87oIOdAMIwzQWLJkkxDQldeF3zA801XzUvUJjfCI5\
                                     JFVoLru0Jwzs/IjCdDYZcmsOzTblTeZNPQuvAXz0CoL7Adegc6FJ7RmoQkGGqCx5vMnTQmt2Y8bUxhgBWqMBto3N6E0sACNnZZMHEH70hDZXDMMqwJdaELozE/uUBpIgMayJ\
                                     TvMQ8ddeU0wjArUgYTuvYiJW0oNUNUn9MrEbeEVqOoT+nMcE7iUFqCqT8iCdaGFVqCqT+jfczPyhQWo6hOyopgprAJ1wCAfL1ShhQRoDFqrPiEvxkILqUAdKMjPzD3ymQdodBO\
                                     eay7ITrpH/kQz5F2Bqj4hX3NNkHeAzjQVZGvfwvpMAzSWLtltHvKmyMm0AnVgIH8vTCZlFqAxeWTDZCiDyaTMKlDVJ5TDZK8ABbZ06M6kTAI0Nm115xGURdGTSQXqQIAAZcsAN\
                                     SAN5dn3yI+eA1T3HYqm+Om5AtUNAAHKlgE61TRQLLPxfQVoNPyhpoGiKYJ6qkCV/6Abz5YB6soFKlAEKIzWM1vcdRyg0eC2rgNVKFtUoBocBCgCFEbPVpQdB6hbwGBAjIN2FKBx\
                                     +6bxT9CNZ4sKVPUJw+O87ihAXalAgKICBcK+h811E6DufwdVKJsGqA1YYdCmmqDdCvRAU8BgOb9bDlAVKAhQBChwjzuSdOGBbdmhvt0ANQMPuvFsGqDWiIEAZfsK1PgnCFC2DFAV\
                                     KAhQVKCAAO02QAFQgQJfYC1oSwFqDBRAFx6g2wA90AwwfJ6P1E6A7msGAF14AAEKIEABBChQOGu+BSiwJWu+BSiAAAUQoAACFAABCiBAgaZcagIBCmznnSYQoAACFKD0AL3WDADb\
                                     BeiVZoBRcK7rwgPb+PHvPwWoAAXIJ0CXmgEGz1yHChTYku57SwGqYWH4LKIXoMCW3MbZUoC6MgFsE6A//v2nKxMM31ITtFOBJjeaAgZNT7PFAFWFwoDpabYboFeaAgbLGlABCmzJ\
                                     +a0LD2xpqQlUoMB2FEhtBqgBZhCgbF+BJm81BwzOjW3suglQjQyqT7YMUA0Nw7PUBN0EqIYGFSgqUEBh1GGA/vj3n+leWXcswHC8jfOaDipQVSioPhGggADtPkA1OAhQ1vTV+/fv\
                                     P/kHf3z7/XvNAsVL459HmqHbCjS50CxQvHNN0E+AGgcFAcqWAbrULFC0axsE9RSgdcO7ckHZFEE9VqCJcVDQfWfLAHUFgzLd6EX2H6AOAKg+2SZAYwDas+KhPAtN0H8F6koG5Umz\
                                     70vNkEeAOhCg+44KFEbhTBNkEqCxj+AbTQRFuPDwuO59vUaX4Llmguwtuvglf3z7/V79Y1q/juK1Fz+fPRTq8XNZ3d4ivhzaBs+f7cb0QGP9v+8mZC2t/dxrMTQP6h8n9WtWvw5\
                                     3/OPeRmG2GELF/GiARuOlq8ex7yhk61UdRqctBGeqNE9b7IVeRJAuSm34dQI0XXVe+45Ctr5pspqL4Jx3WDilZ7GdlngH1ToBqhsP+XpTB89Jg131s6q/eY9Ukc5K6tpPnvoPzMZD\
                                     1hpZuhQ9zcuq30njVPFe1u/ltJTGn6z531kTCvm5aOLOozqwFtXtMN2zDD5Teg+/pfcUvd+yu/B3GvldJg0M3Hq5ywRMBFQK4MNMP1+asZ/mvPRpssF/qwqFfFw3MHudc3hW8d6\
                                     WOVeim1SgabHsP763UH71+cD5Pa1/HFS3i+KnmQVrtpXo2gEajXyZ+RULxlJ9HrT5C6LqS7P7p5mc81mG6GTD/95mBdC/edu/IAVVqnDj2fLf1K/fM+jOZ5c/m1ag6ap0VZlM\
                                     gsFWn4+c/wdVv+tEk5c53bm0UQUa5bPJJOjPrK9fnBa4x6L976rbu4f6cBZBXmQXvpPuA/Cgixx2nI/3kLr2fdxg8yynrvxki8ZLXXiPPYbuZXOHToyRpmr05x5+/fNYNVBkBVp\
                                     VJpOga7/Hwx6zUr+nlAUve/jVWfSEJ1s2WhoHvfadhk7c5FR9PpAHix5C9DiHKnSyw/937nsN3VRbue/k3lOIzvr+3BstY7rP/fHQurexFrMIsTHJiw5/5X/6vLhMdvz/GwuFdp2\
                                     W9GbrMEtV4dsOf+VJn5+3iQC98R2HVrzKYdlS5l3rcgM0SmdVKDQvFSbzEt94rBb4taNf1+tTgycN/BmqUGih6174I4A7y4U+Z+N3DlBVKDTuuuQnVfaQC71Nsk0a+nNUodCc+UA\
                                     +R1e50NuGy40EqCoUGpMCZxAb9kQudFFJl9uFv3e1cXcS7Oa88LHP+xZDPliNBWgc9LnvP+wWoEP6MDEjP9jCatJwYy1UobDTOTTE/XYHu4fwpIU/c+Y0gK0MdZvIpQBd/wq6rOw\
                                     XCoJGgKpCoUNXQ/xQMT8yyGWOk5YaLH0RXjkfQICGNjeDLnY3psfMK4vrQYCWHc79BGiU7aeOLWzUc3NxKChAd9pQeR1/fPv9sv5x7PSAJwP0q6F+tjoHUo/0l5b++Lf3uvFX8Ur\
                                     BetnmhenrDtpuVr/+z+kBo9bm/eqH9/7++F54r26PTcVco3d6TdputUj/X31/4MkqbW/AH6/Px5Kkxw6lx4y8TpVpeuxI/Wrk/Uy6ePd1iM6rbrf5ByHDY2H6Txpe3HUv0UmHb3z\
                                     m2EFv3dy+HWT4nlJX/6+oSLdq+84CtONt/kEFmpf9jN/bi+jab/x8pS4rUF15GGGA9vnIjQ279v+7aTU66eGN6srDw6Y+VxbV6HLdEO08QKMr/7NzBT6vgpqaHc7MSWHv93DdEO2\
                                     jAk0hmnavt2MTDLyHVofQQfX5Os3BhOikxzeYrkrulYeyq7Uhf54nQ7S3AI27AWbOF/jE/jazwRkrfT+MFKKLHCvQ1eMLbHsHwwqdVfc9XQj2B/BRntef5TS7AI0QTW/MeCh8dFz\
                                     I0p+nzAd0TH57aIJvksmbMx4KnzorvPqcVWVOHm10TLII0BgPPXHOwAeHX+o2FhCee6VfAB7pGcxyrEBXD6OzPhTudIFjGVBpFtXtnT2DPCZZBmiEaLpq/e68gX+lECrqmepRoT0\
                                     f8DHZv1uFTnJ7d3WIpjfnfnn42JVfFBKeaZLl9QiOyWm2ARqm9evauQP/elGHU9ZjihGeyxFd1I6yDdA7k0pm5uHWT/FcoZzD89mIjscs5wp0temImXn46JfcuvMjDc9qlU2tP5W\
                                     zgQOUkv61cwc+SDeenDT5cLRMzs3V0zUvq0+fspkc3HnlcnfTN9kHaByoNGj7m/MGPriJEF32cD6mdZ6pEt51tv1t9fFJmcsNf/80Xn3eLvqyiACNRksH7IXzBj7xpn6dtvns8we\
                                     qzrMduuw3Eb5nTb3nuO111kM+vComQIUoPCqtn563FaQRnPMdqr2bCN6ztoYe4qaDeYcZcVFUgApRWKsiXcROZ00E0ixeu3STX0W4v+soIw6iyj1u+VfdFBeg0UBpkPnQuQKPVnz\
                                     L1StWtawTPGlWfRqvXc+xtJZ71sc4bXyek6rl20pLDdC9+GIIUdgs0L7UxW+6WnsT4dn3SoF0UThvKyuKDFAhCln7PW7JzikrUiXa+D36xQaoEIUsvazDc5FpXqT31ej8yaTkIxX\
                                     dg2ll8xEQnk/nxSyGFgToAyFqGzwQnk+ZNVlwFd2F76JEBwYTnqucOKhubxfddXb+ZjKkoxglukoUunFTWnhGTlxVzTxS/XIytCMaIfqr7za0Hp7T0sLzTk6kpU27jodeTYZ4ZO\
                                     vGmacro+84tOI6wvOy8M+x60P7LidDPcJxZfyhsikzNClNwBwNIDxXXfldeqvLyZCPdJTpUyEKjXgTlee7AX2mbR+VcpMuIpOhH/G4Uh5U1orCLl7V59LJwMJztQxym4nnfzdrm\
                                     YzhyFsrCjtJM+2nA/5821Shi/Q/g1oHug6728P63dRqGJNF6+TCVbX+ln3XdZscjKYCvVeNpqvNd5VxUXhMeu7SwRjC826XfE3z1V9MxvjNiP0J076HxkXhc2m8c2iTRU9ZblCV\
                                     n486QCNEr+pXCtFXzhf4EA4/DHy8c9cA/WRn/dGNgT6ki52rIXOpN3bS1cPpMs2B9NkfGwf9MPY5+gr0XjV6Hl36C63BCP2aemNjDs/w1Oef3f8HAvTTLv20ch8945Fuyfwubn\
                                     3m8W78q4ee7SRAPw/S9GX6n8oEE8OW1kQf9fXAt8K8/dK48Nfa5sEQTUs3jv749vsUpr9oEQYkTRTNmnjs8Yiq9OmX/qUKVDXKuKrOA+G50cXm0dtXVaCqUcZRRc101zcOzyf\
                                     vwlKBbl6NmqmnJGlS1FjnFt32de7Csg50C3U1OqtuNyCwbpRcpQv96YhuxWzivE5DG3tPddsFaDONnRo6VaU/aQ0y63qelvqojZ7P6ZNNx4cF6O6NfhTV6LHWIIPu+tnI7m\
                                     HvlQBt8OoVQbqvNejYm6g6rzSFAC09SGeV8VG6kcY55yaIBOjQQjSNj57GS5DSNMuSBKgghS2Cc26CSIAKUhCcAhRBSmvSGOdCcApQPg/TWXW7jtSsPQ8Fp8khAcoaQXo\
                                     SFal1pOO2etbO3HIkAcrmQXoQFemJ7v2opPHNs+iqWwAvQNkxSPciRFNVeqhFButNhKat5QQoLYXpUQSpqnRY1ea5broApdswnUWQPtcaRVmNbZ7ZGUmAkk8XX5jmH5rnuu\
                                     gCFGGK0ESADj5Mp3cC1Zhp+9KzspbV7WSQ7rkAZUCBehRBmkLVGtPmqsxlVJpLE0EI0PEE6jTCVKBuHpjLCExVJgKUD4F6FIGafrql9LZLfhmBeSkwEaCsG6h79wL1oBr2Qv\
                                     6LCMurCMulbwEClKaDdRWmq5+rvy5hkipVlO/uBmX6aewSAUou4boXr6P4x6t/VkXYtjE0cHHnr6/iVUXXu4qK0n3ltO6/AgwAJM21HORE7w8AAAAASUVORK5CYII=";
                    maskImage.onload = function () {
                            $jsvar.series[0].maskImage;
                            $jschartvar.setOption($jsvar);
                    }
                }] -start
        ]

$chart SetOptions -tooltip {}

$chart Add "wordCloudSeries" -gridSize 0 \
                             -sizeRange [list {4 150}] \
                             -rotationRange [list {0 0}] \
                             -shape "pentagon" \
                             -maskImage $maskImage \
                             -drawOutOfBound "False" \
                             -textStyle [list fontWeight "bold" color $js] \
                             -dataWCItem {
                                {name "visualMap" value 22199}
                                {name "continuous" value 10288}
                                {name "contoller" value 620}
                                {name "series" value 274470}
                                {name "gauge" value 12311}
                                {name "detail" value 1206}
                                {name "piecewise" value 4885}
                                {name "textStyle" value 32294}
                                {name "markPoint" value 18574}
                                {name "pie" value 38929}
                                {name "roseType" value 969}
                                {name "label" value 37517}
                                {name "emphasis" value 12053}
                                {name "yAxis" value 57299}
                                {name "name" value 15418}
                                {name "type" value 22905}
                                {name "gridIndex" value 5146}
                                {name "normal" value 49487}
                                {name "itemStyle" value 33837}
                                {name "min" value 4500}
                                {name "silent" value 5744}
                                {name "animation" value 4840}
                                {name "offsetCenter" value 232}
                                {name "inverse" value 3706}
                                {name "borderColor" value 4812}
                                {name "markLine" value 16578}
                                {name "line" value 76970}
                                {name "radiusAxis" value 6704}
                                {name "radar" value 15964}
                                {name "data" value 60679}
                                {name "dataZoom" value 24347}
                                {name "tooltip" value 43420}
                                {name "toolbox" value 25222}
                                {name "geo" value 16904}
                                {name "parallelAxis" value 4029}
                                {name "parallel" value 5319}
                                {name "max" value 3393}
                                {name "bar" value 43066}
                                {name "heatmap" value 3110}
                                {name "map" value 20285}
                                {name "animationDuration" value 3425}
                                {name "animationDelay" value 2431}
                                {name "splitNumber" value 5175}
                                {name "axisLine" value 12738}
                                {name "lineStyle" value 19601}
                                {name "splitLine" value 7133}
                                {name "axisTick" value 8831}
                                {name "axisLabel" value 17516}
                                {name "pointer" value 590}
                                {name "color" value 23426}
                                {name "title" value 38497}
                                {name "formatter" value 15214}
                                {name "slider" value 7236}
                                {name "legend" value 66514}
                                {name "grid" value 28516}
                                {name "smooth" value 1295}
                                {name "smoothMonotone" value 696}
                                {name "sampling" value 757}
                                {name "feature" value 12815}
                                {name "saveAsImage" value 2616}
                                {name "polar" value 6279}
                                {name "calculable" value 879}
                                {name "backgroundColor" value 9419}
                                {name "excludeComponents" value 130}
                                {name "show" value 20620}
                                {name "text" value 2592}
                                {name "icon" value 2782}
                                {name "dimension" value 478}
                                {name "inRange" value 1060}
                                {name "animationEasing" value 2983}
                                {name "animationDurationUpdate" value 2259}
                                {name "animationDelayUpdate" value 2236}
                                {name "animationEasingUpdate" value 2213}
                                {name "xAxis" value 89459}
                                {name "angleAxis" value 5469}
                                {name "showTitle" value 484}
                                {name "dataView" value 2754}
                                {name "restore" value 932}
                                {name "timeline" value 10104}
                                {name "range" value 477}
                                {name "value" value 5732}
                                {name "precision" value 878}
                                {name "target" value 1433}
                                {name "zlevel" value 5361}
                                {name "symbol" value 8718}
                                {name "interval" value 7964}
                                {name "symbolSize" value 5300}
                                {name "showSymbol" value 1247}
                                {name "inside" value 8913}
                                {name "xAxisIndex" value 3843}
                                {name "orient" value 4205}
                                {name "boundaryGap" value 5073}
                                {name "nameGap" value 4896}
                                {name "zoomLock" value 571}
                                {name "hoverAnimation" value 2307}
                                {name "legendHoverLink" value 3553}
                                {name "stack" value 2907}
                                {name "throttle" value 466}
                                {name "connectNulls" value 897}
                                {name "clipOverflow" value 826}
                                {name "startValue" value 551}
                                {name "minInterval" value 3292}
                                {name "opacity" value 3097}
                                {name "splitArea" value 4775}
                                {name "filterMode" value 635}
                                {name "end" value 409}
                                {name "left" value 6475}
                                {name "funnel" value 2238}
                                {name "lines" value 6403}
                                {name "baseline" value 431}
                                {name "align" value 2608}
                                {name "coord" value 897}
                                {name "nameTextStyle" value 7477}
                                {name "width" value 4338}
                                {name "shadowBlur" value 4493}
                                {name "effect" value 929}
                                {name "period" value 225}
                                {name "areaColor" value 631}
                                {name "borderWidth" value 3654}
                                {name "nameLocation" value 4418}
                                {name "position" value 11723}
                                {name "containLabel" value 1701}
                                {name "scatter" value 10718}
                                {name "areaStyle" value 5310}
                                {name "scale" value 3859}
                                {name "pieces" value 414}
                                {name "categories" value 1000}
                                {name "selectedMode" value 3825}
                                {name "itemSymbol" value 273}
                                {name "effectScatter" value 7147}
                                {name "fontStyle" value 3376}
                                {name "fontSize" value 3386}
                                {name "margin" value 1034}
                                {name "iconStyle" value 2257}
                                {name "link" value 1366}
                                {name "axisPointer" value 5245}
                                {name "showDelay" value 896}
                                {name "graph" value 22194}
                                {name "subtext" value 1442}
                                {name "selected" value 2881}
                                {name "barCategoryGap" value 827}
                                {name "barGap" value 1094}
                                {name "barWidth" value 1521}
                                {name "coordinateSystem" value 3622}
                                {name "barBorderRadius" value 284}
                                {name "z" value 4014}
                                {name "polarIndex" value 1456}
                                {name "shadowOffsetX" value 3046}
                                {name "shadowColor" value 3771}
                                {name "shadowOffsetY" value 2475}
                                {name "height" value 1988}
                                {name "barMinHeight" value 575}
                                {name "lang" value 131}
                                {name "symbolRotate" value 2752}
                                {name "symbolOffset" value 2549}
                                {name "showAllSymbol" value 942}
                                {name "transitionDuration" value 993}
                                {name "bottom" value 3724}
                                {name "fillerColor" value 229}
                                {name "nameMap" value 1249}
                                {name "barMaxWidth" value 747}
                                {name "radius" value 2103}
                                {name "center" value 2425}
                                {name "magicType" value 3276}
                                {name "labelPrecision" value 248}
                                {name "option" value 654}
                                {name "seriesIndex" value 935}
                                {name "controlPosition" value 121}
                                {name "itemGap" value 3188}
                                {name "padding" value 3481}
                                {name "shadowStyle" value 347}
                                {name "boxplot" value 1394}
                                {name "labelFormatter" value 264}
                                {name "realtime" value 631}
                                {name "dataBackgroundColor" value 239}
                                {name "showDetail" value 247}
                                {name "showDataShadow" value 217}
                                {name "x" value 684}
                                {name "valueDim" value 499}
                                {name "onZero" value 931}
                                {name "right" value 3255}
                                {name "clockwise" value 1035}
                                {name "itemWidth" value 1732}
                                {name "trigger" value 3840}
                                {name "axis" value 379}
                                {name "selectedOffset" value 670}
                                {name "startAngle" value 1293}
                                {name "minAngle" value 590}
                                {name "top" value 4637}
                                {name "avoidLabelOverlap" value 870}
                                {name "labelLine" value 3785}
                                {name "sankey" value 2933}
                                {name "endAngle" value 213}
                                {name "start" value 779}
                                {name "roam" value 1738}
                                {name "fontWeight" value 2828}
                                {name "fontFamily" value 2490}
                                {name "subtextStyle" value 2066}
                                {name "indicator" value 853}
                                {name "sublink" value 708}
                                {name "zoom" value 1038}
                                {name "subtarget" value 659}
                                {name "length" value 1060}
                                {name "itemSize" value 505}
                                {name "controlStyle" value 452}
                                {name "yAxisIndex" value 2529}
                                {name "edgeLabel" value 1188}
                                {name "radiusAxisIndex" value 354}
                                {name "scaleLimit" value 1313}
                                {name "geoIndex" value 535}
                                {name "regions" value 1892}
                                {name "itemHeight" value 1290}
                                {name "nodes" value 644}
                                {name "candlestick" value 3166}
                                {name "crossStyle" value 466}
                                {name "edges" value 369}
                                {name "links" value 3277}
                                {name "layout" value 846}
                                {name "barBorderColor" value 721}
                                {name "barBorderWidth" value 498}
                                {name "treemap" value 3865}
                                {name "y" value 367}
                                {name "valueIndex" value 704}
                                {name "showLegendSymbol" value 482}
                                {name "mapValueCalculation" value 492}
                                {name "optionToContent" value 264}
                                {name "handleColor" value 187}
                                {name "handleSize" value 271}
                                {name "showContent" value 1853}
                                {name "angleAxisIndex" value 406}
                                {name "endValue" value 327}
                                {name "triggerOn" value 1720}
                                {name "contentToOption" value 169}
                                {name "buttonColor" value 71}
                                {name "rotate" value 1144}
                                {name "hoverLink" value 335}
                                {name "outOfRange" value 491}
                                {name "textareaColor" value 58}
                                {name "textareaBorderColor" value 58}
                                {name "textColor" value 60}
                                {name "buttonTextColor" value 66}
                                {name "category" value 336}
                                {name "hideDelay" value 786}
                                {name "alwaysShowContent" value 1267}
                                {name "extraCssText" value 901}
                                {name "effectType" value 277}
                                {name "force" value 1820}
                                {name "rippleEffect" value 723}
                                {name "edgeSymbolSize" value 329}
                                {name "showEffectOn" value 271}
                                {name "gravity" value 199}
                                {name "edgeLength" value 193}
                                {name "layoutAnimation" value 152}
                                {name "length2" value 169}
                                {name "enterable" value 957}
                                {name "dim" value 83}
                                {name "readOnly" value 143}
                                {name "levels" value 444}
                                {name "textGap" value 256}
                                {name "pixelRatio" value 84}
                                {name "nodeScaleRatio" value 232}
                                {name "draggable" value 249}
                                {name "brushType" value 158}
                                {name "radarIndex" value 152}
                                {name "large" value 182}
                                {name "edgeSymbol" value 675}
                                {name "largeThreshold" value 132}
                                {name "leafDepth" value 73}
                                {name "childrenVisibleMin" value 73}
                                {name "minSize" value 35}
                                {name "maxSize" value 35}
                                {name "sort" value 90}
                                {name "funnelAlign" value 61}
                                {name "source" value 336}
                                {name "nodeClick" value 200}
                                {name "curveness" value 350}
                                {name "areaSelectStyle" value 104}
                                {name "parallelIndex" value 52}
                                {name "initLayout" value 359}
                                {name "trailLength" value 116}
                                {name "boxWidth" value 20}
                                {name "back" value 53}
                                {name "rewind" value 110}
                                {name "zoomToNodeRatio" value 80}
                                {name "squareRatio" value 60}
                                {name "parallelAxisDefault" value 358}
                                {name "checkpointStyle" value 440}
                                {name "nodeWidth" value 49}
                                {name "color0" value 62}
                                {name "layoutIterations" value 56}
                                {name "nodeGap" value 54}
                                {name "color(Array" value 76}
                                {name "<string>)" value 76}
                                {name "repulsion" value 276}
                                {name "tiled" value 105}
                                {name "currentIndex" value 145}
                                {name "axisType" value 227}
                                {name "loop" value 97}
                                {name "playInterval" value 112}
                                {name "borderColor0" value 23}
                                {name "gap" value 43}
                                {name "autoPlay" value 123}
                                {name "showPlayBtn" value 25}
                                {name "breadcrumb" value 119}
                                {name "colorMappingBy" value 85}
                                {name "id" value 18}
                                {name "blurSize" value 85}
                                {name "minOpacity" value 50}
                                {name "maxOpacity" value 54}
                                {name "prevIcon" value 12}
                                {name "children" value 21}
                                {name "shape" value 98}
                                {name "nextIcon" value 12}
                                {name "showNextBtn" value 17}
                                {name "stopIcon" value 21}
                                {name "visibleMin" value 83}
                                {name "visualDimension" value 97}
                                {name "colorSaturation" value 56}
                                {name "colorAlpha" value 66}
                                {name "emptyItemWidth" value 10}
                                {name "inactiveOpacity" value 4}
                                {name "activeOpacity" value 4}
                                {name "showPrevBtn" value 19}
                                {name "playIcon" value 26}
                                {name "ellipsis" value 19}
                                {name "gapWidth" value 19}
                                {name "borderColorSaturation" value 10}
                                {name "handleIcon" value 2}
                                {name "handleStyle" value 6}
                                {name "borderType" value 1}
                                {name "constantSpeed" value 1}
                                {name "polyline" value 2}
                                {name "blendMode" value 1}
                                {name "dataBackground" value 1}
                                {name "textAlign" value 1}
                                {name "textBaseline" value 1}
                                {name "brush" value 3}
                            }

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$chart Render -outfile [file join $dirname $fbasename.html] \
              -title $fbasename \
              -script $var \
              -jschartvar $jschartvar \
              -jsvar $jsvar