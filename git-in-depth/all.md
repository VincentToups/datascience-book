Git In Depth
============

Git is a tool which rewards deep understanding. The good news is that
it's not too hard to understand if we allow ourselves the time to think
about it.

Some vocabulary:

1. git - a version control system. It allows us to do all sorts of
   things with the history of our project: track it, modify it, time
   travel, branch along different lines. Git is given to us as a
   binary executable on our system somewhere and uses the sub-command
   pattern, so we invoke different functionality with different
   sub-commands.
2. sub-command - many Unix tools have a `command subcommand` style
   where functionality is grouped under various categories accessed by
   naming a sub-command. The sub-commands themselves act like their own 
   commands with their own help, command line switches, etc.
3. commit - a snapshot of our project at a specific state. We create
   commits manually. It might seem easier to imagine a system which snapshots
   automatically, but this would capture a lot of noise.
4. branch - a linear series of commits. We are almost always "on a
   branch" which just means that git automatically tracks which commit
   is the head of the branch when we make commits. 
   
   A branch is fundamentally just a pointer to a commit with a name
   that is updated each time we make a commit. Branches are thus
   cheap - we may make as many as we want and we can even delete them
   freely, since a branch just _points to_ a commit. Deleting a branch
   doesn't delete commits, generally. 
5. diff - diff is a command-line utility which encodes differences
   between files in a way that is both human-readable and machine
   usable. It also refers to the file or text that diff produces. When
   we work with git we are dealing with diffs in this sense.
6. patch - the more proper term for the text produced by the tool
   diff.  Key idea: each commit is a "patch" describing how we
   transformed the code from the previous state to the next state.
7. working copy/the tree - strictly speaking, the files we are
   actually looking at and editing are the working copy or tree. The
   git repository itself, the history, etc., is stored in the .git
   directory.
8. the staging area: the place where we use git to construct the patch
   that will become the next commit.
   
Fundamentally, the patch is the key idea in git. We do not even really
need git to ::02_diff_patch:understand the idea::.


:student-select:Q; ../students.json::
Diff and Patch
==============

Really, at a basic level, git is just a bunch of tools built around
`diff` and `patch`. And you might actually find these tools handy from
time to time.

`diff` takes two files and gives us a human-readable difference
between the two. The key idea in git is that this is a temporal
difference between two files.

`patch` takes that difference and is able to transform the first file
into the second file.

Consider this prototype of a visualization about the relative
probabilities of seeing different shapes from different UFOs in our
dataset.

```R file=vis_v1.R
```

```R file=vis_v2.R
```

```bash
echo "<pre>" > "$LABRADORE_MD_FILE"
diff -u vis_v1.R vis_v2.R | tee -a $LABRADORE_MD_FILE
echo "</pre>" >> "$LABRADORE_MD_FILE"
```

:student-select:Q; ../students.json::

Consider this: if we could look at this diff at any time in the future,
we could avoid things like giving our figures new names each time we
generated a new version.

The patch tells us that these are versions of the same figure!

For the sake of completeness, consider that we can use the generated
patch file to transform v1 into v2.

```bash
diff -u vis_v1.R vis_v2.R > v1_to_v2.patch
patch -o /tmp/patched_version.R vis_v1.R v1_to_v2.patch
echo "<pre>" > "$LABRADORE_MD_FILE"
cat /tmp/patched_version.R | tee -a $LABRADORE_MD_FILE
echo "
</pre>" >> "$LABRADORE_MD_FILE"
```

The Fantasy, The Reality
========================

![](./Platon_Cave_Sanraedam_1604.jpg)

Your codebase is NOT the pile of files in the working copy. This is
the shadow of your project.

Your code is the chain of patch files that took you from nothing to
the current time.

Each "commit" is a patch file and each branch is a *history* of patch
files going back to either the beginning of time or the branch from
which your branch diverged:

```
main *-*-*-*-*-*-*
        \   \ 
exp1     \   *-*-*-*
          \
exp2       \*-*-*
```

Bearing this in mind, ::03_repo_actions:let's revisit basic git activity::.

Basic Stuff
===========


We create a git repository like this:

``` bash capture=true

rm -rf project
mkdir project
cd project
git init
git branch -m main

cp ../vis_v1.R state_vectors.R
cp -r ../source_data source_data

git status

```

Then we commit like this:

``` bash capture=true
cd project
git add state_vectors.R

git config user.email "toups@email.unc.edu"
git config user.name "Vincent Toups"	

git commit -m "Added initial version of state_vectors.R"
git status
```

Okay. Then we make some changes. We will represent that thusly:

``` bash capture=true
cp vis_v2.R project/state_vectors.R
cd project
git status 

```

