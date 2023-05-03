[Taygete Scrap Book](https://www.androwish.org/home/dir?name=undroid/tsb) :
- Note : *This is an experimental, partial, compact rebuild of some ideas of Jupyter Notebook.
The name is derived from Taygete (Ταϋγέτη) which is a small retrograde irregular satellite of Jupiter,
aka Jupiter XX.
It consists of a webview (the rendering component/library of a web browser) with an added Tcl interface,
plus some Tcl and JavaScript to provide a user interface resembling Jupyter Notebook.
The webview part is basically taken from the Tiny cross-platform webview library for C/C++/Golang
with the Python interface taken as starting point for the Tcl interface.
No browser and webserver are required so it can be made into one binary with zero installation and without 
requiring network infrastructure. Uncloudy, so to speak clean hot air*.

Dependencies :
-------------------------

`tsb` package from [androwish.org](https://www.androwish.org/home/dir?name=undroid/tsb)   
`twv` package from [androwish.org](https://www.androwish.org/home/dir?name=undroid/twv)

Usage :
-------------------------

> _tclsh_ tsb/tsb.tcl examples/tsb/ticklecharts.tsb

```tcl
package require ticklecharts 3.1.1 ; # minimum version
# ...
# method to interact with Taygete Scrap Book
$chart RenderTsb
```

`RenderTsb` method accepts as arguments :
- _-renderer_ : 'canvas' or 'svg' (`canvas` by default)
- _-height_ : size html canvas (`500px` by default)
- _-merge_ : If **false**, all of the current components will be removed and new components   
will be created according to the new option. (`false` by default)
- _-evalJSON_ (>= **3.1.2**) : Two possibilities `JSON.parse` or `eval` to insert an JSON obj in Tsb Webview. `eval` JSON obj is not   
recommended (security reasons). `JSON.parse` is safe but `function`, `js variable` in JSON obj are not supported.   
(`false` by default)


![ticklecharts.tsb](./ticklecharts_tsb.png)