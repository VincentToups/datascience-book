library(tidyverse)

fix_strings <- function(s){
  s %>%
    str_to_lower() %>%
    str_replace_all("[[:space:]\n]+","_") %>%
    str_replace_all("[^a-zA-Z_]","")
}
fix_df_names <- function(df){
  names(df) <- fix_strings(names(df))
  df
}

# Read long-format power grid data and pivot to wide by character
df <- read_csv("derived_data/power_grid_characters.csv") %>%
  select(-url) %>%
  pivot_wider(id_cols = "character_name",
              names_from = power_category,
              values_from = numeric_level,
              values_fn = mean) %>%
  fix_df_names()

# Run missForest on the numeric columns only and write imputed wide data
imputed <- (df %>%
              select(-character_name) %>%
              mutate(across(everything(), function(x) x + 0.2*rnorm(length(x)))) %>%
              as.data.frame() %>%
              missForest::missForest())$ximp %>% as_tibble()

out <- bind_cols(df %>% select(character_name), imputed)
write_csv(out, "derived_data/power_grid_characters_imputed.csv")

