library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Linear regression estimation"),
    h3("True coefficients of X01 and X02 will always be generated as 1."),
    h3("Other variables are generated with 0."),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("n_samples",
                        "Number of samples",
                        min = 10,
                        max = 1000,
                        value = 100,
                        step = 10),
            sliderInput("n_variables",
                        "Number of variables",
                        min = 5,
                        max = 50,
                        value = 10),
            actionButton("compute", "Compute result")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Least squares", plotOutput("ls_plot")),
                        tabPanel("Lasso", plotOutput("lasso_plot")),
                        tabPanel("Ridge", plotOutput("ridge_plot"))
            ) ## End tablsetPanel
        ) ## End mainPanel
    )
))
