library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Linear regression estimation"),

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
                        value = 10)
            # actionButton("compute", "Compute result"),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("ls_plot"),
            plotOutput("lasso_plot"),
            plotOutput("ridge_plot")
        )
    )
))
