library(tidyverse)
d <- read_csv("https://raw.githubusercontent.com/varunlobo/PowerBI_Vehicle_dataset_kaggle/refs/heads/main/Automobile_data.csv")
names(d) <- names(d) %>%
  str_replace_all("-","_") %>%
  str_replace_all("[^_A-Za-z0-9]*","") %>%
  str_to_lower()

scale <- function(a){
  (a - min(a))/(max(a)-min(a))
}

d_num <- d %>% select(where(is.numeric)) %>%
  mutate(across(where(is.numeric), scale))
  
train <- runif(nrow(d_num)) < 0.75
test <- !train

f = highway_mpg ~  wheel_base + length + width + height + curb_weight + engine_size + compression_ratio

m <- lm(f, data=d_num %>% filter(train))
mdpre(summary(m))

dx <- d_num %>% filter(test)

dx <- dx %>% 
  mutate(highway_mpg_pred = predict(m, dx %>% as.data.frame()))
  
lbdr(ggplot(dx, aes(highway_mpg, highway_mpg_pred)) + geom_point() + geom_segment(aes(x=0,y=0,xend=1,yend=1)))

lbdr(ggplot(dx, aes(highway_mpg-highway_mpg_pred)) + geom_density())


lbdr(m)
