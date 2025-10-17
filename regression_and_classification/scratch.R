library(tidyverse)

d <- read_csv("source_data/power_grid_characters.csv") %>%
  inner_join(read_csv("source_data/power_grid_character_genders.csv"),
             by=c("character_name","url")) %>%
  filter(gender %in% c("Male","Female")) %>%
  filter(complete.cases(.)) %>%
  pivot_wider(id_cols=c("character_name", "url", "gender"),names_from=power_category, values_from=numeric_level,
              values_fn = max,
              values_fill=2) %>%
  select(-url)

gini <- function(s){
  p <- sum(s==s[1])/length(s)
  2*p*(1-p)
}

find_split <- function(df, d_column, i_column){
  # Extract response and predictor
  y <- df[[d_column]]
  x <- df[[i_column]]
  
  # Ensure y has exactly two levels
  levs <- unique(y)
  stopifnot(length(levs) == 2)
  
  # Convert y to logical (TRUE = first level)
  y01 <- as.integer(y == levs[1])
  
  # Sort by the numeric feature
  ord <- order(x)
  y01 <- y01[ord]
  x <- x[ord]
  
  # Candidate split points: midpoints where class changes
  idx <- which(y01[-1] != y01[-length(y01)])
  split_points <- (x[idx] + x[idx + 1]) / 2

  n <- length(y01)
  best_gain <- -Inf
  best_split <- NA
  
  # Parent impurity
  p <- mean(y01 == 1)
  g_parent <- 2 * p * (1 - p)
  
  for (s in split_points) {
    left <- y01[x <= s]
    right <- y01[x > s]
    
    p_left <- mean(left == 1)
    p_right <- mean(right == 1)
    
    g_left <- 2 * p_left * (1 - p_left)
    g_right <- 2 * p_right * (1 - p_right)
    
    g_weighted <- (length(left) * g_left + length(right) * g_right) / n
    gain <- g_parent - g_weighted
    
    if (!is.na(gain) && gain > best_gain) {
                           best_gain <- gain
                           best_split <- s
                           }
  }
  
  tibble(
    column = i_column,
    best_split = best_split,
    gain = best_gain,
    class_levels = list(levs)
  )
}

split <- find_split(d, "gender", "intelligence")
lbdr(split)

lbdr(d %>% filter(intelligence <= split$best_split) %>% summarise(p_male=sum(gender=="Male")/length(gender),
                                                                          p_female=sum(gender=="Female")/length(gender)))

lbdr(d %>% filter(intelligence > split$best_split) %>% summarise(p_male=sum(gender=="Male")/length(gender),
                                                                  p_female=sum(gender=="Female")/length(gender)))


split <- find_split(d, "gender", "strength")
lbdr(split)

d %>% filter(strength <= split$best_split) %>% summarise(p_male=sum(gender=="Male")/length(gender),
                                                             p_female=sum(gender=="Female")/length(gender))







library(tidyverse)

d <- read_csv("derived_data/mileage_prepped.csv")

make_folds <- function(n_pts, n_folds=5){
    ((0:(n_pts-1) %% (n_folds)) + 1) %>% 
    sample(n_pts, replace=F)
}

lbdr(make_folds(50,5))

on_folds <- function(k, d, f){
    folds <- make_folds(nrow(d), k);
    od <- tibble();
    for(i in unique(folds)){
        train <- d %>% filter(folds!=i)
        test <- d %>% filter(folds==i)
        od <- rbind(od, f(train, test, i))
    }
    od
}

f <- highway_mpg ~ curb_weight + length + width + height + num_of_cylinders + stroke + peak_rpm 

one <- function(train, test, fold_ii){
    m <- lm(f, data=train)
    p <- predict(m, newdata=test)
    r <- (sum((p-test$highway_mpg)^2)/nrow(test)) %>% sqrt()
    tibble(fold=fold_ii, rmse=r)
}

r <- on_folds(10, d, one)
lbdr(r)

lbdr(ggplot(r,aes(rmse))+geom_density())

model <- lm(f, data=d)

curb_weights <- seq(from=min(d$curb_weight), to=max(d$curb_weight), length.out=100)


all_cws <- tibble()
for(cw in curb_weights){
  faux <- d %>% mutate(curb_weight=cw)
  mpgs <- predict(model, newdata=faux)
  all_cws <- rbind(all_cws,tibble(point=1:length(mpgs), mpg=mpgs, curb_weight=cw))
}

ggplot(all_cws, aes(curb_weight, mpg)) + geom_line(aes(group=point))

f <- highway_mpg ~ curb_weight + length + width + height + num_of_cylinders + stroke + peak_rpm + peak_rpm * curb_weight + curb_weight * width + width * height
model <- lm(f, data=d)


curb_weights <- seq(from=min(d$curb_weight), to=max(d$curb_weight), length.out=100)


all_cws <- tibble()
for(cw in curb_weights){
  faux <- d %>% mutate(curb_weight=cw)
  mpgs <- predict(model, newdata=faux)
  all_cws <- rbind(all_cws,tibble(point=1:length(mpgs), mpg=mpgs, curb_weight=cw))
}

ggplot(all_cws, aes(curb_weight, mpg)) + geom_line(aes(group=point))




g <- highway_mpg ~ curb_weight + length + width + height + num_of_cylinders + stroke + peak_rpm + peak_rpm * curb_weight + curb_weight * width + width * height
model <- lm(g, data=d)


