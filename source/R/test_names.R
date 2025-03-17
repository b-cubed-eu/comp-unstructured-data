library(rgbif)

species_list <- sort(unique(cube$species))

df_names <- name_backbone(species_list[1])

for (i in 2:length(species_list)){
  check <- name_backbone(species_list[i])

  df_names <- df_names |>
    add_row(check)
}

df_names |>
  filter(grepl(" x ", scientificName))
