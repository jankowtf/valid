# Foo ---------------------------------------------------------------------

valid_foo <- function(
  choice = character(),
  ...
) {
  choices <- letters[1:3]

  names(choices) <- choices %>% toupper()

  valid::valid(
    choice = choice,
    choices = choices,
    ...
  )
}

test_that("Foo", {
  result <- valid_foo()
  expected <- c(A = "a", B = "b", C = "c")
  expect_identical(result, expected)
})

test_that("Foo: reverse", {
  result <- valid_foo(reverse = TRUE)
  expected <- c(C = "c", B = "b", A = "a")
  expect_identical(result, expected)
})

test_that("Foo: flip", {
  result <- valid_foo(flip = TRUE)
  expected <- c(a = "A", b = "B", c = "C")
  expect_identical(result, expected)
})

test_that("Foo: unname", {
  result <- valid_foo(unname = TRUE)
  expected <- c("a", "b", "c")
  expect_identical(result, expected)
})

# Helpers -----------------------------------------------------------------

test_that("Is", {
  result <- "yes" %>% is_answer_true_false()
  expect_true(result)

  result <- "no" %>% is_answer_true_false()
  expect_true(result)

  result <- "exit" %>% is_answer_true_false()
  expect_false(result)

  result <- "abc" %>% is_answer_true_false()
  expect_false(result)
})

# Yes/no ------------------------------------------------------------------

test_that("Yes/no", {
  result <- valid_yes_no()
  expected <- structure(c("Yes", "No"), names = c("yes", "no"))
  expect_identical(result, expected)
})

# Again/exit --------------------------------------------------------------

test_that("Again/exit", {
  result <- valid_again_exit()
  expected <- c(again = "Let me start over", exit = "Exit")
  expect_identical(result, expected)
})

# None --------------------------------------------------------------------

test_that("None", {
  result <- valid_none()
  expected <- c(none = "None")
  expect_identical(result, expected)
})

test_that("Yes/no/again/exit", {
  result <- valid_yes_no_again_exit()
  expected <- c(
    yes = "Yes",
    no = "No",
    again = "Let me start over",
    exit = "Exit"
  )
  expect_identical(result, expected)
})

# Authentication ----------------------------------------------------------

test_that("Authentication", {
  result <- valid_authentication()
  expected <- c(ssh = "ssh", https = "https")
  expect_identical(result, expected)
})

# DevOps environments -----------------------------------------------------

test_that("DevOps environments", {
  result <- valid_devops_envs()
  expected <- c(dev = "dev", staging = "staging", prod = "prod")
  expect_identical(result, expected)
})

# Licenses ----------------------------------------------------------------

test_that("Licenses", {
  result <- valid_licenses()
  expected <-
    c(
      gpl3 = "GPL v3",
      mit = "MIT",
      cc0 = "CC0",
      ccby = "CCBY 4.0",
      lgpl = "LGPL v3",
      apl2 = "APL 2.0",
      agpl3 = "AGPL v3"
    )
  expect_identical(result, expected)
})

# Package dependency types ------------------------------------------------

test_that("Package dependency types", {
  result <- valid_dep_types()
  expected <-
    c(
      Suggests = "Suggests",
      Imports = "Imports",
      Depends = "Depends",
      Enhances = "Enhances",
      LinkingTo = "LinkingTo"
    )
  expect_identical(result, expected)
})
