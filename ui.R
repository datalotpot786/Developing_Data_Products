library(shiny)
library(rCharts)
library(data.table)
# Below UI expects text based file of text transcript which can be speech, debates, editorials,articles
# File Upload feature is provided so that user can upload file from their local machine to run 
# Word Cloud.
# Users can use slider to change Frequency and Number of words
fluidPage(
    # Application title
    titlePanel("Generate Word Cloud & rCharts Bar plot"),
    
    sidebarLayout(
        # Sidebar with a file upload & slider
        sidebarPanel(
            helpText("This app is shows how a user can build word cloud using a text format file\n
            in unstructured form from their own hard drive to perform Word cloud Analysis.
            There are 2 tabs. 1st Tab shows Word Cloud and 2nd Tab shows top 15 words from the Word cloud with
the Frquency. Users can use slider to change the Maximum number of words as well as Frquency.
                     File should be just plain text of any form. Sample files are available on Github."),
            fileInput('file1', 'Choose Text File',
                      accept=c('text', 'text/plain')),
            hr(),
            sliderInput("freq",
                        "Minimum Frequency:",
                        min = 1,  max = 50, value = 25),
            sliderInput("max",
                        "Maximum Number of Words:",
                        min = 1,  max = 300,  value = 100)
        ),
        
        # Show Word Cloud & rCharts plot
        mainPanel(
            tabsetPanel(type='tabs',tabPanel('Word Cloud',plotOutput('WordCld')),
                        tabPanel('Plot',showOutput('plot','polycharts'),htmlOutput("notes3")))
            
        )
    )
)