Pros and Cons
=============

Using rules like this has some benefits and drawbacks.

The main benefit is that you write *one* piece of code that does the
job. There is an old joke that you can't have bugs in code you don't
write and there is a lot of truth to it. If you can identify shared
functionality you should always factor it out into a single task or
function.

The main drawback of this strategy is that it makes the Makefile less
readable:

``` Makefile file=project/Makefile ref=351f

```

In that example we have a serious problem: the Makefile doesn't tell
us *what* we can make. That information is actually hidden in the source_data
directory:

```
drwxr-xr-x 6 root root 4.0K Oct  6 15:17 ..
-rw-r--r-- 1 root root 4.7M Oct  6 14:16 powers.csv
drwxr-xr-x 2 root root 4.0K Oct  6 14:16 .
-rw-r--r-- 1 root root 346K Oct  6 14:16 character-page-data.csv
-rw-r--r-- 1 root root  34M Oct  6 14:16 character-data.csv
```

That is, we need to look elsewhere to understand what the Makefile means.

There are ways to resolve this issue using some more advanced features
of Make, eg:

``` Makefile
SAMPLES := powers character-data

derived_data/deduplicated-$(SAMPLES:=.csv) \
logs/deduplication-$(SAMPLES:=.md): %: data/raw-%.csv deduplicate.R
	@echo Rscript deduplicate.R $*
	Rscript deduplicate.R $*

```

But this introduces additional complexity and indirection.

What I would suggest is something like this:

``` Makefile

derived_data/deduplicated-powers.csv logs/deduplication-powers.md: source_data/powers.csv
	Rscript deduplicate.R powers
	
derived_data/deduplicated-character-data.csv logs/deduplication-character-data.md: source_data/character-data.csv
	Rscript deduplicate.R character-data

```

This allows the reader to see concretely what it is that is being
built while still allowing us to re-use the deduplication logic that is shared
between the two scripts. And there is no way to accidentally call a script on
a piece of data we don't want.

Let's exercise some deeper dependencies.

::08_deeper_dependencies:Next::


