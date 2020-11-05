library(RSpectra)
data <- read.csv("Desktop/PCA_Eigenfaces/face_data_1.csv")

plt_img <- function(x){ image(x, col=grey(seq(0, 1, length=256)))}

newdata<-NULL
#rotate images
for(i in 1:nrow(data))
{
  c <- as.numeric((apply(matrix(as.numeric(data[i, ]), nrow=64, byrow=T), 2, rev)))
  newdata <- rbind(newdata,c)
}

df=as.data.frame(newdata)
write.csv(df,'Desktop/PCA_Eigenfaces/train_faces.csv',row.names=FALSE)

D <- data.matrix(df)

average_face=colMeans(df)

D <- scale(D)

#calculate covariance matrix
meanY <- colMeans(D)

row <- c()
index<-0
for (i in D[1,]){
  index<-index+1
  val <- i-meanY[index]
  row <- c(row, val)
}
for (i in 1:1){
  index <- 0
  row <- c()
  for (j in D[i,]){
    index <- index+1
    val <- j-meanY[index]
    row <- c(row, val)
  }
  B <- matrix(row, ncol = 4096)
}

for (i in 2:400){
  index <- 0
  row <- c()
  for (j in D[i,]){
    index <- index+1
    val <- j-meanY[index]
    row <- c(row, val)
  }
  B <- rbind(B, row)
}

tB <- t(B)

A <- tB %*% B

#calculate eigenvalues and eigenvectors
#calculate the largest 40 eigenvalues and corresponding eigenvectors
eigs <- eigs(A, 40, which = "LM")
eigenvalues <- eigs$values
eigenvectors <- eigs$vectors

eigenvalues1 <- eigen(A)$values
tot <- sum(eigenvalues1)
perc <- c()

for (i in 1:4096){
  sum <- sum(eigenvalues1[1:i])
  result <- sum/tot
  perc <- c(perc, result)
}

D_new <- D %*% eigenvectors

projEigen <- function(x){ 
  projection <- data.matrix(df[x,]) %*% eigenvectors
  projection_result <- projection %*% t(eigenvectors)
  plt_img(matrix(as.numeric(projection_result),nrow=64,byrow=T))
}

projEigenAverage <- function(x){ 
  average_face=colMeans(df)
  average=matrix(average_face,nrow=1,byrow=T)
  projection <- data.matrix(df[x,]) %*% eigenvectors
  projection_result <- projection %*% t(eigenvectors)
  projection_result_average=projection_result+average 
  plt_img(matrix(as.numeric(projection_result_average),nrow=64,byrow=T))
}

runTest <- function(x){
  projection <- data.matrix(df[x,]) %*% eigenvectors
  
  #transform traning images onto eigen space and get the coefficients
  projection_all <- data.matrix(df) %*% eigenvectors
  
  #find simple difference and multiplied by itself to avoid negative value
  test <- matrix(rep(1,400),nrow=400,byrow=T)
  test_projection <- test %*% projection
  Diff <- projection_all-test_projection
  y <- (rowSums(Diff)*rowSums(Diff))
  
  #plot similarity
  par(mfrow=c(1,1))
  par(mar=c(1,1,1,1))
  barplot(y,main = "Similarity Plot: 0 = Most Similar")
}

mostSimilar <- function(x){
  projection <- data.matrix(df[x,]) %*% eigenvectors
  
  #transform traning images onto eigen space and get the coefficients
  projection_all <- data.matrix(df) %*% eigenvectors
  
  #find simple difference and multiplied by itself to avoid negative value
  test <- matrix(rep(1,400),nrow=400,byrow=T)
  test_projection <- test %*% projection
  Diff <- projection_all-test_projection
  y <- (rowSums(Diff)*rowSums(Diff))
  
  # Find the minimum number to match the photo in the files
  x=c(1:400)
  newdf=data.frame(cbind(x,y))
  num = newdf$x[newdf$y == min(newdf$y)]
  plt_img(matrix(as.numeric(df[num, ]), nrow=64, byrow=T))
}

plotAverage <- function(x){
  end <- x*10
  begin <- end-9
  average=colMeans(data.matrix(df[begin:end,]))
  plt_img(matrix(average,nrow=64,byrow=T))
}

personNum <- function(x){
  if ((x %% 10) == 0) {
    x4 <- x-9
  }
  if ((x %% 10) != 0) {
    x1 <- x/10
    x2 <- floor(x1)
    x3 <- x2+1
    x4 <- x3*10
  }
  plt_img(matrix(as.numeric(df[x4, ]), nrow=64, byrow=T))
}

eigenResults <- function(x){
  result <- data.matrix(df[x,]) %*% eigenvectors
  barplot(result,main="Projection Coefficients", col="grey",ylim = c(-40,10))
}

plotVariance <- function(x){
  par(mfrow=c(1,1))
  par(mar=c(2.5,2.5,2.5,2.5))
  y=perc[1:x]
  #plot variance percentage
  plot(1:x, y, type="l", log = "y", main="Total Variance", xlab="Eigenvalue #", ylab="variance")
}

