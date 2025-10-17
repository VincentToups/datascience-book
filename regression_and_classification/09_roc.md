F Scores and ROC Curves
=======================

The main way people do this is by reporting so-called F scores (the most common of which is the F1 score) and by showing ROC curves and 
giving the area under the ROC curve, which has a clear meaning. 

The ROC curve is the less confusing and more useful of the two methods. 

``` R
library(tidyverse)

df <- read_csv("derived_data/over_threshold.csv") %>% arrange(threshold) %>%
   pivot_wider(names_from="measure", values_from="value") %>%
   transmute(`False Positive Rate`=`False Positive`/(`False Positive` + `True Negative`),
             `True Positive Rate` = `True Positive`/(`True Positive` + `False Negative`),
             threshold=threshold) %>% arrange(threshold)

lbdr(df)
lbdr(ggplot(df, aes(`False Positive Rate`, `True Positive Rate`)) + geom_line() + geom_abline(slope=1, intercept=0,color="red"))

```
As is often the case in this class - this problem is too easy and so it's hard to get a sense for what this should look like if we have a not-so-good-classifier.

But we can understand things if we cogitate a bit. If our classifier was terrible then
the true positive rate would be roughly speaking equal to the one minus the threshold and our false positive rate would be equal to the threshold.

If we plotted that we would get the line y=x. So a perfect classifier looks like a rectangle and a perfectly bad classifier looks like the line y=x. 

Thus, we can get a threshold-free measure of the quality of our classifier by
taking the area under the curve minus 1/2 times 2. This would vary from 0 for a bad classifier to 1 for a perfect one.

Typically people give the AUC without this normalization and we just understand an AUC of 1/2 is bad. 

Now let's describe the ::10_f1_score:F1 score::. 
