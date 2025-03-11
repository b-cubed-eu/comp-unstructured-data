<<<<<<< HEAD
download_occ_cube <- function(sql_query, file, overwrite = FALSE) {
=======
download_occ_cube <- function(sql_query, file, path, overwrite = FALSE) {
>>>>>>> 493279dba41b05e377807e3649ae2bb25a84cb60
  require("rgbif")
  require("dplyr")
  require("rlang")

<<<<<<< HEAD
  data_path <- here::here("data")

  # Stop if overwrite = FALSE and file does not exist
  file_path <- paste0(data_path, "/interim/", file)
  if (file.exists(file_path) && !overwrite) {
    return(
      warning(paste("Execution halted! File already exists.",
              "Set `overwrite = TRUE` to overwrite file.", sep = "\n")))
  }

  # Read UTM grid
  utm_grid <- sf::read_sf(
    file.path(data_path, "raw", "utm_grid", "utm1_vl.shp"))
  # Add 31U to the tag names of the grid
  utm_grid <- utm_grid %>%
    mutate(mgrscode = paste0("31U", .data$TAG)) %>%
    sf::st_drop_geometry()

  # Download occurrence cube
  birdcubeflanders_year <- occ_download_sql(
=======
  # Stop if overwrite = FALSE and file does not exist
  file_path <- file.path(path, file)
  if (file.exists(file_path) && !overwrite) {
    message(paste("File already exists. Reading existing file.",
            "Set `overwrite = TRUE` to overwrite file.", sep = "\n"))

    occ_cube <- readr::read_csv(file = file_path, show_col_types = FALSE)

    return(occ_cube)
  }

  # Download occurrence cube
  birdcubeflanders_year <- rgbif::occ_download_sql(
>>>>>>> 493279dba41b05e377807e3649ae2bb25a84cb60
    user = Sys.getenv("USER"),
    pwd = Sys.getenv("PSWD"),
    email = Sys.getenv("MAIL"),
    q = sql_query
  )

  # Get occurrence cube
<<<<<<< HEAD
  occ_download_wait(birdcubeflanders_year)

  birdcubeflanders <- occ_download_get(birdcubeflanders_year,
                                       path = paste0(data_path, "/raw")) |>
    occ_download_import()

  # Retain observations from Flanders
  birdcubeflanders <- utm_grid %>%
    inner_join(birdcubeflanders, by = join_by("mgrscode"))

  # Write out file
  readr::write_csv(
    x = birdcubeflanders,
    file = file_path,
    append = FALSE)
=======
  rgbif::occ_download_wait(birdcubeflanders_year)

  occ_cube <- rgbif::occ_download_get(birdcubeflanders_year,
                                      path = path,
                                      overwrite = overwrite) %>%
    rgbif::occ_download_import()

  # Write csv
  readr::write_csv(
    x = occ_cube,
    file = file_path,
    append = FALSE)

  # Return tibble
  return(occ_cube)
>>>>>>> 493279dba41b05e377807e3649ae2bb25a84cb60
}
