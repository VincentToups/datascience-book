# Perform t-SNE on the Victor-Purpura distance matrix
``` R acc=tsne_metric load_state=reticulate_tsne_fn save_state=tsne
tsne_results <- perform_tsne(as.matrix(distance_matrix))

tsne_results <- cbind(tsne_results) %>% as_tibble()

ggmd(ggplot(tsne_results, aes(V1, V2)) + geom_point(aes(color = label)))

```


Next: ::28_optionally-plot-the-results:Optionally, plot the results::
