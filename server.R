library(shiny)

# Define server logic to plot a Hypergeometric distribution with explanatory text
shinyServer(function(input, output) {
  
  # Slider input for number of women
  output$Nwomen <- renderUI({
    sliderInput("Nwomen", 
                paste("Number of", input$subgroup, "candidates:"), 
                min = 0, 
                max = input$Ntotal, 
                value = min(8, input$Ntotal),
                step = 1)
  })
  
  # Slider input for panel size
  output$Npanel <- renderUI({
    sliderInput("Npanel", 
                "Size of panel:", 
                min = 1, 
                max = input$Ntotal, 
                value = min(5, input$Ntotal),
                step = 1)
  })
  
  # Slider input for nr women whose prob to evaluate
  output$Nchosen <- renderUI({
    sliderInput("Nchosen", 
                paste("Number of", input$subgroup, "panelists whose probability we want to evaluate:"),
                min = 0, 
                max = min(input$Npanel, input$Nwomen),
                value = c(0,0),
                step = 1)
  })
  
  # Specify the hypergeometric distribution from the inputs
  thisDhyper <- function(x) {
    dhyper(x, m = input$Nwomen,
           n = (input$Ntotal - input$Nwomen),
           k = input$Npanel)
  }
  
  # Function that generates a plot of the distribution. The function
  # is wrapped in a call to reactivePlot to indicate that:
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  output$distPlot <- reactivePlot(function() {
    minMorK <- min(input$Nwomen, input$Npanel)
    thisBorder <- rep("black", minMorK + 1)
    thisBorder[(input$Nchosen[1]:input$Nchosen[2])+1] <- "red"
    barplot(100*thisDhyper(0:minMorK), names = 0:minMorK,
            xlab = paste("Number of", input$subgroup, "members on a panel of", input$Npanel),
            ylab = "Probability (%)",
            border = thisBorder)
  })
  
  output$probText <- renderUI({
    strNchosen <- ifelse(input$Nchosen[1] == input$Nchosen[2],
                         input$Nchosen[1],
                         paste(input$Nchosen[1], "to", input$Nchosen[2]))
    HTML(
      paste0("Let's say you started with <b>",
             input$Ntotal,
             "</b> candidates, of whom <b>",
             input$Nwomen,
             "</b> were ",
             input$subgroup,
             ", and you randomly chose a panel of <b>",
             input$Npanel,
             "</b> people from this candidate pool.<br/>The probability that your panel has <b>",
             strNchosen, "</b> ",
             input$subgroup,
             " members would be about <b>",
             round(sum(100*thisDhyper(input$Nchosen[1]:input$Nchosen[2])),
                   1),
             "%</b>.")
    )
  })
  
  output$footnoteText <- renderUI({
    HTML("(Calculations are based on the hypergeometric distribution, as in <a href='http://stats.stackexchange.com/questions/11836/probability-of-panel-assignment'>this StackExchange example</a>.<br/>Code available <a href='https://github.com/civilstat/MixedPanel'>on Github</a>.)")
  })
  
})
