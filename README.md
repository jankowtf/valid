
<!-- README.md is generated from README.Rmd. Please edit that file -->

# valid

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/valid)](https://CRAN.R-project.org/package=valid)
<!-- badges: end -->

## Installation

``` r
# install.packages("remotes")
remotes::install_github("rappster/valid")
```

## What?

Helpers for facilitating systematic input validation

## Why?

Input validation is tedious already. This package hopefully provides
some functionality to make the task a bit easier or at least more fun.

## Overview

``` r
library(valid)
```

### Some build-in functions

The amount of such built-in functions will grow over time in a “scratch
my own itch” manner

``` r
valid_dep_types()
#>    Suggests     Imports     Depends    Enhances   LinkingTo 
#>  "Suggests"   "Imports"   "Depends"  "Enhances" "LinkingTo"
valid_dep_types("Suggests")
#>   Suggests 
#> "Suggests"
try(valid_dep_types("I don't exist"))
#> Error in valid::valid(choice = type, choices = types, flip = flip) : 
#>   Invalid choice: valid_dep_types("I don't exist")

valid_authentication()
#>     ssh   https 
#>   "ssh" "https"
valid_authentication("https")
#>   https 
#> "https"

valid_licenses()
#>       gpl3        mit        cc0       ccby       lgpl       apl2      agpl3 
#>   "GPL v3"      "MIT"      "CC0" "CCBY 4.0"  "LGPL v3"  "APL 2.0"  "AGPL v3"
valid_licenses(flip = TRUE)
#>   GPL v3      MIT      CC0 CCBY 4.0  LGPL v3  APL 2.0  AGPL v3 
#>   "gpl3"    "mit"    "cc0"   "ccby"   "lgpl"   "apl2"  "agpl3"
```

### Custom function

#### Definition

You can build your functions on top of `valid::valid()`

``` r
#' Valid devops environments
#'
#' @param x [[character]] DevOps environment
#' @param reverse [[logical]] Reverse order
#' @param flip [[logical]] Flip values and names
#' @param strict [[logical]] Throw error if invalid choice or return empty
#'
#' @return
#' @export
#'
#' @examples
valid_devops_envs <- function(
  x = character(),
  reverse = FALSE,
  flip = FALSE,
  strict = TRUE
) {
  values <- c("dev", "prod")
  names(values) <- toupper(values)

  valid(
    choice = x,
    choices = values,
    reverse = reverse,
    flip = flip,
    strict = strict
  )
}
```

#### Apply without explicit choice

``` r
valid_devops_envs()
#>    DEV   PROD 
#>  "dev" "prod"
```

``` r
valid_devops_envs(reverse = TRUE)
#>   PROD    DEV 
#> "prod"  "dev"
```

``` r
valid_devops_envs(flip = TRUE)
#>    dev   prod 
#>  "DEV" "PROD"
```

#### Choice via value

Valid:

``` r
valid_devops_envs("dev")
#>   DEV 
#> "dev"
```

Invalid:

``` r
try(valid_devops_envs("abc"))
#> Error in valid(choice = x, choices = values, reverse = reverse, flip = flip,  : 
#>   Invalid choice: valid_devops_envs("abc")
```

Invalid but non-strict:

``` r
valid_devops_envs("abc", strict = FALSE)
#> named character(0)
```

#### Choice via name

Valid:

``` r
valid_devops_envs("PROD")
#>   PROD 
#> "prod"
```

Invalid:

``` r
try(valid_devops_envs("ABC"))
#> Error in valid(choice = x, choices = values, reverse = reverse, flip = flip,  : 
#>   Invalid choice: valid_devops_envs("ABC")
```

Invalid but non-strict:

``` r
valid_devops_envs("ABC", strict = FALSE)
#> named character(0)
```

#### Choice via index/position

Valid:

``` r
valid_devops_envs(2)
#>   PROD 
#> "prod"
```

Invalid:

``` r
try(valid_devops_envs(3))
#> Error in valid(choice = x, choices = values, reverse = reverse, flip = flip,  : 
#>   Invalid choice: valid_devops_envs(3)
```

Invalid but non-strict:

``` r
valid_devops_envs(3, strict = FALSE)
#> named character(0)
```

### Use validation function inside of another function

``` r
foo <- function(
  devops_env = valid_devops_envs("dev")
) {
  # Input validation
  devops_env <- match.arg(devops_env, valid_devops_envs())
  
  # Body
  stringr::str_glue("DevOps env: {stringr::str_c(devops_env, collapse = ', ')}")
}
```

#### Keeping the default

``` r
foo()
#> DevOps env: dev
```

#### Eager input validation

``` r
foo(
  devops_env = valid_devops_envs("dev")
)
#> DevOps env: dev
```

``` r
try(
  foo(
    devops_env = valid_devops_envs("abc")
  )
)
#> Error in valid(choice = x, choices = values, reverse = reverse, flip = flip,  : 
#>   Invalid choice: valid_devops_envs("abc")
```

#### Lazy input validation

``` r
foo(
  devops_env = "dev"
)
#> DevOps env: dev
```

``` r
try(
  foo(
    devops_env = "abc"
  )
)
#> Error in match.arg(devops_env, valid_devops_envs()) : 
#>   'arg' should be one of "dev", "prod"
```

## Code of Conduct

Please note that the valid project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
