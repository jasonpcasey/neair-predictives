sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Overview", tabName = "overview", icon = icon("list")),
    menuItem("Out of Scope", tabName = "scope", icon = icon("list")),
    menuItem("Linear Regression", icon = icon("table"), tabName = "regress"),
    menuItem("Regression Tree", icon = icon("sitemap"), tabName = "tree"),
    menuItem("Random Forest Explained", icon = icon("paperclip"), tabName = "forestexp"),
    menuItem("Random Forest", icon = icon("tree"), tabName = "forest"),
    menuItem("SVR Explained", icon = icon("paperclip"), tabName = "svrexp"),
    menuItem("Support Vector Untuned", icon = icon("line-chart"), tabName = "svr1"),
    menuItem("Support Vector Tuned", icon = icon("line-chart"), tabName = "svr2"),
    menuItem("Summary", tabName = "regmods", icon = icon("th")),
    menuItem("Questions", tabName = "credits", icon = icon("question"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "overview",
            h1("Models Examined"),
            tags$h2('Linear Regression'),
            tags$h2('Regression Tree (Classification Tree via ANOVA Method)'),
            tags$h2('Random Forest'),
            tags$h2('Support Vector Regression (Untuned)'),
            tags$h2('Support Vector Regression (Tuned)'),
            hr(),
            tags$h2('All presentation data and files can be found at:'),
            div(style="display:inline-block;width:100%;padding-left:10px;font-size: 30px;color:blue",
                p("https://github.com/jasonpcasey/neair-predictives"))),
    tabItem(tabName = "scope",
            fluidRow(width=12,
                     h1("Sir Not Appearing in this Film")
                     ),
            fluidRow(width=12,
                     tags$h2('Logistic Models')
                     ),
            fluidRow(width=12,
                     div(style="display:inline-block;width:100%;padding-left:10px;font-size: 30px;color:blue",
                p("https://www.r-bloggers.com/how-to-perform-a-logistic-regression-in-r/"))
                ),
            fluidRow(width=12,
                     tags$h2('Classification Trees')
                     ),
            fluidRow(width=12,
                     div(style="display:inline-block;width:100%;padding-left:10px;font-size: 30px;color:blue",
                p("http://trevorstephens.com/kaggle-titanic-tutorial/r-part-3-decision-trees/"))
                ),
            fluidRow(width=12,
                     tags$h2('Random Forest (Discrete Outcomes)')
                     ),
            fluidRow(width=12,
                     div(style="display:inline-block;width:100%;padding-left:10px;font-size: 30px;color:blue",
                p("http://trevorstephens.com/kaggle-titanic-tutorial/r-part-5-random-forests/"))
                ),
            fluidRow(width=12,
                     tags$h2('Support Vector Machines')
                     ),
            fluidRow(width=12,
                     div(style="display:inline-block;width:100%;padding-left:10px;font-size: 30px;color:blue",
                p("ftp://cran.r-project.org/pub/R/web/packages/e1071/vignettes/svmdoc.pdf"))
            )
    ),
    tabItem(tabName="regress",
            h2("Linear Regression Output"),
            fluidRow(
              box(background="blue",
                  verbatimTextOutput('regsumm'),
                  width=12)
            ),
            fluidRow(
              box(background="blue",
                  verbatimTextOutput('reganov'),
                  width=12)
            )
      ),
    tabItem(tabName='tree',
            h2('Regression Tree Output'),
            fluidRow(
              box(background="blue",
                  verbatimTextOutput('treesumm'),
                  width=12)
            ),
            fluidRow(
              box(title='Tree Plot',
                  plotOutput('treeplot',
                             height=750,
                             width=650),
                  width=12,
                  height = 850,
                  background='blue')
            )
      ),
    tabItem(tabName='forest',
            h2('Random Forest Output'),
            fluidRow(
              box(title='Summary',
                  background="blue",
                  verbatimTextOutput('rfsumm'),
                  width=12)
            ),
            fluidRow(
              box(title='Importance Statistics',
                  background="blue",
                  verbatimTextOutput('rfimp'),
                  width=12)
            ),
            fluidRow(
              box(title='Variable Importance Plots',
                  background="blue",
                  plotOutput('viplot'),
                  width=12)
            )
      ),
    tabItem(tabName='svr1',
            h2('Support Vector (Untuned) Output'),
            fluidRow(
              box(title='Predicted by Observed',
                  background="blue",
                  plotOutput('svuplot',
                             height=550,
                             width=650),
                  width=12,
                  height=650)
            ),
            fluidRow(
              box(title='Summary',
                  #background="blue",
                  dataTableOutput('svrsumm1'),
                  width=12)
            )
    ),
    tabItem(tabName='svr2',
            h2('Support Vector (Tuned) Output'),
            fluidRow(
              box(title='Predicted by Observed',
                  background="blue",
                  plotOutput('svtplot',
                             height=550,
                             width=650),
                  width=12,
                  height=650)
            ),
            fluidRow(
              box(title='Summary',
                  #background="blue",
                  dataTableOutput('svrsumm2'),
                  width=12)
            )
      ),
    tabItem(tabName='credits',
            fluidRow(
              box(background="black",
                  width=100,
                  height=1600,
                  img(src='credits.jpg', 
                      align = "center",
                      width=1600)),
              width=12)
    ),
    tabItem(tabName = "regmods",
            h2("Model Comparisons"),
            fluidRow(
              box(background="blue",
                  tableOutput('data'),
                  width=10)
            )
    )
  )
  )


dashboardPage(
  dashboardHeader(title="Predictive Models"),
  sidebar,
  body
)