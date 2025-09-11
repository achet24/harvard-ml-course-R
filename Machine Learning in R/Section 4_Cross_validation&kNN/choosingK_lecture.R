library(caret)
library(dslabs)
data("mnist_27")
library(purrr)
library(tidyverse)

ks <- seq(3, 251, 2)
accuracy <- map_df(ks, function(k) {
  fit <- knn3(y~., data = mnist_27$train, k=k)
  
  y_hat <- predict(fit, mnist_27$train, type = "class")
  cm_train <- confusionMatrix(y_hat, mnist_27$train$y)
  train_error <- cm_train$overall["Accuracy"]
  
  y_hat <- predict(fit, mnist_27$test, type = "class")
  cm_test <- confusionMatrix(y_hat, mnist_27$test$y)
  test_error <- cm_test$overall["Accuracy"]
  
  tibble(train = train_error, test = test_error)
})

accuracy %>% mutate(k = ks) %>%
  gather(set, accuracy, -k) %>%
  mutate(set = factor(set, levels = c("train", "test"))) %>%
  ggplot(aes(k, accuracy, color = set)) +
  geom_line() +
  geom_point()

ks[which.max(accuracy$test)]
max(accuracy$test)

# Max accuracy is when ks = 9 and the accuracy of the algorithm is 83.5%