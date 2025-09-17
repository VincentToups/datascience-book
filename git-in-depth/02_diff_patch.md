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

``` R file=vis_v1.R

```

``` R file=vis_v2.R

```

``` bash capture=true
diff -u vis_v1.R vis_v2.R
```

:student-select:Q; ../students.json::

Consider this: if we could look at this diff at any time in the future,
we could avoid things like giving our figures new names each time we
generated a new version.

The patch tells us that these are versions of the same figure!

For the sake of completeness, consider that we can use the generated
patch file to transform v1 into v2.

``` bash capture=true
diff -u vis_v1.R vis_v2.R > v1_to_v2.patch
patch -o /tmp/patched_version.R vis_v1.R v1_to_v2.patch
cat /tmp/patched_version.R 

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

