library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Probability of a Mixed Panel Assignment"),
  
  # Sidebar with inputs
  sidebarPanel(
    textInput("subgroup", "Subgroup name:", value = "female"),
    
    # Slider input for total number of people
    sliderInput("Ntotal", 
                "Total number of candidates:", 
                min = 0, 
                max = 50, 
                value = 20),
    
    # Slider input for number of women
    uiOutput("Nwomen"),
    
    # Slider input for panel size
    uiOutput("Npanel"),

    # Slider input for nr women whose prob to evaluate
    uiOutput("Nchosen")
    
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    htmlOutput("probText"),
    plotOutput("distPlot", height = "300px"),
    htmlOutput("footnoteText")
  )
))
