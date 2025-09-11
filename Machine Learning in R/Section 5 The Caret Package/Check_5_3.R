# Caret Package Comprehension Check
# Set seed to number and that random generation of numbers will be the same across all code. On two laptops set.seed(1991) and both programs generate same random numbers

library(dslabs)
library(rpart)
library(caret)

set.seed(1991)

fit <- train(tissue_gene_expression$x, 
             tissue_gene_expression$y, 
             method = "rpart",
             tuneGrid = data.frame(cp = seq(0, 0.1, 0.01)))
# tuneGrid explicitly tells caret to try cp values from 0 to 0.1 in steps of 0.01.

fit
plot(fit)

# Q2: Note that there are only 6 placentas in the dataset. By default, rpart requires 20 observations before splitting a node.
# Rerun the analysis you did in Q1 with caret::train(), but this time with method = "rpart" and allow it to split any node by using the argument control = rpart.control(minsplit = 0).
# Look at the confusion matrix again to determine whether the accuracy increases. Again, set the seed to 1991.


# Learned that control
set.seed(1991)

fit2 <- train(
  tissue_gene_expression$x,
  tissue_gene_expression$y,
  method = "rpart",
  tuneGrid = data.frame(cp = seq(0, 0.1, 0.01)),
  control = rpart.control(minsplit = 0)
)

fit2
confusionMatrix(fit2)
plot(fit2)

# 5th attempt omg. Accuracy = 0.903. Copied code from Q1 then added control line instead of typing it out. It worked. 
# Basic tree plot

plot(fit2$finalModel, margin = 0.1)
text(fit2$finalModel, use.n = TRUE, cex = 0.7)
# Code below returns name of the first split.
fit2$finalModel$frame$var[1]

# fit2$finalModel$frame is a data frame that stores info about all nodes in the tree
# each row = one node in the tree
# columns, var: which vairabe the node splits on (or <leaf> if tis a terminal node).

# Today I learned about the tuneGrid parameter and how you can select the cp values. I also gained a deeper understanding in Trees, how to analyze the ML's desicion based on the data provided, and how finalModel is the model that train() made.

# With only seven genes we can predict tissue type CRAZY!

# Q4: Now let's see if we can predict the tissue type with even fewer genes using a Random Forest.  

set.seed(1991)

fit <- train(tissue_gene_expression$x,
             tissue_gene_expression$y, 
             method = "rf",
             tuneGrid = data.frame(mtry = seq(50, 200, 25)),
             nodesize = 1)
fit
plot(fit)x

