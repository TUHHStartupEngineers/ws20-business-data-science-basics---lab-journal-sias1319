library(tidyverse)
covid_data_tbl <- read_csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv") %>% 
  mutate(across(countriesAndTerritories, str_replace_all, "_", " ")) %>%
  mutate(countriesAndTerritories = case_when(
    
    countriesAndTerritories == "United Kingdom" ~ "UK",
    countriesAndTerritories == "United States of America" ~ "USA",
    countriesAndTerritories == "Czechia" ~ "Czech Republic",
    TRUE ~ countriesAndTerritories))

covid_cases_per_country_month_tbl <- covid_data_tbl %>% 
  group_by(countriesAndTerritories) %>% 
  arrange(year,month,day) %>%
  summarise(cases_per_month = cumsum(cases), year = year, month = month, day = day) %>% 
  ungroup() %>% 
  filter(countriesAndTerritories %in% c("Germany", "UK", "France", "Spain", "USA" )) %>% 
  rename(region = countriesAndTerritories)

covid_cases_eur_per_month_tbl <- covid_data_tbl %>% 
  group_by(continentExp, year, month, day) %>% 
  summarise(cases_per_continent = sum(cases)) %>%
  ungroup()  %>%
  group_by(continentExp) %>%
  arrange(year,month,day) %>%
  summarise(cases_per_month = cumsum(cases_per_continent), year = year, month = month, day = day) %>%
  ungroup() %>%
  filter(continentExp == "Europe") %>%
  rename(region = continentExp)

covid_cases_per_region_month_tbl <- bind_rows(covid_cases_eur_per_month_tbl, covid_cases_per_country_month_tbl) %>%
  filter(year==2020) 