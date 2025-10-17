Cross Validation and Other Notes
================================

Ok, consider what we've been up to so far:

1. take a data set
2. encode it numerically
3. examine correlations between variables
4. perform regression
5. report results

This is almost right except that we learned that we need to do a train/test split:

1. take a data set
2. encode it numerically
3. split the data into a train and test set
3. examine correlations between variables
4. perform regression on the training data
5. report results on the testing data

This may appear to be adequate. But suppose we wish to compare two models? 
For example, we might want to compare a pure ridge vs a pure lasso regression.
Or we might want to compare a tree based method and a linear regression. Or we
might want to compare neural networks to any of these. 

Seems easy: calculate the residual or the accuracy or whatever and then pick the better model?

The problem with this approach is that when we perform a train test split we have
performed a random process and so our entire model is a sample from a distribution
which varies over how we split our data. So for the same reason that we cannot 
just compare *means* of normal distributions we cannot compare the accuracy of
two models without knowing the distribution of the two models' accuracies.

This is challenging because, in general, we do not have access to infinite data
sets and so we cannot really perform independent experiments on our modeling.

Thus, people do the "next best" thing, which is cross validation.

The idea is simple enough:

``` R session=cv

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
```





Making Sense of K-Folds CV
==========================

The main consideration when doing k-fold cross validation is the understanding
that we aren't really generating new samples when we do it.

For each held out fold we are using *many* of the same data points to calculate
our models while our smaller held out folds contain few points. Thus we expect the results
to depend somewhat sensitively on the particular points held out, and we expect
a higher variance than if we could sample from the same distribution over and over.

In practice, the consensus seems to be to use between 5-10 folds and this seems 
to be based on numerical testing. See [this paper](https://ai.stanford.edu/~ronnyk/accEst.pdf) by Kohavi, for instance.

In order to make sense of  what we might use this for, we should have some
models to compare, so let's take a look at ::15_tree_based:tree based regression/classification::
next.

Making Sense of Variable Effect
===============================

The other major way we want to evaluate a model is by understanding how each 
variable changes the possible outcome. There are a few ways to do this, but
the most informative is to plot the way the prediction changes as we change 
each variable (or combination of variables).

For this purpose we just use the training data set, since we want to study
how the model works, not so much how it performs on other data. 

This is pointless unless we add interaction terms: 

``` R session=cv
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

```

This will be much more interesting when we look at ::15_tree_based:tree based regression/classification::. 