#' Fit group-wise linear models and extract slope statistics
#'
#' Fits a simple linear regression `y ~ x` separately for each group in a
#' data frame and returns per-group slope statistics.
#'
#' Groups are processed in the order of factor levels if the grouping variable
#' is a factor; otherwise, groups are processed in the order of appearance in
#' the data.
#'
#' Optionally, the fitted `lm` objects can be returned and a transformation
#' can be applied to the response variable before model fitting.
#'
#' @param data A data frame containing the variables used in the analysis.
#' @param group_var Character string giving the name of the grouping variable.
#' @param x_var Character string giving the name of the predictor variable.
#' @param y_var Character string giving the name of the response variable.
#' @param conf_level Confidence level for the slope confidence interval.
#'   Defaults to `0.95`.
#' @param y_transform Optional function applied to the response variable
#'   before fitting the model (e.g. `log`, `sqrt`,
#'   `function(y) log(y + 1)`). Defaults to `NULL`.
#' @param return_lm Logical; if `TRUE`, the fitted `lm` objects are
#'   returned in addition to the summary statistics. Defaults to `FALSE`.
#'
#' @return
#' If `return_lm = FALSE`, a data frame with one row per group.
#' If `return_lm = TRUE`, a list with components `coefficients`
#' and `models`.
grouped_lm <- function(data,
                       group_var,
                       x_var,
                       y_var,
                       conf_level = 0.95,
                       y_transform = NULL,
                       return_lm = FALSE) {

  group_vec <- data[[group_var]]

  # Determine group order:
  # - factor: use factor levels
  # - otherwise: use order of appearance
  if (is.factor(group_vec)) {
    groups <- levels(group_vec)
  } else {
    groups <- unique(group_vec)
  }

  results <- vector("list", length(groups))
  names(results) <- groups

  lm_list <- if (return_lm) vector("list", length(groups)) else NULL
  if (return_lm) names(lm_list) <- groups

  for (i in seq_along(groups)) {
    g <- groups[i]

    # Subset data for current group
    df_g <- data[group_vec == g, ]

    # Skip empty factor levels (can happen with unused levels)
    if (nrow(df_g) == 0) {
      next
    }

    y <- df_g[[y_var]]

    # Optional response transformation
    if (!is.null(y_transform)) {
      y <- y_transform(y)
    }

    # Fit linear model
    fit <- lm(y ~ df_g[[x_var]])
    sm <- summary(fit)

    # Extract slope statistics
    slope   <- coef(sm)[2, "Estimate"]
    se      <- coef(sm)[2, "Std. Error"]
    p_value <- coef(sm)[2, "Pr(>|t|)"]
    ci <- confint(fit, level = conf_level)[2, ]

    results[[i]] <- data.frame(
      group = g,
      slope = slope,
      se = se,
      conf_low = ci[1],
      conf_high = ci[2],
      p_value = p_value,
      row.names = NULL
    )

    if (return_lm) {
      lm_list[[i]] <- fit
    }
  }

  # Remove empty entries (unused factor levels)
  results <- Filter(Negate(is.null), results)
  result_df <- do.call(rbind, results)

  if (return_lm) {
    return(list(
      coefficients = result_df,
      models = lm_list[names(lm_list) %in% result_df$group]
    ))
  }

  result_df
}
