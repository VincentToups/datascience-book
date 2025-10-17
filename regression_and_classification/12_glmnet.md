Lasso and Ridge
===============

Typically we perform a ridge or lasso regression using glmnet - a library
for doing "elastic net" regressions (these are just between ridge and lasso
regression, essentially).

The API for glmnet is a little different than for lm/glm - we split the 
data set into the response and the model matrix (the independent variables).

Then we typically perform *multiple* regressions as we scale penalty terms and
measure the coefficients, error, etc. 



``` R file=eg_glm_lasso.R start=1 end=19

```
This is the final result, and sure enough, we've got a sparse array 
of predictors. But we can learn a lot more about how this works by making
a few more figures.

:student-select:Q;../students.json::

First, let's examine how the coefficients vary as a function of lambda. As
you can see, they are all gradually pushed to 0. 



``` sidebar
A sparse array is one where memory is only allocated for elements with
non-zero values, which turns out to cover a surprisingly large number of
cases and can save large amounts of memory.
```

``` R file=eg_glm_lasso.R start=20 end=80

```
```sidebar
The curious reader might wonder: we know that doing a regression, in general,
involves a minimization procedure at some point and that these depend on 
certain random initial conditions: how does glmnet make sure that the coefficients
vary in a stable way as lambda increases? It uses the previous values as the 
initial conditions for the next regression. This probably also makes the whole
process more efficient.
```


Note that the above plot shows us that there is a (very shallow) point where
the error is smallest. We can pick out the that fit as the "best".

``` R file=eg_glm_lasso.R start=80 end=85

```

Weird!

Here we see that `make_chevrolet` is the most powerful explanatory variable,
which surprises us, because we expected it to be `curb_weight`. How should we ::13_cor_var:think about this::?