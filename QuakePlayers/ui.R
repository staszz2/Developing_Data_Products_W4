library(shiny)

# Define UI with mosquito heat map or Chicago

shinyUI(pageWithSidebar(
  
  #Application Title
  headerPanel("Linking Quake Player Efficiency to Aim Accuracy."),
  
  
  # Sidebar with a slider input for month
  sidebarPanel(
    sliderInput("dEfficiency", 
                "Select Minimum Player Efficiency", 
                min = 0,
                max = 2, 
                value = 1,
                step = 0.2),
    
    checkboxGroupInput("dWeapon", label = h3("Include Weapon types"), 
                       choices = list("Lighting gun" = 1, "Railgun" = 2, "Rocket Launcher" = 3),
                       selected = 1),
    helpText("*Regression line is constant.")
    
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Main", plotOutput("myplot"), htmlOutput("averages")),
      tabPanel("Documentation",
               helpText("Background - Quake is an online game where players battle eatchother with various weapons. Stats are extracted through QuakeLive API JSON and stored for simplicity in post-processed CSV file."),
               h4("Instructions"),
               helpText("* Slide the efficiency slider to set minimum value for the data subset"),
               helpText("* Check/uncheck weapons you want to display "),
               helpText("* Observe how accuracies follow regression and when they don't"),
               helpText("* See full dataset in the data tab")
      ),
      tabPanel("Data", dataTableOutput("data"))
    )
  )
))