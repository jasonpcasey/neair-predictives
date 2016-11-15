library(rpart)
library(rpart.plot)
library(rattle)

fit <- rpart(mpg~., data=mtcars, method='anova')

plot(fit)
text(fit)

fancyRpartPlot(fit)

plot(mtcars$cyl, mtcars$hp,
     xlim=c(4,8),
     ylim=c(50,350))
abline(v=5,lty=2,col="blue")
abline(h=192.5,lty=2,col="blue")
rect(xleft=5,
     xright=8,
     ybottom=50,
     ytop=350,
     col='lightblue')

#text(c(7, 25), 'mpg = 26.66', cex=0.6, pos=4, col="red")

# rect(xleft, ybottom, xright, ytop, density = NULL, angle = 45,
#      col = NA, border = NULL, lty = par("lty"), lwd = par("lwd"),
#      ...)

summary(fit)
