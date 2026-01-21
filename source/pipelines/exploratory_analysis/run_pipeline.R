library(targets)
tar_path <- file.path(here::here(), "source/pipelines/exploratory_analysis")

# Run the pipeline
tar_make(script = file.path(tar_path, "_targets.R"),
         store = file.path(tar_path, "_targets"))
