library(shiny)
library(shinythemes)
library(highcharter)
library(readr)
library(shinyLP)
library(ggplot2)
library(plotly)

#NewData <- read_csv("NewData.csv")
NewData <- read_delim("processed_video-2016-06-20.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
location <- read_csv("location.csv")
attach(NewData)
attach(location)
#NewData <- na.omit(NewData)

#This command convert the 'text'column(multibyte) to utf8 form
NewData$video_name<-iconv(enc2utf8(NewData$video_name),sub="byte")

video_names <- as.data.frame(unique(NewData$video_name))
keylist <- as.data.frame(unique(NewData$key))
#hchart(NewData$timecode)

#video = video_names[video_names =="2.1. The Downward Closure Property of Frequent Patterns"]

#sub =subset(NewData, NewData$video_name == video)
#hcboxplot(x = sub$timecode, var = sub$key,name = "Length", color = "#2980b9") 
#hcboxplot(x = NewData$timecode, var = NewData$key,name = "Length", color = "#2980b9") 



#hc <- highchart()
#for (cyl in unique(sub$key)) {
#  hc <- hc %>%
#    hc_add_series_scatter(sub$timecode[sub$key == cyl],
#                          name = sprintf("Cyl %s", cyl),
#                          showInLegend = TRUE)
#}

#hc


##PLOTLY

#dens <- density(na.omit(NewData$timecode))
#p <- plot_ly(x = ~dens$x, y = ~dens$y, type = 'scatter', mode = 'lines', fill = 'tozeroy') %>%
#  layout(xaxis = list(title = 'Carat'),
#         yaxis = list(title = 'Density'))


#plot_ly(sub, x = ~timecode, y = ~key, color = ~key, type = 'scatter')




#temp <- na.omit(NewData)
#g <- ggplot(temp, aes(x=temp$timecode, y=temp$key)) +
#  geom_boxplot()
