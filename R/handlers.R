handle_choice_type <- function(choice, choices) {
    choice_type <- if (!is.null(names <- names(choices))) {
        check <- choice %in% names
        if (all(check)) {
            "names"
        } else if (all(!check)) {
            "names_invalid"
        } else if (any(check)) {
            "names_invalid_partial"
        } else {
            stop("Unsuppported logical case")
        }
    } else {
        "other"
    }

    choice_type <- if (choice_type %in%  c("other", "names_invalid")) {
        check <- if (typeof(choice) == typeof(choices)) {
            choice %in% choices
        } else {
            FALSE
        }
        if (all(check)) {
            "values"
        } else if (all(!check)) {
            "values_invalid"
        } else if (any(check)) {
            "values_invalid_partial"
        } else {
            stop("Unsuppported logical case")
        }
    } else {
        choice_type
    }

    choice_type <- if (choice_type %in% c("other", "values_invalid")) {
        check <- choice %in% 1:length(choices)
        if (all(check)) {
            "index"
        } else if (all(!check)) {
            "index_invalid"
        } else if (any(check)) {
            "index_invalid_partial"
        } else {
            stop("Unsuppported logical case")
        }
    } else {
        choice_type
    }

    if (choice_type == "other") {
        stop("Unsupported logical case (second order)")
    }

    choice_type
}

handle_valid_invalid <- function(
    choice,
    choices,
    choice_type
) {
    if (choice_type %in% c("names", "names_invalid", "names_invalid_partial")) {
        valid <- choices[choice]
        index <- !(choice %in% names(choices))
        invalid <- choice[index]
    } else if (choice_type %in% c("values", "values_invalid", "values_invalid_partial")) {
        valid <- choices[choices %in% choice]
        index <- !(choice %in% choices)
        invalid <- choice[index]
    } else if (choice_type %in% c("index", "index_invalid", "index_invalid_partial")) {
        valid <- choices[choice]
        index <- !(choice %in% 1:length(choices))
        invalid <- choice[index]
    }

    list(valid = valid[!is.na(valid)], invalid = invalid)
}
