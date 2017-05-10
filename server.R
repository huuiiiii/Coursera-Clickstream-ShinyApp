#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  output$intro_info = renderText({    
    "Datasets Description" 
  })
  
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(
        lng = -93.85, lat = 37.45, zoom = 4
      ) %>%
      addCircles(lng = location$lon, lat = location$lat, weight = 1, radius = location$location.agg*50, 
                 popup = paste("Location:", location$V4,"<br>",
                               "Participation:", location$location.agg, "<br>",
                               "Percentage:", 100*(location$location.agg/119891),"%"))
  })

  
  
  output$cumulative <- renderPlotly({
    temp <- NewData[which(NewData$key!='heartbeat'),]
    temp <- temp[which(temp$key!='start'),]
    temp <- temp[which(temp$key!='seek'),]
    sub = subset(temp, temp$video_name == input$video)
    #plot(ecdf(sub$timecode),main="Empirical Cumulative Distribution of the time by video", xlab="time by seconds")
    den <- density(na.omit(sub$timecode), bw = 1,from = 0, to = max(sub$timecode))
    plot_ly(x = ~den$x, y = ~den$y, type = 'scatter', mode = 'lines', fill = 'tozeroy') %>%
      layout(
        title = "Activity density plot (exclude the heartbeat) of the selected Video",
        xaxis = list(title = 'Timecode'),
             yaxis = list(title = 'Density'))
  })
  
  
  output$basic <- renderPrint({
    sub = subset(NewData, NewData$video_name == input$video)
    summary(sub$timecode)
  })
  
  
  #output$hist1 <- renderHighchart({
  #  sub = subset(NewData, NewData$video_name == input$video)
  #  hchart(sub$timecode) %>% 
  #  hc_title(text = "Histogram of the time user spent by video") %>%
  #  hc_add_theme(
  #    hc_theme_flatdark(
  #      chart = list(
  #        backgroundColor = "transparent",
  #        divBackgroundImage = "http://www.wired.com/images_blogs/underwire/2013/02/xwing-bg.gif"
  #      )
  #    )
  #  )
  #})
  
  output$hist1 <- renderPlotly({
    sub =subset(NewData[NewData$key == input$key1,], NewData[NewData$key == input$key1,]$video_name == input$video1)
    #den <- density(na.omit(sub$timecode), bw = 0.04, from = 0, to = 1)
    #density <- density(na.omit(NewData$timecode))
    plot_ly(x = sub$timecode, type = "histogram", autobinx = T) %>%
      #add_trace(density, x= density$x, y = density$y, type = 'scatter', mode = 'lines') %>%
    layout(                        
      title = "Histogram of the selected Video", 
      xaxis = list(           
        title = "Timecode",      
        showgrid = F),       
      yaxis = list(           
        title = "Count")     
    )
  })
  
  
  #output$boxplot1 <- renderPlotly({
  #  sub =subset(NewData, NewData$video_name == input$video2)
  #  sub <- sub %>%
  #    arrange(key)
  ##  
  #  plot_ly(sub, color = ~key, x = ~timecode, type = 'box') %>%
  #    layout(autosize = T,
  #           title = "Boxplot for all the keys for selected video") %>%
  #    hide_legend()
  # })
  
  
  output$boxplot1 <- renderHighchart({
    
    sub =subset(NewData, NewData$video_name == input$video2)
    hcboxplot(x = sub$timecode, var = sub$key,name = "Length", color = "#2980b9") 
    
  })
  
  
  
  output$plot2 <- renderPlotly({
    sub2 =subset(NewData[NewData$key == input$key2,], NewData[NewData$key == input$key2,]$video_name == input$video1)
    plot_ly(sub2, x = ~timecode, y = ~key, color = ~key, type = 'scatter')
  })
  
  #output$BoxPlot <- renderPlot({
  #  sub = subset(NewData, NewData$video_name == input$video)
  #  #par(mar=c(5.1,8.1,4.1,2.1))
  #  boxplot(timecode~key, data=sub, horizontal = TRUE,  names, outline = TRUE, col="bisque",las=1,
  #          at=rank(-tapply(sub$timecode, sub$key, mean),na.last=NA))
  #  title("Comparing boxplot()s by different keys")
  #})
  
  
  
 
  
})
