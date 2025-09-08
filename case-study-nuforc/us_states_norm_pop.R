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
# d is your analysis dataset with col 'state' (two-letter abbrev, lowercase)
d <- read_csv("derived_data/tidied_deduplicated.csv") %>%
  group_by(state) %>% tally() %>%
  filter(!is.na(state) & (state %in% state_map$state))

# population data (CSV has columns: state (full name), population)
pop <- read_csv("derived_data/us_state_population_2024.csv", show_col_types = FALSE) %>%
  inner_join(state_map, by = c(state = "name"), suffix = c(".full", ".map")) %>%
  transmute(full_name = state.full, state = state.map, population)

data <- d %>%
  inner_join(pop, by = "state") %>%
  mutate(sightings_per_thousand = 1000 * n / population)

# --- Build choropleth data (join to map polygons by lowercase state name) ---
us_map <- map_data("state") %>% as_tibble() # cols: long, lat, group, order, region, subregion

map_df <- us_map %>%
  left_join(data %>% mutate(region = tolower(full_name)),
            by = "region")

# --- Plot ---
p_map <- ggplot(map_df, aes(long, lat, group = group, fill = sightings_per_thousand)) +
  geom_polygon(color = "white", linewidth = 0.2) +
  coord_quickmap() +
  scale_fill_viridis_c(
    name = "Sightings per\n1,000 people",
    trans = "sqrt",            # spread skewed rates
    na.value = "grey90"
  ) +
  labs(
    title = "UFO Sightings per 1,000 People by State",
    subtitle = "NUFORC sightings (deduplicated) joined to Census Vintage 2024 population",
    caption = "Data: NUFORC (derived_data/tidied_deduplicated.csv) & U.S. Census Vintage 2024 (us_state_population_2024.csv)"
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
ggsave("figures/sightings_per_thousand_map.png",
       plot = p_map, width = 11, height = 7, dpi = 300, bg = "white")
