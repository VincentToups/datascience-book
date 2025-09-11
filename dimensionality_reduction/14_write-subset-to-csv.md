# Write subset to CSV
``` R acc=write_subset load_state=subset save_state=tsne_written
write.csv(as.matrix(subset_distances), file = "subset_distances.csv", row.names = FALSE)

system("python3 do-tsne.py")
```


Next: ::15_read-results-back-into-r:Read results back into R::
