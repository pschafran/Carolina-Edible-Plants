#!/usr/bin/env Rscript

# Set study area limits and raster resolution. Use 0 for all limits to ignore study area (it will use that area covered by all coordinates)
minXlim <- 0  # Longitude in decimal degrees
maxXlim <- 0 # Longitude in decimal degrees
minYlim <- 0 # Latitude in decimal degrees
maxYlim <- 0 # Latitude in decimal degrees
rasterResolution <- "30s" # Must be 10m, 5m, 2.5m, or 30s
path30s <- "GIS/WorldClim/wc2.1_30s_bio/"
path2.5m <- "GIS/WorldClim/wc2.1_2.5m_bio/"
path5m <- "GIS/WorldClim/wc2.1_5m_bio/"
path10m <- "GIS/WorldClim/wc2.1_10m_bio/"
setwd("~/Documents/Website/MaxEntMachine")
modelStudyAreaOnly <- "no" # Must be yes/no. Determines whether to use predictor layers and coordinates outside the study area to model the species distribution
                              # or only the area inside the study area
mapStudyAreaOnly <- "no" # Must be yes/no. Determines whether to map only study area defined above or entire area containing sample coordinates
cexAdj <- 0.75 # Multiplier to adjust size of city points and labels
futureModel <- "no" # Select whether to model future climate model or present day

#Shouldn't need to change anything below this line
################################################################################################################################
{
  Sys.setenv(NOAWT=TRUE)
  suppressMessages(library(rgeos))
  suppressMessages(library(raster))
  library(sp)
  library(maps)
  suppressMessages(library(sf))
  source("maxentHelper.R")
}

 {##### Run prep

  # Parse scientific names passed from terminal
  sciName = commandArgs(trailingOnly=TRUE)
  if (length(sciName) == 2) {
    sciName = paste(sciName[1], sciName[2], sep = " ")
  } else if (length(sciName) == 3){
    sciName = paste(sciName[1], sciName[2], sciName[3], sep = " ")
  } else if (length(sciName) == 4){
    sciName = paste(sciName[1], sciName[2], sciName[3], sciName[4], sep = " ")
  }
  print("**********************START***********************")
  print(sciName)

  # Prepare predictor rasters
  if (rasterResolution == "30s"){
    path <- file.path(path30s)
  }
  else if (rasterResolution == "2.5m") {
    path <- file.path(path2.5m)
  }
  else if (rasterResolution == "5m") {
    path <- file.path(path5m)
  }
  else {
    path <- file.path(path10m)
  }
  bioclimFiles <- list.files(path, pattern = 'tif$', full.names = TRUE)
  bioclimPredictors <- stack(bioclimFiles)

  # Prepare state boundaries
  print("Preparing country boundaries...")
  usaHD <- getData(name="GADM", download = TRUE, level = 1, country = "USA")
  us.states.simple <- gSimplify(usaHD, tol = 0.01, topologyPreserve = TRUE)
  canadaHD <- getData(name="GADM", download = TRUE, level = 1, country = "CAN")
  canada.provinces.simple <- gSimplify(canadaHD, tol = 0.01, topologyPreserve = TRUE)
  mexicoHD <- getData(name="GADM", download = TRUE, level = 1, country = "MEX")
  mexico.states.simple <- gSimplify(mexicoHD, tol = 0.01, topologyPreserve = TRUE)
  greatLakes <- st_read("./Great_Lakes/Great_Lakes.shp")

  # Prepare world cities
  data("world.cities")
  world.cities.large <- world.cities[which(world.cities$pop > 500000),]
  world.cities.large.labels <- world.cities.large$name
  world.cities.large.coords <- SpatialPoints(world.cities.large[5:4], proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
  NorthAm.cities.large <- world.cities.large[which(world.cities.large$country.etc == "USA" | world.cities.large$country.etc == "Canada" | world.cities.large$country.etc == "Mexico"),]
  NorthAm.cities.large.labels <- NorthAm.cities.large$name
  NorthAm.cities.large.coords <- SpatialPoints(NorthAm.cities.large[5:4], proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))



par(mfrow = c(1,1))

tryCatch({
  pdf(file = paste(sciName, "_", rasterResolution, ".pdf", sep = ""), width = 8.97, height = 6.7)
  print(maxent_map(sciName, minXlim, maxXlim, minYlim, maxYlim, modelStudyAreaOnly, mapStudyAreaOnly, futureModel))
  plot(us.states.simple, add = TRUE)
  plot(mexico.states.simple, add = TRUE)
  plot(canada.provinces.simple, add = TRUE)
  plot(greatLakes, add = TRUE, col = "white")
  points(world.cities.large.coords, pch = 20, cex = cexAdj)
  text(world.cities.large.coords, labels = world.cities.large.labels, halo = TRUE, hw = 0.2*cexAdj, hc = "white", pos = 1, cex = 0.75*cexAdj)

  }, error=function(e){cat("ERROR: ", conditionMessage(e), "\n")})
dev.off()
}

print(sciName)
print("**********************END***********************")
rm(list = ls())
quit()
