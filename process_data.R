library(tidyverse)
library(dplyr)
library(knitr)
library(stringr)
library(lubridate)
library(janitor)
library(kableExtra)
library(fs)
library(foreign)

jack <- read_csv("jack.csv")%>% 
  filter(district != "sen", district != "gov")

polldata <- dir_ls("~/R/ps_7_starter/2018-live-poll-results-master/data/")

upshot <- map_dfr(polldata, read_csv, .id="name") %>% 
  separate(name, c("directory","2","live","unneeded","results","poll","district","wavenum"),sep="-")%>% 
  separate(district,c("state","district"),sep=2) %>% 
  separate(wavenum,c("wave","csv"),sep=1)%>% 
  select(state,district,wave,response,ager,educ,race_eth,gender,approve)%>% 
  filter(!str_detect(district,"sen"),!str_detect(district,"gov"),wave==3) 

upshot$state <- str_to_upper(upshot$state)
upshot <- upshot %>% 
  unite("district", c("state", "district"), sep="-")
jack <- jack %>% 
  unite("district", c("state", "district"), sep="-")

joined <- left_join(upshot, jack)

joined
