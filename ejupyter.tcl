# Copyright (c) 2022-2024 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.

# Credit to Stefan Sobernig (https://github.com/mrcalvin) :
#
# "Along the way, I explored ways of integrating charts into Jupyter notebooks.
# The main idea is to re-use the HTML export mechanism and pack the resulting HTML document
# into a <iframe>, to be rendered as a display in a Jupyter notebook."
#
# Dependencies :
# - tcljupyter (https://github.com/mpcjanssen/tcljupyter)

if {[info commands ::jupyter::html] ne ""} {

    namespace eval ticklecharts {
        set minProperties "True" ; # To gain speed
        set htmltemplate [readHTMLTemplate \
                         [file join $edir html jupyter_template.html]]
    }

    # Define a new method 'RenderJupyter' for
    # all ticklecharts classes.
    foreach class {
        ticklecharts::chart ticklecharts::chart3D 
        ticklecharts::Gridlayout ticklecharts::timeline
        } {
        oo::define $class {
            method RenderJupyter {args} {
                # Export chart to Jupyter display
                #
                # args - Options described below.
                #
                # -renderer - 'canvas' or 'svg'
                # -height   - height of iframe plus inner container
                # -width    - width  of iframe plus inner container
                #
                # Returns nothing
            
                if {[llength $args] % 2} {
                    error "wrong # args: should be \"[self] [self method]\
                          ?-renderer renderer? ...\""
                }

                # Gets arguments options
                set jupyteropts [ticklecharts::renderOptions $args [self method]]
                # Sets default arguments html options.
                set htmlopts [ticklecharts::renderOptions {} "toHTML"]
                set opts     [dict merge $htmlopts $jupyteropts]

                set srcDoc [my toHTML {*}$opts]

                # Add global options to main options.
                if {[my getType] in {chart chart3D}} {
                    set myopts [list {*}[my globalOptions] {*}[my options]]
                } else {
                    set myopts [my options]
                }

                # function, variable... javascript inside
                # 'Json' is not supported.
                if {[my getType] eq "timeline"} {
                    set timelineopts [list {*}[my baseOption] {*}$myopts]
                    ticklecharts::checkJsFunc $timelineopts [self method]
                } else {
                    ticklecharts::checkJsFunc $myopts [self method]
                }

                set width  [lindex [dict get $opts -width] 0]
                set height [lindex [dict get $opts -height] 0]
                # TODO : 
                # Provide for different ways of embedding <iframe/> 
                # content (srcdoc vs. data-url)?
                set iframe [format {
                <iframe
                  style="height: %s; width: %s;"
                  frameborder="0"
                  srcdoc='%s'>
                </iframe>
                } $height $width $srcDoc]

                set ::ticklecharts::theme "custom"

                # tcl Jupyter notebook command.
                set displayId [::jupyter::html $iframe]

                return {}
            }

            # export new method
            export RenderJupyter
            # unexport method(s)
            unexport toJSON Render toHTML
        }
    }
}
