# run the pipeline
library(targets)
Sys.setenv(TAR_PROJECT = "exploratory_analysis")

tar_make()



# inspect pipeline
tar_prune()

tar_visnetwork(targets_only = TRUE)
meta <- tar_meta()



# debug pipeline
# R console
library(targets)

tar_read()

# Restart your R session.
rstudioapi::restartSession()

# Loads globals like tar_option_set() packages, simulate_data(), and
# analyze_data():
tar_load_globals()

# Load the data that the target depends on.
tar_load(dataset1)

# Run the command of the errored target.
analyze_data(dataset1)
#> Error in na.fail.default(list(measurement = c(1L, 2L, 3L, 4L, 1L, 2L,  :
#>   missing values in object

abv <- tar_read(abv)
