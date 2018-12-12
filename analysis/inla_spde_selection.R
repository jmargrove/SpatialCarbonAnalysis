# importing the inla function
source('./inla_function.R')


# models with decreasing cutoff values in the mesh 
model1 <- inla_function(cutoff = 1000, sig0 = 50, rho0 = 100)
summary(model1)
sum_model1 <- summary(model1)
save(sum_model1, file='./results/sum_model1.R')

model2 <- inla_function(cutoff = 500, sig0 = 50, rho0 = 100)
summary(model2)
sum_model2 <- summary(model2)
save(sum_model2, file='./results/sum_model2.R')

model3 <- inla_function(cutoff = 250, sig0 = 50, rho0 = 100)
summary(model3)
sum_model3 <- summary(model3)
save(sum_model3, file='./results/sum_model3.R')


# model 4 - starting to take 30+ mins for calculation. 
model4 <- inla_function(cutoff = 100, sig0 = 50, rho0 = 100)
summary(model4)
sum_model4 <- summary(model4)
save(sum_model4, file='./results/sum_model4.R')


# model 5 - starting @18:04. 19:00 so 1 hour to run mod
model5 <- inla_function(cutoff = 75, sig0 = 50, rho0 = 100)
sum_model5 <- summary(model5)
save(sum_model5, file='./results/sum_model5.R')

model6 <- inla_function(cutoff = 50, sig0 = 50, rho0 = 50)
summary(model6)
sum_model6 <- summary(model6)
save(sum_model6, file='./results/sum_model6.R')

model7 <- inla_function(cutoff = 30, sig0 = 30, rho0 = 30)
summary(model7)
sum_model7 <- summary(model7)
save(sum_model7, file='./results/sum_model7.R')

model8 <- inla_function(cutoff = 15, sig0 = 50, rho0 = 30)
summary(model8)
sum_model8 <- summary(model8)
save(sum_model8, file='./results/sum_model8.R')



