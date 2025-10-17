library(palmerpenguins)
library(tidyverse)

data(package = 'palmerpenguins')

scale <- function(x){
  (x - min(x)) / (max(x) - min(x))
}

d <- penguins %>% as_tibble() %>% filter(complete.cases(.)) %>%
  transmute(
    is_adelie       = 1 * (species == "Adelie"),
    bill_length     = bill_length_mm     %>% scale(),
    bill_depth      = bill_depth_mm      %>% scale(),
    flipper_length  = flipper_length_mm  %>% scale(),
    body_mass       = body_mass_g        %>% scale()
  )

lbdr(d)

set.seed(2025)
n <- nrow(d)
train_idx <- sample.int(n, size = floor(0.1 * n))
d_train <- d %>% slice(train_idx)
d_test  <- d %>% slice(setdiff(seq_len(n), train_idx))

ensure_directory("derived_data")
d_train %>% write_csv("derived_data/penguins_train.csv")
d_test  %>% write_csv("derived_data/penguins_test.csv")

f <- is_adelie ~ .
m <- glm(f, data = d_train, family = binomial())

mdpre(summary(m))

ensure_directory("models")
saveRDS(m, "models/adelie_logres.rds")
