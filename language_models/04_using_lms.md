Running Language Models Locally
===============================

Its actually surprisingly possible to run a language model on a modern laptop, although the models that fit on such a small machine are much less "intelligent" than the extremely large models that commercial companies provide access to. There are large models you can run yourself if you have the hardware, but to even approach the capabilities of ChatGPT you need many tens of gigabytes of GPU RAM.

But running a model locally can be a cheap way to experiment with the technology. My preferred way to run models this way is called llama_cpp and I usually use the python "bindings."

Recall from our previous lectures that the web runs on HTTP requests - your browser makes them and they are sort of the lingua franca of computers talking to one another. Hence, while APIs are available in some programming languages, we can interact with
language models by simply using HTTP requests. Since OpenAI was the first mover in this space, it has become standard for systems to support OpenAI's API structure. Here we will use ollama to demonstrate using LLMs locally.

https://ollama.com/

Ollama is actually just a glorified wrapper around Docker and its containers warp llama_cpp:

https://github.com/ggml-org/llama.cpp

But luckily we barely need to know how any of that stuff works  because we will just talk to these systems via HTTP requests.

``` R session=lms capture
library(httr)
library(jsonlite)

# Helper functions to call either OpenAI or Ollama via HTTP
chat_request <- function(model, messages, provider = c("openai","ollama"),
                         base_url = NULL, api_key = Sys.getenv("OPENAI_API_KEY"),
                         temperature = 0.7, max_tokens = 256, num_predict = max_tokens) {
  provider <- match.arg(provider)
  if (is.null(base_url)) base_url <- if (provider == "openai") "https://api.openai.com/v1" else "http://localhost:11434/v1"
  if (provider == "openai") {
    url <- paste0(base_url, "/chat/completions")
    body <- list(model = model, messages = messages, temperature = temperature, max_tokens = max_tokens)
    resp <- httr::POST(url, httr::add_headers(Authorization = paste("Bearer", api_key)), body = body, encode = "json")
    httr::stop_for_status(resp)
    res <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
  } else {
    url <- paste0(base_url, "/chat/completions")
    body <- list(model = model, messages = messages, temperature = temperature, max_tokens = max_tokens)
    resp <- httr::POST(url, body = body, encode = "json")
    httr::stop_for_status(resp)
    res <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
  }
    list(content=res$choices$message$content[1],role="assistant")	
}
```

The above fetches a response (in text terms) from the language
model. But we are also often interested in so-called embeddings, which
are just a concise numerical representation of the input.

``` R session=lms capture
embedding_request <- function(model, inputs, provider = c("openai","ollama"),
                              base_url = NULL, api_key = Sys.getenv("OPENAI_API_KEY")) {
  provider <- match.arg(provider)
  if (is.null(base_url)) base_url <- if (provider == "openai") "https://api.openai.com/v1" else "http://localhost:11434/v1"
  if (provider == "openai") {
    url <- paste0(base_url, "/embeddings")
    resp <- httr::POST(url, httr::add_headers(Authorization = paste("Bearer", api_key)), body = list(model = model, input = inputs), encode = "json")
  } else {
    url <- paste0(base_url, "/embeddings")
    resp <- httr::POST(url, body = list(model = model, input = inputs), encode = "json")
  }
  httr::stop_for_status(resp)
  res <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
  if (!is.null(res$data)) {
    if (is.data.frame(res$data) && "embedding" %in% names(res$data)) {
      return(res$data$embedding)
    } else if (is.list(res$data)) {
      return(lapply(res$data, function(x) x$embedding))
    }
  }
  res
}
```

With these functions defined we can actually just talk to the models.

``` R session=lms capture

# Choose provider and model
provider <- "ollama"  # set to "openai" to use OpenAI API
model_name <- "gemma3:1b"  # if provider=="ollama", ensure this model exists locally

# Simple completion using chat interface
resp <- chat_request(
  model = model_name,
  messages = list(list(role = "user", content = "It was the best of times")),
  provider = provider,
  max_tokens = 2000
)
cat(sprintf("%s\n",resp$content))
```

This is a compact model — around 1B parameters for `gemma3:1b` (still far fewer than very large hosted models). And yet we're getting pretty coherent text out of it.

Its worth saying a bit about how these models are trained. They are usually trained in two phases - first they are simply trained on a very large corpus of text. The initial language models were trained on raw text scraped from the internet - far too much text for any person to examine and clean by hand. From this large amount of text the model learns the meanings of words (or at least their statistical correlations). Then the model is typically "fine tuned" on conversational style data which helps the model function as a task-performing conversational agent. This process involves a template of some kind which anchors the model in conversation mode. For illustration, an instruction-tuned model might have a chat template like this:

```
FROM gemma3:1b
TEMPLATE """{{ if .System }}<|system|>
{{ .System }}<|end|>
{{ end }}{{ if .Prompt }}<|user|>
{{ .Prompt }}<|end|>
{{ end }}<|assistant|>
{{ .Response }}<|end|>
"""
PARAMETER stop """{"stop": ["<|end|>","<|user|>","<|assistant|>"]}"""
SYSTEM """You are a helpful assistant."""
```

Luckily we don't have to manage this ourselves anymore : llama_cpp can usually read the appropriate template from the gguf file. We can just use its chat completion interface to "chat" with the model.


```sidebar
The standard format for offline language models is "gguf". GG stands for "Georgi Gerganov" who wrote
the widely used `llama.cpp` library to run language models locally.
```

Note that we often want to customize the system message to change the behavior of our robot.

``` R session=lms capture
resp <- chat_request(
  model = model_name,
  messages = list(
    list(role = "system", content = "You are an intelligent, friendly, artificial intelligence which can program in Python with an emphasis on data science."),
    list(role = "user", content = "How do I randomly permute the elements of a numpy array?")
  ),
  provider = provider,
  max_tokens = 2000
)
print(resp$content)

```

We can wrap this up in a class to make ::05_chatbot:chatting a little easier::.