Now we can see clearly:

THE GIT HOLY TRINITY
====================

* THE HEAD
* THE TREE
* THE STAGE

Whenever we say "git status" we always, always get information about these things. What are they?

THE HEAD: the branch state at the last commit. The rollup of all commits in the 
current branch up to and including the last one.
THE TREE: the files you are currently working on. After a git commit and git stash,
THE TREE should be identical to THE HEAD.
THE STAGE: that which will be the next commit.

Many git commands can be understood in these terms:

```

git status : print info about the trinity
git add : move a change from the TREE to the STAGE
git diff : show the difference between the HEAD and the TREE (sans the STAGE)
git commit : move the STAGE into the HEAD
git checkout <something> : move something from the HEAD to the TREE

etc.

```


We made a change, so now we can see some stuff:

:student-select:Q; ../students.json::

``` bash capture=true
cd project
git diff

```
Now we can add our change to the stage:

``` bash capture=true
cd project
git add state_vectors.R
git status 
```
So now we are ready to ::04_commits:make a commit::!
Commits
=======

Commits and commit messages are extremely important.

1. Commits should be small — typically a commit should pertain to a single *idea* or *task*.
2. This is because commit messages should be small, and so we can't, and definitely do not want to, make big commits — we don't have enough room to describe what we've done.
3. A single line is a good rule of thumb.

``` bash capture=true
cd project
git add state_vectors.R
git commit -m "Switched to a ggplot visualization for better control over colors and order."
```
Now that we've made a commit, we can view the log:

``` bash capture=true
cd project
git log
```
Note that each commit is associated with a commit ID. These are important!
Branches have names, but ultimately they just point to commit IDs. A commit is, morally speaking, a patch file. We can even see that patch with:

``` bash capture=true
cd project
git show $(git log | grep commit | head -n1 | cut -d' ' -f2)
```
Think of the value in this information: we have both a concise summary of what we changed and a description of why we changed it. And it's never going anywhere; it's associated with a person and a moment in time.

With the right tools we can actually make commits even ::05_better_commits:more informative::.

:student-select:Q; ../students.json::
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
Details
=======

Branches
--------

We can create and switch branches.

``` bash
git branch <some name>
git checkout <some name>
git checkout -b <some name> (combines the above)
```

You now know that branches are just pointers to commits, so they are, in a sense,
pointless. That is because you can always find specific commits.

``` bash
git checkout <commit-id>
```

Indeed, if you are asked to examine some code in the past and anticipate doing
some development from that point, the idiom is:

```
git checkout <commit-id>
git checkout -b working-from-some-past-state
```

This actually allows us to explore the idea of a "detached head state."

We know that the HEAD refers to the current branch. If we know how to checkout a commit
we can detach our own head.

If we know how to checkout a branch, we can reattach it. Easy!

gitignore
---------

Because we are pros, we never `git add -A`. We always add `-i`, which means we never
add anything we don't want to. However, sometimes it's handy to make git stop
asking about certain types of files (when you say `git status`). We do that with a
.gitignore. This can be anywhere in a project, and it only modifies git's behavior for
files in or below the directory it's in. You can have multiple.

``` gitignore
*.png
*.pdf
```

Ignores all PNG and PDF files. This means you can't accidentally put them in your
repo and they won't bother you while you work.

If you want, you can force-add them.

Directories
-----------

Git doesn't handle directories. It only handles files. This is a minor inconvenience.
This is why we are always "ensuring" directories. But you can sort of
navigate around this by putting an empty .gitignore in a folder and committing it.

Git ignores should be in the repo.

Merge and Rebase
----------------

Let's ::07_merge_rebase:talk about it::.

:student-select:Q; ../students.json::
Merge and Rebase
================

Git is about collaboration, and so we often have to deal with integrating code from other
people — either via remotes or branches.

Remotes
-------

A remote is just a pointer to another repo. Everyone will have an origin that points
to GitHub, but a repo can have more than one.

Definitions
-----------

1. merge: pulling commits from somewhere else ON TOP OF YOUR COMMITS
2. rebase: putting your commits away, pulling a remote or other branch's commits
onto the last time you were synced, and then applying your commits on top.

These are fundamentally a matter of etiquette and convention. If you are grabbing commits
from the "official" place, you do a rebase. You do this because, if you are going to
push your code later, it needs to look like it was based on the most recent version
of the official code.

If you are grabbing code from a forked project (a much rarer thing), then a merge
is perhaps more appropriate — you really are just reckoning with commits from elsewhere.

You basically will almost never merge unless you really know what you are doing.
You always want to rebase.

Let's demo that.

Example
-------

