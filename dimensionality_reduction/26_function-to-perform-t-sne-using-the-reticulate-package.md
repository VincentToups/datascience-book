# Function to perform t-SNE in R
``` R acc=reticulate_tsne load_state=reticulate save_state=reticulate_tsne_fn
perform_tsne <- function(distance_matrix, n_components = 2, perplexity = 30) {
  # distance_matrix is a precomputed distance matrix
  if (!requireNamespace("Rtsne", quietly = TRUE)) {
    stop("Package 'Rtsne' is required but not installed.")
  }
  fit <- Rtsne::Rtsne(as.matrix(distance_matrix),
                      dims = n_components,
                      perplexity = perplexity,
                      is_distance = TRUE,
                      verbose = FALSE)
  as.data.frame(fit$Y)
}
```

Next: ::27_perform-t-sne-on-the-victor-purpura-distance-matrix:Perform t-SNE on the Victor-Purpura distance matrix::
