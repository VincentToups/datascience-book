A Git Repo
==========

Setting up a git repository is easy but involves a few complicated steps
if you've never done it before.

First we decide where we want to set it up.

```sidebar
master vs main
--------------

Historically the main branch of a git repository was called "master" but
this language is needlessly hierarchical. Thus the trend has been to use
"main" instead. Will this fix all the social problems in the world? No, but
it's harmless in and of itself and I do it. 

```

Note the following concepts:

:student-select:invent a question; ../students.json::

1. users: on modern computers access is controlled primarily via users. Ultimately
a user is just a number associated with a name and some permissions. Users all 
have a home directory. In unix-like operating systems the user's home directory
is usually `/home/<username>/` and you can always "get" there by using `cd` (change directory)
like this: `cd ~` (the tilde is expanded to the home directory).
Note that the "root" user is a special user who has freedom to do anything. The
root user's home directory is `/root`. 
2. directories: a directory is just a "place" on your computer where you can put files
and directories. We can create a directory by saying `mkdir <directory name>`.
Note that files and directories have access modifiers set on them which 
determine who is allowed to read, write, and execute (for files) those files. We
will need to think carefully about this from time to time (see sidebar).
3. working directory: every process (thing that does something) has a "working directory" relative to which
all filenames are resolved unless you specify a full path.

```sidebar
Docker & Podman and Permissions
-------------------------------
> true hell 

Docker runs containers _as_ the root user. Thus with Docker we often set up
our user _in the container_ to match our user id _outside_ the container so that
we can access files we mount in the container, in which we run as a non-root
container user.

In _podman_ we run containers _as_ our host user. So _inside_ the container it's
convenient to run as the container's _root_ user (who has our user id). This allows
us to access host files without fiddling with permissions. 

Usually "running as root" is a _bad idea_ since you can cause major trouble accidentally but
in a container running as an unprivileged user, we can run as root safely, since
at most we could mess up our container, which is disposable anyway.

But when we run our container via Docker, the docker process itself is (speaking morally)
run by the root user, so we want to at least run as a non-root user in the container.

Confusing, right?
```

Here is one major way we can simplify our lives when doing data science:
always assume when writing code that the working directory is the main project 
directory. If we follow this rule we never need to "cd" or otherwise set our
working directory in our code.

:student-select:invent a question; ../students.json::

Anyway, let's create a repository.

```bash 
# this is just to make this idempotent
rm -rf ~/my-project

cd ~
mkdir my-project
cd my-project 

# note we could say mkdir -p ~/my-project

git init
git branch -m main 


```



Note that our _git repository_ is totally distinct from _GitHub_, which is just
a service. We've created a git repo here and at present it's empty.

```bash pwd=/bios611/my-project/
git status
```
Great. We have a new, fresh, git repository in our project directory.

Before it's worth syncing it up with GitHub we need to actually put something in 
it.

The natural first thing is a ::a_readme:"README.md"::.
