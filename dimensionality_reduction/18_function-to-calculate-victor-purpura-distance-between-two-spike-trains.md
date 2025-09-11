# Function to calculate Victor-Purpura distance between two spike trains
``` R acc=vp_distance load_state=ascii save_state=vp_distance
victor_purpura_distance <- function(spike_train1, spike_train2, q) {
  n1 <- length(spike_train1)
  n2 <- length(spike_train2)
  
  # Initialize cost matrix
  cost_matrix <- matrix(0, nrow = n1 + 1, ncol = n2 + 1)
  
  # Base cases: cost of inserting all spikes from one train to the other
  for (i in 1:(n1 + 1)) {
    cost_matrix[i, 1] <- i - 1
  }
  for (j in 1:(n2 + 1)) {
    cost_matrix[1, j] <- j - 1
  }
  
  # Fill the cost matrix
  for (i in 2:(n1 + 1)) {
    for (j in 2:(n2 + 1)) {
      # Cost of deleting a spike from train1 or inserting a spike into train2
      cost_del_insert <- min(cost_matrix[i - 1, j] + 1, cost_matrix[i, j - 1] + 1)
      
      # Cost of shifting a spike from one time to another
      time_diff <- abs(spike_train1[i - 1] - spike_train2[j - 1])
      cost_shift <- cost_matrix[i - 1, j - 1] + q * time_diff
      
      # Take the minimum cost of delete/insert/shift
      cost_matrix[i, j] <- min(cost_del_insert, cost_shift)
    }
  }
  
  # The final cost is the Victor-Purpura distance
  return(cost_matrix[n1 + 1, n2 + 1])
}
```

Next: ::19_function-to-calculate-pairwise-victor-purpura-distances:Function to calculate pairwise Victor-Purpura distances::
