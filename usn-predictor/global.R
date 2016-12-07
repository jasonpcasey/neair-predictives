library(shiny)
library(ggplot2)
library(shinydashboard)
library(e1071)

pal <- c('lightgray', 'darkblue', 'red')
def <- par(bty="l",
           las=1,
           bg="#F0F0F0",
           col.axis="#434343",
           col.main="#343434",
           cex=0.85,
           cex.axis=0.8)

makePlot <- function(dat, xvar, yvar) {
  par(def)
  plot(0,
       xlab="Judges' Assessment",
       ylab="Overall Score",
       xlim=c(1.5, 5.0),
       ylim=c(20, 100),
       type="n")
  grid(NULL,NULL, col="#DEDEDE",lty="solid", lwd=0.9)
  points(data()$judges_assess[data()$group=="Others"],
         data()$overall[data()$group=="Others"],
         pch=16,
         col=pal[1])
  points(data()$judges_assess[data()$group=="ND (Reported)"],
         data()$overall[data()$group=="ND (Reported)"],
         pch=16,
         col=pal[2])
  points(data()$judges_assess[data()$group=="ND (Predicted)"],
         data()$overall[data()$group=="ND (Predicted)"],
         pch=16,
         col=pal[3])
  abline(lm(data()$overall[data()$group %in% c("Others", "ND (Reported)")]~
              data()$judges_assess[data()$group %in% c("Others", "ND (Reported)")]),
         col="blue")

}

runModel <- function(dat) {
  mod <- svm(overall ~ zpeer_assess +
               zjudges_assess +
               zgpa25 +
              zgpa75 +
              zlsat25 +
              zlsat75 +
              zpct_emp_grad +
              zpct_emp_9 +
              zaccept +
              zsf_ratio +
              zbar_pass_pct,
            data=dat,
            kernel='linear',
            gamma=0.05,
            cost=1,
            epsilon=0.2)
  return(mod)
}

getData <- function(selYear) {
  dat <- read.table(file='../data/LawSchools2014-15.csv',
                    header=TRUE,
                    sep=",",
                    quote="\"",
                    skip=0,
                    row.names=NULL)
  
  # Impute!
  empfit <- lm(pct_emp_grad ~ pct_emp_9 + accept + lsat25 + lsat75, data=dat[!is.na(dat$pct_emp_grad),])
  dat$pct_emp_grad[is.na(dat$pct_emp_grad)] <- predict(empfit, dat[is.na(dat$pct_emp_grad),])  
  
  
  # dat$over_under <- dat$bar_pass_pct - dat$pass_rate
  dat$group <- as.integer(ifelse(!dat$school=='University of Notre Dame',1,2))
  
  dat$label <- ifelse(dat$school=='University of Notre Dame',dat$rank,'')
  
  dat$zpeer_assess <- as.numeric(scale(dat$peer_assess, center = TRUE, scale = TRUE))
  dat$zjudges_assess <- as.numeric(scale(dat$judges_assess, center = TRUE, scale = TRUE))
  dat$zgpa25 <- as.numeric(scale(dat$gpa25, center = TRUE, scale = TRUE))
  dat$zgpa75 <- as.numeric(scale(dat$gpa75, center = TRUE, scale = TRUE))
  dat$zlsat25 <- as.numeric(scale(dat$lsat25, center = TRUE, scale = TRUE))
  dat$zlsat75 <- as.numeric(scale(dat$lsat75, center = TRUE, scale = TRUE))
  dat$zpct_emp_grad <- as.numeric(scale(dat$pct_emp_grad, center = TRUE, scale = TRUE))
  dat$zpct_emp_9 <- as.numeric(scale(dat$pct_emp_9, center = TRUE, scale = TRUE))
  dat$zaccept <- as.numeric(scale(dat$accept, center = TRUE, scale = TRUE))
  dat$zsf_ratio <- as.numeric(scale(dat$sf_ratio, center = TRUE, scale = TRUE))
  dat$zbar_pass_pct <- as.numeric(scale(dat$bar_pass_pct, center = TRUE, scale = TRUE))

  dat <- subset(dat,
                year==selYear,
                select=c(overall,
                         gpa25,
                         gpa75,
                         lsat25,
                         lsat75,
                         pct_emp_grad,
                         pct_emp_9,
                         accept,
                         sf_ratio,
                         bar_pass_pct,
                         zpeer_assess,
                         zjudges_assess,
                         zgpa25,
                         zgpa75,
                         zlsat25,
                         zlsat75,
                         zpct_emp_grad,
                         zpct_emp_9,
                         zaccept,
                         zsf_ratio,
                         zbar_pass_pct,
                         label,
                         group,
                         school,
                         rank))
  return(dat)
}

