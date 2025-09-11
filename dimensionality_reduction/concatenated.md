# Dimensionality Reduction

Real life story: I studied neuronal data for my graduate research. If
you've never thought about this before, consider repeating an experiment
over and over and measuring when a neuron "spikes" (its membrane
potential exceeds -70 mv, for instance).

Because of the noisy character of the brain, these spikes constitute the
only reliable means for neurons which are far from one another to
transmit information. When a voltage spike arrives at a synapse to
another neuron it causes the neuron's membrane potential to increase or
decrease, and thus affects the subsequent spike timing.

Permit me a trip down memory lane. A good model of a spiking neuron is
the FitzHugh-Nagumo equations:

$$
\begin{aligned}
&\frac{dV}{dt} = 10(V-V^3-R+I_{input})\\
&\frac{dR}{dt} = 0.8(-R + 1.25V + 1.5)
\end{aligned}
$$

This is out of scope, but we can integrate differential equations quite
simply in R using its `ode` function. First we write the function which
gives the derivative.

```R
library(deSolve);
fhng <- function(current){
    function(t,y,p){
        V <- y[[1]];
        R <- y[[2]];
        list(c(10*(V - V*V*V - 2*R + current(t)),
               0.1*(-R + 1.25*V + 1.5)));
    }
}
make_current <- function(values,t_max){
    n <- length(values);
    function(t){
        if(t<=0) {
            values[1];
        } else if (t >= n) {
            values[n];
        } else {            
            nt <- n*t/t_max + 1;
            i_low <- max(1,floor(nt));
            i_high <- min(n,ceiling(nt));
            interp <- 1-(nt-i_low);
            values[i_low]*interp + values[i_high]*(1-interp);
        }
    }
}
```

These functions will let us build up a simulation.

```R
library(tidyverse);
dumbsmooth1 <- function(a){
    n <- length(a);
    r <- c(a[2:n],a[n]);
    l <- c(a[1], a[1:(n-1)]);
    (a + l + r)/3;
}
dumbsmooth <- function(a, n){
    for(i in seq(n)){
        a <- dumbsmooth1(a);
    }
    a
}
stimulus <- runif(1000);
stimulus <- dumbsmooth(stimulus,50);
ggmd(ggplot(tibble(x=seq(length(stimulus)), y=stimulus),aes(x,y)) + geom_line());

```

```R
library(deSolve);

cc <- make_current(0.25+stimulus*2.5, 1000);

f <- fhng(current=cc);
ic <- c(-1.07386247, 0.1642691);
r <- ode(ic, times=seq(from=0,to=1000,length.out=10000), func=f) %>%
    as.matrix() %>%
    as_tibble() %>% rename(V=`1`, R=`2`) %>%
    mutate(across(everything(), as.numeric));

ggmd(ggplot(r, aes(time,V)) + geom_line());

```

We want to do maybe 500 trials with some noise.

```R

data <-
    if(file.exists("simcache.csv")){
        read_csv("simcache.csv");
    } else {
        n_trials <- 1500;
        data <- do.call(rbind, Map(function(trial){
            cc <- make_current(0.27+stimulus*2.5 + dumbsmooth(rnorm(length(stimulus))*0.3, 50), 1000);
            f <- fhng(current=cc);
            ic <- c(-1.07386247, 0.1642691);
            r <- ode(ic, times=seq(from=0,to=1000,length.out=1000), func=f) %>%
                as.matrix() %>%
                as_tibble() %>% rename(V=`1`, R=`2`) %>%
                mutate(across(everything(), as.numeric)) %>%
                mutate(trial=trial);
        }, seq(1:n_trials)));
        data %>% write_csv(file="simcache.csv");
        data    
    }
ggmd(ggplot(data %>% filter(trial <= 10),aes(time, V)) + geom_line(aes(color=factor(trial))));

```

