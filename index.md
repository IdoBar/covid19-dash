---
title: "Current Status of the Novel Corona Virus (Covid19) Pandemic Outbreak"
output: 
  flexdashboard::flex_dashboard:
    theme: flatly
    vetical_layout: fill
    orientation: rows
    social: [ "menu" ]
    source_code: "https://github.com/IdoBar/covid19-dash"

---



Row {data-height=100}
-----------------------------------------------------------------------

### Total Confirmed Cases


```r
valueBox(scales::comma(sum(latest_data$Confirmed, na.rm=TRUE)), icon = "fa-procedures", color="warning") # ion-fitness-outline fa-biohazard ion-medkit-outline ion-ios-medkit-outline
```

<!--html_preserve--><span class="value-output" data-icon="fa-procedures" data-color="bg-warning">167,449</span><!--/html_preserve-->

### Total Recovered Cases


```r
valueBox(scales::comma(sum(latest_data$Recovered, na.rm=TRUE)), icon = "ion-android-favorite-outline", color="success") # fa-briefcase-medical ion-ios-heart-outline
```

<!--html_preserve--><span class="value-output" data-icon="ion-android-favorite-outline" data-color="bg-success">76,034</span><!--/html_preserve-->

### Total Deaths


```r
valueBox(scales::comma(sum(latest_data$Deaths, na.rm=TRUE)), icon = "ion-heart-broken", color="danger") # ion-skull-outline, ion-pulse, 
```

<!--html_preserve--><span class="value-output" data-icon="ion-heart-broken" data-color="bg-danger">6,440</span><!--/html_preserve-->


### Mean Mortality Rate


```r
mort_rate <- sum(latest_data$Deaths, na.rm=TRUE)/sum(latest_data$Confirmed, na.rm=TRUE)
gauge(scales::number(mort_rate*100, accuracy = .01), min = 0, max = 20, symbol = '%', gaugeSectors(
  success = c(0, 2), warning = c(2, 5), danger = c(5,100)
))
```

```
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

```
## Warning in normalizePath(path.expand(path), winslash, mustWork): path[1]="webshot3a50704b17b9.png": The system cannot find the file
## specified
```

```
## Warning in file(con, "rb"): cannot open file 'C:\Users\IDOBAR~1\AppData\Local\Temp\RtmpOgPgEJ\file3a5077b47b1\webshot3a50704b17b9.png':
## No such file or directory
```

```
## Error in file(con, "rb"): cannot open the connection
```

```r
# valueBox(scales::percent(mort_rate), icon = "ion-alert", 
#          color=case_when(mort_rate>=0.03 ~ "danger", 
#                          mort_rate>=0.02 & mort_rate<0.03~ "warning", 
#                          mort_rate<0.02 ~"success")) # fa-briefcase-medical ion-ios-heart-outline ion-ios-information-outline ion-alert
```

Row {.tabset .tabset-fade}
-------------------------------------

### Map 


```r
confirmed_cases_latest <- latest_data %>% filter(Confirmed>0) %>% 
  mutate(name= ifelse(is.na(`Province/State`),`Country/Region`, glue::glue('{`Province/State`} ({`Country/Region`})')),
         log_confirmed=log10(Confirmed),
         popup_text=glue::glue('Province/Country: {name}<br/>Confirmed cases: {kableExtra::text_spec(scales::comma(Confirmed), background  = "gold")}<br/>Confirmed deaths: {kableExtra::text_spec(scales::comma(Deaths), background  = "orangered", color="white")} ({scales::percent(Deaths/Confirmed, accuracy=.1)})<br/>Confirmed recovered: {kableExtra::text_spec(scales::comma(Recovered), background  = "limegreen")}') %>% 
           map(~HTML(.x)))  #%>% select(name,lat=  Lat, lon= Long, z=Confirmed)
