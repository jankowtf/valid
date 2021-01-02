
# Ignore ------------------------------------------------------------------

usethis::use_build_ignore("scripts/.*", escape = FALSE)

# Tests -------------------------------------------------------------------

usethis::use_test("valid_generic")
usethis::use_test("valid_example")
usethis::use_test("flip")
