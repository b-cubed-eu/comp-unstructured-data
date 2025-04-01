range_comp <- function(dataset1,
                       dataset2,
                       sel_species,
                       period = 2007:2022) {

  # We filter both datasets for the species and period of interest
  # and group them by TAG (identifier of utm square)
  set_abv <- dataset1 |>
    filter(.data$species %in% sel_species,
           .data$year %in% period) |>
    group_by(.data$mgrscode) |>
    summarise(n = sum(.data$n))

  set_cube <- dataset2 |>
    filter(.data$species %in% sel_species,
           .data$year %in% period) |>
    group_by(.data$mgrscode) |>
    summarise(n = sum(.data$n))

  total_abv <- length(set_abv$mgrscode)
  perc_abv <- (total_abv / length(unique(dataset1$mgrscode))) * 100

  total_cube <- length(set_cube$mgrscode)
  perc_cube <- (total_cube / length(unique(dataset2$mgrscode))) * 100

  list(total_abv, perc_abv,
       total_cube, perc_cube)
}

range_comp_data <- function(dataset1,
                            dataset2,
                            sel_species = unique(dataset1$species),
                            period = 2007:2022){

  comp_range_data <- as.data.frame(sel_species)
  comp_range_data$abv_squares <- NA
  comp_range_data$perc_abv_total_abv <- NA
  comp_range_data$cube_squares <- NA
  comp_range_data$perc_cube_total_cube <- NA
  if (assertthat::has_name(dataset1, "filter_per")){
    comp_range_data$filter_per <- paste0(dataset1$filter_per[1],
                                         dataset2$filter_per[1])
  }

  comp_range_data <- comp_range_data |>
    inner_join(dataset1 |> distinct(species, category),
               by = join_by(sel_species == species))

  for (i in sel_species){
    test <- range_comp(dataset1 = dataset1,
                       dataset2 = dataset2,
                       sel_species = i,
                       period = period)

    comp_range_data[comp_range_data$sel_species == i, 2] <- test[1]
    comp_range_data[comp_range_data$sel_species == i, 3] <- test[2]
    comp_range_data[comp_range_data$sel_species == i, 4] <- test[3]
    comp_range_data[comp_range_data$sel_species == i, 5] <- test[4]
  }

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
    inner_join(data1 |> distinct(species, category),
               by = join_by(species)) |>
    mutate(trend_comp_per = period)

  return(time_series_cor)
}