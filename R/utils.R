
has_var <- function(x, var) var %in% names(x)

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
