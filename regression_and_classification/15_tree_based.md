Tree Based Methods
==================

Motivating Ideas
----------------

The idea of decision trees is thus: given some independent variables
and a dependent variable we pose a series of questions about the independent
variables and this chops our data set up into smaller pieces for which the
problem might be easier to solve. 

If our data set looks like this:

``` R session=tree_one
library(tidyverse)

d <- read_csv("source_data/power_grid_characters.csv") %>%
  inner_join(read_csv("source_data/power_grid_character_genders.csv"),
             by=c("character_name","url")) %>%
  filter(gender %in% c("Male","Female")) %>%
  filter(complete.cases(.)) %>%
  pivot_wider(id_cols=c("character_name", "url", "gender"),names_from=power_category, values_from=numeric_level,
              values_fn = max,
              values_fill=2) %>%
  select(-url) %>% group_by(gender) %>% sample_n(700) %>% ungroup()

# Hold out a test set after balancing genders
set.seed(42)
d <- d %>% mutate(.row_id = row_number())
d_train <- d %>% group_by(gender) %>% slice_sample(prop=0.8) %>% ungroup()
d_test  <- d %>% filter(!(.row_id %in% d_train$.row_id))

lbdr(d)

```
We might want to predict gender based on our power categories and thus attempt to determine whether there is a
gender bias in the imaginations of your typical marvel writer.

A real dumb way to do this would be to write a function which picks one
column and then finds a point to split the data numerically which maximizes
the gender split of the two resulting sets.

``` R session=tree_one
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

lbdr(find_split(d, "gender", "intelligence"))

```
Using this split we can break our characters into two sets:

``` R session=tree_one
split <- find_split(d, "gender", "intelligence")
lbdr(split)

lbdr(d %>% filter(intelligence <= split$best_split) %>% summarise(p_male=sum(gender=="Male")/length(gender),
                                                                          p_female=sum(gender=="Female")/length(gender)))

lbdr(d %>% filter(intelligence > split$best_split) %>% summarise(p_male=sum(gender=="Male")/length(gender),
                                                                  p_female=sum(gender=="Female")/length(gender)))


```


We can turn this into a classifier easily enough: if intelligence is less than
or equal to 4, then the probability that our character is male is 0.75. If the
intelligence of our character is greater than 4 then the probability *goes  up*
to 0.87.

Going Further
-------------

Suppose we wanted to improve our classifier further? Nothing prevents us from 
splitting our two resulting sets *again* using another column from our data set. 


``` R session=tree_one
# First split on intelligence
s_int <- find_split(d, "gender", "intelligence")$best_split
left  <- d %>% filter(intelligence <= s_int)
right <- d %>% filter(intelligence >  s_int)

# Learn strength split separately in each chiln
s_str_L <- find_split(left,  "gender", "strength")$best_split
s_str_R <- find_split(right, "gender", "strength")$best_split

# Report male/female probs for the four leaves
mdpre(sprintf("### less intelligent than/= %d, weaker than/= %d", s_int, s_str_L))
lbdr(left  %>% filter(strength <= s_str_L) %>% summarise(p_male = mean(gender=="Male"),   p_female = mean(gender=="Female")))
mdpre(sprintf("### less intelligent than/= %d, stronger than %d", s_int, s_str_L))
lbdr(left  %>% filter(strength >  s_str_L) %>% summarise(p_male = mean(gender=="Male"),   p_female = mean(gender=="Female")))
mdpre(sprintf("### smarter than %d, weaker than/= %d", s_int, s_str_R))
lbdr(right %>% filter(strength <= s_str_R) %>% summarise(p_male = mean(gender=="Male"),   p_female = mean(gender=="Female")))
mdpre(sprintf("### smarter than %d, stronger than %d", s_int, s_str_R))
lbdr(right %>% filter(strength >  s_str_R) %>% summarise(p_male = mean(gender=="Male"),   p_female = mean(gender=="Female")))

```
If we were performing a regression instead we could calculate the variance of each sub-data set instead
. You could imagine a more complicated procedure:
for each step, pick the variable which produces the best split and split the set
at that point, then repeat that process for each sub-data set until you hit a 
desired tree depth or you hit a given threshold of homogeneity in each sub-tree.

Since we are dealing with just two variables we should be able to make this
substantially more enlightening.

``` R session=tree_one
(ggplot(d, aes(intelligence - runif(length(intelligence)), 
               strength - runif(length(intelligence)))) + 
    geom_point(aes(color=factor(gender))) + 
    geom_vline(xintercept=2) + 
    geom_segment(x=0,y=2,xend=2,yend=2) + 
    geom_segment(x=2,y=5,xend=7,yend=5)) %>%
  lbdr()
```

This is the fundamental idea behind all the latest and greatest tree based
procedures, including one we will demo next: ::16_adaboost:adaboost::.

``` R session=tree_one
# Treat the partitioning as a classifier and plot an ROC on the held-out test set

# Learn the splits on the training data
s_int_tr <- find_split(d_train, "gender", "intelligence")$best_split
left_tr  <- d_train %>% filter(intelligence <= s_int_tr)
right_tr <- d_train %>% filter(intelligence >  s_int_tr)

s_str_L_tr <- find_split(left_tr,  "gender", "strength")$best_split
s_str_R_tr <- find_split(right_tr, "gender", "strength")$best_split

# Leaf probabilities P(Male)
p_LL <- left_tr  %>% filter(strength <= s_str_L_tr) %>% summarise(p=mean(gender=="Male")) %>% pull(p)
p_LR <- left_tr  %>% filter(strength >  s_str_L_tr) %>% summarise(p=mean(gender=="Male")) %>% pull(p)
p_RL <- right_tr %>% filter(strength <= s_str_R_tr) %>% summarise(p=mean(gender=="Male")) %>% pull(p)
p_RR <- right_tr %>% filter(strength >  s_str_R_tr) %>% summarise(p=mean(gender=="Male")) %>% pull(p)

# Score the test set using the learned tree
score_leaf <- function(x_int, x_str){
  if(x_int <= s_int_tr){
    if(x_str <= s_str_L_tr) return(p_LL) else return(p_LR)
  } else {
    if(x_str <= s_str_R_tr) return(p_RL) else return(p_RR)
  }
}

d_scored <- d_test %>%
  mutate(score = mapply(score_leaf, intelligence, strength),
         y = as.integer(gender=="Male"))

# Hand-written ROC from the scores
ths <- sort(unique(d_scored$score), decreasing=TRUE)
ths <- c(Inf, ths, -Inf)

roc <- map_dfr(ths, function(t){
  pred <- as.integer(d_scored$score >= t)
  tp <- sum(pred==1 & d_scored$y==1)
  fp <- sum(pred==1 & d_scored$y==0)
  tn <- sum(pred==0 & d_scored$y==0)
  fn <- sum(pred==0 & d_scored$y==1)
  tibble(`False Positive Rate` = fp/(fp+tn),
         `True Positive Rate`  = tp/(tp+fn),
         threshold = t)
}) %>% arrange(threshold)

lbdr(roc)
lbdr(ggplot(roc, aes(`False Positive Rate`, `True Positive Rate`)) +
       geom_line() +
       geom_abline(slope=1, intercept=0, color="red"))

```
