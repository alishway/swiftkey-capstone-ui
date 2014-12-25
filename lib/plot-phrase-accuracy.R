
#'
#' plots the cumulative accuracy of the model in predicting
#' a complete phrase.  
#'
plot_phrase_accuracy <- function (diagnostics) {
  
  stopifnot (is.data.frame (diagnostics))
  stopifnot (c ("length", "accuracy") %in% colnames (diagnostics))
  
  ggplot (diagnostics, aes (length, accuracy)) + 
    geom_line () +
    geom_point (aes (color = as.character(accurate)), size = 5) + 
    scale_colour_manual (values = c("TRUE"="green", "FALSE"="red")) +
    scale_x_discrete (labels = diagnostics$word) +
    scale_y_continuous (label = percent, limits = c(0, 1)) +
    xlab ("") +
    ylab ("Cumulative Accuracy") +
    theme (legend.position = "none")
  
}