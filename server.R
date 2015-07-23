# Alberto Miedes Garcés - 23 - 07 - 2015

library(shiny)
library(leaflet)
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
        main="Actividades por distritos",
        ylab="Nº actividades",
        xlab="Distrito")
  })
  
  # Gratuidad o no
  #gratuidad <- datos$GRATUITO # Esto va regular
  #rsm_gratuidad <- summary(gratuidad)
  
  # Fechas
  #fechas <- datos$FECHA
  #rsm_fechas <- summary(fechas)
  
  # Horas
  horas <- datos$HORA
  rsm_horas <- summary(horas)
  output$plotHoras <- renderPlot({
    barplot(rsm_horas, 
            main="Actividades por horas",
            ylab="Nº actividades",
            xlab="Hora")
  })
  
  # MAPA
  # ==========================================================================================
  # Construir el mapa
  map <- leaflet()
  map <- addTiles(map)
  
  # Poblar el mapa (DESHABILITADO DE MOMENTO)
#   for (i in 1:nrow(datos)) {
#     if(datos$GRATUITO[i] == TRUE) {
#       map <- addMarkers(map, lng=datos$longitude[i], lat=datos$latitude[i], popup=datos$NOMBRE[i], group = "free_markers")
#     } else {
#       map <- addMarkers(map, lng=datos$longitude[i], lat=datos$latitude[i], popup=datos$NOMBRE[i], group = "pay_markers")
#     }
#   }
  
  # Poblamos el mapa con los marcadores, a la vez que asignamos el grupo
  distritos <- c("ARGANZUELA", "CARABANCHEL", "CENTRO", "CHAMARTIN", "CHAMBERI", "CIUDAD LINEAL", "FUENCARRAL-EL PARDO", "LATINA", "MONCLOA-ARAVACA", "MORATALAZ", "PUENTE DE VALLECAS", "RETIRO", "SALAMANCA", "SAN BLAS-CANILLEJAS" ,"TETUAN" ,"USERA", "VILLAVERDE")
  distritos_abr <- c("arg", "car", "cen", "cha", "chb", "ciu", "fue", "lat", "mon", "mor", "pue", "ret", "sal", "san", "tet", "use", "vill")
  for (i in 1:nrow(datos)) {
    group_name <- datos$DISTRITO[i]
    map <- addMarkers(map, lng=datos$longitude[i], lat=datos$latitude[i], popup=datos$NOMBRE[i], group = group_name)
  }
  
  # Renderizado del mapa (se ejecutará cada vez que hay un cambio en la GUI)
  output$myMap <- renderLeaflet({
    
    # Cargar los marcadores en función de las opciones de precio (DESHABILITADO DE MOMENTO)
#     if(input$rb_gratis == "free") {
#       map <- showGroup(map, "free_markers")
#       map <- hideGroup(map, "pay_markers")
#     } else if(input$rb_gratis == "pay") {
#       map <- showGroup(map, "pay_markers")
#       map <- hideGroup(map, "free_markers")
#     } else if(input$rb_gratis == "none") {
#       map <- hideGroup(map, "pay_markers")
#       map <- hideGroup(map, "free_markers")
#     } else { #all
#       map <- showGroup(map, "pay_markers")
#       map <- showGroup(map, "free_markers")
#     }

    # Cargar los marcadores en función de las opciones de distrito
    dist_sel <- input$rb_distrito
    if (dist_sel == "all") {
      for (i in 1:length(distritos)) {
        map <- showGroup(map, distritos[i])
      }
    } else {
      for (i in 1:length(distritos)) {
        # Si es el distrito seleccionado lo mostramos
        if(distritos_abr[i] == dist_sel) {
          map <- showGroup(map, distritos[i])
        } else { # e.o.c. lo ocultamos
          map <- hideGroup(map, distritos[i])
        }
      }
    }

    # Mostrar el mapa
    map
  })
  
  # TABLA DE DATOS
  # ==========================================================================================
  # Renderizar la tabla a través del data.frame
  output$tabla <- DT::renderDataTable(DT::datatable({
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