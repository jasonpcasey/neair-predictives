function(input, output, session) {
  

  observeEvent(input$resetBtn, {
    updateNumericInput(session, "gpa25", value = base.case$gpa25)
    updateNumericInput(session, "gpa75", value = base.case$gpa75)
    updateNumericInput(session, "lsat25", value = base.case$lsat25)
    updateNumericInput(session, "lsat75", value = base.case$lsat75)
    updateNumericInput(session, "pct_emp_grad", value = base.case$pct_emp_grad)
    updateNumericInput(session, "pct_emp_9", value = base.case$pct_emp_9)
    updateNumericInput(session, "accept", value = base.case$accept)
    updateNumericInput(session, "sf_ratio", value = base.case$sf_ratio)
    updateNumericInput(session, "bar_pass_pct", value = base.case$bar_pass_pct)
  })
  
  data <- reactive({
    new.row <- makeRow(3.4,
                       3.8,
                       input$gpa25,
                       input$gpa75,
                       input$lsat25,
                       input$lsat75,
                       input$pct_emp_grad,
                       input$pct_emp_9,
                       input$accept,
                       input$sf_ratio,
                       input$bar_pass_pct,
                       original.data)
    updatePrediction(new.row)
  })

  output$plot1 <- renderPlot({
    ggplot(data(), aes(x=lsat75, y=overall, label="")) +
      geom_point(size=3.5,
                 aes(color=factor(group))) +
      scale_color_manual(values = pal,
                         breaks=c('ND (Predicted)','ND (Reported)','Others')) +
      geom_smooth(method = "lm", se = TRUE) +
      labs(x='LSAT 75th Percentile', 
           y = "Overall Score") +
      geom_text(vjust = 0, nudge_y = 1.1) +
      theme(legend.title=element_blank(),
            legend.position="top")
  })
  
  output$plot2 <- renderPlot({
    ggplot(data(), aes(x=gpa25, y=overall, label="")) +
      geom_point(size=3.5,
                 aes(color=factor(group))) +
      scale_color_manual(values = pal,
                         breaks=c('ND (Predicted)','ND (Reported)','Others')) +
      geom_smooth(method = "lm", se = TRUE) +
      labs(x='GPA 25th Percentile', 
           y = "Overall Score") +
      geom_text(vjust = 0, nudge_y = 1.1) +
      theme(legend.title=element_blank(),
            legend.position="top")
  })
  
  output$plot3 <- renderPlot({
    ggplot(data(), aes(x=pct_emp_grad, y=overall, label="")) +
      geom_point(size=3.5,
                 aes(color=factor(group))) +
      scale_color_manual(values = pal,
                         breaks=c('ND (Predicted)','ND (Reported)','Others')) +
      geom_smooth(method = "lm", se = TRUE) +
      labs(x='% Employed at Graduation', 
           y = "Overall Score") +
      geom_text(vjust = 0, nudge_y = 1.1) +
      theme(legend.title=element_blank(),
            legend.position="top")
  })
  
  output$plot4 <- renderPlot({
    ggplot(data(), aes(x=accept, y=overall, label="")) +
      geom_point(size=3.5,
                 aes(color=factor(group))) +
      scale_color_manual(values = pal,
                         breaks=c('ND (Predicted)','ND (Reported)','Others')) +
      geom_smooth(method = "lm", se = TRUE) +
      labs(x='Acceptance Rate (%)', 
           y = "Overall Score") +
      geom_text(vjust = 0, nudge_y = 1.1) +
      theme(legend.title=element_blank(),
            legend.position="top")
  })
  
  output$origScore <- renderValueBox({
    valueBox(
      data()$overall[data()$group=='ND (Reported)'],
      "Published Score",
      color = "purple",
      icon("bar-chart")
    )
  })

  output$origRank <- renderValueBox({
    valueBox(
      data()$rank[data()$group=='ND (Reported)'],
      "Published Rank",
      color = "purple",
      icon("list")
    )
  })

  output$predScore <- renderValueBox({
    valueBox(
      round(data()$overall[data()$group=='ND (Predicted)'], digits=0),
      "Predicted Score",
      color = "maroon",
      icon("bar-chart")
    )
  })

  output$predRank <- renderValueBox({
    valueBox(
      data()$rank[data()$group=='ND (Predicted)'],
      "Predicted Rank",
      color = "maroon",
      icon("list")
    )
  })
  
}