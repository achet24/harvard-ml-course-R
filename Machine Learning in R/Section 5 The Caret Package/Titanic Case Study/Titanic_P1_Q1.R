library(titanic)    # loads titanic_train data frame
library(caret)
library(tidyverse)
library(rpart)

# 3 significant digits
options(digits = 3)

# clean the data - `titanic_train` is loaded with the titanic package
titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age), # NA age to median age
         FamilySize = SibSp + Parch + 1) %>%    # count family members
  select(Survived,  Sex, Pclass, Age, Fare, SibSp, Parch, FamilySize, Embarked)

indexes <- createDataPartition(titanic_clean, list = FALSE)
train_set <- titanic_clean[indexes, ]
test_set <- titanic_clean[-indexes, ]

print(test_set)
set.seed(42)

# Q1: 20% partition based on survived column. assign 20% to test_set and rest to train_set.

survived_index <- createDataPartition(y= titanic_clean$Survived, p = 0.8, list = FALSE)
train_set_s <- titanic_clean[survived_index, ]
test_set_s <- titanic_clean[-survived_index, ]

counts <- sum(train_set_s$Survived==1)
print(counts)

# Answer is wrong! Try again below

library(titanic)    # loads titanic_train data frame
library(caret)
library(tidyverse)
library(rpart)

# 3 significant digits
options(digits = 3)

# clean the data - `titanic_train` is loaded with the titanic package
titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age), # NA age to median age
         FamilySize = SibSp + Parch + 1) %>%    # count family members
  select(Survived,  Sex, Pclass, Age, Fare, SibSp, Parch, FamilySize, Embarked)

indexes <- createDataPartition(titanic_clean, list = FALSE)
train_set <- titanic_clean[indexes, ]
test_set <- titanic_clean[-indexes, ]

print(test_set)
set.seed(42)

partition <- createDataPartition(train_set$Survived, p = 0.8, list = FALSE)
train_s2 <- train_set[partition, ]
test_s2 <- train_set[-partition, ]

count <- sum(train_s2$Survived == 1)
print(count)

# I am so confused, I did everything the question asked of me.
# Re-doing everything below:

# 3 significant digits
options(digits = 3)

# clean the data - `titanic_train` is loaded with the titanic package
titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age), # NA age to median age
         FamilySize = SibSp + Parch + 1) %>%    # count family members
  select(Survived,  Sex, Pclass, Age, Fare, SibSp, Parch, FamilySize, Embarked)

indexes <- createDataPartition(titanic_clean, p = 0.8, list = FALSE)
train_set <- titanic_clean[indexes, ]
test_set <- titanic_clean[-indexes, ]

set.seed(42)
indexes <- createDataPartition(titanic_clean, p = 0.8, list = FALSE)
train_set <- titanic_clean[indexes, ]
test_set <- titanic_clean[-indexes, ]

print(sum(train_set$Survived == 1))

# The code above is still outputing the wrong answers. Third attempt below

set.seed(42)
split <- createDataPartition(titanic_clean$Survived, p = 0.2, list = FALSE)
train_set <- titanic_clean[split, ]
test_set <- titanic_clean[-split, ]

nrow(train_set)
# 179 Observations in train set

nrow(test_set)
# 712 Observations in test set

count <- sum(train_set$Survived==1)
print(count)
# 69 individuals survived in train_set

# I realized why it's wrong! - The first two attempts I thought I had to re-split the clean data, but I do not have to. Then I assigned the indexes wrong. I just realized that the training set is much smaller than the test set, but it should be the other way. Will attempt 4th try now.

set.seed(42)
split2 <- createDataPartition(titanic_clean$Survived, p = 0.2, list = FALSE)
train_set <- titanic_clean[-split2, ]
test_set <- titanic_clean[split2, ]

nrow(train_set)
# Answer A: 712

nrow(test_set)
# Answer B: 179

print(sum(train_set$Survived==1))
# Answer C: 273

# Answers for A & B are correct, but not C. 

prop.table(table(train_set$Survived)) 
# Answer: 0.383
