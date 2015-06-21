library(ISLR); library(dplyr); library(ggplot2); library(rCharts)

data(Auto)
auto <- tbl_df(Auto)
auto <- auto %>% filter(cylinders>3) %>%
     mutate(Origin = as.factor(ifelse(origin == 1, "American", ifelse(origin == 2, "European", "Japanese")))) %>%
     rename(      MPG = mpg,
                  Cylinders = cylinders,
                  Displacement = displacement,
                  Horsepower = horsepower,
                  Weight = weight,
                  Acceleration = acceleration,
                  Year = year) %>%
     select(-origin, -name)


server <- shinyServer(function(input, output){
     
     
     output$WeightMPGPlot <- renderPlot(
     ggplot(filter(auto, Year == input$Year), aes(Weight,MPG, color = factor(Cylinders))) +
          ggtitle("Weight vs Mpg\nInteractive by Year") +
          geom_point(shape = 1, size = 3.5)  +
          geom_smooth(method = lm, se = FALSE) +
          scale_colour_discrete(name = "Cylinders") +
          xlim(0, 4500) + ylim(0, 30)
     )
     
     output$OriginMpg <- renderPlot({
          qplot(Origin, MPG, data = auto, color = Origin, geom = c("boxplot", "jitter")) 
     })
     
     
     output$myChart <- renderChart({
          p1 <- nPlot(MPG ~ Weight, data = auto, group = 'Cylinders', type = 'scatterChart')
          p1$addParams(dom = "myChart")
          p1$xAxis(axisLabel = 'Weight (in lb)')
          p1$yAxis(axisLabel = 'MPG')
          return(p1)              
     })
     
     auto$Cylinders <- as.factor(auto$Cylinders)
     auto$Year <- as.factor(auto$Year)
     output$linechart <- renderPlot(
          ggplot(auto, aes_string(input$X, input$Y, color = input$Factor, group = input$Factor)) +
               geom_point() + geom_smooth(method = lm, se = FALSE, lwd = 1.25) + ggtitle("Make a Chart,\n Any Chart") +
               theme(plot.title = element_text(size=20,lineheight=.8, 
                                               vjust=2,family="Calibri")))
     
})
     