For a moment let's meditate on these data. We have stored our data in a
"tidy" format but each "trial" could also be considered an observation
in a 1000 dimensional space (there are 1000 time steps in each run). But
the data themselves hardly fill that 1000 dimensional space (how could
they?).

In other words: our data is characterized by a much smaller number of
degrees of freedom than the 1000 with which we use to plot it. Is there
a way for us to produce a lower dimensional representation which
captures the important character of the data?


Next: ::dimensionality_reduction/02_dimensionality-reduction:Dimensionality Reduction::


# Dimensionality Reduction

These are precisely the circumstances in which dimensionality
reduction is appropriate. We have a data set which is encoded in a
highly redundant way and we want a lower dimensional representation so
that we can either do some subsequent modeling with it or otherwise
understand its nature.

Meditate for a moment on this fact: the universe is *much much much*
simpler than its apparent degrees of freedom suggest it could be. An
absolutely central question in contemporary cosmology is *why* is the
universe so simple? Why is the entropy of the past so much lower than
that of the future when in general we expect entropy to be high if time
is involved?

![Too simple, Jerry!](images/CMB_Timeline300_no_WMAP.jpg)

There are many ways to approach this problem but the most common one is:


Next: ::dimensionality_reduction/03_principal-component-analysis:Principal Component Analysis::

## Principal Component Analysis

One of the reasons that PCA is so common is that it is very easy to
understand graphically. Principal Component Analysis is the process of
finding a rotation in the state space which aligns the axes of the
coordinate system with the directions of decreasing variation in the data.

Consider the following dataset:

```R
d <- tibble(x=rnorm(1000,0,1),y=rnorm(1000,0,0.25)) %>%
    mutate(x=cos(pi/8)*x - sin(pi/8)*y,
           y=sin(pi/8)*x + cos(pi/8)*y);
ggmd(ggplot(d, aes(x,y)) + geom_point() + coord_fixed());
```

Even if you couldn't see how I generated the data you can identify that
it has two primary axes of variation:

```R
arrow_data <- tibble(x=c(0,0),y=c(0,0),
                     xend=c(cos(pi/8),
                            cos(pi/8 + pi/2)*1.0),
                     yend=c(sin(pi/8),
                            sin(pi/8 + pi/2)*1.0));
ggmd(ggplot(d, aes(x,y)) +
    geom_point(alpha=0.5) + 
    geom_segment(data=arrow_data,aes(x=x,y=y,xend=xend,yend=yend),
                 color="red",
                 arrow=arrow()) +
    coord_fixed());
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

```R
r <- prcomp(d);
r
```

And

```R
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

```R
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

The utility of PCA is the assumption that many of the small axes of
variation derive from *noise* in the system and can be neglected.

Let's apply this to our voltage traces. First we need to widen our
dataset and turn it into a matrix for PCA.

```R
library(tidyr);

voltages <- pivot_wider(data %>%
                       arrange(time),
                       id_cols="trial",
                       names_from="time",
                       values_from=V,
                       names_sort=FALSE) %>%
    select(-trial) %>% as.matrix();
library(matlab);
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

```R
results <- prcomp(voltages);
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

```R
ggmd(ggplot(results$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2)) +
    geom_point());
```

There look like there might be clusters here. With very high dimensional
data sets it's hard to appreciate what these low dimensional projections
might mean without making additional plots.

If we have labels on our data this would be a time to use them, but we
don't have any. We can cook some up though. Let's just count spikes.

```R
spikes <- data %>% group_by(trial) %>% filter(V >= 0 & lag(V) < 0) %>% ungroup();
ggmd(ggplot(spikes, aes(time, trial)) + geom_point(shape="|"))
```

This is a so-called "rastergram" - trials on the y axis, spike times on
the x axis. Let's just count spikes.

```R
spike_counts <- spikes %>% group_by(trial) %>% tally() %>%
    arrange(trial) %>% mutate(tritile=ntile(n, 3))
ggmd(ggplot(spike_counts, aes(n)) + geom_histogram())
```

```R

