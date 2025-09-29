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


df <- read_csv("derived_data/power_grid_characters.csv") %>% select(-url) %>%
  pivot_wider(id_cols = "character_name", names_from = power_category, values_from = numeric_level, values_fn = mean) %>%
  fix_df_names()

imputed <- (df %>%
              select(-character_name) %>%
              mutate(across(everything(),function(x) x + 0.2*rnorm(length(x)))) %>%
              as.data.frame() %>%
              missForest::missForest())$ximp %>% as_tibble()

df <- imputed %>% mutate(character_name=df$character_name)

pc_res <- prcomp(imputed)



pcs <- pc_res$x %>% as_tibble() %>% mutate(character_name=df$character_name)

df <- df %>% inner_join(pcs, by="character_name") %>% as_tibble()

r <- clusGap(imputed %>% as.matrix(), kmeans, K.max=30 )
optimal_k <- maxSE(r$Tab[, "gap"], r$Tab[, "SE.sim"], method = "Tibs2001SEmax")

c_res <- kmeans(imputed %>% as.matrix(), optimal_k)

df <- df %>% mutate(cluster = c_res$cluster);

ggplot(df, aes(PC1, PC2)) + geom_point(aes(color=factor(cluster)))

# cumulative variance explained for PCA
explained <- (pc_res$sdev^2)/sum(pc_res$sdev^2)
cumvar <- tibble(component = seq_along(explained), cumvar = cumsum(explained))
ggplot(cumvar, aes(component, cumvar)) + geom_line() + geom_point()

# 2D t-SNE and cluster visualization
perp <- max(5, min(30, floor((nrow(imputed)-1)/3)))
tsne_res <- Rtsne(imputed %>% as.matrix(), dims=2, perplexity=perp, verbose=FALSE, check_duplicates=FALSE)
tsne <- tsne_res$Y %>% as_tibble() %>% mutate(character_name=df$character_name) %>% setNames(c("TSNE1","TSNE2","character_name"))
df <- df %>% inner_join(tsne, by="character_name")
ggplot(df, aes(TSNE1, TSNE2)) + geom_point()
ggplot(df, aes(TSNE1, TSNE2)) + geom_point(aes(color=factor(cluster)))

df %>% group_by(cluster) %>% summarise(characters = paste(character_name, collapse=", "),
                                       across(intelligence:fighting_skills, mean))
ldf <- df %>%
  select(intelligence:character_name, cluster) %>%
  pivot_longer(intelligence:fighting_skills)

ggplot(ldf, aes(factor(cluster),value)) + geom_violin(aes(fill=factor(name)),scale="width") +
  geom_vline(data=tibble(x=(-1:optimal_k+1)-0.5),aes(xintercept=x),linewidth=3)











