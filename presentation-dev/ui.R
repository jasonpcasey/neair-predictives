sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Overview", tabName = "overview", icon = icon("list")),
    menuItem("Linear Regression", icon = icon("th"), tabName = "regress"),
    menuItem("Regression Tree", icon = icon("th"), tabName = "tree"),
    menuItem("Random Forest", icon = icon("th"), tabName = "forest"),
    menuItem("Support Vector Untuned", icon = icon("bar-chart"), tabName = "svr1"),
    menuItem("Support Vector Tuned", icon = icon("bar-chart"), tabName = "svr2"),
    #menuItem("Charts", icon = icon("bar-chart"), tabName="charts"),
    menuItem("Summary", tabName = "regmods", icon = icon("dashboard"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "overview",
            h2("Models Examined"),
            tags$li('Linear Regression'),
            tags$li('Regression Tree (Classification Tree via ANOVA Method'),
            tags$li('Random Forest'),
            tags$li('Support Vector Regression (Untuned)'),
            tags$li('Support Vector Regression (Tuned)')),
    tabItem(tabName = "regmods",
            h2("Model Comparisons"),
            fluidRow(
              box(background="blue",
                  tableOutput('data'),
                  width=10)
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
            h2('Title'),
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
      )
  )
  )


dashboardPage(
  dashboardHeader(title="Predictive Models"),
  sidebar,
  body
)