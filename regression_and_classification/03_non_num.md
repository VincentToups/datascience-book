Categorical Columns
===================

We have a lot of data that isn't really numerical but we might still wish to 
regress on it.

:table:source_data/Automobile_data.csv::

How do people do this?

The simplest method is via a *one-hot* encoding:

``` R file=eg_one_hot.R

```

Now we can perform a regression on this new one-hot encoded data set.

``` R file=eg_one_hot_reg.R

```
A natural question is: [how many of these predictors do we really need if we 
want to have a good model](./04_parsi.md)? 