# Create the leaflet map
leaflet(confirmed_cases_latest) %>% addProviderTiles(providers$CartoDB.Positron) %>% # Esri.WorldStreetMap providers$CartoDB.Positron
  setView(lng = 72.1193378, lat = 9.5361877, zoom = 2) %>% # 16.7432979,29.195003,3z
  addCircles(radius = ~(sqrt(Confirmed)*2500+50000), fillColor="#ff3030", stroke=FALSE, fillOpacity = 0.7,
                   label = ~popup_text, labelOptions = labelOptions(textOnly = FALSE, textsize = "12px")) %>% 
  # addMarkers(popup = ~Name, label = ~Name, 
  #            icon = emojiIcons) %>% 
  addScaleBar(position = "bottomright",
              options = scaleBarOptions(imperial = FALSE)) %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom out",
    onClick=JS("function(btn, map){ map.setZoom(3); }"))) %>%
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Locate Me",
    onClick=JS("function(btn, map){ map.locate({setView: true, maxZoom: 6}); }"))) # flyTo
```

```
## Assuming "Long" and "Lat" are longitude and latitude, respectively
```

```
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

```
## Warning in normalizePath(path.expand(path), winslash, mustWork): path[1]="webshot3a5020ff46c8.png": The system cannot find the file
## specified
```

```
## Warning in file(con, "rb"): cannot open file 'C:\Users\IDOBAR~1\AppData\Local\Temp\RtmpOgPgEJ\file3a50d69599\webshot3a5020ff46c8.png':
## No such file or directory
```

```
## Error in file(con, "rb"): cannot open the connection
```

```r
# hcmap("custom/world-palestine-highres", showInLegend = FALSE, fillcolour="#ff3030") %>% 
#   hc_add_series(data = confirmed_cases_latest, fillcolour="#ff3030",
#                 type = "mapbubble", name = "Confirmed Cases", maxSize = '15%') %>% 
#   hc_mapNavigation(enabled = TRUE) %>% 
#   hc_title(text = "Number of confirmed Covid19 cases by Province/State",
#            margin = 40, align = "left",
#            style = list(color = "#2b908f", useHTML = TRUE)) %>% 
#   hc_subtitle(text = glue::glue("Data last updated on {format(max(latest_data$Date), '%d/%m/%Y')}"),
#               align = "left",
#               style = list(color = "#2b908f", fontWeight = "bold")) %>% 
#   hc_exporting(enabled = TRUE) # enable exporting option
```

> Number of confirmed Covid19 cases by Province/Country (last updated on 15/03/2020)

<!-- ### Map -->

<!-- ```{r confirmed_map} -->
<!-- confirmed_cases_latest <- latest_data %>% filter(Confirmed>0) %>%  -->
<!--   mutate(name= ifelse(is.na(`Province/State`),`Country/Region`, glue::glue('{`Province/State`} ({`Country/Region`})')), -->
<!--          log_confirmed=log(Confirmed)) %>% select(name,lat=  Lat, lon= Long, z=Confirmed) -->
<!-- hcmap("custom/world-palestine-highres", showInLegend = FALSE, fillcolour="#ff3030") %>%  -->
<!--   hc_add_series(data = confirmed_cases_latest, fillcolour="#ff3030", -->
<!--                 type = "mapbubble", name = "Confirmed Cases", maxSize = '15%') %>%  -->
<!--   hc_mapNavigation(enabled = TRUE) %>%  -->
<!--   hc_title(text = "Number of confirmed Covid19 cases by Province/State", -->
<!--            margin = 40, align = "left", -->
<!--            style = list(color = "#2b908f", useHTML = TRUE)) %>%  -->
<!--   hc_subtitle(text = glue::glue("Data last updated on {format(max(latest_data$Date), '%d/%m/%Y')}"), -->
<!--               align = "left", -->
<!--               style = list(color = "#2b908f", fontWeight = "bold")) %>%  -->
<!--   hc_exporting(enabled = TRUE) # enable exporting option -->
<!-- ``` -->

### Current Status Summary Table

<!-- #### Current status of the Covid19 pandemic (updated on Mon Mar 16 22:01:36 2020) -->


