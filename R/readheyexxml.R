#########################################################
###############  run through readheyexxml function
#########################################################

readheyexxml <- function(folder){


  # install and load raster
  if (!require("xml2")){
    install.packages("xml2")
    library(xml2)
    suppressPackageStartupMessages({library(xml2)})
  }
  # install and load raster
  if (!require("tidyverse")){
    install.packages("tidyverse")
    library(tidyverse)
    suppressPackageStartupMessages({library(tidyverse)})
  }
  # install and load raster
  if (!require("EBImage")){
    if (!requireNamespace("BiocManager", quietly = TRUE))
      install.packages("BiocManager")
    BiocManager::install("EBImage")
    library(EBImage)
    suppressPackageStartupMessages({library(EBImage)})
  }



  file <- list.files(folder, pattern = "\\.xml$")
  xml <- read_xml(file)

  ### get attributes from xml file
  ID = xml_find_all(xml, ".//Image/ID") %>% xml_text( "ID" )
  ExamURL = xml_find_all(xml, ".//Image/ImageData/ExamURL" ) %>%  xml_text( "ExamURL" )
  start_x_coord = xml_find_all(xml, ".//Start/Coord/X" ) %>% xml_text("x_start")
  end_x_coord = xml_find_all(xml, ".//End/Coord/X" ) %>% xml_text("x_end")
  y_coord = xml_find_all(xml, ".//Start/Coord/Y" ) %>% xml_text("y_start")
  width = xml_find_all(xml, ".//OphthalmicAcquisitionContext/Width") %>% xml_text( "width" )
  height = xml_find_all(xml, ".//OphthalmicAcquisitionContext/Height") %>% xml_text( "height" )
  scale_x = xml_find_all(xml, ".//OphthalmicAcquisitionContext/ScaleX") %>% xml_text( "scalex" )
  scale_allimages_y = xml_find_all(xml, ".//OphthalmicAcquisitionContext/ScaleY") %>% xml_text( "scaley" )

  ## identify the 0th image - this is the enface image and
  ## non-changing scale attributes
  ExamURL_enface <- basename(ExamURL[c(1)])
  scalex_enface <- as.numeric(scale_x[c(1)])
  scaley_enface <- as.numeric(scale_allimages_y[c(1)])

  # remove from lists first ID and ExamURL (enface image)
  ID <- ID[-c(1)]
  ExamURL <- ExamURL[-c(1)]

  no_bscans <- as.numeric(length(y_coord))
  start_x_coord <- as.numeric(start_x_coord[c(1)])
  end_x_coord <- as.numeric(end_x_coord[c(1)])
  start_y_coord <- as.numeric(y_coord[1])
  end_y_coord <- as.numeric(y_coord[length(y_coord)])
  res_x <- as.numeric(width[c(2)])
  scale_x <- as.numeric(scale_x[c(2)])

  ### each b-scan in micrometers is for the middle of each voxel,hence
  scale_lat_y <- ((start_y_coord)-(end_y_coord))/(no_bscans-1)

  ### coordinates are taken as middle of voxel so find true
  ### start x (call it plot_start_x) rather than middle of voxel
  plot_start_x <- start_x_coord-(0.5*scale_x)
  plot_end_x   <- start_x_coord +(res_x*scale_x)
  plot_start_y <- start_y_coord+(0.5*scale_lat_y)
  plot_end_y   <- end_y_coord-(0.5*scale_lat_y)

  if (plot_start_x < 0){plot_start_x <- 0}

  ### find bounding box on enface img  containing all b-scans in preparation
  ### for cropping enface image or marking with abline
  v1 <- round(plot_start_x/scalex_enface)
  v2 <- round(plot_end_x/scalex_enface)
  h1 <- round(plot_end_y/scaley_enface)
  h2 <- round(plot_start_y/scaley_enface)


  ### create a dataframe of chosen attributes
  df <- data.frame(ID,scale_x,scale_lat_y,y_coord,ExamURL,
                   stringsAsFactors = FALSE)


  ###############################################################
  ##################### Display Images ##########################
  ###############################################################

  ### Display enface image
  enface_img <- EBImage::readImage(ExamURL_enface)
  #EBImage::display(enface_img)

  ### crop enface image
  plot(enface_img)
  abline(h = h1, v = v1, col= "ivory")
  abline(h = h2, v = v2, col= "ivory")
  enface_img_crop = enface_img[v1:v2, h1:h2, 1:3]
  enface_cropped_img <- EBImage::display(enface_img_crop)

  ### isolate bscan filenames and display
  df$ExamURL <- basename(df$ExamURL)
  bscans <- EBImage::readImage(df$ExamURL)
  bscan_imgs <- EBImage::display(bscans)


  return(list(data=df, enface_cropped_img=enface_cropped_img, bscan_imgs=bscan_imgs))

}







