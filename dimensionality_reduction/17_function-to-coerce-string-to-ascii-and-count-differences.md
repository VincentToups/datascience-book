# Function to coerce string to ASCII and count differences
count_ascii_diff <- function(char_vector) {
  # Coerce to ASCII
  ascii_vector <- iconv(char_vector, to = "ASCII//TRANSLIT")
  
  # Initialize counter for differences
  diff_count <- 0
  
  # Loop through each element in the character vector
  for (i in seq_along(char_vector)) {
    # Extract individual characters from original and ASCII strings
    orig_chars <- unlist(strsplit(char_vector[i], ""))
    ascii_chars <- unlist(strsplit(ascii_vector[i], ""))
    
    # Count differences
    diff_count <- diff_count + sum(orig_chars != ascii_chars)
  }
  
  return(diff_count)
}


```

``` R acc=ascii load_state=conclusion save_state=ascii

Next: ::18_function-to-calculate-victor-purpura-distance-between-two-spike-trains:Function to calculate Victor-Purpura distance between two spike trains::
