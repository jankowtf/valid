
<!-- README.md is generated from README.Rmd. Please edit that file -->

# valid

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/valid)](https://CRAN.R-project.org/package=valid)
<!-- badges: end -->

Facilitating structured input validation

## Installation

``` r
remotes::install_github("rappster/valid")
```

## Example

### Custom validation function

``` r
library(valid)
```

``` r
#' Valid devops environments
#'
#' @param devops_env [[character]] DevOps environment
#' @param reverse [[logical]] Reverse order
#' @param flip [[logical]] Flip values and names
#' @param strict [[logical]] Throw error if invalid choice or return empty
#'
#' @return
#' @export
#'
#' @examples
valid_devops_envs <- function(
  devops_env = character(),
  reverse = FALSE,
  flip = FALSE,
  strict = TRUE
) {
  values <- c("dev", "prod")
  names(values) <- toupper(values)

  valid_generic_(
    choice = devops_env,
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
valid_devops_envs(devops_env = "dev")
#>   DEV 
#> "dev"
```

Invalid:

``` r
try(valid_devops_envs(devops_env = "abc"))
#> Error in "Invalid choice: {call}({deparse(choice)})" %>% stringr::str_glue() : 
#>   could not find function "%>%"
```

Invalid but non-strict:

``` r
valid_devops_envs(devops_env = "abc", strict = FALSE)
#> named character(0)
```

#### Choice via index/position

Valid:

``` r
valid_devops_envs(devops_env = 2)
#>   PROD 
#> "prod"
```

Invalid:

``` r
try(valid_devops_envs(devops_env = 3))
#> Error in "Invalid choice: {call}({deparse(choice)})" %>% stringr::str_glue() : 
#>   could not find function "%>%"
```

Invalid but non-strict:

``` r
valid_devops_envs(devops_env = 3, strict = FALSE)
#> named character(0)
```

### Use validation function inside of another function

``` r
foo <- function(
  devops_env = valid_devops_envs("dev")
) {
  devops_env <- match.arg(devops_env, valid_devops_envs())
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
#> Error in "Invalid choice: {call}({deparse(choice)})" %>% stringr::str_glue() : 
#>   could not find function "%>%"
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
