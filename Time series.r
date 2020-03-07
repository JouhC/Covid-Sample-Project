library(ggplot2)
library(maps)
library(ggthemes)
library(gganimate)
library(dplyr)
library(reshape2)

df1 <- read.csv('time_series_19-covid-Confirmed.csv')
date_cols <- colnames(df1)[5:48]
dt <- melt (df1, id.vars = c("Country.Region","Province.State","Lat","Long"),
                    measure.vars = date_cols,
                    variable.name = "date",
                    value.name = "confirmed")

dt$txtdate <- sub("^X", "", dt$date)
dt$txtdate <- format(as.Date(strptime(dt$txtdate, format = "%m.%d.%y")), "%Y-%m-%d")
dt$txtdate <- as.Date(dt$txtdate)


world <- ggplot(data = dt) +
  borders("world", colour = "gray90", fill = "gray76") +
  theme_map() + 
  geom_point(aes(x = dt$Long, y = dt$Lat, size = dt$confirmed ), colour = "#FF0000", alpha = 0.8) +
  labs(title = "Evolution of COVID-19 virus. Date: {frame_time}") +
  transition_time(dt$txtdate) +
  ease_aes("linear") +
  scale_size(name = "Confirmed Cases",range = c(-0.34, 5))



p_ani <- animate(world, duration=44, fps=10, detail = 1)


anim_save("covid.gif", p_ani)
