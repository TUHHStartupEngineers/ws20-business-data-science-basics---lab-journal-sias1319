library(maps)
world <- map_data("world")

covid_mortalitly_tbl <- covid_data_tbl %>%
  group_by(countriesAndTerritories, popData2019) %>%
  summarise(deaths_per_region = sum(deaths)) %>%
  ungroup() %>%
  mutate(mortality = (deaths_per_region/popData2019)) #%>%
  #filter(countriesAndTerritories != "Yemen")

covid_world <- left_join(world,covid_mortalitly_tbl, by = c("region" = "countriesAndTerritories"))

covid_world %>% ggplot(aes(x = long, y = lat)) +
  geom_map(aes(map_id=region, fill=mortality), map = world) +
  # scale_fill_continuous(
  #   low = "red",
  #   high = "black"
  # )
  scale_fill_gradient2(
  low   = "indianred1",
  mid  = "darkred",
  high = "black",
  midpoint = 0.0011,
  labels = percent,
  limits = c(0,0.0015)) +
  labs(
    title = "Confirmed COVID-19 deaths relative to the size of the population",
    subtitle = "More than 1.2 Million confirmed deaths worldwide",
    x = "", # Override defaults for x and y
    y = ""
  ) + 
  theme(
    title = element_text(face = "bold", color = "#08306B"),
    plot.subtitle=element_text(size=8, face="italic", color="black"),
)