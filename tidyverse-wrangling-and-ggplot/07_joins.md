Joins!
======

Because data is often intentionally separated into different data sets in databases,
we often have to put it back together, but in fact, sometimes we are putting together
data from entirely different sources or data sets, and in that case we need to
do joins regardless.

Joins work like this:

Compare some subset of values from each data frame - these are the "keys" since
they determine which rows go together. Then we collect together the columns
from each data set when the keys match. 

Simple! But we need to decide a few things about what to do about missing data and this leads to different joins.

1. "left" table is literally the table we start with and is on our left
2. "right" table is the table we are working with and is our our right sytactically


Remember our actual data sets:

:schema:source_data::

First perhaps the most obvious sort of thing. We want to combine students
with their majors and we want to know which students may not yet have chosen
a major. This is called a "left" join because we keep everything in the left
table and fill in NA's if we don't have data in the right table. 
```R 
library(tidyverse)

students <- read_csv("source_data/student.csv")
majors <- read_csv("source_data/major.csv")
fraternities <- read_csv("source_data/fraternity.csv")
addresses <- read_csv("source_data/address.csv")
props <- read_csv("source_data/student_properties.csv")

# LEFT JOIN: keep all students, attach majors when present
mdpre(paste(
  "students:", nrow(students),
  "majors:", nrow(majors)
))
students_majors_left <- students %>%
  left_join(majors %>% rename(major_name = name, major_address_id = address_id),
            by = c("major_id" = "id")) %>%
  select(id, name, major_id, major_name, enrollment_date, gpa)

mdpre(paste("left join rows:", nrow(students_majors_left)))
mddf(students_majors_left)
```
Inner (contrived)
-----------------

Sometimes the most direct way to see what an inner join does is with a tiny example.

```R 
library(tidyverse) 

# CONTRIVED INNER JOIN: only rows with matching keys survive
left_df <- tibble(id = c(1, 2, 3), val_left = c("A", "B", "C"))
right_df <- tibble(id = c(2, 3, 4), val_right = c("X", "Y", "Z"))

mdpre("left")
mddf(left_df)

mdpre("right")
mddf(right_df)

mdpre(paste(
  "left rows:", nrow(left_df),
  "right rows:", nrow(right_df)
))

inner_df <- left_df %>% inner_join(right_df, by = "id")

mdpre(paste("inner rows:", nrow(inner_df)))
mddf("inner join")
mddf(inner_df)
```
![](joins.png)
Right and full
--------------

:student-select:Q;../students.json::
```R 
library(tidyverse)

students <- read_csv("source_data/student.csv")
majors <- read_csv("source_data/major.csv")
fraternities <- read_csv("source_data/fraternity.csv")
addresses <- read_csv("source_data/address.csv")
props <- read_csv("source_data/student_properties.csv")

# RIGHT JOIN: keep all properties, even if there is no matching student
mdpre(paste(
  "students:", nrow(students),
  "properties:", nrow(props)
))
props_right <- students %>%
  right_join(props, by = c("id" = "student_id"))

# Row count after right join
mdpre(paste("right join rows:", nrow(props_right)))

# Observe the intentionally dangling properties with student_id = 99
mddf(props_right %>% filter(is.na(name)))

# FULL JOIN: keep all students and all properties
props_full <- students %>%
  full_join(props, by = c("id" = "student_id"))

mdpre(paste("full join rows:", nrow(props_full)))
mddf(props_full)
```

With that in our heads we can get back into our data and prepare
to make a non-trivial visualization.

## Other Summaries

You can often get a good sense about how to approach a data set by
grouping on more than one column. What we want to do next is pose
questions like:

Are male (coded) characters more or less likely to be married than
female (coded) characters?

But to answer this question we have to delve into "tidy" data.

## Tidy vs Non-Tidy Data

An important idea in the tidyverse is "tidy" data. This means more than
just clean or nice data. It means that whatever our concept of an
"observation" is our data frames should contain one row per observation.
At present our data is *very* tidy because I wrote the web scraper to
scrape into a tidy form.

In our case an observation is a "character, universe, property_name, and
value".

The tidyverse assumes that your data is tidy in its design. This allows
it to be much simpler than it might otherwise be.

But not all data is tidy to begin with. Its pretty common to see
so-called "wide" data:

```R 
library(tidyverse)
u <- read_csv("untidy-example.csv")
mddf(u, n=100)
```

This data set contains many observations per row. This can make certain
things easier (for instance, we can easily count how often
super_strength and super_speed appear together). But it won't fly with
many tidyverse functions. We need to learn how to "narrow" "wide" data.

## Pivots

The tidyverse package `tidyr` has functions for narrowing and widening
data sets.

