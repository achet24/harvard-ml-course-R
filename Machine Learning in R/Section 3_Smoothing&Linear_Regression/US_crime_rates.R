library(broom)
library(caret)
mnist_27$train %>% glm(y ~ x_2, family = "binomial", data = .) %>% tidy()
qplot(x_2, y, data = mnist_27$train)
# Fit a loess line to the data above and predict the 2s and 7s in the mnist_27$test dataset 
# with just the second covariate and degree=1.
# What is the accuracy of the prediction if we use only the second covariate as predictor?
# Note: There is an NA value after fitting the loess line. To avoid issues, use confusionMatrix() to find the accuracy. 
# Otherwise, if you use mean(), make sure to specify the na.rm argument.
mnist_27_clean <-  mnist_27$train %>% 
  filter(!is.na(y), !is.na(x_2)) %>%
  mutate(y_num = ifelse(y==7, 1,0))

# changed y data to numeric 1s and 0s so that loess can understand it as numeric when it is just binary categorical data.

line2 <- loess(y_num ~ x_2, data = mnist_27_clean, degree = 1)

# Test prediction
test_pred <- predict(line2, newdata = mnist_27$test)

# Since this loess model outputs probabilities, threshold them to classify into 2 or 7.
test_class <- ifelse(test_pred > 0.5, 7, 2)

# must factor 2 and 7 so that they are read as categories and not digits in a confusion matrix
actual <- as.factor(mnist_27$test$y)

# predict(object, newdata, interval) 
# object: the class inheriting from the linear model
# newdata: Input data to predict the values
# interval: Type of interval calculation
predicted <- as.factor(test_class)

confusionMatrix(predicted, actual)

# Trick is to first make them numeric so loess understands the data, then make it categorical so the confusion matrix undersands.
# Hence, we can find the accuracy of this prediction model! YAY
