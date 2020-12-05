library(scales)

covid_cases_per_region_month_tbl %>%
  ggplot(aes(x = as.Date(paste(year, month, day, sep='-')), y = cases_per_month, color = region, fill = region)) +
  geom_line(size = 1.1, linetype = 1) +
  geom_label(aes(label =  scales::dollar(cases_per_month, 
                                           prefix = "",
                                           suffix = "")),
             nudge_x= -3, 
             size  = 3,
             color = "white",
             fontface = "italic",
             data = covid_cases_per_region_month_tbl %>% 
               filter(region %in% c("USA", "Europe") & year == 2020 & month == 12 & day == 4),
             show.legend=F) +
  scale_color_brewer(palette="Spectral") +
  scale_fill_brewer(palette="Spectral") +
  expand_limits(y = 20e6, x = as.Date("2020-12-16")) +
  scale_x_date(date_breaks = "1 month", minor_breaks = NULL, date_labels = "%B", expand = c(0,0))  +
  scale_y_continuous(labels = unit_format(unit = "M" , scale =1e-6), expand = c(0,0)) +
  
  
  labs(
    title = "COVID-19 confimed cases worldwide",
    subtitle = "As of 12/05/2020 Europe has more cases than USA",
    x = "Year 2020", # Override defaults for x and y
    y = "Cumulative Cases",
    color = "Continent/Country"
  )+
  
# Theme
theme_light() +
  theme(
    title = element_text(face = "bold", color = "#08306B"),
    axis.text.x = element_text(angle = 45, hjust = 1), legend.position="bottom", 
    plot.subtitle=element_text(size=8, face="italic", color="black"))
