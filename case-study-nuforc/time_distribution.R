library(tidyverse)

nuforc <- read_csv("source_data/nuforc_sightings.csv")

split_counts <- Map(length, nuforc %>%
              pull("occurred") %>%
              str_split ("/")) %>%
  as.numeric();

sc_table <- split_counts %>% table()

nuforc %>% filter(split_counts == 1)

have_dates <- nuforc %>% filter(split_counts == 3);

parse_date <- function(s){
  space_split <- s %>% str_split("[-/ :]")
  tibble(d1 = Map(nth(1), space_split) %>% as.character(),
         d2 = Map(nth(2), space_split) %>% as.character(),
         d3 = Map(nth(3), space_split) %>% as.character(),
         d4 = Map(nth(4), space_split) %>% as.character(),
         d5 = Map(nth(5), space_split) %>% as.character())
}

nth <- function(n) function(a) a[n]

dates <- parse_date(have_dates %>% pull(occurred)) %>% mutate(id=have_dates$id)

(ggplot(dates, aes(d1)) + geom_histogram(stat="count")) %>% ggmd()
(ggplot(dates, aes(d2)) + geom_histogram(stat="count")) %>% ggmd()
(ggplot(dates, aes(d3 %>% as.numeric())) + geom_histogram(stat="count")) %>% ggmd()
(ggplot(dates, aes(d3 %>% as.numeric())) + geom_histogram(stat="count") + xlim(1980, 2025)) %>% ggmd()

dates <- dates %>% rename(month=d1, day=d2, year=d3, hour=d4, min=d5)

(ggplot(dates, aes(min %>% as.numeric())) + geom_histogram(stat="count"))

dates <- dates %>% mutate(date = as.POSIXct(sprintf("%s-%s-%s %s:%s", year, month, day, hour, min)))

nuforc <- nuforc %>% inner_join(dates, by="id")

