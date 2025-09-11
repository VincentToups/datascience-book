# Examples

Let's build some better data sets to experiment with. The first data set
is some simulated voltage traces where we have three different time
varying stimuli:

``` R acc=examples load_state=pca_limits

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

``` R acc=examples
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

``` R acc=examples
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

``` R acc=examples
results <- prcomp(bad_data %>% select(x,y) %>% as.matrix(), center=T, scale=T);
ggmd(ggplot(results$x %>% as_tibble(), aes(PC1,PC2)) + geom_point(aes(color=factor(bad_data$label))))
```

Note that if we were to throw away the second dimension in this case and
look just at the density:

``` R acc=examples save_state=examples
ggmd(ggplot(results$x %>% as_tibble(), aes(PC1)) + geom_density(aes(fill=factor(bad_data$label))))
```

Arguably the dimensionality reduction made this data set harder to
understand!

Rather than run a million different methods, let's check out an approach
emblematic of advanced approaches:


Next: ::09_t-sne:T-SNE::
