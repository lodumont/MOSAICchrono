## Joining periodo permalinks to an existing dataset
## MOSAICchrono
## 03/09/2024
## Léonard Dumont

library(dplyr)
library(stringr)

# Loading swords dataset
swords <- read.csv("https://search-data.ubfc.fr/dl_data.php?file=154")

# Loading periodo dataset
periodo <- read.csv("https://n2t.net/ark:/99152/p0dataset.csv")

## Creating a subset of the periodo dataset with relevant chronology
periodo_CCWE <- filter(periodo, 
                       str_detect(spatial_coverage, 
                                  "^Parts of central continental western Europe")
)

# Create a new column 'label' to match the 'label' column in periodo
swords %>% 
  mutate(label = case_when(!is.na(Etape) ~ Etape,
                                is.na(Etape) & !is.na(Phase) ~ Phase,
                                is.na(Etape) & is.na(Phase) & !is.na(Periode) ~ Periode,
                                is.na(Etape) & is.na(Phase) & is.na(Periode) ~ "Unknown")
  ) %>% # joining both dataframes using common column 'label'
  inner_join(periodo_CCWE, by = "label") -> swords_periodo


