F1 Scores
=========

Sometimes it's appropriate to think of a classifier as performing a retrieval
task - you search a pile of objects for a particular type and then you get
some objects back. 

From this point of view you can define a few quantities:

1. precision: The number of true positives over the number true and false positives (the number labeled positive).
2. recall: The number of true positives over the true positives and false negatives (the actual positive count)

Using these two measurements we can calculate the f1 score, which looks a little funny:

$$
f_1 = 2 \frac{precision recall}{precision + recall}
$$

What does this mean intuitively? Well, it's the [harmonic mean](https://en.wikipedia.org/wiki/Harmonic_mean#Harmonic_mean_of_two_numbers) of the precision
and the recall. 

The key justification for this measure is that if these two quantities are very
out of balance the above expression penalizes the f1 score. This means that
we want to treat these two measures of utility as being equally important.

Now let's turn our attention to the question of ::11_var_sel:variable selection:: for these
linear style models. 

