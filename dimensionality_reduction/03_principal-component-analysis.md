## Principal Component Analysis

One of the reasons that PCA is so common is that it is very easy to
understand graphically. Principal Component Analysis is the process of
finding a rotation in the state space which aligns the axes of the
coordinate system with the directions of decreasing variation in the data.

Consider the following dataset:

``` R acc=pca load_state=sim
library(tidyverse)
d <- tibble(x=rnorm(1000,0,1),y=rnorm(1000,0,0.25)) %>%
    mutate(x=cos(pi/8)*x - sin(pi/8)*y,
           y=sin(pi/8)*x + cos(pi/8)*y);
ggmd(ggplot(d, aes(x,y)) + geom_point() + coord_fixed());
```

Even if you couldn't see how I generated the data you can identify that
it has two primary axes of variation:

``` R acc=pca
arrow_data <- tibble(x=c(0,0),y=c(0,0),
                     xend=c(cos(pi/8),
                            cos(pi/8 + pi/2)*1.0),
                     yend=c(sin(pi/8),
                            sin(pi/8 + pi/2)*1.0));
p <- ggplot(d, aes(x,y)) +
    geom_point(alpha=0.5) + 
    geom_segment(data=arrow_data,aes(x=x,y=y,xend=xend,yend=yend),
                 color="red",
                 arrow=arrow()) +
    coord_fixed();
ggmd(p)

```

It's a little silly to do this, but I want us to imagine that we're
measuring a one dimensional phenomenon with a two dimensional apparatus.
Maybe it's an oscillator with one degree of freedom but our instrument is
two dimensional, not aligned with it, and has some noise.

Using principal component analysis we can automatically find that axis
of maximal variation corresponding to the true degrees of freedom of the
underlying system. Once we have our rotated data we can throw away the
unimportant axis.

How does this look?

``` R acc=pca
r <- prcomp(d);
r
```

And

``` R acc=pca
summary(r);
```

(Recall `summary` is a *method*).

We can apply the rotation to our data by hand. Recall that given a
rotation matrix $R_{ij}$ the new coordinates are just:

