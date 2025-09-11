# Mortality rates in Puerto Rico for 2015-18
# Note meaning and use of all Libraries learned this week.
library(tidyverse)
library(lubridate)
library(purrr)
library(pdftools)

fn <- system.file("extdata", "RD-Mortality-Report_2015-18-180531.pdf", package="dslabs")
dat <- map_df(str_split(pdf_text(fn), "\n"), function(s){
  s <- str_trim(s)
  header_index <- str_which(s, "2015")[1]
  tmp <- str_split(s[header_index], "\\s+", simplify = TRUE)
  month <- tmp[1]
  header <- tmp[-1]
  tail_index  <- str_which(s, "Total")
  n <- str_count(s, "\\d+")
  out <- c(1:header_index, which(n==1), which(n>=28), tail_index:length(s))
  s[-out] %>%
    str_remove_all("[^\\d\\s]") %>%
    str_trim() %>%
    str_split_fixed("\\s+", n = 6) %>%
    .[,1:5] %>%
    as_tibble() %>% 
    setNames(c("day", header)) %>%
    mutate(month = month,
           day = as.numeric(day)) %>%
    gather(year, deaths, -c(day, month)) %>%
    mutate(deaths = as.numeric(deaths))
}) %>%
  mutate(month = recode(month, "JAN" = 1, "FEB" = 2, "MAR" = 3, "APR" = 4, "MAY" = 5, "JUN" = 6, 
                        "JUL" = 7, "AGO" = 8, "SEP" = 9, "OCT" = 10, "NOV" = 11, "DEC" = 12)) %>%
  mutate(date = make_date(year, month, day)) %>%
  dplyr::filter(date <= "2018-05-01")

# Use the loess() function to obtain a smooth estimate of the expected number of deaths as a function of date. 
# Plot this resulting smooth function. Make the span about two months (60 days) long and use degree = 1.

# Variable date is of class Date - ggplot() understands it, but loess() needs numeric value
# hence, convert date into numeric format e.g. number of days since some origin point

dat <- dat %>% mutate(date_numeric = as.numeric(date))
dat_clean <- dat %>% filter(!is.na(deaths), !is.na(date_numeric))
line1 <- loess(deaths~date_numeric, data=dat_clean,span = 0.05, degree = 1)
dat_clean %>%
  mutate(smooth_2 = line1$fitted) %>%
  ggplot(aes(date_numeric, deaths)) +
  geom_point(size = 3, alpha = .5, color = "grey") +
  geom_line(aes(date, smooth_2), color = "red", lty = 2)

dat %>% 
  mutate(smooth = predict(fit, as.numeric(date)), day = mday(date), year = as.character(year(date))) %>%
  ggplot(aes(day, smooth, col = year)) +
  geom_line(lwd = 2)


library(broom)
mnist_27$train %>% glm(y ~ x_2, family = "binomial", data = .) %>% tidy()
qplot(x_2, y, data = mnist_27$train)
# Fit a loess line to the data above and predict the 2s and 7s in the mnist_27$test dataset 
# with just the second covariate and degree=1.
# What is the accuracy of the prediction if we use only the second covariate as predictor?
# Note: There is an NA value after fitting the loess line. To avoid issues, use confusionMatrix() to find the accuracy. 
# Otherwise, if you use mean(), make sure to specify the na.rm argument.
mnist_27_clean <-  mnist_27$train %>% filter(!is.na(y), !is.na(x_2)) 
line2 <- loess(y ~ x_2, data = mnist_27_clean, degree = 1)

# Test prediction
test_pred <- predict(line2, newdata = mnist_27$test)

# Since this loess model outputs probabilities, threshold them to classify into 2 or 7.
test_class <- ifelse(test_pred > 0.5, 7, 2)

cm <- confusionMatrix(data = test_class, reference = test_class)
