# Load the previously saved value counts and derive ok_values
value_counts <- read_csv("derived_data/value_counts.csv")
ok_values <- value_counts %>% filter(n>=10) %>% pull(value)
ok_values_df <- tibble(value = ok_values)

# Persist for any later blocks that need it
write_csv(ok_values_df, "derived_data/ok_values.csv")

mddf_simple(ok_values_df, n=100)
```

Note that we can filter out the unwanted properties with a line like:

```R 
library(tidyverse)

# Demonstration of filtering with ok_values; make it self-contained
tidied_data <- read_csv("derived_data/tidied_data.csv")
ok_values <- read_csv("derived_data/ok_values.csv") %>% pull(value)

tidied_data <- tidied_data %>% filter(value %in% ok_values)
mddf_simple(tidied_data, n=100)
```

But this is a reasonably good time to introduce *joins*.


::chunks/09_joins:Next: Joins::
