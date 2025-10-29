
Using Language Models for Data Science
======================================

There are two ways, embeddings and using the language model's output. 

Embeddings
----------

Language models have to transfrm their data into numbers in order to actually do their jobs. This is the first stage of processing that the input text gets when it is fed into the model and it is called "embedding." The embeddings are learned as part of the training process and consequently they contain a lot of information about the text passed in, but unlike text, they can be used as vectors (approximately) and are thus ammenable to many of the methods we discussed in class. We can get embeddings from our llama_cpp model like this:


``` R session=lms capture
# Using HTTP embeddings (switch provider between "ollama" and "openai")
provider <- "ollama"
model_name <- if (provider == "openai") "text-embedding-3-small" else "nomic-embed-text"

emb <- embedding_request(model = model_name, inputs = c("It was the best of times.", "It was the worst of times."), provider = provider)
txt <- jsonlite::toJSON(emb, auto_unbox = TRUE)
print(substr(txt, 1, 300))
```

``` R session=lms capture
library(httr)
library(tokenizers)

fetch_and_split_paragraphs <- function(url) {
  response <- httr::GET(url)
  text <- httr::content(response, as = "text", encoding = "UTF-8")
  text <- gsub("\r\n", "\n", text)
  text <- gsub("\r", "\n", text)
  tokenize_paragraphs(text, paragraph_break = "\n\n", simplify = TRUE)
}

tnl_paragraphs <- fetch_and_split_paragraphs("https://www.gutenberg.org/cache/epub/10662/pg10662.txt")
head(tnl_paragraphs)
```

``` R session=lms capture
es <- embedding_request(model = model_name, inputs = tnl_paragraphs[1:10], provider = provider)
print(substr(jsonlite::toJSON(es, auto_unbox = TRUE), 1, 200))
```

Thus in a pinch we could calculate embeddings for a large data set on our own computer with a reasonably capable language model. However, if we get to this scale of things we probably want to pay a little money to havve a bigger computer do the embeddings. Most big shops (aws, for example) support getting embeddings but I'll show you how to use OpenAI for this purpose. 

Note! You will be sending your data to them in order to get embeddings. So bear that in mind if you have privacy or confidentiality or copyright concerns.

 

``` R session=lms capture
# Best practice (R) — OpenAI embeddings via HTTP
library(jsonlite)
library(digest)

# Sys.setenv(OPENAI_API_KEY = "...")

# Ensure the cache directory exists
CACHE_DIR <- ".embedding_cache"
if (!dir.exists(CACHE_DIR)) dir.create(CACHE_DIR)

get_cache_path <- function(text) {
  file.path(CACHE_DIR, paste0(digest(text, algo = "md5"), ".json"))
}

get_embedding <- function(text, model = "nomic-embed-text") {
  cache_path <- get_cache_path(text)
  if (file.exists(cache_path)) {
    return(jsonlite::fromJSON(cache_path))
  }
  vec <- embedding_request(model = model, inputs = text, provider = "ollama")[[1]]
  write(jsonlite::toJSON(vec, auto_unbox = TRUE), cache_path)
  vec
}

print(length(tnl_paragraphs))
tnl_paragraphs <- tnl_paragraphs[nchar(tnl_paragraphs) > 50]
print(length(tnl_paragraphs))

embeddings <- lapply(tnl_paragraphs, get_embedding)

```

Once we have our embeddings we can ::07_dim_red:do stuff with them::.
