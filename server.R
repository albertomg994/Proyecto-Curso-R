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
    if(datos$GRATUITO[i] == TRUE) {
      map <- addMarkers(map, lng=datos$longitude[i], lat=datos$latitude[i], popup=datos$NOMBRE[i], group = "free_markers")
    } else {
      map <- addMarkers(map, lng=datos$longitude[i], lat=datos$latitude[i], popup=datos$NOMBRE[i], group = "pay_markers")
    }
  }
  
  # RenderizaR el mapa
  #output$myMap <- renderLeaflet({
    #map <- addMarkers(map, lng=input$longitud, lat=input$latitud, popup="The birthplace of R")
  #  map
  #})
  ############################
  output$myMap <- renderLeaflet({
    
    # Cargar los marcadores en función de las opciones
    if(input$rb_gratis == "free") {
      print("Estas en free")
      map <- showGroup(map, "free_markers")
      map <- hideGroup(map, "pay_markers")
    } 
    else if(input$rb_gratis == "pay") {
      print("Estas en pay")
      map <- showGroup(map, "pay_markers")
      map <- hideGroup(map, "free_markers")
    } 
    else if(input$rb_gratis == "none") {
      print("Estas en none")
      map <- hideGroup(map, "pay_markers")
      map <- hideGroup(map, "free_markers")
    } 
    else { #all
      print("Estas en all")
      map <- showGroup(map, "pay_markers")
      map <- showGroup(map, "free_markers")
    }

    #print("Markers ahora vale:")
    #print(head(markers))
    #print("....")
    #print(tail(markers))
    
    # Borramos los marcadores antiguos
    #map <- removeMarker(map, 1)

    # Renderizar
    #for (i in 1:nrow(markers)) {
    #  map <- addMarkers(map, lng=markers$longitude[i], lat=markers$latitude[i], popup=markers$NOMBRE[i], layerId = 1)
    #}
    map
  })
  ############################
  
  # Más operaciones sobre el mapa
  mostrarHoy <- function () {
    date <- "2015-01-03"
    datos.hoy <- subset(datos, subset = (datos$FECHA == date))
  }
  mostrarGratis <- function () {
    datos.gratis <- subset(datos, subset = (datos$GRATUITO == 1))
  }
  
  
  # TABLA DE DATOS
  # ==========================================================================================
  # Renderizar la tabla a través del data.frame
  output$tabla <- DT::renderDataTable(DT::datatable({
    data <- datos
    data <- subset(datos, select = c(NOMBRE, GRATUITO, FECHA, HORA, NOMBRE.INSTALACION, DISTRITO))
    
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