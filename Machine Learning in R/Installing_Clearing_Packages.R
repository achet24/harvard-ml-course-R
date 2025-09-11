# Installing Packages
install.packages("pacman")
require(pacman)
pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes, ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny, stringr, tidyr)

# Clear packages
p_unload(dplyr, tidyr, stringr) # Clear specific packages
p_unload(all) # Easier: clears all add-ons