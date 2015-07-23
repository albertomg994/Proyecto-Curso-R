library(shiny)
library(leaflet)
library(sp)
library(rgdal)
library(readr)

shinyUI(
  navbarPage("Nobre de la barra",
    # Tab 1
    tabPanel("Mapa",
      sidebarLayout(
        sidebarPanel(
          #radioButtons("plotType", "Plot type", c("Scatter"="p", "Line"="l"))
          radioButtons("rb_gratis", "rb_gratis", c("Pago" = "pay", "Gratuitos" = "free", "Todos" = "all", "Ninguno" = "none"))
        ),
        
        mainPanel(
          h2("Mapa con las ubicaciones"),
          leafletOutput("myMap")
        )
      )
      # ./sidebarLayout
    ),
    # ./ tabPanel
    
    # Tab 2
    tabPanel("Tabla de datos",
      # Row para filtros
      fluidRow(
        column(5, offset = 1,
          selectInput("distrito", "Distrito:", c("All", unique(as.character(datos$DISTRITO))))
        ),
        column(5,
         	selectInput("instalacion", "Nombre instalaciones:", c("All", unique(as.character(datos$NOMBRE.INSTALACION))))
        )
      ),

      # La tabla en si
      fluidRow(
         column(10, offset = 1,
         	  DT::dataTableOutput("tabla")
         )
      )
    ),
    # ./ tabPanel
  
    # Tab 3
    tabPanel("Estadisticas",
     fluidRow(
       column(5, offset = 1,
          plotOutput('plotDistritos')
       ),
       column(5,
          plotOutput('plotHoras')
       )
     )
    )
    # ./ tabPanel
  )
  # ./navbarPage()
)
# ./shinyUI()