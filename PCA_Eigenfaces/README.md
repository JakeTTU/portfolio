# PCA Eigenfaces

## Overview:

This R program uses a Pinciple Component Analysis (PCA) dimensionality reduction technique to reduce the dimensionality of face images to construct eigenfaces which are then used for facial recognition.

### Eigenfaces:

Eigenfaces is the term used to describe the output of face images after Principle Component Analysis (PCA) dimensionality reduction technique is used on a dataset of face images. The output are the dimensions with the greatest data variance which can then be used for comparison in facial recognition. The original images have their dimensionality reduced to only include the most important features that can be used to differentiate the face in the image with the others in the dataset. 

### To Run:

Requirements 
 * R - https://cloud.r-project.org 
 * RStudio - https://rstudio.com/products/rstudio/download/

Package dependencies include: 
  * RSpectra - https://cran.r-project.org/web/packages/RSpectra/index.html
  * Shiny - https://cran.r-project.org/web/packages/shiny/index.html
  * Shinydashboard - https://cran.r-project.org/web/packages/shinydashboard/index.html
  
To Run:
 1. Download the repo to the Desktop
 2. Run script.R in RStudio
 3. Run dashboard.R in RStudio
