
## Loading libraries
library(openalexR) # OpenAlex Database API interface
library(biblioverlap) # For document coverage analysis
library(dplyr) # For data manipulation
library(purrr) # For data manipulation
library(lubridate) # For datetime manipulation


#Set your email for faster response times - more info at https://docs.openalex.org/how-to-use-the-api/rate-limits-and-authentication#the-polite-pool)
#options(openalexR.mailto = "") #Add your email here

#Function to get records from openalex API
#get_openalex_records <- function(keyword = 'Open Access',
#                                 pubyear = seq(2000, as.numeric( format(Sys.time(), "%Y") ) ),
#                                 type_crossref = 'journal-article') {
#  records <- oa_fetch(
#    entity = 'works',
#    type_crossref = type_crossref,
#    publication_year = pubyear,
#    #default.search = keyword,
#    title.search = keyword,
#    abstract = FALSE,
#    options = list(select = c('doi', 'publication_year', 'cited_by_count', 'open_access', 'language')),
#    verbose = TRUE 
#    ) %>%
#    rename(DI = doi, PY = publication_year, TC = cited_by_count,
#           OA = oa_status, LA = language) %>% #Renames fields
#    select(DI, PY, TC, OA, LA) #Selects fields
#}
#
#data <- get_openalex_records()
#saveRDS(data, 'oa_dashboard/data.rds')

server <- function(input, output, session) {
  
  data <- readRDS('data.rds')
  
  output$plot <- renderPlot({
    filtered_data <- data %>%
      filter(PY %in% seq(input$year_range[1], input$year_range[2]))
    
    if (input$xcol == 'TC') {
      filtered_data %>%
        group_by(PY) %>%
        summarise(count = sum(TC)) %>%
        ggplot(aes(x = PY, y = count, label = count)) +
        geom_col(color = 'black', fill = 'lightblue') +
        labs(y = "COUNT") +
        geom_text(position = position_dodge(width = .9), vjust = -0.3) + 
        theme(axis.text = element_text(size = 12))
    } else {
    filtered_data %>%
        group_by(!!sym(input$xcol)) %>%
        summarise(count = ifelse(input$xcol == 'TC', sum(!!sym(input$xcol)), n()) ) %>%
        ggplot(aes(x = !!sym(input$xcol), y = count, label = count)) +
        geom_col(color = 'black', fill = 'lightblue') +
        labs(y = "COUNT") + 
        geom_text(position = position_dodge(width = .9), vjust = -0.3) + 
        theme(axis.text = element_text(size = 12))
    }
  })
}