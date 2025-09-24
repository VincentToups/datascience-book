#!/usr/bin/env Rscript

# Extract TNG dialogs from source_data/tng/*.txt
# Produces a data.frame with columns: episode_number, character, dialog

extract_tng_dialogs <- function(dir = "source_data/tng") {
  stopifnot(dir.exists(dir))
  files <- list.files(dir, pattern = "\\.txt$", full.names = TRUE)
  if (length(files) == 0) {
    return(data.frame(
      episode_number = integer(0),
      character = character(0),
      dialog = character(0),
      stringsAsFactors = FALSE
    ))
  }

  parse_file <- function(path) {
    cat(sprintf("File %s\n", path))
                                lines <- readLines(path, warn = FALSE)

    # Patterns
    # Match five tabs, then an ALL-CAPS character name possibly containing spaces, periods, apostrophes, or hyphens
    # Place '-' first in the class to avoid needing escapes in R strings
    pat_char <- "^\\t{5}([-A-Z0-9 .']+)\\s*$"   # five tabs then ALL CAPS name
    pat_dialog <- "^\\t{3}(\\S.*)$"                 # three tabs then dialog text

    current_char <- NA_character_
    results <- vector("list", length(lines))
    res_i <- 0L
    i <- 1L
    n <- length(lines)

    while (i <= n) {
      line <- lines[[i]]

      # Character name line sets state
      if (grepl(pat_char, line, perl = TRUE)) {
        current_char <- sub(pat_char, "\\1", line, perl = TRUE)
        i <- i + 1L
        next
      }

      # If we have a current character, capture consecutive 3-tab dialog lines as a block
      if (!is.na(current_char) && grepl(pat_dialog, line, perl = TRUE)) {
        block <- character()
        while (i <= n && grepl(pat_dialog, lines[[i]], perl = TRUE)) {
          text <- sub(pat_dialog, "\\1", lines[[i]], perl = TRUE)
          block <- c(block, text)
          i <- i + 1L
        }

        # Collapse block lines into a single dialog string
        dialog <- paste(block, collapse = " ")
        dialog <- trimws(gsub("\\s+", " ", dialog))

        # Append row
        res_i <- res_i + 1L
        results[[res_i]] <- list(
          episode_number = suppressWarnings(as.integer(gsub("[^0-9]", "", basename(path)))),
          character = current_char,
          dialog = dialog
        )

        # continue without increment since we already advanced i in the inner loop
        next
      }

      # Otherwise, move on
      i <- i + 1L
    }

    if (res_i == 0L) {
      return(NULL)
    }

    df <- as.data.frame(do.call(rbind, lapply(results[seq_len(res_i)], as.data.frame)),
                        stringsAsFactors = FALSE)

    # Ensure correct types
    df$episode_number <- as.integer(df$episode_number)
    df$character <- as.character(df$character)
    df$dialog <- as.character(df$dialog)
    df
  }

  cat(sprintf("files %s%",paste(files, collapse=", ")))
  dfs <- lapply(files, parse_file)
  dfs <- dfs[!vapply(dfs, is.null, logical(1))]
  if (!length(dfs)) {
    return(data.frame(
      episode_number = integer(0),
      character = character(0),
      dialog = character(0),
      stringsAsFactors = FALSE
    ))
  }
  do.call(rbind, dfs)
}

# If executed directly, build the data frame into `dialogs` and print a preview
if (identical(environment(), globalenv()) && !length(commandArgs(trailingOnly = TRUE))) {
  dialogs <- extract_tng_dialogs() %>%
    as_tibble() %>%
    mutate(character=str_replace_all(character, " V\\.O\\.", "") %>% str_trim() %>%
             str_replace_all("'S COM VOICE","") %>% str_trim()) %>%
    write_csv("source_data/tng.csv")
}

