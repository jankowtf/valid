# No choice ---------------------------------------------------------------

test_that("No choice", {
    result <- valid2(
        .choices = letters[1:3]
    )

    target <- c("a", "b", "c")

    expect_identical(result, target)
})

test_that("No choice: reverse", {
    result <- valid2(
        .choices = letters[1:3],
        .reverse = TRUE
    )

    target <- c("a", "b", "c") %>% rev()

    expect_identical(result, target)
})

test_that("No choice: flip", {
    result <- valid2(
        .choices = letters[1:3] %>%
            purrr::set_names(LETTERS[1:3]),
        .flip = TRUE
    )

    target <- LETTERS[1:3] %>%
        purrr::set_names(c("a", "b", "c"))

    expect_identical(result, target)
})

# Name choice -------------------------------------------------------------

test_that("Choice: names", {
    result <- valid2(
        LETTERS[1],
        .choices = structure(letters[1:3], names = LETTERS[1:3])
    )
    target <- c(A = "a")
    expect_identical(result, target)

    result <- valid2(
        LETTERS[1:2],
        .choices = structure(letters[1:3], names = LETTERS[1:3])
    )
    target <- c(A = "a", B = "b")
    expect_identical(result, target)

    result <- valid2(
        LETTERS[1:2],
        .choices = structure(letters[1:3], names = LETTERS[1:3]),
        .reverse = TRUE,
        .unname = TRUE
    )
    target <- c("b", "a")
    expect_identical(result, target)
})

test_that("Choice: names: invalid", {
    expect_error(
        valid2(
            LETTERS[4],
            .choices = structure(letters[1:3], names = LETTERS[1:3]),
        )
    )

    expect_error(
        valid2(
            LETTERS[c(1, 4)],
            .choices = structure(letters[1:3], names = LETTERS[1:3]),
        )
    )
})

test_that("Choice: names: invalid: non-strict", {
    result <- valid2(
        letters[4],
        .choices = letters[1:3],
        .strict = FALSE
    )
    target <- character()
    expect_identical(result, target)

    result <- valid2(
        letters[c(1, 4)],
        .choices = structure(letters[1:3], names = LETTERS[1:3]),
        .strict = FALSE
    )
    target <- c(A = "a")
    expect_identical(result, target)
})

# Value choice ------------------------------------------------------------

test_that("Choice: values", {
    result <- valid2(
        letters[1],
        .choices = letters[1:3]
    )
    target <- "a"
    expect_identical(result, target)

    result <- valid2(
        letters[1:2],
        .choices = letters[1:3]
    )
    target <- c("a", "b")
    expect_identical(result, target)

    result <- valid2(
        "a",
        "b",
        .choices = letters[1:3]
    )
    target <- c("a", "b")
    expect_identical(result, target)

    result <- valid2(
        letters[1:2],
        .choices = letters[1:3],
        .reverse = TRUE
    )
    target <- c("b", "a")
    expect_identical(result, target)
})

test_that("Choice: values: invalid", {
    expect_error(
        valid2(
            letters[4],
            .choices = letters[1:3]
        )
    )

    expect_error(
        valid2(
            "a",
            "d",
            .choices = letters[1:3]
        )
    )
})

test_that("Choice: values: invalid: non-strict", {
    result <- valid2(
        letters[4],
        .choices = letters[1:3],
        .strict = FALSE
    )
    target <- character()
    expect_identical(result, target)

    result <- valid2(
        "a",
        "d",
        .choices = letters[1:3],
        .strict = FALSE
    )
    target <- "a"
    expect_identical(result, target)
})

# Index choice ------------------------------------------------------------

test_that("Choice: indexes", {
    result <- valid2(
        1,
        .choices = letters[1:3]
    )
    target <- "a"
    expect_identical(result, target)

    result <- valid2(
        1, 3,
        .choices = letters[1:3]
    )
    target <- c("a", "c")
    expect_identical(result, target)

    result <- valid2(
        1, 3,
        .choices = letters[1:3],
        .reverse = TRUE
    )
    target <- c("c", "a")
    expect_identical(result, target)
})

test_that("Choice: indexes: invalid", {
    expect_error(
        valid2(
            4,
            .choices = letters[1:3]
        )
    )
})

test_that("Choice: indexes: invalid: non-strict", {
    result <- valid2(
        4,
        .choices = letters[1:3],
        .strict = FALSE
    )

    target <- character()

    expect_identical(result, target)
})

# Foo ---------------------------------------------------------------------

valid_foo <- function(
    ...
) {
    choices <- letters[1:3]

    names(choices) <- choices %>% toupper()

    valid::valid2(
        ...,
        .choices = choices
    )
}

test_that("Foo", {
    result <- valid_foo()
    expected <- c(A = "a", B = "b", C = "c")
    expect_identical(result, expected)
})

test_that("Foo: reverse", {
    result <- valid_foo(.reverse = TRUE)
    expected <- c(C = "c", B = "b", A = "a")
    expect_identical(result, expected)
})

test_that("Foo: flip", {
    result <- valid_foo(.flip = TRUE)
    expected <- c(a = "A", b = "B", c = "C")
    expect_identical(result, expected)
})

test_that("Foo: unname", {
    result <- valid_foo(.unname = TRUE)
    expected <- c("a", "b", "c")
    expect_identical(result, expected)
})

test_that("Foo: char", {
    result <- valid_foo("a", "c")
    expected <- c(A = "a", C = "c")
    expect_identical(result, expected)

    result <- valid_foo("A", "C")
    expected <- c(A = "a", C = "c")
    expect_identical(result, expected)

    result <- valid_foo("a", "c", .reverse = TRUE)
    expected <- c(C = "c", A = "a")
    expect_identical(result, expected)
})

test_that("Foo: char: (partially) invalid", {
    expect_error(valid_foo("d"))
    expect_error(valid_foo("D"))

    expect_error(valid_foo("a", "d"))
    result <- valid_foo("a", "d", .strict = FALSE)
    expected <- c(A = "a")
    expect_identical(result, expected)

    expect_error(valid_foo("A", "D"))
    result <- valid_foo("A", "D", .strict = FALSE)
    expected <- c(A = "a")
    expect_identical(result, expected)

    expect_error(valid_foo("a", "D"))
    result <- valid_foo("a", "D", .strict = FALSE)
    expected <- c(A = "a")
    expect_identical(result, expected)

    expect_error(valid_foo("a", "B"))
    result <- valid_foo("a", "B", .strict = FALSE)
    expected <- c(B = "b")
    expect_identical(result, expected)
})
