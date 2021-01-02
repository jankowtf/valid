test_that("Flip", {
  result <- flip_values_and_names(
    x = letters[1:3] %>% purrr::set_names(LETTERS[1:3])
  )

  target <- c(a = "A", b = "B", c = "C")

  expect_identical(result, target)
})
