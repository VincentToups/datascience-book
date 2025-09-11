# Read results back into R
``` R acc=read_results load_state=tsne_written
results <- read.csv("results.csv") %>% as_tibble() %>%
    mutate(country=names$country[sample_indices])

```

``` R acc=read_results load_state=metric
ggmd(ggplot(results,aes(X0, X1)) + geom_point(aes(color=country)));

```

``` R acc=read_results save_state=read_results
ggmd(ggplot(results,aes(X0)) + geom_density(aes(color=country)));
ggmd(ggplot(results,aes(X1)) + geom_density(aes(color=country)));


```

As promised, this is an example where the labels aren't easily separated
by the embedding.


Next: ::16_concluding-notes:Concluding Notes::