```

And now we can label our projection by spike count, which may reveal
something.

```R
data_2d <- results$x %>% as_tibble() %>% select(PC1, PC2);
data_2d$spike_count <- spike_counts$n;
data_2d$tritile <- spike_counts$tritile;
ggmd(ggplot(data_2d, aes(PC1,PC2)) + geom_point(aes(color=factor(tritile)),alpha=0.5));
```

Another method we might try is subdividing the 2d data and plotting the
voltage traces (this works for this example because the voltage traces
are intelligible as time series).

```R
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

```R
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

```R

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


Next: ::dimensionality_reduction/04_scaling-and-centering:Scaling and Centering::

# Scaling and Centering

In general you should scale and center your data before doing a PCA. In
particular, centering makes sense, since a PCA is a rotation and you
usually want to rotate around the centroid of the data. But in some
cases it can be hard to justify.

Consider our data. To scale and center it is to apply a scale/center
operation to each time point. This doesn't seem to make much physical
sense.

(In the weeds: in this case the right thing to do might be to center the
results on the equilibrium position of the differential equations which
produced the data or the resting potential of the cell and normalize all
"columns" by the maximum voltage range).

```R
scaled <- data %>% group_by(time) %>% mutate(V = (V - mean(V))/sd(V));
ggmd(ggplot(scaled %>% filter(trial %in% seq(10)), aes(time, V)) + geom_line(aes(color=factor(trial))));
```

Whether this makes sense or not depends a lot on your situation. Scaling
and centering this data has the effect of minimizing the influence of
places where spikes always happen which almost certainly improves the
results of anything which is trying to discriminate between these
trials. On the other hand, it makes the data much harder to appreciate
visually.

Scaling in particular is a challenging idea. In some situations you have
no idea whether one variable is more important than another. In these
situations it makes sense to scale them all to have the same variance.
But in other situations the variation in one variable really is more
important, or there is some other physical relation that sets a natural
scale between dimensions (for example, two dimensions might literally be
a length). In these cases you may want to scale them together or not
scale them at all.

Most of the time scaling and centering is right.


Next: ::dimensionality_reduction/05_where-pca-can-t-possibly-work:Where PCA Can't Possibly Work:::

# Where PCA Can't Possibly Work:

Consider:

```R
bad_data <- tibble(r = sample(c(2,5),size=400,replace=TRUE) + rnorm(400,0,0.4),
            theta = runif(400,0,2*pi)) %>%
    transmute(x=r*cos(theta),
              y=r*sin(theta));
ggmd(ggplot(bad_data, aes(x,y)) + geom_point() + coord_fixed());
```

This data set clearly only has one interesting degree of variation: the
radius. But no rotation will separate these two axes. Indeed, PCA on
this data set is the identity operation. You will need more
sophisticated methods to deal with data like this.

Or you can apply some elbow grease: in this case, if you can manually
calculate the radius then you can just throw away the angular part.
We'll see something similar to this in the lecture on classification.

(NB: This question of understanding how these kinds of cyclic dimensions
work and can be described is also central to physics in a variety of
ways. In GR we tackle this kind of thing by very carefully considering
only properties which are describable on local patches of curved
dimensions and which are "patch parameterization independent". In
Quantum Gravity we seek alternative observables from the angle which are
continuous and smooth (the sin and the cosine of the angle)).


Next: ::dimensionality_reduction/06_vector-spaces:Vector Spaces::

# Vector Spaces

PCA finds a rotation which aligns axes of variation with the axes of our
coordinate system. This rotation is then applied to each element of our
data set individually. The only mathematical objects you can rotate are
vectors.

A vector space is a set V along with a field F such that the following
are true:

$$
\begin{aligned}
&u, v, w \in V\\
&a, b \in F\\ 
&u + (v + w) = (u + v) + w\\
&u + v = v + w\\
&v + 0 = v\\
&a(bv) = (ab)v\\
&1v = v\\
&a(u+v) = au + av\\
&(a+b)v = av + bb
\end{aligned}
$$

