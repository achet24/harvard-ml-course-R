# Supervised Learning models
library(titanic)    # loads titanic_train data frame
library(caret)
library(tidyverse)
library(rpart)

# 3 significant digits
options(digits = 3)

# clean the data - `titanic_train` is loaded with the titanic package
titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age), # NA age to median age
         FamilySize = SibSp + Parch + 1) %>%    # count family members
  select(Survived,  Sex, Pclass, Age, Fare, SibSp, Parch, FamilySize, Embarked)

set.seed(42)
split2 <- createDataPartition(titanic_clean$Survived, p = 0.2, list = FALSE)
train_set <- titanic_clean[-split2, ]
test_set <- titanic_clean[split2, ]

nrow(train_set)    # 712 observations in the training set - Correct

nrow(test_set)     # 179 observations in the test set - Correct

print(sum(train_set$Survived==1))     # 273 Individuals survived in training set - Incorrect
prop.table(table(train_set$Survived))     # 0.383 - Correct. Misinterpreted question. This is the proportion of individuals in the training set who survived.


# Q2: Randomly guess whether that an individual survived by sampling from the vector c(0,1) in the test set. Use default argument setting of prob in sample function. What is the accuracy of this guessing method?
set.seed(3)
vector <- c(0,1)

# Learning how to use sample()
guess <- sample(vector, nrow(test_set), replace = TRUE)
print(mean(guess == test_set$Survived))   # 0.458 Accuracy of method - Incorrect
# 0.542 Accuracy of method. Re-ran the code again and answer changed. 


# Q3a: Predicting survival by sex using training set
# What proportion of training set females survived?

female_survived <- mean(train_set$Survived[train_set$Sex] == 1)
print(female_survived)     # NA consule output - Definitely Incorrect.

# Second attempt. Will use dplyr. Its funcitons like filter(), mutate(), summarize() do not modify original dataset, instead creates new temp dataframe called a tibble. 
# Can view tibble in console or new object.

female_survived <- train_set %>%
  filter(Sex== "female") %>%
  summarize(prob_survived = mean(Survived == 1))
print(female_survived)    # 0.733 of training set females survived - Correct

male_survived <- train_set %>%
  filter(Sex == "male") %>%
  summarize(prob_survived = mean(Survived == 1))
print(male_survived)     # O.193 of Male survived proportion - Correct
# Lesson: Figured out syntax on how to find out if individual survived based on two characteristics.

# Q3b: Predicting survival by sex
# Step 1: Predict survival using sex on the test set, if the survival rate for a sex is over 0.5, predict survival for all individuals of that sex, and predict death if the survival rate for a sex is under 0.5.

female_test_survival <- test_set %>%
  filter(Sex == "female") %>%
  summarize(pred_survived = mean(Survived == 1))
print(female_test_survival)     # 0.778 of females survived -> Hence all females survived in model

male_test_survival <- test_set %>%
  filter(Sex == "male") %>%
  summarize(pred_survived = mean(Survived == 1))
print(male_test_survival)     # 0.172 of males survived-> Hence, all males died in model

# Sex based prediction model accuracy
pred_sex_based <- ifelse(test_set$Sex == "female", 1, 0)
print(mean(pred_sex_based == test_set$Survived))     # 0.81 Accuracy. - Correct

# Q4a: Predicting survival by passenger class
# In the training set, which class(es) (Pclass) were passengers more likely to survive than die?
# Re-applying what I learned in previous question to generate survival rate table based on social class. 
class_pred <- train_set %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived ==1))
print(class_pred)     # Members of class 1 were most likely to survive. - Correct

# Q4b: What is the accuracy of this class-based prediction method on the test set?
test_class_pred <- test_set %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived == 1))
print(test_class_pred)     # From table analysis of test set: 1 & 2 Survived, 3 Died 

pred_class_model <- ifelse(test_set$Pclass == 3, 0, 1)
print(mean(pred_class_model == test_set$Pclass))
# 0.201 Accuracy - Incorrect. Will use prediction from train set to make test set model

pred_class_model <- ifelse(test_set$Pclass == 1, 1, 0)
print(mean(pred_class_model == test_set$Pclass))
# Answer is the same. 

# Oh! It should be mean(pred_class_model == test_set$Survived)

