#######################################################################################################################
###### Extra exercise: data und and data prep #########
#######################################################################################################################
###### Exercise 1
#Consider the following data frame. Select only the third column and make
#sure the output is still a data frame containing the name of the vector.

(df <- data.frame(matrix(1:25,ncol=5,nrow=5)))
#-# X1 X2 X3 X4 X5
#-# 1 1 6 11 16 21
#-# 2 2 7 12 17 22
#-# 3 3 8 13 18 23
#-# 4 4 9 14 19 24
#-# 5 5 10 15 20 25

###### Solution

rm(list = ls())

#######################################################################################################################
###### Exercise 2
#We have two functions: mainFirst, mainSecond. The function mainFirst will
#always be called first and the function mainSecond will be called second in
#our code. These functions are not very maintainable. The first part of both
#functions seems to be very similar. How could we improve this by making a
#third function?

#input data
x <- rnorm(100)

mainFirst <- function(x) { x <- x + 1 + 2 - 1 + 3 - 4 + 1 + 1 + 10 + 35 - 12 + 9 + 19 +
  1 + 1 + 5 + 1
summary(x)
}
mainSecond <- function(x) {
  x <- x + 1 + 2 - 1 + 3 - 4 + 1 + 1 + 10 + 35 - 12 + 9 + 19 +
    1 + 100 + 5 + 1
  hist(x)
}
mainFirst(x)
#-# Min. 1st Qu. Median Mean 3rd Qu. Max.
#-# 69.54 71.18 71.82 71.83 72.35 74.10
mainSecond(x)

###### Solution

rm(list = ls())
#######################################################################################################################
###### Exercise 3
#Assume that subscriptions.txt is independent period data. Make predictors
#from 5 columns. Assume we will be merging those predictors with another
#table by CustomerID, so we need to aggregate.

###### Solution


