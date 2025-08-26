# Function to determine the structure of the data frames in a list
get_df_structure <- function(df_list) {
  require("dplyr")

  non_na_df <- df_list %>% plyr::compact() %>% first()
  empty_df <- purrr::map(non_na_df, ~ NA)
  empty_df <- as_tibble(empty_df)
  return(empty_df)
}

# Function to find the taxon keys that match search values best
find_df_name <- function(df_list, search_value, lang = NA) {
  require("dplyr")

  # Check how many times the value is present in each dataframe
  contains_value <- purrr::map(df_list, function(df) {
    if (is.na(lang)) {
      vernacular_names <- df %>%
        pull(.data$vernacularName)
    } else {
      vernacular_names <- df %>%
        dplyr::filter(.data$language == lang) %>%
        pull(.data$vernacularName)
    }

    # Count number of matches (exact match and ignore case)
    sum(grepl(paste0("^\\s*", search_value, "\\s*$"), vernacular_names,
              ignore.case = TRUE))
  })

  # Sort species keys from most to least matches
  contains_value <- contains_value[order(unlist(contains_value),
                                         decreasing = TRUE)]
  contains_value <- contains_value[contains_value != 0]

  # Get species key with most matches
  df_name <- names(contains_value)[1]

  # Return the name
  return(df_name)
}

# Return accepted taxonomic information
get_accepted_name_usage <- function(taxon_data) {
  require("dplyr")

  if ("acceptedKey" %in% colnames(taxon_data)) {
    taxon_key <- taxon_data %>% pull(.data$acceptedKey)
    return(rgbif::name_usage(taxon_key)$data)
  } else {
    taxon_key <- taxon_data %>% pull(.data$key)
    return(rgbif::name_usage(taxon_key)$data)
  }
}

# Match vernacular names with GBIF taxonomic backbone
# Inspired by:
# https://gist.github.com/damianooldoni/3fa9cc1ffa67377a9757df097d48d19f
match_vernacular_name <- function(
    vernacular_name_df,
    filter_cols = NULL,
    lang = NA,
    increment = 0,
    ...) {
  # Get vernacular name
  vernacular_name <- pull(vernacular_name_df[1])

  # Get limit
  dots <- list(...)
  if ("limit" %in% names(list(...))) {
    limit <- dots$limit
    dots <- dots[names(dots) != "limit"]
  } else {
    limit <- 100
  }

  # Loop variable
  stop_loop <- FALSE

  # Loop until match is found or limit reaches maximum of 3000
  while (isFALSE(stop_loop) && limit < 3000) {
    # Lookup vernacular names in GBIF backbone
    gbif_lookup <- do.call(
      rgbif::name_lookup,
      c(list(vernacular_name),
        list(datasetKey = "d7dddbf4-2cf0-4f39-9b2a-bb099caae36c"),
        list(limit = limit),
        dots)
    )

    # Return taxon data frame if match found
    if (nrow(gbif_lookup$data) > 0) {
      # Define vernacular names and taxon data
      vernacular_names <- gbif_lookup$names
      taxon_data <- gbif_lookup$data

      # Use filter columns if provided
      if (!is.null(filter_cols)) {
        # In case of NA values
        cols_to_remove <- vernacular_name_df %>%
          select(where(~ any(is.na(.)))) %>%
          colnames()
        filter_cols <- filter_cols[!filter_cols %in% cols_to_remove]

        # Create the join condition dynamically
        join_condition <- stats::setNames(names(filter_cols),
                                          unlist(filter_cols))

        # Perform the inner join to select taxon data
        taxon_data <- vernacular_name_df %>%
          select(where(~ all(!is.na(.)))) %>%
          inner_join(taxon_data, by = join_condition, keep = TRUE) %>%
          select(-all_of(setdiff(colnames(vernacular_name_df), cols_to_remove)))

        # Use species keys to select vernacular names
        indices <- names(vernacular_names) %in% taxon_data$key
        vernacular_names <- vernacular_names[indices]
      }
    } else {
      return(NA_character_)
    }

    # Increment limit if required
    if (length(vernacular_names) == 0 && increment > 0) {
      limit <- limit + increment
    } else {
      stop_loop <- TRUE
    }
  }


  # Search taxon key in vernacular names
  if (length(vernacular_names) > 0) {
    taxon_key <- find_df_name(vernacular_names, vernacular_name, lang)

    # Return NA if no good match found
    if (is.na(taxon_key)) {
      return(NA_character_)
      # Return match with taxon key
    } else {
      out_data <- taxon_data[taxon_data$key == taxon_key, ]
      out_data <- out_data[, colSums(is.na(out_data)) < nrow(out_data)]

      return(get_accepted_name_usage(out_data))
    }
  } else {
    return(NA_character_)
  }
}

# Input dataframe with vernacular names and get taxon information
map_taxa_from_vernacular <- function(
    vernacular_name_df,
    vernacular_name_col = "vernacularName",
    out_cols = "scientificName",
    filter_cols = NULL,
    lang = NA,
    increment = 0,
    ...) {
  require("dplyr")
  require("tidyr")

  group_cols <- unlist(filter_cols, use.names = FALSE)

  # Match vernacular names to get taxonomic info
  matched_names_df <- vernacular_name_df %>%

    # group  by vernacular name and compact the data
    group_by(across(all_of(c(vernacular_name_col, group_cols)))) %>%
    nest() %>%
    ungroup() %>%
    nest(match_df = all_of(c(vernacular_name_col, group_cols))) %>%

    # find scientific name for each (distinct) vernacular name
    mutate(
      taxon_df = purrr::map(
        .data$match_df,
        match_vernacular_name,
        filter_cols = filter_cols,
        lang = lang,
        increment = increment,
        ...
      )
    ) %>%
    unnest("match_df") %>%

    # Remove unneeded columns
    select(-"data")

  # Create output dataframe
  out_df <- matched_names_df %>%

    # Unnest taxon dataframes
    mutate(taxon_df = purrr::map(.data$taxon_df, ~ {
      # Unnesting only possible if all dataframes have the same structure
      if (all(is.na(.x))) {
        get_df_structure(matched_names_df$taxon_df)
      } else {
        .x
      }
    })
    ) %>%
    unnest("taxon_df") %>%
    ungroup() %>%

    # Add other columns from input df
    right_join(
      vernacular_name_df,
      by = c(vernacular_name_col, group_cols)
    ) %>%

    # Set desired column(s) at the right side
    select(all_of(names(vernacular_name_df)), all_of(out_cols)) %>%

    # Reorder rows based on original order in input df
    right_join(vernacular_name_df, by = names(vernacular_name_df))

  return(out_df)
}
