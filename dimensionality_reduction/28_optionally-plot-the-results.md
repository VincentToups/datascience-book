# Optionally, plot the results
``` R acc=tsne_plot load_state=tsne save_state=tsne_plot
## ggplot scatter replacement
ggmd(ggplot(tsne_results, aes(V1, V2)) +
       geom_point(alpha=0.8) +
       labs(x = "Component 1", y = "Component 2",
            title = "t-SNE on Victor-Purpura Distance Matrix"))

```
