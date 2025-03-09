path_to_interim <- function(path_to_data, file) {
  file.path(path_to_data, "interim", file)
}

add_cyclus <- function(data){
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

add_category <- function(data){
  output <- data |>
    group_by(species) |>
    mutate(n_obs = sum(n)) |>
    ungroup() |>
    mutate(category = cut(n_obs,
                          breaks = c(0, 10, 100, 1000, 10000, +Inf),
                          labels = c("Very rare", "Rare", "Common",
                                     "Very common", "Extremely common"),
                          right = FALSE))

  return(output)
}


filter_1 <- function(data){
  abv_birds <- read.csv("./data/interim/abv_birds.csv")

  output <- data |>
    filter(species %in% abv_birds$species)
}

#' Rules (loosely based on ABV):
#' 1) A square is only relevant is the species was observed in more than one time period
#' 2) A minimum of three relevant squares to include the species
#' 3) A minimum of a hundred observations to include the species

filter_2 <- function(data, time_period = "year"){
  output <- data |>
    group_by(mgrscode, species) |>
    mutate(periods = n_distinct(!!sym(time_period))) |>
    ungroup() |>
    filter(periods > 1) |>
    group_by(species) |>
    mutate(squares = n_distinct(mgrscode)) |>
    ungroup() |>
    filter(squares > 2) |>
    group_by(species) |>
    mutate(obs = n()) |>
    ungroup() |>
    filter(obs > 100)

  return(output)
}
