library(e1071)
library(rgl)

demo <- read.table(file='data/plane-demo.csv',
                   header=TRUE,
                   sep=",",
                   quote="\"",
                   skip=0,
                   stringsAsFactors = TRUE,
                   row.names=NULL)

demo$sym <- ifelse(demo$Group=='A',16,4)

s3d <-scatterplot3d(demo$X,demo$Z,demo$Y, pch=demo$sym, highlight.3d=TRUE,
                    type="h", main="3D Scatterplot")
fit <- svm(Group ~ X + Y + Z, kernel='linear', data=demo) 
#s3d$plane3d(fit)
w <- t(fit$coefs) %*% fit$SV

# detalization <- 100 
grid <- expand.grid(seq(from=min(demo$x),to=max(demo$x),length.out=100),                                                                                                         
                    seq(from=min(demo$y),to=max(demo$y),length.out=100))                                                                                                         
# grid <- data.frame(X=seq(from=0,to=16, length.out=100),
#                    Y=seq(from=0,to=16, length.out=100))

z <- (fit$rho - w[1,1]*grid[,1] - w[1,2]*grid[,2]) / w[1,3]

plot(demo$X, demo$Y, col=ifelse(demo$Group=='A','red','darkblue'), pch=demo$sym)
plot3d(demo$X, demo$Y,demo$Z, col=ifelse(demo$Group=='A','red','gray'), size=3)

plot3d(grid[,1],grid[,2], 5.5)  # this will draw plane.
# adding of points to the graphics.
points3d(demo$x[which(demo$Group=='A')], demo$y[which(demo$Group=='A')], demo$z[which(demo$Group=='A')], col='red')
points3d(demo$x[which(demo$Group=='B')], demo$y[which(demo$Group=='B')], demo$z[which(demo$Group=='B')], col='blue')

