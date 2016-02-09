#QUESTIONS ABOUT THIS DOCUMENT:   matthias.bogaert@ugent.be     steven.hoornaert@ugent.be

##########################################################################################################
#Contents of this file:

#5 DATES
#6 WORKING WITH CHARACTERS
#7 CREATING FUNCTIONS
#8 CONDITIONAL PROCESSING
#9 LOOPS
#10 TIMING CODE

##########################################################################################################
#5 DATES
#The function as.Date() transforms a character or numeric vector into an object of class 'Date'.

#5.1.   When you read in data, dates are read in as a CHARACTER vector. To transform a character to a Date object:
date_to_transform <- "2015-01-15" #In R, the standard read-in format is: "YYYY-MM-DD"
class(date_to_transform) #date_to_transform is of class "character"

date_transformed <- as.Date(date_to_transform)
class(date_transformed) #date_transformed is of class "Date"

#5.2.   When using as.Date on a NUMERIC vector you need to set the origin. The origin on this system is "01/01/1970".
help(as.Date)
as.Date(10,origin="1970/01/01") #in this case, 10 days are added to the origin, which results in "1970-01-11"

#5.3.   R has some built-in functions to return the current date and datetime
Sys.Date()
Sys.time()

#5.4.   Formatting dates
format(Sys.Date(),"%d")
format(Sys.Date(),"%A %dth of %B %Y")

#To change the language in which the result is returned
Sys.getlocale()
#English
  Sys.setlocale("LC_TIME", "English") #FOR MAC OS: Sys.setlocale("LC_TIME", "en_US")    #FOR LINUX: Sys.setlocale("LC_TIME", "en_US.UTF-8")
  format(Sys.Date(),"%A")
  
#French
  Sys.setlocale("LC_TIME", "French")  #FOR MAC OS: Sys.setlocale("LC_TIME", "fr_FR")    #FOR LINUX: Sys.setlocale("LC_TIME", "fr_FR.UTF-8")
  format(Sys.Date(),"%A")
  
  
# Most relevant formats:
# %d  day as a number 
# %a  abbreviated weekday 
# %A  unabbreviated weekday	
# %m	month
# %b  abbreviated month
# %B	unabbreviated month
# %y  2-digit year
# %Y	4-digit year

#More information on formats:
help(strftime)
help(ISOdatetime)
# http://stat.ethz.ch/R-manual/R-devel/library/base/html/strptime.html

#Subtraction of two dates as Date object and Numeric object results in both cases in the number of days between the two dates:
f <- "%d/%m/%Y"
as.Date('02/01/1970',format=f) - as.Date('01/01/1970',format=f)
as.numeric(as.Date('02/01/1970',format=f)) - as.numeric(as.Date('01/01/1970',format=f))

