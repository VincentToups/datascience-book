Asking Models to Tag or Otherwise Annotate Data
===============================================


``` R session=lms capture
library(jsonlite)
library(digest)

KEYWORDS_CACHE_DIR <- ".keywords_cache"
if (!dir.exists(KEYWORDS_CACHE_DIR)) dir.create(KEYWORDS_CACHE_DIR)

get_kw_cache_path <- function(txt) file.path(KEYWORDS_CACHE_DIR, paste0(digest(txt, "md5"), ".txt"))

# Robustly extract the first balanced JSON array from a possibly noisy response
extract_json_array <- function(x) {
  x <- gsub("^\n?```[a-zA-Z0-9]*\n", "", x, perl = TRUE)
  x <- gsub("\n```\n?$", "", x, perl = TRUE)
  x <- gsub("```", "", x, fixed = TRUE)
  x <- gsub("^\\s*json\\s*$", "", x)
  x <- gsub("^\\s*\\[\\[?\\d+\\]?\\]\\s*$", "", x, perl = TRUE)
  chars <- strsplit(x, "", fixed = TRUE)[[1]]
  n <- length(chars)
  depth <- 0L; open_idx <- NA_integer_
  for (i in seq_len(n)) {
    ch <- chars[[i]]
    if (ch == "[") {
      if (is.na(open_idx)) open_idx <- i
      depth <- depth + 1L
    } else if (ch == "]" && !is.na(open_idx)) {
      depth <- depth - 1L
      if (depth == 0L) return(trimws(substr(x, open_idx, i)))
    }
  }
  trimws(x)
}

get_keywords <- function(txt) {
  cache_path <- get_kw_cache_path(txt)
  status_path <- "/tmp/status"

  # Initialize or refresh progress tracker in global env
  if (!exists("kw_progress", envir = .GlobalEnv, inherits = FALSE)) {
    total <- tryCatch(length(get("tnl_paragraphs", inherits = TRUE)), error = function(e) NA_integer_)
    assign("kw_progress", list(started = Sys.time(), total = total, done = 0L), envir = .GlobalEnv)
  } else {
    prog_chk <- get("kw_progress", envir = .GlobalEnv)
    current_total <- tryCatch(length(get("tnl_paragraphs", inherits = TRUE)), error = function(e) prog_chk$total)
    if (is.null(prog_chk$started) || is.na(prog_chk$total) || !identical(prog_chk$total, current_total) || (is.numeric(prog_chk$done) && is.numeric(prog_chk$total) && prog_chk$done >= prog_chk$total)) {
      assign("kw_progress", list(started = Sys.time(), total = current_total, done = 0L), envir = .GlobalEnv)
    }
  }

  # Load raw from cache or request from local model
  if (file.exists(cache_path)) {
    content <- paste(readLines(cache_path, warn = FALSE), collapse = "\n")
  } else {
    prompt <- sprintf('Read the following passage from William Hope Hodgson\'s novel The Night Land, which describes a future world and a journey to save a loved one. Extract 5-15 keywords that reflect the general themes and emotional content. Keywords should be in lowercase, in English ASCII characters, and focus on broad literary concepts like emotions, actions, and challenges, such as love, fear, danger, courage, or isolation. Avoid specific terms unique to the story.\n\nReturn only a JSON array of keywords. If the passage is too short or lacks meaningful content, return an empty JSON array.\n\nPassage:\n%s', txt)
    messages <- list(
      list(role = "system", content = "This is a conversation between an expert AI and a human. When they request JSON objects return only valid JSON."),
      list(role = "user", content = prompt)
    )
    res <- chat_request(model = "gemma3:1b", messages = messages, provider = "ollama")
    content <- res$content
    print(content)
    writeLines(content, cache_path)
  }
  keywords <- tryCatch(jsonlite::fromJSON(extract_json_array(content)), error = function(e) character())

  # Progress + ETA
  prog <- get("kw_progress", envir = .GlobalEnv)
  prog$done <- as.integer(prog$done) + 1L
  elapsed <- as.numeric(difftime(Sys.time(), prog$started, units = "secs"))
  rate <- if (prog$done > 0) elapsed / prog$done else NA_real_
  remaining <- if (!is.na(prog$total) && !is.na(rate)) max(prog$total - prog$done, 0) * rate else NA_real_
  eta_str <- if (is.na(remaining)) {
    "ETA: NA"
  } else {
    hh <- floor(remaining / 3600);
    mm <- floor((remaining %% 3600) / 60);
    ss <- floor(remaining %% 60);
    paste0("ETA: ", sprintf("%02d:%02d:%02d", hh, mm, ss))
  }
  msg <- sprintf("Tagged %d/%s | %s", prog$done, ifelse(is.na(prog$total), "?", as.character(prog$total)), eta_str)
  assign("kw_progress", prog, envir = .GlobalEnv)
  cat(msg, "\n")
  try(cat(paste0(msg, "\n"), file = status_path, append = TRUE), silent = TRUE)

  keywords
}

