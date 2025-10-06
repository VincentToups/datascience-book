Figures
=======

Let's start with the Makefile entry, since we know what we need and
what we want to create.

``` Makefile file=project/Makefile ref=3af8f51

```

And now the code itself. We've seen this before in another lecture.

``` R file=project/figure_power_gender_rank.R ref=3af8f51

```


And now we can do our thing:

``` bash
cd project
git stash
git checkout 3af8f51
make clean
make figures/power_gender_rank.png
git checkout main 

```

Now a reminder: we don't even need clean for ::10_honest:make to keep us honest::.

