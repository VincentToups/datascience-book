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

``` R acc=sim
library(deSolve)

fhng <- function(current){
  function(t, y, p){
    V <- y[[1]]; R <- y[[2]];
    list(c(
      10*(V - V*V*V - 2*R + current(t)),
      0.1*(-R + 1.25*V + 1.5)
    ))
  }
}

make_current <- function(values, t_max){
  n <- length(values)
  function(t){
    if (t <= 0) {
      values[1]
    } else if (t >= n) {
      values[n]
    } else {
      nt <- n*t/t_max + 1
      i_low <- max(1, floor(nt))
      i_high <- min(n, ceiling(nt))
      interp <- 1 - (nt - i_low)
      values[i_low]*interp + values[i_high]*(1 - interp)
    }
  }
}
```

These functions will let us build up a simulation.

``` R acc=sim
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

``` R acc=sim save_state=sim
cc <- make_current(0.25 + stimulus*2.5, 1000)
f <- fhng(current = cc)
ic <- c(-1.07386247, 0.1642691)
r <- ode(ic, times = seq(from = 0, to = 1000, length.out = 10000), func = f) %>%
  as.matrix() %>%
  as_tibble() %>% rename(V = `1`, R = `2`) %>%
  mutate(across(everything(), as.numeric))
ggmd(ggplot(r, aes(time, V)) + geom_line())
```

We want to do maybe 500 trials with some noise.

``` R acc=sim save_state=sim
data <-
  if (file.exists("simcache_book.csv")){
    read_csv("simcache.csv")
  } else {
    n_trials <- 1500
    data <- do.call(rbind, Map(function(trial){
      cat(sprintf("Trial %d\n",trial))
      cat(sprintf("Trial %d\n", trial))
      cc <- make_current(0.27 + stimulus*2.5 + dumbsmooth(rnorm(length(stimulus))*0.3, 50), 1000)
      f <- fhng(current = cc)
      ic <- c(-1.07386247, 0.1642691)
      ode(ic, times = seq(from = 0, to = 1000, length.out = 1000), func = f) %>%
        as.matrix() %>%
        as_tibble() %>% rename(V = `1`, R = `2`) %>%
        mutate(across(everything(), as.numeric)) %>%
        mutate(trial = trial)
    }, seq(1, n_trials)))
    data %>% write_csv(file = "simcache_book.csv")
    data
  }
ggmd(ggplot(data %>% filter(trial <= 10), aes(time, V)) +
  geom_line(aes(color = factor(trial))))
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

::interactive:This interactive demo helps make this data more interesting.::


Next: ::02_dimensionality-reduction:Dimensionality Reduction::
