#'
#'
#'
plot_katz_models <- function (diagnostics) {
  
  stopifnot (is.data.frame (diagnostics))
  stopifnot (c ("n", "accurate") %in% colnames (diagnostics))
  
  # add a label for the model that was used for the prediction
  diagnostics [n == 1, nlabel := "Unigram"]
  diagnostics [n == 2, nlabel := "Bigram" ]
  diagnostics [n == 3, nlabel := "Trigram"]
  diagnostics [, nlabel := factor (nlabel, levels = c("Unigram", "Bigram", "Trigram"))]
  
  ggplot (diagnostics, aes (x = nlabel, fill = as.character (accurate))) + 
    geom_bar (aes (y = ..count.. / sum (..count..)), width = 0.45) +
    stat_bin (geom = "text", 
              aes (label = ..count.., 
                   y = (..count.. / sum (..count..))), 
              vjust = 2) +
    scale_y_continuous (label = percent) + 
    scale_x_discrete (drop = FALSE) +
    scale_fill_manual (values = c("TRUE"="chartreuse3", "FALSE"="red3"),
                       labels = c("Inaccurate", "Accurate")) +
    xlab ("") +
    ylab ("Percentage of Overall Use") + 
    theme (legend.title = element_blank())
}