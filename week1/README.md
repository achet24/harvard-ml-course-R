# Week 1: Categorical Data and Linear Regression
Notes on what I've learned and any challeges I've faced.

## Day 1
### What I've Learned 📚
#### RStudios Interface 💻:
- Prior to starting the course, I self-taught how to navigate the interface of RStudios via youtube videos.
- Four main sections: the top left corner has the R scripts; the bottom left contains the console, terminal, and background jobs; top right tracks the all the activity in the environment, history, and connections and tutorials; and lastly the bottom left displays graphys produced in the R script, files, loaded packages, and help.
- Packages sections is genius. On the spot, name and description of every package in the System Library 💃
#### R Language and Syntax 🔤:
- The equal sign in R is "<-".
- Writing a function in R is very similar to Python and Java, however, pipe operators "%>%" are a very new concept to me. An opporator allows for multiple functions to be chained together, resulting in one output. For instance, instead of nesting functions like in Python, in R the functions x, y, and z can be truncated to "output <- x %>% y %>% z".
- If else statements can be written in one line. For example in the code "fruit <- ifelse(number > 5, "orange", "apple")", if the variable "number" is greater than 5, the fruit is orange, else it is an apple.
- To comment out, use "#".
- set.seed(): random generator function
- set.seed(some_integer): sequence of random numbers generated (1 random number or infinity random numbers) will stay the same everytime program is ran.

### Challenges I faced ⛰️
- Getting used to the syntax.

## Day 2
### What I've Learned 📚
#### Refreshing & Learning ML Basics
- caret package contains functions for building & assessing ML methods.
- Training set: used to develope algorithm.
- Test set: used to make predictions based on model developed with training set.
- createDataPartition() randomly splits dataset into training and test set. examples seen in "Day_2_Code".
- For categorical data where the predictor is numeric and outcome is categorical, finding the optimal cutoff predictor is important to resulting in more accurate outcomes.
  
#### More Syntax and Language
- factor() encodes a vector of categories. Useful for functions that only understand categorical data.
- as.factor() turns numeric objects into factors.
- numeric() encodes a vector of numbers
- as.numeric() turns object into numeric value for program to interpret.
- data_set$column - $ is used to navigate a dataset's categories.

### Challenges I faced ⛰️
- Understanding the syntax of built in R functions.

## Day 3
### What I've Learned 📚
#### ConfusionMatrix
- ConfusionMatrix: tabulates each combination of prediction & actual value (e.g. true positive (TP), false negative (FN), false positives (FP), true negatives (TN)).
- From caret package.
- computes metrics such as sensitiveity and specificity one positve category is defined.
- Important to calculate sensitivity and specificity to determin how precise algorithm is, rather than depending on overall accuracy of test set.
  
#### Sensitivity
- Sensitivity: measures algorithms ability to predict positive outcome when acutal outcome is positive.
- Also known as True Positive Rate (TPR), and recall
- Equation: TP / (TP+FN)

#### Specificity
- Specificity: measures algorithms ability to predict negative outcome when actual outcome is negative.
- Also known as True Negative Rate (TNR)
- Equation: TN / (TN+FP)

#### Prevalence
- Prevalence: the amount of positives in the total population.
- Impacts Specificity/Precision
- High sensitivity and specificity may not be helpful when prevalence is close to eithrer 0 or 1.

#### Precision
- Also known as Positive Predictive value (PPV)
- Precision is higher when prevalence is higher
- Equation: TP / (TP+FP)

#### F1 Score
- The average of specificity and sensitivity
- Equation: 2 * [(precision * recall) / (precision + recall)]
- Values range from 0-1.
- Values closer to 1 are considered strong models, but must becareful if model is overfitting dataset.

### Challenges I faced ⛰️
- Loading libraries with datasets and understanding how it works in R. Figured it out by reading R documentation.

## Day 4
### What I've Learned 📚
#### ROC & Precision Recall Curves
- ROC: Reciever operaating characteristics
- Plots both sensitivity and specificity on the same graph.
- Best use for balanced datasets, but also means plots do not depend on prevalence and therefore might not be helpful for imbalanced datasets where there's a large number of true negatives (TN).
- ROC line on identity line for methods that guess. Especially for binary data the ratio of specificity and sensitivity will be 1:1

#### Loss Function
- Funciton that provides numerical measure of how well the model works. Lower value = predictions and known outcome are better aligned
- Used for both categorical and numerical data
- Squared Loss function: (y_hat - y)^2

#### Mean Squared Error (MSE)
- Works on N number of observations
- Equation: 1/N * {Sigma (y_hat - y)^2}

#### Baye's Theorem
- Equation: P(A|B) = [P(B|A) * P(A)] / P(B)

### Challenges I faced ⛰️
- Had to learn basics of Baye's Theorem. Will update progress on Baye's Theorem in next week's notes.