```r
tab_caption <- glue::glue("Current status of the Covid19 pandemic (data updated on {format(max(latest_data$Date), '%d/%m/%Y')})")
latest_data %>% group_by(`Country/Region`) %>% summarise_at(c("Confirmed", "Deaths", "Recovered"), ~sum(.)) %>%  
  mutate(Mortality_rate=Deaths/Confirmed) %>% 
  arrange(desc(Confirmed)) %>% 
  # select(`Country/Region`, Confirmed, Deaths, Recovered, Mortality_rate) %>% 
  # mutate_at(c("Confirmed", "Deaths", "Recovered"), scales::comma) %>% 
  # mutate(Mortality_rate=scales::percent(Mortality_rate, accuracy = .01)) %>% 
  DT::datatable(., colnames = c("Mortality Rate"="Mortality_rate"), rownames = FALSE, 
                style = 'bootstrap', class = 'table-bordered table-condensed', 
                caption = tab_caption,# 
                options = list(pageLength = 15,
                columnDefs = list(list(className = 'dt-center', targets = 1:4)))
                ) %>% formatStyle('Mortality Rate',
  backgroundColor = styleInterval(c(0.01,0.04,0.07), c('limegreen',NA, 'gold', 'orangered'))) %>%  # 'orange', 'orangered', 'firebrick'
  formatPercentage("Mortality Rate", digits = 2) %>% formatRound(c("Confirmed", "Deaths", "Recovered"), digits = 0)
```

```
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

```
## Warning in normalizePath(path.expand(path), winslash, mustWork): path[1]="webshot3a504a8d6c80.png": The system cannot find the file
## specified
```

```
## Warning in file(con, "rb"): cannot open file 'C:
## \Users\IDOBAR~1\AppData\Local\Temp\RtmpOgPgEJ\file3a50588b314c\webshot3a504a8d6c80.png': No such file or directory
```

```
## Error in file(con, "rb"): cannot open the connection
```

### Disease Progress timeline

```r
cases_by_country <- covid_data_csse %>% filter(Confirmed>0) %>% group_by(`Country/Region`, Date) %>% 
 summarise_at(c("Confirmed", "Deaths", "Recovered"), ~sum(., na.rm=TRUE)) %>%  
  ungroup() %>%  group_by(Date) %>% 
  mutate(Mortality_rate=ifelse(Confirmed==0, 0, Deaths/Confirmed),
         rank = min_rank(desc(Confirmed+runif(n())))*1 ) %>% ungroup() %>% filter(rank <= 15)
p <- ggplot(cases_by_country, aes(x=rank, group=`Country/Region`)) + theme_classic(base_size = 18) +
  geom_tile(aes(y=sqrt(Confirmed)/2, height=sqrt(Confirmed), width=0.8), fill="orangered") +
  geom_tile(aes(y=sqrt(Deaths)/2, height=sqrt(Deaths), width=0.8), fill="black", alpha=0.7) +
  geom_text(aes(y = 0, label = paste(`Country/Region`, " ")), vjust = 0.2, hjust = 1) +
  geom_text(aes(y = sqrt(Confirmed),
                label = glue::glue('{scales::comma(Confirmed)} ({Deaths})')), hjust = 0, nudge_y = 5 ) +

  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = NULL, limits = c(0, sqrt(max(cases_by_country$Confirmed))*1.4)) +
  # scale_y_sqrt(labels = scales::comma) +
  scale_x_reverse() +

  labs(title='Number of confirmed cases and deaths as of {closest_state}', x = "", y = "Confirmed Covid19 cases and deaths\n (square-root scale)") +
  theme(plot.title = element_text(hjust = 0, size = 22),
        axis.ticks.y = element_blank(),  # These relate to the axes post-flip
        axis.text.y  = element_blank(),  # These relate to the axes post-flip
        plot.margin = margin(1,1,1,4, "cm")) +

  transition_states(Date, transition_length = 4, state_length = 1) +
  enter_grow() +  exit_fade() + 
  ease_aes('linear')
  # ease_aes('cubic-in-out')

# animate(p, fps = 25, duration = 20, width = 800, height = 600, end_pause = 10)
```


### Data Sources

The information presented here is sourced from data collected from a range of sources by the Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE) and hosted on their [GitHub repository](https://github.com/CSSEGISandData/COVID-19).

This site was compiled on Mon Mar 16 22:01:37 2020 from data last updated on 15/03/2020.



