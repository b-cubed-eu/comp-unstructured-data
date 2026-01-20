my_group_by <- function(data, cols) {
  require("dplyr")

  group_by(data, pick({{ cols }}))
}

range_comp <- function(data) {
  require("dplyr")
  require("tidyr")
  require("rlang")

  dataset_least_species <- data |>
    group_by(.data$id_dataset) |>
    summarize(n_species = n_distinct(.data$species)) |>
    filter(.data$n_species == min(.data$n_species)) |>
    pull(.data$id_dataset)

  species_list <- data |>
    filter(.data$id_dataset == dataset_least_species) |>
    select("species") |>
    distinct() |>
    pull()

  comp_range_data <- data |>
    filter(.data$species %in% species_list) |>
    group_by(pick(matches("^id_"))) |>
    mutate(tot_n_dist_gridcells = n_distinct(.data$mgrscode)) |>
    ungroup() |>
    my_group_by(c(c("species", "tot_n_dist_gridcells"), matches("^id_"))) |>
    summarise(n_dist_gridcells = n_distinct(.data$mgrscode)) |>
    ungroup() |>
    mutate(percentage = .data$n_dist_gridcells / .data$tot_n_dist_gridcells) |>
    pivot_wider(id_cols = c("id_spat_res",
                            "species",
                            matches("^id_filter")),
                names_from = "id_dataset",
                values_from = c("n_dist_gridcells", "percentage")) |>
    left_join(data |>
                filter(.data$id_dataset == "abv_data") |>
                distinct(.data$species, .data$category),
              by = join_by("species"))

  return(comp_range_data)
}

trend_comp <- function(data, time_period) {
  require("dplyr")
  require("tidyr")
  require("rlang")

  dataset_least_species <- data |>
    group_by(.data$id_dataset) |>
    summarize(n_species = n_distinct(.data$species)) |>
    filter(.data$n_species == min(.data$n_species)) |>
    pull(.data$id_dataset)

  species_list <- data |>
    filter(.data$id_dataset == dataset_least_species) |>
    select("species") |>
    distinct() |>
    pull()

  trend_range_data <- data |>
    filter(.data$species %in% species_list) |>
    my_group_by(c(c("species", !!sym(time_period)), matches("^id_"))) |>
    summarize(occurrence = sum(n)) |>
    ungroup() |>
    pivot_wider(id_cols = c("id_spat_res",
                            "species",
                            !!sym(time_period),
                            matches("^id_filter")),
                names_from = "id_dataset",
                values_from = "occurrence") |>
    drop_na() |>
    my_group_by(c(c("species", "id_spat_res"), matches("^id_filter"))) |>
    summarise(correlation = cor(.data$abv_data,
                                .data$birdflanders,
                                method = "pearson")) |>
    ungroup() |>
    left_join(data |>
                filter(.data$id_dataset == "abv_data") |>
                distinct(.data$species, .data$category),
              by = join_by("species")) |>
    mutate(time_period = time_period)

  return(trend_range_data)
}
