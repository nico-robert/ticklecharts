
Dependencies :
-------------------------

- tcljupyter (https://github.com/mpcjanssen/tcljupyter)

Usage :
-------------------------

```tcl
package require ticklecharts 3.2 ; # minimum version
# ...
# method to interact with jupyter notebook
$chart RenderJupyter
```

`RenderJupyter` method accepts as arguments :
- _-renderer_ : 'canvas' or 'svg' (`canvas` by default)
- _-height_ : height of iframe plus inner container (`500px` by default)
- _-width_ : width of iframe plus inner container (`100%` by default)

Credit :
-------------------------
- Stefan Sobernig (https://github.com/mrcalvin)