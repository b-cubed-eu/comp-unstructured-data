my_group_by <- function(data, cols) {
  group_by(data, pick({{ cols }}))
}

range_comp <- function(data) {

  dataset_least_species <- data |>
    group_by(id_dataset) |>
    summarize(n_species = n_distinct(species)) |>
    filter(n_species == min(n_species)) |>
    pull(id_dataset)

  species_list <- data |>
    filter(id_dataset == dataset_least_species) |>
    select(species) |>
    distinct() |>
    pull()

  comp_range_data <- data |>
    filter(species %in% species_list) |>
    group_by(pick(matches("^id_"))) |>
    mutate(tot_n_dist_gridcells = n_distinct(mgrscode)) |>
    ungroup() |>
    my_group_by(c(c(species, tot_n_dist_gridcells), matches("^id_"))) |>
    summarise(n_dist_gridcells = n_distinct(mgrscode)) |>
    ungroup() |>
    mutate(percentage = n_dist_gridcells/tot_n_dist_gridcells) |>
    pivot_wider(id_cols = c(id_spat_res, species, matches("^id_filter")),
                names_from = id_dataset,
                values_from = c(n_dist_gridcells, percentage))

  return(comp_range_data)
}

trend_comp_data <- function(data1,
                            data2,
                            period = "year"){
  time_series_1 <- data1 |>
    group_by(species, !!sym(period)) |>
    summarize(occurrence = sum(n))

  time_series_2 <- data2 |>
    group_by(species, !!sym(period))  |>
    summarize(occurrence = sum(n))

  # Pearson Correlation for each species
  # inner_join makes sure that only species-year combinations present
  # in both datasets are included
  time_series_cor <- time_series_1 |>
    inner_join(time_series_2,
               by = c("species", period),
               suffix = c("_1", "_2"))  |>
    group_by(species) |>
    summarize(correlation = cor(occurrence_1, occurrence_2,
                                method = "pearson"))|>
    left_join(data1 |> distinct(species, category),
               by = join_by(species)) |>
    mutate(trend_comp_per = period)

  return(time_series_cor)
}