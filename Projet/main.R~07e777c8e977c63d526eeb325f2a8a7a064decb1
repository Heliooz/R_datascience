rm(list = ls())

library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

data <- as.data.frame(read.csv("Listings.csv"))
paris <- filter(data, city=="Paris")

ggplot(paris, aes(x=longitude, y=latitude, color=neighbourhood)) + geom_point()

map_arrondissements <- as.data.frame(read_delim("arrondissements.csv", delim = ';'))
map_arrondissements <- map_arrondissements['geom']

ggplot()

test <- geojsonsf::geojson_sf(map_arrondissements)




       