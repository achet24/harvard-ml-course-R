library(dslabs)
library(caret)

data(mnist_27)

set.seed(1995)
indexes <- createResample(mnist_27$train$y, 10)

# Q:1 How many times do 3, 4, and 7 appear in the first resampled index?

# mnist_27$train$y: vector of labesl (etiher 2 or 7) from a small subset of MNIST dataset
# createResample(..., 10): generates 10 bootstrap samples (resamples with resplacement) of the indices of mnist_27$train$y
# indexes: declared list of 10 vectors.

table(indexes[[1]])[c("3", "4", "7")]
# Ans. 3:1 4:2 7:1

# Q2: We see that some numbers appear more than once and others appear no times. This has to be this way for each dataset to be independent. Repeat the exercise for all the resampled indexes.
# What is the total number of times that 3 appears in all the resampled indexes?

sum(sapply(indexes, function(i) sum(i==3)))

# Q3: Report Expected value and Standard error to at least 3 values

set.seed(1)
num_repititions <- 10000

q75_estimates <- replicate(num_repititions, {
  y <- rnorm(100, 0, 1)
  quantile(y, 0.75)
})

mean_q75 <- mean(q75_estimates)
se_q75 <- sd(q75_estimates)

c(mean = round(mean_q75, 3), standard_error = round(se_q75, 3))
# Learned: Monte Carlo simulation, writing functions inside another function, how to use mean() and sd()

# Q4:Set the seed to 1 again after generating y and use 10,000 bootstrap samples to estimate the expected value and standard error of the 75th quantile.

set.seed(1)
y <- rnorm(100, 0, 1)

set.seed(1)
# Bootstrap approach: using just one dataset and resampling from it
B <- 10000
bootstrap_q75 <- replicate(B, {
  sample_y <- sample(y, replace = TRUE)
  quantile(sample_y, 0.75)
})

mean_q75 <- mean(bootstrap_q75)
se_q75 <- sd(bootstrap_q75)

c(mean = round(mean_q75, 3), standard_error = round(se_q75, 3))

# The bootstrap is particularly useful in situations when we do not have access to the distribution or it is unknown.
