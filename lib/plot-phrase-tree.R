
#'
#'
#'
plot_phrase_tree <- function (diagnostics) {
  
  stopifnot (is.data.frame (diagnostics))
  stopifnot (c ("phrase","context","w1","w2","w3","w4","w5") %in% colnames (diagnostics))
  
  # create links for the words typed by the user - these should be weighted heavily
  word_links <- diagnostics [, phrase, by = context]
  setnames (word_links, c("source","target"))
  
  # create links for the model's suggestions - weighted by probability
  sugg_links <- rbindlist (list (diagnostics [, w1, by = context],
                                 diagnostics [, w2, by = context],
                                 diagnostics [, w3, by = context],
                                 diagnostics [, w4, by = context],
                                 diagnostics [, w5, by = context]))
  setnames (sugg_links, c("source", "target"))
  sugg_links <- sugg_links [complete.cases (sugg_links)]
  
  # create a network plot
  links <- rbind (word_links, sugg_links)
  if (nrow (links) < 100) {
    simpleNetwork (links, font = 16)
  }
}