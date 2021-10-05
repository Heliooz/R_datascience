rm(list = ls())

library(tidyverse)

data <- read.csv("Listings.csv")

data <- as.data.frame(data)
paris <- filter(data, city=="Paris", price<= 500)

ggplot(paris, aes(x = price)) + geom_histogram()


       