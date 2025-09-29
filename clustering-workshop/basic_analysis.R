library(tidyverse)

# Provide a no-op mddf if not available to avoid errors during Make
if(!exists("mddf")){
  mddf <- function(...) invisible(NULL)
}

mk_logger <- function(filename){
  cat("", file=filename)
  function(...){
    cat(sprintf(...),file=filename,append=T)
  }
}

note_bene <- mk_logger("logs/basic_observations.md");

data <- read_csv("derived_data/power_grid_characters.csv");

records_per_character <- data %>% group_by(character_name) %>% tally(name="records_per_character")

ggplot(records_per_character, aes(records_per_character)) + geom_histogram(stat="count");
ggsave("figures/records_per_character.png", last_plot());

tbl <- records_per_character %>% pull(records_per_character) %>% table();

note_bene("We see the following counts in our data set (record count per character, number of characters): %s.",
          paste(sprintf("%s (%d)", names(tbl), tbl),
                collapse=", "))

eg7 <- data %>% filter(character_name %in%
                        (records_per_character %>% filter(records_per_character==7) %>% pull(character_name)))

mddf(eg7)

eg9 <- data %>% filter(character_name %in%
                                      (records_per_character %>% filter(records_per_character==7) %>% pull(character_name)))

mddf(eg9)

note_bene("Manual examination of URLs associated with characters with more than 6 recordings indicate that some characters have multiple 'modes' and so have different stats. We will exclude these characters for now. Characters with few elements appear to be those for whom these were simply not recorded, usually because they are humans.")