print(mean(pred_class_model == test_set$Survived))    # 0.682 Accuracy - Correct

# Q4c Using training set group passengers by both sex and passenger class.
# Which sex and class combinations were more likely to survive than die (i.e. >50% survival)?

female_survived_classes <- train_set %>%
  filter(Sex == "female") %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived == 1))
print(female_survived_classes)


male_survived_classes <- train_set %>%
  filter(Sex == "male") %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived == 1))
print(male_survived_classes)

# Female 1 & 2 Class most likely to survive.

# Q4d: Predict survival using both sex and passenger class on the test set. Predict survival if the survival rate for a sex/class combination is over 0.5, otherwise predict death.
# What is the accuracy of this sex and class-based prediction method on the test set?

female_survived_classes <- test_set %>%
  filter(Sex == "female") %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived == 1))
print(female_survived_classes)   # 1, 2, 3 class female survived. 

male_survived_classes <- test_set %>%
  filter(Sex == "male") %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived == 1))
print(male_survived_classes)     # All males died

pred_model_class <- ifelse(test_set$Sex=="female", 1, 0)

print(mean(pred_model_class == test_set$Survived))
# 0.615 Accuracy - Incorrect. Definately a syntax error. Must of set up pred_model_class incorrectly.
# 0.81 Accuracy - Incorrect. I learned that the rules should come from the training set, not the test set. So Female Class 1 & 2 are the only ones who survived

# Third attempt
# Must set rules and then program prediction model accordingly. Below is also a much more effective way of seeing characteristics of dataset. 
# Rules is now a dataframe with four columns, Sex, Pclass, rate, and pred. First three are information gathered from original dataset, pred is based on rate.
rules <- train_set %>%
  group_by(Sex, Pclass) %>%
  summarize(rate = mean(Survived == 1), .groups = "drop") %>%
  mutate(pred = ifelse(rate > 0.5, 1, 0))

print(rules)

# Below: applying rules to test set. Learning how to use left_join() - function from dplyr, sort of similar to iterating over a dictionary based on characteristics of another dictionary. Miss Python.
# test_pred has teh same columns as rules
pred_sex_class <- test_set %>%
  left_join(rules, by = c("Sex", "Pclass"))

mean(pred_sex_class$pred == test_set$Survived)     # Answer: 0.793 - Correct!


# Prediction models: pred_sex_based, pred_model_class, pred_sex_class

# 5a: Confusion Matix

# Must make all values factors.
# I need to learn how to make this into a for loop function for this to be more efficient.
# Need to make all of them a dataframe like the previous question

rules <- train_set %>%
  group_by(Sex) %>%
  summarize(rate = mean(Survived == 1), .groups = "drop") %>%
  mutate(pred = ifelse(rate > 0.5, 1, 0))

pred_sex_based <- test_set %>%
  left_join(rules, by = c("Sex"))

pred_sex_based$pred <- as.factor(pred_sex_based$pred)

rules <- train_set %>%
  group_by(Pclass) %>%
  summarize(rate = mean(Survived == 1), .groups = "drop") %>%
  mutate(pred = ifelse(rate > 0.5, 1, 0))
         
pred_model_class <- test_set %>%
  left_join(rules, by = c("Pclass"))

pred_model_class$pred <- as.factor(pred_model_class$pred)
pred_sex_class$pred <- as.factor(pred_sex_class$pred)

cm_s <- confusionMatrix(pred_sex_based$pred, reference = test_set$Survived)
cm_c <- confusionMatrix(pred_model_class$pred, reference = test_set$Survived)
cm_sc <- confusionMatrix(pred_sex_class$pred, reference = test_set$Survived)

# Print information i.e. Sensitivity, Specificity, Balanced Accuracy, 'Positive' Class
cm_s
cm_c
cm_sc

factor_testPred <- factor(test_set$Survived)

f_s <- F_meas(pred_sex_based$pred, factor_testPred)
f_c <- F_meas(pred_model_class$pred, factor_testPred)
f_sc <- F_meas(pred_sex_class$pred, factor_testPred)

f_s    # 0.85
f_c    # 0.775
f_sc   # 0.855
# F1 score of sex/class combined model has the highest score of 0.855.