download_occ_cube <- function(sql_query, file, overwrite = FALSE) {
  require("rgbif")
  require("dplyr")
  require("rlang")

  # Download occurrence cube
  birdcubeflanders_year <- occ_download_sql(
    user = Sys.getenv("USER"),
    pwd = Sys.getenv("PSWD"),
    email = Sys.getenv("MAIL"),
    q = sql_query
  )

  # Get occurrence cube
  occ_download_wait(birdcubeflanders_year)

  birdcubeflanders <- occ_download_get(birdcubeflanders_year,
                                       path = file,
                                       overwrite = overwrite) |>
    occ_download_import()
}
