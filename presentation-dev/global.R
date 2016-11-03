library(shiny)
library(shinydashboard)
library(e1071)
library(randomForest)

pal <- c('lightgray', 'darkblue', 'red')

def <- par(bty="l",
           las=1,
           bg="#F0F0F0",
           col.axis="#434343",
           col.main="#343434",
           cex=0.85,
           cex.axis=0.8)

regressMod <- function(dat) {
  return(lm(overall ~ .,
            data=dat))
}

svmMod <- function(dat,
                   gamma=0.01,
                   cost=1,
                   epsilon=0.1,
                   kernel='linear') {
  return(svm(overall ~ .,
             data = dat,
             kernel=kernel,
             gamma = gamma,
             cost = cost,
             epsilon=epsilon))
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

predPlot <- function(predicted, observed) {
  par(def)
  plot(0,
       xlab="Predicted Score",
       ylab="Observed Score",
       xlim=c(20, 100),
       ylim=c(20, 100),
       type="n")
  grid(NULL,NULL, col="#DEDEDE",lty="solid", lwd=0.9)
  points(predicted,
         observed,
         pch=16,
         col=pal[1])
  lines(lowess(predicted,
               observed),
        col=pal[2])
}

rmse <- function(error) {
  sqrt(mean(error^2))
}

rsq <- function(error, y) {
  1 - (mean(error^2)/var(y))
}
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
svu <- svmMod(training.data, 100, 1, 0.1, 'linear')
svt <- svmMod(training.data, 0.01, 1, 0.1, 'linear')
rf <- rfMod(training.data, 4000, 4)

predlr <- predict(lr, testing.data)
predsvu <- predict(svu, testing.data)
predsvt <- predict(svt, testing.data)
predrf <- predict(rf, testing.data)

model.compare <- data.frame(Model=NULL, Rsq=NULL, RMSE=NULL)

error <- lr$residuals
model.compare <- rbind(model.compare, data.frame(Model='Linear Regression Model', Rsq=summary(lr)$adj.r.squared, RMSE=rmse(error)))

error <- testing.data$overall - predsvu
model.compare <- rbind(model.compare, data.frame(Model='Support Vector Regression Model (Untuned)', Rsq=rsq(error, training.data$overall), RMSE=rmse(error)))

error <- testing.data$overall - predsvt
model.compare <- rbind(model.compare, data.frame(Model='Support Vector Regression Model (Tuned)', Rsq=rsq(error, training.data$overall), RMSE=rmse(error)))

error <- testing.data$overall - predrf
model.compare <- rbind(model.compare, data.frame(Model='Random Forest Model', Rsq=mean(rf$rsq), RMSE=rmse(error)))

