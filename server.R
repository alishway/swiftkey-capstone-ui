library (scales)
library (ggplot2)
library (shiny)
library (networkD3)
library (swiftcap)

source ("lib/pad.R")
source ("lib/remove-nonprint.R")
source ("lib/phrase-diagnostics.R")
source ("lib/plot-katz-models.R")
source ("lib/plot-phrase-accuracy.R")
source ("lib/plot-phrase-tree.R")
source ("lib/plot-top-words.R")
source ("lib/generate-phrase.R")

# load the ngram model used for type ahead prediction
data (model)

shinyServer (function (input, output, clientData, session) {

    # predict the top 5 most likely words to be next
    next_words <- reactive ({
        predict (model, input$context)
    })

    # retrieve diagnostics for how the model performed on the given input
    diagnostics <- reactive ({
        phrase_diagnostics (input$context, model)
    })

    # what is the single word most likely to be next?
    output$next_word <- renderText ({
        validate (need ( nchar (input$context) > 0, "Begin by typing..."))

        # extract the single most likely word
        w <- next_words()$word[1]

        # if no prediction can be made, prompt the user to keep typing
        ifelse (!is.na (w), w,  "Continue typing for further suggestions...")
    })

    # when the user clicks the "random" button, generate a randomized phrase
    observe ({

        if (input$gorandom > 0) {
            phrase <- generate_phrase (model)
            updateTextInput (session, "context", value = phrase)
        }
    })

    # plot the relative probability of the top N next words
    output$next_words_plot <- renderPlot ({
        plot_top_words (next_words ())
    })

    # visualize accuracy across the entire phrase
    output$accuracy_plot <- renderPlot ({
        plot_phrase_accuracy (diagnostics ())
    })

    # display the tree of predictions for each sub-phrase
    output$phrase_tree <- renderSimpleNetwork ({
        plot_phrase_tree (diagnostics ())
    })

    # display which models (unigram, bigram, etc) are being leveraged
    output$katz_plot <- renderPlot ({
        plot_katz_models (diagnostics ())
    })
})

