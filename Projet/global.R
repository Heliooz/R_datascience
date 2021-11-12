
## librairies utilisees ##
library(tidyverse)
library(shiny)
library(gapminder)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(tidyr)
library(broom)
library(leaflet)

## lecture du fichier csv ##
airBnB_data <- read.csv("listings.csv")

## colonnes que nous n'utilisons pas ##
airBnB_data$amenities <- NULL
airBnB_data$host_location <- NULL
airBnB_data$host_since <- NULL
airBnB_data$host_response_time <- NULL
airBnB_data$host_response_rate <- NULL
airBnB_data$host_acceptance_rate <- NULL
airBnB_data$host_total_listings_count <- NULL
airBnB_data$host_has_profile_pic <- NULL
airBnB_data$district <- NULL
airBnB_data$minimum_nights <- NULL
airBnB_data$maximum_nights <- NULL
airBnB_data$instant_bookable <- NULL