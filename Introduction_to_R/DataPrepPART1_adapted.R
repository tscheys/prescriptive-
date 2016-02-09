#QUESTIONS ABOUT THIS DOCUMENT: matthias.bogaert@ugent.be or steven.hoornaert@ugent.be

##########################################################################################################
#Contents of this file:

#1 DUMMIES
  #1.1 MANUALLY
  #1.2 AUTOMATICALLY
  #1.3 WITH data.table
#2 BY PROCESSING
#3 MERGING
  #3.1 Merging 2 data frames/data tables
  #3.2 Merging multiple data frames/data tables
#4 APPLYING FUNCTIONS TO DATA FRAMES
  #4.1 BAD SOLUTION
  #4.2 BETTER SOLUTION
  #4.3 BEST SOLUTION


##########################################################################################################
#1 DUMMIES

#1.1. MANUALLY
(x <- data.frame(ID=c(1,1,2,2,3,3),V1=as.factor(c(1,2,3,4,4,4))))

x[,3] <- ifelse(x$V1=='1',1,0)
x[,4] <- ifelse(x$V1=='2',1,0)
x[,5] <- ifelse(x$V1=='3',1,0)
x[,6] <- ifelse(x$V1=='4',1,0)
x
(names(x)[3:6] <- c('V1_1','V1_2','V1_3','V1_4'))

#1.2. AUTOMATICALLY
#install.packages('dummy')
require(dummy) #same as library(dummy)

?dummy
#the dummy package automatically creates dummy-variables from the factor and character variables. There is also support for predictive contexts.

(x <- data.frame(ID=c(1,1,1,1,1,2,2,2),V1=as.factor(c(1,1,2,3,4,4,4,4)),V2=as.factor(c(1,1,2,3,4,4,4,4))))

#Make dummies of all predictors 
dummy::dummy(x = x, p = 'all', int = FALSE)

#If you only want to select the top p values, you should adapt the parameter 'p'
dummy::dummy(x = x, p = 1, int = FALSE)

#In a predictive context, you should always first create a categories-object with the categories function.
#this function stores the top p values of all factors and character variables. It makes sure that you will always produce the same dummy variables. 
(cats <- categories(x = x, p = 2))
dummy::dummy(x = x, object = cats, int = FALSE)

#1.3. WITH data.table
x <- as.data.table(x)
ind <- as.character(unique(x$V1))
x[, (ind) := lapply(ind, function (x) ifelse(V1 == x,1,0))]

##########################################################################################################
#2 BY PROCESSING

(x <- data.frame(ID=c(1,1,1,1,1,2,2,2),V1=c(1,1,2,3,4,4,4,4),V2=c(1,1,2,3,4,4,4,4)))

#aggregate
?aggregate
#sum
aggregate(x[,names(x) != 'ID'],by=list(ID=x$ID),sum)
#counts
aggregate(x[,names(x) != 'ID'],by=list(x$ID),length) 
#first or last observation
aggregate(x[,names(x) != 'ID'],by=list(x$ID),head,n=1)
aggregate(x[,names(x) != 'ID'],by=list(x$ID),tail,n=1)

#data.table
require(data.table)
x <- as.data.table(x)
#sum
x[,list(sum(V1),sum(V2)), by = 'ID']
x[,lapply(.SD,sum), by = 'ID', .SDcols = c(2,3)] 
x[,lapply(.SD,sum), by = 'ID', .SDcols = c('V1', 'V2')]
x[,lapply(.SD,sum), by = 'ID', .SDcols = -1] # '-' in this case means remove this column (the same reasonig goes for data.frames)
#counts
x[,list(length(V1),length(V2)), by = 'ID']
x[,lapply(.SD,length), by = 'ID', .SDcols = 2:3]
#first or last observation
x[,list(head(V1,n=1),head(V2,n=1)), by = 'ID']
x[,lapply(.SD,head, n=1), by = 'ID', .SDcols = 2:3]
x[,list(tail(V1,n=1),tail(V2,n=1)), by = 'ID']
x[,lapply(.SD,tail, n=1), by = 'ID', .SDcols = 2:3]

#If you're interested in other functions that achieve the same thing: http://www.r-bloggers.com/say-it-in-r-with-by-apply-and-friends/ (aggregate is among the best)

#EXERCISE: Using the Iris dataset, calculate the mean and the standard deviation for every 'Species'
data(iris)
str(iris)

##########################################################################################################
#3 MERGING

#3.1. Merging 2 data frames/data tables
#3.1.1. Data frames
?merge

(left <- data.frame(ID=c(1,1,2,2,3,3),V1=c(1,2,3,4,4,4),V2=c(1,2,3,4,4,4)))

(right <- data.frame(ID=c(2,2,3,3,4,4),V3=c(1,2,3,4,4,4),V4=c(1,2,3,4,4,4)))