makeRow <- function(peer_assess,
                    judges_assess,
                    gpa25,
                    gpa75,
                    lsat25,
                    lsat75,
                    pct_emp_grad,
                    pct_emp_9,
                    accept,
                    sf_ratio,
                    bar_pass_pct,
                    dat) {
  
  new.row <- data.frame(overall = NA,
                        peer_assess = peer_assess,
                        judges_assess = judges_assess,
                        gpa25 = gpa25,
                        gpa75 = gpa75,
                        lsat25 = lsat25,
                        lsat75 = lsat75,
                        pct_emp_grad = pct_emp_grad,
                        pct_emp_9 = pct_emp_9,
                        accept = accept,
                        sf_ratio = sf_ratio,
                        bar_pass_pct = bar_pass_pct)
  
  new.row$zpeer_assess = as.numeric((new.row$peer_assess - mean(dat$peer_assess)) / sd(dat$peer_assess))
  new.row$zjudges_assess = as.numeric((new.row$judges_assess - mean(dat$judges_assess)) / sd(dat$judges_assess))
  new.row$zgpa25 = as.numeric((new.row$gpa25 - mean(dat$gpa25)) / sd(dat$gpa25))
  new.row$zgpa75 = as.numeric((new.row$gpa75 - mean(dat$gpa75)) / sd(dat$gpa75))
  new.row$zlsat25 = as.numeric((new.row$lsat25 - mean(dat$lsat25)) / sd(dat$lsat25))
  new.row$zlsat75 = as.numeric((new.row$lsat75 - mean(dat$lsat75)) / sd(dat$lsat75))
  new.row$zpct_emp_grad = as.numeric((new.row$pct_emp_grad - mean(dat$pct_emp_grad)) / sd(dat$pct_emp_grad))
  new.row$zpct_emp_9 = as.numeric((new.row$pct_emp_9 - mean(dat$pct_emp_9)) / sd(dat$pct_emp_9))
  new.row$zaccept = as.numeric((new.row$accept - mean(dat$accept)) / sd(dat$accept))
  new.row$zsf_ratio = as.numeric((new.row$sf_ratio - mean(dat$sf_ratio)) / sd(dat$sf_ratio))
  new.row$zbar_pass_pct = as.numeric((new.row$bar_pass_pct - mean(dat$bar_pass_pct)) / sd(dat$bar_pass_pct))
  
  new.row$label <- NA
  new.row$group <- 3
  new.row$school <- 'University of Notre Dame (Pred.)'
  new.row$rank <- NA
  return(new.row)
}

original.data <- getData(2016)
model <- runModel(original.data)
base.case <- subset(original.data,
                    school=='University of Notre Dame')
base.data <- subset(original.data,
                    school!='University of Notre Dame')

updatePrediction <- function(new.row) {
  new.row$overall <- predict(model, new.row[,15:23])
  new.row$group <- 3L
  new.set <- rbind(base.data, new.row)
  new.set$rank <- rank(-new.set$overall, ties.method = 'first')
  new.set$label[new.set$group==3] <- new.set$rank[new.set$group==3]
  new.set <- rbind(new.set, base.case)

  new.set$group <- factor(new.set$group,
                          levels=c(1,2,3),
                          labels=c('Others',
                                   'ND (Reported)',
                                   'ND (Predicted)'))
  
  return(new.set)
}


