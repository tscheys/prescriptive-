#QUESTIONS ABOUT THIS DOCUMENT: matthias.bogaert@ugent.be or steven.hoornaert@ugent.be

##########################################################################################################
#Contents of this file:

#0 CREATING, STORING AND LOOKING AT OBJECTS
#1 OBJECT TYPES AND SUBSETTING
#2 MEMORY MONITORING AND MANAGEMENT
#3 READ IN DATA
#4 DATA EXPLORATION
#5 MISSING VALUES
#6 INSTALLING AND LOADING PACKAGES

##########################################################################################################
#GETTING HELP

#if you don't know how some action should be executed with R, simply Google it (there is much on the internet about R).

#If you know the name of the function but need more information on how to use it, or its parameters: R has a built-in help system:
#help(function) OR ?function
#help.search("function") OR ??function 
help()
help.search()
#Get familiar with the layout of the helpfiles. You will use them a lot.

##########################################################################################################
#0 CREATING, STORING AND LOOKING AT OBJECTS

#create an object and store the value 1
a <- 1
#alternative:
a = 1

#look at its contents
a

#create, store and print simultaneously
(a <- 2)

##########################################################################################################
#1 OBJECT TYPES AND SUBSETTING

# 1.1. Object Types
# Object Types:

# 1) vectors
#The main four types of vectors are:
  # --numeric: decimal numbers
    (num_vector <- as.numeric(seq(from=1,to=2,by=0.1))) #?seq

  # --character: strings
    (char_vector <- as.character(c("a","b","c","d","e","f","g","h","i","j"))) # OR    (char_vector <- letters[seq(from = 1, to = 10)])

  # --integer: integer numbers
    (int_vector <- as.integer(1:10)) #?":"

  # --factor: numeric but with labels
    (fact_vector <- as.factor(c("a","b","c","d","e","f","g","h","i","j"))) #?c
    str(fact_vector)
    str(char_vector)

# 2) collection of vectors:
  # --matrix: collection of vectors of the same type
    (mat <- matrix(data=1:25,nrow=5,ncol=5)) #?matrix
    
  # --data.frame: collection of different vector types (what we work with most often)
    (df <- data.frame(int_vector,fact_vector)) #help(data.frame)
  
  # -- data.table: enhanced data.frame
    #LOAD THE PACKAGE 'data.table
    #people who are NOT working on athena will have to install this package first. Since all packages are preloaded on Athena, the only thing you need to do is load them into R using library() or require().
    #Once the package is installed, load it into R using require(name_of_package) or library(name_of_package).
    #install.packages('data.table')
    require(data.table) #library(data.table) does the same thing.
    
    (dt <- data.table(int_vector,fact_vector))
    (dt2 <- data.table(df))
    
    #CONCLUSION data.table: 
      #data.table can be seen as an enhanced version a data.frame. Everything you do in a data.frame you can do in a data.table, so a data.table inherits functions from a data.frame!
      #The syntax of a data.table differs from that of a data.frame. In the help file and the documentation on minerva, you can find out how it works in detail.
      #The data.table package also has some handy functions -besides data.table()- which make coding a lot easier and faster. These functions work with both data.table and data.frame.  
      #You are free to use data.frame or data.table. But when working with large datasets, a data.table cuts processing time and is more efficient!

# 3) collection of all object types in R: vectors, data.frames, objects from packages, lists, ...
  # --list
  (l <- list(df=df,mat=mat,int=int_vector))
  
  #By using name_of_your_object = object, you can name an element in a list. Notice the difference:
  list(df=df,mat=mat,int=int_vector)
  list(df,mat,int_vector)

#1.2. Subsetting
#1.2.1. Subsetting for vectors: Use [indicator]
  #select the second element
  num_vector[2]
  #select the fist two elements
  num_vector[1:2]
  #select element 1 and 3
  num_vector[c(1,3)]

