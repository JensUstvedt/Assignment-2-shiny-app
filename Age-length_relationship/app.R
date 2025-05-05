

library(shiny)
library(bslib)
library(readxl)
library(here)
library(tidyverse)
library(FSAdata)

ui <- fluidPage(
  titlePanel("Growth curve comparison"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
             sliderInput("Linf", "Asymptotic Length (Linf):", min = 10, max = 1500, value = 500),
             sliderInput("k", "Growth Rate (k):", min = 0.01, max = 1, value = 0.2),
             sliderInput("t0", "t₀ (Theoretical Age at Zero Length):", min = -5, max = 5, value = 0),
    
             checkboxGroupInput("model", "Select model(s) to display:",
                               choices = c("von Bertalanffy", "Gompertz"),
                               selected = c("von Bertalanffy", "Gompertz")),
             checkboxGroupInput("data", "Select example data to display:",
                                choices = c("Blue whiting", "Blue catfish"),
                                selected = c())
             ),
    mainPanel(plotOutput("plot", height = "500px")))
    )
  


server <- function(input, output) {
  
  bw_data <- read_excel(here("data/blue_whiting_data.xlsx")) |> 
    select(length, age)
  blue_catfish_data <- get("BlueCatfish")
  
  output$plot <- renderPlot({
    Linf <- input$Linf
    k <- input$k
    t0 <- input$t0
    t <- seq(-2, 30)
    VB <- Linf * (1 - exp(-k * (t - t0)))
    Gomp <- Linf * exp(-(1/k) * exp(-k * (t - t0)))
    ymax <- Linf * 1.1
    
    plot(NULL, 
         xlab = "Age (years)",
         ylab = "Length (mm)",
         xlim = c(-2, 28),
         ylim = c(0, ymax))
    
    if(all(c("von Bertalanffy", "Gompertz") %in% input$model)) {
      lines(t, VB)
      lines(t, Gomp)
    } else if("Gompertz" %in% input$model){
      lines(t, Gomp)
    } else if("von Bertalanffy" %in% input$model){
      lines(t, VB)
    } else{plot.new()
           text(0.5, 0.5, "Please select at least one model")}
    if(all(c("Blue whiting", "Blue catfish") %in% input$data))  {
      points(bw_data$age, bw_data$length, col = "red")
      points(blue_catfish_data$age, blue_catfish_data$tl, col = "blue")
    }else if("Blue whiting" %in% input$data){
      points(bw_data$age, bw_data$length, col = "red")
    } else if("Blue catfish" %in% input$data){
      points(blue_catfish_data$age, blue_catfish_data$tl, col = "blue")
  }

})
}

shinyApp(ui = ui, server = server)
