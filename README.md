
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

## How?

``` r
library(valid)
```

The actual workhorse is `valid()` while `valid2()` makes choice input a
bit more convenient via the `...` mechanism.

### Built-in functions

There are some built-in functions for typical validation tasks.

The number of such built-in functions will grow over time in a “scratch
my own itch” manner

``` r
valid_authentication()
#>     ssh   https 
#>   "ssh" "https"
valid_authentication("https")
#>   https 
#> "https"
valid_authentication(2)
#>   https 
#> "https"
try(valid_authentication("I don't exist"))
#> Error in valid::valid(choice = auth, choices = auths, ...) : 
#>   Invalid choice: valid_authentication("I don't exist")
try(valid_authentication(3))
#> Error in valid::valid(choice = auth, choices = auths, ...) : 
#>   Invalid choice: valid_authentication(3)

valid_dep_types()
#>    Suggests     Imports     Depends    Enhances   LinkingTo 
#>  "Suggests"   "Imports"   "Depends"  "Enhances" "LinkingTo"
valid_dep_types("Suggests")
#>   Suggests 
#> "Suggests"
try(valid_dep_types("I don't exist"))
#> Error in valid::valid(choice = type, choices = types, ...) : 
#>   Invalid choice: valid_dep_types("I don't exist")

valid_devops_envs()
#>       dev   staging      prod 
#>     "dev" "staging"    "prod"
valid_devops_envs("staging")
#>   staging 
#> "staging"
try(valid_devops_envs("I don't exist"))
#> Error in valid::valid(choice = devops_env, choices = values, ...) : 
#>   Invalid choice: valid_devops_envs("I don't exist")

valid_licenses()
#>       gpl3        mit        cc0       ccby       lgpl       apl2      agpl3 
#>   "GPL v3"      "MIT"      "CC0" "CCBY 4.0"  "LGPL v3"  "APL 2.0"  "AGPL v3"
valid_licenses("mit")
#>   mit 
#> "MIT"
try(valid_licenses("I don't exist"))
#> Error in valid::valid(choice = license, choices = licenses, ...) : 
#>   Invalid choice: valid_licenses("I don't exist")
```

You can reverse the order or flip names and values

``` r
valid_devops_envs(reverse = TRUE)
#>      prod   staging       dev 
#>    "prod" "staging"     "dev"
valid_devops_envs(flip = TRUE) # doesn't really make sense in this case as both is lowercase
#>       dev   staging      prod 
#>     "dev" "staging"    "prod"
valid_devops_envs(unname = TRUE)
#> [1] "dev"     "staging" "prod"
```

### Custom function

#### Definition

You can build your functions on top of `valid::valid()`

``` r
my_valid_devops_envs <- function(
  x = character(),
  ...
) {
  choices <- c("dev", "staging", "prod")
  names(choices) <- toupper(choices)

  valid(
    choice = x,
    choices = choices,
    ...
  )
}

my_valid_devops_envs2 <- function(
  ...
) {
  choices <- c("dev", "staging", "prod")
  names(choices) <- toupper(choices)

  valid2(
    ...,
    .choices = choices
  )
}
```

#### Apply without explicit choice

``` r
my_valid_devops_envs()
#>       DEV   STAGING      PROD 
#>     "dev" "staging"    "prod"
```

``` r
my_valid_devops_envs(reverse = TRUE)
#>      PROD   STAGING       DEV 
#>    "prod" "staging"     "dev"
```

``` r
my_valid_devops_envs(flip = TRUE)
#>       dev   staging      prod 
#>     "DEV" "STAGING"    "PROD"
```

``` r
my_valid_devops_envs(unname = TRUE)
#> [1] "dev"     "staging" "prod"
```

``` r
my_valid_devops_envs(flip = TRUE, unname = TRUE)
#> [1] "DEV"     "STAGING" "PROD"
```

#### Choice via name

Valid:

``` r
my_valid_devops_envs("PROD")
#>   PROD 
#> "prod"
```

``` r
my_valid_devops_envs(c("STAGING", "PROD"))
#>   STAGING      PROD 
#> "staging"    "prod"
my_valid_devops_envs2("STAGING", "PROD")
#>   STAGING      PROD 
#> "staging"    "prod"
```

Invalid:

``` r
try(my_valid_devops_envs("ABC"))
#> Error in valid(choice = x, choices = choices, ...) : 
#>   Invalid choice: my_valid_devops_envs("ABC")
```

