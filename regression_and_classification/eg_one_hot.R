library(tidyverse)

d <- read_csv("source_data/Automobile_data.csv")


names(d) <- names(d) %>%
  str_replace_all("-","_") %>%
  str_replace_all("[^_A-Za-z0-9]*","") %>%
  str_to_lower()

scale <- function(a){
  (a - min(a))/(max(a)-min(a))
}



one_hot_encode_one <- function(df, col_name){
  unique_values <- df[[col_name]] %>% unique() %>% `[`(2:length(.))
  values <- df[[col_name]]
  df[[col_name]] <- NULL # delete the old column
  for(v in unique_values){
    new_col_name <- sprintf("%s_%s", col_name, v)
    df[[new_col_name]] <- (values == v) %>% as.numeric()
  }
  df
}

 one_hot_encode <- function(df, columns){
  for(col in columns){
    df <- one_hot_encode_one(df, col)
  }
  df
}

wordnum_to_int <- function(x) {
  dict <- c(zero=0, one=1, two=2, three=3, four=4, five=5, six=6,
            seven=7, eight=8, nine=9, ten=10, eleven=11, twelve=12)
  x <- tolower(trimws(as.character(x)))
  as.integer(unname(dict[x]))  # unknowns -> NA
}

# Pipeline
d_clean <-
  d %>%
  dplyr::select(-symboling, -normalized_losses) %>%
  dplyr::mutate(
    price = price %>% as.numeric(),
    bore=bore %>% as.numeric(),
    stroke=stroke %>% as.numeric(),
    peak_rpm=peak_rpm %>% as.numeric(),
    horsepower = horsepower %>% as.numeric()) %>%
  dplyr::mutate(
    dplyr::across(
      dplyr::any_of(c("num_of_doors", "num_of_cylinders")),
      wordnum_to_int
    )
  ) %>%
  one_hot_encode(names(dplyr::select(., where(is.character)))) 

lbdr(names(d_clean))

ensure_directory("derived_data")

d_clean %>% filter(complete.cases(.)) %>% 
  write_csv("derived_data/mileage_prepped.csv")