#von Bertalanffy and Gompertz growth equation comparison

This app is created as a tool to visualize and investigate the differences between two commonly used growth models used to describe age and length relationships in fish, the von Bertalanffy and Gompertz models.
The app allows investigation as to how the parameters alters the shape of the growth curve, and the relationship between the parameters.
The app can be used as an educational tool, to understand the mechanisms between model parameters, and translate this information to a biological context. 

#Content of the app
-Plot with either one or both growth functions
-2 example datasets, which could be replaced by the users own data by loading the data to the script, and modifying plots slightly. 
-3 sliders, that allow adjustment of the three parameters used in von Bertalanffy and this version of Gompertz:
  -Linf (Asymptotic maksimum length)
  -k (Growth coeffisient)
  -t0 (hypothetical age at length = 0)
-Dynamic display of the two functions


#How to use the app
-Download rep (both the script and the data in data-folder should be downloaded) 
-Make sure all packages are installed before calling packages:
  -library(shiny)
  -library(shiny)
  -library(bslib)
  -library(readxl)
  -library(here)
  -library(tidyverse)
  -library(FSAdata)
-Open script in RStudio, and run shinyApp(ui = ui, server = server)
-The app will open in browser
-Select which growth equations and example data you want to include
-Adjust model parameters to alter model fit

#Contact
Jens Braaten Ustvedt - jeust6956@uib.no
Github: JensUstvedt