#1.2.2. Subsetting for collection of vectors (matrix and data.frame): Use [row indicators, column indicators]
  #subsetting for a data.frame
  df
  #select element on row 3, column 2
  df[3,2]
  #select column 2
  df[,2]
  df[,c(FALSE,TRUE)]
  df[2]
  #select row 2
  df[2,]
  #select row 1 and 2
  df[,1:2]
  df[,c(TRUE,TRUE)]
  df[1:2]
  #you can also use the column names
  df
  #select column 2
  df$fact_vector #is the same as df[,2]
  df[,'fact_vector']
  #select row 1 and 2
  df[, c('fact_vector', 'int_vector')]
  
  #subsetting for a data.table
  dt
  #the syntax of data.table can be compared with SQL:
  #DT[i,j,by]
  #i = WHERE , j = SELECT , by = GROUP BY
  
  #select element on row 3, column 2
  dt[3,2] #returns 2, this is because the second argument of a data.table is always an expression. Column names are seen as variables in data.table
  # bad solution
  dt[3,2,with=FALSE] # if you set with = FALSE, then the syntax of a data.table is the same as a data.frame
  # the data.table way
  dt[3,fact_vector]
  #select column 2
  dt[, fact_vector]
  #select row 2
  dt[2,]
  dt[2]
  #you can also use the column names with the '$' as in data.frame
  #select column 2
  dt$fact_vector
  #select row 1 and 2
  #if you want to select more than 1 column, you have to make a list.
  dt[, list(fact_vector, int_vector)]
  #another good solution is to work with the .SD and .SDcols argument
  #.SD automatically selects all the columns, in the .SDcols argument you can specify which ones by name (with '') or by position
  dt[, .SD]
  dt[, .SD, .SDcols = c(1,2)]

#1.2.3. Subsetting for lists: Use [[]]  or '$' (if you have specified the names in your list)
  l
  #select second element
  l[[2]]
  l$mat
  #select column two of the second element
  l[[2]][,2]
  #
  l$mat[,2]

#1.3. Renaming
rownames(df)
colnames(df) #or names(df)

(names(df) <- c("a","b"))

# from the data.table package
#This function is also more efficient, in comparison to 'names()'
(setnames(df,c("a","b"),c("c","d")))

#Let's rename the second variable of df to 'Whatever'
colnames(df)[2] <- 'Whatever'
setnames(df,"c","a")
df

#1.3. Working with IDs
#it might be tempting to store IDs as integers (which is often more memory efficient than as characters), but this will lead to incorrect imports for IDs with leading zeros.
as.integer('013')
as.character('013')

#EXERCISE: Using the df/dt and l objects, select the numbers corresponding with the letters 'd' and 'g.
(df <- data.frame(int_vector,fact_vector))
(dt <- data.table(int_vector,fact_vector))

##########################################################################################################
#2 MEMORY MONITORING AND MANAGEMENT

#2.1. On object class sizes:

#Consider 1000 values, each value unique
object.size(as.integer(1:1000))
object.size(as.numeric(1:1000))
object.size(as.character(1:1000))
object.size(as.factor(1:1000)) #store 1000 labels
#evt nog extra voorbeeldje voor data.table

#Consider 1000 values, only 2 unique values
object.size(as.integer(c(rep(1,500),rep(0,500))))
object.size(as.numeric(c(rep(1,500),rep(0,500))))
object.size(as.character(c(rep(1,500),rep(0,500))))
object.size(as.factor(c(rep(1,500),rep(0,500)))) #store 1000 integers and 2 labels

#CONLUSION: Factors in R are stored as a vector of integer values with a corresponding set of labels.
#When you need to choose between character and factor, apply the following rules: 
  #When you have many unique values, use  character
  #When you have a few unique values, use factor

#2.2. Deleting all objects and clearing memory:
#-Removing 1 object
rm(df)

#-Removing all objects in the global environment
#Select all objects in the global environment
ls()

#remove all the objects in the global environment from memory
rm(list=ls())

#remove all the object in the global environment except for 1
x <- 1
rm(list = setdiff(ls(), 'x'))

##########################################################################################################
#3 READ IN DATA
setwd('H:\\Doctoraat\\Predictive & Prescriptive Analytics\\2016\\Course\\Introduction to R') #On Windows use \\ or /, on Linux or Unix (Mac) use /
getwd()

#read.table()
#The most flexilble way to read in data.
#read.table() reads in the files in a table format and autmatically converts it to a data.frame. The most important arguments are sep = '' and header = c(TRUE,FALSE). 
#other important variants are read.csv(), read.delim() --> these functions are read.table arguments but with the 'sep' and 'header' argument adapted. 

#open txt file
subscriptions <- read.table(file = "subscriptions.txt", header=TRUE, sep=";")
# you see that characters are autmoatically converted to factors, if you want to change add stringsAsFactors = FALSE or use the 'ColClasses' argument.

