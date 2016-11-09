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

logitMod <- function(dat) {
  return(glm(tier ~ .,
            data=dat,
            family=binomial(link='logit')))
}

svrMod <- function(dat,
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

svmMod <- function(dat,
                   gamma=0.01,
                   cost=1,
                   epsilon=0.1,
                   kernel='linear') {
  return(svm(tier ~ .,
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

rfModCat <- function(dat,
                  trees=1000,
                  vars=4) {
  return(randomForest(tier ~ .,
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
       xlim=c(-100, 10000),
       ylim=c(0, 10000),
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

cat.training.data <- read.table(file='../data/catTrainSet.csv',
                            header=TRUE,
                            sep=",",
                            quote="\"",
                            skip=0,
                            row.names=NULL)

cat.testing.data <- read.table(file='../data/catTestSet.csv',
                           header=TRUE,
                           sep=",",
                           quote="\"",
                           skip=0,
                           row.names=NULL)

lr <- regressMod(training.data)
svu <- svrMod(training.data, 100, 1, 0.1, 'linear')
svt <- svrMod(training.data, 0.01, 1, 0.1, 'radial')
rf <- rfMod(training.data, 4000, 4)

clr <- logitMod(cat.training.data)
csvu <- svmMod(cat.training.data, 100, 1, 0.1, 'radial')
csvt <- svmMod(cat.training.data, 0.01, 1, 0.1, 'radial')
crf <- rfModCat(cat.training.data, 4000, 4)

predlr <- predict(lr, testing.data)
predsvu <- predict(svu, testing.data)
predsvt <- predict(svt, testing.data)
predrf <- predict(rf, testing.data)

#cpredlr <- predict(clr, cat.testing.data)
clr.probs <- predict(clr, cat.testing.data, type = "response")
cpredlr <- ifelse(clr.probs > 0.5, "Bottom", "Other")
#results_lr[index_subj] <- predictions_lr

cpredsvu <- predict(csvu, cat.testing.data)
cpredsvt <- predict(csvt, cat.testing.data)
cpredrf <- predict(crf, cat.testing.data)

reg.model.compare <- data.frame(Model=NULL, Rsq=NULL, RMSE=NULL)

error <- lr$residuals
reg.model.compare <- rbind(reg.model.compare, data.frame(Model='Linear Regression Model', Rsq=summary(lr)$adj.r.squared, RMSE=rmse(error)))

error <- testing.data$overall - predsvu
reg.model.compare <- rbind(reg.model.compare, data.frame(Model='Support Vector Regression Model (Untuned)', Rsq=rsq(error, training.data$overall), RMSE=rmse(error)))

error <- testing.data$overall - predsvt
reg.model.compare <- rbind(reg.model.compare, data.frame(Model='Support Vector Regression Model (Tuned)', Rsq=rsq(error, training.data$overall), RMSE=rmse(error)))

error <- testing.data$overall - predrf
reg.model.compare <- rbind(reg.model.compare, data.frame(Model='Random Forest Model', Rsq=mean(rf$rsq), RMSE=rmse(error)))

