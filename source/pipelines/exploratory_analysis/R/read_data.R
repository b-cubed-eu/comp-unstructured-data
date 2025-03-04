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

rename_species <- function(data){
  output <- data |>
    mutate(species = case_when(
      species == "Parus montanus" ~ "Poecile montanus",
      species == "Dendrocopus major" ~ "Dendrocopos major",
      species == "Saxicola torquatus" ~ "Saxicola rubicola",
      TRUE ~ species
    ))

  return(output)
}

filter_1 <- function(data){

}