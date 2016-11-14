library(e1071)

# clear workspace
rm(list=ls())

# my default plot preferences in a function
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

rmse <- function(error)
{
  sqrt(mean(error^2))
}

svr.example <- read.table(file='data/nonlin.csv',
                  header=TRUE,
                  sep=",",
                  quote="\"",
                  skip=0,
                  row.names=NULL)

# error terms data frame
resid <- data.frame(Model=NULL,Desc=NULL, RMSE=NULL)

# Plot the data
plot(svr.example$x, svr.example$y, pch=16)

# Create a linear regression model
model <- lm(y ~ x, svr.example)

# Add the fitted line
#abline(model)

# make a prediction for each x
svr.example$RegPredictedY <- predict(model, svr.example)

# display the predictions
points(svr.example$x, svr.example$RegPredictedY, col = "blue", pch=1)

error <- model$residuals  # same as svr.example$y - predictedY
#predictionRMSE <- rmse(error)   # 5.703778
resid <- rbind(resid, data.frame(Model='A', Desc='Linear Regression', RMSE=rmse(error)))
rm(error)

model <- svm(y ~ x , svr.example)

svr.example$SVUPredictedY <- predict(model, svr.example)

points(svr.example$x, svr.example$SVUPredictedY, col = "red", pch=4)
lines(svr.example$x, svr.example$SVUPredictedY, col = "red", lty=1)

error <- svr.example$y - svr.example$SVUPredictedY
#svrPredictionRMSE <- rmse(error)  # 3.157061
resid <- rbind(resid, data.frame(Model='B', Desc='Untuned SVR', RMSE=rmse(error)))

tuneResult <- tune(svm, y ~ x,  data = svr.example,
                   ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9)))
print(tuneResult)
# best performance: MSE = 8.371412, RMSE = 2.89 epsilon 1e-04 cost 4
# Draw the tuning graph
plot(tuneResult)

tuneResult <- tune(svm, y ~ x,  data = svr.example,
                   ranges = list(epsilon = seq(0,0.2,0.01), cost = 2^(2:9))
) 

print(tuneResult)
plot(tuneResult)

tunedModel <- tuneResult$best.model
#tunedModelY <- predict(tunedModel, data) 
svr.example$SVTPredictedY <- predict(tunedModel, svr.example)

error <- svr.example$y - svr.example$SVTPredictedY  

# this value can be different on your computer
# because the tune method  randomly shuffles the data
tunedModelRMSE <- rmse(error)  # 2.219642 
resid <- rbind(resid, data.frame(Model='C', Desc='Tuned SVR', RMSE=rmse(error)))

# Plot the data
plot(0,
     xlab="x",
     ylab="y",
     xlim=c(min(svr.example$x),max(svr.example$x)),
     ylim=c(min(svr.example$y),max(svr.example$y)),
     type='n')
grid(NULL,NULL, col="#DEDEDE",lty="solid", lwd=0.9)
# observations
points(svr.example$x, svr.example$y, col = "black", pch=16)

# linear model predictions
points(svr.example$x, svr.example$RegPredictedY, col = "purple", pch=1)
lines(svr.example$x, svr.example$RegPredictedY, col = "purple", pch=2)

# Untuned SVR model predictions
points(svr.example$x, svr.example$SVUPredictedY, col = "blue", pch=4)
lines(svr.example$x, svr.example$SVUPredictedY, col="blue", pch=4)

# tuned SVR model predictions
points(svr.example$x, svr.example$SVTPredictedY, col = "red", pch=1)
lines(svr.example$x, svr.example$SVTPredictedY, col="red", pch=4)

#plotMe(svr.example$RegPredictedY, svr.example$y, 'Predicted','Observed','Linear Regression')
#plotMe(svr.example$SVUPredictedY, svr.example$y, 'Predicted','Observed','Untuned SVR')
#plotMe(svr.example$SVTPredictedY, svr.example$y, 'Predicted','Observed','Tuned SVR')


resid