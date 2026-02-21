# function to calculate the ratio:
# occurence of a species / occurences within the order of this species

get_rel_occ <- function(cube, spec) {
  cube$data %>%
    dplyr::filter(orderKey ==  cube$data %>%
                    dplyr::filter(scientificName == spec) %>%
                    dplyr::first() %>%
                    dplyr::pull(orderKey)) %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(tot = sum(diversity_val)) %>%
    dplyr::left_join(cube$data %>%
                       dplyr::filter(scientificName == spec),
                     by = "year") %>%
    dplyr::mutate(rel_occ = diversity_val / tot)
}
