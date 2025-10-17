Motivating the Logistic Regression
==================================

The primary challenge with using the framework of linear regression to estimate a classifier is that our
target variable's support is the set {0,1} where 0 means one category and 1 means the other
(we restrict ourselves to two categories for the moment).

For example, we can use the fun palmer penguins package:

``` R
install.packages("palmerpenguins")
library(palmerpenguins)
data(package = 'palmerpenguins')
lbdr(penguins)

```
To build a classifier that predicts whether a penguin is of the species Adelie or not:

``` R
library(palmerpenguins)
library(tidyverse)
data(package = 'palmerpenguins')

scale <- function(x){
    (x-min(x))/(max(x)-min(x))
}
d <- penguins %>% as_tibble() %>% filter(complete.cases(.)) %>%
  transmute(is_adelie = 1*(species == "Adelie"), 
            bill_length = bill_length_mm %>% scale(), 
            bill_depth = bill_depth_mm %>% scale(), 
            flipper_length = flipper_length_mm %>% scale(), 
            body_mass = body_mass_g %>% scale(), 
            is_male = 1*(sex == "male"))
lbdr(d)            
```
I do not believe we need to belabor the point that our target variable is not
normally distributed for a given combination of independent variables. More
generally, our regression wants to predict the mean of a distribution which 
may vary over the real numbers continuously, but our target variable does not
behave this way, even if we think of it as a probability varying between zero
and one. 

What if we could find a target variable that had that behavior? We need a
function which maps the domain [0,1] to the real line. One such function is 
the logit function:

$$
logit(p) = log(\frac{p}{1-p})
$$

The behavior of the log function combined with the fraction here makes it so that
when p == 1 we have logit(1) = $\infty$ and when p == 0 logit(0) = $-\infty$.

How can we integrate this into our regression? Well, recall:

$$
\hat{y_i} = \beta_j x_i^j
$$

We want to estimate the probability $P(y=1|x)$ so we can write:

$$
logit(P(y_i=1|x_i)) = \beta_j x_i^j
$$

The number on the RHS is now well behaved. However, we cannot think of this as
just a simple optimization problem anymore because we cannot calculate the log odds
for each data point alone (they are either negative or positive infinity). 

Instead we recognize that we are maximizing the likelihood of drawing the $y_i$
from a parameterized Bernoulli distribution where we get the parameter $p_i$ by inverting 
the link function:

$$
p_i = \frac{1}{1 + e^{\beta_i^j x_j}}
$$

Given an estimate for all the $p_i$ for our data set we can write the likelihood
of our $y_i$ like this:

$$
L(\beta_\mu) 
= \prod_{i=1}^n 
\left[ \left( \frac{1}{1 + e^{-\beta_\nu x_i^\nu}} \right)^{y_i}
\left( 1 - \frac{1}{1 + e^{-\beta_\nu x_i^\nu}} \right)^{1 - y_i} \right]
$$

Thus if we maximize the likelihood over $\beta_j$ in the above expression we
can find the parameters we need. Maximizing the likelihood is outside the scope
of the course, but in a pinch you could do it with `optim`. We do not have to do so.

The critical idea here is that we are estimating the parameters of a *different* probability distribution in terms
of a linear combination of the explanatory variables. In a regular regression that
distribution is the normal distribution, but here it is the Bernoulli. 

Let's ::07_example:do an example::.
