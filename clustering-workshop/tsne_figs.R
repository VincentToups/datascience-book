library(tidyverse)
library(Rtsne)

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

clusters <- read_csv("derived_data/clustered_characters.csv", show_col_types = FALSE)

perp <- max(5, min(30, floor((nrow(imputed)-1)/3)))
tsne_res <- Rtsne(imputed %>% as.matrix(), dims=2, perplexity=perp, verbose=FALSE, check_duplicates=FALSE)
tsne <- tsne_res$Y %>% as_tibble() %>% mutate(character_name=df$character_name) %>% setNames(c("TSNE1","TSNE2","character_name"))
dfp <- tsne %>% inner_join(clusters, by="character_name")

g_plain <- ggplot(dfp, aes(TSNE1, TSNE2)) + geom_point()
ggsave("figures/tsne_scatter.png", g_plain, width=7, height=5, dpi=150)

g_cluster <- ggplot(dfp, aes(TSNE1, TSNE2)) + geom_point(aes(color=factor(cluster)))
ggsave("figures/tsne_clusters.png", g_cluster, width=7, height=5, dpi=150)

# save TSNE projection
write_csv(dfp, "derived_data/tsne_projection.csv")
