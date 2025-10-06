Make Kees the Score
===================

Imagine that we scrutinize our data and find that all these "genderless"
robots in our data set present as male and we decide they should be treated
as such:

```R file=project/make_gender_dataset.R ref=71caf
```

If we make this change and then run make, even without a clean, make
detects that something which effects the figure changed and rebuilds
everything required to make the figure reflect that change.

A few ::11_tricks:other make tricks::.
