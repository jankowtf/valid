#' Generic validation function
#'
#' Designed to be called *inside* a custom`valid_*` function (e.g. [valid_yes_no()])
#'
#' @param choice ([character]) Available values
#' @param choices ([character]) Selection of available values
#' @param reverse ([logical]) Reverse order yes/no
#' @param flip ([logical]) Flip names and values yes/no
#' @param strict ([logical]) Be strict about "things that might go wrong" yes/no
#' @param unname ([logical]) Drop names yes/no
#' @param call ([call]) Enclosing call
#'
#' @return
#' @export
#'
#' @examples
#' valid_foo <- function(
#'   choice = character(),
#'   ...
#' ) {
#'   choices <- letters[1:3]
#'
#'   names(choices) <- choices %>% toupper()
#'
#'   valid::valid(
#'     choice = choice,
#'     choices = choices,
#'     ...
#'   )
#' }
#' valid_foo()
#' # Via name
#' valid_foo("A")
#' valid_foo("A", "C")
#' # Via value
#' valid_foo("a")
#' valid_foo("a", "c")
#' # Handling obvious errors
#' try(valid_foo("D"))
#' try(valid_foo("d"))
#' # Handling partial errors
#' try(valid_foo("A", "D"))
#' try(valid_foo("A", "D", .strict = FALSE))
#' try(valid_foo("a", "d"))
#' try(valid_foo("a", "d", .strict = FALSE))
valid <- function(
    choice = character(),
    choices = character(),
    reverse = FALSE,
    flip = FALSE,
    strict = TRUE,
    unname = FALSE,
    call = sys.call(-1)[[1]]
) {
    # Choose
    out <- if (length(choice)) {
        choice_type <- handle_choice_type(
            choice = choice,
            choices = choices
        )

        valid_invalid <- handle_valid_invalid(
            choice = choice,
            choices = choices,
            choice_type = choice_type
        )
        valid <- valid_invalid$valid
        invalid <- valid_invalid$invalid

        handle_message(
            valid = valid,
            invalid = invalid,
            choices = choices,
            call = call,
            strict = strict
        )

        valid
    } else {
        choices
    }

    # Reverse
    out <- if (!reverse) {
        out
    } else {
        rev(out)
    }

    # Flip
    out <- if (!flip) {
        out
    } else {
        # Flip names and values
        out <- flip_values_and_names(out)
    }

    # Strict yes/no
    if (!length(out) && strict) {
        stop("Invalid choice: {call}({deparse(choice)})" %>%
                stringr::str_glue())
    }

    # Unname
    out <- if (unname) {
        out %>% unname()
    } else {
        out
    }

    out
}

#' Alternative generic validation function
#'
#' Designed to be called *inside* a custom`valid_*` function (e.g. [valid_yes_no()])
#'
#' @param ... ([character]) Selection of available values
#' @param .choices ([character]) Available values
#' @param .reverse ([logical]) Reverse order yes/no
#' @param .flip ([logical]) Flip names and values yes/no
#' @param .strict ([logical]) Be strict about "things that might go wrong" yes/no
#' @param .unname ([logical]) Drop names yes/no
#'
#' @return
#' @export
#'
#' @examples
#' valid_foo <- function(
#'   ...
#' ) {
#'   choices <- letters[1:3]
#'
#'   names(choices) <- choices %>% toupper()
#'
#'   valid::valid2(
#'     ...,
#'     .choices = choices
#'   )
#' }
#' valid_foo()
#' # Via name
#' valid_foo("A")
#' valid_foo("A", "C")
#' # Via value
#' valid_foo("a")
#' valid_foo("a", "c")
#' # Handling obvious errors
#' try(valid_foo("D"))
#' try(valid_foo("d"))
#' # Handling partial errors
#' try(valid_foo("A", "D"))
#' try(valid_foo("A", "D", .strict = FALSE))
#' try(valid_foo("a", "d"))
#' try(valid_foo("a", "d", .strict = FALSE))
valid2 <- function(
    ...,
    .choices = character(),
    .reverse = FALSE,
    .flip = FALSE,
    .strict = TRUE,
    .unname = FALSE
) {
    choice <- rlang::list2(...) %>% unlist()

    call <- as.character(sys.call(-1)[[1]])

    return(valid(
        choice = choice,
        choices = .choices,
        reverse = .reverse,
        flip = .flip,
        strict = .strict,
        unname = .unname,
        call = call
    ))
}

#' Is valid
#'
#' Convenience wrapper around using a `valid_*` function directly
#'
#' @param x [[chacter] or [integer]] A valid choice
#' @param valid_fn [[function]] The actual validation function
#' @param ... Additional arguments passed to `valid_fn`
#'
#' @return
#' @export
#'
#' @examples
#' is_valid("yes", valid_yes_no)
#' is_valid(c("yes", "no"), valid_yes_no)
#' try(is_valid("YES", valid_yes_no))
#' is_valid(c("yes", "NO"), valid_yes_no)
is_valid <- function(
    x,
    valid_fn,
    ...
) {
    valid_fn(x, ...)
}

