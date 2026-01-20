#' Compare if species have a comparable percentage of occupied grid cells
#' in both datasets
range_comp <- function(dataset1, dataset2) {
  require("dplyr")
  require("tidyr")
  require("rlang")

  species_list <- dataset1 |>
    select("species") |>
    distinct() |>
    pull()

  comp_range_data1 <- dataset1 |>
    group_by(pick(matches("^id_"))) |>
    mutate(tot_n_dist_gridcells = n_distinct(.data$mgrscode)) |>
    ungroup() |>
    group_by(.data$species,
             .data$tot_n_dist_gridcells,
             .data$category,
             pick(matches("^id_"))) |>
    summarise(n_dist_gridcells = n_distinct(.data$mgrscode)) |>
    ungroup() |>
    mutate(percentage = .data$n_dist_gridcells / .data$tot_n_dist_gridcells) |>
    pivot_wider(id_cols = c("id_spat_res",
                            "species",
                            "category",
                            matches("^id_filter")),
                names_from = "id_dataset",
                values_from = c("n_dist_gridcells", "percentage"))

  comp_range_data2 <- dataset2 |>
    filter(.data$species %in% species_list) |>
    group_by(pick(matches("^id_"))) |>
    mutate(tot_n_dist_gridcells = n_distinct(.data$mgrscode)) |>
    ungroup() |>
    group_by(.data$species,
             .data$tot_n_dist_gridcells,
             pick(matches("^id_"))) |>
    summarise(n_dist_gridcells = n_distinct(.data$mgrscode)) |>
    ungroup() |>
    mutate(percentage = .data$n_dist_gridcells / .data$tot_n_dist_gridcells) |>
    pivot_wider(id_cols = c("id_spat_res",
                            "species",
                            matches("^id_filter")),
                names_from = "id_dataset",
                values_from = c("n_dist_gridcells", "percentage"))

  comp_range_data <- comp_range_data1 |>
    left_join(comp_range_data2,
              by = join_by("species", "id_spat_res"))

  return(comp_range_data)
}

trend_comp <- function(dataset1, dataset2, time_period) {
  require("dplyr")
  require("tidyr")
  require("rlang")

  species_list <- dataset1 |>
    select("species") |>
    distinct() |>
    pull()

  trend_range_data1 <- dataset1 |>
    group_by(.data$species,
             .data$category,
             !!sym(time_period),
             pick(matches("^id_"))) |>
    summarize(occurrence = sum(n)) |>
    ungroup() |>
    pivot_wider(id_cols = c("id_spat_res",
                            "species",
                            "category",
                            !!sym(time_period),
                            matches("^id_filter")),
                names_from = "id_dataset",
                values_from = "occurrence")

  trend_range_data2 <- dataset2 |>
    filter(.data$species %in% species_list) |>
    group_by(.data$species,
             !!sym(time_period),
             pick(matches("^id_"))) |>
    summarize(occurrence = sum(n)) |>
    ungroup() |>
    pivot_wider(id_cols = c("id_spat_res",
                            "species",
                            !!sym(time_period),
                            matches("^id_filter")),
                names_from = "id_dataset",
                values_from = "occurrence")

  trend_range_data <- trend_range_data1 |>
    left_join(trend_range_data2,
              by = c("id_spat_res", "species", time_period)) |>
    drop_na() |>
    group_by(.data$species,
             .data$category,
             .data$id_spat_res,
             pick(matches("^id_filter"))) |>
    summarise(correlation = cor(.data$abv_data,
                                .data$birdflanders,
                                method = "pearson")) |>
    mutate(time_period = time_period)

  return(trend_range_data)
}
