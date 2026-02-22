# Retrieve for all taxonkeys in the dataset the orderKey from GBIF
library(rgbif)

# Load dataset occurence cube birdflanders
store <- file.path(
  here::here(), "source/pipelines/biodiversity_indicators/_targets"
)

spec_occ_ts_cube <- read_branch(
  "spec_occ_ts",
  dataset = "birdflanders",
  spat_res = 10,
  store = store
)

taxonkeys <- unique(spec_occ_ts_cube$data$taxonKey)

# 2493012 Cettia cetti - order = 729
# 5231198 Passer montanus - order
# 7660710 Luscinia megarhynchos

# name_usage for the taxonomic data
detailed_list <- taxonkeys %>%
  purrr::map_dfr(~name_usage(key = .x)$data)

order_list <- detailed_list %>%
  dplyr::select(key, orderKey)

saveRDS(order_list, file = "./data/processed/order_list.RDS")
