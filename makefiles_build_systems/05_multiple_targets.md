Handling Multiple Targets
=========================

Sometimes a single step produces more than one useful artifact. For example, while deduplicating, we can also log a summary line to a notes file.

First, add a tiny logger helper to `utils.R`:

``` R file=project/utils.R ref=9cbdb

```

Use it in the deduplication step to write both the CSV and a log entry:

``` R file=project/deduplicate.R ref=9cbdb

```

Reflect the two outputs in the Makefile by listing both targets for the same recipe:

``` Makefile file=project/Makefile ref=9cbdb

```

Next: ::06_parameterize:Parameterize steps for reuse::.
