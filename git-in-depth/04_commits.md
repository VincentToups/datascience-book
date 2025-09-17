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