```

``` R session=lms capture
keywords <- lapply(tnl_paragraphs[50:60], get_keywords)
keywords
```

Ok, so now we have a set of keywords. However, its important to think carefully about how we used the language model here. The first critical fact is that language models have exactly two forms of memory by default: long term memory stored in the fixed weights of the model and short term memory represented literally and entirely by the text which functions as the input to the model. Unless you explicitly fill that text with information, the model will not remember anything from one invocation to the next. In our specific case its difficult to know whether the keywords that the model will employ will be consistent across invocations. In fact, because the sampling of the language model is typically random, unless we set the seed of the random number generator, two invocations of the same model with the same input text will not generally reproduce the same output.

Thus, we may want to look at the results and try to figure out a set of keywords which we can use in a second run-through of the data.


``` R session=lms capture
# Flatten and count keyword frequencies
all_keywords_flat <- unlist(keywords)
tab <- sort(table(all_keywords_flat), decreasing = TRUE)
df <- data.frame(keyword = names(tab), count = as.integer(tab), row.names = NULL)
df

```

``` R session=lms capture
head(df$keyword, 100)
```

I handed ChatGPT the above list and asked it to tidy it up:

Emotions: fear, love, hope, despair, sorrow, joy, courage, anger, longing, loneliness, happiness, affection, anxiety
States: isolation, strength, weakness, safety, danger, uncertainty, darkness, light, quiet, silence, warmth, slumber, dread
Themes: survival, mystery, exploration, adventure, journey, struggle, discovery, protection, endurance, determination, perseverance, companionship
Concepts: life, death, memory, spirit, knowledge, wisdom, eternity, understanding, power, emotion, desire
Environment: night, land, water, earth, place, world, darkness, strangeness, unknown, distance
Symbols: monster, fire, armour, rock, pyramid, evil, destruction, terror, threat
Actions: search, fight, watch, anticipation, preparation, observation, communication

Now let's rewrite our prompt to tell the machine to use this list of keywords exclusively.

``` R session=lms capture
remove_markers <- function(x) extract_json_array(x)

get_keywords_tidy <- function(txt) {
  cache_path <- get_kw_cache_path(paste0(txt, "tidy"))
  status_path <- "/tmp/status"

  # Initialize or refresh separate progress tracker for tidy run
  if (!exists("kwt_progress", envir = .GlobalEnv, inherits = FALSE)) {
    total <- tryCatch(length(get("tnl_paragraphs", inherits = TRUE)), error = function(e) NA_integer_)
    assign("kwt_progress", list(started = Sys.time(), total = total, done = 0L), envir = .GlobalEnv)
  } else {
    prog_chk <- get("kwt_progress", envir = .GlobalEnv)
    current_total <- tryCatch(length(get("tnl_paragraphs", inherits = TRUE)), error = function(e) prog_chk$total)
    if (is.null(prog_chk$started) || is.na(prog_chk$total) || !identical(prog_chk$total, current_total) || (is.numeric(prog_chk$done) && is.numeric(prog_chk$total) && prog_chk$done >= prog_chk$total)) {
      assign("kwt_progress", list(started = Sys.time(), total = current_total, done = 0L), envir = .GlobalEnv)
    }
  }

  # Load from cache or request from local model
  if (file.exists(cache_path)) {
    content <- paste(readLines(cache_path, warn = FALSE), collapse = "\n")
  } else {
    prompt <- sprintf('Read the following passage from William Hope Hodgson\'s novel The Night Land, which describes a future world and a journey to save a loved one. Use the following categorized list of keywords:\n\n[\n    "fear", "love", "hope", "despair", "sorrow", "joy", "courage", "anger", "longing", "loneliness", "happiness", "affection", "anxiety",\n    "isolation", "strength", "weakness", "safety", "danger", "uncertainty", "darkness", "light", "quiet", "silence", "warmth", "slumber", "dread",\n    "survival", "mystery", "exploration", "adventure", "journey", "struggle", "discovery", "protection", "endurance", "determination", "perseverance", "companionship",\n    "life", "death", "memory", "spirit", "knowledge", "wisdom", "eternity", "understanding", "power", "emotion", "desire",\n    "night", "land", "water", "earth", "place", "world", "darkness", "strangeness", "unknown", "distance",\n    "monster", "fire", "armour", "rock", "pyramid", "evil", "destruction", "terror", "threat",\n    "search", "fight", "watch", "anticipation", "preparation", "observation", "communication"\n]\n\nUse ONLY keywords that appear in the above list. Do NOT fence the result in backquotes or anything. Just return the JSON.\n\nReturn only a JSON array of keywords. If the passage is too short or lacks meaningful content, return an empty JSON array.\n\nPassage:\n%s', txt)
    messages <- list(
      list(role = "system", content = "This is a conversation between an expert AI and a human. When they request JSON objects return only valid JSON."),
      list(role = "user", content = prompt)
    )
    res <- chat_request(model = "gemma3:1b", messages = messages, provider = "ollama")
    content <- res$content
    writeLines(content, cache_path)
  }
  if (!exists("content", inherits = FALSE)) {
    content <- paste(readLines(cache_path, warn = FALSE), collapse = "\n")
  }
  keywords <- tryCatch(jsonlite::fromJSON(remove_markers(content)), error = function(e) character())

  # Progress + ETA for tidy run
  prog <- get("kwt_progress", envir = .GlobalEnv)
  prog$done <- as.integer(prog$done) + 1L
  elapsed <- as.numeric(difftime(Sys.time(), prog$started, units = "secs"))
  rate <- if (prog$done > 0) elapsed / prog$done else NA_real_
  remaining <- if (!is.na(prog$total) && !is.na(rate)) max(prog$total - prog$done, 0) * rate else NA_real_
  eta_str <- if (is.na(remaining)) {
    "ETA: NA"
  } else {
    hh <- floor(remaining / 3600);
    mm <- floor((remaining %% 3600) / 60);
    ss <- floor(remaining %% 60);
    paste0("ETA: ", sprintf("%02d:%02d:%02d", hh, mm, ss))
  }
  msg <- sprintf("Tagged (tidy) %d/%s | %s", prog$done, ifelse(is.na(prog$total), "?", as.character(prog$total)), eta_str)
  assign("kwt_progress", prog, envir = .GlobalEnv)
  cat(msg, "\n")
  try(cat(paste0(msg, "\n"), file = status_path, append = TRUE), silent = TRUE)

  keywords
}
```

``` R session=lms capture
keywords_tidy <- lapply(tnl_paragraphs, get_keywords_tidy)
```

Note that above I am using a smaller, cheaper and dumber model, which is probably ok, since we constrained the keywords. We might also get away with running this kind of job on a local model.


``` R session=lms capture
# Requires Rtsne and ggplot2
library(Rtsne)
library(ggplot2)
library(viridis)