``` r
my_valid_devops_envs("ABC", strict = FALSE)
#> named character(0)
```

Partially invalid:

``` r
try(my_valid_devops_envs(x = c("DEV", "ABC")))
#> Error in valid(choice = x, choices = choices, ...) : 
#>   Invalid choice: my_valid_devops_envs("ABC")
try(my_valid_devops_envs2("DEV", "ABC"))
#> Error in valid(choice = choice, choices = .choices, reverse = .reverse,  : 
#>   Invalid choice: my_valid_devops_envs2("ABC")
```

``` r
my_valid_devops_envs(x = c("DEV", "ABC"), strict = FALSE)
#>   DEV 
#> "dev"
my_valid_devops_envs2("DEV", "ABC", .strict = FALSE)
#>   DEV 
#> "dev"
```

#### Choice via value

Valid:

``` r
my_valid_devops_envs("dev")
#>   DEV 
#> "dev"
```

``` r
my_valid_devops_envs(c("dev", "staging"))
#>       DEV   STAGING 
#>     "dev" "staging"
my_valid_devops_envs2("dev", "staging")
#>       DEV   STAGING 
#>     "dev" "staging"
```

Invalid:

``` r
try(my_valid_devops_envs("abc"))
#> Error in valid(choice = x, choices = choices, ...) : 
#>   Invalid choice: my_valid_devops_envs("abc")
```

``` r
my_valid_devops_envs("abc", strict = FALSE)
#> named character(0)
```

Partially invalid

``` r
try(my_valid_devops_envs(c("dev", "abc")))
#> Error in valid(choice = x, choices = choices, ...) : 
#>   Invalid choice: my_valid_devops_envs("abc")
try(my_valid_devops_envs2("dev", "abc"))
#> Error in valid(choice = choice, choices = .choices, reverse = .reverse,  : 
#>   Invalid choice: my_valid_devops_envs2("abc")
```

``` r
my_valid_devops_envs(c("dev", "abc"), strict = FALSE)
#>   DEV 
#> "dev"
my_valid_devops_envs2("dev", "abc", .strict = FALSE)
#>   DEV 
#> "dev"
```

#### Choice via index/position

Valid:

``` r
my_valid_devops_envs(2)
#>   STAGING 
#> "staging"
```

``` r
my_valid_devops_envs(c(2, 3))
#>   STAGING      PROD 
#> "staging"    "prod"
my_valid_devops_envs2(2, 3)
#>   STAGING      PROD 
#> "staging"    "prod"
```

Invalid:

``` r
try(my_valid_devops_envs(4))
#> Error in valid(choice = x, choices = choices, ...) : 
#>   Invalid choice: my_valid_devops_envs(4)
```

``` r
my_valid_devops_envs(4, strict = FALSE)
#> named character(0)
```

Partially invalid:

``` r
try(my_valid_devops_envs(x = c(1, 4)))
#> Error in valid(choice = x, choices = choices, ...) : 
#>   Invalid choice: my_valid_devops_envs(4)
try(my_valid_devops_envs2(1, 4))
#> Error in valid(choice = choice, choices = .choices, reverse = .reverse,  : 
#>   Invalid choice: my_valid_devops_envs2(4)
```

``` r
my_valid_devops_envs(x = c(1, 4), strict = FALSE)
#>   DEV 
#> "dev"
my_valid_devops_envs2(1, 4, .strict = FALSE)
#>   DEV 
#> "dev"
```

### Use validation function inside of another function

``` r
foo <- function(
  devops_env = my_valid_devops_envs2("dev")
) {
  # Input validation
  devops_env <- match.arg(devops_env, my_valid_devops_envs2())
  
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
  devops_env = my_valid_devops_envs2("dev")
)
#> DevOps env: dev
```

``` r
try(
  foo(
    devops_env = my_valid_devops_envs2("abc")
  )
)
#> Error in valid(choice = choice, choices = .choices, reverse = .reverse,  : 
#>   Invalid choice: my_valid_devops_envs2("abc")
```

``` r
try(
  foo(
    devops_env = my_valid_devops_envs2("dev", "abc")
  )
)
#> Error in valid(choice = choice, choices = .choices, reverse = .reverse,  : 
#>   Invalid choice: my_valid_devops_envs2("abc")
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
#> Error in match.arg(devops_env, my_valid_devops_envs2()) : 
#>   'arg' should be one of "dev", "staging", "prod"
```

## Code of Conduct

Please note that the valid project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
