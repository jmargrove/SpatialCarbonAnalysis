#' @title Organise the data for analysis 
#' @author James margrove 
#' @description data organisation 

# Import files 
source("./data/index.R")

# setting values for unplanted (1) and planted (2)
values(unPlantedCarbon)[values(unPlantedCarbon) > 0] <- 1
values(plantedCarbon)[values(plantedCarbon) > 0] <- 10
treatment <- merge(plantedCarbon, unPlantedCarbon)
plot(treatment)


treatment_scaled <- treatment 
values(treatment_scaled )[values(treatment_scaled ) <= 5] <- 1
values(treatment_scaled )[values(treatment_scaled ) > 5] <- 10
plot(treatment_scaled)

fullAreaCarbon_scaled <- fullAreaCarbon 
plot(fullAreaCarbon_scaled)

# Sorting raster maps to matrices 
fullAreaCarbon_matrix <- as.matrix(fullAreaCarbon_scaled)
treatment_matrix <- as.matrix(treatment_scaled)
coupeYear_matrix <- as.matrix(coupeYear)

treatment_vec <- as.vector(treatment_matrix)
carbon_vec <- as.vector(fullAreaCarbon_matrix)
coupeYear_vec <- as.vector(coupeYear_matrix)

dtm <- dim(treatment_matrix)
y = rep(dtm[1]:1, times = dtm[2]) * 30
x = rep(1:dtm[2], each = dtm[1]) * 30

data <- data.frame(x = x, y = y, carbon = carbon_vec, coupeYear = coupeYear_vec, treatment = treatment_vec)
data <- data[which(!is.na(data$carbon)),]
data <- data[which(!is.na(data$treatment)),]
data$treatment[which(data$treatment == 1)] <- "unPlanted"
data$treatment[which(data$treatment == 10)] <- "planted"