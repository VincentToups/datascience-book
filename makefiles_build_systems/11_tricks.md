Make Tricks
===========

Git repos, directories, etc.

Directories
-----------

Git does not know about directories. And unfortunately or fortunately,
depending on your perspective, when we eg `ggsave("<dir>/<file>")` R
will not, but default, create the directory for us. This is probably good
because it means a typo in the directory name will produce an error.

However, its sort of a hassle because we need to think constantly
about directories for our stuff - its convenient to delete them with `clean`
but then we have to remember to always check if they exist. Make has a
facility which we can use to ease the burden if we want:

```Makefile

directories:
	mkdir -p figures
	mkdir -p derived_data

derived_data/some_data.csv: source_data/req.csv script.R | directories
	Rscript script.R
```

This will ensure that the target "directories" always runs before `derived_data/some_data.csv` so that we don't have to track it manually in the code.

Shell Commands
--------------

It can be useful to run shell commands in a script, especially when we
want to create artifacts tagged with the git commit.

```Makefile

COMMIT=$(shell git log -1 | head -n 1 | cut -d' ' -f2)
CLEAN=$(shell git diff --quiet && echo clean || echo dirty)

figures/test.png: ...
	Rscript script.R
	cp figures/test.png tagged_figures/$COMMIT_$CLEAN_test.png
```

As we will see this is a useful way to tag outputs when we generate
::12_reports:reports via Markdown::.




