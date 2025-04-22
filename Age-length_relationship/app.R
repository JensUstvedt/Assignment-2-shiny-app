

library(shiny)


ui <- page_sidebar(
  title = "Growth curve comparison",
  sliderInput("Linf", "Asymptotic Length (Linf):", min = 10, max = 200),
  sliderInput("k", "Growth Rate (k):", min = 0.01, max = 1),
  sliderInput("t0", "t₀ (Theoretical Age at Zero Length):", min = -5, max = 5),
  checkboxGroupInput("model", "Select model(s) to display:",
                     choices = c("von Bertalanffy", "Gompertz"),
                     selected = c("von Bertalanffy", "Gompertz")),
  mainPanel(plotOutput("plot"))
  
)


server <- function(input, output) {
  output$plot <- renderPlot(
    
  )

   
}


shinyApp(ui = ui, server = server)
