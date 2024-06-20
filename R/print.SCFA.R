#' Print results of Signal Cancellation Factor Analysis
#'
#' @description Print the number of factors to retain.
#' @param x An object of class "SCFA".
#' @param ... Further arguments for other methods, ignored for "SCFA".
#'
#' @export
#' 
#' @return No return value, called for side effects.
#'
#' @examples 
#' results <- SCFA(TabachnickFidell, N = 175)
#' print(results)
print.SCFA <- function(x, ...){
  cat(paste0("Signal Cancellation Factor Analysis found ",x$ng,.s(x$ng," factor"),"."),"\n")
}

# .s ####
.s <- function(x, w = NULL){
  paste0(w, c("s")[x>1])
}
