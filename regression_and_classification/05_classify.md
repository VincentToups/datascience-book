Classification Vs Regression
============================

For reasons that aren't entirely clear to me, classification tasks seem 
more ubiquitous than regression ones. I think it's because humans like to make
decisions and this is fundamentally the process of turning a bunch of evidence
into a binary value: do this, or do not do this. 

First some preliminary about regular regression.

Recall that when we perform a regular regression we calculate:


$$
\hat{y_i} = \beta^{j}x_{ij}
$$

that is to say, we estimate a $\hat{y}$ function by finding the $\beta_j$ via

$$
min_{\beta_j}{}(y_i - \hat{y_i})^2
$$

In the case of a linear regression this process is tractable analytically but
we are but lowly data scientists, and thus we can stupidly invoke a regular
old optimization function to implement this kind of regression ourselves:

``` R
estimate_betas <- function(X, y) {
  # X: matrix of predictors with first column of 1's for intercept
  # y: response vector
  
  # initial guess for coefficients
  init <- rep(0, ncol(X))
  
  # objective: sum of squared residuals
  sse <- function(beta) {
    sum((y - X %*% beta)^2)
  }
  
  # use built-in optimizer
  opt <- optim(par = init, fn = sse)
  
  opt$par  # estimated coefficients
}

```

Here, like the true hand waving physicist I am, I am just farming out all the hard work to the `optim` function:

``` R
mdpre(tools::Rd2txt(utils:::.getHelpFile(help("optim"))))

```
But another, deeper perspective presents itself as useful here.

Instead of minimizing the difference between the estimated and true $y_i$ we
can think of a linear regression as calculating a parameterized normal distribution
for $y$ at a given $x$ under the assumption that the other parameters of the
distribution are the same at all $x$ positions. 

The residual of the fit gives us the parameters of that normal distribution.

This perspective is useful because we can then imagine variations on regressions
that calculate other kinds of distributions. Let's motivate this a bit on the way
to the so-called ::06_motivate_log:"logistic" regression::, which creates a classifier. 