Any combination of a set and a field which satisfies these axioms is a
vector space. But these are quite powerful and thus restrictive. Just
for instance, we must be able to add two vectors to get another.
Consider a simple data set consisting of pairs of weights and heights of
human beings. What does it mean to *add* two elements of this set?

What about to multiply an element by 10. By 1000?


Next: ::dimensionality_reduction/07_manifolds:Manifolds::

# Manifolds

In the case of our pairs `(W,H)` some operations simply don't make
sense. You can understand why we might be able to sometimes get away
with thinking of this data as a vector space if you consider *local*
transformations only. In the vicinity of a particular data point a small
deviation in weight or height tends to produce another physically
plausible weight and height.

Thus, statistically and locally, weights and heights resemble a vector
space. It's really miraculous that PCA is so generally useful given that
very few data sets have any good reason to satisfy all the vector space
axioms.

A set which has the property that it resembles a vector space locally is
called a manifold (speaking informally).

Fun fact: position in space, the sort of prototypical vector space, is
only approximately true. General Relativity tells us that the ability to
describe events as things pointed to by vectors is only a local
phenomenon. In general, there is no vector space structure relating
events.

In any case, more sophisticated methods of dimensionality reduction
often try to learn or otherwise approximate the *manifold* on which the
data lie. This is a deep assumption but there isn't much we can hope to
accomplish for high dimensional data without it.


Next: ::dimensionality_reduction/08_examples:Examples::

# Examples

Let's build some better data sets to experiment with. The first data set
is some simulated voltage traces where we have three different time
varying stimuli:

```R

sim_fitznagumo <- function(t_max=250,
                           n_trials=1,
                           stimulus=c(0,0,0),
                           ic=c(-1.031463, 0.1557358)){
    data <- do.call(rbind, Map(function(trial){
        cc <- make_current(0.27+stimulus*2.5 + dumbsmooth(rnorm(length(stimulus))*0.35, 50), t_max);
        f <- fhng(current=cc);
        r <- ode(ic + 0.001*rnorm(2), times=seq(from=0,to=t_max,length.out=t_max), func=f) %>%
            as.matrix() %>%
            as_tibble() %>% rename(V=`1`, R=`2`) %>%
            mutate(across(everything(), as.numeric)) %>%
            mutate(trial=trial);
    }, seq(1:n_trials)))
    data
}
make_stim <- function(n=1000, s=50){
    stimulus <- runif(n);
    stimulus <- dumbsmooth(stimulus,s);
    stimulus
}

fn_data <- if(file.exists("sim2cache.csv")){
    read_csv("sim2cache.csv");
} else {
    ds = rbind(sim_fitznagumo(n_trials=300, stimulus=make_stim(250,s=20)) %>%
             mutate(label=1),
             sim_fitznagumo(n_trials=300, stimulus=make_stim(250,s=20)) %>%
             mutate(label=2),
             sim_fitznagumo(n_trials=300, stimulus=make_stim(250,s=20)) %>%
             mutate(label=3));
    write_csv(ds, "sim2cache.csv");
    ds
}

ggmd(ggplot(fn_data, aes(time, V + label*3)) +
    geom_line(aes(color=factor(label), group=sprintf("%d:%d",label, trial))))

```

The second is a more intentionally pathological case:

```R
bad_data <- tibble(r = 5 + rnorm(800,0,0.1),
                   theta = c(rnorm(200,pi/2,0.2),
                             rnorm(200,2*pi/2, 0.2),
                             rnorm(200,3*pi/2, 0.2),
                             rnorm(200,0, 0.2))) %>%
    transmute(x=r*cos(theta),
              y=r*sin(theta),
              label=c(rep(1,200),
                      rep(2,200),
                      rep(3,200),
                      rep(4,200)));
ggmd(ggplot(bad_data, aes(x,y)) + geom_point(aes(color=factor(label))) + coord_fixed())
```

