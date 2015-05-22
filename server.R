library(shiny)
library(rCharts)
library(data.table)

# This is reactive App where Word cloud and Plot changes based on User Input
# File upload feature of Shiny App is used to read text format data
# Word cloud is generated in global.R file using helper function
# Word Cloud and rCharts plot can be viewed in 2 different tabs

function(input, output, session) {
    # Define a reactive expression for the document term matrix
    terms <- reactive({
        # Change when file is selected from local machine
        input$file1
        if(is.null(input$file1))     return(NULL) 
        infile1 <- input$file1
        my_data <- read.table(infile1$datapath, sep='\n')
        # ...but not for anything else
        isolate({
            withProgress({
                setProgress(message = "Processing wordcloud...")
                getTermMatrix(my_data)
            })
        })
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    output$WordCld <- renderPlot({
        if(!is.null(input$file1)) {
            v <- terms()
            wordcloud_rep(names(v), v, scale=c(4,0.5),
                          min.freq = input$freq, max.words=input$max,
                          colors=brewer.pal(8, "Dark2"))
        }
        
    })
    # Below code will plot Bar chart with top 15 words and frequencies
    output$plot <- renderChart2({
        if(!is.null(input$file1)) {
            v <- terms()
            setorder(dt1, -freq)
            p1 <- rPlot(freq ~ word, color = 'word', data = dt1, type = 'bar', group='word')
            return(p1)
        }
    })
    output$notes3 <- renderUI( {
        if (is.null(input$file1)) { return() }
        HTML("This interactive bar plot shows top 15 words in the wordcloud with their frequency")
        
    })
}