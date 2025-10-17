library(tidyverse)

d <- read_csv("derived_data/mileage_prepped.csv") %>%
  select(-city_mpg);
  
f <- highway_mpg ~ . 

m <- lm(f, d)

mdpre(summary(m))
lbdr(m)
