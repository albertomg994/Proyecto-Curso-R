library(shiny)
library(leaflet)
library(sp)
library(rgdal)
library(readr)

shinyUI(fluidPage(
	# Creamos un panel de título
	titlePanel("Title Panel"),

	# Creamos un panel lateral (siempre recibe estos dos argumentos)
	sidebarLayout(
		# Que contiente a su vez otros dos paneles
		sidebarPanel(
		    h3("Coordenadas:"),
		    numericInput("latitud", label = p("Latitud"), value = 1),
		    numericInput("longitud", label = p("Longitud"), value = 1)
	  	),

		# Panel principal
		mainPanel("main panel izq.",
			h1("Titulo 2"),
			leafletOutput("myMap")
		)
	)
))