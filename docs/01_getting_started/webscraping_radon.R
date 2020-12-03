# WEBSCRAPING ----

# 1.0 LIBRARIES ----

library(tidyverse) # Main Package - Loads dplyr, purrr, etc.
library(rvest)     # HTML Hacking & Web Scraping
library(xopen)     # Quickly opening URLs
library(jsonlite)  # converts JSON files to R objects
library(glue)      # concatenate strings
library(stringi)   # character string/text processing
library(furrr)     # multicore usage
# 1.1 COLLECT PRODUCT FAMILIES ----

url_home          <- "https://www.radon-bikes.de/en/"

# Read in the HTML for the entire webpage
html_home         <- read_html(url_home)

# Web scrape the ids for the families
radon_family_tbl <- html_home %>%
  
  # Get the nodes for the families ...
  html_nodes(css = ".a-panel--light") %>%
  html_nodes(css = ".a-button--margin-top-small") %>%
  html_attr('href') %>%
  
  # Convert vector to tibble
  enframe(name = "position", value = "subdirectory") %>%
  
  #filter other urls
  filter(!(subdirectory %>% str_detect("www."))) %>%

  # Add the domain, because we will get only the subdirectories
   mutate(
    url = glue("https://www.radon-bikes.de{subdirectory}")
  ) %>%

  # Some categories are listed multiple times.
  # We only need unique values
  distinct(url)


radon_family_tbl

#function for bike dubcategories
get_bike_data_sub_category <- function(url) {
  sub_node <- read_html(url) %>%
    
  #Check for link to subcategory
  html_nodes(css = ".m-teaser-grid__linkcontainer") %>%
  html_attr('href') %>%
  
  # Convert vector to tibble
  enframe(name = "position", value = "subdirectory") %>%
  mutate(
      url = glue("https://www.radon-bikes.de{subdirectory}")
    ) %>%
    
    # Some categories are listed multiple times.
    # We only need unique values
  distinct(url)
  
  if (dim(sub_node)[1] != 0)
    return (sub_node)
  else
    return (tibble(url))
}

#check if subcategories work

sub_node <- get_bike_data_sub_category(radon_family_tbl$url[1])
sub_node
sub_node <- get_bike_data_sub_category(radon_family_tbl$url[2])
sub_node

get_bike_data_url<- function(url) {
  print(url)
  # All bikes are under bikegrid
  all_bike_html <- glue("{url}bikegrid/")
  bike_url <- read_html(all_bike_html) %>%
    
    #Only bikes gave gears
    html_nodes(css = ".gearhub-1") %>%
    html_nodes(css = "a") %>%
    html_attr('href') %>%
    # 
    # Convert vector to tibble
    enframe(name = "position", value = "subdirectory") %>%
    mutate(
      url = glue("https://www.radon-bikes.de{subdirectory}")
    ) %>%
    
    # Some categories are listed multiple times.
    # We only need unique values
    distinct(url)
  return (bike_url)
}

bike_data_url <- get_bike_data_url("https://www.radon-bikes.de/en/mountainbike/hardtail/")
bike_data_url

get_bike_data <-function(url, category) {
  print(url)
  bike_html <- read_html(url)
  bike_name <- 
    bike_html %>%
    
    #Only bikes gave gears
    html_node(css = ".a-heading--medium") %>%
    html_text()
  
  bike_descr_text <- bike_html %>%
    
    #Only bikes gave gears
    html_node(css = ".a-paragraph--bigger") %>%
    html_text()
  
  bike_script_text <- bike_html %>%
    
    #Only bikes gave gears
    html_nodes(css = ".mod-bikedetail") %>%
    
    #get first script node
    html_node(css = "script") %>%
    html_text()
  
  
  available <- stringr::str_extract(bike_script_text, "availability.*?\\{.*?\\}") %>%
    str_detect("true")
  price <- stringr::str_match(bike_script_text, "eur.*?price.*?(\\d+)")
  price <- price[2]
  
    
  return (tibble(name =  bike_name,category = category, available = available, price = as.numeric(price), descr = bike_descr_text, url = url))
}

bike_data <- get_bike_data("https://www.radon-bikes.de/en/mountainbike/hardtail/jealous/jealous-80-2021/", "a")

get_bike_data_per_cat <- function(url) {
  category <- url %>%
    str_replace(url_home,"") %>%
    str_replace("/","")
  url_per_subcat_vec <- get_bike_data_sub_category(url) %>% pull(url)
  url_per_bike <- url_per_subcat_vec %>% map(get_bike_data_url) %>% bind_rows %>% pull(url)

  bike_data_cat_list <- url_per_bike %>% map(get_bike_data, category = category)
  return (bind_rows(bike_data_cat_list))
}


#plan("multiprocess")
radon_bike_lst <- radon_family_tbl %>% pull(url) %>% map(get_bike_data_per_cat)
radon_bike_tbl <- radon_bike_lst %>% bind_rows()



