#von Bertalanffy and Gompertz growth equation comparison

This app is designed as a tool to visualize and explore the differences between two commonly used growth models for describing age-length relationships in fish; the von Bertalanffy and Gompertz models.
It enables users to see how changes in model parameters affect the shape of the growth curve, and how the parameters relate to each other.
The app serves as an educational resource for understanding the mechanisms between model parameters, and translate this information to a biological context. 
The comparison of the two models for 2 different example species demonstrate the importance of model choice and its relation biological interspecific variability. 

#Features
-Plot with either one or both growth functions
-Inclusion of 2 example species datasets, blue whiting and Blue catfish
   -These can be replaced by your own data by loading it to the script, and modifying the code for the plots slightly. 
-interactive sliders, that allow adjustment of the three parameters used in the models
  -Linf (Asymptotic maksimum length)
  -k (Growth coeffisient)
  -t0 (hypothetical age at length = 0)
-Dynamic display of the model functions


#How to use the app
-Download repository, including both the script and the data folder
-Install all packages, if not already installed:
<pre> ```r install.packages(c("shiny", "tidyverse", "bslib", "readxl", "here", "FSAdata"))``` </pre>
-Open script in RStudio
-Run the app using:
<pre> ```r shinyApp(ui = ui, server = server)``` </pre>
-The app will open in browser
-Select which growth equations and example data you want to include
-Adjust model parameters to alter model fit

#Contact
Jens Braaten Ustvedt - jeust6956@uib.no
Github: JensUstvedt





