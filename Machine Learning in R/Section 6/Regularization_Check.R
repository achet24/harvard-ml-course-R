library(tidyverse)
options(digits=7)
# simulating a dataset for 1000 schools
# 1. Simulating number of students in each school
set.seed(1986)
n <- round(2^rnorm(1000, 8, 1))

# Making sure ach school is completely indpedent from size.
set.seed(1)
mu <- round(80 + 2*rt(1000, 5))
range(mu)
schools <- data.frame(id = paste("PS",1:1000),
                      size = n,
                      quality = mu,
                      rank = rank(-mu))
print(schools %>% 
        top_n(10, quality) %>% 
        arrange(desc(quality))
)  # Just found out pipe operator %>% is part of the tidyverse library.

# Randomly simulating test scores
scores <- sapply(1:nrow(schools), function(i){
  scores <- rnorm(schools$size[i], schools$quality[i], 30)
  scores
})
schools <- schools %>% mutate(score = sapply(scores, mean))

# Top 10 average scores
top10_avg_score <- schools %>%
  top_n(10, score) %>%
  arrange(desc(score))
print(top10_avg_score)

print(median(schools$size, na.rm = FALSE)) # Answer 261 
print(median(top10_avg_score$size)) # Answer 185.5

# Find median school size of the lowest 10 average scores
sorted_scores <- schools %>% 
  sort(score) %>%
  arrange(desc(score))
lowest10_socres <- sorted_scores[1:10] # This code is wrong because I am unable to find the school size once I got the lowest 10 scores. Below is the correct way to solve the question

lowest10_scores <- schools %>%
  arrange(score) %>%
  slice(1:10)

median(lowest10_scores$size)

top10_ID <- top10_avg_score %>%
  pull(top10_avg_score$id)

