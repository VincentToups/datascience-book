library(tidyverse)
library(Rtsne)
library(ggrepel)


# Override to fix diag<- error and ensure matrix semantics
cov_to_dist <- function(cov_mat) {
  stopifnot(is.matrix(cov_mat), nrow(cov_mat) == ncol(cov_mat))
  cor_mat <- cov2cor(cov_mat)
  D <- sqrt(2 * (1 - cor_mat))
  D[!is.finite(D)] <- NA
  D[D < 0] <- 0
  diag(D) <- 0
  dimnames(D) <- dimnames(cov_mat)
  D
}

tsne_vars_from_dist <- function(D, perplexity = 5, seed = 123) {
  set.seed(seed)
  ts <- Rtsne::Rtsne(
    as.dist(D),
    is_distance = TRUE,
    perplexity = perplexity,
    theta = 0.5,
    verbose = FALSE,
    check_duplicates = FALSE
  )
  tibble(
    variable = rownames(D),
    x = ts$Y[, 1],
    y = ts$Y[, 2]
  )
}

spectral_clusters_from_dist <- function(D, k = 5, seed = 123) {
  stopifnot(is.matrix(D), nrow(D) == ncol(D))
  # Affinity via RBF kernel; sigma = median pairwise distance
  dvals <- D[upper.tri(D)]
  sigma <- stats::median(dvals[dvals > 0], na.rm = TRUE)
  if (!is.finite(sigma) || sigma <= 0) sigma <- mean(dvals, na.rm = TRUE)
  A <- exp(-(D^2) / (2 * sigma^2))
  diag(A) <- 0

  # Normalized Laplacian L_sym = I - D^{-1/2} A D^{-1/2}
  deg <- rowSums(A)
  Dmhalf <- diag(ifelse(deg > 0, 1 / sqrt(deg), 0))
  Lsym <- diag(nrow(A)) - Dmhalf %*% A %*% Dmhalf

  # Smallest k eigenvectors of L_sym
  ev <- eigen(Lsym, symmetric = TRUE)
  U <- ev$vectors[, (ncol(ev$vectors) - k + 1L):ncol(ev$vectors)]  # safeguard if eigenvalues not sorted asc
  # In base::eigen for symmetric matrices, values are sorted decreasing.
  # So take the last k (smallest) eigenvectors.
  # Row-normalize then k-means
  U_norm <- U / pmax(sqrt(rowSums(U^2)), .Machine$double.eps)
  set.seed(seed)
  km <- kmeans(U_norm, centers = k, nstart = 50, iter.max = 1000)

  tibble(
    variable = rownames(D),
    cluster = factor(km$cluster, levels = sort(unique(km$cluster)))
  )
}

# ---- pipeline wrapper ----

analyze_cov_tsne_spectral <- function(cov_mat, tsne_perplexity = 5, k_groups = 5, seed = 123) {
  D <- cov_to_dist(cov_mat)

  tsne_tbl <- tsne_vars_from_dist(D, perplexity = tsne_perplexity, seed = seed)

  cl_tbl <- spectral_clusters_from_dist(D, k = k_groups, seed = seed)

  list(distance = D, tsne = tsne_tbl, clusters = cl_tbl)
}

# ---- plotting ----

plot_tsne_labels <- function(tsne_tbl, cl_tbl = NULL) {
  if (!is.null(cl_tbl)) {
    df <- tsne_tbl %>% left_join(cl_tbl, by = "variable")
  } else {
    df <- tsne_tbl %>% mutate(cluster = factor(1))
  }

  ggplot(df, aes(x = x, y = y, label = variable, color = cluster)) +
    geom_point(alpha = 0.2, size = 2) +
    ggrepel::geom_text_repel(size = 3, max.overlaps = Inf, segment.alpha = 0.2) +
    coord_equal() +
    labs(x = "t-SNE 1", y = "t-SNE 2", color = "Cluster") +
    theme_minimal()
}

# ---- pretty printing of clusters ----

summarize_clusters <- function(cl_tbl) {
  cl_tbl %>%
    arrange(cluster, variable) %>%
    group_by(cluster) %>%
    summarise(variables = paste(variable, collapse = ", "), .groups = "drop")
}
