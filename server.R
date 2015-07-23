library(shiny)
library(leaflet)
library(XML)
library(sp)
library(rgdal)
library(readr)

shinyServer(function(input, output) {
  
  
  # Lectura de los datos
  datos <- read.csv(file="data/datos1.csv", header=TRUE, sep=";")
  
  
  # GRÁFICAS SOBRE LOS DATOS
  # ==========================================================================================
  # Reparto por distritos
  distritos <- datos$DISTRITO
  rsm_distritos <- summary(distritos)
  output$plotDistritos <- renderPlot({
    barplot(rsm_distritos, 
        main="Distribución por distritos",
        ylab="Nº actividades",
        xlab="Distrito")
  })
  
  # Gratuidad o no
  gratuidad <- datos$GRATUITO # Esto va regular
  rsm_gratuidad <- summary(gratuidad)
  
  # Fechas
  fechas <- datos$FECHA
  rsm_fechas <- summary(fechas)
  
  # Horas
  horas <- datos$HORA
  rsm_horas <- summary(horas)
  output$plotHoras <- renderPlot({
    barplot(rsm_horas, 
            main="Distribución por horas",
            ylab="Nº actividades",
            xlab="Hora")
  })
  
  # MAPA
  # ==========================================================================================
  # Construir el mapa
  map <- leaflet()
  map <- addTiles(map)
  #map %>% setView(40.89710, -3.63655, 1)
  
  # Poblar el mapa
  for (i in 1:nrow(datos)) {
    map <- addMarkers(map, lng=datos$longitude[i], lat=datos$latitude[i], popup=datos$NOMBRE[i])
  }
  
  # RenderizaR el mapa
  output$myMap <- renderLeaflet({
    #map <- addMarkers(map, lng=input$longitud, lat=input$latitud, popup="The birthplace of R")
    map
  })
  
  # TABLA DE DATOS
  # ==========================================================================================
  # Renderizar la tabla a través del data.frame
  output$tabla <- DT::renderDataTable(DT::datatable({
    data <- datos
    data <- subset(datos, select = c(NOMBRE, GRATUITO, FECHA, HORA, NOMBRE.INSTALACION))
    
    if (input$distrito != "All") {
      data <- data[data$DISTRITO == input$distrito,]
    }
    if (input$instalacion != "All") {
      data <- data[data$NOMBRE.INSTALACION == input$instalacion,]
    }
    data
  }))
}
)