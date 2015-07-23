# Alberto Miedes Garcés - 23 - 07 - 2015

library(shiny)
library(leaflet)
library(sp)
library(rgdal)
library(readr)

shinyUI(
  navbarPage("¡Madrid!",
    # Tab 1
    tabPanel("Mapa",
      sidebarLayout(
        sidebarPanel(
          # radioButtons("rb_gratis", "rb_gratis", c("Pago" = "pay", "Gratuitos" = "free", "Todos" = "all", "Ninguno" = "none")),
          radioButtons("rb_distrito", "Filtrar por distrito:", c(
            "Todos" = "all",
            "Arganzuela" = "arg",
            "Carabancher" = "car",
            "Centro" = "cen",
            "Chamartin" = "cha",
            "Chamberi" = "chb",
            "Ciudad Lineal" = "ciu",
            "Fuencarral - El Pardo" = "fue",
            "Latina" = "lat",
            "Moncloa - Aravaca" = "mon",
            "Moratalaz" = "mor", 
            "Puente de Vallecas" = "pue", 
            "Retiro" = "ret", 
            "Salamanca" = "sal", 
            "San Blas - Canillejas" ="san",
            "Tetuan" = "tet",
            "Usera" = "use", 
            "Villaverde" = "vill")
          )
        ),
        
        mainPanel(
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