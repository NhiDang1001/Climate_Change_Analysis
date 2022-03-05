library(ggplot2)
library(plotly)
library(bslib)
library(dplyr)
library("shiny")
library("rbokeh")

climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")


intro_tab <- tabPanel(
  "Introduction",
  fluidPage(theme = bs_theme(bootswatch = "minty"),
            p("Welcome to my climate change app"),
            mainPanel(
              textOutput("Text1"),
              textOutput("Value") 
            )
  )
)

value_tab <- tabPanel(
  "Envisioning",
  fluidPage(theme = bs_theme(bootswatch = "minty"),
            p("Welcome to my envisioning tab"),
            mainPanel(
              textOutput("Text4"),
              textOutput("Text5")
              
            )
  )
)

ui <- fluidPage(
  navbarPage("Climate Change",
             intro_tab,
             value_tab,
             tabPanel("Oil CO2 Across The World", 
                      # Side bar layout
                      sidebarLayout( 
                        sidebarPanel(
                          # Allow user to input range
                          selectInput(
                            inputId = "user_category", 
                            label = "Select Country",
                            choices = climate_data$country,
                            selected = "United States",
                            multiple = TRUE),
                          sliderInput("slider2", label = "Year slider",
                                      #start = min(climate_data$year),
                                      #end = max(climate_data$year),
                                      min = min(climate_data$year),
                                      max = max(climate_data$year),
                                      value = c(1750, 2000),
                                      sep = "",
                                      step = 10)
                                      
                        ),
                        # Main Panel3
                        mainPanel(
                          # display Bokeh output3
                          plotlyOutput(outputId = "climatePlot"),
                          textOutput("Text2")
                        ) 
                      )),
             tabPanel("Total CO2 per capita Vietnam vs US Chart", 
                      #Side Bar layout
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                            inputId = "user_year",
                            label = "Select Year",
                            choices = climate_data$year,
                            selected = "1970",
                            multiple = TRUE)
     
                        ),
                        mainPanel(
                          # plotly output for chart
                          plotlyOutput(outputId = "co2_comparisonPlot"),
                          textOutput("Text3")
                        ))
             ),
  )
)



