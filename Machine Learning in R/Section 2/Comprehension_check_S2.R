library(dslabs)
library(dplyr)
library(lubridate)
data(reported_heights)

dat <- mutate(reported_heights, date_time = ymd_hms(time_stamp)) %>%
  filter(date_time >= make_date(2016, 01, 25) & date_time < make_date(2016, 02, 1)) %>%
  mutate(type = ifelse(day(date_time) == 25 & hour(date_time) == 8 & between(minute(date_time), 15, 30), "inclass","online")) %>%
  select(sex, type)

y <- factor(dat$sex, c("Female", "Male"))
x <- dat$type

View(dat)

f_inclass <- sum(dat$sex == "Female" & dat$type == "inclass", na.rm = TRUE)
tot_inclass <- sum(dat$type == "inclass")

percent_f_inclass <- f_inclass/tot_inclass

f_online <- sum(dat$sex == "Female" & dat$type == "online", na.rm = TRUE)
tot_online <- sum(dat$type == "online")

percent_f_online <- f_online/tot_online

# Q2: In the course videos, height cutoffs were used to predict sex. 
# Instead of height, use the type variable to predict sex. 
# Assume that for each class type the students are either all male or all female, 
# based on the most prevalent sex in each class type you calculated in Q1. 
# Report the accuracy of your prediction of sex based on type. 
# You do not need to split the data into training and test sets.

pred_inclass <- ifelse(percent_f_inclass > 0.5, "Female", "Male")
pred_online <- ifelse(percent_f_online > 0.5, "Female", "Male")

y_hat <- ifelse(x == "inclass", pred_inclass, pred_online) %>%
  factor(levels = levels(y))

accuracy <- mean(y_hat == y)
print(accuracy)

table(y_hat, y)

# Q3: Sensitivity
library(caret)
sensitivity(data = y_hat, reference = y)

# Q4: Specificity
specificity(data = y_hat, reference = y)

# Q5: What is the prevalence (% of females) in the dat dataset defined above?
prevalence <- sum(dat$sex == "Female")
print(prevalence)
percent_prev <- prevalence/100
print(percent_prev)
# Above is wrong, below might be correct. YAY! It's correct.

mean(dat$sex == "Female", na.rm = TRUE)

# COMPREHENSION CHECK PART 2: TRAINING/TEST SET PRACTICE
data(iris)
iris <- iris[-which(iris$Species=='setosa'),]
y <- iris$Species
set.seed(76)
test_index <- createDataPartition(y, times=1, p=0.5, list=FALSE)
test <- iris[test_index,]
train <- iris[-test_index,]
View(iris)
View(test)

# Q8: Which feature produces most accurate predictions? Use only train set.
#first will find max/min, then cutoff, accuracy
min_val <- min(iris[, 1:4])
max_val <- max(iris[, 1:4])

cat("Min:", min_val, "\nMax:", max_val)

cutoff_1 <- seq(1, 7.9, by = 0.1)

# Compute accuracy for each cutoff
accuracy_sepal_len <- map_dbl(cutoff_1, function(x) {
  y_hat1 <- ifelse(train$Sepal.Length > x, "virginica", "versicolor") %>%
    factor(levels = levels(train$Species))
  mean(y_hat1 == test$Species)
})

# Show results
print(accuracy_sepal_len)

#Sepal Width
accuracy_sepal_width <- map_dbl(cutoff_1, function(x) {
  y_hat2 <- ifelse(train$Sepal.Width > x, "virginica", "versicolor") %>%
    factor(levels = levels(train$Species))
  mean(y_hat2 == test$Species)
})

# Show results
print(accuracy_sepal_width)

#Petal Length
accuracy_petal_length <- map_dbl(cutoff_1, function(x) {
  y_hat3 <- ifelse(train$Petal.Length > x, "virginica", "versicolor") %>%
    factor(levels = levels(train$Species))
  mean(y_hat3 == test$Species)
})

# Show results
print(accuracy_petal_length)

#Petal Width
accuracy_petal_width <- map_dbl(cutoff_1, function(x) {
  y_hat4 <- ifelse(train$Petal.Width > x, "virginica", "versicolor") %>%
    factor(levels = levels(train$Species))
  mean(y_hat4 == test$Species)
})

# Show results
print(accuracy_petal_width)

# I think I definately did this question wrong, but I got the correct answer?

# Q9: For the feature selected in Q8, use the smart cutoff value from the training data to calculate overall accuracy in the test data.
# What is the overall accuracy?

best_cutoff_3 <- which.max(accuracy_petal_width) 
pred_virginica <- ifelse(test$Petal.Width > best_cutoff_3, "virginica", "versicolor") %>%
  factor(levels = levels(test$Species))
overall_accuracy <- mean(pred_virginica == test$Species)
print(overall_accuracy)

# Hmm, answer is wrong. Using Chat to help answer this.