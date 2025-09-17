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
