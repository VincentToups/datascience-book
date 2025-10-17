Parsimoniousness Again
======================

In general we wish to maximize our ability to predict things using as few
parameters as possible. This urge is so strong that physicists have been
trying to figure out how to do it once and for all for around 60 years, trying
to produce a model of the universe with only one parameter: the string tension.

It is kind of a maddening problem, since in some ways it's gone terrifically 
and in other ways it's a total failure.

I digress.

There are various ways to do this. I'd like to explain penalized regression
first because it generalizes nicely to neural networks. 

Recall:

$$
\hat{y_i} = \beta_i^j x_j
$$

We choose $\beta_j$ by varying the $\beta_j$ in such a way that we minimize

$$
(\hat{y_i}-y_i)^2
$$

Which we could expand out to look like this:

$$
(\beta_i^j x_j - y_i)^2
$$

Suppose we wanted to impose a parsimoniousness onto our model. Consider that if a given 
$\beta_i$ for a specific $i$ is 0, that amounts to setting that parameter to 0.

So a parsimonious model might be one where something like the following is true:

$$
\beta_j \beta^j \text{ is small }
$$

Or, in regular notation, for clarity:

$$
\sum_j{\beta_j^2} \text { is small }
$$

Here we square $\beta_j$ because we don't care about the *sign* of the $\beta_j$ - we just
want it to be small. What if we added this as a penalty term to our optimization problem like this:

$$
\min_{\beta_j} ((\beta_i^j x_j-y_i)^2 + \alpha \beta_j \beta^j)
$$

This would penalize our optimization objective function if our $\beta_j$ started
to get big. This is the idea of a penalized regression, of which there are at
least two types.

We can see a demo of this [here](demo.html).

What may not be obvious is that the funny behavior of the so-called "LASSO" regression

$$
\min_{\beta_j} ((\beta_i^j x_j-y_i)^2 + \alpha \sum_{j=1}^{n}{abs(\beta_j)} )
$$

which has the quality of breaking the rotational symmetry of the squared penalty
term, has some desirable properties: it tends to force coefficients to zero
one at a time rather than just constraining the total coefficient sum. This is because the
penalty term goes like minimizing the Manhattan distance rather than the Euclidean
one. If you are forced to walk along a grid between two arbitrary points and
you measure the difference in x coordinate and y coordinate as a function of time
one of them will hit zero before the other - you can't continuously adjust them
to zero at the same time.

This has the benefit of performing variable selection "automatically," although
we shall see this is fraught with peril.

Ok, so how do we do this? We use the ::12_glmnet:glmnet:: library.
