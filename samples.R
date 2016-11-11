library(e1071)
library(randomForest)
library(reshape2)

# clear workspace
rm(list=ls())

# to ensure consistency of random sets
set.seed(10765)

# my default plot preferences in a function
plotMe <- function(xvar, yvar, xdesc, ydesc, title) {
  # set default palette  for plots here
  pal <- c('lightgray', 'darkgray', 'blue')
  
  par(bty="l",
      las=1,
      bg="#F0F0F0",
      col.axis="#434343",
      col.main="#343434",
      cex=0.85,
      cex.axis=0.8)
  
  plot(0,
       xlim=c(min(xvar), max(xvar)),
       ylim=c(min(yvar), max(yvar)),
       xlab=xdesc,
       ylab=ydesc)
  grid(NULL,
       NULL, 
       col="#DEDEDE",
       lty="solid", 
       lwd=0.9)
  title(title)
  points(xvar,
         yvar,
         pch=16,
         col=pal[1])
  lines(lowess(xvar,
               yvar),
        col=pal[2])
  abline(lm(yvar~xvar),
         lty=2,
         col=pal[3])
}

# RMSE function
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# create two datasets: train and test
e <- rnorm(100,0,1)
id <- seq(1:100)
x <- rnorm(100,0,1)
y <- x * 0.7 + e
train <- data.frame(id, y,x)
outlier <- data.frame(id=c(101, 102, 103, 104,105),
                      x=c(2.0,2.3,1.5,1.9,2.2),
                      y=c(-4.0,-3.9,-4.1,-3.2,-3.5))
train <- rbind(train, outlier)

e <- rnorm(100,0,1)
x <- rnorm(100,0,1)
y <- x * 0.7 + e
test <- data.frame(id, y,x)

plotMe(train$x, train$y, 'X', 'Y', 'Training Set')
plotMe(test$x, test$y, 'X', 'Y', 'Testing Set')

# error terms data frame
resid <- data.frame(Model=NULL,
                    Desc=NULL,
                    RMSE=NULL)

# create model using MR
model <- lm(x ~ y, train)
summary(model)

# predict training set from model and estimate residuals
reg.pred <- predict(model, test)
error <- test$y - reg.pred

# add results to comparison table
resid <- rbind(resid, data.frame(Model='A', Desc='Linear Regression', RMSE=rmse(error)))

# create model using Random Forests
model <- randomForest(y ~ x,
                      data=train,
                      importance=TRUE,
                      ntree=500,
                      replace=TRUE)

# predict training set from model and estimate residuals
rf.pred <- predict(model, test)
error <- test$y - rf.pred

# add results to comparison table
resid <- rbind(resid, data.frame(Model='B', Desc='Random Forest', RMSE=rmse(error)))

# create model using SVR
model <- svm(y ~ x,
             kernel='linear',
             data=train)

# predict training set from model and estimate residuals
svr.untuned.pred <- predict(model, test)
error <- test$y - svr.untuned.pred

# add results to comparison table
resid <- rbind(resid, data.frame(Model='C', Desc='Untuned SVR', RMSE=rmse(error)))

# request a tune-up, testing sequences for epsilon and cost
tuneResult <- tune(svm, y ~ x,  data = train,
                   ranges = list(epsilon = seq(0,1,0.01), cost = 2^(2:9))
)
print(tuneResult)
plot(tuneResult)

# select best model from tuning
model <- tuneResult$best.model

# predict training set from model and estimate residuals
svr.tuned.pred <- predict(model, test)
error <- test$y - svr.tuned.pred

# add results to comparison table
resid <- rbind(resid, data.frame(Model='D', Desc='Tuned SVR', RMSE=rmse(error)))

resid