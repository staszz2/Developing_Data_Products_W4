library(shiny)
library(ggplot2)

dataSet <- read.csv("players.csv")

allAccuracies <- rbind(dataSet$LIGHTNING_ACCURACY, dataSet$RAILGUN_ACCURACY, dataSet$ROCKET_ACCURACY)
ylim <-max(allAccuracies)
xlim <-max(dataSet$KDR)
lg_reg <- lm(LIGHTNING_ACCURACY ~ KDR,dataSet)
rg_reg <- lm(RAILGUN_ACCURACY ~ KDR,dataSet)
rl_reg <- lm(ROCKET_ACCURACY ~ KDR,dataSet)


shinyServer(function(input, output) {
   
  output$myplot <- renderPlot({
    
    data <- subset(dataSet, KDR> input$dEfficiency)

    if(length(input$dWeapon) > 0)
    {
      g <- ggplot(data, aes(x = KDR, y = value, color = variable)) + xlim(0, xlim) + ylim(0,ylim) 
      if(1 %in% input$dWeapon) { g <- g + geom_point(aes(y = LIGHTNING_ACCURACY, col = "LIGHTNING_ACCURACY")) + geom_abline(color = 'red', intercept = coef(lg_reg)[2], slope = coef(lg_reg)[1]) }
      if(2 %in% input$dWeapon) { g <- g + geom_point(aes(y = RAILGUN_ACCURACY, col = "RAILGUN_ACCURACY")) + geom_abline(color = 'green', intercept = coef(rg_reg)[2], slope = coef(rg_reg)[1]) }
      if(3 %in% input$dWeapon) { g <- g + geom_point(aes(y = ROCKET_ACCURACY, col = "ROCKET_ACCURACY")) + geom_abline(color = 'blue', intercept = coef(rl_reg)[2], slope = coef(rl_reg)[1])}
    g
    }
    })
    output$averages <- renderText({
      data <- subset(dataSet, KDR> input$dEfficiency)
      text <- " "
      if(length(input$dWeapon) > 0)
      {
        text <- paste("Average accuracies for efficiency ", input$dEfficiency, " and above</br>")
        if(1 %in% input$dWeapon) { text <- paste(text, " Lightning gun : ", round(mean(data$LIGHTNING_ACCURACY),1) , "</br>")}
        if(2 %in% input$dWeapon) { text <- paste(text, " Rail gun : ", round(mean(data$RAILGUN_ACCURACY),1) , "</br>")}
        if(3 %in% input$dWeapon) { text <- paste(text, " Rocket Launcher : ", round(mean(data$ROCKET_ACCURACY),1) , "</br>")}
      }
      text
    })
    
    output$data = renderDataTable({
      data <- subset(dataSet, KDR> input$dEfficiency)
      data
    }
    )
})
