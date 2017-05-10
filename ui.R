library(shiny)
library(shinythemes)
library(leaflet)
library(highcharter)
library(shinyLP)

navbarPage("ClickStream Data Analysis", theme = shinytheme("flatly"),
           tabPanel("Welcome", icon = icon("home"),
                    
                    jumbotron("Clickstream Data Dashboard of Coursera", "Coursera's clickstream data is a log of the user's interactions with Coursera. We call each
                                row of this log an event. Every event captures some user interaction at some specific point
                                in time. This allows for fine-grained analysis of user behavior, engagement, and trends.
                                ",button = FALSE),
                    leafletOutput("map", width="100%",height="500px"),
                    h5("The world map that describes the student distribution")
           ),
              tabPanel("Summary",icon = icon("table"),
                       fluidRow(
                              fluidPage(
                                sidebarLayout(
                                  sidebarPanel(
                                    selectInput("video", "Video:",choices = video_names, selected="."),
                                    helpText("Description:  Interactions with lecture videos (e.g start, stop, pause, change subtitles,
                                        heartbeats)
                                        ")
                                    ),
                                   mainPanel(
                                     plotlyOutput("cumulative"),
                                     verbatimTextOutput("basic")
                              ))))
                    ),
              tabPanel("Histogram",icon = icon("bar-chart-o"),
                       
                        sidebarLayout(
                          sidebarPanel(
                              selectInput("video1","Video:", choices=video_names),
                              selectInput("key1", "Key:", choices = keylist),
                              helpText("Keys: each of these keys represent one type of video events."),
                              helpText("Heartbeat: An event that is fired every 5 seconds of the video playing"),
                              helpText("wait: An event fired when the user requires to wait to buffer additional video"),
                              helpText("seek: An event fired when the user seeks to another part of the video")
                             
                                       #heartbeat: An event that is fired every 5 seconds of the video playing
                                       #wait: An event fired when the user requires to wait to buffer additional video
                                       #seek: An event fired when the user seeks to another part of the video
                                       #start: An event fired when the video first starts
                                       #end: And event fired when the video ends
                                       #pause: An event fired when the user pauses the video
                                       #play: An event fired when the user restarts a paused video
                                       #volumn_change: An event fired when the user changes the volumn
                                       #subtitle_change: An event fired when the user changes the subtitle language")
                              ),
                        mainPanel(
                         plotlyOutput("hist1") 
                         )
                        )
                       
              ),
              tabPanel("Boxplot", icon = icon("list-alt"),
                       fluidPage(
                         sidebarLayout(
                           sidebarPanel(
                             selectInput("video2","Video:", choices=video_names),
                             selectInput("key2", "Key:", choices = keylist),
                             helpText("Keys: each of these keys represent one type of video events."),
                             helpText("Heartbeat: An event that is fired every 5 seconds of the video playing"),
                             helpText("wait: An event fired when the user requires to wait to buffer additional video"),
                             helpText("seek: An event fired when the user seeks to another part of the video")
                           ),
                           mainPanel(
                            
                             #plotOutput("BoxPlot")
                             #plotOutput("BoxPlot", height="200px")
                             highchartOutput("boxplot1"),
                             #plotlyOutput("boxplot1",width="100%",height="500px"),
                             plotlyOutput("plot2") 
                            
                           )
                         )
                       )
                       )
          )