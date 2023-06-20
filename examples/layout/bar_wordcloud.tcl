lappend auto_path [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]

# v1.0 : Initial example
# v2.0 : bump to 'v2.1.0' echarts-wordcloud
# v3.0 : Delete 'echarts-wordcloud.js' with jsfunc. It is inserted automatically when writing the html file.
# v4.0 : Rename '-databaritem' by '-dataBarItem' +
#        Replace 'render' method by 'Render' (Note the first letter in capital letter...)
# v5.0 : Update example with the new 'Add' method for chart series.
# v6.0 : Replaces '-dataBarItem' by '-dataItem' (both properties are available).

proc fakerRandomValue {{min 10} {max 1000}} {

    set range [expr {$max - $min}]
    return [expr {int(rand() * $range) + $min}]
}

proc cmdTclTk {list} {
    foreach cmd $list {
        lappend commands [list name $cmd value [fakerRandomValue]]
    }

    return $commands
}

# source all.tcl
if {[catch {package present ticklecharts}]} {package require ticklecharts}


set tcl_commands {
    after errorInfo load re_syntax tcl_startOfNextWord
    append eval lrange read tcl_startOfPreviousWord
    apply exec lrepeat refchan tcl_traceCompile
    argc exit lreplace regexp tcl_traceExec
    argv expr lreverse registry tcl_version
    argv0 fblocked lsearch regsub tcl_wordBreakAfter
    array fconfigure lset rename tcl_wordBreakBefore
    auto_execok fcopy lsort return tcl_wordchars
    auto_import file mathfunc safe tcltest
    auto_load fileevent mathop scan tell
    auto_mkindex filename memory seek throw
    auto_path flush msgcat self time
    auto_qualify for my set timerate
    auto_reset foreach namespace socket tm
    bgerror format next source trace
    binary gets nextto split transchan
    break glob oo::class string try
    catch global oo::copy subst unknown
    cd history oo::define switch unload
    chan http oo::objdefine tailcall unset
    clock if oo::object Tcl update
    close incr open tcl::prefix uplevel
    concat info package tcl_endOfWord upvar
    continue interp parray tcl_findLibrary variable
    coroutine join pid tcl_interactive vwait
    dde lappend pkg::create tcl_library while
    dict lassign pkg_mkIndex tcl_nonwordchars yield
    encoding lindex platform tcl_patchLevel yieldto
    env linsert platform::shell tcl_pkgPath zlib
    eof list proc tcl_platform
    error llength puts tcl_precision
    errorCode lmap pwd tcl_rcFileName
}

set tk_commands {
    bell grab scale tk_optionMenu ttk::menubutton
    bind grid scrollbar tk_patchLevel ttk::notebook
    bindtags image selection tk_popup ttk::panedwindow
    bitmap keysyms send tk_setPalette ttk::progressbar
    busy label spinbox tk_strictMotif ttk::radiobutton
    button labelframe text tk_textCopy ttk::scale
    canvas listbox tk tk_textCut ttk::scrollbar
    checkbutton lower tk::mac tk_textPaste ttk::separator
    clipboard menu tk_bisque tk_version ttk::sizegrip
    colors menubutton tk_chooseColor tkerror ttk::spinbox
    console message tk_chooseDirectory tkwait ttk::style
    cursors option tk_dialog toplevel ttk::treeview
    destroy options tk_focusFollowsMouse ttk::button ttk::widget
    entry pack tk_focusNext ttk::checkbutton ttk_image
    event panedwindow tk_focusPrev ttk::combobox ttk_vsapi
    focus photo tk_getOpenFile ttk::entry winfo
    font place tk_getSaveFile ttk::frame wm
    fontchooser radiobutton tk_library ttk::intro
    frame raise tk_menuSetFocus ttk::label
    geometry safe::loadTk tk_messageBox
}

# Add bar serie
set bar [ticklecharts::chart new]
                  
$bar SetOptions -title   {text "layout bar + wordCloud..."} \
                 -tooltip {show "True"}          
    
$bar Xaxis -data [list {"Tcl" "Tk"}]
$bar Yaxis
$bar Add "barSeries" -dataItem [list \
                                    [list value [llength $tcl_commands]] \
                                    [list value [llength $tk_commands] itemStyle {color "#91cc75" borderColor "nothing"}] \
                                ] \
                     -label {show "True" position "top" distance 8}

# Add wordCloud serie
set wc [ticklecharts::chart new]

# callback color wordCloud
set js [ticklecharts::jsfunc new {
                function () {
                    let colors = ["#3ba272", "#73c0de"];
                    let num = Math.round(Math.random());
                    return colors[num];
                }
          }]

$wc Add "wordCloudSeries" -gridSize 0 \
                          -sizeRange [list {3 120}] \
                          -shape "pentagon" \
                          -width  50% \
                          -height 50% \
                          -drawOutOfBound "False" \
                          -keepAspect "True" \
                          -textStyle [list color $js] \
                          -dataWCItem [cmdTclTk [concat $tcl_commands $tk_commands]]

# Add bar + wordCloud chart...
set layout [ticklecharts::Gridlayout new]
$layout Add $bar  -bottom "60%" -width "30%" -left "5%"
$layout Add $wc   -top "50%" -left "5%"

set fbasename [file rootname [file tail [info script]]]
set dirname [file dirname [info script]]

$layout Render -outfile [file join $dirname $fbasename.html] \
               -title $fbasename \
               -width 1900px \
               -height 1000px