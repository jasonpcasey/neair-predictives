dashboardPage(
  dashboardHeader(title="Regression Model"),

  dashboardSidebar(
    width=275,
    div(style="padding-left: 10px;display:inline-block", titlePanel('Select Parameters'), style="float:right"),
    
    #div(style="padding-left: 10px;display:inline-block", submitButton("Go", icon('calculator')), style="width=30px"),
    # div(style="display:inline-block;width:33%;padding-left: 10px;",actionButton('goBtn', "Estimate", icon('calculator'))),
    div(style="display:inline-block;width:33%;padding-left: 10px;",submitButton("Predict", icon('calculator'))),
    div(style="display:inline-block;width:33%;padding-left: 10px;",actionButton("resetBtn", label = "Reset", icon = icon("briefcase"))),
    
    #numericInput('peer_assess', 'Peer Assessment Score', base.case$peer_assess, min = 1, max = 5, step=0.1),
    #numericInput('judges_assess', 'Judges Assessment Score', base.case$judges_assess, min = 1, max = 5, step=0.1),
    numericInput('gpa25', 'UG GPA 25th p-tile', base.case$gpa25, min = 1, max = 4, step=0.1),
    numericInput('gpa75', 'UG GPA 75th p-tile', base.case$gpa75, min = 1, max = 4, step=0.1),
    numericInput('lsat25', 'LSAT 25th p-tile', base.case$lsat25, min = 120, max = 180, step=1),
    numericInput('lsat75', 'LSAT 75th p-tile', base.case$lsat75, min = 120, max = 180, step=1),
    numericInput('pct_emp_grad', '% Employed at Graduation', base.case$pct_emp_grad, min = 1, max = 100, step=0.1),
    numericInput('pct_emp_9', '% Employed at 9 Months', base.case$pct_emp_9, min = 1, max = 100, step=0.1),
    numericInput('accept', 'Acceptance Rate', base.case$accept, min = 1, max = 100, step=0.1),
    numericInput('sf_ratio', 'Students per Faculty', base.case$sf_ratio, min = 1, max = 35, step=0.1),
    numericInput('bar_pass_pct', 'Bar Passage %', base.case$bar_pass_pct, min = 1, max = 100, step=0.1)
  ),
  dashboardBody(
    fluidRow(
      valueBoxOutput("origScore"),
      infoBoxOutput("origRank")
    ),
    fluidRow(
      valueBoxOutput("predScore"),
      valueBoxOutput("predRank")
    ),
    fluidRow(
      box(
      title = "Overall Score by LSAT 75", background = "orange", solidHeader = TRUE,
      plotOutput("plot1", height = 250)
      ),
      box(
        title = "Overall Score by GPA 25", background = "orange", solidHeader = TRUE,
        plotOutput("plot2", height = 250)
      )
    ),
    fluidRow(
      box(
        title = "Overall Score by % Emp. at Grad", background = "orange", solidHeader = TRUE,
        plotOutput("plot3", height = 250)
      ),
      box(
        title = "Overall Score by Selectivity", background = "orange", solidHeader = TRUE,
        plotOutput("plot4", height = 250)
      )
    )
  )
)