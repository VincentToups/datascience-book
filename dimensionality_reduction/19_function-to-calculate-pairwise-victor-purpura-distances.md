# Function to calculate pairwise Victor-Purpura distances
``` R acc=vp_pairwise load_state=vp_distance save_state=vp_pairwise
pairwise_victor_purpura <- function(df, q) {
  # Extract unique trials
  trials <- unique(df$trial)
  
  # Initialize a distance matrix
  distance_matrix <- matrix(0, nrow = length(trials), ncol = length(trials))
  rownames(distance_matrix) <- trials
  colnames(distance_matrix) <- trials
  
  # Calculate pairwise distances
  for (i in 1:length(trials)) {
    for (j in i:length(trials)) {
      # Get spike trains for each trial
      train1 <- df$time[df$trial == trials[i]]
      train2 <- df$time[df$trial == trials[j]]
      
      # Calculate Victor-Purpura distance
      distance <- victor_purpura_distance(train1, train2, q)
      
      # Fill the distance matrix symmetrically
      distance_matrix[i, j] <- distance
      distance_matrix[j, i] <- distance
    }
  }
  
  return(distance_matrix)
}
```

Next: ::20_example-usage:Example Usage::
