Step 1
======

Consider this code

``` R file=project/deduplicate.R ref=a0af9

```
It’s the kind of thing we might write in a scratch file while we get to know a data set.

This is a fine way to work, but after a while we want to discipline ourselves a bit and ask:

1. What am I doing here?
2. What am I creating in this step?
3. What do I need to create it?

With those things in mind we can rewrite the above code like this:

``` R file=project/deduplicate.R ref=47515

```
Note how we have added a bit of code to *write out* the result of this step. Now we can create an entry in our Makefile that looks like this:

And to support that we have the following:

``` R file=project/utils.R ref=47515b

```
``` Makefile file=project/Makefile ref=47515

```


Now that we have a Makefile we can discuss the all‑important ::04_make_clean:make clean::.
