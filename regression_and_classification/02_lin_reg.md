Linear Regression
=================

Like PCA and KMeans, the linear regression is so simple you could
invent it. And like those methods it's also very fraught with
simplifications.

In a linear regression we have a quantity $y$ which we wish to predict
given a vector of quantities $x_j$ where we have $J$ elements. To do
this, we posit the simplest possible relationship:

$$
y = \beta^{j}x_{j}
$$

Where I am using repeated indices to indicate a sum. That is, the above is equivalent to:

$$
y = \sum_{j=1}^{J} \beta_j x_j
$$

And we have ignored an intercept term by adding a constant column to our input data set.

That is to say that we claim that our dependent variable $y$ is a linear sum of
weighted predictors.

An example might be useful:

``` R
library(tidyverse)
d <- read_csv("https://raw.githubusercontent.com/varunlobo/PowerBI_Vehicle_dataset_kaggle/refs/heads/main/Automobile_data.csv")
names(d) <- names(d) %>%
  str_replace_all("-","_") %>%
  str_replace_all("[^_A-Za-z0-9]*","") %>%
  str_to_lower()

scale <- function(a){
  (a - min(a))/(max(a)-min(a))
}

d_num <- d %>% select(where(is.numeric)) %>%
  mutate(across(where(is.numeric), scale))
  
lbdr(d_num)

f = highway_mpg ~  wheel_base + length + width + height + curb_weight + engine_size + compression_ratio

m <- lm(f, data=d_num)
mdpre(summary(m))

dx <- d_num %>%
  mutate(highway_mpg_pred = predict(m, d_num %>% as.data.frame()))
  
lbdr(ggplot(dx, aes(highway_mpg, highway_mpg_pred)) + geom_point() + geom_segment(aes(x=0,y=0,xend=1,yend=1)))

lbdr(m)

```
Of course this is ALL WRONG.

For the first time we have to consider the question of a train/test split.

Consider for a moment the ideal model for $y_i$ given $x_i^j$: if there are enough
bits in $x_i^j$ to encode each value of $y_i$ given a sufficiently complex model
then the best model is just one that memorizes each $x_i^j$ and associates it with
$y_i$.

There is a funny thing about such models: they tend to do poorly on new data drawn 
from the same distribution (is this always true?) A string memorizer can't even 
predict data it has never seen before, at least if you think of it as a table mapping every
x to every y. So clearly we want models that can predict well on *new* data. at least
we want to estimate how the model works on new data somehow.

In an ideal world we would just fetch more and more data to test with, but we
usually don't have that luxury and so we have to set aside some of our (sometimes precious)
data set to use as a test set later.

``` R file=eg_simple_regression.R

```

Of course even this is questionable - after all, our train test split 
constitutes a random variable of which there are many realizations and 
so even if we report a single number (the residual error, for example) we
are actually understating the uncertainty of our results - there is a distribution
of residuals we should really report!

But let's set that aside for now with the note that at the absolute minimum 
we need to hold out a test set for testing.

Let's talk about how we might ::03_non_num:include non-numerical variables::.
