library(httr2)
library(rvest)
library(xml2)
library(stringr)
library(purrr)
library(tibble)
library(dplyr)
library(readr)
#!/usr/bin/env Rscript
# Scrape zbMATH yearly counts for 1980–2024 using browser-like headers,
# retries, and jittered delays to reduce blocking.

suppressPackageStartupMessages({
  library(httr2); library(rvest); library(xml2); library(stringr)
  library(purrr); library(tibble); library(dplyr); library(readr)
})

# ----- Config -----
YEARS <- 1980:2024
OUTFILE <- "zbmath_counts_1980_2024.csv"
# Jittered pause between years (seconds). Override via env if desired.
PAUSE_MIN <- as.numeric(Sys.getenv("ZBMATH_PAUSE_MIN", "2"))
PAUSE_MAX <- as.numeric(Sys.getenv("ZBMATH_PAUSE_MAX", "5"))
MAX_TRIES <- as.integer(Sys.getenv("ZBMATH_MAX_TRIES", "5"))
REQ_TIMEOUT <- as.numeric(Sys.getenv("ZBMATH_TIMEOUT", "30"))

# ----- Helpers -----
rand_suffix <- function() {
  # small random UA suffix to de-duplicate requests without looking suspicious
  paste0(sample(c(letters, LETTERS, 0:9), 6, TRUE), collapse = "")
}

build_url <- function(year) {
  paste0(
    "https://zbmath.org/?ml=3",
    "&ml-1-f=py",
    "&ml-1-v=", year,
    "&ml-1-op=and",
    "&ml-2-f=au",
    "&ml-2-v=",
    "&ml-2-op=and",
    "&ml-3-f=ti",
    "&ml-3-v=",
    "&dt=j&dt=a&dt=b&dt=p"
  )
}

make_req <- function(url) {
  # Emulate a real browser; allow gzip/br/zstd; keep-alive; add referer and sec- headers
  ua <- sprintf("Mozilla/5.0 (X11; Linux x86_64; rv:143.0) Gecko/20100101 Firefox/143.0 %s",
                rand_suffix())

  request(url) |>
    req_user_agent(ua) |>
    req_headers(
      "Accept"            = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
      "Accept-Language"   = "en-US,en;q=0.9",
      "Accept-Encoding"   = "gzip, deflate, br, zstd",
      "Referer"           = "https://zbmath.org/",
      "Connection"        = "keep-alive",
      "Upgrade-Insecure-Requests" = "1",
      "Sec-Fetch-Dest"    = "document",
      "Sec-Fetch-Mode"    = "navigate",
      "Sec-Fetch-Site"    = "same-origin",
      "Sec-Fetch-User"    = "?1",
      "Cache-Control"     = "no-cache",
      "Pragma"            = "no-cache",
      "DNT"               = "1",
      "Sec-GPC"           = "1"
    ) |>
    # Timeouts & retry for transient errors (429/5xx)
    req_timeout(REQ_TIMEOUT) |>
    req_retry(
      max_tries = MAX_TRIES,
      is_transient = function(resp) {
        code <- resp_status(resp)
        code == 429 || (code >= 500 && code < 600)
      },
      backoff = function(try) { # jittered linear backoff
        runif(1, 2, 5) + (try - 1) * runif(1, 1.5, 2.5)
      }
    ) |>
    # Do not abort on HTTP error (we handle NA later)
    req_error(is_error = ~ FALSE)
}

parse_count_from_h2 <- function(html_doc) {
  h2 <- html_element(html_doc, xpath = "//h2[contains(., 'Found')]")
  if (is.na(h2)) return(NA_integer_)
  txt <- html_text(h2, trim = TRUE)
  m <- str_match(txt, "Found\\s+([0-9][0-9,]*)\\s+Documents")
  if (length(m) < 2 || is.na(m[,2])) return(NA_integer_)
  as.integer(gsub(",", "", m[,2]))
}

fetch_year_count <- function(year) {
  url <- build_url(year)
  resp <- make_req(url) |> req_perform()
  if (is.null(resp) || resp_status(resp) != 200) return(NA_integer_)
  doc <- read_html(resp_body_string(resp))
  parse_count_from_h2(doc)
}

# ----- Run -----
set.seed(as.integer(Sys.time()))
results <- map_int(YEARS, function(yy) {
  n <- fetch_year_count(yy)
  # polite jitter between requests
  Sys.sleep(runif(1, PAUSE_MIN, PAUSE_MAX))
  n
})

tbl <- tibble(year = YEARS, n = results)

# basic sanity check
if (anyNA(tbl$n)) {
  warning("Some years returned NA; a few requests may have been blocked or the page structure changed.")
}

write_csv(tbl, OUTFILE)
message("Wrote: ", normalizePath(OUTFILE, mustWork = FALSE))
print(tbl, n = nrow(tbl))
