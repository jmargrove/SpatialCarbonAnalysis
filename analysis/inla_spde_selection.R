# importing the inla function
source('./inla_function.R')


# models with decreasing cutoff values in the mesh 
#model1 <- inla_function(cutoff = 1000, sig0 = 50, rho0 = 100)
summary(model1)

#model2 <- inla_function(cutoff = 500, sig0 = 50, rho0 = 100)
summary(model2)

#model3 <- inla_function(cutoff = 250, sig0 = 50, rho0 = 100)
summary(model3)

# model4 <- inla_function(cutoff = 100, sig0 = 50, rho0 = 100)
summary(model4)


model5 <- inla_function(cutoff = 75, sig0 = 50, rho0 = 100)
summary(model5)

model6 <- inla_function(cutoff = 50, sig0 = 100, rho0 = 50)
summary(model6)
