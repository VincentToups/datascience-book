Deduplication
=============

Before we do that let's throw away our bits and pieces of dates and create a posix date time.

``` R file=basic_exploration.R start="lit:d <- d %>% mutate(date" end="^ select"

```

When we deduplicate data we need to be sure to throw away obvious id columns. Lots of
rows might be identical except for an auto generated id.

This is  because a lot of database software generates id columns for us as we insert data
into the database. So if we accidentally enter the same data twice they will have different
id columns. 

In this case we have only a few duplicate rows.

``` R file=basic_exploration.R start="^deduplicated" end="lit:write_csv"

```

Now we can ::04_makefile:examine the entire file:: and update our Makefile.
