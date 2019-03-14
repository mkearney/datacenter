## fooo <- function(x) sprintf('has_%s <- function(x) "%s" %%in%% names(x)', x, x)
## foo <- function(x) paste0(sapply(x, fooo), collapse = "\n\n")

`%H%` <- function(.x, .y) UseMethod("%H%")

`%H%.list` <- function(.x, .y) {
  .y %in% names(.x)
}

`%H%.character` <- function(.x, .y) {
  .x %in% names(.y)
}

`%H%.default` <- function(.x, .y) {
  if (is.recursive(.x)) {
    `%H%.list`(.x, .y)
  } else if (is.recursive(.y)) {
    `%H%.list`(.y, .x)
  } else {
    stop(".x or .y must be recursive", call. = FALSE)
  }
}

`%!H%` <- function(.x, .y) UseMethod("%!H%")

`%!H%.list` <- function(.x, .y) {
  !.y %in% names(.x)
}

`%!H%.character` <- function(.x, .y) {
  !.x %in% names(.y)
}

`%!H%.default` <- function(.x, .y) {
  if (is.recursive(.x)) {
    `%H%.list`(.x, .y)
  } else if (is.recursive(.y)) {
    `%H%.list`(.y, .x)
  } else {
    stop(".x or .y must be recursive", call. = FALSE)
  }
}


has_var <- function(x) "birthday" %in% names(x)


has_birthday <- function(x) "birthday" %in% names(x)

has_party <- function(x) "party" %in% names(x)

has_state <- function(x) "state" %in% names(x)

has_gender <- function(x) "gender" %in% names(x)

has_office <- function(x) "office" %in% names(x)

has_full_name <- function(x) "full_name" %in% names(x)

is_named_list <- function(x) {
  length(x) == 1 && is.recursive (x[[1]]) && length(names(x[[1]])) > 0 &&
    !all(names(x[[1]]) == "")
}



elps <- function(...) {
  dots <- list(...)
  if (is_named_list(dots)) {
    dots <- dots[[1]]
  }
  tibble::as_tibble(dots)
}