(left_by <- aggregate(left[,names(left) != 'ID'],by=list(ID=left$ID),sum))

(right_by <- aggregate(right[,names(right) != 'ID'],by=list(right$ID),sum))


#You can rename a column like this:
names(right_by)[1] <- 'ID'
#or you can use list(ID=right$ID) when defining right_by

str(left_by)
str(right_by)

#Inner Join
merge(left_by,right_by,by='ID')

#Left outer join
merge(left_by,right_by,by='ID',all.x=TRUE)

#Right outer join
merge(left_by,right_by,by='ID',all.y=TRUE)

#Full outer join
merge(left_by,right_by,by='ID',all=TRUE)

#3.1.2. Data tables
#Joins in data tables can also be done with the merge function. Merge is a generic function which also works for data table
#merge with table works faster then the original merge
#merge with data table merges autmotically on the shared key (if defined)

(left_by <- as.data.table(left_by))
setkeyv(x = left_by, cols = 'ID')

(right_by <- as.data.table(right_by))
setkeyv(x = right_by, cols = 'ID')

#Inner Join
merge(left_by,right_by,by='ID')
merge(left_by,right_by)

#Left outer join
merge(left_by,right_by,all.x=TRUE)

#Right outer join
merge(left_by,right_by,all.y=TRUE)

#Full outer join
merge(left_by,right_by,all=TRUE)
left_by[right_by]

#3.2. Merging multiple data frames/data tables
# This is the same for both data frames and data tables 

#create a third dataset

(center <- data.frame(ID=c(2,2,3,3,4,4),V5=c(1,2,3,4,4,4),V6=c(1,2,3,4,4,4)))
(center_by <- aggregate(center[,names(center) != 'ID'],by=list(ID=center$ID),sum))
(left_by <- as.data.frame(left_by))
(right_by <- as.data.frame(right_by)) 

#Approach 1: Use a loop (the bad approach, correct but slower)
datalist <- list(left_by,right_by,center_by)
for (i in 1:length(datalist)) {
  if (i==1) intermediate <- datalist[[1]] 
  if (i>1) intermediate <- merge(intermediate,datalist[[i]],by='ID')
}
intermediate

#Approach 2: Reduce (the good approach)
#?Reduce
#http://www.r-bloggers.com/merging-multiple-data-files-into-one-data-frame/
#http://r.789695.n4.nabble.com/merge-multiple-data-frames-td4331089.html

#The Reduce function successively combines the elements of a given vector 
#to see the process in action, set accumulate=TRUE
str(datalist)
Reduce(function(x, y) merge(x, y, by='ID'),datalist,accumulate=TRUE)

#To keep only the final merge drop the accumulate (default is accumulate=FALSE)
Reduce(function(x, y) merge(x, y, by='ID'),datalist)

#EXERCISE: Create an extra dataset calculating the sum for all columns per 'Species' using the iris dataset. 
#Use the data.frames created in the previous exercise (standard deviation and mean) and merge them into one data.frame together with your newly created sum.
#EXTRA: Make sure that you know which columns respresent the mean, the standard deviation and the sum.


##########################################################################################################

#4 APPLYING FUNCTIONS TO DATA FRAMES
#create some data
x <- data.frame(matrix(runif(10000000),nrow = 100, ncol=100000)) #this yields 100 rows and 100k columns with random values
dim(x)

#Monitor speed of execution (look at elapsed time)
#system.time('here goes your code')

#OBJECTIVE: compute the column sums

#4.1. BAD SOLUTION: Use a Loop to take the sum of each variable and save it (22 seconds on my system)
x_sum1 <- integer()
system.time(
  for (i in 1:ncol(x)) x_sum1[i] <- sum(x[,i])
)
head(x_sum1)
?head

#4.2. BETTER SOLUTION: Pre-allocate the object and use a Loop to take the sum of each variable and save it (6 seconds on my system)

x_sum2 <- integer(length=100000)
system.time(
  for (i in 1:ncol(x)) x_sum2[i] <- sum(x[,i])
)
head(x_sum2)

#4.3 BEST SOLUTION:      Use APPLY FAMILY     :sapply (0.1 seconds on my system)
#Conceptually sapply successively takes the columns of the data frame, applies a function to each column, returns a vector of the same length as the number of columns.
#see http://www.r-bloggers.com/using-apply-sapply-lapply-in-r/ for more info.

system.time(
  x_sum3 <- sapply(x,sum)
)

head(x_sum3)

#Data table solution
x <- as.data.table(x)
system.time(
  x_sum_4<- x[,lapply(.SD,sum)]
) #apparently data.table is a lot slower in this case

#But if you use the same code as data.frame is faster ... 
system.time(
  x_sum5 <- lapply(x,sum)
)
head(x_sum5)

#There are some ready made functions that rely on sapply
head(colSums(x))
head(colMeans(x))

