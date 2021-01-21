wofostats
=========
[![Project Status: Unsupported – The project has reached a stable, usable state but the author(s) have ceased all work on it. A new maintainer may be desired.](https://www.repostatus.org/badges/latest/unsupported.svg)](https://www.repostatus.org/#unsupported)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

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
