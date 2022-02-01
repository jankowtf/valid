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
valid <- function(
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

# Helpers ------------------------------------------------------------------

#' Is answer really TRUE or FALSE?
#'
#' @param answer ([character]) Answer
#'
#' @return
#' @export
is_answer_true_false <- function(answer) {
  # answer %>%
  #   not_in(
  #     c(valid_again_exit(flip = TRUE), valid_none(flip = TRUE))
  #   )

  answer %>%
    `%in%`(valid_yes_no(flip = TRUE))
}

#' Check if not in set
#'
#' @param x ([character])
#' @param set ([character])
#'
#' @return ([logical(1)])
not_in <- function(x, set) {
  !(x %in% set)
}

# Answers to choices ------------------------------------------------------

#' Valid: yes/no
#'
#' @param choice [character] Actual choice out of all available choices
#' @param flip ([logical]) Flip the vector's order?
#'
#' @return
#' @export
valid_yes_no <- function(choice = character(), flip = FALSE) {
  valid::valid(
    choice = choice,
    choices = c(
      yes = "Yes",
      no = "No"
    ),
    flip = flip
  )
}

#' Valid: again/exit
#'
#' @param choice [character] Actual choice out of all available choices
#' @param flip ([logical]) Flip the vector's order?
#'
#' @return
#' @export
valid_again_exit <- function(choice = character(), flip = FALSE) {
  valid::valid(
    choice = choice,
    choices = c(
      again = "Let me start over",
      exit = "Exit"
    ),
    flip = flip
  )
}

#' Valid: none
#'
#' @param choice [character] Actual choice out of all available choices
#' @param flip ([logical]) Flip the vector's order?
#'
#' @return
#' @export
valid_none <- function(choice = character(), flip = FALSE) {
  valid::valid(
    choice = choice,
    choices = c(
      none = "None"
    ),
    flip = flip
  )
}

#' Valid: yes/no/again/exit
#'
#' @param choice [character] Actual choice out of all available choices
#' @param flip ([logical]) Flip the vector's order?
#'
#' @return
#' @export
valid_yes_no_again_exit <- function(choice = character(), flip = FALSE) {
  valid::valid(
    choice = choice,
    choices = c(
      valid_yes_no(),
      valid_again_exit()
    ),
    flip = flip
  )
}

# Licenses ----------------------------------------------------------------

#' Valid: licenses
#'
#' @param license [character] License choice
#' @param flip ([logical]) Flip the vector's order?
#'
#' @return
#' @export
valid_licenses <- function(license = character(), flip = FALSE) {
  licenses <- c("GPL v3", "MIT", "CC0", "CCBY 4.0", "LGPL v3", "APL 2.0", "AGPL v3")
  names <- c("gpl3", "mit", "cc0", "ccby", "lgpl", "apl2", "agpl3")
  names(licenses) <- names
  valid::valid(
    choice = license,
    choices = licenses,
    flip = flip
  )
}

# Authentication ----------------------------------------------------------

#' Valid: authentication
#'
#' @param auth ([character]) Authentication choice
#' @param flip ([logical]) Flip the vector's order?
#'
#' @return
#' @export
valid_authentication <- function(auth = character(), flip = FALSE) {
  auths <- c("ssh", "https")
  names(auths) <- auths
  valid::valid(
    choice = auth,
    choices = auths,
    flip = flip
  )
}

# Package dependencies ----------------------------------------------------

#' Valid: dependency types
#'
#' @param type ([character]) Dependency type choice
#' @param flip ([logical]) Flip the vector's order?
#'
#' @return
#' @export
valid_dep_types <- function(type = character(), flip = FALSE) {
  types <- c("Suggests", "Imports", "Depends", "Enhances", "LinkingTo")
  names(types) <- types
  valid::valid(
    choice = type,
    choices = types,
    flip = flip
  )
}
