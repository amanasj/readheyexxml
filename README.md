# readheyexxml


Package to open and process OCT images exported from heidelberg spectralis in xml format. 


This package reads the xml file and extracts image attributes including bscan position.  A dataframe is output with ordered bscan attributes along with two image files


1) cropped en-face image representing the region of retina that was scanned


2) series of ordered bscans which can be viewed (starts from bottom and goes upwards along en-face image)


<br><br>

<hr>

library(devtools)

install_github("amanasj/readheyexxml")

library(readheyexxml)


<br>

data <- readheyexxml(images_path)

<br>

data[1]    # shows the raw data
<br>
data[2]    # displays the cropped en-face image
<br>
data[3]    # displays all the b-scans which you can cycle through
<br>
data[4]    # displays the original (un-cropped) en-face image

<br><br>







<br><br>

<hr>


