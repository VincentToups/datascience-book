library(tidyverse)
library(plotly)
library(htmlwidgets)

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

df_raw <- read_csv("derived_data/power_grid_characters.csv", show_col_types = FALSE)
char_url <- df_raw %>% group_by(character_name) %>% summarise(url = first(url), .groups = "drop")
df <- read_csv("derived_data/power_grid_characters_imputed.csv", show_col_types = FALSE) %>% fix_df_names()

tsne <- read_csv("derived_data/tsne_projection.csv", show_col_types = FALSE)

dfp <- df %>%
  select(intelligence:fighting_skills, character_name) %>%
  inner_join(tsne %>% select(character_name, TSNE1, TSNE2, cluster), by="character_name") %>%
  left_join(char_url, by = "character_name")

spark_from_stats <- function(v){
  # v expected length 6 with values typically 1..7
  blocks <- c("▁","▂","▃","▄","▅","▆","▇","█")
  v2 <- v
  v2[is.na(v2)] <- 0
  idx <- pmin(pmax(as.integer(round(v2)), 0), 7) + 1
  paste(blocks[idx], collapse = "")
}

spark_from_scaled <- function(v_norm){
  # v_norm in [0,1], scale to 8 block levels
  blocks <- c("▁","▂","▃","▄","▅","▆","▇","█")
  v2 <- v_norm
  v2[is.na(v2)] <- 0
  v2 <- pmin(pmax(v2, 0), 1)
  idx <- as.integer(round(v2 * 7)) + 1
  paste(blocks[idx], collapse = "")
}

sparks <- apply(dfp %>% select(intelligence:fighting_skills) %>% as.matrix(), 1, spark_from_stats)
hover <- paste0("<b>", dfp$character_name, "</b><br/>",
                "stats: ", sparks)
dfp <- dfp %>% mutate(hover = hover)

# Build legend labels with cluster-average sparklines
stats_cols <- c("intelligence","strength","speed","durability","energy_projection","fighting_skills")
cluster_means <- dfp %>% group_by(cluster) %>% summarise(across(all_of(stats_cols), mean), .groups="drop")

# global scaling based on entire dataset ranges
mins <- sapply(stats_cols, function(x) min(dfp[[x]], na.rm = TRUE))
maxs <- sapply(stats_cols, function(x) max(dfp[[x]], na.rm = TRUE))

cluster_labels <- cluster_means %>% rowwise() %>% mutate(
  label = {
    vals <- c_across(all_of(stats_cols))
    scaled <- (vals - mins[stats_cols]) / pmax(1e-9, (maxs[stats_cols] - mins[stats_cols]))
    paste0("Cluster ", cluster, " ", spark_from_scaled(scaled))
  }
) %>% ungroup() %>% select(cluster, label)

# Create one trace per cluster with custom legend name
p <- plotly::plot_ly()
for(k in sort(unique(dfp$cluster))){
  lab <- (cluster_labels %>% filter(cluster==k) %>% pull(label))
  dsub <- dfp %>% filter(cluster==k)
  p <- p %>% add_trace(data=dsub,
                       x=~TSNE1, y=~TSNE2,
                       type="scatter", mode="markers",
                       name=lab[[1]],
                       text=~hover, hoverinfo="text",
                       customdata=~url,
                       marker=list(size=6),
                       showlegend=TRUE)
}

p <- p %>% layout(
  legend = list(title = list(text = "Clusters (avg stats sparkline; global-scaled)")),
  title = list(text = "t-SNE of Power Grid — Sparkline order: intelligence, strength, speed, durability, energy_projection, fighting_skills",
               x = 0.01)
)

p <- htmlwidgets::onRender(p, "function(el, x){
  el.on('plotly_click', function(d){
    var url = d.points[0].customdata;
    if(url){ window.open(url, '_blank'); }
  });
}")

saveWidget(as_widget(p), "figures/tsne_interactive.html", selfcontained = TRUE)
