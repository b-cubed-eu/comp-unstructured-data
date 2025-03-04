get_dataset_names <- function(df) {
  require("dplyr")
  require("rlang")

  unique_datasets <- df %>%
    distinct("datasetkey", "datasetname")

  dataset_names <- sapply(as.list(unique_datasets$datasetkey), function(key) {
    rgbif::dataset_get(key)$title
  })

  # Complete dataset
  full_dataset_df <- unique_datasets %>%
    mutate(datasetname = coalesce(.data$datasetname, dataset_names))

  # Add dataset names
  df_out <- df %>%
    select(-"datasetname") %>%
    left_join(full_dataset_df, by = join_by("datasetkey"))

  return(df_out)
}
