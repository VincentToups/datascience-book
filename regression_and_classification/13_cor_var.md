Correlated Independent Variables
================================

``` R
library(tidyverse)

lbdr(read_csv("source_data/Automobile_data.csv") %>%
     group_by(make) %>% 
     summarize(avg_curb_weight=mean(`curb-weight`)) %>%
     arrange(desc(avg_curb_weight)))

```

We can see that when the make is `chevy` we have the lowest weight. In general, what we will find is that our
`curb_weight`  is correlated with many of these high explanatory variables.
``` R
library(tidyverse)

d <- read_csv("derived_data/mileage_prepped.csv") %>%
     mutate(across(everything(), function(x){
       m <- mean(x);
       sd <- sd(x);
       (x-m)/sd
     }))
covd <- cov(d) %>% as_tibble() %>% mutate(variable=names(d))
lbdr(covd)

covdl <- covd %>% pivot_longer(cols=num_of_doors:fuel_system_spdi) %>%
  rename(var1=variable, var2=name);
  
var_to_coord_map <- 1:length(names(d));
names(var_to_coord_map) <- names(d);
var_to_coord <- function(var){
    var_to_coord_map[var]
}

p <- ggplot(covdl, aes(var1,var2)) + 
   geom_rect(aes(xmin=var_to_coord(var1)-0.5, xmax=var_to_coord(var1)+0.5,
             ymin=var_to_coord(var2)-0.5, ymax=var_to_coord(var2)+0.5,
             fill=value)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
             
lbdr(p)


```
``` R


source("variable_grouping_util.R")
library(tidyverse)

d <- read_csv("derived_data/mileage_prepped.csv", show_col_types = FALSE) %>%
  select(where(is.numeric)) %>%
  select(where(~ sd(., na.rm = TRUE) > 0)) %>%
  mutate(across(everything(), ~ (.-mean(., na.rm = TRUE)) / sd(., na.rm = TRUE)))

cov_mat <- cov(d, use = "pairwise.complete.obs")
cov_mat[!is.finite(cov_mat)] <- NA
keep <- rowSums(is.na(cov_mat)) == 0
cov_mat <- cov_mat[keep, keep, drop = FALSE]

stopifnot(ncol(cov_mat) == nrow(cov_mat))
colnames(cov_mat) <- colnames(d)[keep]
rownames(cov_mat) <- colnames(d)[keep]

res <- analyze_cov_tsne_spectral(cov_mat, tsne_perplexity = 5, k_groups = 5, seed = 42)
p_tsne <- plot_tsne_labels(res$tsne, res$clusters)
lbdr(p_tsne)

cluster_summary <- summarize_clusters(res$clusters)
lbdr(cluster_summary)

D <- res$distance
D_tbl <- as_tibble(D, .name_repair = "unique") %>%
  mutate(variable = rownames(D))
lbdr(D_tbl)

```
The key insight here is that variables can be correlated and, if that is the
case, then when we do variable elimination with LASSO, which variables we end up with
may depend on the randomness in the method.

The story is different with ridge regressions, which use the L2 penalty - in that
case groups tend to share similar coefficients. Using an elastic net regression
where we regress like this:

$$
min_{\beta_j} ((\beta_j x^j_i - y_i)^2 + \lambda (c \sum_j abs(\beta_j) + (1-c) \beta_j \beta^j))
$$

Can help us choose between these two behaviors. 

Causality?
----------

A slightly deeper method is that we can't typically make a causal interpretation
of these kinds of regressions. We might see that vitamin B deficiency is
correlated with greater chance of Covid death, for example, but that variable
is also correlated with lower socioeconomic status, and that is correlated
with lower health outcomes across the board and so on. 

If you must assign causal relations to the outcome you need to either 
rely on causal methods or on domain knowledge.

cv What
-------

While we've been looking at elastic net regressions, we have slid over
explaining a key technique employed in the glmnet suite: ::14_cross_validation:cross validation::.