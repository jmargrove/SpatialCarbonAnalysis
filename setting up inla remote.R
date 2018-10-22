### testing inla remote 

require(INLA)
#install.packages("INLA", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/testing"), dep=TRUE)
set.seed(253)
x <- runif(100)
y <- x * 2 + rnorm(100, sd = 0.25)
plot(x = x, y = y, main = "play data")
data <- data.frame(x,y)
# so run inla model localy 
model <- inla(y ~ x, family = "gaussian", data = data)
summary(model)

model2 <- inla(y ~ x, family = "gaussian", data = data, inla.call = "remote")
summary(model2)


remove.packages("INLA")
options(repos = c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/testing"))
update.packages("INLA", dep=TRUE)
install.packages("Rgraphviz")