handle_message <- function(
    valid,
    invalid,
    choices,
    call,
    strict
) {
    if (length(invalid)) {
        msg_valid <- c(
            "Valid choices:",
            choices
        ) %>% stringr::str_c("\n")

        msg_choice <- c(
            "Your choice:",
            c(valid, invalid)
        ) %>% stringr::str_c("\n")

        msg <- "Invalid choice: {call}({deparse(invalid)})" %>%
            stringr::str_glue()
        if (strict) {
            message(msg_choice)
            message(msg_valid)
            stop(msg, call. = FALSE)
        } else {
            warning(msg, call. = FALSE)
            message(msg_choice)
            message(msg_valid)
        }
    }
}


# Helpers ------------------------------------------------------------------

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
#' @param choice ([character]) Actual choice out of all available choices
#' @param ... Further arguments that will be passed to [valid::valid()]
#'
#' @return
#' @export
#'
#' @examples
#' valid_yes_no()
#' valid_yes_no("yes")
#' try(valid_yes_no("invalid"))
#' valid_yes_no(reverse = TRUE)
#' valid_yes_no(flip = TRUE)
#' valid_yes_no(unname = TRUE)
valid_yes_no <- function(
    choice = character(),
    ...
) {
    valid::valid(
        choice = choice,
        choices = c(
            yes = "Yes",
            no = "No"
        ),
        ...
    )
}

#' Valid: keep/reset
#'
#' @param choice ([character]) Actual choice out of all available choices
#' @param ... Further arguments that will be passed to [valid::valid()]
#'
#' @return
#' @export
#'
#' @examples
#' valid_keep_reset()
#' valid_keep_reset("keep")
#' try(valid_keep_reset("invalid"))
#' valid_keep_reset(reverse = TRUE)
#' valid_keep_reset(flip = TRUE)
#' valid_keep_reset(unname = TRUE)
valid_keep_reset <- function(
    choice = character(),
    ...
) {
    valid::valid(
        choice = choice,
        choices = c(
            keep = "Keep",
            reset = "Reset"
        ),
        ...
    )
}

#' Valid: again/exit
#'
#' @param choice ([character]) Selection from available valid choices
#' @param ... Further arguments that will be passed to [valid::valid()])]
#'
#' @return
#' @export
#' @examples
#' valid_again_exit()
#' valid_again_exit("again")
#' try(valid_again_exit("invalid"))
#' valid_again_exit(reverse = TRUE)
#' valid_again_exit(flip = TRUE)
#' valid_again_exit(unname = TRUE)
valid_again_exit <- function(
    choice = character(),
    ...
) {
    valid::valid(
        choice = choice,
        choices = c(
            again = "Let me start over",
            exit = "Exit"
        ),
        ...
    )
}

#' Valid: none
#'
#' @param choice ([character]) Selection from available valid choices
#' @param ... Further arguments that should be passed to [valid::valid()]
#'
#' @return
#' @export
#' @examples
#' valid_none()
#' valid_none("none")
#' try(valid_none("invalid"))
#' valid_none(reverse = TRUE)
#' valid_none(flip = TRUE)
#' valid_none(unname = TRUE)
valid_none <- function(
    choice = character(),
    ...
) {
    valid::valid(
        choice = choice,
        choices = c(
            none = "None"
        ),
        ...
    )
}

#' Valid: yes/no/again/exit
#'
#' @param choice ([character]) Selection from available valid choices
#' @param ... Further arguments that will be passed to [valid::valid()]
#'
#' @return
#' @export
#' @examples
#' valid_yes_no_again_exit()
#' valid_yes_no_again_exit("yes")
#' try(valid_yes_no_again_exit("invalid"))
#' valid_yes_no_again_exit(reverse = TRUE)
#' valid_yes_no_again_exit(flip = TRUE)
#' valid_yes_no_again_exit(unname = TRUE)
valid_yes_no_again_exit <- function(
    choice = character(),
    ...
) {
    valid::valid(
        choice = choice,
        choices = c(
            valid_yes_no(),
            valid_again_exit()
        ),
        ...
    )
}

#' Valid: keep/reset/again/exit
#'
#' @param choice ([character]) Selection from available valid choices
#' @param ... Further arguments that will be passed to [valid::valid()]
#'
#' @return
#' @export
#' @examples
#' valid_keep_reset_again_exit()
#' valid_keep_reset_again_exit("yes")
#' try(valid_keep_reset_again_exit("invalid"))
#' valid_keep_reset_again_exit(reverse = TRUE)
#' valid_keep_reset_again_exit(flip = TRUE)
#' valid_keep_reset_again_exit(unname = TRUE)
valid_keep_reset_again_exit <- function(
    choice = character(),
    ...
) {
    valid::valid(
        choice = choice,
        choices = c(
            valid_keep_reset(),
            valid_again_exit()
        ),
        ...
    )
}

# Authentication ----------------------------------------------------------

