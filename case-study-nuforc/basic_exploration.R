library(tidyverse);
library(gridExtra);

# make_logger creates/clears the given file and returns a logger
# function that appends sprintf-formatted messages to that file.
make_logger <- function(filename){
  # Clear the file if it exists (and create it if it doesn't)
  cat("", file = filename)
  # Return a logging function with catfa-like semantics
  function(..., catargs = list()){
    do.call(cat, c(list(sprintf(...), file = filename, append = TRUE), catargs))
  }
}

log <- make_logger("exploration.md")

log("Basic Information about the NUFORC Data Set\n")
log("===========================================\n")

d <- read_csv("source_data/nuforc_sightings.csv")

n <- nrow(d)

log("We begin with %d rows with columns %s.\n\n", n, paste(names(d), collapse=", "))

i <- 1;
for(col in names(d)){
  col_values <- d[[col]]
  missing <- sum(is.na(col_values));
  unique_col_values <- table(col_values) %>% sort(decreasing=T) %>% names()
  n_unique <- length(unique(col_values));
  print_max <- if(n_unique < 50) 50 else 3
  log("%d. %s (%d NA) with %s unique values (eg. %s)\n", i,
      col, missing, n_unique, paste(unique_col_values[1:min(length(unique_col_values),print_max)],collapse=",\n\t"))
  i <- i + 1;
}


log("\n\nMADAR Nodes\n")
log("===========\n")
log("MADAR Nodes refer to an automated device which alerts users to UFO activity. Thought most of the experience descriptions/summaries are free text, a number of them refer to MADAR nodes (%d).\n",
    d %>% filter(str_detect(summary, "MADAR")) %>% nrow())

log("\nMost of the rows have no description or image.\n\n")

log("Shapes are inconcistently capitalized so we will send them all to lowercase and %d rows have no date. Interestingly, there are more missing states than cities. This turns out to be because some reports are from outside the US and do not have a state in that sense. We will also eliminate those sightings that do not have dates and we will restrict ourselves to years after 1945.\n\n", nrow(filter(d, is.na(occurred))))

d <- d %>% filter(!is.na(occurred)) %>% mutate(shape=str_to_lower(shape))

nth <- function(n) function(a) a[n]

parse_date <- function(s){
                          space_split <- s %>% str_split("[-/ :]")
                          tibble(d1 = Map(nth(1), space_split) %>% as.character(),
                                      d2 = Map(nth(2), space_split) %>% as.character(),
                                      d3 = Map(nth(3), space_split) %>% as.character(),
                                      d4 = Map(nth(4), space_split) %>% as.character(),
                                      d5 = Map(nth(5), space_split) %>% as.character())
                          }



dates <- parse_date(d %>% pull(occurred)) %>% mutate(id=d$id)
dates <- dates %>% rename(month=d1, day=d2, year=d3, hour=d4, min=d5)

d <- d %>% inner_join(dates, by="id") %>% filter(year %>% as.numeric() > 1940)

p1 <- (ggplot(d, aes(day)) + geom_histogram(stat="count")) 
p2 <- (ggplot(d, aes(month)) + geom_histogram(stat="count")) 
p3 <- (ggplot(d, aes(year %>% as.numeric())) + geom_histogram(stat="count")) 
p4 <- (ggplot(d, aes(hour %>% as.numeric())) + geom_histogram(stat="count"))
p5 <- (ggplot(d, aes(min %>% as.numeric())) + geom_histogram(stat="count")) 

p <- grid.arrange(p1,p2,p3,p4,p5,nrow=3) %>% ggmd()

ensure_directory("figures")

ggsave("figures/time_diagnostics.png",plot=p)

log("\n![time histograms](./figures/time_diagnostics.png)")

simplify_strings <- function(s){
                                s %>%
                                str_replace_all("[^a-zA-Z0-9[:space:],;]*","") %>%
                                str_to_lower() %>%
                                str_trim() %>%
                                str_replace_all("[[:space:]]+"," ")
  
                                }

log("Furthermore, we treated city, state, country, shape to a simplification procedure where we replaced all non-ascii characters with nothing, downcased, collapses multiple whitespace, and trimmed.")

d <- d %>% mutate(across(city:shape,simplify_strings))

state_counts <- d %>%
  filter(!is.na(state)) %>%
  group_by(state) %>%
  tally() %>%
  arrange(desc(n)) %>%
  filter(n > 500)

states <- ggplot(
  d %>%
    inner_join(state_counts, by = "state") %>%
    filter(!is.na(state)),
  aes(factor(state, state_counts$state))
) +
  geom_histogram(stat = "count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


country_counts <- d %>%
  filter(!is.na(country)) %>%
  group_by(country) %>%
  tally() %>%
  arrange(desc(n)) %>%
  filter(n > 100)

countrys <- ggplot(
  d %>%
    inner_join(country_counts, by = "country") %>%
    filter(!is.na(country)),
  aes(factor(country, country_counts$country))
) +
  geom_histogram(stat = "count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


shape_counts <- d %>%
  filter(!is.na(shape)) %>%
  group_by(shape) %>%
  tally() %>%
  arrange(desc(n)) %>%
  filter(n > 100)

shapes <- ggplot(
  d %>%
    inner_join(shape_counts, by = "shape") %>%
    filter(!is.na(shape)),
  aes(factor(shape, shape_counts$shape))
) +
  geom_histogram(stat = "count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


g1 <- grid.arrange(countrys, states, nrow = 1)
g2 <- grid.arrange(g1, states) %>% ggmd()
g2

ggsave("figures/state_country_shape.png",plot=g2)

log("\n![state, country, shape histograms](./figures/state_country_shape.png)\n")

d <- d %>% mutate(date = as.POSIXct(sprintf("%s-%s-%s %s:%s", year, month, day, hour, min))) %>%
  select(-hour, -min, -year, -month, -day, -occurred, -reported)

deduplicated <- d %>% select(-id, -link_url) %>% distinct()

log("\nAfter these transformations and neglecting obvious id columns, deduplication reduced our row count by %d.\n", nrow(d)-nrow(deduplicated))

d %>% group_by(city, state, country, shape, summary, has_image, explanation, date) %>% tally() %>% filter(n>1)

log("\nExamination of these duplicates indicated genuine duplication.\n", nrow(d)-nrow(deduplicated))

ensure_directory("derived_data")
write_csv(deduplicated, "derived_data/tidied_deduplicated.csv")

