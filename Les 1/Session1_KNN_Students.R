#QUESTIONS ABOUT THIS DOCUMENT: matthias.bogaert@ugent.be or steven.hoornaert@ugent.be


##########################################################################################################
#Contents of this file:

#1.Time-window 
#1.Create training, validation and test set
#2.k-Nearest Neighbors
#3.Model performance measures


##########################################################################################################
setwd("C:\\Users\\matbogae\\Documents\\Doctoraat\\Teaching\\Predictive & Prescriptive Analytics\\2016\\Course\\Course1_IntroductionPredictiveAnalytics\\Data")

##########################################################################################################
#1. Time-window

#1.1. Define time-window

#take care of default date format
f <- "%d/%m/%Y"
setClass('fDate')
setAs(from="character",to="fDate", def=function(from) as.Date(from, format=f))

#subscriptions
subscriptions <- read.table("Introduction_to_R/subscriptions.txt",header=TRUE, sep=";", colClasses=c("integer","integer","character","character","fDate","fDate","integer","integer","fDate","factor","factor","fDate","integer","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

#Set timewindow
start_ind <- as.Date('02/01/2006', f)
end_ind <- as.Date('01/06/2009', f)
start_dep <- as.Date('02/06/2009', f)
end_dep <- as.Date('02/06/2010', f) #dump date

#1.2. Defintion of churn

#We implement a basic definition of churn: if a customer did not have a newspaper subscription in the dependent period, the customer has churned.

#First we need to check if the customers are active at end_ind.
#Only select the active subscriptions that can be targeted in the dependent period (those whose subscriptions end in the dependent period)
#Active customers are customers who have a subscription before the independent period which ends in the dependent period. 
#We don't consider customers in our sample if their newspaper subscription ends after the end of the dependent period.
#(optional) We think a one day gap between dependent and independent period is advisable.
ActiveCustomerID <- unique(subscriptions[subscriptions$StartDate <= end_ind & 
                                           subscriptions$EndDate  > start_dep & 
                                           subscriptions$EndDate  <= end_dep ,"CustomerID"])


#This is one possibility. Another option would be to predict churn for customers with an EndDate in the gap or after the dependent period.
#ActiveCustomerID <- subscriptions[subscriptions$StartDate <= end_ind & subscriptions$EndDate  > end_ind ,"CustomerID"]

ActiveCustomerID <- unique(ActiveCustomerID)
length(ActiveCustomerID)

#Select only the subscriptions of the active customers
subs <- subscriptions[subscriptions$CustomerID %in% ActiveCustomerID,]

#Now we can create the churn variable.
#First look at the customers who renewed their subscription
subs$Renew <- ifelse((subs$StartDate >= start_dep & subs$StartDate <= end_dep),1,0)
table(subs$Renew)

#Customer churn = customers who did not renew
churners <- aggregate(subs[,'Renew'],by=list(CustomerID=subs$CustomerID),sum)
colnames(churners)[2] <- "churn"
subs$Renew <- NULL

churners$churn <- as.factor(ifelse(churners$churn==0,1,0))
table(churners$churn)/length(churners$churn) #28% churners
head(churners)

#1.3. Implement the independent period

#The next step will be to restrict all the tables to the independent period and make the basetable.
#Make sure that ALL the date variables do not exceed the end_indep BEFORE calculating the variables.

#EXERCISE: Restrict the subscriptions table to the time-window

##########################################################################################################
#2. Create training, validation and test set

load('Basetable.Rdata')
str(Basetable)
head(Basetable)
dim(Basetable)

#Remove the CustomerID variable, otherwise it will be modeled as a predictor.
Basetable$CustomerID <- NULL

#Before starting the analyses, clean up by removing all objects except the Basetable
rm(list=setdiff(ls(),"Basetable")) #setdiff returns which elements of the first argument are not in the second argument
ls()

# Set up modeling data-sets:
# -training set: build different models
# -validation set: evaluate different models and pick best one
# -test set: get final performance of best model (determined on validation set)

#create idicators

#randomize order of indicators
allind <- sample(x=1:nrow(Basetable),size=nrow(Basetable))

#EXERCISE: split the observations in three parts of (approx.) equal length
BasetableTRAIN <- Basetable[trainind,]
BasetableVAL <- Basetable[valind,]
BasetableTEST <- Basetable[testind,]

#Create a separate response variable
yTRAIN <- BasetableTRAIN$Retention
BasetableTRAIN$Retention <- NULL

yVAL <- BasetableVAL$Retention
BasetableVAL$Retention <- NULL

yTEST <- BasetableTEST$Retention
BasetableTEST$Retention <- NULL

table(yTRAIN);table(yVAL);table(yTEST)

#if no tuning is required then use TRAIN + VAL as a big training set
BasetableTRAINbig <- rbind(BasetableTRAIN,BasetableVAL)
yTRAINbig <- factor(c(as.integer(as.character(yTRAIN)),as.integer(as.character(yVAL))))

#check whether we didn't make a mistake
dim(BasetableTRAIN)
dim(BasetableVAL)
dim(BasetableTEST)

# ?intersect
intersect(rownames(BasetableTRAIN),rownames(BasetableTEST))
intersect(rownames(BasetableTRAIN),rownames(BasetableVAL))
intersect(rownames(BasetableTEST),rownames(BasetableVAL))
#intersection is empty so all datasets contain unique observations.

#save(list=c("BasetableTRAIN","yTRAIN"),file="TRAIN.Rdata")
#save(list=c("BasetableVAL","yVAL"),file="VAL.Rdata")
#save(list=c("BasetableTEST","yTEST"),file="TEST.Rdata")
#save(list=c("BasetableTRAINbig","yTRAINbig"),file="TRAINbig.Rdata")

##########################################################################################################
#2.KNN: K-Nearest Neighbors

#Fast Nearest Neighbor Search Algorithms and Applications.
if(require('FNN')==FALSE)  install.packages('FNN',repos="http://www.freestatistics.org/cran/"); require('FNN')

#Model evaluation using AUC.
if(require('AUC')==FALSE)  install.packages('AUC',repos="http://www.freestatistics.org/cran/"); require('AUC')

#the knnx function requires all indicators to be numeric so we need to convert the basetable first.
trainKNN <- data.frame(sapply(BasetableTRAIN, function(x) as.numeric(as.character(x))))
trainKNNbig <- data.frame(sapply(BasetableTRAINbig, function(x) as.numeric(as.character(x))))   
valKNN <- data.frame(sapply(BasetableVAL, function(x) as.numeric(as.character(x))))
testKNN <- data.frame(sapply(BasetableTEST, function(x) as.numeric(as.character(x))))

#note that all computations take place in the prediction phase

#example for 10 nearest neighbors:
k=10
#retrieve the indicators of the k nearest neighbors of the query data 
indicatorsKNN <- as.integer(knnx.index(data=trainKNNbig, query=BasetableTEST, k=k))
#retrieve the y-values from the training set for these indicators.
predKNN <- as.integer(as.character(yTRAINbig[indicatorsKNN]))
#if k > 1 than we take the proportion of 1s
predKNN <- rowMeans(data.frame(matrix(data=predKNN,ncol=k,nrow=nrow(testKNN))))


#if you want to tune
#Tuning comes down to evaluating which value for k achieves highest performance.

#EXERCISE: 
#-Tune the parameter k
#-plot the auc in terms of the number of k, what do you learn?
#-Select the optimal k
if(require('AUC')==FALSE)  install.packages('AUC',repos="http://www.freestatistics.org/cran/"); require('AUC')

auc <- numeric()
for (k in seq(from = 1, to = nrow(trainKNN), by = 2)) {

}



#the next step would be to train again on trainKNNbig using the best value of k and predict on testKNN
#retrieve the indicators of the k nearest neighbors of the query data 
indicatorsKNN <- as.integer(knnx.index(data=trainKNNbig, query=testKNN, k=k))
#retrieve the actual y from the tarining set
predKNNoptimal <- as.integer(as.character(yTRAINbig[indicatorsKNN]))
#if k > 1 than we take the proportion of 1s
predKNNoptimal <- rowMeans(data.frame(matrix(data=predKNNoptimal,ncol=k,nrow=nrow(testKNN))))

##########################################################################################################
#3.MODEL PERFORMANCE

# AUC
#package AUC
if(require('AUC')==FALSE)  install.packages('AUC',repos="http://www.freestatistics.org/cran/"); require('AUC')
auc(roc(predictions = predKNNoptimal,labels = yTEST))
plot(roc(predKNNoptimal,yTEST))

#package ROCR
if(require('ROCR')==FALSE)  install.packages('ROCR',repos="http://www.freestatistics.org/cran/"); require('ROCR')
performance(prediction.obj = prediction(predKNNoptimal,yTEST), measure = 'auc')@y.values
plot(performance(prediction(predKNNoptimal,yTEST),'tpr','fpr'))

#lift
#cumulative lift
if(require('lift')==FALSE)  install.packages('lift',repos="http://www.freestatistics.org/cran/"); require('lift')
TopDecileLift(predicted = predKNNoptimal, labels = yTEST)
plotLift(predKNNoptimal, yTEST)

#EXERCISE:interpret the cumulative lift curve

#non cumulative lift
# Use the ROCR pacakge .
#?performance for all the posstible options
plot(performance(prediction(predKNNoptimal,yTEST),measure = 'lift', x.measure = 'rpp'), main = 'Lift curve')

# Precision-recall curve
plot(performance(prediction(predKNNoptimal,yTEST),measure = 'prec', x.measure = 'rec'))

#F-measure
plot(performance(prediction(predKNNoptimal,yTEST),measure = 'f'))
