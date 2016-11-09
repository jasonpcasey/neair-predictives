function(input, output, session) {
  #
  output$data <- renderTable(reg.model.compare)
  output$classif <- renderPrint(table(cpredlr, cat.testing.data$tier))
  output$scatter1 <- renderPlot(predPlot(predlr, testing.data$overall))
  output$scatter2 <- renderPlot(predPlot(predsvu, testing.data$overall))
  output$scatter3 <- renderPlot(predPlot(predsvt, testing.data$overall))
  output$scatter4 <- renderPlot(predPlot(predrf, testing.data$overall))
}