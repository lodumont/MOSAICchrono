## Regular expressions example: getting a list of references from a dataset
## MOSAICchrono
## 03/09/2024
## Léonard Dumont

library(dplyr)
library(stringr)
library(purrr)

swords <- read.csv("https://search-data.ubfc.fr/dl_data.php?file=154")

swords$Bibliographie %>% 
  map(str_split_1, pattern = "\\s;\\s") %>% 
  map(str_extract, pattern = "[A-Za-zÀ-ž.,\\s2]*\\s\\d{4}") %>% 
  unlist() %>%
  na.omit() %>% 
  str_trim() %>% 
  unique() %>% 
  sort() -> references

writeLines(references, "./references.txt")
