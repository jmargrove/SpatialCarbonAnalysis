# treatment levels enrichment planting or not
# unplanted as the intercept.
# variables {carbon map/biomass, time_since_logging, treatment, spatial effect [x, y], random effect of coop }
# add in the prior for the intercept, and treatment values.
# spatial effect in a rw2d
# one analysis has time_since_logging one has not.

# unplanted = 42.158 -/+ 16.0517
# planted = (42.158 - 15.608) -/+ 12.049

# importing packages 
require(INLA)
require(raster)

# importing data 
plantedCarbon <- raster("./data/PlantedAreaCarbon.tif")
unPlantedCarbon <- raster("./data/UnPlantedAreaCarbon.tif")
fullAreaCarbon <- raster("./data/FullAreaCarbon.tif")

# setting values for unplanted (1) and planted (2)
values(unPlantedCarbon)[values(unPlantedCarbon) > 0] <- 1
values(plantedCarbon)[values(plantedCarbon) > 0] <- 10
treatment <- merge(plantedCarbon, unPlantedCarbon)
plot(treatment)

treatment_scaled <- aggregate(treatment, fact = 20, FUN = mean)
values(treatment_scaled )[values(treatment_scaled ) <= 5] <- 1
values(treatment_scaled )[values(treatment_scaled ) > 5] <- 10
plot(treatment_scaled)

fullAreaCarbon_scaled <- aggregate(fullAreaCarbon, fact = 20, FUN = mean)
plot(fullAreaCarbon_scaled)

# sorting raster maps to matrices 
fullAreaCarbon_matrix <- as.matrix(fullAreaCarbon_scaled)
treatment_matrix <- as.matrix(treatment_scaled)



# sorting maps for inla 
treatment_inla <- inla.matrix2vector(treatment_matrix)
fullAreaCarbon_inla <- inla.matrix2vector(fullAreaCarbon_matrix)

# prepairing data.frame 
node <- 1:length(fullAreaCarbon_inla)
data <- data.frame(carbon = fullAreaCarbon_inla, treatment = treatment_inla, node = node)

with(data, tapply(carbon, treatment, mean, na.rm = T))
data$treatment[which(data$treatment == 1)] <- "unPlanted"
data$treatment[which(data$treatment == 10)] <- "planted"

nr <-  nrow(fullAreaCarbon_matrix)
nc <- ncol(fullAreaCarbon_matrix)

# formula for model
formula <- carbon ~ 0 + treatment + f(node, model = "rw2d", nrow = nr, ncol = nc, scale.model = TRUE)

# running the model 
model <- inla(formula, 
              data = data, 
              family = "gaussian")

# inspecting model results 
summary(model)
