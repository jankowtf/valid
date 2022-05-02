test_that("valid", {
    result <- is_valid("yes", valid_fn = valid_yes_no)
    expected <- valid_yes_no("yes")
    expect_identical(result, expected)
})

test_that("valid multiple", {
    result <- is_valid(c("yes", "no"), valid_fn = valid_yes_no)
    expected <- valid_yes_no()
    expect_identical(result, expected)
})

test_that("invalid", {
    result <- expect_error(is_valid("NO", valid_fn = valid_yes_no))
})

test_that("mixed", {
    result <- expect_error(is_valid(c("yes", "NO"), valid_fn = valid_yes_no))

    result <- is_valid(c("yes", "NO"), valid_fn = valid_yes_no, strict = FALSE)
    expected <- valid_yes_no("yes")
    expect_identical(result, expected)
})
