
This repository provides a convenient mechanism for generating TopoJSON files from [Natural Earth](http://naturalearthdata.com/).
Before you can run `make`, you’ll need to install Node.js, ```topojson``` and the ```gdal``` package for your system.

```bash
yum install gdal-perl gdal-doc gdal
npm install -g topojson canvas
```

If you want to install this software using an alternate method see the website for [TopoJSON](https://github.com/mbostock/topojson).
I also recommend reading Mike's tutorial, [Let’s Make a Map](http://bost.ocks.org/mike/map/).

## Make Targets

<b>topo/world-10m.json</b>

Admin 0 country boundaries at 1:10,000,000 scale.

<b>topo/world-50m.json</b>

Admin 0 country boundaries at 1:50,000,000 scale.

<b>topo/world-110m.json</b>

Admin 0 country boundaries at 1:110,000,000 scale.

