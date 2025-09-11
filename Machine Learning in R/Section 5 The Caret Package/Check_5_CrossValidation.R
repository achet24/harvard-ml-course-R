library(tidyverse)
library(caret)

set.seed(1996)
n <- 1000
p <- 10000
x <- matrix(rnorm(n*p), n, p)
colnames(x) <- paste("x", 1:ncol(x), sep = "_")
y <- rbinom(n, 1, 0.5) %>% factor()

x_subset <- x[ ,sample(p, 100)]

# Q1: Code to run cross-validation using logistic regression. Accuracy should be around 0.5
set.seed(1)
fit <- train(x_subset, y, method = "glm")
fit$results

pvals <- rep(0, ncol(x))
for (i in 1:ncol(x)) {
  pvals[i] <- t.test(x[,i][y==0], x[,i][y==1], var.equal=TRUE)$p.value
}

# Q2: Create an index ind with the column numbers of the predictors that were "statistically significantly" associated with y. Use a p-value cutoff of 0.01 to define "statistically significantly."

ind <- which(pvals < 0.01)
length(ind)

# Q3: Now set the seed to 1 and re-run the cross-validation after redefinining x_subset to be the subset of x defined by the columns showing "statistically significant" association with y.
set.seed(1)
x_subset <- x[ ,ind]
crossV <- train(x_subset, y, method = "glm")
crossV$results

# YAY! Figured it out :)

# Q4: Set the seed to 1 and re-run the cross-validation again, but this time using kNN. Try out the following grid k = seq(101, 301, 25) of tuning parameters. Make a plot of the resulting accuracies.
set.seed(1)
fit <- train(x_subset, y, method = "knn", tuneGrid = data.frame(k = seq(101, 301, 25)))
ggplot(fit)

# Learn: how to make colomn of predictors, train() incorporates logistic regression & knn, (and 237 more methods!)

# In the previous exercises, we see that despite the fact that x and y are completely independent, we were able to predict y with accuracy higher than 70%. We must be doing something wrong then.
# What is it?

# We used the entire dataset to select the columns used in the model.
# Hence, the accuracy is too high. The selcetion step needs to be included as part of the corss-validation algorithm, and then the cross-validation itself is performed after the column selection step.
# As a follow-up exercisse, try to re-do the CV with logistric regression, this time including the selection step in the CV algorithm. The accuracy should now be close to 50%.