```R 
library(tidyverse)
library(tidyr)
u <- read_csv("untidy-example.csv")
u_long <- pivot_longer(u, cols=super_strength:super_intelligence, values_to="value", names_to="power")
mddf(u_long, n=100)
```

You may notice that this is more or less how my power dataset looks.

You will need to have your data in tidy format to use ggplot
effectively.

But in our case, we really do want to compare gender and marital status,
so we want to widen (a subset) of our data.

```R 
library(tidyverse)
tidied_data <- read_csv("derived_data/tidied_data.csv")

gender_marital <- tidied_data %>%
    filter(property_name == 'gender' | property_name == 'marital_status');

mddf(gender_marital, n=100)

write_csv(gender_marital, "derived_data/gender_marital.csv")
```

When we `pivot_longer` we need to understand which columns we need to
convert to observations. To `pivot_wider` we need to understand which
observations we want to convert to rows.

But we have a bit more tidying to do before we can get there. Question:
it seems obvious, but how can we be sure that we don't have unique
characters here with two or more genders or marital statuses?

This is a disadvantage of tidy data: we may have repeat or even
logically mutually exclusive observations.

Let's examine that question.

```R 
library(tidyverse)
gender_marital <- read_csv("derived_data/gender_marital.csv")

mddf(gender_marital %>% filter(property_name == 'gender') %>%
    group_by(character, universe) %>% tally() %>%
    filter(n!=1))
```

Looks like our gender data is good.

```R 
library(tidyverse)
gender_marital <- read_csv("derived_data/gender_marital.csv")

marital_status_counts <- gender_marital %>%
    filter(property_name == 'marital_status') %>%
    group_by(character, universe) %>%
    tally() %>%
    arrange(desc(n));
mddf(marital_status_counts, n=100);
write_csv(marital_status_counts, "derived_data/marital_status_counts.csv")
```

But it seems like we have a few characters with multiple marital
statuses. Let's filter them out.

```R 
library(tidyverse)
gender_marital <- read_csv("derived_data/gender_marital.csv")
marital_status_counts <- read_csv("derived_data/marital_status_counts.csv")

gender_marital <- gender_marital %>%
    left_join(marital_status_counts, by=c("character","universe")) %>%
    filter(n == 1) %>%
    select(-n);
write_csv(gender_marital, "derived_data/gender_marital_filtered.csv")

mddf(gender_marital, n=100)
```

And now we can check whether we got it right.

```R 
library(tidyverse)
gender_marital <- read_csv("derived_data/gender_marital_filtered.csv")

mddf(gender_marital %>% filter(property_name == 'marital_status') %>%
    group_by(character, universe) %>%
    tally() %>%
    arrange(desc(n)), n=100);
```

Ok. Now we can perform our widen.

```R 
library(tidyverse)
gender_marital <- read_csv("derived_data/gender_marital_filtered.csv")

gm_wider <- gender_marital %>% pivot_wider(id_cols=character:universe, names_from = 'property_name',
                               values_from='value');
write_csv(gm_wider, "derived_data/gm_wider.csv")

mddf(gm_wider, n=100)
```

And now we can get a sense for our question: does gender correlate with
marital status in comics?

```R 
library(tidyverse)
gm_wider <- read_csv("derived_data/gm_wider.csv")

status_counts <- gm_wider %>%
    group_by(gender, marital_status) %>%
    tally() %>% arrange(desc(n));
mddf(status_counts, n=100)
write_csv(status_counts, "derived_data/status_counts.csv")
```

This isn't enough, though, we need to normalize by total number with
each gender.

```R 
library(tidyverse)
gm_wider <- read_csv("derived_data/gm_wider.csv")

gender_counts <- gm_wider %>%
    group_by(gender) %>%
    tally();
mddf(gender_counts, n=100)
write_csv(gender_counts, "derived_data/gender_counts.csv")
```

And now we do a join.

```R 
library(tidyverse)
status_counts <- read_csv("derived_data/status_counts.csv")
gender_counts <- read_csv("derived_data/gender_counts.csv")

status_probs <- status_counts %>%
    left_join(gender_counts, by="gender", suffix=c("",".gender")) %>%
    mutate(p=n/n.gender)

mddf(status_probs, n=100)

mddf(status_probs %>%
    filter(gender %in% c("male","female") & marital_status %in% c("single","married","divorced")) %>%
    arrange(desc(p)), n=100);
write_csv(status_probs, "derived_data/status_probs.csv")
```

We can imagine producing a series of such tables to get a sense for
whether there is anything interesting in this data. Sometimes looking at
tables is enough, but even a moderate number of things to look at can be
overwhelming.

That is why data exploration also requires the ability to make figures.
Lots of them.


::08_review:Next∶ Review of Dplyr & TidyR::
