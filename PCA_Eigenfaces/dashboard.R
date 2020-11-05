## app.R ##
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Eigenface Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Images", tabName = "dashboard", icon = icon("th")),
      menuItem("Average Faces", tabName = "widgets3", icon = icon("th")),
      menuItem("Eigenvector Results", tabName = "widgets4", icon = icon("th")),
      menuItem("Image & Eigenfaces", tabName = "widgets", icon = icon("th")),
      menuItem("Facial Recognition", tabName = "widgets2", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              h2("Images"),
              fluidRow(
                box(
                  title = "Image", solidHeader = TRUE,
                  plotOutput("plot1", height = 256, width = 256),
                  sliderInput("slider", "Slider input:", 1, 400, 1)
                ),
                box(
                  title = "Average Face for Dataset", solidHeader = TRUE,
                  plotOutput("plot3", height = 256, width = 256)
                ),
              )
              
      ),
      
      # Second tab content
      tabItem(tabName = "widgets",
              h2("Image & Eigenfaces"),
              fluidRow(
                box(
                  title = "This page shows a selected image, the average 
                  image, the image with eigenvector projection, and the image
                  with eigenvector projection and average image.",
                  sliderInput("slider1", "Slider input:", 1, 400, 1)
                ),
                box(
                  title = "Face Image", solidHeader = TRUE,
                  plotOutput("plot2", height = 256, width = 256),
                ),
                box(
                  title = "Face with Eigen Projection", solidHeader = TRUE,
                  plotOutput("plot4", height = 256, width = 256)
                ),
                box(
                  title = "Face with Eigen projection & Average", solidHeader = TRUE,
                  plotOutput("plot5", height = 256, width = 256)
                )
              )
              
      ),
      tabItem(tabName = "widgets2",
              h2("Facial Recognition"),
              fluidRow(
                box(
                  title = "This page shows the similarity of the Eigenfaces.",
                  sliderInput("slider2", "Slider input:", 1, 400, 1)
                ),
                box(
                  title = "Similarity", solidHeader = TRUE,
                  plotOutput("plot6", height = 256, width = 256)
                ),
                box(
                  title = "Selected Image", solidHeader = TRUE,
                  plotOutput("plot7", height = 256, width = 256)
                ),
                box(
                  title = "Person Recognized", solidHeader = TRUE,
                  plotOutput("plot9", height = 256, width = 256)
                )
              )
              
      ),
      tabItem(tabName = "widgets3",
              h2("Average Faces"),
              fluidRow(
                box(
                  title = "This page shows the Average Face of the person selected.",
                  sliderInput("slider3", "Slider input:", 1, 40, 1)
                ),
                box(
                  title = "Average Face", solidHeader = TRUE,
                  plotOutput("plot8", height = 256, width = 256)
                )
              )
              
      ),
      tabItem(tabName = "widgets4",
              h2("Eigenvector Results"),
              fluidRow(
                box(
                  title = "This shows the results of the projection coefficients
                  of the selected image in eigen space after reducting the data
                  from 4096 to 40 dimensions.",
                  sliderInput("slider4", "Slider input:", 1, 400, 1),
                  plotOutput("plot10", height = 256, width = 256)
                ),
                box(
                  title = "This shows the total variance of the number of dimensions 
                  selected using the slider input. With 40 dimensions, 85% of the
                  data is retained",
                  sliderInput("slider5", "Slider input:", 1, 4096, 40),
                  plotOutput("plot11", height = 256, width = 256)
                )
              )
              
      )
    )
  )
)

server <- function(input, output) {
  #  set.seed(122)
  #  histdata <- rnorm(500)
  output$plot1 <- renderPlot( plt_img(matrix(as.numeric(df[input$slider, ]), nrow=64, byrow=T)))
  output$plot2 <- renderPlot( plt_img(matrix(as.numeric(df[input$slider1, ]), nrow=64, byrow=T)))
  output$plot3 <- renderPlot(plt_img(matrix(average_face,nrow=64,byrow=T)))
  output$plot4 <- renderPlot(projEigen(input$slider1))
  output$plot5 <- renderPlot(projEigenAverage(input$slider1))
  output$plot6 <- renderPlot(runTest(input$slider2))
  output$plot7 <- renderPlot(mostSimilar(input$slider2))
  output$plot8 <- renderPlot(plotAverage(input$slider3))
  output$plot9 <- renderPlot(personNum(input$slider2))
  output$plot10 <- renderPlot(eigenResults(input$slider4))
  output$plot11 <- renderPlot(plotVariance(input$slider5))
}

shinyApp(ui, server)