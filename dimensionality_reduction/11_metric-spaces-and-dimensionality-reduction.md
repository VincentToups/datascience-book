# Metric Spaces and Dimensionality Reduction

A metric space is just a set with a distance function that satisfies a
triangle inequality. This is substantially less structure than a vector
space. Many of the datasets we work with in practice have a meaningful
metric but no real meaningful vector space embedding.

For example:

``` R acc=metric load_state=tsne
library(tidyverse)
library(reticulate);

use_python("/usr/bin/python3");
manifold <- import("sklearn.manifold");


names <-
    rbind(read_csv("source_data/us.txt", col_names="name") %>% sample_n(250) %>% mutate(country="US"),
          read_csv("source_data/uk.txt", col_names="name") %>% sample_n(250) %>% mutate(country="UK"),
          read_csv("source_data/fr.txt", col_names="name") %>% sample_n(250) %>% mutate(country="FR"));
mddf(names)

```

Contrary to some datasets which we cavalierly represent as lists of
numbers, it's clear that there is no meaning whatsoever to the question
of what "Smith" + "Herve" is supposed to be. But we can define a metric,
the edit distance:

``` R acc=metric
distances_h <- adist(head(names$name));
distances <- adist(names$name);
mddf(as.data.frame(distances_h))
```

Some dimensionality reduction methods work directly on a metric. MDS is
one such method.

It works by finding a set of coordinates for each point given nothing
but a metric space. Obviously the result is only as good as the
assumption that the elements of the set that generated the distances are
themselves a vector space.

``` R acc=metric save_state=metric
```

Next: ::12_take-a-100x100-subset-of-distances:Take a 100x100 subset of distances::
