library(tidyverse)
diamonds2 <- readRDS("01_getting_started/?diamonds2.rds")

diamonds2 %>% head(n = 5)
## # A tibble: 5 x 3
##   cut     `2008` `2009`
##   <chr>    <dbl>  <dbl>
## 1 Ideal      326    332
## 2 Premium    326    332
## 3 Good       237    333
## 4 Premium    334    340
## 5 Good       335    341