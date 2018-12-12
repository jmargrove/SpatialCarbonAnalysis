# @title inla spde analaysis 

# importing packages
source("./packages.R")
# importing data 
source("./data/organised_data.R")

inla_function <- function(cutoff, rho0, sig0) {
# setting up the spde model in inla 
  coords <- cbind(data$x, data$y)
  mesh <- inla.mesh.2d(coords, max.edge = c(500, 1000), 
                     cutoff = cutoff, 
                     offset=c(900, 5000))
  plot(mesh)
# rho0 = 100
# this will move towards higher values of the range of the spatial effect and the P is 
# the probability that it is lower. 

# sig0 = 50
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
                                          treatment = data$treatment)))

  formula <- carbon ~ 0 + treatment + f(i, model = spde) 

  model1 <- inla(formula, data = inla.stack.data(stk),
               control.predictor = list(A=inla.stack.A(stk)),
               control.fixed = list(expand.factor.strategy="inla"), family = "gaussian", 
               inla.call = "remote")

  return(model1)
}


# save(model_list, file = './results/model_list.R')
