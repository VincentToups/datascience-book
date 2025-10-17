An Example Logistic Regression

``` R file=make_penguin_model.R

```
An Aside about Models
=====================

Note: *models are artefacts* in the Makefile/build system sense.

We can thus add an entry like this:

```
models/adelie_logres.rds derived_data/penguins_train.csv derived_data/penguins_test.csv: 
    Rscript make_penguin_model.R 
```

And then use the model later as part of another analysis. 

Characterizing the performance of logistic regressions (and other classifiers) is actually a bit tricky. Let's ::08_char_class:think about it::.
