library(targets)
tar_path <- file.path(here::here(), "source/pipelines/biodiversity_indicators")

# Install b3gbi v0.8.11

# Run the pipeline
tar_make(script = file.path(tar_path, "_targets.R"),
         store = file.path(tar_path, "_targets"))
