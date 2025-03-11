# Load packages required to define the pipeline:
library(targets)


# Set target options:
tar_option_set(
  packages = c(
               "dplyr"
               ),
  format = "qs" # Optionally set the default storage format. qs is fast.
)

targets_project_dir <- rprojroot::find_root(rprojroot::is_git_root) |>
  file.path("source/pipelines/")
path_to_data <- rprojroot::find_root(rprojroot::is_git_root) |>
  file.path("data")

tar_config_set(
  script = file.path(targets_project_dir, "exploratory_analysis", "_targets.R"),
  store = file.path(targets_project_dir, "exploratory_analysis",
                    "_targets/"),
  config = "_targets.yaml",
  project = "exploratory_analysis",
  use_crew = TRUE)

# Run the R scripts in the R/ folder with your custom functions:
tar_source(file.path(targets_project_dir, "exploratory_analysis", "R"))

# Replace the target list below with your own:
list(
  tarchetypes::tar_file(
    abv_data_file,
    path_to_interim(path_to_data = path_to_data, file = "abv_data_cube.csv")
  ),
  tar_target(
    abv_data_int1,
    read.csv(abv_data_file)
  ),
  tar_target(
    abv_data_int2,
    add_cyclus(abv_data_int1)
  ),
  tar_target(
    abv_data,
    add_category(abv_data_int2)
  ),
  tarchetypes::tar_file(
    birdcube_data_file,
    path_to_interim(path_to_data = path_to_data, file = "birdcubeflanders.csv")
  ),
  tar_target(
    birdcube_data_int,
    read.csv(birdcube_data_file)
  ),
  tar_target(
    birdcube_data,
    add_cyclus(birdcube_data_int)
  ),
  tar_target(
    filter1_abv,
    filter_1(abv_data)
  ),
  tar_target(
    filter1_cube,
    filter_1(birdcube_data)
  ),
  tar_target(
    filter2_abv,
    filter_2(abv_data)
  ),
  tar_target(
    filter2_cube,
    filter_2(birdcube_data)
  ),
  tar_target(
    filter3_abv,
    filter_3(abv_data)
  ),
  tar_target(
    filter3_cube,
    filter_3(birdcube_data)
  ),
  tar_target(
    range_comp_0,
    range_comp_data(abv_data, birdcube_data)
  ),
  tar_target(
    range_comp_1,
    range_comp_data(filter1_abv, filter1_cube)
  ),
  tar_target(
    range_comp_2,
    range_comp_data(filter2_abv, filter2_cube)
  ),
  tar_target(
    trend_comp_0,
    trend_comp_data(abv_data, birdcube_data)
  ),
  tar_target(
    trend_comp_1,
    trend_comp_data(filter1_abv, filter1_cube)
  ),
  tar_target(
    trend_comp_2,
    trend_comp_data(filter2_abv, filter2_cube)
  ),
  tar_target(
    trend_comp_3,
    trend_comp_data(filter3_abv, filter3_cube)
  ),
  tar_target(
    trend_comp_0c,
    trend_comp_data(abv_data, birdcube_data,
                    period = "cyclus")
  ),
  tar_target(
    trend_comp_1c,
    trend_comp_data(filter1_abv, filter1_cube,
                    period = "cyclus")
  ),
  tar_target(
    trend_comp_2c,
    trend_comp_data(filter2_abv, filter2_cube,
                    period = "cyclus")
  ),
  tar_target(
    trend_comp_3c,
    trend_comp_data(filter3_abv, filter3_cube,
                    period = "cyclus")
  )
)
