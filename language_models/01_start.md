Language Models!
================

``` R
# Install required packages for this document
install.packages(c(
  "httr", "jsonlite", "tokenizers", "stringr", "R6",
  "digest", "ggplot2", "Rtsne", "viridis"
), repos = "https://cloud.r-project.org")
```

``` Dockerfile
# Dockerfile snippet to install the R packages used here
# Uses a Rocker base image with R preinstalled
FROM rocker/r-ver:4.3.3

# (Optional) system deps commonly needed by CRAN packages used here
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev libssl-dev libxml2-dev libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Install CRAN packages
RUN R -e 'install.packages(c(\
  "httr","jsonlite","tokenizers","stringr","R6",\
  "digest","ggplot2","Rtsne","viridis"\
), repos = "https://cloud.r-project.org")'
```

What the heck!? The human race has been around for like 10000 - 1.5 million years and in all that time if you wanted to have a conversation with something you had only one choice: another person.

And yet it can be said that in the last 4 years that state of affairs has changed: you can now talk to something called a language model. This surprised me as it surprised many people.

https://www.numerama.com/pop-culture/135762-peut-on-generer-automatiquement-le-prochain-chef-doeuvre-de-la-litterature.html

The above quote is coverage in a french media magazine of my very own pre-language model text-generation attempt as part of national novel generating month. I used something called a Markov model to perform this task and I want to explain how that works as a way of gently hinting at how language models work.

Let's begin with a corpus of words:

``` R session=lms capture
# Required libraries
library(httr)
library(tokenizers)
library(stringr)

# Step 1: Fetch text from URL
url <- "https://www.gutenberg.org/cache/epub/10662/pg10662.txt"
resp <- httr::GET(url)
text <- httr::content(resp, as = "text", encoding = "UTF-8")

# Step 2: Tokenize the text
tokens <- tokenizers::tokenize_words(text, lowercase = TRUE, strip_punct = TRUE)[[1]]

# Step 3: Build the Markov model (bigram-based)
markov_model <- new.env(parent = emptyenv())

get_counts <- function(env, key) {
  if (!is.null(env[[key]])) env[[key]] else {
    x <- integer(0); names(x) <- character(0); x
  }
}

if (length(tokens) > 1) {
  for (i in seq_len(length(tokens) - 1)) {
    current_word <- tokens[i]
    next_word <- tokens[i + 1]
    counts <- get_counts(markov_model, current_word)
    if (next_word %in% names(counts)) {
      counts[[next_word]] <- counts[[next_word]] + 1L
    } else {
      counts[[next_word]] <- 1L
    }
    markov_model[[current_word]] <- counts
  }
}

# Step 4: Function to predict the next word
predict_next_word <- function(word, model = markov_model) {
  counts <- get_counts(model, word)
  if (length(counts) == 0) return(NA_character_)
  sample(names(counts), size = 1, prob = as.numeric(counts))
}

# Step 5: Generate a sequence
generate_text <- function(start_word, length = 10) {
  word_sequence <- c(start_word)
  for (i in seq_len(length - 1)) {
    next_word <- predict_next_word(tail(word_sequence, 1))
    if (is.na(next_word)) break
    word_sequence <- c(word_sequence, next_word)
  }
  paste(word_sequence, collapse = " ")
}

# Example usage
print(generate_text("love", 45))

```

This sucks! If we ::02_multiple:think a bit we can improve the outcome a little::.