$$
\begin{aligned}
&x^{'} = R_{11} x + R_{12} y\\
&y^{'} = R_{21} x + R_{22} y
\end{aligned}
$$

We can get the rotation matrix like this:

``` R acc=pca
R <- solve(r$rotation);
dr <- d %>% mutate(xp = R[1,1]*x + R[1,2]*y,
                   yp = R[2,1]*x + R[2,2]*y) %>%
    select(-x,-y) %>% rename(x=xp, y=yp);

ggmd(ggplot(dr,aes(x,y)) + geom_point() + coord_fixed());

```

This should drive the point home: At its most basic level, principal
component analysis *finds a rotation* in the space of the data such that
successively decreasing axes of variation are aligned with the axis of
the coordinate system.

### Interactive: Covariance and PCA geometry

::point_cloud_interactive:interactively::

The utility of PCA is the assumption that many of the small axes of
variation derive from *noise* in the system and can be neglected.

Let's apply this to our voltage traces. First we need to widen our
dataset and turn it into a matrix for PCA.

``` R acc=pca
library(tidyr);

voltages <- pivot_wider(data %>%
                       arrange(time),
                       id_cols="trial",
                       names_from="time",
                       values_from=V,
                       names_sort=FALSE) %>%
    select(-trial) %>% as.matrix();
## Convert matrix to long-form tibble and plot heatmap
vol_df <- as_tibble(voltages) %>%
  mutate(row = row_number()) %>%
  pivot_longer(cols = -row, names_to = "col", values_to = "value") %>%
  mutate(col = suppressWarnings(as.numeric(gsub("^[^0-9]*", "", col))))
ggmd(ggplot(vol_df, aes(x = col, y = row, fill = value)) +
       geom_raster() +
       scale_y_reverse() +
       coord_fixed() +
       scale_fill_viridis_c(option = "C") +
       labs(x = "Time", y = "Trial", fill = "V"));

```

Now that our data is in shape, let's find the PCs.

``` R acc=pca
results <- prcomp(voltages);
## Heatmap of rotated data (scores)
rx <- results$x
rx_df <- as_tibble(rx) %>%
  mutate(row = row_number()) %>%
  pivot_longer(cols = -row, names_to = "pc", values_to = "value") %>%
  mutate(pc = suppressWarnings(as.numeric(gsub("^[^0-9]*", "", pc))))
ggmd(ggplot(rx_df, aes(x = pc, y = row, fill = value)) +
       geom_raster() +
       scale_y_reverse() +
       coord_fixed() +
       scale_fill_viridis_c(option = "C") +
       labs(x = "PC", y = "Row", fill = "Score"));
summary(results);
```

Great - so what do we do with the results?

Recall: the resulting vectors (`results$x`) are the rotated data. We
expect that as we choose larger and larger dimensions by index, the
variation in those components is smaller and smaller. One thing we can do
is just chop off all but a few components.

``` R acc=pca
ggmd(ggplot(results$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2)) +
    geom_point());
```

There look like there might be clusters here. With very high dimensional
data sets it's hard to appreciate what these low dimensional projections
might mean without making additional plots.

If we have labels on our data this would be a time to use them, but we
don't have any. We can cook some up though. Let's just count spikes.

``` R acc=pca
spikes <- data %>% group_by(trial) %>% filter(V >= 0 & lag(V) < 0) %>% ungroup();
ggmd(ggplot(spikes, aes(time, trial)) + geom_point(shape="|"))
```

This is a so-called "rastergram" - trials on the y axis, spike times on
the x axis. Let's just count spikes.

``` R acc=pca
spike_counts <- spikes %>% group_by(trial) %>% tally() %>%
    arrange(trial) %>% mutate(tritile=ntile(n, 3))
ggmd(ggplot(spike_counts, aes(n)) + geom_histogram())
```

``` R acc=pca

```

And now we can label our projection by spike count, which may reveal
something.

``` R acc=pca
data_2d <- results$x %>% as_tibble() %>% select(PC1, PC2);
data_2d$spike_count <- spike_counts$n;
data_2d$tritile <- spike_counts$tritile;
ggmd(ggplot(data_2d, aes(PC1,PC2)) + geom_point(aes(color=factor(tritile)),alpha=0.5));
```

Another method we might try is subdividing the 2d data and plotting the
voltage traces (this works for this example because the voltage traces
are intelligible as time series).

``` R acc=pca
ggmd(ggplot(data_2d, aes(PC1,PC2)) + geom_point(aes(color=factor(spike_count))) +
    geom_rect(inherit.aes = FALSE, data=tibble(
                  xmin=c(-1, 1),
                  ymin=c(-1,-1),
                  xmax=c( 0, 3),
                  ymax=c( 1, 1)),
              mapping=aes(xmin=xmin, ymin=ymin,
                          xmax=xmax, ymax=ymax),
              fill="blue",
              alpha=0.25));
```

``` R acc=pca
data_2d$trial <- seq(nrow(data_2d));
s1 <- data_2d %>% filter(PC1 >= -1 & PC1 <= 0 &
                         PC2 >= -1 & PC2 <= 1) %>% mutate(label="Box 1");
s2 <- data_2d %>% filter(PC1 >= 1 & PC1 <= 3 &
                         PC2 >= -1 & PC2 <= 1) %>% mutate(label="Box 2");

s <- rbind(s1 %>% head(10),s2 %>% head(10));

traces_ex <- data %>% inner_join(s, by="trial");

ggmd(ggplot(traces_ex,
       aes(time, V)) + geom_line(aes(color=factor(label)),alpha=0.5));

```

Believe it or not, this plot is actually pretty informative if you know
what to look for. After a neuron spikes it has a brief refractory period
during which it cannot spike again. Physiologically this is because the
membrane is depolarized by the ion channels which open lower the voltage
back down to near the resting potential.

A final thing we can do with principal components is zero the smaller
ones and rotate back into the actual space of the data. This should
eliminate the noisy part of the variation subject to all the
interpretational difficulties associated with PCA.

Let's keep the first 500 components.

``` R acc=pca save_state=pca_lecture

r <- results$rotation;
rotated <- results$x;
rotated[,500:1000] <- 0;

less_noisy <- do.call(rbind, Map(function(trial){
    v <- rotated[trial,];
    t(r %*% v);
}, 1:1500));

prep <- less_noisy %>% as_tibble() %>%
    mutate(trial=seq(nrow(.))) %>%
    pivot_longer(cols=`0`:`1000`) %>%
    group_by(trial) %>%
    mutate(time=seq(1000)) %>%
    ungroup() %>%
    filter(trial %in% sample(1:1500, 10));

ggmd(ggplot(prep,aes(time,value)) + geom_line(aes(color=factor(trial))));
```

In this case it's not that useful of a procedure: our data really is all
about those spike times and the PCs don't do a good job of capturing the
results. Plus there is the matter of:


Next: ::04_scaling-and-centering:Scaling and Centering::
