source("renv/activate.R")

set_options <- function (
  repos = c(RSPM = "https://packagemanager.rstudio.com/all/__linux__/focal/latest"),
  pkgType = "binary"
) {
  options(repos = repos, pkgType = pkgType)
  renv::settings$snapshot.type("all")
}

set_options()
rm(set_options)
