function(input, output, session) {
  #
  output$data <- renderTable(model.compare)
}