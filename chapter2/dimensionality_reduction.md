Dimensionality Reduction
========================

Here is a very concrete example of dimensionality reduction:

Consider these voltage traces from a (simulated) neuron.
```R file=plot_voltages.R
library(tidyverse)

voltages <- read_csv("voltages_wide.csv")

voltages_long <- voltages %>%
  select(-label,index) %>%
  pivot_longer(
    cols = `0`:`250`,
    names_to = "time",
    values_to = "voltage"
  ) %>%
  mutate(time = as.numeric(time)) %>%
  filter(complete.cases(.))


p <- ggplot(voltages_long, aes(x = time, y = voltage, group = index)) +
  geom_line(alpha = 0.5) +
  labs(x = "Time", y = "Voltage", title = "Voltage Time Series") +
  theme_minimal()

write_csv(voltages_long,"voltages_long.csv")

ggmd(p)

```
```R file=pca.R
# pca_summary.R
# Load voltages_wide.csv, run PCA on time columns, plot cumulative variance vs PCs
# and scatter of PC1 vs PC2.

library(tidyverse)

# Load data
df <- read_csv("voltages_wide.csv", show_col_types = FALSE)

# Identify and order time columns numerically in (0, 250]
time_cols <- names(df) |>
  discard(~ .x %in% c("trial", "label", "index")) |>
  keep(~ !is.na(suppressWarnings(as.numeric(.x)))) |>
  keep(~ {
    v <- as.numeric(.x)
    v > 0 && v <= 250
  }) |>
  (\(x) x[order(as.numeric(x))])()

# Matrix for PCA
X <- df |>
  select(all_of(time_cols)) |>
  drop_na() |>
  as.matrix()

# PCA
pca <- prcomp(X, center = TRUE, scale. = TRUE)

# Variance explained
ve <- (pca$sdev^2) / sum(pca$sdev^2)
ve_tbl <- tibble(
  PC = seq_along(ve),
  cum_var = cumsum(ve)
)

# Plot 1: cumulative variance explained
p_var <- ggplot(ve_tbl, aes(x = PC, y = cum_var)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, 1)) +
  labs(
    title = "Cumulative Variance Explained",
    x = "Number of Principal Components",
    y = "Cumulative Variance"
  ) +
  theme_minimal()

ggmd(p_var)

# Plot 2: scatter of first two PCs
scores <- as_tibble(pca$x[, 1:2], .name_repair = "minimal") |>
  rename(PC1 = 1, PC2 = 2)

ve1 <- scales::percent(ve[1])
ve2 <- scales::percent(ve[2])

p_scatter <- ggplot(scores, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "PCA Scores Scatterplot",
    x = paste0("PC1 (", ve1, ")"),
    y = paste0("PC2 (", ve2, ")")
  ) +
  theme_minimal()

ggmd(p_scatter)

write_csv(scores, "projection.csv");

```
Ok, so we can see that there are just three types of voltage traces. 

We can use ::clustering:clustering:: to get which traces belong in which cluster.