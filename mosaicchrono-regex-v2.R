## Regular expressions example: getting a list of references from a dataset
## MOSAICchrono
## 03/09/2024
## Léonard Dumont

# Loading libraries
library(dplyr) # Pipe operator
library(stringr) # Text manipulation and regex
library(purrr) # Map function

# Import dataset
swords <- read.csv("https://search-data.ubfc.fr/dl_data.php?file=154")

# Process bibliography
swords$Bibliographie %>% 
  # map function applies a function to all elements of a list or a vector
  map(str_split_1, pattern = "\\s;\\s") %>% # Split strings around " ; "
  map(str_extract, pattern = "[A-Za-zÀ-ž.,\\s2]*\\s\\d{4}") %>% # Extract only author and year
  unlist() %>% # Get a vector
  na.omit() %>% # Remove NAs
  str_trim() %>% # Remove unwanted spaces
  unique() %>% # Remove duplicated
  sort() -> references # Sort and store result in a vector

# Write vector to a text file
writeLines(references, "./references.txt")
