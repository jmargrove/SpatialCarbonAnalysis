# treatment levels enrichment planting or not
# unplanted as the intercept.
# variables {carbon map/biomass, time_since_logging, treatment, spatial effect [x, y], random effect of coop }
# add in the prior for the intercept, and treatment values.
# spatial effect in a rw2d
# one analysis has time_since_logging one has not.

?acf
?dist
require(INLA)
install.packages("INLA", repos = "")
?install.packages


node <- 1:dim(carbon)[1]

formula <- carbon ~ treatment + f(node, model = "rw2d", nrow = nrow(mat), ncol = ncol(mat) )

model <- inla(formula, data = data, family = "gaussian")