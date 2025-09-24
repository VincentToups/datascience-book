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
  inner_join(read_csv("source_data/genders.csv"), by = "character") %>%
  inner_join(read_csv("source_data/season_map.csv") %>% mutate(episode_number=episode_number+100), by="episode_number") %>%
  mutate(season = factor(season, levels = 1:7))

okabe_ito <- c(
  "female" = "#0072B2",   # blue
  "male"   = "#D55E00",   # vermillion
  "other"  = "#CC79A7"    # reddish purple
)

ggplot(g, aes(factor(character, main_characters), n)) +
  geom_violin(aes(fill = gender), color = "black") +
  geom_jitter(width = 0.2, alpha = 0.25, color = "black", size = 1) +
  scale_fill_manual(values = okabe_ito) +
  facet_wrap(~ season, ncol = 2, drop=FALSE) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

ggmd(last_plot())
