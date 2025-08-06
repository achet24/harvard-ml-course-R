# Week 1: Categorical Data and Linear Regression

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