curb_weights <- seq(from=min(d$curb_weight), to=max(d$curb_weight), length.out=100)


all_cws <- tibble()
for(cw in curb_weights){
  faux <- d %>% mutate(curb_weight=cw)
  mpgs <- predict(model, newdata=faux)
  all_cws <- rbind(all_cws,tibble(point=1:length(mpgs), mpg=mpgs, curb_weight=cw, peak_rpm=faux$peak_rpm))
}

lbdr(ggplot(all_cws, aes(curb_weight, mpg)) + geom_line(aes(group=point, color=peak_rpm)))




# Required packages
library(tidyverse)
library(caret)
library(gbm)
library(gridExtra)
library(ggplot2)

# Assumptions:
# - `d` exists as shown.
# - Binary gender classification desired; positive class set to "Male".
# - `lbdr()` exists in the environment (user-defined display helper).

# --- 1) Prep ------------------------------------------------------------------
# Keep only rows with non-missing gender and predictors

d <- read_csv("source_data/power_grid_characters.csv") %>%
  inner_join(read_csv("source_data/power_grid_character_genders.csv"),
             by=c("character_name","url")) %>%
  filter(gender %in% c("Male","Female")) %>%
  filter(complete.cases(.)) %>%
  pivot_wider(id_cols=c("character_name", "url", "gender"),names_from=power_category, values_from=numeric_level,
              values_fn = max,
              values_fill=2) %>%
  select(-url)

predictors <- c("intelligence","strength","speed","durability","energy projection","fighting skills")

d2 <- d %>%
  dplyr::filter(gender %in% c("Male","Female")) %>%
  drop_na(gender, all_of(predictors)) %>%
  mutate(
    gender = as.character(gender),
    # Binary target for AdaBoost in gbm: 0/1
    gender01 = as.integer(gender == "Male")
  )



# Train/test split (stratified)
set.seed(42)
idx <- createDataPartition(d2$gender01, p = 0.8, list = FALSE)
train <- d2[idx, ]
test  <- d2[-idx, ]

# --- 2) Fit GBM (AdaBoost) ----------------------------------------------------
set.seed(42)
gbm_fit <- gbm(
  formula = gender01 ~ intelligence + strength + speed + durability + `energy projection` + `fighting skills`,
  data = train,
  distribution = "adaboost",   # requires 0/1 target
  n.trees = 3000,
  interaction.depth = 3,
  shrinkage = 0.01,
  bag.fraction = 0.8,
  cv.folds = 5,
  train.fraction = 1.0,
  verbose = FALSE
)

best_iter <- gbm.perf(gbm_fit, method = "cv", plot.it = FALSE)

# Print informative variables (relative influence)
vi_tbl <- as_tibble(summary(gbm_fit, n.trees = best_iter, plotit = FALSE)) %>%
  rename(variable = var, rel_influence = rel.inf) %>%
  arrange(desc(rel_influence))
print(vi_tbl)

# --- 3) Hand-made ICE plots for each predictor --------------------------------
# Helper to build one ICE plot, assigning to a symbol `p_<sanitized_name>`
make_ice_plot <- function(feat, sample_n = 100, grid_n = 50) {
  # Grid over the feature's empirical range
  rng <- range(train[[feat]], na.rm = TRUE)
  grid_vals <- seq(rng[1], rng[2], length.out = grid_n)

  # Sample a subset of rows to keep plots readable
  base_rows <- train %>%
    slice_sample(n = min(sample_n, nrow(train))) %>%
    mutate(.id = row_number())

  # Cross with grid and predict
  newd <- base_rows %>%
    select(all_of(c("gender01", predictors, ".id"))) %>%
    select(-all_of(feat)) %>%
    crossing(setNames(tibble(grid_vals), feat))

  newd$pred <- predict(gbm_fit, newdata = newd, n.trees = best_iter, type = "response")

  # Plot
  ggplot(newd, aes_string(x = feat, y = "pred", group = ".id")) +
    geom_line(alpha = 0.25) +
    labs(
      title = paste("ICE:", feat),
      y = "P( Male )",
      x = feat
    ) +
    theme_minimal()
}

# Build and assign plots to variables p_<feature>
feat_names <- predictors
sanitized  <- gsub("[^A-Za-z0-9_]+", "_", feat_names)

for (i in seq_along(feat_names)) {
  plt <- make_ice_plot(sanitized[i])
  assign(paste0("p_", sanitized[i]), plt, inherits = TRUE)
}

# Optional: a variable importance bar chart to help fill the grid
p_importance <- vi_tbl %>%
  mutate(variable = fct_reorder(variable, rel_influence)) %>%
  ggplot(aes(x = variable, y = rel_influence)) +
  geom_col() +
  coord_flip() +
  labs(title = "GBM Relative Influence", x = NULL, y = "Rel. Influence") +
  theme_minimal()

# --- 4) Arrange into 3x3 grid and lbdr() --------------------------------------
# Collect plots (6 ICE + importance) and pad to 9 with blanks
plots <- list(
  p_intelligence,
  p_strength,
  p_speed,
  p_durability,
  p_energy_projection,
  p_fighting_skills,
  p_importance
)

# Pad with blank grobs to reach 9
while (length(plots) < 9) plots <- append(plots, list(nullGrob()))

# Build arranged grob (3x3)
grid_grob <- arrangeGrob(grobs = plots, ncol = 3)

# Display & log/book display
grid::grid.newpage(); grid::grid.draw(grid_grob)
lbdr(grid_grob)
