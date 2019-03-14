#' Datacenter object
#'
#' An R6 class to represent source code/data associated with a political candidate
#'
#' @section Functions:
#' Some text here
#'
#' \describe{
#' \item{one}{description}
#' }
#'
#' @export
new_datacenter <- function(vars) {
  Datacenter <- R6::R6Class(
    classname = "Datacenter",
    public    = pub <- list(
      initialize = dc_initialize,
      add        = dc_add,
      update     = dc_update,
      format     = dc_format,
      validate   = dc_validate
    )
  )
  ## if character vector, convert to tibble
  if (is.character(vars)) {
    vars <- unique(vars)
    vars <- structure(
      rep(list(logical()), length(vars)),
      class = "list",
      names = vars
    )
    vars <- tibble::as_tibble(vars)
  }
  ## add id var if not already
  .vars <- unique(c("id", names(vars)))
  if (!has_var(vars, "id")) {
    vars$id <- rep(NA_character_, nrow(vars))
  }
  ## set public vars
  for (i in .vars) {
    Datacenter$set("public", i, vars[[i]])
  }
  ## set var names as .vars
  Datacenter$set("public", ".vars", .vars)
  ## return data center
  Datacenter$new()
}

dc_initialize <- function(...) invisible(self)

#' Add method: only adds observations (rows); doesn't update values
dc_add <- function(...) {
  dots <- elps(...)
  dots <- dots[names(dots) %in% self$.vars]
  lapply(
    names(dots), function(.x) {
      assign(.x, c(self[[.x]], dots[[.x]]), envir = self)
    })
  lapply(
    self$.vars[!self$.vars %in% names(dots)], function(.x) {
      assign(.x, c(self[[.x]], rep(NA, max(lengths(dots)))), envir = self)
    })
  invisible(self)
}

#' Update method: only updates values; doesn't add observations (rows)
dc_update <- function(...) {
  dots <- elps(...)
  dots <- dots[names(dots) %in% self$.vars]
  dots <- dots[dots$id %in% self$id & !duplicated(dots$id), ]
  w <- match(dots$id, self$id)
  for (i in names(dots)) {
    self[[i]][w][is.na(self[[i]][w])] <- dots[[i]][is.na(self[[i]][w])]
  }
  invisible(self)
}

dc_format <- function(...) {
  d <- as.data.frame(self)
  c(
    sprintf("# A datacenter: %d x %d", nrow(d), ncol(d)),
    capture.output(tibble:::print.tbl(d, n = 5))[-1]
  )
}

#' Filters out duplicates
dc_validate <- function() {
  dups <- duplicated(self$id)
  for (i in self$.vars) {
    self[[i]] <- self[[i]][!dups]
  }
  invisible(self)
}


#' @export
as.data.frame.Datacenter <- function(x) {
  tibble::as_tibble(as.list(x)[x$.vars])
}

