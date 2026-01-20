get_mean_common <- function(
    x,
    cats = c("Common", "Very common", "Extremely common")) {
  require("dplyr")
  require("rlang")

  vals <- x |>
    filter(.data$category %in% cats) |>
    pull(.data$correlation)

  return(mean(vals, na.rm = TRUE))
}
