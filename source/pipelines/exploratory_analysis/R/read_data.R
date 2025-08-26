path_to_interim <- function(path_to_data, dataset, spat_res) {
  file <- paste0(dataset, "_cube_", spat_res, ".csv")
  file.path(path_to_data, "interim", file)
}

read_andid <- function(data_file, dataset, spat_res) {
  require("dplyr")

  data <- read.csv(data_file)

  output <- data |>
    mutate(id_dataset = dataset,
           id_spat_res = spat_res)

  return(output)
}

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

add_category <- function(data) {
  require("dplyr")

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


filter_1 <- function(data) {
  abv_birds <- read.csv("./data/interim/abv_birds.csv")

  output <- data |>
    filter(.data$species %in% abv_birds$species)

  return(output)
}

#' Rules (loosely based on ABV):
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
    mutate(id_filter_per = .data$time_period)

  return(output)
}

filter_3 <- function(data, time_period = "year") {
  require("dplyr")

  output <- data |>
    group_by(.data$id_dataset,
             .data$id_spat_res,
             .data$species,
             .data$category,
             !!sym(time_period)) |>
    summarise(n = sum(.data$n)) |>
    ungroup() |>
    group_by(!!sym(time_period)) |>
    mutate(total_obs = sum(.data$n)) |>
    ungroup() |>
    mutate(n = .data$n / .data$total_obs)

  if ("id_filter_per" %in% colnames(data)) {
    output$id_filter_per <- data$id_filter_per[1]
    output$id_filter_per2 <- time_period
  } else {
    output$id_filter_per <- time_period
  }

  return(output)
}
