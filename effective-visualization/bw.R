# Black & white (grayscale)
library(tidyverse)

main_characters <- ("PICARD RIKER DATA GEORDI WORF BEVERLY TROI WESLEY PULASKI TASHA" %>%
  str_split(" ", simplify=TRUE))

d <- read_csv("source_data/tng.csv")
g <- d %>%
  group_by(character, episode_number) %>%
  tally() %>%
  ungroup() %>%
  arrange(desc(n)) %>%
  mutate(x = row_number()) %>%
  filter(character %in% main_characters) %>%
  inner_join(read_csv("source_data/genders.csv"), by = "character")

ggplot(g, aes(factor(character, main_characters), n)) +
  geom_violin(aes(fill = gender), color = "black") +
  geom_jitter(width = 0.2, alpha = 0.25, color = "black", size = 1) +
  scale_fill_grey(start = 0.25, end = 0.85)

ggmd(last_plot())
