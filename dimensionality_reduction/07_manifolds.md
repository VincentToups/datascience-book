# Manifolds

In the case of our pairs `(W,H)` some operations simply don't make
sense. You can understand why we might be able to sometimes get away
with thinking of this data as a vector space if you consider *local*
transformations only. In the vicinity of a particular data point a small
deviation in weight or height tends to produce another physically
plausible weight and height.

Thus, statistically and locally, weights and heights resemble a vector
space. It's really miraculous that PCA is so generally useful given that
very few data sets have any good reason to satisfy all the vector space
axioms.

A set which has the property that it resembles a vector space locally is
called a manifold (speaking informally).

Fun fact: position in space, the sort of prototypical vector space, is
only approximately true. General Relativity tells us that the ability to
describe events as things pointed to by vectors is only a local
phenomenon. In general, there is no vector space structure relating
events.

In any case, more sophisticated methods of dimensionality reduction
often try to learn or otherwise approximate the *manifold* on which the
data lie. This is a deep assumption but there isn't much we can hope to
accomplish for high dimensional data without it.


Next: ::08_examples:Examples::
