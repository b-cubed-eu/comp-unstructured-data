# run the pipeline
library(targets)
Sys.setenv(TAR_PROJECT = "biodiversity_indicators")

tar_make()


# inspect pipeline
tar_prune()

tar_visnetwork()
meta <- tar_meta()


# debug pipeline
abv <- tar_read(abv)
