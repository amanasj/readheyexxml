# readheyexxml


Package to open and process OCT images exported from heidelberg spectralis in xml format. 


This package reads the xml file and extracts image attributes including bscan position.  A dataframe is output with ordered bscan attributes along with two image files


1) cropped en-face image representing the region of retina that was scanned


2) series of ordered bscans which can be viewed (starts from bottom and goes upwards along en-face image)


<br>


library(devtools)

install_github("amanasj/readheyexxml")

library(readheyexxml)




