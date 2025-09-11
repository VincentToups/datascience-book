# T-SNE

T-SNE is an approach based on the idea that the important thing to model
in the reduced data set is something like the probability of two points
being neighbors. In high density areas points must be closer to one
another to count as nearby, whereas in low density areas they can be
further apart.

It then seeks a map into a lower dimensional space which preserves these
probabilities without as much freedom to adjust things for density. So
it accomplishes both a dimensionality reduction and a simplification of
the distribution of points.

$$
p_{j\mid i} 
= \frac{\exp\!\left(-\tfrac{\lVert x_i - x_j \rVert^2}{2\,\sigma_i^2}\right)}{\sum_{k\ne i} \exp\!\left(-\tfrac{\lVert x_i - x_k \rVert^2}{2\,\sigma_i^2}\right)},\quad p_{ii}=0
$$

$$
p_{ij} 
= \frac{p_{j\mid i} + p_{i\mid j}}{2n},\quad i\ne j;
\qquad \sum_{i\ne j} p_{ij} = 1
$$

In the low-dimensional space with embeddings \(y_i\), define a heavy-tailed Student-t kernel:

$$
q_{ij} = \frac{\left(1 + \lVert y_i - y_j \rVert^2\right)^{-1}}{\sum_{k\ne l} \left(1 + \lVert y_k - y_l \rVert^2\right)^{-1}},\quad q_{ii}=0
$$

The t-SNE objective is the Kullback–Leibler divergence between \(P\) and \(Q\):

$$
\mathcal{L}(Y) = \mathrm{KL}(P\,\Vert\,Q) 
= \sum_{i\ne j} p_{ij} \log \frac{p_{ij}}{q_{ij}}.
$$

Here, each \(\sigma_i\) is chosen (via binary search) to match a user-specified perplexity.

``` R acc=tsne load_state=examples
library(tidyverse)
library(Rtsne)

X <- fn_datav %>% select(-trial, -label) %>% as.matrix()
tsne_out <- Rtsne(X, dims = 2, perplexity = 30, verbose = FALSE, check_duplicates = FALSE)
results <- as_tibble(tsne_out$Y)

ggmd(ggplot(results, aes(V1, V2)) + geom_point(aes(color = factor(fn_datav$label))))

```

To relate neighborhood structure before and after projection, pick a point and compare the distribution of distances from that point in the original space versus in the t-SNE embedding.

``` R acc=tsne
# Select a reference point and compute distance distributions
set.seed(1)
i <- sample(1:nrow(fn_datav), 1)
X <- fn_datav %>% select(-trial, -label) %>% as.matrix()
Y <- results %>% as.matrix()

d_high <- sqrt(rowSums((X - matrix(X[i,], nrow=nrow(X), ncol=ncol(X), byrow=TRUE))^2))
d_low  <- sqrt(rowSums((Y - matrix(Y[i,], nrow=nrow(Y), ncol=ncol(Y), byrow=TRUE))^2))

dd <- tibble(space = c(rep("original", length(d_high)-1), rep("projection", length(d_low)-1)),
             dist  = c(d_high[-i], d_low[-i]))

ggmd(ggplot(dd, aes(dist, fill = space)) +
  geom_density(alpha = 0.4) +
  facet_wrap(~space, scales = "free") +
  labs(title = sprintf("Distance distributions from point %d", i)))
```

The smaller data set is more illustrative:

``` R acc=tsne save_state=tsne
library(Rtsne)

Y1 <- Rtsne(bad_data %>% select(x, y) %>% as.matrix(), dims = 1, perplexity = 30, verbose = FALSE, check_duplicates = FALSE)
results <- as_tibble(Y1$Y)
ggmd(ggplot(results, aes(V1)) + geom_density(aes(fill = factor(bad_data$label)), position = "dodge"))

```


Next: ::10_important-contrasts-between-tsne-and-pca:Important Contrasts Between TSNE and PCA::
