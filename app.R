library(shiny)
library(shinyjs)
library(shinyTree)
library(shinyWidgets)
library(shinythemes)

#setwd("/Users/ju_rando/Documents/Flora_do_Brasil/Chave_teste")

#para atualizar o site -> rsconnect::deployApp('/Users/ju_rando/Documents/Flora_do_Brasil/Chave_dez_final/Chave_FBO2020')

#https://www.shinyapps.io/admin/#/applications/all

# Run the application 
shinyApp(ui = "ui.R", server = "server.R")
