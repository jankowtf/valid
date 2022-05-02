
# Ignore ------------------------------------------------------------------

usethis::use_build_ignore("devops/.*", escape = FALSE)

# Dev dependencies --------------------------------------------------------

renv::install("devtools")
renv::install("testthat")
renv::install("yaml")
renv::install("htmltools")
renv::install("rmarkdown")
renv::install("tinytex")
renv::install("pdflatex")

# Tests -------------------------------------------------------------------

usethis::use_test("valid_generic")
usethis::use_test("valid_example")
usethis::use_test("flip")
usethis::use_test("valids")
usethis::use_test("is_valid")

# Dev notebook ------------------------------------------------------------

usethis::use_package_doc()
usethis::use_pipe()
usethis::use_version("dev")
