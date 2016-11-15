sidebar <- dashboardSidebar(
  sidebarMenu(
    #menuItem("Overview", tabName = "overview", icon = icon("list")),
    #menuItem("Out of Scope", tabName = "scope", icon = icon("list")),
    menuItem("Linear Regression", icon = icon("table"), tabName = "regress"),
    menuItem("Regression Tree", icon = icon("sitemap"), tabName = "tree"),
    #menuItem("Random Forest Explained", icon = icon("paperclip"), tabName = "forestexp"),
    menuItem("Random Forest", icon = icon("tree"), tabName = "forest"),
    #menuItem("SVR Explained", icon = icon("paperclip"), tabName = "svrexp"),
    menuItem("Support Vector Untuned", icon = icon("line-chart"), tabName = "svr1"),
    menuItem("Support Vector Tuned", icon = icon("line-chart"), tabName = "svr2"),
    menuItem("Summary", tabName = "regmods", icon = icon("th"))
  )
)

body <- dashboardBody(
  tabItems(
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
                             width=1200),
                  width=12,
                  height = 1200,
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
    tabItem(tabName = "regmods",
            h2("Model Comparisons"),
            fluidRow(
              box(background="blue",
                  tableOutput('data'),
                  width=10)
            ),
            fluidRow(
              box(title='Variable Importance',
                  background="blue",
                  tableOutput('varimptab'),
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