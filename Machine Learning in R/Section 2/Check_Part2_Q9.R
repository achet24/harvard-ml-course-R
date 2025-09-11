library(dslabs)
library(tidyverse)
library(caret)
library(purrr)

# Load and filter iris data
data(iris)
iris <- iris %>% filter(Species != "setosa") %>% droplevels()
y <- iris$Species

# Split data
set.seed(76)
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
test <- iris[test_index, ]
train <- iris[-test_index, ]

# Create Petal.Width cutoffs (use observed range from train set)
cutoff_pw <- seq(floor(min(train$Petal.Width)), ceiling(max(train$Petal.Width)), by = 0.1)

# Evaluate accuracy for each cutoff
accuracy_pw <- map_dbl(cutoff_pw, function(x) {
  y_hat <- ifelse(train$Petal.Width > x, "virginica", "versicolor") %>%
    factor(levels = levels(train$Species))
  mean(y_hat == test$Species)
})

# Step 1: Best cutoff
best_cutoff_pw <- cutoff_pw[which.max(accuracy_pw)]

# Step 2: Final predictions on test set
y_hat_final_pw <- ifelse(test$Petal.Width > best_cutoff_pw, "virginica", "versicolor") %>%
  factor(levels = levels(test$Species))

# Step 3: Final accuracy
final_accuracy_pw <- mean(y_hat_final_pw == test$Species)
print(best_cutoff_pw)
print(final_accuracy_pw)


plot(iris, pch=21, bg=iris$Species)

cutoff_pl <- seq(floor(min(train$Petal.Length)), ceiling(max(train$Petal.Length)), by = 0.1)

accuracy_pl <- map_dbl(cutoff_pl, function(x) {
  y_hat <- ifelse(train$Petal.Length > x, "virginica", "versicolor") %>%
    factor(levels = levels(train$Species))
  mean(y_hat == test$Species)
})

# Step 1: Best cutoff
best_cutoff_pl <- cutoff_pl[which.max(accuracy_pl)]

pred_flower <- ifelse(test$Petal.Length > best_cutoff_pl & test$Petal.Width > best_cutoff_pw, "virginica", "versicolor")
final_accuracy <- mean(pred_flower==test$Species)
print(final_accuracy)
