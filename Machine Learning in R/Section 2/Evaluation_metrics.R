install.packages("dslabs")
install.packages("tidyverse")
library(tidyverse)
library(caret)
library(dslabs)
data(heights)

# define outcome and predictors
y <- heights$sex
x <- heights$height

set.seed(2007)
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
test_set <- heights[test_index, ]
train_set <- heights[-test_index, ]

# ignore predictors & guess sex
y_hat <- sample(c("Male", "Female"), length(test_index), replace = TRUE) %>%
  factor(levels = levels(test_set$sex))

# compute accuracy
mean(y_hat == test_set$sex)

# compare heights in males and females in our data set
heights %>% group_by(sex) %>% summarize(mean(height), sd(height))

# predicting "male" if height is within 2 SD of the average male
y_hat <- ifelse(x>62, "Male", "Female") %>% factor(levels = levels(test_set$sex))
mean(y==y_hat)
# 0.7933

#examine the accuracy of 10 cutoffs
cutoff <- seq(61, 70)
accuracy <- map_dbl(cutoff, function(x){
  y_hat <- ifelse(train_set$height>x, "Male", "Female") %>%
    factor(levels = levels(test_set$sex))
  mean(y_hat == train_set$sex)
})
data.frame(cutoff, accuracy) %>%
  ggplot(aes(cutoff, accuracy)) +
  geom_point() +
  geom_line()
max(accuracy)
# accuracy = 0.8495

best_cutoff <- cutoff[which.max(accuracy)]
best_cutoff
# best height is 64 inches

y_hat <- ifelse(test_set$height > best_cutoff, "Male", "Female") %>%
  factor(levels = levels(test_set$sex))
y_hat <- factor(y_hat)
mean(y_hat==test_set$sex)
# result of accuracy = 0.80

read_mnist()

data("mnist_27")
str(mnist_27$train)
num_features <- ncol(mnist_27$train$x)-1
print(num_features)
#above outputted numeric(0), i dont think i get it, but i will try the keras version below

install.packages("keras")
library(keras)

# Load full MNIST dataset
mnist <- dataset_mnist()

cm