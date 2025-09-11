# Install dslabs package from CRAN, load dslabs package into workspace

install.packages("dslabs")
library(dslabs)
data(heights)

total_males <- sum(heights$sex == "Male", na.rm = TRUE)
total_observations <- nrow(heights) 
prop <- total_males/total_observations
print(prop)

# Individuals taller than 78 inches

tall_count <- sum(heights$height > 78, na.rm = TRUE)
print(tall_count)

tall_females <- sum(heights$height > 78 & heights$sex == "Female", na.rm = TRUE)
