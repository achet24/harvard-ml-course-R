# Unsupervised learning
set.seed(1)

library(titanic)    # loads titanic_train data frame
library(caret)
library(tidyverse)
library(rpart)

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

# Q7: Training model using Loess (Local Estimated Scatterplot Smoothing), using fare as the only predictor. Use train() class formula.
loess_model <- train(Survived ~ Fare, data = train_set, "gamLoess")

# Prediction
pred_loess <- predict(loess_model, newdata = test_set)

# Check accuracy
mean(pred_loess == test_set$Survived)     # 0.665 Accuracy - Correct

# Q8: Logistic Regression Models
set.seed(1)
lrm_model <- train(Survived ~ Age, data = train_set, method = "glm")
pred_glm <- predict(lrm_model, newdata = test_set)
mean(pred_glm == test_set$Survived)     # 0.615 Accuracy - Correct

# Four predictors: sex, class, fare, and age
set.seed(1)
lrm4 <- train(Survived ~ Sex + Pclass + Fare + Age, train_set, "glm")
pred_lrm4 <- predict(lrm4, newdata = test_set)
mean(pred_lrm4 == test_set$Survived)     # 0.821 Accuracy - Correct

# Use all predictors
set.seed(1)
lrmAll <- train(Survived ~ ., train_set, "glm")
predAll <- predict(lrmAll, newdata = test_set)
mean(predAll == test_set$Survived)     # 0.827 Accuracy - Correct

# Q9: kNN Model
set.seed(6)
kNN_model <- train(Survived ~ ., data = train_set, method = "knn", tuneLength = seq(3, 51, 2))
plot(kNN_model)     # k = 7 is the optimal number of neighbors - Incorrect

# Lesson: tuneLength automatically generates tuning parameters. That's why on the graph it only showed values 5-9 for number of neighbors.

# 2nd attempt below:
kNN_model <- train(Survived ~ ., data = train_set, method = "knn", tuneGrid = data.frame( k = seq(3, 51, 2)))
kNN_model$bestTune     # k = 21 provids optimal number of neighbors - Incorrect.

# Lesson: kNN need an object that configures the re-sampling method. Re-sampling method basically experiments with different sections of the same dataset being used as either the test or train set.
# Reflection: Unsupervised learning using re-sampling and bootstrap to create models that do not overfit dataset.

# 3rd attempt below:
ctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
kNN_model <- train(Survived ~ ., data = train_set, method = "knn", trControl = ctrl, tuneGrid = data.frame( k = seq(3, 51, 2)))
kNN_model$bestTune     # k = 21 - Incorrect. Very confused.

# 4th Attempt
set.seed(6)
ctrl <- trainControl(method = "cv", number = 10)
kNN_model <- train(Survived ~ ., data = train_set, method = "knn", trControl = ctrl, tuneGrid = data.frame( k = seq(3, 51, 2)))
kNN_model$bestTune     # k = 5 - Incorrect
plot(kNN_model)

# 5th Attempt
set.seed(6)
k <- data.frame(k = seq(3, 51, 2))
kNN_model <- train(
  Survived ~ ., 
  data = train_set, 
  method = "knn",
  tuneGrid = k)

pred <- predict(kNN_model, newdata = test_set)
confusionMatrix(pred, test_set$Survived).     # Accuracy = 0.732 - Correct
kNN_model$bestTune
kNN_model$results
# Lesson: k needs to be a dataframe for tuneGrid, not a numeric vector as I had done before.
# Reflection: I still do not understand why my answer for bestTune is wrong. There is no bug in my code, but I keep getting k = 21, 25, or 15 when the answer is k = 11.


# Q:10 Cross-Validation
# Set the seed to 8 and train a new kNN model. Instead of the default training control, use 10-fold cross-validation where each partition consists of 10% of the total. Try tuning with k = seq(3, 51, 2)
set.seed(8)
kNN2 <- train(
  Survived ~ .,
  data = train_set,
  method = "knn",
  tuneGrid = k,
  trControl = trainControl(method = "cv", number = 10)
  )
kNN2$bestTune     # k = 23 - Correct
pred <- predict(kNN2, newdata = test_set)
confusionMatrix(pred, test_set$Survived)     # Accuracy = 0.732 - Correct

# Q11a: Classification tree model
set.seed(10)
cp = data.frame(cp = seq(0, 0.05, 0.002))
tree <- train(
  Survived ~ .,
  data = train_set,
  method = "rpart",
  tuneGrid = cp,
)
pred <- predict(tree, newdata = test_set)
tree$bestTune     # Optimal value complexity parameter = 0.02
confusionMatrix(pred, test_set$Survived)     # Accuracy = 0.849
tree$trainingData

# Checking which variables were used for classification tree model
rpart.plot(pred).    # import library(rpart.plot)
summary(tree$finalModel)
varImp(tree) # Predictors used: Sex, Pclass, Fare, FamilySize, SibSp, EmbarkedC, Age, EmbarkedS, EmbarkedQ


# Viewing descision tree diagram
library(rpart)
install.packages("rpart.plot")
library(rpart.plot)
rpart.plot(tree$finalModel, type = 2, extra = 104, fallen.leaves = TRUE)    
# Lesson: Printed a desicion tree! So exciting.
# ReadME has analysis of chart

# Q12: Random Forest model
set.seed(14)
ranforest <- train(Survived ~ ., data = train_set, method = "rf", mtry = seq(1:7), ntree = 100)
tuneGrid <- data.frame(.mtry = seq(1:7))
rfmodel <- train(
  Survived ~ ., 
  data = train_set,
  method = "rf",
  tuneGrid = tuneGrid,
  ntree = 100)
rfmodel$bestTune # mtry value that maximizes accuracy = 3 - Incorrect
pred <- predict(rfmodel, newdata = test_set)
confusionMatrix(pred, test_set$Survived) # Accuracy = 0.883
rfmodel$results.  # mtry value that maximizes accuracy = 2 - Correct!

# Lesson: bestTune give optimal value, results show general accuracy 
