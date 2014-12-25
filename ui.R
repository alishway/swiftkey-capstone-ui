
shinyUI (
  
  fluidPage (
    
    # page title
    titlePanel ("Type Ahead Prediction"),
    
    # the 1st row
    fluidRow (
      
      # allow the user to type
      wellPanel (
        
        # text entry box
        fluidRow (
          column (10, textInput ("context", label = "", value = "Start with a few kind words about")),
          tags$style (type="text/css", "input[type=text] {width: 100%;}"),
          column (2, actionButton ("gorandom", label = "Random"))
        ),

        # the predicted next word
        helpText (textOutput ("next_word"))
      )
    ),
    
    # the 2nd row 
    fluidRow (
      
      # the top N most likely next words
      column (
        6, 
        verticalLayout (
          
          h5 ("Top Suggestions"),
          plotOutput ("next_words_plot"),
          helpText ( 
            paste0 ("Figure 1: The most likely next words and the probability ", 
                    "of each as calculated by the model.")
          )
        )                    
      ),
      
      # cumulative accuracy
      column (
        6, 
        verticalLayout (
          
          h5 ("Type Ahead Accuracy"),
          plotOutput ("accuracy_plot"),
          helpText ( 
            paste0 ("Figure 2: The cumulative accuracy of type ahead prediction for the current ",
                    "phrase. The model is considered accurate if the next word appears ", 
                    "in the top 5 suggestions.")
          )
        )
      ),
      
      # the 3rd row 
      fluidRow (
        
        # katz back-off algorithm
        column (
          6,
          verticalLayout (
            
            h5 ("Katz Back-Off"),
            plotOutput ("katz_plot"),
            helpText (
              paste0 ("Figure 3: Identifies the n-gram models that are used more frequently for ",
                      "type ahead prediction.  The y-axis shows the percentage of time the ", 
                      "ngram model was used.  The accuracy of each model is also highlighted.")))
        ),
        
        # network graph of the model's cumulative suggestions
        column (
          6,
          verticalLayout ( 
            
            h5 ("Phrase Tree"),
            networkD3::simpleNetworkOutput ("phrase_tree"),
            helpText (
              paste0 ("Figure 4: The cumulative top suggestions for the entire phrase.  Rearrange, ",
                      "click, and move the nodes to uncover relations between the model's suggestions. ",
                      "Each node containing a caret (^) is a sub-component of the phrase. Those ",
                      "nodes connected contain the model's suggestions.")
            )
          )
        )
      )
    ),
    
    # links
    fluidRow (
      wellPanel (
        column (4, 
                align = "left", 
                tags$a(href="http://rpubs.com/willylane333/46619", 
                       "How does this work?")),
        
        column (4, 
                align = "center",
                tags$a(href="https://github.com/nickwallen/swiftkey-capstone", 
                       "Where is the code?")),
        
        column (4, align = "right",
                tags$a(href="https://www.linkedin.com/in/nickallenofcolumbus", 
                       "Who did this?"))
      )
    )
  )
)