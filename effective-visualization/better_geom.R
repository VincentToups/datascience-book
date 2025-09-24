library(tidyverse)

main_characters <- ("PICARD RIKER DATA GEORDI WORF BEVERLY TROI WESLEY PULASKI TASHA" %>% str_split(" ",simplify=TRUE))

d <- read_csv("source_data/tng.csv")
g <- d %>%
  group_by(character,episode_number) %>%
  tally()  %>% ungroup() %>%
  arrange(desc(n)) %>%
  mutate(x=row_number()) %>%
  filter(character %in% main_characters)

ggplot(g) +
  geom_boxplot(aes(factor(character, main_characters),n))

ggmd(last_plot())




