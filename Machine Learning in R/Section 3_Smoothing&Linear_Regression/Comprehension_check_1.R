library(tidyverse)
library(caret)
# Question 2 was hard, will review again in 1 hour.
rmse_sim <- function(n) {
  Sigma <- 9*matrix(c(1.0, 0.5, 0.5, 1.0), 2, 2)
  dat <- MASS::mvrnorm(n = n, c(69, 69), Sigma) %>%
    data.frame() %>% setNames(c("x", "y"))

  # within replicate(), partition data set into test and training sets with p = 0.5 and dat$y to generate indicies
  rmse_values <- replicate(100, {
    # Split data
    train_index <- createDataPartition(dat$y, p = 0.5, list = FALSE)
    train_set <- dat[train_index, ]
    test_set <- dat[-train_index, ]
  
    # Train model
    model <- lm(y ~ x, data = train_set)
  
    # Predict
    pred <- predict(model, test_set)
  
    # Calculate RMSE
    RMSE(pred = pred, obs = test_set$y)
        
  })
  # return function in R. Will relearn in Python omg. this was crazy yet so simple
  c(mean = mean(rmse_values), sd = sd(rmse_values))
}
 
set.seed(1)
n_values <- c(100, 500, 1000, 5000, 10000)
summary <- sapply(n_values, rmse_sim)

# Transpose result
t(summary)

# On average, the RMSE does not change much as n gets larger, but the variability of the RMSE decreases.