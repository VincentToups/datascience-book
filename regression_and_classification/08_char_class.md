Characterizing Classifications
==============================

The natural thing to do when reporting how well a classification works is
to report the "accuracy," which is just the number of times the classifier
is "right" on the held out data set.

```sidebar
Note that we use the `type="response"` argument when we call `predict` here. That
gives us back the probabilities instead of the logit.
```
``` R
library(tidyverse)

d_test <- read_csv("derived_data/penguins_test.csv", show_col_types = FALSE)
m <- readRDS("models/adelie_logres.rds")

p <- predict(m, newdata = d_test, type = "response")
pred <- as.integer(p >= 0.5)
truth <- d_test$is_adelie

tp <- sum(pred == 1 & truth == 1)
fp <- sum(pred == 1 & truth == 0)
tn <- sum(pred == 0 & truth == 0)
fn <- sum(pred == 0 & truth == 1)
acc <- (tp + tn) / (tp + fp + tn + fn)

df <- tibble(
  measure = c("True Positive", "False Positive", "True Negative", "False Negative", "Accuracy"),
  value   = c(tp, fp, tn, fn, acc)
)

lbdr(df)

```
It may not be obvious that we care about the values other than the accuracy, but, in fact,
which type of error we care about depends a lot on the cost of making different kinds of 
mistakes.

If we imagine that Adelie penguins in particular carry a deadly disease which
we have to prevent from entering a country at customs then we might want to 
bias the classifier towards avoiding false negatives. We can do that 
by adjusting the threshold probability. 

``` R
library(tidyverse)

evaluate_model <- function(model, data, threshold = 0.5) {
  p <- predict(model, newdata = data, type = "response")
  pred <- as.integer(p >= threshold)
  truth <- data$is_adelie
  
  tp <- sum(pred == 1 & truth == 1)
  fp <- sum(pred == 1 & truth == 0)
  tn <- sum(pred == 0 & truth == 0)
  fn <- sum(pred == 0 & truth == 1)
  acc <- (tp + tn) / (tp + fp + tn + fn)
  
  tibble(
    measure = c("True Positive", "False Positive", "True Negative", "False Negative", "Accuracy"),
    value   = c(tp, fp, tn, fn, acc),
    threshold = threshold
  )
}

d_test <- read_csv("derived_data/penguins_test.csv", show_col_types = FALSE)
m <- readRDS("models/adelie_logres.rds")

df <- evaluate_model(m, d_test, threshold = 0.5)
lbdr(df)

df <- tibble()
for(i in (0:100)/100){
    df <- rbind(df, 
      evaluate_model(m, d_test, i))
}

lbdr(ggplot(df, aes(threshold, value)) + geom_line(aes(group=measure,color=measure)))

write_csv(df, "derived_data/over_threshold.csv")
```
According to the above, if our goal is to produce a classifier than NEVER misses
an Adelie penguin, we are going to have a lot of trouble! We might need to 
go back to the drawing board.

In an ideal situation we would know the cost associated with each type of error
and the profit associated with each type of successful prediction and we would
choose a threshold based on maximizing the value of the classifier. Unfortunately
we rarely have concrete information and so there are other methods of
characterizing the utility of a classifier which serve as useful shorthands.

The key idea is coming up with a measure that is ::09_roc:independent of the threshold::.