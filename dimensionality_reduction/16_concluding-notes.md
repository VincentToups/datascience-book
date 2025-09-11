# Concluding Notes

A lot of data comes in a redundant form: we have many columns but they
contain lots of correlations, for instance. Or the data is very high
dimensional but occupies a much lower dimensional manifold within that
high dimensional space. Or the data has no natural representation as a
space at all, but a distance function is available that can tell you how
similar data points are.

Dimensionality reduction is the unsupervised attempt to remove that
redundancy either for the purposes of visualization or pre-treatment for
a regression.

We discussed a few methods here. There are many. A great resource for a
survey is sklearn's Manifold learning documentation. Things we should
keep in mind:

1.  what assumptions about the space are made for a given method?
2.  is the method deterministic or not?
3.  Can we easily interpret the results?
4.  Does the method allow us to project new data down to lower
    dimensions?

A final note: "feature engineering" is what people used to do before
unsupervised methods were computationally convenient or readily
available. Sometimes an ounce of feature engineering can be worth a
pound of unsupervised dimensionality reduction. For example, we'd
probably do a lot better identifying French names by looking for accent
marks than by trying a manifold embedding!

``` R acc=conclusion load_state=read_results save_state=conclusion
```

Next: ::17_function-to-coerce-string-to-ascii-and-count-differences:Function to coerce string to ASCII and count differences::
