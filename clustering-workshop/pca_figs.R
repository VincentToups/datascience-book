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

df <- read_csv("derived_data/power_grid_characters_imputed.csv", show_col_types = FALSE) %>% fix_df_names()
imputed <- df %>% select(-character_name)

pc_res <- prcomp(imputed)
pcs <- pc_res$x %>% as_tibble() %>% mutate(character_name=df$character_name)

clusters <- read_csv("derived_data/clustered_characters.csv", show_col_types = FALSE)
dfp <- pcs %>% inner_join(clusters, by="character_name")

# save PCA projection
write_csv(dfp, "derived_data/pca_projection.csv")

# PCA scatter colored by cluster
g1 <- ggplot(dfp, aes(PC1, PC2)) + geom_point(aes(color=factor(cluster)))
ggsave("figures/pca_scatter.png", g1, width=7, height=5, dpi=150)

# cumulative variance explained
explained <- (pc_res$sdev^2)/sum(pc_res$sdev^2)
cumvar <- tibble(component = seq_along(explained), cumvar = cumsum(explained))
g2 <- ggplot(cumvar, aes(component, cumvar)) + geom_line() + geom_point()
ggsave("figures/pca_cumvar.png", g2, width=7, height=5, dpi=150)