Our process is always the same:

1.  do a dimensionality reduction
2.  look at the projection in 2d

```R
fn_datav <- pivot_wider(fn_data %>%
                      arrange(time) %>% filter(time>1),
                      id_cols=c("trial","label"),
                      names_from="time",
                      values_from="V",
                      names_sort=FALSE);
results <- prcomp(fn_datav %>% select(-trial,-label) %>% as.matrix(),
                  center=T, scale=T);
ggmd(ggplot(results$x %>% as_tibble(), aes(PC1,PC2)) + geom_point(aes(color=factor(fn_datav$label))))
```

Remarkably good!

The pathological data:

```R
results <- prcomp(bad_data %>% select(x,y) %>% as.matrix(), center=T, scale=T);
ggmd(ggplot(results$x %>% as_tibble(), aes(PC1,PC2)) + geom_point(aes(color=factor(bad_data$label))))
```

Note that if we were to throw away the second dimension in this case and
look just at the density:

```R
ggmd(ggplot(results$x %>% as_tibble(), aes(PC1)) + geom_density(aes(fill=factor(bad_data$label))))
```

Arguably the dimensionality reduction made this data set harder to
understand!

Rather than run a million different methods, let's check out an approach
emblematic of advanced approaches:


Next: ::dimensionality_reduction/09_t-sne:T-SNE::

# T-SNE

T-SNE is an approach based on the idea that the important thing to model
in the reduced data set is something like the probability of two points
being neighbors. In high density areas points must be closer to one
another to count as nearby, whereas in low density areas they can be
further apart.

It then seeks a map into a lower dimensional space which preserves these
probabilities without as much freedom to adjust things for density. So
it accomplishes both a dimensionality reduction and a simplification of
the distribution of points.

```R
library(tidyverse);
library(reticulate);

use_python("/usr/bin/python3");
manifold <- import("sklearn.manifold");

tsne_instance <- manifold$TSNE(n_components=as.integer(2));
results <- tsne_instance$fit_transform(fn_datav %>% select(-trial, -label) %>% as.matrix()) %>%
    as_tibble();

ggmd(ggplot(results, aes(V1, V2)) + geom_point(aes(color=factor(fn_datav$label))));

```

The smaller data set is more illustrative:

```R

tsne_instance <- manifold$TSNE(n_components=as.integer(1));

results <- tsne_instance$fit_transform(bad_data %>% select(x,y) %>% as.matrix()) %>%
    as_tibble();
ggmd(ggplot(results, aes(V1)) + geom_density(aes(fill=factor(bad_data$label)),position="dodge"));

```


Next: ::dimensionality_reduction/10_important-contrasts-between-tsne-and-pca:Important Contrasts Between TSNE and PCA::

# Important Contrasts Between TSNE and PCA

One thing to consider is that the result of PCA is a rotation matrix
which may be applied to any vector whatsoever of the appropriate
dimensionality. In particular, if you believe your original dataset is
statistically representative then the rotation matrix can reasonably be
applied to any new vectors you might have handed to you.

For example, it turns out to be the case that neural responses of the
sort we simulated in this lecture are conserved even across different
animals with similar physiology. That is, if we show two human beings
the same 60 second section of John Wick (and have them fix their eyes at
the center of the screen) then similar pyramidal cells in the visual
cortex will have similar firing patterns and membrane potentials.

Thus, if we have measured these voltages and found a useful set of
principal components, we might theoretically be able to re-use them in
later brain computer interfaces.

On the other hand, TSNE optimizes the configuration of representative
points in the training data. It doesn't provide a formula or method for
applying the resulting solution to new data, and so its utility for
future modeling is limited.

Rule of Thumb: TSNE for visualization, PCA for pre-treatment.


Next: ::dimensionality_reduction/11_metric-spaces-and-dimensionality-reduction:Metric Spaces and Dimensionality Reduction::

