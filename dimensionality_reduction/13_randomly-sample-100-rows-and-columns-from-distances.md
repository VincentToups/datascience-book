# Randomly sample 100 rows and columns from distances
``` R acc=subset load_state=metric save_state=subset
sample_indices <- sample(nrow(distances), 750)
subset_distances <- distances[sample_indices, sample_indices]
```



Next: ::14_write-subset-to-csv:Write subset to CSV::
