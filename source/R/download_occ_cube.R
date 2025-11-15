download_occ_cube <- function(sql_query, file, path, overwrite = FALSE) {
  require("rgbif")
  require("dplyr")
  require("rlang")

  # Stop if overwrite = FALSE and file does not exist
  file_path <- file.path(path, file)
  if (file.exists(file_path) && !overwrite) {
    message(paste("File already exists. Reading existing file.",
                  "Set `overwrite = TRUE` to overwrite file.", sep = "\n"))

    occ_cube <- readr::read_delim(file = file_path, show_col_types = FALSE)

    return(occ_cube)
  }

  # Download occurrence cube
  birdcubeflanders_year <- rgbif::occ_download_sql(
    user = Sys.getenv("USER"),
    pwd = Sys.getenv("PSWD"),
    email = Sys.getenv("MAIL"),
    q = sql_query
  )

  # Get occurrence cube
  rgbif::occ_download_wait(birdcubeflanders_year)

  occ_cube <- rgbif::occ_download_get(birdcubeflanders_year,
                                      path = path,
                                      overwrite = overwrite) %>%
    rgbif::occ_download_import()

  # Write csv
  readr::write_csv(
    x = occ_cube,
    file = file_path,
    append = FALSE
  )

  # Return tibble
  return(occ_cube)
}
