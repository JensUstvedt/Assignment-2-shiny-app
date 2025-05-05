

library(shiny)
library(bslib)
library(readxl)
library(here)
library(tidyverse)
library(FSAdata)

ui <- page_sidebar(
  plotOutput("plot", height = "550"),
  card(
    card_header("Dynamic growth model equations"), 
  card_body(
    uiOutput("DynamicFormulaSheet"))),
  title = "Growth curve comparison",
  sidebar = sidebar(
             sliderInput("Linf", "Asymptotic Length (Linf):", min = 10, max = 1500, value = 500),
             sliderInput("k", "Growth Rate (k):", min = 0.01, max = 1, value = 0.2),
             sliderInput("t0", "t₀ (Theoretical Age at Zero Length):", min = -5, max = 5, value = 0),
    
             checkboxGroupInput("model", "Select model(s) to display:",
                               choices = c("von Bertalanffy", "Gompertz"),
                               selected = c("von Bertalanffy", "Gompertz")),
             checkboxGroupInput("data", "Select example data to display:",
                                choices = c("Blue whiting", "Blue catfish"),
                                selected = c()),
      )
    )
    

server <- function(input, output) {
  
  bw_data <- read_excel(here("data/blue_whiting_data.xlsx")) |> 
    select(length, age)
  blue_catfish_data <- get("BlueCatfish")
  
  output$plot <- renderPlot({
    Linf <- input$Linf
    k <- input$k
    t0 <- input$t0
    t <- seq(-5, 30)
    VB <- Linf * (1 - exp(-k * (t - t0)))
    Gomp <- Linf * exp(-(1/k) * exp(-k * (t - t0)))
    ymax <- Linf * 1.1
    
    plot(NULL, 
         xlab = "Age (years)",
         ylab = "Length (mm)",
         xlim = c(-5, 30),
         ylim = c(0, ymax),
         cex.axis = 1.5,
         cex.lab = 1.5,
         lwd = 2,
         bty = "l")
    
    legend("bottomright",
           legend = c("von Bertalanffy", "Gompertz", "Blue whiting", "Blue catfish"),
           col = c("black", "red", "blue", "darkgreen"),
           lty = c(1, 1, NA, NA),
           pch = c(NA, NA, 16, 16),
           pt.cex = 1.5,
           cex = 1.4, 
           bty = "n")
    grid()
    
    if(all(c("von Bertalanffy", "Gompertz") %in% input$model)) {
      lines(t, VB, col = "black", lwd = 3)
      lines(t, Gomp, col = "red", lwd = 3)
    } else if("Gompertz" %in% input$model){
      lines(t, Gomp, col = "red", lwd = 3)
    } else if("von Bertalanffy" %in% input$model){
      lines(t, VB, col = "black", lwd = 3)
    } else{plot.new()
           text(0.5, 0.5, "Please select at least one model")}
    if(all(c("Blue whiting", "Blue catfish") %in% input$data))  {
      points(bw_data$age, bw_data$length, col = "blue", pch = 19)
      points(blue_catfish_data$age, blue_catfish_data$tl, col = "darkgreen", pch = 19)
    }else if("Blue whiting" %in% input$data){
      points(bw_data$age, bw_data$length, col = "blue", pch =19)
    } else if("Blue catfish" %in% input$data){
      points(blue_catfish_data$age, blue_catfish_data$tl, col = "darkgreen", pch = 19)
    }
    
output$DynamicFormulaSheet <- renderUI({
  withMathJax(HTML(
    paste0(
  "<b>von Bertalanffy:</b> \\( L(t) = ", input$Linf, " \\cdot (1 - e^{-", input$k, "(t - ", input$t0, ")}) \\)<br>", 
  "<b>Gompertz:</b> \\( L(t) = ", input$Linf, " \\cdot e^{-\\frac{1}{", input$k, "} e^{-", input$k, "(t - ", input$t0, ")}} \\)"
  )))})
})
}

shinyApp(ui = ui, server = server)