#5.5.   Setting dates in data.frames
#Read in file
setwd('C:\\Users\\sghoorna\\Dropbox\\Teaching\\CLASS_PredictiveAndPrescriptive_Analytics\\Introduction_session_R')
subscriptions <- read.table("subscriptions.txt",header=TRUE, sep=";", colClasses=c("character","character","character","character","character","character","integer","integer","character","factor","factor","character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

str(subscriptions)

  #STEP 1: Select the appropriate date vars
  vars <- which(names(subscriptions) %in% c("StartDate","EndDate","PaymentDate","RenewalDate"))
  vars
  
  #STEP 2. Solution A.: Transform one date from character to Date object
  subscriptions$StartDate <- as.Date(subscriptions$StartDate,format="%d/%m/%Y")
  class(subscriptions$StartDate)
  
  #STEP 2. Solution B.: Transform multiple dates in one step
  subscriptions[,vars] <- sapply(vars,function(vars) {
    as.Date(subscriptions[,vars],format="%d/%m/%Y")
  },simplify=FALSE)

str(subscriptions)


#EXERCISE: Output the following sentence to the console: "The 6th of December of 1980 was a SATURDAY."

##########################################################################################################
#6 WORKING WITH STRINGS
#Most important functions: grep(l), (g)sub, regexpr and strsplit:
  #grep: evaluates for each element of a vector if a certain pattern is present. If it does, it returns the position in the vector where the pattern was found.
  #grepl = grep, where the 'l' stands for 'logical' (i.e. TRUE/FALSE). Instead of returning the position in the vector, it returns TRUE/FALSE.
  
  #sub/gsub: allows you to substitute a pattern with a replacement value
  
  #regexpr: evaluates for each vector element if the pattern was found (older version of 'grep()')
  
  #strsplit: returns a list of characters, splitted on the 'split'-value

  data(iris) #iris is a built-in dataset

#6.1.   grab all columns with 'Length'
  length_vars <- grep(pattern="Length",names(iris))

#6.2.   Check if a column contains an ID variable
  grepl("ID",names(iris)) #returns TRUE/FALSE for each

#6.3.  Notice the difference between sub and gsub
  #Substitute each 's' with "'s"
  names(iris)
  gsub(pattern="s",replacement="'s",names(iris),ignore.case=TRUE)
  
  #Substitute the first occurence of 's' with "'s"
  sub(pattern="s",replacement="'s",names(iris),ignore.case=TRUE)

#6.4.  Select all variables with a dot ('.') in their column names
  names(iris)
  regexpr(pattern="[.]",names(iris),useBytes=FALSE) #for punctuation symbols (?,!,.,...), squared brackets are required
  #regexpr returns the beginning position in a character where the pattern was found. If the pattern was not found, regexpr will return '-1'

  #For more information on regular expressions ('regex'): http://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html

#6.5.  Split a character on a character value
  str <- "abc$**$def$**$ghi$**$jkl$**$mno$**$pqr$**$stu$**$vwx$**$yz"
  strsplit(str,split="$**$",fixed=TRUE) #with fixed=TRUE, strsplit will look for this pattern exactly: '$**$'

#EXERCISE: Make some code to select the title and year of the blog post of the following url:
  url <- "http://www.mma.ugent.be/predictive_analytics/customer_intelligence/Blog/Entries/2014/10/30_DMA_2014_Conference_in_San_Diego%2C_CA.html"

##########################################################################################################
#7 FUNCTIONS

### Skeleton:

# function_name <- fuction(parameter_names) {
#
#     ** code block **
#
#    return(value)
# }

#STEP 1. Make the function
#This function sums two objects a and b and returns the summed result
  MySum <- function(a,b) {
    c <- a+b
    d <- c+5
    return(d) #the 'return()' statement contains the value you want returned by the function and that will be stored in the 'MySum'-object
  }

#STEP 2. Execute the function
  (sum_d <- MySum(1,2))

#EXERCISE: Make a function that returns the minimum, maximum, mean and range (i.e. difference between maximum and minimum of a variable) for a variable in a data.frame and call this function 'MyRange'
#Apply this function to the 'NbrNewspapers'-variable of the subscriptions table

##########################################################################################################
#8 CONDITIONAL PROCESSING

#Skeleton
#if (condition which can result in TRUE/FALSE) {
    #code to execute if function is TRUE
#} else {
    #code to execute if function is FALSE
#}

x <- 1
x <- 3
x <- 5
x <- 4
x <- 7
x <- 9

#Logic gate operators:
  #AND:   &
  #OR:    || or |
  #NOT:   !

if (x <= 2) {
    print("Smaller than or equal to 2")
} else if (x == 3 || x==5) {
    print("Equal to 3 or 5")
} else if (x<=6 & x>=4){
    print("Between 4 and 6")
} else if (!x %in% c(8,9)) {
  print("Not equal to 8 or 9")
} else {
  print("unknown value")
}

##########################################################################################################
#9 LOOPS

#9.1.   FOR AND WHILE LOOP
  for (i in 1:10) {
    print(paste("Number of loops executed: ",i,sep=""))
  }
  

  i <- 0
  while (i < 10){
    i <- i + 1
    print(i) 
  }

#9.2.   APPLY FAMILY
  #The apply family is specifically designed for R and consists of a series of fast, optimized loop-functions.
  #There are numerous functions available in the apply-family : apply, sapply, lapply, tapply, vapply, eapply, rapply, ... 
  #The most often used are: apply, sapply (and lapply)

#9.2.1. apply
  #Apply is used for iterating over rows or columns of a matrix or data.frame
  
  data(iris)
  str(iris)
  
  #Calculate the mean for each ROW
  iris$row_mean <- apply(iris[,names(iris)!="Species"],1,mean)
  
    #Alternative: rowMeans() - function
    #iris$row_mean <- rowMeans(iris[,names(iris)!="Species"])
  
  #Calculate the mean for each COLUMN
  apply(iris[,!names(iris) %in% c("Species","row_mean")],2,mean) #Alternative: colMeans()
  
#EXERCISE: 
#Use apply to return the product of Sepal.Length and Sepal.Width of the iris dataset for each row

  
#9.2.2. sapply: SIMPLIFIED apply
  #Sapply executes a function for each element of a vector and returns by default a 'simplified' result. 
  
  #If simplify=TRUE:
    #After all elements are processed, sapply will try to return the most appropriate object class for the result.
    #If all the values returned are of the same type (all values are numeric, character, Date,...): sapply will return a vector (or matrix) of that type
    #If the values returned are a composite of vector types (e.g. numeric + character): sapply will return a data.frame 
    #If the values returned are a composite of vectors and/or matrices and/or data.frames and/or lists: sapply will return a list
  
  #If simplify=FALSE: sapply will return the resulting values as a list. In that case sapply(,simplify=FALSE) = lapply(). 
  
  #Make a function that returns the number of unique values for each character or factor variable and the standard deviation for each numeric variable
  sapply_func <- function (var) {
    if (is.numeric(var)) return(sd(var))
    else if (is.character(var) || is.factor(var)) return(length(unique(var)))
    else return(NA)
  }
  
  sapply(X=iris,FUN=sapply_func)

#9.2.3. lapply = LIST sapply
  #returns the result always in 'list' format
  lapply(iris,sapply_func)
  sapply(iris,sapply_func,simplify=FALSE)

  #As was mentioned above, you can see: lapply(X,FUN) = sapply(X,FUN,simplify=FALSE)

#EXERCISE: 
#Make a function that returns the number of missing values per column

#Make a function that returns the number of missing values per row

##########################################################################################################
#10 TIMING CODE

## Two methods for timing code
(start <- Sys.time())
  Sys.sleep("1") #Sys.sleep() lets the system 'sleep' (="wait and do nothing") for x seconds
(Sys.time() - start)

#OR

system.time(Sys.sleep("1"))

## Efficiency data.table vs data.frame

#Create a huge dataset
system.time(df <- data.frame(x=rep(LETTERS, 1000000), y= rep(letters, 1000000), z= runif(1000000)))
system.time(rr<-df[df$x == 'R' & df$y == 'r',]) #16.05s on my system

dt <- as.data.table(df)
setkey(dt,x,y) # setkey sets one or more keys on a data.table. A data.table will be automatically sorted by the key(s).
system.time(RR<-dt[list('R','r'),]) #0.06s on my system wih a BINARY SEARCH

#or without defining a key (bad way but still faster than data.frame)
system.time(RR<-dt[x=='R' & y == 'r',]) #10.98s on my system with a VECTOR SCAN

#CONCLUSION:
  # Data.tables are more efficient than data.frames because they allow you to do binary searches.
  # Data.frames only work with vectors scans, this means that everytime you search something the entire column is scanned. This slows everything down.
  # When doing binary seaches, you are actually joining.

## Efficiency (s)apply and for-loop
  random_vector <- runif(1000000)

  #FOR LOOP
  (start <- Sys.time())
    forloop <- numeric()
    for (i in 1:length(random_vector)) forloop[i] <- random_vector[i]**2 + random_vector[i]
  (stop <- Sys.time()- start)
  #Time elapsed on my computer - forloop:     > 1h
  
  #SAPPLY
  (start <- Sys.time())
    sapplyloop <- sapply(random_vector, function (x) {
      return(x**2 + x)
    })
  (stop <- Sys.time()- start)
  #Time elapsed on my computer - sapplyloop:  12.57s

#CONCLUSION: 
  #The apply-family works much more efficient for large datasets than a for-loop; for small datasets however, the difference is negligable.




