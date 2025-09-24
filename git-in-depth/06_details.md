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

![](detached-head.png)

If we know how to checkout a branch, we can reattach it. Easy!

gitignore
---------

Because we are pros, we never `git add -A`. We always add `-i`, which means we never
add anything we don't want to. However, sometimes it's handy to make git stop
asking about certain types of files (when you say `git status`). We do that with a
.gitignore. This can be anywhere in a project, and it only modifies git's behavior for
files in or below the directory it's in. You can have multiple.

``` .gitignore
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