# Metric Spaces and Dimensionality Reduction

A metric space is just a set with a distance function that satisfies a
triangle inequality. This is substantially less structure than a vector
space. Many of the datasets we work with in practice have a meaningful
metric but no real meaningful vector space embedding.

For example:

```R
library(tidyverse)
library(reticulate);

use_python("/usr/bin/python3");
manifold <- import("sklearn.manifold");


names <-
    rbind(read_csv("source_data/us.txt", col_names="name") %>% sample_n(250) %>% mutate(country="US"),
          read_csv("source_data/uk.txt", col_names="name") %>% sample_n(250) %>% mutate(country="UK"),
          read_csv("source_data/fr.txt", col_names="name") %>% sample_n(250) %>% mutate(country="FR"));
mddf(names)

```

Contrary to some datasets which we cavalierly represent as lists of
numbers, it's clear that there is no meaning whatsoever to the question
of what "Smith" + "Herve" is supposed to be. But we can define a metric,
the edit distance:

```R
distances_h <- adist(head(names$name));
distances <- adist(names$name);
mddf(as.data.frame(distances_h))
```

Some dimensionality reduction methods work directly on a metric. MDS is
one such method.

It works by finding a set of coordinates for each point given nothing
but a metric space. Obviously the result is only as good as the
assumption that the elements of the set that generated the distances are
themselves a vector space.

```R

Next: ::dimensionality_reduction/12_take-a-100x100-subset-of-distances:Take a 100x100 subset of distances::

# Take a 100x100 subset of distances

Next: ::dimensionality_reduction/13_randomly-sample-100-rows-and-columns-from-distances:Randomly sample 100 rows and columns from distances::

# Randomly sample 100 rows and columns from distances
sample_indices <- sample(nrow(distances), 750)
subset_distances <- distances[sample_indices, sample_indices]



Next: ::dimensionality_reduction/14_write-subset-to-csv:Write subset to CSV::

# Write subset to CSV
write.csv(as.matrix(subset_distances), file = "subset_distances.csv", row.names = FALSE)

system("python3 do-tsne.py")


Next: ::dimensionality_reduction/15_read-results-back-into-r:Read results back into R::

# Read results back into R
results <- read.csv("results.csv") %>% as_tibble() %>%
    mutate(country=names$country[sample_indices])

```

```R
ggmd(ggplot(results,aes(X0, X1)) + geom_point(aes(color=country)));

```

```R
ggmd(ggplot(results,aes(X0)) + geom_density(aes(color=country)));
ggmd(ggplot(results,aes(X1)) + geom_density(aes(color=country)));


```

As promised, this is an example where the labels aren't easily separated
by the embedding.


Next: ::dimensionality_reduction/16_concluding-notes:Concluding Notes::

# Concluding Notes

A lot of data comes in a redundant form: we have many columns but they
contain lots of correlations, for instance. Or the data is very high
dimensional but occupies a much lower dimensional manifold within that
high dimensional space. Or the data has no natural representation as a
space at all, but a distance function is available that can tell you how
similar data points are.

Dimensionality reduction is the unsupervised attempt to remove that
redundancy either for the purposes of visualization or pre-treatment for
a regression.

We discussed a few methods here. There are many. A great resource for a
survey is sklearn's Manifold learning documentation. Things we should
keep in mind:

1.  what assumptions about the space are made for a given method?
2.  is the method deterministic or not?
3.  Can we easily interpret the results?
4.  Does the method allow us to project new data down to lower
    dimensions?

A final note: "feature engineering" is what people used to do before
unsupervised methods were computationally convenient or readily
available. Sometimes an ounce of feature engineering can be worth a
pound of unsupervised dimensionality reduction. For example, we'd
probably do a lot better identifying French names by looking for accent
marks than by trying a manifold embedding!

