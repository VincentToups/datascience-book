#!/usr/bin/env Rscript

library(tidyverse)
library(maps)
library(cowplot)

# Hard-coded abbreviation -> state name mapping
state_map <- tribble(
  ~state, ~name,
  "al", "Alabama",
  "ak", "Alaska",
  "az", "Arizona",
  "ar", "Arkansas",
  "ca", "California",
  "co", "Colorado",
  "ct", "Connecticut",
  "de", "Delaware",
  "fl", "Florida",
  "ga", "Georgia",
  "hi", "Hawaii",
  "id", "Idaho",
  "il", "Illinois",
  "in", "Indiana",
  "ia", "Iowa",
  "ks", "Kansas",
  "ky", "Kentucky",
  "la", "Louisiana",
  "me", "Maine",
  "md", "Maryland",
  "ma", "Massachusetts",
  "mi", "Michigan",
  "mn", "Minnesota",
  "ms", "Mississippi",
  "mo", "Missouri",
  "mt", "Montana",
  "ne", "Nebraska",
  "nv", "Nevada",
  "nh", "New Hampshire",
  "nj", "New Jersey",
  "nm", "New Mexico",
  "ny", "New York",
  "nc", "North Carolina",
  "nd", "North Dakota",
  "oh", "Ohio",
  "ok", "Oklahoma",
  "or", "Oregon",
  "pa", "Pennsylvania",
  "ri", "Rhode Island",
  "sc", "South Carolina",
  "sd", "South Dakota",
  "tn", "Tennessee",
  "tx", "Texas",
  "ut", "Utah",
  "vt", "Vermont",
  "va", "Virginia",
  "wa", "Washington",
  "wv", "West Virginia",
  "wi", "Wisconsin",
  "wy", "Wyoming"
)

# --- Read data ---
# d is analysis dataset with col 'state' (two-letter abbrev, lowercase)
d <- read_csv("derived_data/tidied_deduplicated.csv", show_col_types = FALSE) %>%
  group_by(state) %>% tally(name = "count") %>%
  filter(!is.na(state) & state %in% state_map$state) %>%
  inner_join(state_map, by = "state") %>%
  mutate(region = tolower(name))

# --- Map polygons and join ---
us_map <- map_data("state") %>% as_tibble() # long, lat, group, order, region, subregion

map_df <- us_map %>%
  left_join(d %>% select(region, count), by = "region")

# --- Plot (counts, no normalization) ---
p_map <- ggplot(map_df, aes(long, lat, group = group, fill = count)) +
  geom_polygon(color = "white", linewidth = 0.2) +
  coord_quickmap() +
  scale_fill_viridis_c(
    name = "Sightings (count)",
    trans = "sqrt",      # stabilize skew; remove if undesired
    na.value = "grey90"
  ) +
  labs(
    title = "UFO Sightings by State (Counts)",
    subtitle = "NUFORC deduplicated sightings; no population normalization",
    caption = "Data: NUFORC (derived_data/tidied_deduplicated.csv)"
  ) +
  theme_void(base_size = 11) +
  theme(
    legend.position = "right",
    plot.title = element_text(face = "bold")
  )

# Display if interactive
print(p_map)

# Save
if (!dir.exists("figures")) dir.create("figures", recursive = TRUE)
ggsave("figures/sightings_counts_map.png",
       plot = p_map, width = 11, height = 7, dpi = 300, bg = "white")
