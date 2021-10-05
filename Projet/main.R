rm(list = ls())

library(tidyverse)
library(tmap)
library(tmaptools)
library(sf)
library(spData)
library(spDataLarge)

data <- read.csv("Listings.csv")
data <- as.data.frame(data)

paris <- filter(data, city=="Paris", price<= 500)





       