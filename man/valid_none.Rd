% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/valid.R
\name{valid_none}
\alias{valid_none}
\title{Valid: none}
\usage{
valid_none(choice = character(), ...)
}
\arguments{
\item{choice}{(\link{character}) Selection from available valid choices}

\item{...}{Further arguments that should be passed to \code{\link[=valid]{valid()}}}
}
\value{

}
\description{
Valid: none
}
\examples{
valid_none()
valid_none("none")
try(valid_none("invalid"))
valid_none(reverse = TRUE)
valid_none(flip = TRUE)
valid_none(unname = TRUE)
}