Imagine that we didn't have the most recent commits from our project. We just
have the code that switched to ggplot.

We decide to improve the contrast with this change:

```
root@esc:~/bios611/git-in-depth/rebase-example# git diff
diff --git a/state_vectors.R b/state_vectors.R
index 1203871..7906b3a 100644
--- a/state_vectors.R
+++ b/state_vectors.R
@@ -25,9 +25,6 @@ state_vectors <-
   pivot_longer(changing:cube) %>%
   rename(shape=name, p=value)
 
-state_vectors <- state_vectors %>%
-  mutate(p=-log(p))
-
 ordering <- state_vectors %>%
   group_by(shape) %>%
   summarize(p_avg=mean(p)) %>%
@@ -35,6 +32,9 @@ ordering <- state_vectors %>%
   mutate(x0=1:nrow(.)-0.5,
          xf=1:nrow(.)+0.5)
 
+state_vectors <- state_vectors %>%
+  mutate(p=-log(p))
+
 state_ordering <- tibble(state=state_name_map$state, ymin=(1:50)-0.5, ymax=(1:50)+0.5)
 
 
root@esc:~/bios611/git-in-depth/rebase-example# git add state_vectors.R 
root@esc:~/bios611/git-in-depth/rebase-example# git commit --amend -m "Improved contrast by taking log of p in state_vectors.R"

```

And then we hear that our collaborators have added some code. We want to get it, so
we say:

```
root@esc:~/bios611/git-in-depth/rebase-example# git fetch
root@esc:~/bios611/git-in-depth/rebase-example# git rebase origin/main
Auto-merging state_vectors.R
CONFLICT (content): Merge conflict in state_vectors.R
error: could not apply 77ef284... Improved contrast by taking log of p in state_vectors.R
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply 77ef284... Improved contrast by taking log of p in state_vectors.R
root@esc:~/bios611/git-in-depth/rebase-example# 
```

If we look in the file:

```
...
<<<<<<< HEAD
state_vectors <- state_vectors %>% group_by(shape) %>%
  mutate(p=p/max(p)) %>% ungroup()
=======
state_vectors <- state_vectors %>%
  mutate(p=-log(p))
>>>>>>> 77ef284 (Improved contrast by taking log of p in state_vectors.R)

...
```

This is a conflict marker. I want to emphasize that git is totally ignorant of
how programming languages work. All this is telling us is that git found
lines which we changed that our collaborators also changed.

We are in the middle of a rebase. We have to fix this:

:student-select:Q; ../students.json::

```
...
state_vectors <- state_vectors %>% group_by(shape) %>%
  mutate(p=p/max(p)) %>% ungroup()
...
```

And then tell git we did it:

```bash
git add state_vectors.R
git rebase --continue
```

Which would result in something like this:

```
(emacs:3748): dbind-WARNING **: 17:03:44.671: Couldn't connect to accessibility bus: Failed to connect to socket /run/user/6001/at-spi/bus_1: No such file or directory
[detached HEAD d5f398b] Accepted better normalization from origin.
 1 file changed, 2 deletions(-)
Successfully rebased and updated refs/heads/my-branch.
root@esc:~/bios611/git-in-depth/rebase-example# 
```

We can represent a rebase or merge visually:

```rebase
local-main a-b-c-d
remote-main a-q-r-s-w

# after rebase

local-main a-q-r-s-w-b'-c'-d'
```

```merge
local-main a-b-c-d
remote-main a-q-r-s-w

# after merge

local-main a-b-c-d-q'-r'-s'-w'
```

::08_recapitulation:Recapitulation::
Recapitulation
==============

Key ideas we covered:

- Git as patches: think of your project as a chain of patches (commits), not just a pile of files.
- diff and patch: `diff` shows changes; `patch` applies them. Each commit is effectively a patch.
- Basic workflow: initialize, edit, stage, commit. Always be aware of the trinity: HEAD, TREE, and STAGE.
- The Trinity:
  - THE HEAD: the last committed state of your current branch.
  - THE TREE: your working copy (files on disk).
  - THE STAGE: what will become the next commit.
- Commits: keep them small and focused. Write clear, single-line summaries that state what and why.
- Interactive staging: use `git add -i` or `git add -p` to craft precise commits from mixed changes.
- Details that matter: branches are pointers; detached HEAD is normal when examining old commits; use `.gitignore`; Git tracks files, not directories.
- Rebase vs merge: prefer rebasing onto the official history; merge only when that’s truly what you intend.

The goal is clarity: small, intentional commits with informative messages, built from a clean understanding of how changes move between the TREE, the STAGE, and the HEAD.


:student-select:Q; ../students.json::
