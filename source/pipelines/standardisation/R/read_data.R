# Functions for reading and filtering data

# Create path to specific dataset in interim data folder
path_to_interim <- function(path_to_data, dataset, spat_res) {
  file <- paste0(dataset, "_cube_", spat_res, "_temp.csv")
  file.path(path_to_data, "interim", file)
}

# Add dataset id and spatial resolution as column to dataset
read_andid <- function(data_file, dataset, spat_res) {
  require("dplyr")

  data <- read.csv(data_file)

  output <- data |>
    mutate(id_dataset = dataset,
           id_spat_res = spat_res)

  return(output)
}

# Add ABV cycle based on year
add_cyclus <- function(data) {
  require("dplyr")

  output <- data |>
    mutate(cyclus = case_when(
      year >= 2007 & year <= 2009 ~ 1,
      year >= 2010 & year <= 2012 ~ 2,
      year >= 2013 & year <= 2015 ~ 3,
      year >= 2016 & year <= 2018 ~ 4,
      year >= 2019 & year <= 2021 ~ 5,
      year >= 2022 & year <= 2024 ~ 6
    ))

  return(output)
}

# Add rareness categories to dataset based on the number of observations
add_category <- function(data) {
  require("dplyr")
  require("rlang")

  output <- data |>
    group_by(.data$species) |>
    mutate(n_obs = sum(.data$n)) |>
    ungroup() |>
    mutate(category = cut(.data$n_obs,
                          breaks = c(0, 10, 100, 1000, 10000, +Inf),
                          labels = c("Very rare", "Rare", "Common",
                                     "Very common", "Extremely common"),
                          right = FALSE))

  return(output)
}

# Filter data for only species analysed under ABV
filter_1 <- function(data) {
  abv_birds <- read.csv("./data/interim/abv_birds.csv")

  output <- data |>
    filter(.data$species %in% abv_birds$species)

  return(output)
}

#' Filter dataset based on these rules (loosely based on ABV):
#' 1) A square is only relevant is the species was observed in
#' more than one time period
#' 2) A minimum of three relevant squares to include the species
#' 3) A minimum of a hundred observations to include the species

filter_2 <- function(data, time_period = "year") {
  require("dplyr")

  output <- data |>
    group_by(.data$mgrscode, .data$species) |>
    mutate(periods = n_distinct(!!sym(time_period))) |>
    ungroup() |>
    filter(.data$periods > 1) |>
    group_by(.data$species) |>
    mutate(squares = n_distinct(.data$mgrscode)) |>
    ungroup() |>
    filter(.data$squares > 2) |>
    group_by(.data$species) |>
    mutate(obs = n()) |>
    ungroup() |>
    filter(.data$obs > 100) |>
    mutate(id_filter_per = time_period)

  return(output)
}

#' Standardize data by dividing by the total number of observations
#' per time period or grid cell
filter_3 <- function(data, divide_by) {
  require("dplyr")

  output <- data |>
    group_by(
      across(
        any_of(
          c("id_dataset",
            "id_spat_res",
            "species",
            "category",
            divide_by)
        )
      )
    ) |>
    summarise(n = sum(.data$n)) |>
    ungroup() |>
    group_by(.data$id_dataset,
             .data$id_spat_res,
             !!sym(divide_by)) |>
    mutate(total_obs = sum(.data$n)) |>
    ungroup() |>
    mutate(n = .data$n / .data$total_obs)

  if ("id_filter_per" %in% colnames(data)) {
    output$id_filter_per <- data$id_filter_per[1]
    output$id_filter_per2 <- divide_by
  } else {
    output$id_filter_per <- divide_by
  }

  return(output)
}

# Standardize data based on total observations per family or order
stand_class_level <- function(data, stand_by, time_period) {
  require("dplyr")
  require("rlang")

  output <- data |>
    group_by(
      across(
        any_of(
          c("id_dataset",
            "id_spat_res",
            "species",
            "category",
            time_period)
        )
      )
    ) |>
    summarise(n = sum(.data$n),
              total = sum(!!sym(stand_by))) |>
    ungroup() |>
    mutate(n = .data$n / .data$total)

  if ("id_filter_per" %in% colnames(data)) {
    output$id_filter_per <- data$id_filter_per[1]
    output$id_filter_per2 <- time_period
  } else {
    output$id_filter_per <- time_period
  }

  return(output)
}
