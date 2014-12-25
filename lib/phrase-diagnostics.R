#'
#' phrase diagnostics
#'
#' provides diagnostics to measure the predictive accuracy
#' of the type-ahead language model.  an input phrase is broken
#' into sub-phrases and diagnostics are provided for each. for
#' example, the phrase "which is the best" would be broken into
#' the sub-phrases; "which is", "which is the", and "which is the best".
#' model diagnostics would be provided for each sub-phrase.
#'
#'@param phrase The phrase that diagnostics are needed for.
#'@param ngram The ngram language model.
#'@return Diagnostics used to assess model accuracy.s
#'
phrase_diagnostics <- function (phrase, model) {

  # clean the input
  phrase <- clean_sentences (phrase, end_tag = "")

  # generate a list of sub-phrases to predict
  split <- unlist (stri_split (phrase, regex = "[ ]+"))
  if (length (split) > 1) {
    phrases <- sapply (1:length (split), function (end) split [1:end])
    phrases <- sapply (phrases, function (p) paste (p, collapse = " "))
  } else {
    phrases <- split
  }

  # extract the context and actual next word
  phrases <- data.table (phrase = phrases)
  phrases [, `:=` (
    context = except_last_word (phrase),
    word    = last_word (phrase)
  ), by = phrase]

  # grab the top 5 word suggestions for each phrase
  phrases [, c("w1","w2","w3","w4","w5","n") := {
    nxt <- predict (model, context)
    words <- pad (nxt$word, n = 5, pad_with = NA)
    as.list (c(words, unique (nxt$n)))
  }, by = phrase ]

  # is the actual next word in the top 5 suggestions?
  phrases [, accurate := FALSE]
  phrases [ word == w1 | word == w2 | word == w3 | word == w4 | word == w5, accurate := TRUE]

  # calculate the cumulative accuracy for each of the sub-phrases
  phrases [, length := .I ]
  phrases [, accuracy := cumsum (accurate) / length ]

  return (phrases)
}
