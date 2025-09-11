## An Aside: Magrittr

You might notice there is a pattern in the function we wrote above: a
series of lines overwriting a variable on each line. There are other
ways we could have written it. This is more explicit:

```R 
library(tidyverse)
simplify_strings <- function(s){
    s <- str_to_lower(s);
    s1 <- str_trim(s);
    s2 <- str_replace_all(s1,"[^a-z]+","_")
    s2
}
```

But error prone and still verbose. We could eliminate the temporary
variables like this:

```R 
library(tidyverse)
simplify_strings <- function(s){
    str_replace_all(str_trim(str_to_lower(s)), "[^a-z]+","_");
}
```

But some people find this less than readable. In particular, in English
we tend to read right to left, but the above happens left to right and
it can be hard to parse out precisely which arguments go with which
functions.

Recall pipes in bash:
``` 
> find . -type R | xargs grep do_something_important | cut -d':' -f 1
\| sort uniq
```

Magrittr is a part of the tidyverse that allows us to build similar
pipelines in R. It provides a `%>%` binary operator which stitches
together its arguments.

```R 
library(tidyverse)
simplify_strings <- function(s){
    s %>% 
        str_to_lower() %>%
        str_trim() %>%
        str_replace_all("[^a-z1-9]+","_") %>%
        str_replace_all("^_+","") %>% # added these lines after looking at the data
        str_replace_all("_+$","");
}

```

You can think of this as "putting the result of the previous expression
into the first argument slot of the next expression" thus forming a
pipe. We will now start using this pipeline operator almost everywhere,
including in dplyr pipelines.


::chunks/07_back_to_business:Next: Back to Business::
