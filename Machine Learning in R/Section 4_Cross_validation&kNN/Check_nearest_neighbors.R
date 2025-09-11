# Q1: Set the seed to 1, then use the caret package to partition the dslabs heights data into a training and test set of equal size (p = 0.5).
# Use the sapply() function to perform KNN with k values of seq(1, 101, 3) on the training set and calculate F1 scores on the test set with 
# the F_meas() function using the default value of the relevant argument.
library(caret)
library(dslabs)

set.seed(1)
trainer <- createDataPartition(heights$height, p=0.5, list=FALSE)
train_set <- heights[trainer, ]
test_set <- heights[-trainer, ]

# Sequence of k values
k_values <- seq(1, 101, 3)

# Compute F1 scores for each k

f1_scores <- sapply(k_values, function(k) {
  model <- knn3(sex ~ height, data = train_set, k=k)
  pred <- predict(model, test_set, type="class")
  F_meas(data=pred, test_set$sex)
})

# Max f1 score
max(f1_scores)

# Value of K at which max f1 score occurs
best_k <- k_values[which.max(f1_scores)]
best_k

# Learning lesson: reinforced understanding of how I can add functions into sapply(). Also a great review of how for loops work in R, very different from Python.

# Q2: First, set the seed to 1 and split the data into training and test sets with p = 0.5. 
# Then, report the overall accuracy you obtain from predicting tissue type using KNN with k = seq(1, 11, 2) using sapply() or map_df().
# Note: use the createDataPartition() function outside of sapply() or map_df().


data <- data("tissue_gene_expression")
set.seed(1)
indices <- createDataPartition(tissue_gene_expression$y, p = 0.5, list = FALSE)

# Have to split x and y separately because because tissue_gene_expression is a list of x and y, where x is the gene expression matrix and y are the tissue labels.

# train set
train_x <- tissue_gene_expression$x[indices, ]
train_y <- tissue_gene_expression$y[indices]

# test set
test_x <- tissue_gene_expression$x[-indices, ]
test_y <- tissue_gene_expression$y[-indices]

# k values
k_vals <- seq(1, 11, 2)

accuracy_model <- sapply(k_vals, function(k) {
  model <- knn3(train_x, train_y, k=k)
  pred <- predict(model, test_x, type="class")
  pred <- factor(pred, levels = levels(test_y)) # Ensure consistent factor levels
  accuracy_model <- confusionMatrix(pred, test_y)$overall["Accuracy"]
  print(paste("k =", k, "Accuracy =", accuracy_model))
  return(accuracy_model)
})
