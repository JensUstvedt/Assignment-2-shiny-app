

library(shiny)


ui <- fluidPage(
  titlePanel("Growth curve comparison"),
  sidebarLayout(
    sidebarPanel(
  sliderInput("Linf", "Asymptotic Length (Linf):", min = 10, max = 200, value = 100),
  sliderInput("k", "Growth Rate (k):", min = 0.01, max = 1, value = 0.2),
  sliderInput("t0", "t₀ (Theoretical Age at Zero Length):", min = -5, max = 5, value = 0),
  checkboxGroupInput("model", "Select model(s) to display:",
                     choices = c("von Bertalanffy", "Gompertz"),
                     selected = c("von Bertalanffy", "Gompertz"))
  #checkboxGroupInput("data", "Select example data to display:",
                    # choises = c(),
                    # selected = c())
  ),
  mainPanel(plotOutput("plot"))
))


server <- function(input, output) {
  
  output$plot <- renderPlot({
    Linf <- input$Linf
    k <- input$k
    t0 <- input$t0
    t <- seq(0, 50)
    VB <- Linf * (1 - exp(-k * (t - t0)))
    Gomp <- Linf * exp(-(1/k) * exp(-k * (t - t0)))
    
    
    if(all(c("von Bertalanffy", "Gompertz") %in% input$model)) {
      plot(t, VB, type = "l")
      lines(t, Gomp)
    } else if("Gompertz" %in% input$model){
      plot(t, Gomp, type = "l")
    } else if("von Bertalanffy" %in% input$model){
      plot(t, VB, type = "l")
    } else{plot.new()
           text(0.5, 0.5, "Please select at least one model")}
      
  }
  )
}

shinyApp(ui = ui, server = server)