# Step 1: Convert list of lists to a DataFrame of binary indicators
all_keywords <- sort(unique(unlist(keywords_tidy)))
keywords_df <- as.data.frame(do.call(rbind, lapply(keywords_tidy, function(keywords) {
  as.integer(all_keywords %in% keywords)
})))
colnames(keywords_df) <- all_keywords

# Step 2: Group data by sets of ten rows and sum keyword counts
chunk_size <- 10L
num_chunks <- nrow(keywords_df) %/% chunk_size
grouped_vectors <- do.call(rbind, lapply(seq_len(num_chunks), function(i) {
  colSums(keywords_df[((i - 1) * chunk_size + 1):(i * chunk_size), , drop = FALSE])
}))

# Step 3: Apply t-SNE to project grouped keyword vectors to 2D
tsne <- Rtsne::Rtsne(grouped_vectors, dims = 2, perplexity = 10, verbose = FALSE)
coords <- as.data.frame(tsne$Y)
names(coords) <- c("x", "y")
coords$index <- paste0("Group ", seq_len(nrow(coords)))
coords$order <- seq_len(nrow(coords))

ggplot(coords, aes(x = x, y = y)) +
  geom_point(color = "navy", alpha = 0.7) +
  geom_path(aes(group = 1, color = order), linewidth = 1) +
  scale_color_viridis_c(guide = "none") +
  ggtitle("t-SNE of Summed Keyword Vectors with Sequential Color Gradient Line") +
  xlab("t-SNE Dimension 1") + ylab("t-SNE Dimension 2")

```

Summary
=======

Language models are crazy! They are enormously useful to the data scientist because they can transform textual data into numerical forms by either embedding or by using natural language instructions to score or keyword label data. 

You can run language models at home or on a service like OpenAI's api. Amazon and Azure and Google also provide such services. Google Collab also provides access to free machines to run python which can handle running relatively large language models. 

Warning
=======

In this example we played willy-nilly with the language model's output but in a serious situation the proper way would be to hand-label some portion of the data set so that you can evaluate the success of the language model. In the case of keyword labels you'd want to do like 100 yourself as a basis for comparison. For the case of embeddings you would need to figure out what your modelling process is and then hand-label or cluster the data to have a basis of comparison. Or you need to establish some other criteria for evaluating the model.  Remember: language models are just gigantic joint probabilitity distributions. They cannot really reason except to the extent that sampling from the distribution tends to reproduce textual chains of thought. Despite these limitations I think its a mistake not to consider models.

``` R session=lms capture

```
