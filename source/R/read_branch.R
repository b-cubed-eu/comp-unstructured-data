#' Read a specific branch from a targets object
#'
#' Wrapper around \code{\link[targets]{tar_read}} to automatically select a
#' branch based on dataset and spatial resolution.
#'
#' @param name Character. Name of the target to read.
#' @param dataset Character. Dataset name. Options: \code{"abv_data"} or
#' \code{"birdflanders"}.
#' @param spat_res Numeric. Spatial resolution in km. Options: 1 or 10.
#' @param ... Additional arguments passed to \code{\link[targets]{tar_read}}.
#'
#' @return The object read from the specified branch. If the branch contains a
#'   list of length 1, the first element is returned automatically.
#'
#' @examples
#' # Read 10 km ABV data
#' total_occ_map_abv <- read_branch(
#'   name = "total_occ_map",
#'   dataset = "abv_data",
#'   spat_res = 10,
#'   store = store
#' )
#'
#' # Read 1 km Bird Flanders data
#' total_occ_map_bf <- read_branch(
#'   name = "total_occ_map",
#'   dataset = "birdflanders",
#'   spat_res = 1
#' )

read_branch <- function(
    name,
    dataset = c("abv_data", "birdflanders"),
    spat_res = c(1, 10),
    ...) {
  # Match dataset and spatial resolution
  dataset <- match.arg(dataset)
  spat_res <- match.arg(as.character(spat_res), choices = c("1", "10"))

  # Determine branch number
  branch <- switch(
    paste0(dataset, "_", spat_res),
    "abv_data_1"         = 1,
    "abv_data_10"        = 2,
    "birdflanders_1"     = 3,
    "birdflanders_10"    = 4,
    stop("Invalid combination of dataset and spat_res")
  )

  # Read target with specified branch
  result <- targets::tar_read_raw(name, branches = branch, ...)

  # Return first element if result is a list of length 1
  if (is.list(result) && length(result) == 1) result <- result[[1]]

  return(result)
}