```R

Next: ::dimensionality_reduction/17_function-to-coerce-string-to-ascii-and-count-differences:Function to coerce string to ASCII and count differences::

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

```R

Next: ::dimensionality_reduction/18_function-to-calculate-victor-purpura-distance-between-two-spike-trains:Function to calculate Victor-Purpura distance between two spike trains::

# Function to calculate Victor-Purpura distance between two spike trains
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


Next: ::dimensionality_reduction/19_function-to-calculate-pairwise-victor-purpura-distances:Function to calculate pairwise Victor-Purpura distances::

# Function to calculate pairwise Victor-Purpura distances
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


Next: ::dimensionality_reduction/20_example-usage:Example Usage::

# Example Usage

Next: ::dimensionality_reduction/21_sample-data-frame-with-spike-times-and-trials:Sample data frame with spike times and trials::

# Sample data frame with spike times and trials
df <- spikes;
q <- 0.2;



Next: ::dimensionality_reduction/22_calculate-pairwise-distances:Calculate pairwise distances::

# Calculate pairwise distances
distance_matrix <- pairwise_victor_purpura(df, q)

dm_df <- as_tibble(as.data.frame(distance_matrix)) %>%
  mutate(row = row_number()) %>%
  pivot_longer(cols = -row, names_to = "col", values_to = "value") %>%
  mutate(col = suppressWarnings(as.numeric(gsub("^[^0-9]*", "", col))))
ggmd(ggplot(dm_df, aes(x = col, y = row, fill = value)) +
       geom_raster() +
       scale_y_reverse() +
       coord_fixed() +
       scale_fill_viridis_c(option = "C") +
       labs(x = "Col", y = "Row", fill = "Dist"))
```

```R

Next: ::dimensionality_reduction/23_load-necessary-libraries:Load necessary libraries::

# Load necessary libraries
library(reticulate)


Next: ::dimensionality_reduction/24_install-the-scikit-learn-library-via-reticulate-if-not-already-installed:Install the 'scikit-learn' library via reticulate if not already installed::

# Install the 'scikit-learn' library via reticulate if not already installed

Next: ::dimensionality_reduction/25_py-install-scikit-learn-uncomment-this-if-scikit-learn-is-not-installed:py_install("scikit-learn")  # Uncomment this if scikit-learn is not installed::

# py_install("scikit-learn")  # Uncomment this if scikit-learn is not installed


Next: ::dimensionality_reduction/26_function-to-perform-t-sne-using-the-reticulate-package:Function to perform t-SNE using the reticulate package::

# Function to perform t-SNE using the reticulate package
perform_tsne <- function(distance_matrix, n_components = 2, perplexity = 30, random_state = 42) {
  # Import Python's scikit-learn package
  sklearn <- import("sklearn.manifold")

  # Create the t-SNE model
  tsne <- sklearn$TSNE(
    n_components = as.integer(n_components), 
    metric = "precomputed", 
    perplexity = perplexity, 
    random_state = as.integer(random_state),
    init="random"
  )
  
  # Perform t-SNE on the distance matrix
  tsne_results <- tsne$fit_transform(distance_matrix)
  
  return(as.data.frame(tsne_results))
}


Next: ::dimensionality_reduction/27_perform-t-sne-on-the-victor-purpura-distance-matrix:Perform t-SNE on the Victor-Purpura distance matrix::

# Perform t-SNE on the Victor-Purpura distance matrix
tsne_results <- perform_tsne(as.matrix(distance_matrix))


tsne_results <- cbind(tsne_results) %>% as_tibble();

ggmd(ggplot(tsne_results, aes(V1, V2)) + geom_point(aes(color=label)))


Next: ::dimensionality_reduction/28_optionally-plot-the-results:Optionally, plot the results::

# Optionally, plot the results
plot(tsne_results$V1, tsne_results$V2, xlab = "Component 1", ylab = "Component 2", 
     main = "t-SNE on Victor-Purpura Distance Matrix", pch = 19)

```
