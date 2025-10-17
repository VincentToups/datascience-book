Adaboost
========

The `gbm` package implements a method called
[AdaBoost](https://en.wikipedia.org/wiki/AdaBoost) which uses a
tree-based method as its basic component, but its worth talking about
the details.

Random Forests
--------------

You may have noticed that classification trees chunk up space into
discrete regions and then the classification is performed in each
region.

This is a bit like a k-nearest neighbor classification, where you just
grab k neighbors of a point and they vote on which class they belong
in. But such a tesselation of the input space introduces a rigidity to
the classifier: a given point is or is not in the region in question
and that region predicts the result in its entirity. You could see how
this might make decisions for points near the boundary of regions more
error prone.

The idea of a random forest is to exchange one potentially deep tree
for many, independent, trees, trained on bootstrapped or
samples with random feature subsets.

Then all the trees "vote" on a given point when you want to classify
it. You can think of this as performing many different tesselations of
the space and averaging out their contribution to a single point.

Given that you know how to choose an ideal split, which means you know
how to train a specific sub-tree, you too could implement a random
forest fitter.


Adaboost
--------

In adaboost we instead take the following tact:

1. train a small model, limited parameters and depth.
2. evaluate it on the training data, finding those points which the model does not accurately predict
3. train a new small model with those points weighed as more important
4. repeat until we have a set number of trees

Finally, the trees all vote on the result when new data is presented,
except that their vote is weighted by their accuracy on the data.

Here is an example of using adaboost on our data set.

``` R session=ada

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



idx <- createDataPartition(d2$gender01, p = 0.8, list = FALSE)
train <- d2[idx, ]
test  <- d2[-idx, ]

# --- 2) Fit GBM (AdaBoost) ----------------------------------------------------
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
lbdr(vi_tbl)

```
``` R session=ada
make_ice_plot <- function(feat, sample_n = 100, grid_n = 50) {
  # Grid over the feature's empirical range
  rng <- range(train[[feat]], na.rm = TRUE)
  grid_vals <- seq(rng[1], rng[2], length.out = grid_n)

  # Sample a subset of rows to keep plots readable
  base_rows <- train %>%
    dplyr::slice_sample(n = min(sample_n, nrow(train))) %>%
    dplyr::mutate(.id = dplyr::row_number())

  # Cross with grid and predict (handles non-syntactic names via tidy-eval)
  grid_tbl <- tibble::tibble(!!feat := grid_vals)

  newd <- base_rows %>%
    dplyr::select(dplyr::all_of(c("gender01", predictors, ".id"))) %>%
    dplyr::select(-dplyr::all_of(feat)) %>%
    tidyr::crossing(grid_tbl)

  newd$pred <- predict(gbm_fit, newdata = newd, n.trees = best_iter, type = "response")

  ggplot2::ggplot(newd, ggplot2::aes(x = .data[[feat]], y = .data[["pred"]], group = .data[[".id"]])) +
    ggplot2::geom_line(alpha = 0.25) +
    ggplot2::labs(
      title = paste("ICE:", feat),
      y = "P( Male )",
      x = feat
    ) +
    ggplot2::theme_minimal()
}

lbdr(make_ice_plot("strength"))
lbdr(make_ice_plot("intelligence"))
lbdr(make_ice_plot("fighting skills"))
```
``` R session=ada
# Hand-written ROC on the held-out test set

# Predict probabilities for the positive class (Male)
test <- test %>% mutate(score = predict(gbm_fit, newdata = test, n.trees = best_iter, type = "response"),
                        y = as.integer(gender == "Male"))

# Compute ROC curve by sweeping thresholds over unique scores
ths <- test$score %>% unique() %>% sort(decreasing = TRUE)
ths <- c(Inf, ths, -Inf)

roc <- map_dfr(ths, function(t){
  pred <- as.integer(test$score >= t)
  tp <- sum(pred == 1 & test$y == 1)
  fp <- sum(pred == 1 & test$y == 0)
  tn <- sum(pred == 0 & test$y == 0)
  fn <- sum(pred == 0 & test$y == 1)
  tibble(`False Positive Rate` = fp/(fp + tn),
         `True Positive Rate`  = tp/(tp + fn),
         threshold = t)
}) %>% arrange(threshold)

lbdr(roc)
lbdr(ggplot(roc, aes(`False Positive Rate`, `True Positive Rate`)) +
       geom_line() +
       geom_abline(slope = 1, intercept = 0, color = "red"))
```

::17_summary:Recap::.