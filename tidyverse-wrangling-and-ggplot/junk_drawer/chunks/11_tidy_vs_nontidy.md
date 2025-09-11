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


::chunks/12_pivots:Next: Pivots::
