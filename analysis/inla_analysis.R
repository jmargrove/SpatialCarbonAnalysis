# treatment levels enrichment planting or not
# unplanted as the intercept.
# variables {carbon map/biomass, time_since_logging, treatment, spatial effect [x, y], random effect of coop }
# add in the prior for the intercept, and treatment values.
# spatial effect in a rw2d
# one analysis has time_since_logging one has not.

# unplanted = 42.158 -/+ 16.0517
# planted = (42.158 - 15.608) -/+ 12.049

# importing packages 
?acf
?dist

?levels
?relevel
install.packages("INLA", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
install.packages('raster', dep = TRUE)
require(INLA)
require(raster)

# importing data 
plantedCarbon <- raster("./data/PlantedAreaCarbon.tif")
unPlantedCarbon <- raster("./data/UnPlantedAreaCarbon.tif")
fullAreaCarbon <- raster("./data/FullAreaCarbon.tif")

# setting values for unplanted (1) and planted (2)
values(unPlantedCarbon)[values(unPlantedCarbon) > 0] <- 1
values(plantedCarbon)[values(plantedCarbon) > 0] <- 2
treatment <- merge(plantedCarbon, unPlantedCarbon)
plot(treatment)

# sorting raster maps to matrices 
fullAreaCarbon_matrix <- as.matrix(fullAreaCarbon)
treatment_matrix <- as.matrix(treatment)

# sorting maps for inla 
treatment_inla <- inla.matrix2vector(treatment_matrix)
fullAreaCarbon_inla <- inla.matrix2vector(fullAreaCarbon_matrix)

# prepairing data.frame 
node <- 1:length(fullAreaCarbon_inla)
data <- data.frame(carbon = fullAreaCarbon_inla, treatment = treatment_inla, node = node)
nr <-  nrow(fullAreaCarbon_matrix)
nc <- ncol(fullAreaCarbon_matrix)


# formula for model
formula <- carbon ~ 1 + treatment + f(node, model = "rw2d", nrow = nr, ncol = nc)

# running the model 
model <- inla(formula, 
              data = data, 
              family = "gaussian")

# inspecting model results 
summary(model)
