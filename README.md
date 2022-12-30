
# yamlupdater

<!-- badges: start -->
<!-- badges: end -->

The goal of yamlupdater is to help updating yaml headers where you may want to append keys, values, or both, rather than or in addition to overwriting the whole header, and where you want to protect the main md from being overwritten.

The `ymlthis` functions are great for working with yaml but (I think) they don't help writing yaml to existing files. The `yaml` package is great for basics but similarly limited. This provides functions for some simple yaml cases, but I doubt it's useful for more complex. I think other tools (e.g. https://kislyuk.github.io/yq/ ) are likely to be a better bet, and it'd be great to have an `R` wrapper for `yq`. 

## Installation

You can install the development version of yamlupdater from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("sjgknight/yamlupdater")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(yamlupdater)
## basic example code
```

