library(readr)
library(dplyr)

# Read the official all-states CSV directly from Census
raw <- readr::read_csv("https://www2.census.gov/programs-surveys/popest/datasets/2020-2024/state/totals/NST-EST2024-ALLDATA.csv"
                     , show_col_types = FALSE)

# Filter to states (SUMLEV 040), exclude DC and Puerto Rico; select 2024 estimate
states <- raw %>%
  filter(as.integer(SUMLEV) == 40) %>%                # state-level rows
  filter(!NAME %in% c("District of Columbia", "Puerto Rico")) %>%
  transmute(state = NAME,
            population = as.integer(POPESTIMATE2024)) %>%
  arrange(state)

# Basic sanity check: expect 50 states
if (nrow(states) != 50) {
  stop(sprintf("Expected 50 states; got %d. Upstream schema may have changed.", nrow(states)))
}

# Write tidy CSV
readr::write_csv(states, "derived_data/us_state_population_2024.csv", na = "")


