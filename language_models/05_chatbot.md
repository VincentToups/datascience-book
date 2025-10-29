[Quick aside on OO programming in R](../object_orientation_r/01_start.md)

``` R session=lms capture
ChatWrapper <- R6::R6Class(
  "ChatWrapper",
  public = list(
    model = NULL,
    provider = NULL,
    message_history = NULL,
    initialize = function(model, provider = "ollama") {
      self$model <- model
      self$provider <- provider
      self$message_history <- list(
        list(role = "system", content = "You are an intelligent, friendly, artificial intelligence which can program in Python with an emphasis on data science.")
      )
    },
    message = function(user_content) {
      self$message_history <- c(self$message_history, list(list(role = "user", content = user_content)))
      response <- chat_request(model = self$model, messages = self$message_history, provider = self$provider)
      assistant_content <- response$content
      print(assistant_content)
      self$message_history <- c(self$message_history, list(list(role = "assistant", content = assistant_content)))
      invisible(response)
    }
  )
)

```

Which we use like this:

``` R session=lms capture
c <- ChatWrapper$new(model_name, provider = provider)
res <- c$message("Explain how list comprehensions work, please.")
cat(sprintf(res$content))
```

But how do we actually use ::06_datascience:language models for data science::? 
