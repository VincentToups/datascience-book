library(tidyverse)

# this is an input, so we point it at where we put our data officially
voltages <- read_csv("source_data/voltages_wide.csv")

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

# this is an output. Let's put it someplace nice.
ensure_directory <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  invisible(TRUE)
}

ensure_directory("derived_data")
write_csv(voltages_long,"derived_data/voltages_long.csv")

ensure_directory("figures")

ggsave("figures/voltages.png")
