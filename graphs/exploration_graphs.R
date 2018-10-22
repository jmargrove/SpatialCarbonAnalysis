# @title inla spde analaysis 

# importing packages
source("./packages.R")
# importing data 
source("./data/organised_data.R")

ggplot(data, aes(x = x, y = y, fill = carbon)) + geom_raster() + theme_bw()
ggplot(data, aes(x = x, y = y, fill = treatment)) + geom_raster() + theme_bw()
ggplot(data, aes(x = x, y = y, fill = coupeYear)) + geom_raster() + theme_bw()


