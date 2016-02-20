wofostats
=========
[![Project Status: Suspended - Initial development has started, but there has not yet been a stable, usable release; work has been stopped for the time being but the author(s) intend on resuming work.](http://www.repostatus.org/badges/latest/suspended.svg)](http://www.repostatus.org/#suspended)
[![Travis-CI Build Status](https://travis-ci.org/zsteinmetz/wofostats.svg?branch=master)](https://travis-ci.org/zsteinmetz/wofostats)
[![License](http://img.shields.io/:license-GPL--3-blue.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html)

WOFOST ([WOrld FOod STudies by Alterra Wageningen](http://www.wageningenur.nl/en/Expertise-Services/Research-Institutes/alterra/Facilities-Products/Software-and-models/WOFOST.htm)) is a simulation model for the quantitative analysis of the growth and production of annual field crops. The `wofostats` package provides functions to handle WOFOST parameter input files and model results.

## Functions
Currently, the following functions are available:

* Read WOFOST output files (\*.out, \*.pps, \*.wps) `read.wofost()`
* Write CABO weather files `write.cabo()`

## Installation
`wofostats` is available on github. To install the package paste the following code into your R console:

```r
if (!'devtools' %in% installed.packages()[,'Package']) install.packages('devtools')
devtools::install_github('zsteinmetz/wofostats')
require(wofostats)
```
