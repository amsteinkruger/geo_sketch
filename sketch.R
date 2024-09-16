# Set up rasters to describe waters and mountains of Europe.

# Packages

install.packages("terra")
install.packages("tidyverse")

library(terra)
library(dplyr)
library(magrittr)
library(stringr)
library(purrr)

# Water

#  Get files.
dat_water = 
  "data/water" %>% 
  list.files %>% 
  tibble %>% 
  rename("file" = ".") %>% 
  filter(str_sub(file, -3, -1) != "xml") %>% 
  mutate(dat = 
           file %>% 
           paste0("data/water/", .) %>% 
           map(sds) %>%
           map(extract,
               1)) %>% 
  pull(dat) %>% 
  sprc %>% 
  merge

#  Crop to region of interest.

#  Reproject to suit region.

#  Rescale. 

#  Export.

# Mountains


