plot_cross_validation <- function(
    cv_df,
    prevalence_df,
    measure = ".data[[measure]]",
    quant = 0.9,
    max.overlaps = 20) {
  require("dplyr")
  require("ggplot2")
  require("rlang")
  require("ggrepel")

  cv_df %>%
    distinct(species, rarity, !!sym(measure)) %>%
    left_join(prevalence_df, by = join_by(species, rarity)) %>%
    mutate(measure_quant = stats::quantile(.data[[measure]], probs = quant)) %>%
    ggplot(aes(x = abv, y = birdcube)) +
    geom_point(aes(shape = rarity, colour = .data[[measure]]), size = 2) +
    ggrepel::geom_text_repel(
      aes(label = ifelse(.data[[measure]] > measure_quant,
                         paste0(species, "\n(value: ",
                                round(.data[[measure]], 3), ")"),
                         NA)
          ),
      size = 2.5, max.overlaps = max.overlaps
    ) +
    labs(x = "Proportion of occupied grid cells\nin ABV dataset",
         y = "Proportion of occupied grid cells\nin cube dataset",
         shape = "Rarity") +
    scale_colour_viridis_c(option = "turbo") +
    theme_minimal()
}
