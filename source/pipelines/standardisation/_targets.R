# Pipeline to run the standardization analysis

# Load packages required to define the pipeline:
library(targets)


# Set target options:
tar_option_set(
  packages = c("tidyverse"),
  format = "qs" # Optionally set the default storage format. qs is fast.
)

# Set project directory and data path:
targets_project_dir <- rprojroot::find_root(rprojroot::is_git_root) |>
  file.path("source/pipelines/")
path_to_data <- rprojroot::find_root(rprojroot::is_git_root) |>
  file.path("data")

#' Write custom settings for the current project to
#' YAML configuration file
tar_config_set(
  script = file.path(targets_project_dir, "standardisation", "_targets.R"),
  store = file.path(targets_project_dir, "standardisation",
                    "_targets/"),
  config = "_targets.yaml",
  project = "standardisation",
  use_crew = TRUE
)

# Run the R scripts in the R/ folder with our custom functions:
tar_source(file.path(targets_project_dir, "standardisation", "R"))

# List of targets:
list(
  #' Define parameters:
  tar_target(
    time_period,
    c("year", "cyclus")
  ),
  tar_target(
    spat_res,
    c("1km", "10km")
  ),
  tar_target(
    dataset,
    c("abv_data", "birdflanders")
  ),
  #' Define the data file target:
  tarchetypes::tar_file(
    data_file_abv,
    path_to_interim(path_to_data = path_to_data,
                    dataset = "abv_data",
                    spat_res = spat_res),
    pattern = map(spat_res)
  ),
  tarchetypes::tar_file(
    data_file_cube,
    path_to_interim(path_to_data = path_to_data,
                    dataset = "birdflanders",
                    spat_res = spat_res),
    pattern = map(spat_res)
  ),
  #' Read abv_1km and abv_10km:
  tar_target(
    data_abv_int1,
    read_andid(data_file_abv, "abv_data", spat_res),
    pattern = map(data_file_abv, spat_res)
  ),
  #' Read birdflanders_1km and birdflanders_10km:
  tar_target(
    data_cube_int1,
    read_andid(data_file_cube, "birdflanders", spat_res),
    pattern = map(data_file_cube, spat_res)
  ),
  #' Add cyclus to datasets:
  tar_target(
    data_abv_int2,
    add_cyclus(data_abv_int1),
    pattern = map(data_abv_int1)
  ),
  tar_target(
    data_cube,
    add_cyclus(data_cube_int1),
    pattern = map(data_cube_int1)
  ),
  #' Add category based on total number of observations per species:
  tar_target(
    data_abv,
    add_category(data_abv_int2),
    pattern = map(data_abv_int2)
  ),
  #' Filter for species interpreted under ABV scheme:
  tar_target(
    filter1_abv,
    filter_1(data_abv),
    pattern = map(data_abv)
  ),
  tar_target(
    filter1_cube,
    filter_1(data_cube),
    pattern = map(data_cube)
  ),
  #' Filter based on set of rules:
  tar_target(
    filter2_abv,
    filter_2(data_abv, time_period),
    pattern = cross(data_abv, time_period)
  ),
  tar_target(
    filter2_cube,
    filter_2(data_cube, time_period),
    pattern = cross(data_cube, time_period)
  ),
  #' Convert to relative abundance per time period:
  tar_target(
    filter3_abv,
    filter_3(data_abv, time_period),
    pattern = cross(data_abv, time_period)
  ),
  tar_target(
    filter3_cube,
    filter_3(data_cube, time_period),
    pattern = cross(data_cube, time_period)
  ),
  #' Apply filter 2 and convert to relative abundance per time period:
  tar_target(
    filter4_abv,
    filter_3(filter2_abv, time_period),
    pattern = cross(filter2_abv, time_period)
  ),
  tar_target(
    filter4_cube,
    filter_3(filter2_cube, time_period),
    pattern = cross(filter2_cube, time_period)
  ),
  #' Convert to relative abundance per order:
  tar_target(
    stand_order_abv,
    stand_class_level(data_abv, stand_by = "ordercount", time_period),
    pattern = cross(data_abv, time_period)
  ),
  tar_target(
    stand_order_cube,
    stand_class_level(data_cube, stand_by = "ordercount", time_period),
    pattern = cross(data_cube, time_period)
  ),
  #' Convert to relative abundance per family:
  tar_target(
    stand_family_abv,
    stand_class_level(data_abv, stand_by = "familycount", time_period),
    pattern = cross(data_abv, time_period)
  ),
  tar_target(
    stand_family_cube,
    stand_class_level(data_cube, stand_by = "familycount", time_period),
    pattern = cross(data_cube, time_period)
  ),
  #' Convert to relative abundance per genus:
  tar_target(
    stand_genus_abv,
    stand_class_level(data_abv, stand_by = "genuscount", time_period),
    pattern = cross(data_abv, time_period)
  ),
  tar_target(
    stand_genus_cube,
    stand_class_level(data_cube, stand_by = "genuscount", time_period),
    pattern = cross(data_cube, time_period)
  ),
  #' Compare the range per species in structured and unstructured data
  #' after applying different filters:
  #' Compare the range per species in structured and unstructured data
  #' after applying different filters:
  tar_target(
    range_comp_0,
    range_comp(data_abv, data_cube)
  ),
  tar_target(
    range_comp_1,
    range_comp(data_abv, filter1_cube)
  ),
  tar_target(
    range_comp_2,
    range_comp(data_abv, filter2_cube)
  ),
  #' Compare the trend per species in structured and unstructured data
  #' after applying different filters:
  tar_target(
    trend_comp_0,
    trend_comp(data_abv, data_cube, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_0_cutoff,
    trend_comp(data_abv |> filter(year < 2019),
               data_cube |> filter(year < 2019),
               time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_1,
    trend_comp(data_abv, filter1_cube, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_2,
    trend_comp(data_abv, filter2_cube, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_3,
    trend_comp(data_abv, filter3_cube, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_3_cutoff,
    trend_comp(data_abv |> filter(year < 2019),
               filter3_cube |> filter(year < 2019),
               time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_4,
    trend_comp(data_abv, filter4_cube, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_order,
    trend_comp(data_abv, stand_order_cube, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_order_cutoff,
    trend_comp(data_abv |> filter(year < 2019),
               stand_order_cube|> filter(year < 2019),
               time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_family,
    trend_comp(data_abv, stand_family_cube, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_family_cutoff,
    trend_comp(data_abv |> filter(year < 2019),
               stand_family_cube |> filter(year < 2019),
               time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_genus,
    trend_comp(data_abv, stand_genus_cube, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_genus_cutoff,
    trend_comp(data_abv |> filter(year < 2019),
               stand_genus_cube |> filter(year < 2019),
               time_period),
    pattern = map(time_period)
  )
)