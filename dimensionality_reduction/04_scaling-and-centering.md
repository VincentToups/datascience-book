# Scaling and Centering

In general you should scale and center your data before doing a PCA. In
particular, centering makes sense, since a PCA is a rotation and you
usually want to rotate around the centroid of the data. But in some
cases it can be hard to justify.

Consider our data. To scale and center it is to apply a scale/center
operation to each time point. This doesn't seem to make much physical
sense.

(In the weeds: in this case the right thing to do might be to center the
results on the equilibrium position of the differential equations which
produced the data or the resting potential of the cell and normalize all
"columns" by the maximum voltage range).

``` R acc=scaling load_state=pca_lecture save_state=scaling
library(tidyverse)
scaled <- data %>% group_by(time) %>% mutate(V = (V - mean(V))/sd(V));
ggmd(ggplot(scaled %>% filter(trial %in% seq(10)), aes(time, V)) + geom_line(aes(color=factor(trial))));
```

Whether this makes sense or not depends a lot on your situation. Scaling
and centering this data has the effect of minimizing the influence of
places where spikes always happen which almost certainly improves the
results of anything which is trying to discriminate between these
trials. On the other hand, it makes the data much harder to appreciate
visually.

Scaling in particular is a challenging idea. In some situations you have
no idea whether one variable is more important than another. In these
situations it makes sense to scale them all to have the same variance.
But in other situations the variation in one variable really is more
important, or there is some other physical relation that sets a natural
scale between dimensions (for example, two dimensions might literally be
a length). In these cases you may want to scale them together or not
scale them at all.

Most of the time scaling and centering is right.


Next: ::05_where-pca-can-t-possibly-work:Where PCA Can't Possibly Work:::
