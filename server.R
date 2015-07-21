library(shiny)
library(leaflet)
library(XML)
library(sp)
library(rgdal)
library(readr)

shinyServer(function(input, output) {
  
  # Dataframe de ejemplo 1
  # ---------------------------------------------
  df_example1 <- data.frame(location = c("White House", "Impound Lot", "Bush Garden", "Rayburn", "Robertson House", "Beers Elementary"), latitude = c(38.89710, 38.81289, 38.94178, 38.8867787, 38.9053894, 38.86466), longitude = c(-77.036545, -77.0171983, -77.073311, -77.0105317, -77.0616441, -76.95554))
  
  # Dataframe de ejemplo 2
  # ---------------------------------------------
  location <- c("Evento1", "Evento2", "Evento3", "Evento4")
  #date <- as.Date(c("2015-7-21", "2015-7-22", "2015-7-23", "2015-7-24"))
  latitude = c(40.39227092120195, 40.39241367848808, 40.49082275610172, 40.42834456035844)
  longitude = c(-3.684968648157021, -3.697259467865366, -3.7216054330053647, -3.728941931668392)
  df_example2 <- data.frame(location, latitude, longitude)
  
  # Dataframe de ejemplo 3
  # ---------------------------------------------
  #df_example3 <- xmlToDataFrame("data/datos.xml")
  #df_example4 <- read_csv("data/datos.csv")
  #df_example5 <- read.csv(file="data/datos.csv", header=TRUE, sep=";", colClasses = c("NULL", "character", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "numeric", "numeric", "NULL", "NULL"))
  df_example5 <- read.csv(file="data/datos1.csv", header=TRUE, sep=";")
  
  # Construir el mapa
  # ---------------------------------------------
  map <- leaflet()
  map <- addTiles(map)
  #map %>% setView(40.89710, -3.63655, 1)
  
  # Asociamos que df cargamos
  # ---------------------------------------------
  df_example <- df_example5
  n_elems <- nrow(df_example5)
  
  # Poblar el mapa
  # ---------------------------------------------
  for (i in 1:n_elems) {
    map <- addMarkers(map, lng=df_example$longitude[i], lat=df_example$latitude[i], popup=df_example$NOMBRE[i])
  }
  
  # Renderizamos el mapa
  # ---------------------------------------------
  output$myMap <- renderLeaflet({
    #map <- addMarkers(map, lng=input$longitud, lat=input$latitud, popup="The birthplace of R")
    map
  })
  
}
)