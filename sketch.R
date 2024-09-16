# Set up rasters to describe waters and mountains of Europe.

# Packages

library(tidyverse)
library(magrittr)
library(terra)

# Target

dat_target = rast(nrows = 8192, 
                  ncols = 8192, 
                  xmin = -2500000, 
                  xmax = 2500000, 
                  ymin = 0, 
                  ymax = 5000000, 
                  crs = "ESRI:102013") # Albers Europe

# Water

#  Get files, process, reproject, and export.
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
           map(magrittr::extract,
               1)) %>% 
  pull(dat) %>% 
  sprc %>% 
  merge %>% 
  project(dat_target,
          method = "min") %>% 
  subst(NA, 2) %T>% 
  writeRaster("out/water.tif", overwrite = TRUE)

# Mountains

#  Get files, reproject, and export.
dat_mountains = 
  "data/mountains/GlobalMountainsK3Classes/k3classes.tif" %>% 
  rast %>% 
  project(dat_target,
          method = "min") %T>% 
  writeRaster("out/mountains.tif", overwrite = TRUE)
