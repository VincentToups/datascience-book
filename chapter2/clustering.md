Clustering
==========

The simplest clustering method automatically gives a label to each 
trace:

```R file=cluster.R
# kmeans_pc12_traces.R
# Cluster projection.csv on PC1 & PC2, color-coded scatter,
# then average original traces per cluster and plot mean traces.

# S1: Imports
library(tidyverse)

# S2: Params (k from CLI; default k = 3)
args <- commandArgs(trailingOnly = TRUE)
k <- if (length(args) >= 1 && !is.na(suppressWarnings(as.integer(args[1])))) {
  as.integer(args[1])
} else 3

set.seed(42)

# S3: Load scores and pick PC1, PC2
scores_raw <- read_csv("projection.csv", show_col_types = FALSE)

pc_cols <- c("PC1", "PC2")
if (!all(pc_cols %in% names(scores_raw))) {
  # Fallback: first two numeric columns
  num_cols <- names(scores_raw)[map_lgl(scores_raw, is.numeric)]
  if (length(num_cols) < 2) stop("Need at least two numeric columns or named PC1 and PC2.")
  pc_cols <- num_cols[1:2]
  message(sprintf("Using columns: %s, %s", pc_cols[1], pc_cols[2]))
}

scores <- scores_raw |>
  select(all_of(pc_cols)) |>
  rename(PC1 = 1, PC2 = 2)

# S4: K-means on (PC1, PC2)
if (anyNA(scores)) stop("projection.csv contains NA in PC1/PC2; cannot run k-means safely.")
km <- kmeans(scores[, c("PC1", "PC2")], centers = k, nstart = 25)
scores$cluster <- factor(km$cluster)

# S5: Scatter PC1–PC2 colored by cluster
ggmd(ggplot(scores, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.75) +
  labs(
    title = sprintf("k-means on PC1–PC2 (k = %d)", k),
    x = "PC1",
    y = "PC2",
    color = "Cluster"
  ) +
  theme_minimal())

# S6: Load original wide data and select time columns 0..250 (inclusive)
df <- read_csv("voltages_wide.csv", show_col_types = FALSE)

time_cols <- names(df) |>
  discard(~ .x %in% c("trial", "label", "index")) |>
  keep(~ !is.na(suppressWarnings(as.numeric(.x)))) |>
  keep(~ {
    v <- as.numeric(.x)
    v >= 0 && v <= 250
  }) |>
  (\(x) x[order(as.numeric(x))])()

wide_time <- df |> select(all_of(time_cols))

# S7: Sanity check: rows must match scores to cbind labels
if (nrow(wide_time) != nrow(scores)) {
  stop(sprintf(
    "Row count mismatch: voltages_wide (%d) vs projection.csv (%d).\nEnsure projection.csv was produced from the same rows in the same order.",
    nrow(wide_time), nrow(scores)
  ))
}

labelled <- wide_time |>
  mutate(cluster = scores$cluster);

write_csv(labelled, "labelled_traces.csv")

# S8: Average traces per cluster
avg_wide <- wide_time |>
  mutate(cluster = scores$cluster) |>
  group_by(cluster) |>
  summarise(across(everything(), ~ mean(.x, na.rm = TRUE)), .groups = "drop")

avg_long <- avg_wide |>
  pivot_longer(-cluster, names_to = "time", values_to = "avg_voltage") |>
  mutate(time = as.numeric(time))

# S9: Plot mean traces per cluster
ggmd(ggplot(avg_long, aes(x = time, y = avg_voltage, color = cluster)) +
  geom_line() +
  labs(
    title = "Mean Voltage Traces per Cluster",
    x = "Time",
    y = "Mean Voltage",
    color = "Cluster"
  ) +
  theme_minimal())

```
Now let's cook up a use for ::classification:classification::.