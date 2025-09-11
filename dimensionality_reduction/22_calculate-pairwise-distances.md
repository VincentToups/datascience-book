# Calculate pairwise distances
``` R acc=distances load_state=spikes_setup save_state=distances
distance_matrix <- pairwise_victor_purpura(df, q)

## Plot distance matrix as heatmap with ggplot
library(tidyr); library(tibble); library(ggplot2)
dm_df <- as_tibble(as.data.frame(distance_matrix)) %>%
  mutate(row = row_number()) %>%
  pivot_longer(cols = -row, names_to = "col", values_to = "value") %>%
  mutate(col = suppressWarnings(as.numeric(gsub("^[^0-9]*", "", col))))
ggmd(ggplot(dm_df, aes(x = col, y = row, fill = value)) +
       geom_raster() +
       scale_y_reverse() +
       coord_fixed() +
       scale_fill_viridis_c(option = "C") +
       labs(x = "Col", y = "Row", fill = "Dist"))
```

Next: ::23_load-necessary-libraries:Load necessary libraries::
