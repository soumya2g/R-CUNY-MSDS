library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(kableExtra)
library(jsonlite)
library(RSocrata)
library(stringr)
library(shinydashboard)
library(sunburstR)
library(dashboardthemes)
library(maps)
library(leaflet)
library(geojsonio)
library(sp)

### Load base NY Solar Data using SoSQL Queries ##

### Dasboard Data Period Notification 
soql_url <- 'https://data.ny.gov/resource/3x8r-34rs.json?$select=max(date_trunc_ymd(reporting_period)) as Repoerted_date'
soql_url <- str_replace_all(soql_url, ' ','%20')

rptg_period <- fromJSON(soql_url, simplifyVector = TRUE, flatten = TRUE)

## Dataframe# 1. Detail Data ##
soql_url <- 'https://data.ny.gov/resource/3x8r-34rs.json?$select=state,county,city,zip_code,sector,program_type,project_status,date_extract_y(date_install) as year_completed,count(project_number) as Project_Count,sum(project_cost) as Project_Cost,sum(totalnameplatekwdc) as Installed_Capacity_KWDC,sum(expected_kwh_annual_production/1000) as Expected_Annual_Production_MWH&$group=state,county,city,zip_code,sector,program_type,project_status,date_extract_y(date_install)&$order=state,county,city,zip_code,sector,program_type,project_status,date_extract_y(date_install)'
soql_url <- str_replace_all(soql_url, ' ','%20')
proj_details <- fromJSON(soql_url, simplifyVector = TRUE, flatten = TRUE)

proj_details$Expected_Annual_Production_MWH <- round(as.numeric(proj_details$Expected_Annual_Production_MWH),2)
proj_details$Project_Cost <- paste('$',formatC(proj_details$Project_Cost, big.mark=',', format = 'f'))
proj_details$Project_Count <- as.numeric(proj_details$Project_Count)
proj_details$Installed_Capacity_KWDC <- as.numeric(proj_details$Installed_Capacity_KWDC)

## Summary ###
soql_url <- 'https://data.ny.gov/resource/3x8r-34rs.json?$select=county,sector,program_type,project_status,sum(totalnameplatekwdc/1000) as mwdc_capacity_rating,sum(expected_kwh_annual_production/1000000) as expected_gwh_annual_production,count(project_number) as total_projects&$group=county,sector,program_type,project_status'
soql_url <- str_replace_all(soql_url, ' ','%20')
proj_summary <- fromJSON(soql_url, simplifyVector = TRUE, flatten = TRUE)

proj_summary$mwdc_capacity_rating <- round(as.numeric(proj_summary$mwdc_capacity_rating),0)
proj_summary$expected_gwh_annual_production <- round(as.numeric(proj_summary$expected_gwh_annual_production),0)
proj_summary$total_projects <- as.numeric(proj_summary$total_projects)

header_df1 <- proj_summary %>% group_by(county) %>% summarize(mwdc_capacity_rating = sum(mwdc_capacity_rating), expected_gwh_annual_production = sum(expected_gwh_annual_production),total_projects= sum(total_projects))
header_df2 <- proj_summary %>% summarize(mwdc_capacity_rating = sum(mwdc_capacity_rating), expected_gwh_annual_production = sum(expected_gwh_annual_production),total_projects= sum(total_projects)) %>% mutate(county = 'All')
header_df <- bind_rows(header_df1,header_df2)

proj_summary_df <- proj_summary %>% group_by(project_status) %>% summarize(total_projects= sum(total_projects))
sunburstDF <- proj_summary %>% mutate(burst_key = paste(project_status,'-',str_replace_all(sector,'-',''),'-',program_type)) %>%  select(burst_key,total_projects)

### SunBurst Specific context ###

# create a d2b sunburst
#s2b <- sund2b(sunburstDF, colors = htmlwidgets::JS("d3.scaleOrdinal(d3.schemeCategory20b)"))
s2b <- sund2b(sunburstDF)
options(shiny.trace=FALSE)