#' Valid authentication
#'
#' @param auth ([character]) Selection from available valid choices
#' @param ... Further arguments that will be passed to [valid::valid()]
#'
#' @return
#' @export
#' @examples
#' valid_authentication()
#' valid_authentication("ssh")
#' try(valid_authentication("invalid"))
#' valid_authentication(reverse = TRUE)
#' valid_authentication(flip = TRUE)
#' valid_authentication(unname = TRUE)
valid_authentication <- function(
    auth = character(),
    ...
) {
    auths <- c("ssh", "https")
    names(auths) <- auths
    valid::valid(
        choice = auth,
        choices = auths,
        ...
    )
}

# DevOps environments -----------------------------------------------------

#' Valid DevOps environments
#'
#' @param devops_env ([character]) Selection from available valid choices
#' @param ... Further arguments that will be passed to [valid::valid()]
#'
#' @return
#' @export
#' @examples
#' valid_devops_envs()
#' valid_devops_envs("staging")
#' try(valid_devops_envs("invalid"))
#' valid_devops_envs(reverse = TRUE)
#' valid_devops_envs(flip = TRUE)
#' valid_devops_envs(unname = TRUE)
valid_devops_envs <- function(
    devops_env = character(),
    ...
) {
    values <- c("dev", "staging", "prod")
    names(values) <- values

    valid::valid(
        choice = devops_env,
        choices = values,
        ...
    )
}

# Licenses ----------------------------------------------------------------

#' Valid licenses
#'
#' @param license [character] License choice
#' @param ... Further arguments that will be passed to [valid::valid()]#'
#' @return
#' @export
#' @examples
#' valid_licenses()
#' valid_licenses("gpl3)
#' try(valid_licenses("invalid"))
#' valid_licenses(reverse = TRUE)
#' valid_licenses(flip = TRUE)
#' valid_licenses(unname = TRUE)
valid_licenses <- function(
    license = character(),
    ...
) {
    licenses <- c("GPL v3", "MIT", "CC0", "CCBY 4.0", "LGPL v3", "APL 2.0", "AGPL v3")
    names <- c("gpl3", "mit", "cc0", "ccby", "lgpl", "apl2", "agpl3")
    names(licenses) <- names
    valid::valid(
        choice = license,
        choices = licenses,
        ...
    )
}

# Package dependencies ----------------------------------------------------

#' Valid dependency types
#'
#' @param type ([character]) Dependency type choice
#' @param ... Further arguments that will be passed to [valid::valid()]
#'
#' @return
#' @export
#' @examples
#' valid_dep_types()
#' valid_dep_types("Suggests")
#' try(valid_dep_types("invalid"))
#' valid_dep_types(reverse = TRUE)
#' valid_dep_types(flip = TRUE)
#' valid_dep_types(unname = TRUE)
valid_dep_types <- function(
    type = character(),
    ...
) {
    types <- c("Suggests", "Imports", "Depends", "Enhances", "LinkingTo")
    names(types) <- types
    valid::valid(
        choice = type,
        choices = types,
        ...
    )
}

# Storage -----------------------------------------------------------------

#' Valid remote storage
#'
#' @param storage ([character]) Selection from available valid choices
#' @param ... Further arguments that will be passed to [valid::valid2()]
#'
#' @return
#' @export
#' @examples
#' valid_storage_remote()
#' valid_storage_remote("gcp_s3")
#' try(valid_storage_remote("invalid"))
#' valid_storage_remote(reverse = TRUE)
#' valid_storage_remoten(flip = TRUE)
#' valid_storage_remote(unname = TRUE)
valid_storage_remote <- function(
    storage = character(),
    ...
) {
    storages <- c("aws_s3", "gcp_cs", "gcp_s3")
    names(storages) <- storages
    valid::valid2(
        storage,
        .choices = storages,
        ...
    )
}

#' Valid local storage
#'
#' @param storage ([character]) Selection from available valid choices
#' @param ... Further arguments that will be passed to [valid::valid2()]
#'
#' @return
#' @export
#' @examples
#' valid_storage_local()
#' valid_storage_local("fs")
#' try(valid_storage_local("invalid"))
#' valid_storage_local(reverse = TRUE)
#' valid_storage_localn(flip = TRUE)
#' valid_storage_local(unname = TRUE)
valid_storage_local <- function(
    storage = character(),
    ...
) {
    storages <- c("fs")
    names(storages) <- storages
    valid::valid2(
        storage,
        .choices = storages,
        ...
    )
}

#' Valid storage
#'
#' @param storage ([character]) Selection from available valid choices
#' @param ... Further arguments that will be passed to [valid::valid2()]
#'
#' @return
#' @export
#' @examples
#' valid_storage()
#' valid_storage("fs", "aws_s3)
#' try(valid_storage("invalid"))
#' valid_storage(reverse = TRUE)
#' valid_storage(flip = TRUE)
#' valid_storage(unname = TRUE)
valid_storage <- function(
    storage = character(),
    ...
) {
    storages <- c(valid_storage_local(), valid_storage_remote())
    names(storages) <- storages
    valid::valid2(
        storage,
        .choices = storages,
        ...
    )
}
