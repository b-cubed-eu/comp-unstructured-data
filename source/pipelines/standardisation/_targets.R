# Load packages required to define the pipeline:
library(targets)


# Set target options:
tar_option_set(
  packages = c("tidyverse"),
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
  use_crew = TRUE
)

# Run the R scripts in the R/ folder with our custom functions:
tar_source(file.path(targets_project_dir, "exploratory_analysis", "R"))

# List of targets:
list(
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
  tarchetypes::tar_file(
    data_file,
    path_to_interim(path_to_data = path_to_data,
                    dataset = dataset,
                    spat_res = spat_res),
    pattern = cross(dataset, spat_res)
  ),
  tar_target(
    data_int1,
    read_andid(data_file, dataset, spat_res),
    pattern = map(data_file, cross(dataset, spat_res))
  ),
  tar_target(
    data_int2,
    add_cyclus(data_int1),
    pattern = map(data_int1)
  ),
  tar_target(
    data,
    add_category(data_int2),
    pattern = map(data_int2)
  ),
  tar_target(
    filter1,
    filter_1(data),
    pattern = map(data)
  ),
  tar_target(
    filter2,
    filter_2(data, time_period),
    pattern = cross(data, time_period)
  ),
  tar_target(
    filter3,
    filter_3(data, time_period),
    pattern = cross(data, time_period)
  ),
  tar_target(
    filter4,
    filter_3(filter2, time_period),
    pattern = cross(filter2, time_period)
  ),
  tar_target(
    range_comp_0,
    range_comp(data)
  ),
  tar_target(
    range_comp_1,
    range_comp(filter1)
  ),
  tar_target(
    range_comp_2,
    range_comp(filter2)
  ),
  tar_target(
    trend_comp_0,
    trend_comp(data, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_1,
    trend_comp(filter1, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_2,
    trend_comp(filter2, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_3,
    trend_comp(filter3, time_period),
    pattern = map(time_period)
  ),
  tar_target(
    trend_comp_4,
    trend_comp(filter4, time_period),
    pattern = map(time_period)
  )
)
