function(input, output, session) {
  #
  output$data <- renderTable(reg.model.compare)
  output$regsumm <- renderPrint(summary(lr))
  output$reganov <- renderPrint(anova(lr))
  output$treesumm <- renderPrint(print(tr))
  output$treeplot <- renderPlot({
    plot(tr)
    })
  output$rfsumm <- renderPrint(print(rf))
  output$rfimp <- renderPrint(importance(rf))
  output$svrsumm1 <- renderDataTable({ 
    cbind(predsvu, testing.data)
  })
  output$svuplot <- renderPlot({ plotMe(predsvu,
                                        testing.data$overall,
                                        'Predicted',
                                        'Observed',
                                        'Predicted vs Observed')})
  output$svrsumm2 <- renderDataTable({ 
    cbind(predsvt, testing.data)
  })
  output$svtplot <- renderPlot({ plotMe(predsvt,
                                        testing.data$overall,
                                        'Predicted',
                                        'Observed',
                                        'Predicted vs Observed')})
  output$viplot <- renderPlot(varImpPlot(rf, main=NULL))

  output$varimptab <- renderTable({
    summ
  })
  
}