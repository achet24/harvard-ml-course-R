set.seed(1)
n <- 100
Sigma <- 9*matrix(c(1.0, 0.95, 0.95, 1.0), 2, 2)
dat <- MASS::mvrnorm(n = 100, c(69, 69), Sigma) %>%
  data.frame() %>% setNames(c("x", "y"))

set.seed(1)
rmse_val2 <- replicate(n, {
  # Test and Training set
  set_split <- createDataPartition(dat$y, p=0.5, list = FALSE)
  train_set2 <- dat[set_split, ]
  test_set2 <- dat[-set_split, ]
  
  # Train lm
  model <- lm(y ~ x, train_set2)
  pred2 <- predict(model, test_set2)
  
  # calculate RMSE of model
  RMSE(pred2, obs = test_set2$y)
  
})

mean2 <- mean(rmse_val2)
std <- sd(rmse_val2)

print(mean2)
print(std)

# When we increase the correlation between x and y, x has a more predictitive power and thus provides a better estimate of y.
# YAY! I got it correct. Lowk miss this kind of work. I made the right choice. I know I did.

# Q6
set.seed(1)
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.25, 0.75, 0.25, 1.0), 3, 3)
dat2 <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
  data.frame() %>% setNames(c("y", "x_1", "x_2"))

# Train and test
model_sets <- createDataPartition(dat2$y, p = 0.5, list = FALSE)
train3 <- dat2[model_sets, ]
test3 <- dat2[-model_sets, ]

# Single LM all three cases
model3 <- lm(y~x_1, train3)
pred3 <- predict(model3, test3)

model4 <- lm(y~x_2, train3)
pred4 <- predict(model4, test3)

model5 <- lm(y~x_1+x_2, train3)
pred5 <- predict(model5, test3)

rmse3 <- RMSE(pred3, obs = test3$y)
rmse4 <- RMSE(pred4, obs = test3$y)
rmse5 <- RMSE(pred5, obs = test3$y)
print(rmse3)
print(rmse4)
print(rmse5)


# Q8
set.seed(1)
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.95, 0.75, 0.95, 1.0), 3, 3)
dat3 <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
  data.frame() %>% setNames(c("y", "x_1", "x_2"))

# Train & test
q_set <- createDataPartition(dat3$y, p = 0.5, list = FALSE)
train_set3 <- dat3[q_set, ]
test_set3 <- dat3[-q_set, ]

# lm Fit
model6 <- lm(y~x_1, train_set3)
pred6 <- predict(model6, test_set3)

model7 <- lm(y~x_2, train_set3)
pred7 <- predict(model7, test_set3)

model8 <- lm(y~x_1+x_2, train_set3)
pred8 <- predict(model8, test_set3)

# RMSE
rmse6 <- RMSE(pred6, obs = test_set3$y)
rmse7 <- RMSE(pred7, obs = test_set3$y)
rmse8 <- RMSE(pred8, obs = test_set3$y)
print(rmse6)
print(rmse7)
print(rmse8)

# Lesson: Adding extra predictors can improve RMSE substantially, but not when the added predictors are higly correlated with other predictors.

