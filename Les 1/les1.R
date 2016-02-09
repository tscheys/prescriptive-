# les 1 
# when increasing the flexibility of your model, training error keeps on going dowm 
# this is misleading (les 1 slide 29)
# so you should find sweet spot via test MSE, where the error in red is minimal 

#slide 31 we want to be in the sweet spot: low variance, low bias 
#upper right, on average you still hit the bulls eye
#lower left, we don't hit the bulls eye, pred are close to each other but not on target
# example: when we model something very complex (reality) with a simple modelling technique
# lets say: human behaviour modelling with logistic regression 

# slide 35
# binary classification: it focusses you on the right thing (vdp is fan)
# you want as many obs in tn and tp quadrants 
# Accuracy = tp + tn / # total obs 
# Sensitivity = tp / (tn + tp)
# Specificity = ...

# slide 37 
# top decile lift: take first 10 percent, look at performance 
# if top decile lift is 5, it means that 
# on average we are doing 5 times better than if we were using not model

# F1-measure: balances sensitivity and precision  
# AUC: regardless of inbalance in the 2 classes (few churners, and a lot of loyal customers) = groups are inbalanced 
# other measures have trouble with this imbalance, AUC does not 

# slide 42: lift curve, very important, decision makers often want you to present this 
# categorize into buckets, gives you the top decile performance (eg the people with the highest churn chance)
# lift is 4: on average my model is 4 times better at identifying the churners then (using no model)
# shown is a cumalative lift curve 
# please show me the non-cumulative lift curve 

#KNN 

# rule: you should touch your test sample only once 
# to not misuse your test set, make a third dataset, a validation set 

# k nearest neigbours: you can have n-params, you will work in n-dimensions 
# is quite performant 
# disadvantage: very computational intensive (distance computing)
# k = 1 (might lead to overfitting)

