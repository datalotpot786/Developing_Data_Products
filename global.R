library(tm)
library(wordcloud)
library(memoise)
library(data.table)

# This App is built to generate Word cloud out of text file
# Below function expects dataset which is read in reactive function of server.R
# Below function uses tm and wordcloud libaries to create Word cloud
# It also generates data frame with top 15 words which are plotted

getTermMatrix <- memoise(function(my_data) {

    # Below steps will read Data set from UI and generate Word cloud by applying filters.
    myCorpus = Corpus(VectorSource(my_data))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords,
                      c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but","_","--"))
    
    myDTM = TermDocumentMatrix(myCorpus,
                               control = list(minWordLength = 1,wordLengths=c(0,Inf),
                                              removePunctuation = TRUE))
    
    m = as.matrix(myDTM)
    wordFreq = rowSums(m)
    sortedValues = sort(wordFreq, decreasing=T)
    identifiers = names(sortedValues)
    # Create Data Frame/Data table for plotting
    df = data.frame(word=identifiers, freq=sortedValues)
    dt = as.data.table(df)
    dt = na.omit(dt)
    dt1 <<- head(dt, 15)
    sort(rowSums(m), decreasing = T)
})