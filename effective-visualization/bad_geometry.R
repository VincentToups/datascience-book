library(tidyverse)


d <- read_csv("source_data/tng.csv")
g <- d %>%
  group_by(character) %>%
  tally()  %>%
  arrange(desc(n)) %>%
  mutate(x=row_number()) %>%
  filter(n>1000)

ggplot(g, aes(x,n)) +
  geom_line() +
  labs(title="Star Trek Dialog Counts Per Character",x="Character",y="Count") +
  scale_x_continuous(breaks=g$x, labels=g$character)

ggmd(last_plot())




