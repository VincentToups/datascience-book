Why? Well, we're only using one previous word to guess the next word and this doesn't even guarantee gramattically correct generation. Can we do better? One we is to use more words going back in the history of the generated text.

``` R session=lms capture
library(R6)
library(httr)
library(tokenizers)

NGramMarkovModel <- R6::R6Class(
  "NGramMarkovModel",
  public = list(
    n = 2L,
    model = NULL,
    initialize = function(corpus = NULL, n = 2L) {
      self$n <- as.integer(n)
      self$model <- new.env(parent = emptyenv())
      if (!is.null(corpus)) {
        self$digest_text(corpus)
      }
    },
    digest_text = function(text) {
      tokens <- tokenizers::tokenize_words(tolower(text), strip_punct = TRUE)[[1]]
      private$update_model(tokens)
    },
    digest_url = function(url) {
      res <- httr::GET(url)
      txt <- httr::content(res, as = "text", encoding = "UTF-8")
      self$digest_text(txt)
    },
    predict_next_word = function(ngram) {
      key <- private$key_from(ngram)
      counts <- private$get_counts(key)
      if (length(counts) == 0) return(NA_character_)
      sample(names(counts), size = 1, prob = as.numeric(counts))
    },
    generate_text = function(start_words = NULL, length = 10L) {
      if (is.null(start_words) || length(start_words) != self$n - 1) {
        start_words <- private$random_start()
      }
      word_sequence <- start_words
      for (i in seq_len(length - length(start_words))) {
        ngram <- tail(word_sequence, self$n - 1)
        next_word <- self$predict_next_word(ngram)
        if (is.na(next_word)) break
        word_sequence <- c(word_sequence, next_word)
      }
      paste(word_sequence, collapse = " ")
    }
  ),
  private = list(
    sep = "\x1f",
    key_from = function(ngram) paste(ngram, collapse = private$sep),
    get_counts = function(key) {
      if (!is.null(self$model[[key]])) self$model[[key]] else {
        x <- integer(0); names(x) <- character(0); x
      }
    },
    update_model = function(tokens) {
      n <- self$n
      if (length(tokens) < n) return(invisible(NULL))
      for (i in seq_len(length(tokens) - n + 1)) {
        ngram <- tokens[i:(i + n - 2)]
        next_word <- tokens[i + n - 1]
        key <- private$key_from(ngram)
        counts <- private$get_counts(key)
        if (next_word %in% names(counts)) {
          counts[[next_word]] <- counts[[next_word]] + 1L
        } else {
          counts[[next_word]] <- 1L
        }
        self$model[[key]] <- counts
      }
      invisible(NULL)
    },
    random_start = function() {
      keys <- ls(envir = self$model, all.names = TRUE)
      if (length(keys) == 0) {
        stop("No n-grams available. Digest text first.")
      }
      picked <- sample(keys, 1)
      strsplit(picked, private$sep, fixed = TRUE)[[1]]
    }
  )
)

```

``` R session=lms capture
model <- NGramMarkovModel$new(n = 3)
model$digest_url("https://www.gutenberg.org/cache/epub/10662/pg10662.txt")

# Generate text starting with a given n-gram or randomly if not provided
print(model$generate_text(length = 128))

```

``` R session=lms capture
model <- NGramMarkovModel$new(n = 5)
model$digest_url("https://www.gutenberg.org/cache/epub/10662/pg10662.txt")

# Generate text starting with a given n-gram or randomly if not provided
print(model$generate_text(length = 128))

```

We got some juice out of that - why not use ::03_larger:ever larger lookback::?

