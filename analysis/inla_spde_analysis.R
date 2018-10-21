?rm
rm(list = ls())
require(INLA)
require(raster)
require(ggplot2)

# importing data 
plantedCarbon <- raster("./data/PlantedAreaCarbon.tif")
unPlantedCarbon <- raster("./data/UnPlantedAreaCarbon.tif")
fullAreaCarbon <- raster("./data/FullAreaCarbon.tif")
coupeYear <- raster("./data/CoupeYear.tif")


# setting values for unplanted (1) and planted (2)
values(unPlantedCarbon)[values(unPlantedCarbon) > 0] <- 1
values(plantedCarbon)[values(plantedCarbon) > 0] <- 10
treatment <- merge(plantedCarbon, unPlantedCarbon)
plot(treatment)
5+1+5 * 30
treatment_scaled <- treatment#aggregate(treatment, fact = 5, FUN = mean)
values(treatment_scaled )[values(treatment_scaled ) <= 5] <- 1
values(treatment_scaled )[values(treatment_scaled ) > 5] <- 10
plot(treatment_scaled)
?aggregate
fullAreaCarbon_scaled <- fullAreaCarbon #aggregate(fullAreaCarbon, fact = 5, FUN = mean)
plot(fullAreaCarbon_scaled)

# sorting raster maps to matrices 
fullAreaCarbon_matrix <- as.matrix(fullAreaCarbon_scaled)
treatment_matrix <- as.matrix(treatment_scaled)
coupeYear_matrix <- as.matrix(coupeYear)

dim(treatment_matrix)
dim(fullAreaCarbon_matrix)

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

x <- with(data, tapply(carbon, as.factor(coupeYear), mean))
y <- with(data, tapply(coupeYear, as.factor(coupeYear), mean))

ggplot(data, aes(x = x, y = y, fill = carbon)) + geom_raster() + theme_bw()
ggplot(data, aes(x = x, y = y, fill = treatment)) + geom_raster() + theme_bw()
ggplot(data, aes(x = x, y = y, fill = coupeYear)) + geom_raster() + theme_bw()
ggplot(data, aes(x = x, y = y, fill = logged)) + geom_raster() + theme_bw()

coords <- cbind(data$x, data$y)
mesh <- inla.mesh.2d(coords, max.edge = c(1000, 2000), 
                     cutoff = 1000, 
                     offset=c(900, 5000))

plot(mesh)
points(coords, col = "red", pch = 19)

rho0 = 500
# this will move towards higher values of the range of the spatial effect and the P is 
# the probability that it is lower. 
sd(data$carbon)
sig0 = 60
# what is the standard deviation of trhe response, and what is the probability that the 
# actual sigma is greater than this. The lodgic is that it will shrink towards lower values. 

spde <- inla.spde2.pcmatern(mesh, alpha=2,   
                            prior.range=c(rho0,  NA),
                            prior.sigma=c(sig0, 0.05))
                          
A <- inla.spde.make.A(mesh, loc=as.matrix(coords))
stk <- inla.stack(tag = "stk", 
                  data=list(carbon=data$carbon), 
                  A=list(A, 1), 
                  effects=list(list(i=1:spde$n.spde),
                               data.frame(int=1,
                                          coupeYear = as.factor(data$coupeYear),
                                          treatment = data$treatment)))

formula <- carbon ~ 0 + treatment + f(i, model = spde) + f(coupeYear, model = 'iid')
model1 <- inla(formula, data = inla.stack.data(stk),
               control.predictor = list(A=inla.stack.A(stk)),
               control.fixed = list(expand.factor.strategy="inla"), family = "gaussian")

summary(model1)