## New York State County FIPS Data ##
soql_url <- 'https://data.ny.gov/resource/juva-r6g2.json?$select=distinct county,county_code,county_fips'
soql_url <- str_replace_all(soql_url, ' ','%20')
ny_county_data <- fromJSON(soql_url, simplifyVector = TRUE, flatten = TRUE)

##County Geo Map ##
soql_url <- 'https://data.ny.gov/resource/3x8r-34rs.json?$select=state,county,sum(totalnameplatekwdc) as installed_capacitykW,sum(case(project_status="Complete",1,true,0)) as completed_project_count,sum(case(project_status="Pipeline",1,true,0)) as pipeline_project_count,count(project_number) as project_count&$group=state,county'
soql_url <- str_replace_all(soql_url, ' ','%20')
proj_county_map <- fromJSON(soql_url, simplifyVector = TRUE, flatten = TRUE)

proj_county_map$installed_capacitykW <- round(as.numeric(proj_county_map$installed_capacitykW),0)
proj_county_map$completed_project_count <- round(as.numeric(proj_county_map$completed_project_count),0)
proj_county_map$pipeline_project_count <- round(as.numeric(proj_county_map$pipeline_project_count),0)
proj_county_map$project_count <- round(as.numeric(proj_county_map$project_count),0)

cats <- c("0-250kW","250-3,500kW","3,500-5,500kW","5,500-9,000kW","9,000-20,000kW","20,000-35,000kW","35,000-50,000kW","> 50,000kW")

proj_county_map$category <- cut(proj_county_map$installed_capacitykW, breaks = c(0,250,3500,5500,9000,20000,35000,50000,Inf), 
                                labels=c("0-250kW","250-3,500kW","3,500-5,500kW","5,500-9,000kW","9,000-20,000kW",
                                         "20,000-35,000kW","35,000-50,000kW","> 50,000kW"))

proj_county_map$category_count <- cut(proj_county_map$installed_capacitykW, breaks = c(0,250,3500,5500,9000,20000,35000,50000,Inf), 
                                      labels=FALSE)

### GeoJSON Data for New York
geo_url <- 'https://eric.clst.org/assets/wiki/uploads/Stuff/gz_2010_us_050_00_20m.json'
xy <- geojsonio::geojson_read(geo_url, what = "sp")

## State Code == 36 for New York
nys <- (xy[xy$STATE == 36, ])

proj_county_map <-  merge(nys, proj_county_map, by.x="NAME", by.y="county")


## Leaflet Map Prepare ##
factpal <- colorFactor(palette = "viridis", proj_county_map$category,reverse = TRUE)
labels <- sprintf(
  paste("<strong>County: %s</strong><br/>",
        "Total Installed Capacity: %gkW<br/>",
        "No. of Completed Projects: %g<br/>",
        "No. of Projects in Peipeline: %g<br/>",
        "Total No. of Projects: %g<br/>"),
  proj_county_map$NAME
  ,proj_county_map$installed_capacitykW
  ,proj_county_map$completed_project_count
  ,proj_county_map$pipeline_project_count
  ,proj_county_map$project_count
) %>% lapply(htmltools::HTML)


## Plotly Map Prepare ##
# ny_map <- map_data("county") %>%  filter(region == 'new york')
# proj_county_map$join_county <- tolower(proj_county_map$county)
# proj_county_map <- proj_county_map %>% inner_join(ny_map, by = c("join_county" = "subregion"))
# 
# proj_county_map$key <- row.names(proj_county_map)

##County Level Aggregate ##
soql_url <- 'https://data.ny.gov/resource/3x8r-34rs.json?$select=county,state,sector,sum(case(project_status="Complete",1,true,0)) as completed_project_count,sum(case(project_status="Pipeline",1,true,0)) as pipeline_project_count,count(project_number) as total_projects,sum(totalnameplatekwdc) as KWDC_capacity_rating,sum(expected_kwh_annual_production/1000) as expected_MWH_annual_production&$group=county,state,sector'
soql_url <- str_replace_all(soql_url, ' ','%20')
county_map <- fromJSON(soql_url, simplifyVector = TRUE, flatten = TRUE)
county_map$expected_MWH_annual_production <- round(as.numeric(county_map$expected_MWH_annual_production),2)

