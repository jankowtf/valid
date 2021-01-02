# Test fixture ------------------------------------------------------------

valid_devops_envs <- function(
  devops_env = character(),
  reverse = FALSE,
  flip = FALSE,
  strict = TRUE
) {
  values <- c("dev", "prod")
  names(values) <- values

  valid(
    choice = devops_env,
    choices = values,
    reverse = reverse,
    flip = flip,
    strict = strict
  )
}

# No choice ---------------------------------------------------------------

test_that("No choice", {
  result <- valid_devops_envs()

  target <- c("dev", "prod") %>%
    purrr::set_names(.)

  expect_identical(result, target)
})

test_that("No choice: reverse", {
  result <- valid_devops_envs(
    reverse = TRUE
  )

  target <- c("dev", "prod") %>%
    rev() %>%
    purrr::set_names(.)

  expect_identical(result, target)
})

test_that("No choice: flip", {
  result <- valid_devops_envs(
    flip = TRUE
  )

  target <- c("dev", "prod") %>%
    purrr::set_names(.)

  expect_identical(result, target)
})

# Value choice ------------------------------------------------------------

test_that("Choice: value: valid", {
  result <- valid_devops_envs(
    devops_env = "dev"
  )

  target <- c(dev = "dev")

  expect_identical(result, target)
})

test_that("Choice: value: invalid", {
  expect_error(
    valid_devops_envs(
      devops_env = "abc"
    ),
    regexp = 'Invalid choice: valid_devops_envs\\("abc\"\\)'
  )
})

test_that("Choice: value: invalid: non-strict", {
  result <- valid_devops_envs(
    devops_env = "abc",
    strict = FALSE
  )

  target <- c(x = "x")[0]

  expect_identical(result, target)
})

# Index choice ------------------------------------------------------------

test_that("Choice: value: index", {
  result <- valid_devops_envs(
    devops_env = 2
  )

  target <- c(prod = "prod")

  expect_identical(result, target)
})

test_that("Choice: index: invalid", {
  expect_error(
    valid_devops_envs(
      devops_env = 3
    ),
    regexp = "Invalid choice: valid_devops_envs\\(3\\)"
  )
})

test_that("Choice: index: invalid: non-strict", {
  result <- valid_devops_envs(
    devops_env = 3,
    strict = FALSE
  )

  target <- c(x = "x")[0]

  expect_identical(result, target)
})
