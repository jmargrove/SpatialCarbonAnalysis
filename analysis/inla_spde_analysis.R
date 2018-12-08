# @title inla spde analaysis 

# importing packages
source("./packages.R")
# importing data 
source("./data/organised_data.R")

# setting up the spde model in inla 
coords <- cbind(data$x, data$y)
dim(coords)
diff(head(coords))
head(data)
30*30 * length(!is.na(data[data$treatment == "planted",]$carbon)) / 10000

length(!is.na(data$carbon))
mesh <- inla.mesh.2d(coords, max.edge = c(500, 1000), 
                     cutoff = 1000, 
                     offset=c(900, 5000))

plot(mesh)
points(coords, col = "red", pch = 19)

rho0 = 100
# this will move towards higher values of the range of the spatial effect and the P is 
# the probability that it is lower. 
sd(data$carbon)
sig0 = 60
# what is the standard deviation of trhe response, and what is the probability that the 
# actual sigma is greater than this. The lodgic is that it will shrink towards lower values. 

spde <- inla.spde2.pcmatern(mesh, alpha=2,   
                            prior.range=c(rho0,  0.05),
                            prior.sigma=c(sig0, 0.05))
                          
A <- inla.spde.make.A(mesh, loc=as.matrix(coords))
stk <- inla.stack(tag = "stk", 
                  data=list(carbon=data$carbon), 
                  A=list(A, 1), 
                  effects=list(list(i=1:spde$n.spde),
                               data.frame(int=1,
                                          coupeYear = as.factor(data$coupeYear),
                                          treatment = data$treatment)))

formula <- carbon ~ 0 + treatment + f(i, model = spde) 

model1 <- inla(formula, data = inla.stack.data(stk),
               control.predictor = list(A=inla.stack.A(stk)),
               control.fixed = list(expand.factor.strategy="inla"), family = "gaussian", 
               inla.call = "remote", num.threads = 16)

summary(model1)



