# Training all models in a function. So cool
models <- c("glm", "lda", "naive_bayes", "knn", "gamLoess", "qda", "rf")
library(caret)
library(dslabs)
library(tidyverse)
set.seed(1)
data("mnist_27")

fits <- lapply(models, function(model){
  print(model)
  train(y ~ ., method = model, data = mnist_27$train)
})

names(fits) <- models

# Create matrix of predictions for the test set.

pred_matrix <- sapply(fits, function(fit) {
  predict(fit, mnist_27$test)
})

dim(pred_matrix)
length(mnist_27$test$y) # Rows = 200 - Correct 
length(models) # Columns = 7 - Correct

cm <- lapply(pred_matrix, function(preds){
  print(preds)
  cm1 <- confusionMatrix(preds, mnist_27$test$y)
  print(cm1)
})

# Above code is incorrect because data and reference are not the factors of the same level. lapply() returns list, sapply() returns vector or matrix, but if unable to it will also return a list.

# colMeans() computes the mean of each column, proportion of correct predictions

accuracies <- colMeans(pred_matrix == mnist_27$test$y)
accuracies
mean(accuracies) # Mean accuracy accross all models = 0.81 - Correct

# Build an ensemble prediction model. Vote 7 if more than 0.5 of the models predict 7, else 2.
# What is the accuracy of the ensemble? 
# Code translation: If the mean of the prediction in a model is greater than 0.5, predict 7.

ensemble_pred <- ifelse(rowMeans(pred_matrix=="7") > 0.5, "7", "2")
accuracy <- mean(ensemble_pred == mnist_27$test$y)
accuracy # Accuracy = 0.825 - Correct

# kNN and gamLoess perform better than the ensemble model. Maybe I should make using only the kNN and gamLoess model? 
# Realized that it should not be done because it might overfit the training and test sets.

# Obtain minimum accuracy estimates obtained from cross validation with training dta for each model from fit$results$Accruacy

min_accuracy <- sapply(fits, function(fit){
  max(fit$results$Accuracy)
})
min_accuracy
mean(min_accuracy) # Mean of training set accuracy estimates = 0.80 - Correct!

# Reflection: Learned how to obtain information from matrices and interate over matrices. Realized it is very similar to Python ndarray.

# Make ensemble with minimum accuracies > 0.8. This would be easier to do in Python I believe.
# names() - gets names of elements in an object (i.e. vector, list, or data frame)
selected_models <- names(min_accuracy[min_accuracy >= 0.8])

# new prediction matrix with the selected models
selected_pred_matrix <- pred_matrix[, selected_models]
selected_pred_matrix # naive_bayes, gamLoess, qda - Correct
ensemble_pred2 <- ifelse(rowMeans(selected_pred_matrix == "7") >= 0.5, "7", "2")
accuracy <- mean(ensemble_pred2 == mnist_27$test$y)
accuracy # 0.825 - Incorrect on system, but all other classmates got the same answer. Rounded down to 0.82 and it worked.

# Lesson: Learned to a great extent how to iterate, manipulate, extrapolate information from a matrix