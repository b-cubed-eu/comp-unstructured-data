# Load packages required to define the pipeline:
library(targets)


# Set target options:
tar_option_set(
  packages = c("rgbif",
               "sf",
               "dplyr"
               ),
  format = "qs" # Optionally set the default storage format. qs is fast.
)

targets_project_dir <- rprojroot::find_root(rprojroot::is_git_root) |>
  file.path("source/pipelines/")
path_to_data <- rprojroot::find_root(rprojroot::is_git_root) |>
  file.path("data")

tar_config_set(
  script = file.path(targets_project_dir, "target_workflow", "_targets.R"),
  store = file.path(targets_project_dir, "target_workflow",
                    "_targets/"),
  config = "_targets.yaml",
  project = "target_workflow",
  use_crew = TRUE)

# Run the R scripts in the R/ folder with your custom functions:
tar_source(file.path(targets_project_dir, "target_workflow", "R"))

# Replace the target list below with your own:
list(
  tarchetypes::tar_file(
    abv_data_file,
    path_to_interim(path_to_data = path_to_data, file = "abv_data.csv")
  ),
  tar_target(
    abv_data,
    read.csv(abv_data_file)
  ),
  tarchetypes::tar_file(
    birdcube_data_file,
    path_to_interim(path_to_data = path_to_data, file = "birdcubeflanders.csv")
  ),
  tar_target(
    birdcube_data,
    read.csv(birdcube_data_file)
  )
)
