library(shiny)
library(shinydashboard)
library(e1071)
library(randomForest)
library(rpart)
library(party)
library(rpart.plot)
library(rattle)

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


summ <- data.frame(Regression=c('lsat75','gpa25','pct_emp_9','pct_emp_grad','sf_ratio','lsat25'),
                   CART=c('lsat75','pct_emp_9','gpa75','gpa25','-','-'),
                   RandForest=c('lsat75','lsat25','gpa25','gpa75','pct_emp_grad','pct_emp_9'),
                   SVR=c('-','-','-','-','-','-'))

