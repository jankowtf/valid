# No choice ---------------------------------------------------------------

test_that("No choice", {
  result <- valid(
    choices = letters[1:3]
  )

  target <- c("a", "b", "c")

  expect_identical(result, target)
})

test_that("No choice: reverse", {
  result <- valid(
    choices = letters[1:3],
    reverse = TRUE
  )

  target <- c("a", "b", "c") %>% rev()

  expect_identical(result, target)
})

test_that("No choice: flip", {
  result <- valid(
    choices = letters[1:3] %>%
      purrr::set_names(LETTERS[1:3]),
    flip = TRUE
  )

  target <- LETTERS[1:3] %>%
    purrr::set_names(c("a", "b", "c"))

  expect_identical(result, target)
})

# Value choice ------------------------------------------------------------

test_that("Choice: value", {
  result <- valid(
    choice = letters[1],
    choices = letters[1:3]
  )

  target <- "a"

  expect_identical(result, target)
})

test_that("Choice: value: invalid", {
  expect_error(
    valid(
      choice = letters[4],
      choices = letters[1:3]
    )
  )
})

test_that("Choice: value: invalid: non-strict", {
  result <- valid(
    choice = letters[4],
    choices = letters[1:3],
    strict = FALSE
  )

  target <- character()

  expect_identical(result, target)
})

# Index choice ------------------------------------------------------------

test_that("Choice: index", {
  result <- valid(
    choice = 1,
    choices = letters[1:3]
  )

  target <- "a"

  expect_identical(result, target)
})

test_that("Choice: index: invalid", {
  expect_error(
    valid(
      choice = 4,
      choices = letters[1:3]
    )
  )
})

test_that("Choice: index: invalid: non-strict", {
  result <- valid(
    choice = 4,
    choices = letters[1:3],
    strict = FALSE
  )

  target <- character()

  expect_identical(result, target)
})