county_map <- county_map %>% inner_join(ny_county_data, by=c("county"="county")) %>% arrange(state, county)

## Plotly Map Prepare ##
ny_map <- map_data("county") %>% filter(region == 'new york')
county_map$county <- tolower(county_map$county)
county_map <- county_map %>% inner_join(ny_map, by = c("county" = "subregion"))

## Production Trend ##
soql_url <- 'https://data.ny.gov/resource/3x8r-34rs.json?$select=date_extract_y(date_install) as year_completed,state,sector,sum(totalnameplatekwdc/1000) as mwdc_capacity_rating,sum(expected_kwh_annual_production/1000000) as expected_gwh_annual_production,count(project_number) as total_projects,sum(project_cost) as Project_Cost&$where=project_status="Complete"&$group=date_extract_y(date_install),state,sector&$order=date_extract_y(date_install)'
soql_url <- str_replace_all(soql_url, ' ','%20')
production_trend <- fromJSON(soql_url, simplifyVector = TRUE, flatten = TRUE)


production_trend$mwdc_capacity_rating <- round(as.numeric(production_trend$mwdc_capacity_rating),0)
production_trend$expected_gwh_annual_production <- round(as.numeric(production_trend$expected_gwh_annual_production),0)
production_trend$total_projects <- round(as.numeric(production_trend$total_projects),0)
production_trend$Project_Cost <- round(as.numeric(production_trend$Project_Cost),0)


state_trend <- production_trend %>% filter(year_completed >= 2011) %>% group_by(state,year_completed) %>%
                summarize(mwdc_capacity_rating = sum(mwdc_capacity_rating),expected_gwh_annual_production = sum(expected_gwh_annual_production))
state_trend <- state_trend %>% group_by(state) %>% mutate(cum_mwdc_capacity_rating = cumsum(mwdc_capacity_rating),
                                                          cum_expected_gwh_annual_production = cumsum(expected_gwh_annual_production))

sector_trend <- production_trend %>% filter(year_completed >= 2011) %>% group_by(sector,year_completed) %>%
                summarize(mwdc_capacity_rating= sum(mwdc_capacity_rating),total_projects = sum(total_projects),
                          Project_Cost = sum(Project_Cost))%>% mutate(cost_per_watt = round(Project_Cost/(mwdc_capacity_rating*1000000),2))

## Layout Definition ##
header <- dashboardHeader(title = "NY Solar Projects Analysis",
              titleWidth = 230,
              dropdownMenu(type = "notifications",
                notificationItem(
                  text = textOutput('reportDate'),
                  icon("clock")
                )
              )
          )

sidebar <- dashboardSidebar(
            sidebarMenu(id = "sidebar",
              menuItem("Solar Dashboard", tabName = "dashboard", icon = icon("dashboard")),
              menuItem("Detail Data", tabName = "data", icon = icon("table")),
              menuItem("NYERDA Project Background", tabName = "overview", icon = icon("home"))#,
           #   menuItem("Widgets", tabName = "widgets", icon = icon("th"),badgeLabel = "new", badgeColor = "green")
            )#,
            # sidebarMenu(id = "sidebarMenu",
            #             menuItem("Graphs", tabName = "first_page", icon = icon("bar-chart-o")),
            #             menuItem("Tables", tabName = "second_page",icon = icon("th"))
            # ),
            # conditionalPanel("input.sidebarMenu == 'first_page'",
            #                  class = "shiny-input-container",
            #                  sliderInput("graph_slider", "Graphs slider:", min=1, max=10, value=2)
            # ),
            # conditionalPanel("input.sidebarMenu == 'second_page'",
            #                  class = "shiny-input-container",
            #                  sliderInput("table_slider", "Table slider:",  min=1, max=10, value=3)
            # )
          )

