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

  result <- valid_yes_no("Yes")
  expected <- c("yes" = "Yes")
  expect_identical(result, expected)

  expect_error(valid_yes_no("YES"))
  result <- valid_yes_no(c("Yes", "NO"), strict = FALSE)
  expected <- c("yes" = "Yes")
  expect_identical(result, expected)
})

# Keep/reset --------------------------------------------------------------

test_that("Keep/reset", {
    result <- valid_keep_reset()
    expected <- c(keep = "Keep", reset = "Reset")
    expect_identical(result, expected)

    result <- valid_keep_reset("Keep")
    expected <- c(keep = "Keep")
    expect_identical(result, expected)

    expect_error(valid_keep_reset("KEEP"))
    result <- valid_keep_reset(c("Keep", "RESET"), strict = FALSE)
    expected <- c(keep = "Keep")
    expect_identical(result, expected)
})

# Again/exit --------------------------------------------------------------

test_that("Again/exit", {
  result <- valid_again_exit()
  expected <- c(again = "Let me start over", exit = "Exit")
  expect_identical(result, expected)
})

# Yes/no/again_exit ---------------------------------------------------

test_that("Yes/no/again/exit", {
    result <- valid_yes_no_again_exit()
    expected <- c(yes = "Yes", no = "No", again = "Let me start over", exit = "Exit"
    )
    expect_identical(result, expected)

    result <- valid_yes_no_again_exit("No")
    expected <- c(no = "No")
    expect_identical(result, expected)

    expect_error(valid_yes_no_again_exit("NO"))
    result <- valid_yes_no_again_exit(c("Yes", "NO"), strict = FALSE)
    expected <- c(yes = "Yes")
    expect_identical(result, expected)
})


# Keep/reset/again_exit ---------------------------------------------------

test_that("Keep/reset/again/exit", {
    result <- valid_keep_reset_again_exit()
    expected <- c(keep = "Keep", reset = "Reset", again = "Let me start over",
        exit = "Exit")
    expect_identical(result, expected)

    result <- valid_keep_reset_again_exit("Reset")
    expected <- c(reset = "Reset")
    expect_identical(result, expected)

    expect_error(valid_keep_reset_again_exit("KEEP"))
    result <- valid_keep_reset_again_exit(c("Keep", "RESET"), strict = FALSE)
    expected <- c(keep = "Keep")
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
