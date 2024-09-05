## Retrieveing 14C data from XRONOS
## MOSAICchrono
## 05/09/2024
## Léonard Dumont

library(xronos)
library(dplyr)
library(stringr)
library(tidyr)

## XRONOS data

fr <- chron_data(country = "France",
                 material = c("wood","charcoal","bone","antler","seed/fruit"))
fr %>% 
  unnest(periods) %>% 
  filter(str_detect(periods, "Bronze")) -> fr_ba

## Plotting

library(rnaturalearth)
library(sf)
library(ggplot2)

# Retrieving France boundaries

ne_countries(country = "france", scale = "large") %>% 
  st_transform(crs = 3035) -> france

# Preparing the XRONOS dataset for mapping
fr_ba %>% 
  drop_na(c("lat","lng")) %>% # remove rows with undefined coordinates
  mutate(lat = as.numeric(lat)) %>% # convert lat and lng columns to numeric
  mutate(lng = as.numeric(lng)) %>% 
  st_as_sf(coords = c("lng", "lat"), crs = 4326) %>% # create a sf object
  st_transform(crs = 3035) -> fr_ba_sf # change coordinates system

# Plotting with ggplot2
ggplot()+
  # Plot France boundaries
  geom_sf(data = france, linewidth = .5, color = "black", fill = "white")+
  # Plot points of 14C dates
  geom_sf(data = fr_ba_sf)+ # aes(fill = material), shape = 21
  # Define plot limits
  coord_sf(xlim = c(3150000, 4350000), 
           ylim = c(2000000, 3200000), 
           expand = FALSE)+
  # Simple black and whiote theme
  theme_bw()
