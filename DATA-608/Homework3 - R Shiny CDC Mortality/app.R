library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(kableExtra)

### Load base CDC Data ##
cdc <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv", header= TRUE)

### Prepare Data for Question1 ##
cdcrank2010 <- cdc %>% filter(Year == '2010') %>% group_by(ICD.Chapter) %>% mutate(rank = rank(-Crude.Rate)) %>% arrange(rank)

### Prepare Data for Question2 ##
cdcNatlAvg <- cdc %>% group_by(ICD.Chapter,Year) %>% mutate(Avg.Rate = round(sum(Deaths)/sum(Population)*10^5,1)) %>% ungroup()

## Define UI components for Shiny App##
ui <- fluidPage(
  theme = shinythemes::shinytheme("lumen"),
  h1('Exploring CDC WONDER Mortality Rate data'),
  h4("Soumya ghosh, DATA 608 - Homework3"),
  navlistPanel(
    tabPanel("Question 1",
      wellPanel(
        strong("Question 1: As a researcher, you frequently compare mortality rates from particular causes across
         different States. You need a visualization that will let you see (for 2010 only) the crude
         mortality rate, across all States, from one cause (for example, Neoplasms, which are
         effectively cancers). Create a visualization that allows you to rank States by crude mortality
         for each cause of death.")),
  
      headerPanel('Mortality Rate Ranking for 2010'),
      sidebarPanel(
        selectInput('cause', 'Cause of Death:', unique(cdcrank2010$ICD.Chapter), selected='Neoplasms'),
        sliderInput(inputId = "rank",
                    label = "Select No. of States to Rank:",
                    value = 5, min = 1, max = 52)
      ),
      mainPanel(
        plotlyOutput('plot1')
      )
    ),
    tabPanel("Question 2",
      wellPanel(
         strong("Question 2: Often you are asked whether particular States are improving their mortality rates (per cause)
              faster than, or slower than, the national average. Create a visualization that lets your clients
              see this for themselves for one cause of death at the time. Keep in mind that the national
              average should be weighted by the national population.")),
             
      headerPanel('Mortality Rate Trend Comparison'),
         sidebarPanel(
             selectInput('cause2', 'Cause of Death:', unique(cdcNatlAvg$ICD.Chapter), selected='Neoplasms'),
             checkboxGroupInput('state', 'Select States to Compare:', unique(cdcNatlAvg$State), selected = 'CT')
             ),
             mainPanel(
               plotlyOutput('plot2')
             )
        ),
    fluidRow(
      column(12,
             h2("Data Source"),
             p("The Underlying Cause of Death data available on WONDER are 
               county-level national mortality and population data spanning 
               the years 1999-2015. Data are based on death certificates for 
               U.S. residents. Each death certificate identifies a single 
               underlying cause of death and demographic data. The number of 
               deaths, crude death rates or age-adjusted death rates, and 95% 
               confidence intervals and standard errors for death rates can 
               be obtained by place of residence (total U.S., region, state 
               and county), age group (single-year-of age, 5-year age groups, 
               10-year age groups and infant age groups), race, Hispanic 
               ethnicity, gender, year, cause-of-death (4-digit ICD-10 code or 
               group of codes), injury intent and injury mechanism, drug/alcohol 
               induced causes and urbanization categories. Data are also available 
               for place of death, month and week day of death, and whether 
               an autopsy was performed."),
             helpText(
               "For more information on this Data Source visit: ",
               a(href="https://wonder.cdc.gov/wonder/help/ucd.html#", target="_blank", "CDC-WONDER")
             )
          )
       )
    )
)

## Define Server component for Shiny App ##
server <- function(input, output) {

  selectedData <- reactive({
    dfSlice <- cdcrank2010 %>%
      filter(ICD.Chapter == input$cause, rank <= input$rank)
  })
  
  selectedData2 <- reactive({
    dfSlice2 <- cdcNatlAvg %>%
      filter(ICD.Chapter == input$cause2, State %in% input$state)
  })

  output$plot1 <- renderPlotly({

    plot_ly(selectedData(), x = ~State, y = ~Crude.Rate, type='bar', color = I("grey")) %>%
      layout(
        title = "Crude Mortality Rate Rank",
        xaxis = list(title = "State",
                     categoryorder = "array",
                     categoryarray = ~rank),
        yaxis = list(title = "Crude Mortality Rate")
      )
  })
  
  output$plot2 <- renderPlotly({
    
    plot_ly(selectedData2(), x = ~Year, y = ~Crude.Rate, linetype = ~State, type='scatter', mode = 'lines+markers') %>%
      add_lines(y = ~Avg.Rate, name = 'National Average Rate', mode = 'lines', line = list(color = I("black"), dash = 'solid')) %>%
      layout(
        title = "Crude Mortality Rate Trend Vs. National Avg.",
        xaxis = list(title = "Year"),
        yaxis = list(title = "Mortality Rate")
      )
  })

}


### Launch the app ##
shinyApp(ui = ui, server = server)
