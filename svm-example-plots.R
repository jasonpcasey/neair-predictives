x <- c(0.6,1,1.9,3.6,1.7,4.1,4.2,5.5,6.1,7)
y <- c(3.1,4.8,4,5,2.3,4.1,1.2,0.9,2.1,3.2)
class <- c('A','A','A','A','A','A','B','B','B','B')

par(bty="l",
    las=1,
    bg="#F0F0F0",
    col.axis="#434343",
    col.main="#343434",
    cex=1.5,
    cex.axis=1)

plot(0,
     xlab="x",
     ylab="y",
     xlim=c(min(x),max(x)),
     ylim=c(min(y),max(y)),
     type='n')

grid(NULL,NULL, col="#DEDEDE",lty="solid", lwd=0.9)

points(x, y,
       col = ifelse(class=='A','red','blue'),
       pch=20)

abline(0, 0.95, lty=2)
abline(0, 0.9, lty=2)
abline(-2, 1, lty=2)
abline(-1, 1, lty=2)
abline(-0.1, 0.6, lty=2)


plot(0,
     xlab="x",
     ylab="y",
     xlim=c(min(x),max(x)),
     ylim=c(min(y),max(y)),
     type='n')

grid(NULL,NULL, col="#DEDEDE",lty="solid", lwd=0.9)

points(x, y,
       col = ifelse(class=='A','red','blue'),
       pch=20)

abline(1.05, 0.75, lty=2)
abline(-1.95, 0.75, lty=2)
abline(-0.45, 0.75, lty=1)
#abline(8, -1.33, lty=1)
