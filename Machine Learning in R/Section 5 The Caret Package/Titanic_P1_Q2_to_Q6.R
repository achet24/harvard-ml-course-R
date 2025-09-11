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

nrow(train_set)
# Answer A: 712

nrow(test_set)
# Answer B: 179

print(sum(train_set$Survived==1))
# Answer C: 273

# Answers for A & B are correct, but not C. 

prop.table(table(train_set$Survived)) 

# Q2: Randomly guess whether that an individual survived by sampling from the vector c(0,1) in the test set. Use default argument setting of prob in sample function. What is the accuracy of this guessing method?
set.seed(3)
vector <- c(0,1)

# Learning how to use sample()

guess <- sample(vector, nrow(test_set), replace = TRUE)
print(mean(guess == test_set$Survived))
# Answer: 0.458

# Answer above is wrong. Should be correct though because guessing method for binary datasets would have around 0.5 accraucy. 
# Answer: 0.542. Ran the whole code again answer changed. Maybe the seed was incorrect the first time?


# Q3a: Predicting survival by sex
# Use training set

# What proportion of training set females survived?

female_survived <- mean(train_set$Survived[train_set$Sex] == 1)
print(female_survived)
# Answer: NA - Definately wrong.

# Second attempt. Will use dplyr. Its funcitons like filter(), mutate(), summarize() do not modify original dataset, instead creates new temp dataframe called a tibble. 
# Can view tibble in console or new object.

female_survived <- train_set %>%
  filter(Sex== "female") %>%
  summarize(prob_survived = mean(Survived == 1))

print(female_survived)
# Answer: Proportion of training set females survived = 0.733

male_survived <- train_set %>%
  filter(Sex == "male") %>%
  summarize(prob_survived = mean(Survived == 1))

print(male_survived)
# Answer: Male survived proportion 0.193 - Correct
# Learn: Figured out syntax on how to find out if individual survived based on two characteristics.

# Q3b: Predicting survival by sex
# Step 1: Predict survival using sex on the test set, if the survival rate for a sex is over 0.5, predict survival for all individuals of that sex, and predict death if the survival rate for a sex is under 0.5.

female_test_survival <- test_set %>%
  filter(Sex == "female") %>%
  summarize(pred_survived = mean(Survived == 1))
print(female_test_survival)
# 0.778, Hence all females survived

male_test_survival <- test_set %>%
  filter(Sex == "male") %>%
  summarize(pred_survived = mean(Survived == 1))
print(male_test_survival)
# 0.172, Hence, all males died.

# Sex based prediction model accuracy
pred_sex_based <- ifelse(test_set$Sex == "female", 1, 0)
print(mean(pred_sex_based == test_set$Survived))

# Answer: Sex based prediciton model is 0.81 accurate. - Correct

# Q4a: Predicting survival by passenger class
# In the training set, which class(es) (Pclass) were passengers more likely to survive than die?
# Re-applying what I learned in previous question to generate survival rate table based on social class. 
class_pred <- train_set %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived ==1))
print(class_pred)  
# Answer: Members of class 1 were most likely to survive. - Correct

# Q4b: What is the accuracy of this class-based prediction method on the test set?
test_class_pred <- test_set %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived == 1))
print(test_class_pred)

# From table analysis of test set: 1 & 2 Survived, 3 Died 

pred_class_model <- ifelse(test_set$Pclass == 3, 0, 1)
print(mean(pred_class_model == test_set$Pclass))
# Answer: 0.201 - Answer is wrong. Will use prediciton from train set to make test set model

pred_class_model <- ifelse(test_set$Pclass == 1, 1, 0)
print(mean(pred_class_model == test_set$Pclass))
# Answer is the same. 

# Ohhh, the error is that it should be mean(pred_class_model == test_set$Survived)

print(mean(pred_class_model == test_set$Survived))
# Answer: 0.682 - Correct

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

# Answer: female 1 & 2 Class most likely to survive.

# Q4d: Predict survival using both sex and passenger class on the test set. Predict survival if the survival rate for a sex/class combination is over 0.5, otherwise predict death.
# What is the accuracy of this sex- and class-based prediction method on the test set?

female_survived_classes <- test_set %>%
  filter(Sex == "female") %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived == 1))

print(female_survived_classes)

# 1 & 2 class female suvived. 

male_survived_classes <- test_set %>%
  filter(Sex == "male") %>%
  group_by(Pclass) %>%
  summarize(survival_rate = mean(Survived == 1))

print(male_survived_classes)

# All males died

pred_model_class <- ifelse(test_set$Survived[test_set$Pclass[test_set$Sex=="female"]] == 1, 1, 0)

print(mean(pred_model_class == test_set$Survived))
# Answer: 0.615 - Wrong. Definately a syntax error. Must of set up pred_model_class incorrectly.


