Interactive Staging
===================

Consider our code:

``` R file=vis_v2.R

```
Let's work on a few things.

First of all, we want to rotate the x-tick marks so they are legible.
Then we want to fix these missing rectangles somehow.
Next, we probably want to scale each column for contrast.
Finally, perhaps we want to do some PCA and plot the low-D data with labels.

``` R
library(tidyverse)


state_name_map <- read_csv("source_data/state_names.csv")

sightings <- read_csv("source_data/tidied_deduplicated.csv") %>%
  inner_join(state_name_map, by="state")

data <- read_csv("source_data/us_state_population_2024.csv") %>%
  transmute(name=state, population=population) %>%
  inner_join(sightings, by="name") %>%
  select(state, shape, population)

data <- data %>%
  inner_join(data %>% group_by(state) %>% tally(name="sightings_total"),
             by="state")

shape_pcts <- data %>%
  group_by(state, shape, population, sightings_total) %>% tally() %>% ungroup() %>%
  mutate(p=n/sightings_total, log_p=-log(n/sightings_total)) %>% select(-n) 

state_vectors <-
  shape_pcts %>% select(state, shape, p, log_p) %>%
  pivot_wider(id_cols=state, names_from=shape, values_from=p, values_fill=0) %>%
  pivot_longer(changing:cube) %>%
  rename(shape=name, p=value)

ordering <- state_vectors %>%
  group_by(shape) %>%
  summarize(p_avg=mean(p)) %>%
  arrange(desc(p_avg)) %>%
  mutate(x0=1:nrow(.)-0.5,
         xf=1:nrow(.)+0.5)

state_vectors <- state_vectors %>% group_by(shape) %>%
  mutate(p=p/max(p)) %>% ungroup()

state_ordering <- tibble(state=state_name_map$state, ymin=(1:50)-0.5, ymax=(1:50)+0.5)

p <- ggplot(state_vectors %>%
         inner_join(ordering, by="shape") %>%
         inner_join(state_ordering, by="state")) +
  geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
  scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

print(p)

ensure_directory("figures")
ggsave("figures/state_vectors.png")

ggmd(p)

states <- state_vectors %>% pivot_wider(id_cols=state, names_from=shape, values_from=p)
kmr <- kmeans(states %>% select(-state), 5)
pcr <- prcomp(states %>% select(-state))

p <- ggplot(pcr$x %>% as_tibble() %>% mutate(state=states$state), aes(PC1, PC2)) +
  geom_text(aes(label=state))

ggmd(p)
ggsave("figures/state_vectors_pca.png")

state_ordering <- pcr$x %>% as_tibble() %>% select(PC1, PC2) %>%
  mutate(state=states$state) %>% arrange(PC1, PC2) %>%
  mutate(ymin=(1:50)-0.5, ymax=(1:50)+0.5)

p <- ggplot(state_vectors %>%
         inner_join(ordering, by="shape") %>%
         inner_join(state_ordering, by="state")) +
  geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
  scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggmd(p)
ggsave("figures/state_vectors_pc_ordered.png")



```
Now that we have a new version, let's look at the diff.

``` bash capture=true
cp vis_v3.R project/state_vectors.R
cd project
git status
git diff
```
There is no way to do this except by interactive staging.

:student-select:Q; ../students.json::

In class, we will do this live, but here is the transcript of something like it:

