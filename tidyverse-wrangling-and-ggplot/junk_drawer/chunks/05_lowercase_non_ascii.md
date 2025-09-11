## lowercase and remove non-ascii characters
simplify_strings <- function(s){
    s <- str_to_lower(s);
    s <- str_trim(s);
    s <- str_replace_all(s,"[^a-z]+","_")
    s
}
mdpre(simplify_strings(c(" ha", "ha! ", "aha!ha", "aha ha")))

```


::chunks/06_magrittr_aside:Next: An Aside: Magrittr::