#Notice the advantage of using 'colClasses' with read.table, this allows you to set the correct type per variable, whilst reading the file into R.
subscriptions <- read.table("subscriptions.txt", header=TRUE, sep=";", colClasses=c("character","character","character","character","character","character","integer","integer","character","factor","factor","character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

#fread()
#enhanced and faster read.table() from the data.table-package. The 'sep', 'colClasses' and 'header' are automatically detected. 
subscriptions <- fread("subscriptions.txt")

##########################################################################################################
#4 DATA EXPLORATION

##Class
class(subscriptions)

##Dimension
dim(subscriptions)
nrow(subscriptions) #same as dim(subscriptions)[1]
ncol(subscriptions) #same as dim(subscriptions)[2]

##Structure
#str: the basic structure of the data object is displayed. But also the object class and some example values.
#Using this function to see the structure of your data, should be your first instinct.
str(subscriptions)

##First and last observations
head(subscriptions)
tail(subscriptions)

##Length: number of elements in a vector, list, ...
length(subscriptions$PaymentType)

##Names
colnames(subscriptions)
names(subscriptions)

#EXERCISE: Display a random subset of 5 elements 


##Frequencies
table(subscriptions$PaymentType)

#EXERCISE: relative frequencies of PaymentStatus, rounded on two-digits.

##Summary statistics
#Many functions are object-oriented: the same function reacts differently to different data types, this is called method dispatching
summary(subscriptions$PaymentType)
summary(subscriptions$TotalPrice)

mean(subscriptions$TotalPrice, na.rm=TRUE)

var(subscriptions$TotalPrice, na.rm=TRUE)

sd(subscriptions$TotalPrice, na.rm=TRUE)

cor(subscriptions$TotalPrice[!is.na(subscriptions$TotalPrice)], 
    subscriptions$NbrNewspapers[!is.na(subscriptions$TotalPrice)])
#the cor-function does not have an 'na.rm=TRUE', so you need to manually delete the NAs before using the function

range(subscriptions$TotalPrice,na.rm = TRUE)

min(subscriptions$TotalPrice, na.rm=TRUE)

max(subscriptions$TotalPrice, na.rm=TRUE)

is.numeric(subscriptions$TotalPrice)

is.numeric(subscriptions$CustomerID)

##Plotting
plot(subscriptions$PaymentType)
plot(subscriptions$TotalPrice)

hist(subscriptions$TotalPrice)

pairs(subscriptions[,17:21]) # a scatterplot matrix of all variables in the data

plot(subscriptions$NbrNewspapers,subscriptions$TotalPrice)

#another package that is used a lot for plotting is ggplot2

##########################################################################################################
#5 MISSING VALUES
  #One important aspect in Analytics is how to treat missing data. Depending on the variable, you will handle missing data in different ways.
  #GENERAL RULE: Replace NA's with mode or median.

#Consider a data frame with missing values
data <- data.frame(v_int=as.integer(c(1,1,2,NA)),v_num=as.numeric(c(1.1,1.1,2.2,NA)),v_char=as.character(c('one','one','two',NA)),v_fact=as.factor(c('one','one','two',NA)),stringsAsFactors = FALSE)
data
str(data)

#locate the NA's
is.na(data)

#how many missings per variable?
colSums(is.na(data))

#Replace NA with the mode in case of factor or character and median in case of integer or numeric.
#load package imputeMissings
#in the package impute you can also choose to impute with random forest. 
#This imputes the values first with the median and to mode, makes predictions and then replaces the missings with the predictions.
#There is also a compatbility for predictive contexts
#install.packages('imputeMissings')
library(imputeMissings)
(imputed <- impute(data))

str(imputed)


#Exercise: Change the missing value of the first column to 0. 
data <- data.frame(v_int=as.integer(c(1,1,2,NA)),v_num=as.numeric(c(1.1,1.1,2.2,NA)),v_char=as.character(c('one','one','two',NA)),v_fact=as.factor(c('one','one','two',NA)),stringsAsFactors = FALSE)
data

##########################################################################################################
#6 INSTALLING AND LOADING PACKAGES

#Install a package called rotationForest
#install.packages('rotationForest')
#Then load the package
library('rotationForest')
# you can also use require(). The difference between require() and library() is that require() TRIES to load a package i.e. require()=try(library()).
# For extra information on the difference between require() and library() see http://www.r-bloggers.com/library-vs-require-in-r/.

help(rotationForest)
?rotationForest
help(predict.rotationForest) #getting some information about a method of a package

#Loading more then 1 package
for (i in c('rotationForest', 'kernelFactory', 'AUC')) if(!require(i, character.only = TRUE, quietly = TRUE)) install.packages(i) ; require(i, character.only = TRUE, quietly = TRUE)






