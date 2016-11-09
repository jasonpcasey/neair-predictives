library(reshape2)
library(plyr)

getData <- function() {
  # Get the data
  dat <- read.table(file='data/LawSchools2014-15.csv',
                    header=TRUE,
                    sep=",",
                    quote="\"",
                    skip=0,
                    row.names=NULL)
  
  # Impute for missing
  empfit <- lm(pct_emp_grad ~ pct_emp_9 + accept + lsat25 + lsat75, data=dat[!is.na(dat$pct_emp_grad),])
  dat$pct_emp_grad[is.na(dat$pct_emp_grad)] <- predict(empfit, dat[is.na(dat$pct_emp_grad),])  
  
  # manipulate overall for demo
  dat$overall <- dat$overall^2
  
  # Re-scale for use in models
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
  
  # Make categorical variable
  dat$tier <- factor(ifelse(dat$rank < 17, 'Top','Other'))
  
  # Standard subset for return
  dat <- subset(dat,
                select=c(overall,
                         peer_assess,
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
                         school,
                         rank,
                         tier,
                         year))
  return(dat)
}

original.data <- getData()
training.data <- subset(original.data,
                        year==2015,
                        select=c(overall,
                                 #zpeer_assess,
                                 #zjudges_assess,
                                 #zgpa25,
                                 #zgpa75,
                                 #zlsat25,
                                 zlsat75,
                                 #zpct_emp_grad,
                                 zpct_emp_9,
                                 zaccept,
                                 #zsf_ratio,
                                 zbar_pass_pct))

testing.data <- subset(original.data,
                       year==2016,
                       select=c(overall,
                                #zpeer_assess,
                                #zjudges_assess,
                                #zgpa25,
                                #zgpa75,
                                #zlsat25,
                                zlsat75,
                                #zpct_emp_grad,
                                zpct_emp_9,
                                zaccept,
                                #zsf_ratio,
                                zbar_pass_pct))

cat.training.data <- subset(original.data,
                        year==2015,
                        select=c(tier,
                                 #zpeer_assess,
                                 #zjudges_assess,
                                 #zgpa25,
                                 #zgpa75,
                                 #zlsat25,
                                 zlsat75,
                                 #zpct_emp_grad,
                                 zpct_emp_9,
                                 zaccept,
                                 #zsf_ratio,
                                 zbar_pass_pct))

cat.testing.data <- subset(original.data,
                       year==2016,
                       select=c(tier,
                                #zpeer_assess,
                                #zjudges_assess,
                                #zgpa25,
                                #zgpa75,
                                #zlsat25,
                                zlsat75,
                                #zpct_emp_grad,
                                zpct_emp_9,
                                zaccept,
                                #zsf_ratio,
                                zbar_pass_pct))


write.table(original.data,
            file='data/fullSet.csv',
            append=FALSE,
            quote=TRUE,
            sep=",",
            row.names=FALSE,
            col.names=TRUE,
            na = "")

write.table(testing.data,
            file='data/testSet.csv',
            append=FALSE,
            quote=TRUE,
            sep=",",
            row.names=FALSE,
            col.names=TRUE,
            na = "")

write.table(training.data,
            file='data/trainSet.csv',
            append=FALSE,
            quote=TRUE,
            sep=",",
            row.names=FALSE,
            col.names=TRUE,
            na = "")

write.table(cat.testing.data,
            file='data/catTestSet.csv',
            append=FALSE,
            quote=TRUE,
            sep=",",
            row.names=FALSE,
            col.names=TRUE,
            na = "")

write.table(cat.training.data,
            file='data/catTrainSet.csv',
            append=FALSE,
            quote=TRUE,
            sep=",",
            row.names=FALSE,
            col.names=TRUE,
            na = "")

rm(list=ls())
