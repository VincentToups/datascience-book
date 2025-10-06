Parameterizing Builds
=====================

Note that we have two files in our source data:

:table:project/source_data/character-data.csv::
:table:project/source_data/powers.csv::

And we can use the same logic to deduplicate both of them. 

Let's modify our our file so that it looks like this:


``` R file=project/deduplicate.R ref=351f

```
Note how we access the command line arguments given to our script by using the 
`commandArgs` function.

And the Makefile entries that use the same script to produce different artifacts by passing an argument:

``` Makefile file=project/Makefile ref=351f

```

This keeps one source of truth for the logic while still producing separate, explicit artifacts.


Next: ::07_pattern_rules:Pattern rules (when to use)::. 