```
root@esc:~/bios611/git-in-depth/project# git add -i state_vectors.R 
           staged     unstaged path
  1:    unchanged       +36/-5 state_vectors.R

*** Commands ***
  1: [s]tatus	  2: [u]pdate	  3: [r]evert	  4: [a]dd untracked
  5: [p]atch	  6: [d]iff	  7: [q]uit	  8: [h]elp
What now> 5
           staged     unstaged path
  1:    unchanged       +36/-5 [s]tate_vectors.R
Patch update>> 1
           staged     unstaged path
* 1:    unchanged       +36/-5 [s]tate_vectors.R
Patch update>> 
diff --git a/state_vectors.R b/state_vectors.R
index 3fde576..3d1c275 100644
--- a/state_vectors.R
+++ b/state_vectors.R
@@ -25,8 +25,6 @@ state_vectors <-
   pivot_longer(changing:cube) %>%
   rename(shape=name, p=value)
 
-
-
 ordering <- state_vectors %>%
   group_by(shape) %>%
   summarize(p_avg=mean(p)) %>%
(1/2) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]? n
@@ -34,16 +32,49 @@ ordering <- state_vectors %>%
   mutate(x0=1:nrow(.)-0.5,
          xf=1:nrow(.)+0.5)
 
-state_ordering <- tibble(state=state_name_map$state, ymin=(1:50)-0.5, ymax=(1:50)+0.5)
-
+state_vectors <- state_vectors %>% group_by(shape) %>%
+  mutate(p=p/max(p)) %>% ungroup()
 
+state_ordering <- tibble(state=state_name_map$state, ymin=(1:50)-0.5, ymax=(1:50)+0.5)
 
 p <- ggplot(state_vectors %>%
          inner_join(ordering, by="shape") %>%
          inner_join(state_ordering, by="state")) +
   geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
   scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
-  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state)
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+print(p)
 
 ensure_directory("figures")
 ggsave("figures/state_vectors.png")
+
+ggmd(p)
+
+states <- state_vectors %>% pivot_wider(id_cols=state, names_from=shape, values_from=p)
+kmr <- kmeans(states %>% select(-state), 5)
+pcr <- prcomp(states %>% select(-state))
+
+p <- ggplot(pcr$x %>% as_tibble() %>% mutate(state=states$state), aes(PC1, PC2)) +
+  geom_text(aes(label=state))
+
+ggmd(p)
+ggsave("figures/state_vectors_pca.png")
+
+state_ordering <- pcr$x %>% as_tibble() %>% select(PC1, PC2) %>%
+  mutate(state=states$state) %>% arrange(PC1, PC2) %>%
+  mutate(ymin=(1:50)-0.5, ymax=(1:50)+0.5)
+
+p <- ggplot(state_vectors %>%
+         inner_join(ordering, by="shape") %>%
+         inner_join(state_ordering, by="state")) +
+  geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
+  scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+ggmd(p)
+ggsave("figures/state_vectors_pc_ordered.png")
+
+
(2/2) Stage this hunk [y,n,q,a,d,K,g,/,s,e,?]? s
Split into 4 hunks.
@@ -34,6 +32,6 @@
   mutate(x0=1:nrow(.)-0.5,
          xf=1:nrow(.)+0.5)
 
-state_ordering <- tibble(state=state_name_map$state, ymin=(1:50)-0.5, ymax=(1:50)+0.5)
-
+state_vectors <- state_vectors %>% group_by(shape) %>%
+  mutate(p=p/max(p)) %>% ungroup()
 
(2/5) Stage this hunk [y,n,q,a,d,K,j,J,g,/,e,?]? y
@@ -39,7 +37,8 @@
 
+state_ordering <- tibble(state=state_name_map$state, ymin=(1:50)-0.5, ymax=(1:50)+0.5)
 
 p <- ggplot(state_vectors %>%
          inner_join(ordering, by="shape") %>%
          inner_join(state_ordering, by="state")) +
   geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
   scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
(3/5) Stage this hunk [y,n,q,a,d,K,j,J,g,/,e,?]? y
@@ -40,10 +39,13 @@
 
 p <- ggplot(state_vectors %>%
          inner_join(ordering, by="shape") %>%
          inner_join(state_ordering, by="state")) +
   geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
   scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
-  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state)
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+print(p)
 
 ensure_directory("figures")
 ggsave("figures/state_vectors.png")
(4/5) Stage this hunk [y,n,q,a,d,K,j,J,g,/,e,?]? n
@@ -47,3 +49,32 @@
 
 ensure_directory("figures")
 ggsave("figures/state_vectors.png")
+
+ggmd(p)
+
+states <- state_vectors %>% pivot_wider(id_cols=state, names_from=shape, values_from=p)
+kmr <- kmeans(states %>% select(-state), 5)
+pcr <- prcomp(states %>% select(-state))
+
+p <- ggplot(pcr$x %>% as_tibble() %>% mutate(state=states$state), aes(PC1, PC2)) +
+  geom_text(aes(label=state))
+
+ggmd(p)
+ggsave("figures/state_vectors_pca.png")
+
+state_ordering <- pcr$x %>% as_tibble() %>% select(PC1, PC2) %>%
+  mutate(state=states$state) %>% arrange(PC1, PC2) %>%
+  mutate(ymin=(1:50)-0.5, ymax=(1:50)+0.5)
+
+p <- ggplot(state_vectors %>%
+         inner_join(ordering, by="shape") %>%
+         inner_join(state_ordering, by="state")) +
+  geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
+  scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+ggmd(p)
+ggsave("figures/state_vectors_pc_ordered.png")
+
+
(5/5) Stage this hunk [y,n,q,a,d,K,g,/,e,?]? n

*** Commands ***
  1: [s]tatus	  2: [u]pdate	  3: [r]evert	  4: [a]dd untracked
  5: [p]atch	  6: [d]iff	  7: [q]uit	  8: [h]elp
What now> 
*** Commands ***
  1: [s]tatus	  2: [u]pdate	  3: [r]evert	  4: [a]dd untracked
  5: [p]atch	  6: [d]iff	  7: [q]uit	  8: [h]elp
What now> q
Bye.
root@esc:~/bios611/git-in-depth/project# git commit -m "Modified state_vectors.R to do a column based scaling for contrast."
[main 22de5a9] Modified state_vectors.R to do a column based scaling for contrast.
 1 file changed, 3 insertions(+), 2 deletions(-)
root@esc:~/bios611/git-in-depth/project# git add -i 
           staged     unstaged path
  1:    unchanged       +33/-3 state_vectors.R

*** Commands ***
  1: [s]tatus	  2: [u]pdate	  3: [r]evert	  4: [a]dd untracked
  5: [p]atch	  6: [d]iff	  7: [q]uit	  8: [h]elp
What now> 5
           staged     unstaged path
  1:    unchanged       +33/-3 [s]tate_vectors.R
Patch update>> 1
           staged     unstaged path
* 1:    unchanged       +33/-3 [s]tate_vectors.R
Patch update>> 
diff --git a/state_vectors.R b/state_vectors.R
index ba895b9..3d1c275 100644
--- a/state_vectors.R
+++ b/state_vectors.R
@@ -25,8 +25,6 @@ state_vectors <-
   pivot_longer(changing:cube) %>%
   rename(shape=name, p=value)
 
-
-
 ordering <- state_vectors %>%
   group_by(shape) %>%
   summarize(p_avg=mean(p)) %>%
(1/2) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]? n
@@ -44,7 +42,39 @@ p <- ggplot(state_vectors %>%
          inner_join(state_ordering, by="state")) +
   geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
   scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
-  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state)
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+print(p)
 
 ensure_directory("figures")
 ggsave("figures/state_vectors.png")
+
+ggmd(p)
+
+states <- state_vectors %>% pivot_wider(id_cols=state, names_from=shape, values_from=p)
+kmr <- kmeans(states %>% select(-state), 5)
+pcr <- prcomp(states %>% select(-state))
+
+p <- ggplot(pcr$x %>% as_tibble() %>% mutate(state=states$state), aes(PC1, PC2)) +
+  geom_text(aes(label=state))
+
+ggmd(p)
+ggsave("figures/state_vectors_pca.png")
+
+state_ordering <- pcr$x %>% as_tibble() %>% select(PC1, PC2) %>%
+  mutate(state=states$state) %>% arrange(PC1, PC2) %>%
+  mutate(ymin=(1:50)-0.5, ymax=(1:50)+0.5)
+
+p <- ggplot(state_vectors %>%
+         inner_join(ordering, by="shape") %>%
+         inner_join(state_ordering, by="state")) +
+  geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
+  scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+ggmd(p)
+ggsave("figures/state_vectors_pc_ordered.png")
+
+
(2/2) Stage this hunk [y,n,q,a,d,K,g,/,s,e,?]? s
Split into 2 hunks.
@@ -44,7 +42,10 @@
          inner_join(state_ordering, by="state")) +
   geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
   scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
-  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state)
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+print(p)
 
 ensure_directory("figures")
 ggsave("figures/state_vectors.png")
(2/3) Stage this hunk [y,n,q,a,d,K,j,J,g,/,e,?]? y
@@ -48,3 +49,32 @@
 
 ensure_directory("figures")
 ggsave("figures/state_vectors.png")
+
+ggmd(p)
+
+states <- state_vectors %>% pivot_wider(id_cols=state, names_from=shape, values_from=p)
+kmr <- kmeans(states %>% select(-state), 5)
+pcr <- prcomp(states %>% select(-state))
+
+p <- ggplot(pcr$x %>% as_tibble() %>% mutate(state=states$state), aes(PC1, PC2)) +
+  geom_text(aes(label=state))
+
+ggmd(p)
+ggsave("figures/state_vectors_pca.png")
+
+state_ordering <- pcr$x %>% as_tibble() %>% select(PC1, PC2) %>%
+  mutate(state=states$state) %>% arrange(PC1, PC2) %>%
+  mutate(ymin=(1:50)-0.5, ymax=(1:50)+0.5)
+
+p <- ggplot(state_vectors %>%
+         inner_join(ordering, by="shape") %>%
+         inner_join(state_ordering, by="state")) +
+  geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
+  scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+ggmd(p)
+ggsave("figures/state_vectors_pc_ordered.png")
+
+
(3/3) Stage this hunk [y,n,q,a,d,K,g,/,e,?]? q

*** Commands ***
  1: [s]tatus	  2: [u]pdate	  3: [r]evert	  4: [a]dd untracked
  5: [p]atch	  6: [d]iff	  7: [q]uit	  8: [h]elp
What now> q
Bye.
root@esc:~/bios611/git-in-depth/project# git commit -m "Improved axis tick marks in state_vector_visualization."
[main 0c6939d] Improved axis tick marks in state_vector_visualization.
 1 file changed, 4 insertions(+), 1 deletion(-)
root@esc:~/bios611/git-in-depth/project# git add -i
           staged     unstaged path
  1:    unchanged       +29/-2 state_vectors.R

*** Commands ***
  1: [s]tatus	  2: [u]pdate	  3: [r]evert	  4: [a]dd untracked
  5: [p]atch	  6: [d]iff	  7: [q]uit	  8: [h]elp
What now> 5
           staged     unstaged path
  1:    unchanged       +29/-2 [s]tate_vectors.R
Patch update>> 1
           staged     unstaged path
* 1:    unchanged       +29/-2 [s]tate_vectors.R
Patch update>> 
diff --git a/state_vectors.R b/state_vectors.R
index 2a62c71..3d1c275 100644
--- a/state_vectors.R
+++ b/state_vectors.R
@@ -25,8 +25,6 @@ state_vectors <-
   pivot_longer(changing:cube) %>%
   rename(shape=name, p=value)
 
-
-
 ordering <- state_vectors %>%
   group_by(shape) %>%
   summarize(p_avg=mean(p)) %>%
(1/2) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]? n
@@ -51,3 +49,32 @@ print(p)
 
 ensure_directory("figures")
 ggsave("figures/state_vectors.png")
+
+ggmd(p)
+
+states <- state_vectors %>% pivot_wider(id_cols=state, names_from=shape, values_from=p)
+kmr <- kmeans(states %>% select(-state), 5)
+pcr <- prcomp(states %>% select(-state))
+
+p <- ggplot(pcr$x %>% as_tibble() %>% mutate(state=states$state), aes(PC1, PC2)) +
+  geom_text(aes(label=state))
+
+ggmd(p)
+ggsave("figures/state_vectors_pca.png")
+
+state_ordering <- pcr$x %>% as_tibble() %>% select(PC1, PC2) %>%
+  mutate(state=states$state) %>% arrange(PC1, PC2) %>%
+  mutate(ymin=(1:50)-0.5, ymax=(1:50)+0.5)
+
+p <- ggplot(state_vectors %>%
+         inner_join(ordering, by="shape") %>%
+         inner_join(state_ordering, by="state")) +
+  geom_rect(aes(xmin=x0, xmax=xf, ymin=ymin, ymax=ymax,fill=p),color="black") +
+  scale_x_continuous(breaks=seq_along(ordering$shape), labels=ordering$shape) +
+  scale_y_continuous(breaks=seq_along(state_ordering$state), labels=state_ordering$state) +
+  theme(axis.text.x = element_text(angle = 90, hjust = 1))
+
+ggmd(p)
+ggsave("figures/state_vectors_pc_ordered.png")
+
+
(2/2) Stage this hunk [y,n,q,a,d,K,g,/,e,?]? y
<stdin>:36: new blank line at EOF.
+
warning: 1 line adds whitespace errors.

*** Commands ***
  1: [s]tatus	  2: [u]pdate	  3: [r]evert	  4: [a]dd untracked
  5: [p]atch	  6: [d]iff	  7: [q]uit	  8: [h]elp
What now> q
Bye.
root@esc:~/bios611/git-in-depth/project# git commit -m "Added additional plots showing PCA of vectors and ordered the vectors in a heatmap using the PCA coordinates."
[main bde0b8c] Added additional plots showing PCA of vectors and ordered the vectors in a heatmap using the PCA coordinates.
 1 file changed, 29 insertions(+)
root@esc:~/bios611/git-in-depth/project# git status
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   state_vectors.R

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	source_data/

no changes added to commit (use "git add" and/or "git commit -a")
root@esc:~/bios611/git-in-depth/project# git diff
diff --git a/state_vectors.R b/state_vectors.R
index 410a817..3d1c275 100644
--- a/state_vectors.R
+++ b/state_vectors.R
@@ -25,8 +25,6 @@ state_vectors <-
   pivot_longer(changing:cube) %>%
   rename(shape=name, p=value)
 
-
-
 ordering <- state_vectors %>%
   group_by(shape) %>%
   summarize(p_avg=mean(p)) %>%
root@esc:~/bios611/git-in-depth/project# git stash
Saved working directory and index state WIP on main: bde0b8c Added additional plots showing PCA of vectors and ordered the vectors in a heatmap using the PCA coordinates.
root@esc:~/bios611/git-in-depth/project# 
```
How does this work in practice?

The beautiful thing about git is that we can ignore it most of the time. It isn't
unusual for me to work for a week or two without thinking much about git, except to say
periodically:

``` bash
git add -A :/ && git commit --amend -m "Revise me"
```

And then, when I feel the need to actually think about git, I say:

```
git reset HEAD~
```

Which means "Move the HEAD to the previous commit."

Then we can say:

``` bash
git add -i
```

And make a series of tidy commits.

:student-select:Q; ../students.json::

All the other stuff about git is ::06_details:details::. Except for rebase and merge, which we will discuss after the details.
