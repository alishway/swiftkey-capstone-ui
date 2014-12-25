
#'
#' plots the top 'N' words as predicted by the language model
#'
plot_top_words <- function (next_words) {
  
  stopifnot (is.data.frame (next_words))
  stopifnot (c("word", "p") %in% colnames (next_words))
  
  ggplot (next_words, aes (reorder (word, p), p, fill = word)) + 
    geom_bar (stat = "identity", width = 0.55) + 
    scale_y_continuous (label = percent) +
    coord_flip () +
    xlab ("") +
    ylab ("Probability") +
    theme (legend.position = "none", axis.text.y = element_text (size = 20)) 
}