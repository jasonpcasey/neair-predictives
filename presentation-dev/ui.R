sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Slides", icon = icon("list"), tabName = "slides"),
    # menuItem("Widgets", icon = icon("th"), tabName = "widgets"),
    menuItem("Charts", icon = icon("bar-chart"), tabName="charts")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
            h2("Model Comparisons"),
            box(tableOutput('data'))
    ),
    
    tabItem(tabName = "slides",
            h2("Slides tab content"),
            fluidRow(
              tabBox(
                title = "First tabBox",
                # The id lets us use input$tabset1 on the server to find the current tab
                id = "tabset1", height = "250px",
                tabPanel("Tab1", "First tab content"),
                tabPanel("Tab2", "Tab content 2")
              ),
              tabBox(
                side = "right", height = "250px",
                selected = "Tab3",
                tabPanel("Tab1", "Tab content 1"),
                tabPanel("Tab2", "Tab content 2"),
                tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
              )
            ),
            fluidRow(
              tabBox(
                # Title can include an icon
                title = tagList(shiny::icon("gear"), "tabBox status"),
                tabPanel("Tab1",
                         "Currently selected tab from first box:",
                         verbatimTextOutput("tabset1Selected")
                ),
                tabPanel("Tab2", "Tab content 2")
              )
            )
    ),
    tabItem(tabName = "charts",
            h2("Charts tab content"),
            tabBox(
              title = "First tabBox",
              # The id lets us use input$tabset1 on the server to find the current tab
              id = "tabset1", height = "250px",
              width='100%',
              tabPanel("Tab1", "First tab content"),
              tabPanel("Tab2", "Tab content 2")
            )
    )
  )
)

dashboardPage(
  dashboardHeader(title="Predictive Models"),
  sidebar,
  body
)