library(tidyverse)
library(lubridate)
library(dslabs)
data("movielens")

# Lesson: learned how to use Boxplot

# Q1: Compute the number of ratings for each movie and then plot it against the year the movie came out using a boxplot for each year. Use the square root transformation on the y-axis (number of ratings) when creating your plot.

# Number of ratings for each movie
movie_ratings_count <- movielens %>%
  group_by(movieId, title) %>%
  summarise(num_ratings = n(), .groups = "drop")

# Extract year from title for x-axis plot
movie_ratings_count <- movie_ratings_count %>%
  mutate(year = str_extract(title, "(\\d{4})")) %>%
  mutate(year = as.numeric(year))

# Boxplot of number of ratings by year
movie_ratings_count %>%
  ggplot(aes(x = factor(year), y = num_ratings)) +
  geom_boxplot() +  
  scale_y_sqrt() +# square-roots the y-axis to scale down the values
  xlab("Year") +
  ylab("Number of Ratings (sqrt scale)") +
  ggtitle("Distribution of Movie Ratings per Year")

# Compute median number of ratings per year
year_medians <- movie_ratings_count %>%
  group_by(year) %>% # Groups by year
  summarise(median_ratings = median(num_ratings), .groups = "drop") %>% # calculates the median of num_ratings ans stores it in median_ratings.
  arrange(desc(median_ratings)) # arranges data from highest to lowest ratings

year_medians
year_medians[which.max(year_medians$median_ratings), ] # Answer: 2001 - Incorrect

# It might be because some movie titles have digits, therefore this line "mutate(year = str_extract(title, "\\d{4}"))" might extract the wrong numbers if the first digit is just a part of the title.
# Unable to figure out correct syntax to extract "(YEAR)" from every title.
# Unable to view dataframe as well, for some reason, only shows 1x1 dataframe with "movielens" in the box. :(
# I believe this is a data issue and not a code issue, because I am unable to decode it after documenting what each line does.




# Q2: What is the average rating for a movie The Shawshank Redemption
# Select top 25 movies with the highest average number of ratings per year (n/year), calculate the average rating of each of them. Use 2018 as the end year.
# this is so much easier in Python, I definately miss it

# First create a new column on the dataset for which year the movie came out
movielens <- movielens %>%
  mutate(year = as.numeric(str_extract(title, "(\\d{4})")))

# New data summary with movieId, title, and year
# .group = "drop" - use once you are done grouping variables at the end of a function I think. 
movie_summary <- movielens %>%
  filter(year >= 1993) %>%
  group_by(movieId, title, year) %>%
  summarise(
    n = n(),
    avg_rating = mean(rating),
    .groups = "drop"
  ) %>%
  mutate(ratings_per_year = n / (2018 - year +1))

# create data frame of the top 25 movies. First arrange by top ratings per year, then take the first 25.
top25 <- movie_summary %>%
  arrange(desc(ratings_per_year)) %>%
  head(25)

# find avearge rating for The Shawshank Redemption
avg_shaw_rating <- top25 %>%
  filter(str_detect(title, "Shawshank Redemption"))

avg_shaw_rating # Answer: NA - Incorrect. I assume it has to do with finding the name of the title

# 2nd attempt
avg_shaw_rating <- top25 %>%
  filter(str_detect(title, regex("Shawshank Redemption", ignore_case = TRUE)))
avg_shaw_rating


  

