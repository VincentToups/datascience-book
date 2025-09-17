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

![](trinity.png)

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
