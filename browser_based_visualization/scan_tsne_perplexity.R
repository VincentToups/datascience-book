#!/usr/bin/env Rscript

# Scan t-SNE perplexity values and output 2D embeddings for each
# - Input:  source_data/tidy_wide_characters.csv
# - Output: source_data/tsne_perplexity_scan.csv
#
# The output includes columns: character_name, x, y, perplexity

suppressPackageStartupMessages({
  if (!requireNamespace("Rtsne", quietly = TRUE)) {
    message("Package 'Rtsne' not found. Attempting to install...")
    try(install.packages("Rtsne"), silent = TRUE)
  }
})

suppressPackageStartupMessages({
  library(utils)
})

input_path <- "source_data/tidy_wide_characters.csv"
output_path <- "source_data/tsne_perplexity_scan.csv"

if (!file.exists(input_path)) {
  stop(sprintf("Input file not found at '%s'", input_path))
}

df <- read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)

if (!"character_name" %in% names(df)) {
  stop("Input data must contain a 'character_name' column for joining.")
}

# Keep character_name for join and select numeric features for t-SNE
name_col <- df$character_name

# Identify numeric columns (exclude name identifier)
num_cols <- vapply(df, is.numeric, logical(1))
num_cols[match("character_name", names(num_cols))] <- FALSE

X <- df[, num_cols, drop = FALSE]

if (ncol(X) == 0) {
  stop("No numeric columns found to run t-SNE on.")
}

# Remove rows with NA in features, tracking names for those kept
complete_idx <- stats::complete.cases(X)
if (!all(complete_idx)) {
  removed <- sum(!complete_idx)
  message(sprintf("Removed %d rows with NA values in numeric features.", removed))
}
X_complete <- X[complete_idx, , drop = FALSE]
names_complete <- name_col[complete_idx]

n <- nrow(X_complete)
if (n < 5) {
  stop(sprintf("Not enough complete rows for t-SNE (n = %d).", n))
}

# Determine reasonable perplexity range: default 5..50 bounded by t-SNE limit
max_perp_allowed <- max(2, floor((n - 1) / 3))
perp_min <- 5
perp_max <- min(50, max_perp_allowed)

if (perp_max < perp_min) {
  # For very small datasets, fall back to a smaller range
  perp_min <- max(2, min(5, max_perp_allowed - 1))
  perp_max <- max_perp_allowed
}

if (perp_max < 2) {
  stop(sprintf("Effective perplexity upper bound too small (<=1). n=%d", n))
}

# Create 20 perplexity values across the range (unique to avoid duplicates)
perplexities <- unique(round(seq(perp_min, perp_max, length.out = 20), digits = 2))

if (length(perplexities) == 0) {
  stop("Could not create a perplexity scan range.")
}

message(sprintf(
  "Running t-SNE on %d rows, %d features, perplexities: [%s]",
  n, ncol(X_complete), paste(perplexities, collapse = ", ")
))

set.seed(42)

results_list <- vector("list", length(perplexities))

# Initialize the first embedding with PCA; reuse each result as the next init
Y_prev <- NULL
for (i in seq_along(perplexities)) {
  p <- perplexities[i]
  message(sprintf("t-SNE: perplexity = %s", as.character(p)))
  if (is.null(Y_prev)) {
    tsne_fit <- Rtsne::Rtsne(
      as.matrix(X_complete),
      dims = 2,
      perplexity = p,
      check_duplicates = FALSE,
      verbose = FALSE,
      pca = TRUE
    )
  } else {
    # Try to initialize from previous embedding to improve comparability
    tsne_fit <- tryCatch({
      Rtsne::Rtsne(
        as.matrix(X_complete),
        dims = 2,
        perplexity = p,
        check_duplicates = FALSE,
        verbose = FALSE,
        pca = FALSE,
        Y_init = Y_prev
      )
    }, error = function(e) {
      message(sprintf(
        "Y_init failed or unsupported for perplexity %s. Falling back to PCA init. (%s)",
        as.character(p), e$message
      ))
      Rtsne::Rtsne(
        as.matrix(X_complete),
        dims = 2,
        perplexity = p,
        check_duplicates = FALSE,
        verbose = FALSE,
        pca = TRUE
      )
    })
  }

  Y <- tsne_fit$Y
  Y_prev <- Y
  results_list[[i]] <- data.frame(
    character_name = names_complete,
    x = Y[, 1],
    y = Y[, 2],
    perplexity = p,
    stringsAsFactors = FALSE
  )
}

out_df <- do.call(rbind, results_list)

utils::write.csv(out_df, file = output_path, row.names = FALSE)
message(sprintf("Wrote %d rows to %s", nrow(out_df), output_path))
