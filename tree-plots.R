library(rpart)
library(rpart.plot)
library(rattle)

fit <- rpart(mpg~., data=mtcars, method='anova')

plot(fit)
text(fit)

fancyRpartPlot(fit)

summary(fit)
