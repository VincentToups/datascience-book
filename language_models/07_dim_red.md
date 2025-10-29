Dimensionality Reduction
========================

Embeddings are usually very high dimensional. 

``` R session=lms capture
library(ggplot2)

chunk_and_average_embeddings <- function(embeddings, paragraphs, chunk_size = 30) {
  chunked_embeddings <- list()
  chunked_paragraphs <- character()
  n <- length(embeddings)
  for (i in seq(1, n, by = chunk_size)) {
    idx <- i:min(i + chunk_size - 1, n)
    mat <- do.call(rbind, embeddings[idx])
    avg_embedding <- colMeans(mat)
    chunked_embeddings[[length(chunked_embeddings) + 1]] <- avg_embedding
    chunked_paragraphs <- c(chunked_paragraphs, paragraphs[i])
  }
  list(chunked_embeddings, chunked_paragraphs)
}

tmp <- chunk_and_average_embeddings(embeddings, tnl_paragraphs, chunk_size = 10)
avg_embeddings <- tmp[[1]]
avg_paragraphs <- tmp[[2]]

pca <- prcomp(do.call(rbind, avg_embeddings), center = TRUE, scale. = TRUE)
coords <- as.data.frame(pca$x[, 1:2])
names(coords) <- c("x", "y")
coords$paragraph <- avg_paragraphs
coords$seq <- seq_len(nrow(coords))

lbdr(ggplot(coords, aes(x = x, y = y)) +
  geom_point(color = "navy", alpha = 0.6) +
  geom_path(aes(group = 1), color = "orange", alpha = 0.5) +
  ggtitle("PCA of Averaged Embeddings with Sequential Line Connection") +
  xlab("PC1") + ylab("PC2"))

```

``` R session=lms capture
library(Rtsne)
library(ggplot2)
library(viridis)

chunk_and_average_embeddings <- function(embeddings, paragraphs, chunk_size = 10) {
  chunked_embeddings <- list()
  chunked_paragraphs <- character()
  n <- length(embeddings)
  for (i in seq(1, n, by = chunk_size)) {
    idx <- i:min(i + chunk_size - 1, n)
    mat <- do.call(rbind, embeddings[idx])
    avg_embedding <- colMeans(mat)
    chunked_embeddings[[length(chunked_embeddings) + 1]] <- avg_embedding
    chunked_paragraphs <- c(chunked_paragraphs, paragraphs[i])
  }
  list(chunked_embeddings, chunked_paragraphs)
}

tmp <- chunk_and_average_embeddings(embeddings, tnl_paragraphs, chunk_size = 10)
avg_embeddings <- tmp[[1]]
avg_paragraphs <- tmp[[2]]

avg_mat <- do.call(rbind, avg_embeddings)
tsne <- Rtsne::Rtsne(avg_mat, dims = 2, perplexity = 30, verbose = FALSE)
coords <- as.data.frame(tsne$Y)
names(coords) <- c("x", "y")
coords$index <- seq_len(nrow(coords))

lbdr(ggplot(coords, aes(x = x, y = y)) +
  geom_point(color = "navy", alpha = 0.6) +
  geom_path(aes(color = index, group = 1), linewidth = 1) +
  scale_color_viridis_c() +
  ggtitle("t-SNE of Averaged Embeddings with Sequential Color Gradient Line") +
  xlab("t-SNE 1") + ylab("t-SNE 2"))

```



One thing I have found about embeddings is that they are very tempermental - they embed ALL the information about the text, including things like style and length. Becaues of this they can be surprisingly uninformative when applied to a corpus of texts which vary in style or length.

What other options do we have? One is to simply ask the model to extract features from the text. This is more expensive but potentially ::08_keywords:easier to target and understand::.
