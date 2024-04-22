current_year <- as.numeric(format(Sys.time(), "%Y"))

ui <- pageWithSidebar(
  headerPanel('Open Access Monitor'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', 
                choices = c('Publication Year' = 'PY',
                            'Open Access Status' = 'OA',
                            'Language' = 'LA',
                            'Total citations' = 'TC')
                ),
    sliderInput('year_range', 'Filter by Year',
                min = 2000,
                max = current_year,
                value = c(2000, current_year),
                sep = ''
                ),
  ),
  mainPanel(
    plotOutput('plot')
  )
)