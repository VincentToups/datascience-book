# Where PCA Can't Possibly Work:

Consider:

``` R acc=pca_limits load_state=scaling save_state=pca_limits
library(tidyverse)

bad_data <- tibble(r = sample(c(2,5),size=400,replace=TRUE) + rnorm(400,0,0.4),
            theta = runif(400,0,2*pi)) %>%
    transmute(x=r*cos(theta),
              y=r*sin(theta));
ggmd(ggplot(bad_data, aes(x,y)) + geom_point() + coord_fixed());
```

This data set clearly only has one interesting degree of variation: the
radius. But no rotation will separate these two axes. Indeed, PCA on
this data set is the identity operation. You will need more
sophisticated methods to deal with data like this.

Or you can apply some elbow grease: in this case, if you can manually
calculate the radius then you can just throw away the angular part.
We'll see something similar to this in the lecture on classification.

(NB: This question of understanding how these kinds of cyclic dimensions
work and can be described is also central to physics in a variety of
ways. In GR we tackle this kind of thing by very carefully considering
only properties which are describable on local patches of curved
dimensions and which are "patch parameterization independent". In
Quantum Gravity we seek alternative observables from the angle which are
continuous and smooth (the sin and the cosine of the angle)).


Next: ::06_vector-spaces:Vector Spaces::
