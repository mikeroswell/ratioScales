#' Modified do.call for passing optional arguments to child functions
#'
#' @param what Character, name of function
#' @param args List of unquoted arguments
#' @param accepted Character, quoted names of arguments to be passed to `what`
#' @importFrom methods formalArgs
#'
#' @return Output of what
#'
#' @details source code and example from stack overflow conversation with G.
#'   Grothendieck here: https://stackoverflow.com/a/71801214/8400969
#' @noRd
#'
#' @examples
#'
#' dat <- c(NA, 1:5)
#' meanLog <- function(x, ...){
#'   y <- doCall2("log", list(x, ...), "base")
#'   z <- doCall2("mean.default", list(y, ...))
#'   return(z)
#'   }
#'
#' meanLog(dat, na.rm = TRUE, base = 2)

doCall2 <- function(what, args, accepted = methods::formalArgs(what)) {
  ok <- names(args) %in% c("", accepted)
  do.call(what, args[ok])
}
