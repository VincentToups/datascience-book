library(tidyverse)
library(cluster)

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

df <- read_csv("derived_data/power_grid_characters_imputed.csv", show_col_types = FALSE)
imputed <- df %>% select(-character_name)

r <- clusGap(imputed %>% as.matrix(), kmeans, K.max=30 )
optimal_k <- maxSE(r$Tab[, "gap"], r$Tab[, "SE.sim"], method = "Tibs2001SEmax")

c_res <- kmeans(imputed %>% as.matrix(), optimal_k)

out <- tibble(character_name = df$character_name, cluster = c_res$cluster)
write_csv(out, "derived_data/clustered_characters.csv")
