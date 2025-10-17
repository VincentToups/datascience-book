Regression and Classification
=============================

So far we've discussed unsupervised methods. This means we've got data
but we don't have *labels* which tell us some authoritative thing
about the data or at least we don't want to think of the data that way.

Dimensionality reduction and clustering are ways to summarize data
without making direct claims about relations between the elements or trying to
predict things.

But it's very common to be asked to predict something given the data we
have. We might want to predict, for example, whether someone who has
watched a set of movies will want to watch another. Our data contains
that sort of information implicitly, but we need to form a model.

Or we might want to predict a numerical outcome of some kind - perhaps
we have data about treatments over a trial and we want to figure out
how to predict how much a person's back pain has decreased.

As usual, we will begin with the simplest thing and then build up
towards more complicated methods.

The simplest thing we can reasonably do is a ::02_lin_reg:linear regression::.



