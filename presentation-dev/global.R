library(shiny)
library(shinydashboard)
library(e1071)
library(randomForest)
library(rpart)
library(party)

# pal <- c('lightgray', 'darkblue', 'red')
# 
# def <- par(bty="l",
#            las=1,
#            bg="#F0F0F0",
#            col.axis="#434343",
#            col.main="#343434",
#            cex=0.85,
#            cex.axis=0.8)

regressMod <- function(dat) {
  return(lm(overall ~ .,
            data=dat))
}

svrMod <- function(dat,
                   gamma=0.25,
                   cost=1,
                   epsilon=0.1,
                   kernel='radial') {
  return(svm(overall ~ .,
             data = dat,
             kernel=kernel,
             gamma = gamma,
             cost = cost,
             epsilon=epsilon))
}

treeMod <- function(dat, method) {
  return(ctree(overall ~ .,
               data = dat#,
               #method=method
               ))
}

rfMod <- function(dat,
                  trees=1000,
                  vars=4) {
  return(randomForest(overall ~ .,
                      data=dat,
                      importance=TRUE,
                      ntree=trees,
                      mtry=vars,
                      replace=TRUE))
}

plotMe <- function(xvar, yvar, xdesc, ydesc, title) {
  # set default palette  for plots here
  pal <- c('orange', 'darkblue', 'blue')
  
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

rmse <- function(error) {
  sqrt(mean(error^2))
}

rsq <- function(error, y) {
  1 - (mean(error^2)/var(y))
}

svr.example <- read.table(file='../data/nonlin.csv',
                          header=TRUE,
                          sep=",",
                          quote="\"",
                          skip=0,
                          row.names=NULL)


training.data <- read.table(file='../data/trainSet.csv',
                            header=TRUE,
                            sep=",",
                            quote="\"",
                            skip=0,
                            row.names=NULL)

testing.data <- read.table(file='../data/testSet.csv',
                            header=TRUE,
                            sep=",",
                            quote="\"",
                            skip=0,
                            row.names=NULL)


lr <- regressMod(training.data)
tr <- treeMod(training.data,'anova')
svu <- svrMod(training.data,0.1,1,0.1,'linear')
svt <- svrMod(training.data, 0.05, 1, 0.2, 'linear')
rf <- rfMod(training.data, 4000, 4)

predlr <- predict(lr, testing.data)
predtr <- predict(tr, testing.data)
predsvu <- predict(svu, testing.data)
predsvt <- predict(svt, testing.data)
predrf <- predict(rf, testing.data)

reg.model.compare <- data.frame(Model=NULL,
                                Training.Rsq=NULL,
                                Testing.Rsq=NULL,
                                RMSE=NULL)

error <- testing.data$overall - predlr
reg.model.compare <- rbind(reg.model.compare,
                           data.frame(Model='Linear Regression',
                                      Training.Rsq=summary(lr)$r.squared,
                                      Testing.Rsq=rsq(error, testing.data$overall),
                                      RMSE=rmse(error)))

error <- testing.data$overall - predtr
train.error <- training.data$overall - predict(tr, training.data)
reg.model.compare <- rbind(reg.model.compare,
                           data.frame(Model='Regression Tree',
                                      Training.Rsq=rsq(train.error, training.data$overall),
                                      Testing.Rsq=rsq(error, testing.data$overall),
                                      RMSE=rmse(error)))

error <- testing.data$overall - predrf
reg.model.compare <- rbind(reg.model.compare,
                           data.frame(Model='Random Forest',
                                      Training.Rsq=mean(rf$rsq),
                                      Testing.Rsq=rsq(error, testing.data$overall),
                                      RMSE=rmse(error)))

error <- testing.data$overall - predsvu
train.error <- training.data$overall - predict(svu, training.data)
reg.model.compare <- rbind(reg.model.compare,
                           data.frame(Model='Support Vector Regression (Untuned)',
                                      Training.Rsq=rsq(train.error, training.data$overall),
                                      Testing.Rsq=rsq(error, testing.data$overall),
                                      RMSE=rmse(error)))

error <- testing.data$overall - predsvt
train.error <- training.data$overall - predict(svt, training.data)
reg.model.compare <- rbind(reg.model.compare,
                           data.frame(Model='Support Vector Regression (Tuned)',
                                      Training.Rsq=rsq(train.error, training.data$overall),
                                      Testing.Rsq=rsq(error, testing.data$overall),
                                      RMSE=rmse(error)))

# error terms data frame
resid <- data.frame(Model=NULL,Desc=NULL, RMSE=NULL)

# Create a linear regression model
model <- lm(y ~ x, svr.example)

# make a prediction for each x
svr.example$RegPredictedY <- predict(model, svr.example)

# display the predictions
points(svr.example$x, svr.example$RegPredictedY, col = "blue", pch=1)

error <- model$residuals  # same as svr.example$y - predictedY

resid <- rbind(resid, data.frame(Model='A', Desc='Linear Regression', RMSE=rmse(error)))

model <- svm(y ~ x , svr.example)

svr.example$SVUPredictedY <- predict(model, svr.example)

error <- svr.example$y - svr.example$SVUPredictedY

resid <- rbind(resid, data.frame(Model='B', Desc='Untuned SVR', RMSE=rmse(error)))

tuneResult <- tune(svm, y ~ x,  data = svr.example,
                   ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9)))

tuneResult <- tune(svm, y ~ x,  data = svr.example,
                   ranges = list(epsilon = seq(0,0.2,0.01), cost = 2^(2:9))
) 

tunedModel <- tuneResult$best.model
#tunedModelY <- predict(tunedModel, data) 
svr.example$SVTPredictedY <- predict(tunedModel, svr.example)

error <- svr.example$y - svr.example$SVTPredictedY  

# this value can be different on your computer
# because the tune method  randomly shuffles the data
tunedModelRMSE <- rmse(error)  # 2.219642 
resid <- rbind(resid, data.frame(Model='C', Desc='Tuned SVR', RMSE=rmse(error)))

resid
