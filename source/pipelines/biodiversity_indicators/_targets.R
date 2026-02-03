# Pipeline to run the standardization analysis

# Load packages required to define the pipeline:
library(targets)

# Set target options:
tar_option_set(
  packages = c("b3gbi", "tidyverse"),
  format = "qs" # Optionally set the default storage format. qs is fast.
)

# Set project directory and data path:
targets_project_dir <- rprojroot::find_root(rprojroot::is_git_root) |>
  file.path("source/pipelines/")
path_to_data <- rprojroot::find_root(rprojroot::is_git_root) |>
  file.path("data")

# Run the R scripts in the R/ folder with our custom functions:
tar_source(file.path(targets_project_dir, "biodiversity_indicators", "R"))

# The target list:
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
    path_to_processed(
      path_to_data = path_to_data,
      dataset = dataset,
      spat_res = spat_res
    ),
    pattern = cross(dataset, spat_res)
  ),
  tar_target(
    data_int1,
    read_andid(data_file, dataset, spat_res),
    pattern = map(data_file, cross(dataset, spat_res))
  ),
  tar_target(
    data,
    add_cyclus(data_int1),
    pattern = map(data_int1)
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
    data_cubes,
    process_cube(data,
                 cols_occurrences = "n"),
    pattern = map(data),
    iteration = "list"
  ),
  tar_target(
    obs_richness_map,
    obs_richness_map(data_cubes, cell_size = 10),
    pattern = map(data_cubes),
    iteration = "list"
  ),
  tar_target(
    obs_richness_ts,
    obs_richness_ts(data_cubes, ci_type = "none"),
    pattern = map(data_cubes),
    iteration = "list"
  ),
  tar_target(
    total_occ_map,
    total_occ_map(data_cubes, cell_size = 10),
    pattern = map(data_cubes),
    iteration = "list"
  ),
  tar_target(
    total_occ_ts,
    total_occ_ts(data_cubes, ci_type = "none"),
    pattern = map(data_cubes),
    iteration = "list"
  ),
  tar_target(
    pielou_evenness_map,
    pielou_evenness_map(data_cubes, cell_size = 10),
    pattern = map(data_cubes),
    iteration = "list",
    error = "continue" # run this with b3gbi v0.8.11
  ),
  tar_target(
    pielou_evenness_ts,
    pielou_evenness_ts(data_cubes, ci_type = "none"),
    pattern = map(data_cubes),
    iteration = "list"
  ),
  tar_target(
    spec_occ_map,
    spec_occ_map(data_cubes),
    pattern = map(data_cubes),
    iteration = "list"
  ),
  tar_target(
    spec_occ_ts,
    spec_occ_ts(data_cubes, ci_type = "none"),
    pattern = map(data_cubes),
    iteration = "list"
  ),
  tar_target(
    spec_range_map,
    spec_range_map(data_cubes),
    pattern = map(data_cubes),
    iteration = "list"
  ),
  tar_target(
    spec_range_ts,
    spec_range_ts(data_cubes, ci_type = "none"),
    pattern = map(data_cubes),
    iteration = "list"
  )
)
