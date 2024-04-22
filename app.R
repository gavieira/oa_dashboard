library(shiny)
library(dplyr)
library(ggplot2) 
library(openalexR) # OpenAlex Database API interface



# Load the UI and server components
source('ui.R')
source('server.R')

# Run the Shiny app
shinyApp(ui = ui, server = server)