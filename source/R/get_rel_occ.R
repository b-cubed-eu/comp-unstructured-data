# function to calculate the ratio:
# occurence of a species / occurences within the order of this species

get_rel_occ <- function(cube, spec) {
  require("dplyr")
  require("rlang")

  cube$data %>%
    dplyr::filter(.data$orderKey ==  cube$data %>%
                    dplyr::filter(.data$scientificName == spec) %>%
                    dplyr::first() %>%
                    dplyr::pull(.data$orderKey)) %>%
    dplyr::group_by(.data$year) %>%
    dplyr::summarise(tot = sum(.data$diversity_val)) %>%
    dplyr::left_join(cube$data %>%
                       dplyr::filter(.data$scientificName == spec),
                     by = "year") %>%
    dplyr::mutate(rel_occ = .data$diversity_val / .data$tot)
}