body <- dashboardBody(
          ### changing theme
          shinyDashboardThemes(
            theme = "blue_gradient"
            #theme = "grey_dark"
          ),
          tabItems(
            tabItem(tabName = "dashboard",
              fluidRow(
                # Dynamic valueBoxes
                valueBoxOutput("projects"),
                valueBoxOutput("capacity"),
                valueBoxOutput("exptd_production")
              ),
              fluidRow(
                leafletOutput("leafmap",height = 700, width = 1450),
              #  plotlyOutput(
              #    "plotMap", height = 900, width = 1500)#,
                verbatimTextOutput('mapclick')
              #  textOutput('mapclick')
              ),
              # fluidRow(sliderInput(inputId = "year",
              #                      label = "Year:",
              #                      value = 2011, min = 2011, max = 2019)
              # ),
              fluidRow(
                tabBox(title = "Installed Solar Power Capacity (Megawatts)", 
                       id = 'tabset1',#height = "100%", width = "400px",
                  tabPanel('Bar Chart','',
                           plotlyOutput("plot1")),
                  tabPanel('Line Chart','',
                           plotlyOutput("plot9"))
                    
                ),
                tabBox(title = "Status of Solar Projects", 
                       id = 'tabset2',#height = "100%", width = "400px",
                  tabPanel('Pie Chart','',
                           plotlyOutput("plot2")),
                  tabPanel('Sunburst Chart', '',
                      sunburstOutput("sunburst"),
                      textOutput("selection")
                  ),
                  tabPanel('Sunburst (Alt)', '',
                      sund2bOutput("s2b")
                  )
                )
              ),
              fluidRow(
                tabBox(title = "Expected Annual Solar Capacity (GWh)", 
                       id = 'tabset3',#height = "100%", width = "400px",
                  tabPanel('Bar Chart','',
                           plotlyOutput("plot3")),
                  tabPanel('Line Chart','',
                           plotlyOutput("plot10"))   
                ),
                tabBox(title = "Installed Solar Power Capacity (Megawatts) By Sector", 
                       id = 'tabset4',#height = "100%", width = "400px",
                  tabPanel('Bar Chart','',
                          plotlyOutput("plot4")),
                  tabPanel('Line Chart','',
                          plotlyOutput("plot11"))     
                )
              ),
              fluidRow(
                tabBox(title = "Completed Solar Installation by Sector", 
                       id = 'tabset5',#height = "100%", width = "400px",
                  tabPanel('Bar Chart','',
                          plotlyOutput("plot5")),
                  tabPanel('Line Chart','',
                          plotlyOutput("plot12"))     
                ),
                tabBox(title = "Local Cost of Solar ($/Watt) By Sector", 
                       id = 'tabset6',#height = "100%", width = "400px",
                  tabPanel('Bar Chart','',
                          plotlyOutput("plot6")),
                  tabPanel('Line Chart','',
                          plotlyOutput("plot13")) 
                ) 
              )
            ),
            tabItem(tabName = "data",
                    # Create a new Row in the UI for selectInputs
                    fluidRow(
                      column(3,
                             selectInput("county",
                                         h4("County:"),
                                         c("All",
                                           sort(unique(as.character(proj_details$county)))))
                      ),
                      column(3,
                             selectInput("city",
                                         h4("City:"),
                                         c("All",
                                           sort(unique(as.character(proj_details$city)))))
                      ),
                      column(3,
                             selectInput("sector",
                                         h4("Sector:"),
                                         c("All",
                                           sort(unique(as.character(proj_details$sector)))))
                      ),
                      column(3,
                             selectInput("status",
                                         h4("Project Status:"),
                                         c("All",
                                           sort(unique(as.character(proj_details$project_status)))))
                      )
                    ),
                    # Create a new row for the table.
                    DT::dataTableOutput("table")
            ),
            tabItem(tabName = "widgets",
              h2("Widgets tab content")
            ),
            tabItem(tabName = "overview",
              h2('Title:New York Solar Electric Program Study - Interactive Visualization'),  
              
              h3('Project Background'),
              
              p('On August 4, 2011, the Power New York Act of 2011 was signed into law, which directed New York State Energy Research and Development Authority (NYSERDA) to conduct a Study on Increasing Generation from Photovoltaic (PV) Devices in New York (the Solar Study). While the current contribution of solar electric (PV) energy generation is small and the cost of the technology is at a premium compared with market electricity prices, the Act sought analysis of the benefits and costs of PV, acknowledging that costs are declining and noting the potential for PV energy generation to contribute to economic development and job creation in the State.
              
              Specifically, the Act directed that the Solar Study should:'),
              
              tags$ul(
                
                tags$ol('- Identify administrative and policy options that could be used to achieve goals of 2,500 Megawatts (MW) of PV installations operating by 2020 and 5,000 MW operating by 2025 (the "Goals");'),
              
                tags$ol('- Estimate the per MW cost of achieving increased generation from PV devices and the costs of achieving the Goals using the options identified in the analysis;'),
              
                tags$ol('- Analyze the net economic and job creation benefits of achieving the Goals using each of the options identified in the analysis; and'),
              
                tags$ol('- Conduct an analysis of the environmental benefits of achieving the Goals using the options identified in the analysis.')
              
              ),
              h3('Objective'),
              
              p('The goal of the final project is to interactively analyze the available data to -'),

              tags$ul(
                
                tags$ol('- Plot NYSERDA reported data on NY state map capturing summarized gnerated metrics at county and/or city level from 2000 to September 2019'),
 
                tags$ol('- Create visualizations and analyze annual trends of Cumulative Vs. Annual growth for metrics like Total Capacity Generated, Number of Solar Projects Completed, Cost & Incentive per Watt, Expected Annual production etc.'),
 
                tags$ol('- Create summary visualization and comparatives between various sectors (Residential Vs. Commercial etc.) for metrics like Total Capacity (in MW), No. of projects etc. for projects already Completed and on Pipeline by county and/or city'),

                tags$ol('- Use Cross filtering and other techniques across different charts to create a more coherent user experience')
              
                ),

 
            h3('Data Source'),
            h4('Primary Source'),

            p('For this project I am going to use Solar Electric Programs data provided by New York State Energy Research and Development Authority (NYSREDA). The detailed description of the data set is hosted on the below DATA.NY.GOV site -'),
              
            tags$a(heref='https://data.ny.gov/Energy-Environment/Solar-Electric-Programs-Reported-by-NYSERDA-Beginn/3x8r-34rs', '[Data Site]'),
            
            p('Link to Data Dictionary:'),

            tags$a(href='https://data.ny.gov/api/views/3x8r-34rs/files/cf4cdff8-056b-4e09-a056-5fcce38756cd?download=true&filename=NYSERDA_SolarElectric_DataDictionary.pdf','[Data Dictionary]'), 

            p('This dataset includes information on solar photovoltaic (PV) installations supported by NYSERDA throughout New York State since 2000 by county, region, or statewide.')
            
            )
          )
        )
        
      


ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) { 
  
  # print list of input events
  # output$mapclick <-
  # renderPrint({reactiveValuesToList(input)})
  
    ## Last Data Refresh Time ##
  output$reportDate <- renderText({ paste('Last Data Refresh Date: ',substr(rptg_period$Repoerted_date,1,10))
    })

  
  #################### New York Map - Leaflet ###################################
  output$leafmap <- renderLeaflet({
    leaflet(proj_county_map) %>%
      addProviderTiles("OpenStreetMap.Mapnik") %>%
      addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.9,
                  fillColor = ~factpal(proj_county_map$category),
                  color = "white",
                  weight = "5",
                  dashArray = "3",
                  label = labels,
                  layerId = ~COUNTY,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "14px",
                    direction = "top"),
                  # Highlight neighbourhoods upon mouseover
                  highlight = highlightOptions(
                    weight = 5,
                    fillOpacity = 0.7,
                    color = "black",
                    opacity = 1.0,
                    bringToFront = TRUE
                  )) %>%
      addLegend(position = "topright", pal = factpal, values = proj_county_map$category, opacity = 1.0,
                title = "Installed Solar Capacity")
  
    })
  
  ### Declare Reactive Variable for County
  selectedCounty <- reactiveVal('All')
  
  ### Process Clicks/Mouseover events on the Map ######
  observeEvent(input$leafmap_shape_mouseover,{
  #  event <- input$leafmap_shape_click
    event <- input$leafmap_shape_mouseover
    if(is.null(event))
    {
        selectedCounty <- 'All'
    }
    else
    {
      selectedCounty <- renderPrint(proj_county_map$NAME[proj_county_map$COUNTY == event$id])
    }
    output$mapclick <- selectedCounty
    
  })
 ############### END of LEAFLET MAP #####################################
  
  #######################################################
  selectedData <- reactive({
   # dfSlice <- header_df %>%
    #  dplyr::filter(county == selectedCounty)
    header_df[header_df[,"county"] == selectedCounty, ]
  })
  ##########################################################
  
  ## Thumbnails Calculations ##
  ## 01. Total No. of Projects
  
  output$projects <- renderValueBox({
    valueBox(
      formatC(header_df2$total_projects, format="f", big.mark=",", digits=0), "Number of Projects", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "purple"
    )
  })
  
  ## 02. Total Installed Capacity
  output$capacity <- renderValueBox({
    valueBox(
      paste0(formatC(header_df2$mwdc_capacity_rating, format="f", big.mark=",", digits=0),"MW"), "Total Capacity(MW DC)", icon = icon("list"),
      color = "yellow"
    )
  })
  
  ## 03. Total Expected Production
  output$exptd_production <- renderValueBox({
    valueBox(
      paste0(formatC(header_df2$expected_gwh_annual_production, format="f", big.mark=",", digits=0),"GWh"), "Total Expected Production(GWh)",  icon("cog", lib = "glyphicon"),
      color = "aqua"
    )
  })
  
  ## Panel 1: Bar Chart ##
  output$plot1 <- renderPlotly({
    plot_ly(state_trend, x = ~year_completed, y = ~mwdc_capacity_rating, type='bar',
            name = 'Annual Installations', marker = list(color = 'rgb(255, 172, 84)'),
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", state_trend$year_completed,
                              "<br> Annual Installed Capacity :", paste0(state_trend$mwdc_capacity_rating,'MW'))
            ) %>%
            add_trace(y = ~cum_mwdc_capacity_rating, name = 'Cumulative Total', marker = list(color = 'rgb(42, 122, 189)'),
                      textposition = "auto",
                      hoverinfo = "text",
                      hovertext = paste("Year :", state_trend$year_completed,
                                        "<br> Cumulative Total Capacity :", 
                                        paste0(state_trend$cum_mwdc_capacity_rating,'MW'))
                      ) %>%
            layout(
              xaxis = list(title = ""),
              yaxis = list(title = ""),
              legend = list(orientation = 'h'),
              barmode = 'group', bargap = 0.15, bargroupgap = 0.1,
              markerOptions = list(riseOnHover = TRUE, riseOffset = 250)
            )
    })

  ## Panel 1: Line Chart ##
  output$plot9 <- renderPlotly({
    plot_ly(state_trend, x = ~year_completed, y = ~mwdc_capacity_rating, type = 'scatter', mode='lines+markers',
            name = 'Annual Installations', line = list(color = 'rgb(42, 122, 189)'),
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", state_trend$year_completed,
                              "<br> Annual Installed Capacity :", paste0(state_trend$mwdc_capacity_rating,'MW'))
    ) %>%
      add_trace(y = ~cum_mwdc_capacity_rating, name = 'Cumulative Total', line = list(color = 'rgb(255, 172, 84)'),
                textposition = "auto",
                hoverinfo = "text",
                hovertext = paste("Year :", state_trend$year_completed,
                                  "<br> Cumulative Total Capacity :", 
                                  paste0(state_trend$cum_mwdc_capacity_rating,'MW'))
      ) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        legend = list(orientation = 'h')
      )
  })  
  
  
  ## Panel2 Pie Chart ##
  output$plot2 <- renderPlotly({
  plot_ly(proj_summary_df, labels = ~project_status, values = ~total_projects, insidetextfont = list(color = '#FFFFFF'),
          marker = list(colors = c('#ffac54','#2a7abd')),
          textposition = "auto",
          hoverinfo = "text",
          hovertext = paste("Project status :",proj_summary_df$project_status,
                            "<br>No. Solar Projects :", proj_summary_df$total_projects)
          ) %>%
    add_pie(hole = 0.5, markerOptions = list(riseOnHover = TRUE, riseOffset = 250)) %>%
    animation_opts(frame = 500) %>%
    layout(
      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = TRUE),
      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = TRUE),
      legend = list(orientation = 'h'))
  })
  
  ## Panel3: Bar Chart ##
  output$plot3 <- renderPlotly({
    plot_ly(state_trend, x = ~year_completed, y = ~expected_gwh_annual_production, type='bar',
            name = 'Expected Annual Capacity', marker = list(color = 'rgb(255, 172, 84)'),
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", state_trend$year_completed,
                              "<br> Expected Annual Capacity :", paste0(state_trend$expected_gwh_annual_production,'GWh'))
    ) %>%
      add_trace(y = ~cum_expected_gwh_annual_production, name = 'Cumulative Expected Capacity', 
                marker = list(color = 'rgb(42, 122, 189)'),
                textposition = "auto",
                hoverinfo = "text",
                hovertext = paste("Year :", state_trend$year_completed,
                                  "<br> Cumulative Expected Capacity :", 
                                  paste0(state_trend$cum_expected_gwh_annual_production,'GWh'))) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        legend = list(orientation = 'h'),
        barmode = 'group', bargap = 0.15, bargroupgap = 0.1,
        markerOptions = list(riseOnHover = TRUE, riseOffset = 250)
      )
  })

  ## Panel3: Line Chart ##
  output$plot10 <- renderPlotly({
    plot_ly(state_trend, x = ~year_completed, y = ~expected_gwh_annual_production, type = 'scatter', mode='lines+markers',
            name = 'Expected Annual Capacity', line = list(color = 'rgb(42, 122, 189)'),
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", state_trend$year_completed,
                              "<br> Expected Annual Capacity :", paste0(state_trend$expected_gwh_annual_production,'GWh'))
    ) %>%
      add_trace(y = ~cum_expected_gwh_annual_production, name = 'Cumulative Expected Capacity', 
                line = list(color = 'rgb(255, 172, 84)'),
                textposition = "auto",
                hoverinfo = "text",
                hovertext = paste("Year :", state_trend$year_completed,
                                  "<br> Cumulative Expected Capacity :", 
                                  paste0(state_trend$cum_expected_gwh_annual_production,'GWh'))) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        legend = list(orientation = 'h')
      )
  })
  
  ## Panel4 : Bar Chart ##
  output$plot4 <- renderPlotly({
    plot_ly(sector_trend, x = ~year_completed, y = ~mwdc_capacity_rating, type='bar',
            color = ~sector, colors = c('#ffac54','#2a7abd'), 
            text = ~mwdc_capacity_rating,
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", sector_trend$year_completed,
                              "<br> Sector :", sector_trend$sector,
                              "<br> Installed Solar Capacity :", paste0(sector_trend$mwdc_capacity_rating,'MW'))) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "", hoverformat = '.2f'),
        legend = list(orientation = 'h'),
        barmode = 'group', bargap = 0.15, bargroupgap = 0.1
      )
  })
  
  ## Panel4 : Line Chart ##
  output$plot11 <- renderPlotly({
    plot_ly(data=sector_trend, x = ~year_completed, y = ~mwdc_capacity_rating, type = 'scatter', mode='lines+markers',
            color = ~sector, colors = c('#ffac54','#2a7abd'), 
            text = ~mwdc_capacity_rating,
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", sector_trend$year_completed,
                              "<br> Sector :", sector_trend$sector,
                              "<br> Installed Solar Capacity :", paste0(sector_trend$mwdc_capacity_rating,'MW'))) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "", hoverformat = '.2f'),
        legend = list(orientation = 'h')
      )
  })

  ## Panel5: Bar Chart ##
  output$plot5 <- renderPlotly({
    plot_ly(sector_trend, x = ~year_completed, y = ~total_projects, type='bar',
            color = ~sector, colors = c('#ffac54','#2a7abd'), 
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", sector_trend$year_completed,
                              "<br> Sector :", sector_trend$sector,
                              "<br> Installed Solar Projects :", sector_trend$total_projects)
            ) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        legend = list(orientation = 'h'),
        barmode = 'group', bargap = 0.15, bargroupgap = 0.1
      )
  })
  
  ## Panel5: Line Chart ##
  output$plot12 <- renderPlotly({
    plot_ly(sector_trend, x = ~year_completed, y = ~total_projects, type = 'scatter', mode='lines+markers',
            color = ~sector, colors = c('#ffac54','#2a7abd'), 
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", sector_trend$year_completed,
                              "<br> Sector :", sector_trend$sector,
                              "<br> Installed Solar Projects :", sector_trend$total_projects)
    ) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        legend = list(orientation = 'h')
      )
  })

  ## Panel6: Bar Chart ##
  output$plot6 <- renderPlotly({
    plot_ly(sector_trend, x = ~year_completed, y = ~cost_per_watt, type='bar',
            color = ~sector, colors = c('#ffac54','#2a7abd'),
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", sector_trend$year_completed,
                              "<br> Sector :", sector_trend$sector,
                              "<br> Installed Solar Projects :", paste0('$',sector_trend$cost_per_watt))
            ) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "", hoverformat = '$.2f'),
        legend = list(orientation = 'h'),
        barmode = 'group', bargap = 0.15, bargroupgap = 0.1
      )
  })
  
  ## Panel6: Line Chart ##
  output$plot13 <- renderPlotly({
    plot_ly(sector_trend, x = ~year_completed, y = ~cost_per_watt, type = 'scatter', mode='lines+markers',
            color = ~sector, colors = c('#ffac54','#2a7abd'),
            textposition = "auto",
            hoverinfo = "text",
            hovertext = paste("Year :", sector_trend$year_completed,
                              "<br> Sector :", sector_trend$sector,
                              "<br> Installed Solar Projects :", paste0('$',sector_trend$cost_per_watt))
    ) %>%
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "", hoverformat = '$.2f'),
        legend = list(orientation = 'h')
      )
  })  

  ### Sunburst Chart ##
  output$sunburst <- renderSunburst({
    #invalidateLater(1000, session)
    
    add_shiny(
      sunburst(
        sunburstDF,
        count = TRUE,
        legend = list(w = 250, h = 20, r = 20, s = 5),
        sumNodes = TRUE))
  })
  selection <- reactive({
    input$sunburst_mouseover
  })
  output$selection <- renderText(selection())
  
  ## Alternate SunBurst ##
  output$s2b <- renderSund2b({
    add_shiny(s2b)
  })  
    
  # Detail Data Tab: Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- proj_details
    if (input$county != "All") {
      data <- data[data$county == input$county,]
    }
    if (input$city != "All") {
      data <- data[data$city == input$city,]
    }
    if (input$sector != "All") {
      data <- data[data$sector == input$sector,]
    }
    if (input$status != "All") {
      data <- data[data$project_status == input$status,]
    }
    data
  }))
  

}

shinyApp(ui, server)
