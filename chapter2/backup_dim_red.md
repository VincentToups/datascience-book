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

And now let's use the most common form of dimensionality reduction
there is (principal component analysis):

```R file=pca.R
library(tidyverse)

# S2: Load
df <- read_csv("voltages_wide.csv", show_col_types = FALSE)


time_cols <- names(df) |>
  discard(~ .x %in% c("trial", "label", "index")) |>
  keep(~ !is.na(suppressWarnings(as.numeric(.x)))) |>
  keep(~ {
    v <- as.numeric(.x)
    v > 0 && v <= 250
  })


X <- df |>
  select(all_of(time_cols)) |>
  drop_na() |>
  as.matrix()


pca <- prcomp(X, center = TRUE, scale. = TRUE)


scores <- as_tibble(pca$x[, 1:2], .name_repair = "minimal") |>
  rename(PC1 = 1, PC2 = 2)

ve <- (pca$sdev^2) / sum(pca$sdev^2)
ve1 <- scales::percent(ve[1])
ve2 <- scales::percent(ve[2])


ggmd(ggplot(scores, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "PCA of Voltages (0–250)",
    x = paste0("PC1 (", ve1, ")"),
    y = paste0("PC2 (", ve2, ")")
  ) +
    theme_minimal())



```

After PCA its suddenly clear that there is much less going on in the data than we might
be able to see from a casual examination of the raw data. 

This is data science.


