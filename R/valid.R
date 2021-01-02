#' Generic validation function
#'
#' @param choice
#' @param choices
#' @param reverse
#' @param flip
#' @param strict
#'
#' @return
#' @export
#'
#' @examples
valid_generic_ <- function(
  choice = character(),
  choices = character(),
  reverse = FALSE,
  flip = FALSE,
  strict = TRUE
) {
  out <- if (length(choice)) {
    # if (choice %in% names(choices)) {
    #   choices[choice]
    # }

    # Try via names
    out <- choices[choice]
    if (any(is.na(out))) {
      # Try via element matching
      out <- choices[choices == choice]
    }
    out
  } else {
    choices
  }

  out <- if (!flip) {
    out
  } else {
    # Flip names and values
    out <- flip_values_and_names(out)
  }

  out <- if (!reverse) {
    out
  } else {
    rev(out)
  }

  if (!length(out) && strict) {
    call <- as.character(sys.call(-1)[[1]])
    stop("Invalid choice: {call}({deparse(choice)})" %>%
        stringr::str_glue())
  }

  out
}

#' Flip values and names
#'
#' @param x
#'
#' @return Same structure as before, but names as values and values as names
flip_values_and_names <- function(x) {
  names <- x
  x <- names(x)
  names(x) <- names
  x
}
