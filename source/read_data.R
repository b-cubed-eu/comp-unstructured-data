library(rgbif)
library(sf)
library(dplyr)

# nolint start

data_path <- here::here("data")

utm_grid <- read_sf(file.path(data_path, "raw", "utm_grid", "utm1_vl.shp"))
utm_grid <- utm_grid %>%
  mutate(mgrscode = paste0("31U", TAG)) %>%
  st_drop_geometry()

birdcubeflanders_year <- occ_download_sql(
  user = Sys.getenv("USER"),
  pwd = Sys.getenv("PSWD"),
  email = Sys.getenv("MAIL"),
  "SELECT
  \"year\",
  GBIF_MGRSCode(1000, decimalLatitude, decimalLongitude,
  COALESCE(coordinateUncertaintyInMeters, 1000)) AS mgrsCode,
  speciesKey,
  species,
  family,
  COUNT(*) AS n,
  MIN(COALESCE(coordinateUncertaintyInMeters, 1000)) AS minCoordinateUncertaintyInMeters,
  IF(ISNULL(family), NULL, SUM(COUNT(*)) OVER (PARTITION BY family)) AS familyCount
  FROM
  occurrence
  WHERE
  occurrenceStatus = 'PRESENT'
  AND NOT ARRAY_CONTAINS(issue, 'ZERO_COORDINATE')
  AND NOT ARRAY_CONTAINS(issue, 'COORDINATE_OUT_OF_RANGE')
  AND NOT ARRAY_CONTAINS(issue, 'COORDINATE_INVALID')
  AND NOT ARRAY_CONTAINS(issue, 'COUNTRY_COORDINATE_MISMATCH')
  AND level1gid = 'BEL.2_1'
  AND \"year\" >= 2007
  AND \"year\" <= 2022
  AND speciesKey IS NOT NULL
  AND decimalLatitude IS NOT NULL
  AND decimalLongitude IS NOT NULL
  AND class = 'Aves'
  AND collectionCode != 'ABV'
  GROUP BY
  \"year\",
  mgrsCode,
  speciesKey,
  family,
  species
  ORDER BY
  \"year\" ASC,
  mgrsCode ASC,
  speciesKey ASC"
)

occ_download_wait(birdcubeflanders_year)

birdcubeflanders <- occ_download_get(birdcubeflanders_year,
                                     path = paste0(data_path, "/raw")) |>
  occ_download_import()

birdcubeflanders <- utm_grid %>%
  inner_join(birdcubeflanders, by = join_by(mgrscode))

write.csv(birdcubeflanders, paste0(data_path, "/interim/birdcubeflanders.csv"))

abv_data_down <- occ_download_sql(
  user = Sys.getenv("USER"),
  pwd = Sys.getenv("PSWD"),
  email = Sys.getenv("MAIL"),
  "SELECT
  \"year\",
  GBIF_MGRSCode(1000, decimalLatitude, decimalLongitude,
  COALESCE(coordinateUncertaintyInMeters, 1000)) AS mgrsCode,
  speciesKey,
  species,
  family,
  COUNT(*) AS n,
  MIN(COALESCE(coordinateUncertaintyInMeters, 1000)) AS minCoordinateUncertaintyInMeters,
  IF(ISNULL(family), NULL, SUM(COUNT(*)) OVER (PARTITION BY family)) AS familyCount
  FROM
  occurrence
  WHERE
  occurrenceStatus = 'PRESENT'
  AND NOT ARRAY_CONTAINS(issue, 'ZERO_COORDINATE')
  AND NOT ARRAY_CONTAINS(issue, 'COORDINATE_OUT_OF_RANGE')
  AND NOT ARRAY_CONTAINS(issue, 'COORDINATE_INVALID')
  AND NOT ARRAY_CONTAINS(issue, 'COUNTRY_COORDINATE_MISMATCH')
  AND level1gid = 'BEL.2_1'
  AND \"year\" >= 2007
  AND \"year\" <= 2022
  AND speciesKey IS NOT NULL
  AND decimalLatitude IS NOT NULL
  AND decimalLongitude IS NOT NULL
  AND class = 'Aves'
  AND collectionCode = 'ABV'
  GROUP BY
  \"year\",
  mgrsCode,
  speciesKey,
  family,
  species
  ORDER BY
  \"year\" ASC,
  mgrsCode ASC,
  speciesKey ASC"
)

occ_download_wait(abv_data_down)

abv_data <- occ_download_get(abv_data_down,
                             path = paste0(data_path, "/raw")) |>
  occ_download_import()

write.csv(abv_data, paste0(data_path, "/interim/abv_data.csv"))

# nolint end
