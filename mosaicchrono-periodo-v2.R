## Joining periodo permalinks to an existing dataset
## MOSAICchrono
## 03/09/2024
## Léonard Dumont

# Load libraries
library(dplyr)
library(stringr)

# Loading swords dataset
swords <- read.csv("https://search-data.ubfc.fr/dl_data.php?file=154")

# Loading periodo dataset
periodo <- read.csv("https://n2t.net/ark:/99152/p0dataset.csv")

# Getting end date as numeric (and not character)
periodo_num <- periodo
periodo_num$stop <- as.numeric(periodo$stop)

# Creating a subset of periodo with chronologies from ArkeOpen
periodo_ArkeOpen <- filter(periodo_num, 
                           str_detect(source, 
                                      "^ArkeOpen"
                                      )
)

# Alternative solution for creating a subset, same result
#periodo_ArkeOpen <- filter(periodo, authority == "http://n2t.net/ark:/99152/p09hq4n")

# Create a new column 'label' to match the 'label' column in periodo
swords %>% 
  mutate(label = case_when(!is.na(Etape) ~ Etape,
                                is.na(Etape) & !is.na(Phase) ~ Phase,
                                is.na(Etape) & is.na(Phase) & !is.na(Periode) ~ Periode,
                                is.na(Etape) & is.na(Phase) & is.na(Periode) ~ "Unknown")
  ) %>% # joining both dataframes using common column 'label'
  left_join(periodo_ArkeOpen[,c("label","period")], # remove square brackets to merge all columns of periodo
             by = label) -> swords_periodo

#If the columns used to match dataframes have different names use instead:
#left_join(periodo_ArkeOpen[,c("label","period")], 
#          by = join_by(column_name == label))
