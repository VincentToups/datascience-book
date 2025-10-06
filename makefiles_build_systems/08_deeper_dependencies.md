Deeper Dependencies
===================

So we've produced a few artifacts, let's produce some more to
demonstrate how Make really makes life easier. We did quite a lot in
the last lecture, but let's pick a narrow focus: we want to produce a
cleaned up data set with just the gender data in it. 

We can begin by adding the appropriate target to our Makefile.

``` Makefile file=project/Makefile ref=3934

```

And create the appropriate script.

``` R file=project/make_gender_dataset.R ref=3934

```

And then we want to create a data set that joins this data with the
powers data.

``` Makefile file=project/Makefile ref=05bfe

```

``` R file=project/make_power_gender_dataset.R ref=05bfe

```

Now we should be extremely comfortable deleting all of our work. If I've done
my job correctly we should be able to do that quite easily:

``` bash
cd project
git checkout 05bfe
make clean
make derived_data/power_gender_data.csv
cat derived_data/power_gender_data.csv
git checkout main
```


The goal here is total comfort in deleting intermediary work: your repo always needs to be able to reproduce your work at any time. 

Let's introduce some ::09_figures:figures.::