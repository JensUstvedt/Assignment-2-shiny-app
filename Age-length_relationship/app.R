
library(shiny)
library(bslib)
library(readxl)
library(here)
library(tidyverse)
library(FSAdata)

#UI. Decided to use page_sidebar instead of fluid_page as page_sidebar provided a more structured user interface more easily formatted

ui <- page_sidebar(
  plotOutput("plot", height = "550"),
  card(
    card_header("Dynamic growth model equations"), #Added a card with dynamic formulas. 
  card_body(
    uiOutput("DynamicFormulaSheet"))),
  title = "Growth curve comparison",
  sidebar = sidebar( #Sidebar with all sliders and checkboxes 
             sliderInput("Linf", "Asymptotic Length (Linf):", min = 10, max = 1500, value = 500), #Add min and max length to the slider. Value is starting value when launching app
             sliderInput("k", "Growth Rate (k):", min = 0.01, max = 1, value = 0.2),
             sliderInput("t0", "t₀ (Theoretical Age at Zero Length):", min = -5, max = 5, value = 0), #t0 is including negative values as this is a hypothetical age of length 0, and is therefore logically often negative (depending on growth at young ages)
    
             checkboxGroupInput("model", "Select model(s) to display:",
                               choices = c("von Bertalanffy", "Gompertz"),
                               selected = c("von Bertalanffy", "Gompertz")), #Checkboxes for model selection and example data selection
             checkboxGroupInput("data", "Select example data to display:", #If you are using your own data, replace one or both of these species with your own
                                choices = c("Blue whiting", "Blue catfish"),
                                selected = c())
      )
    )
    

server <- function(input, output) {
  
  bw_data <- read_excel(here("data/blue_whiting_data.xlsx")) |>  #Blue whiting data. Make sure data is in correct folder after downloading from github
    select(length, age) #In this section you can replace the blue whiting data with your own data. Make sure length and age are column names in your data.
  blue_catfish_data <- get("BlueCatfish") #Blue catfish data is from the FSAdata package. 
  
  #These datasets are good examples because they display different growth patterns, making for good display of why model choice is important and should be adjusted to species
  
  output$plot <- renderPlot({
    Linf <- input$Linf #Creating objects for the growth functions
    k <- input$k
    t0 <- input$t0
    t <- seq(-5, 30) # t is the age, so is a vector. Is from -5 because theoretical t0 is used in the model, and is typically a negative value
    VB <- Linf * (1 - exp(-k * (t - t0))) #Von bertalanffy growth equation
    Gomp <- Linf * exp(-(1/k) * exp(-k * (t - t0))) #Gompertz growth equation
    ymax <- Linf * 1.1 #Making a object to easily set y_lim. Makes ylim adjustable to the input value of Linf
    
    plot(NULL, 
         xlab = "t (Age in years)",
         ylab = "Length (mm)",
         xlim = c(-5, 30),
         ylim = c(0, ymax),
         cex.axis = 1.5,
         cex.lab = 1.5,
         lwd = 2,
         bty = "l")
    
    legend("bottomright",
           legend = c("von Bertalanffy", "Gompertz", "Blue whiting", "Blue catfish"), #replace blue whiting with you species if using your own data
           col = c("black", "red", "blue", "darkgreen"),
           lty = c(1, 1, NA, NA),
           pch = c(NA, NA, 16, 16),
           pt.cex = 1.5,
           cex = 1.4, 
           bty = "n")
    grid() #Added grid so it would be easier to see the approximation of length to Linf (asymptotic value)
    
    if(all(c("von Bertalanffy", "Gompertz") %in% input$model)) { #Use if else to make sure plots are displayed or not based on selections in user interface. This plots both if both are selected 
      lines(t, VB, col = "black", lwd = 3)
      lines(t, Gomp, col = "red", lwd = 3)
    } else if("Gompertz" %in% input$model){ #Plots just Gompertz if only Gompertz is selected
      lines(t, Gomp, col = "red", lwd = 3)
    } else if("von Bertalanffy" %in% input$model){ #Plots just VB if only VB is selected 
      lines(t, VB, col = "black", lwd = 3)
    } else{plot.new()
           text(0.5, 0.5, "Please select at least one model")} #If no models are selected, reads message to select model
    if(all(c("Blue whiting", "Blue catfish") %in% input$data))  { #Same use of if else for example data. This line plots both if both are selected
      points(bw_data$age, bw_data$length, col = "blue", pch = 19)
      points(blue_catfish_data$age, blue_catfish_data$tl, col = "darkgreen", pch = 19) #make sure all cases of species name is replaced with your own, if using your own data
    }else if("Blue whiting" %in% input$data){ #Plots only blue whiting data if only blue whiting is selected
      points(bw_data$age, bw_data$length, col = "blue", pch =19)
    } else if("Blue catfish" %in% input$data){ #Plots only blue catfish data if only blue catfish is selected
      points(blue_catfish_data$age, blue_catfish_data$tl, col = "darkgreen", pch = 19)
    }
    #Did not add any specific message if no example data is selected as this is a viable option. 
})
  output$DynamicFormulaSheet <- renderUI({ #Dynamic formulas
    withMathJax(HTML( #withMathJax helps transform the input in paste0 to correctly formatted functions.
      paste0(
        "<b>von Bertalanffy:</b> \\( L(t) = ", input$Linf, " \\cdot (1 - e^{-", input$k, "(t - ", input$t0, ")}) \\)<br>", 
        "<b>Gompertz:</b> \\( L(t) = ", input$Linf, " \\cdot e^{-\\frac{1}{", input$k, "} e^{-", input$k, "(t - ", input$t0, ")}} \\)"
      )))}) #Not the most intuitive way of writing out functions, but results in correct functions. Use input$values to make sure the functions are dynamic, extracting values from the input in the sliders
}

shinyApp(ui = ui, server = server) #to run the app
