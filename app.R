# PTR Library
#
# A Library of Proton-Transfer Reactions of H3O+ Ions Used for Trace Gas Detection
# D. Pagonis, K. Sekimoto, J. de Gouw
# J. Am. Soc. Mass Spectrom (2019), 30, 7, 1330-1335
# https://pubs.acs.org/doi/10.1007/s13361-019-02209-3

library(shiny)
library("googlesheets4")

## ## Google authorization not requested
## gs4_deauth()

## ## import the PTR library
## gs.df <- read_sheet("108MzOYtjequJHZ2N_fth1yFM7XnlGzOlQ7tPkvK5FHQ", sheet="H3O+ Reactions", skip=2)
## save(gs.df, file="data.Rda")

load("data.Rda")

gs.species <- unique(gs.df["Compound Name"])

## =====================================================================
## User Interface ----
ui <- fluidPage(
  titlePanel("PTR Library"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Compound",
                  label = "Choose a compound",
                  choices = gs.species,
                  selected = "propyne")
    ),
    mainPanel(
      tableOutput("Data")
    )
  )
)

## =====================================================================
## Server Logic ----
server <- function(input, output) {

  nrows <- reactive({
    which(gs.df["Compound Name"] == input$Compound)
  })

  output$Data <- renderTable({
    gs1 <- gs.df[nrows(), c(1:4,26:28,30:31)]
    return(gs1)
  }, display=c("f","s","s","s","e","f","f","e","e","s"))

}

## =====================================================================
## Run app ----
shinyApp(ui = ui, server = server)
