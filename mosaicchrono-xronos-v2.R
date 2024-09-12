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
  filter(str_detect(periods, "[Bb]ronze")) -> fr_ba

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
  mutate(lat = as.numeric(lat), lng = as.numeric(lng)) %>% # convert lat and lng columns to numeric
  st_as_sf(coords = c("lng", "lat"), crs = 4326) %>% # create a sf object
  st_transform(crs = 3035) -> fr_ba_sf # change coordinates system

library(ggspatial) # For scale and north arrow on map

# Plotting with ggplot2
ggplot()+
  # Plot France boundaries
  geom_sf(data = france, linewidth = .5, color = "black", fill = "white")+
  # Plot points of 14C dates with fill color and point shape according to material
  geom_sf(data = fr_ba_sf, aes(fill = material, shape = material))+
  # Defining point shapes
  scale_shape_manual(values = 21:25)+
  # Defining point fill colors
  scale_fill_manual(values = c("red","blue","black","green","yellow"))+
  annotation_scale(location = "bl")+# scale bottom left
  annotation_north_arrow(location = "tr",
                         height = unit(1, "cm"),
                         width = unit(0.8, "cm"))+ # north arrow top right
  # Define plot limits
  coord_sf(xlim = c(3150000, 4350000), 
           ylim = c(2000000, 3200000), 
           expand = FALSE)+
  # Simple black and white theme
  theme_bw()

ggsave("./map_14C_France.png", plot = last_plot(), device = "png",
       width = 20, height = 18, units = "cm", dpi = 300)
