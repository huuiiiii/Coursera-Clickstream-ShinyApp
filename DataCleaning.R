### Libraries ###
library(stringr)
library(reshape)
library(reshape2)
library(dplyr)
library(plyr)
library(data.table)
library(splitstackshape)
library(doBy)
library(ggplot2)
library(foreign)
library(readr)

video_2016_12_FULL_PARSED <- fread("T:/Practice Clickstream/PC/PC/video-2016-12-FULL_PARSED.csv")
attach(video_2016_12_FULL_PARSED)

str(video_2016_12_FULL_PARSED)
names(video_2016_12_FULL_PARSED)
length(unique(video_2016_12_FULL_PARSED$illinois_user_id))
length(unique(video_2016_12_FULL_PARSED$course_id))
length(unique(video_2016_12_FULL_PARSED$country_cd))



video_2016_12_FULL_PARSED$video_name = str_trim(video_2016_12_FULL_PARSED$video_name, side = "both") #Eliminating the white space from start and end of string.
video_2016_12_FULL_PARSED = data.frame(video_2016_12_FULL_PARSED) #Making sure we have a dataframe object. 

video_names <- unique(video_2016_12_FULL_PARSED$video_name)
course_id <- unique(video_2016_12_FULL_PARSED$course_id)
country_cd <- unique(video_2016_12_FULL_PARSED$country_cd)
region_cd <- unique(video_2016_12_FULL_PARSED$region_cd)
module_id <-unique(video_2016_12_FULL_PARSED$module_id)

sub = subset(video_2016_12_FULL_PARSED, video_2016_12_FULL_PARSED$video_name == video_names[1])
#sub = video_2016_12_FULL_PARSED
plot(ecdf(sub$timecode),main="Empirical Cumulative Distribution of the time by video", xlab="time by seconds")

library(highcharter)
hchart(sub$timecode)


hchart(density(na.omit(sub$timecode)), type = 'area', color = '#871C1C')

hcboxplot(x = sub$timecode, var = sub$key, name = "Length")


library(maps)


states_map <- map_data('state', region = states_agg$x)

#ggplot(states_agg, aes(map_id = states_agg$x)) +
#  geom_map(aes(fill = states_agg$freq), map = states_map) +
#  expand_limits(x = states_map$long, y = states_map$lat)



library(ISOcodes)
data("ISO_3166_2")
sub$iso <- paste(sub$country_cd, sub$region_cd, sep="-")


########### Obtain the country name
temp <- merge(sub, ISO_3166_2, by.x = "iso", by.y = "Code")

library(plyr)
agg <- count(temp$Name)


###### Mapping world
library(ggmap)
library(maptools)
library(maps)

visited <- geocode(unique(temp$Name))

visit.x <- na.omit(visited$lon)
visit.y <- na.omit(visited$lat)

visited$agg <- agg$freq

map("world", fill=TRUE, col="white", bg="lightblue", ylim=c(-60, 90), mar=c(0,0,0,0))
points(visit.x,visit.y, col="red", pch=16)

#############


mp <- NULL
mapWorld <- borders("world", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() +   mapWorld

#Now Layer the cities on top
mp <- mp+ geom_point(aes(x=visit.x, y=visit.y) ,color="blue", size=3) 
mp

#############
#############library(rworldmap)

###########
library(leaflet)
m = leaflet(visited) %>%
  addTiles(
    urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
    attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
  ) %>%
  setView(lng = -93.85, lat = 37.45, zoom = 4)
#%>%addTiles()

m <- addCircles(m, lng = visit.x, lat = visit.y, weight = 1, radius = visited$agg*500)

m


####################
library(ggplot2)

ggplot(sub, aes(factor(sub$key), sub$timecode)) +
  geom_boxplot()
