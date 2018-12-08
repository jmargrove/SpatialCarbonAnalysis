### testing inla remote 

require(INLA)
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


