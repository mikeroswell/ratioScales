#' Ratio labels
#'
#'
#' @param x Numeric, on a logarithmic scale
#' @param base Scalar, base of the logarithm used
#'
#' @concept Visualization
#'
#' @return String to be evaluated with \code{str2expression}
#' @export
#'
#' @examples
#' print_operator(((-1:3)))
#'
print_operator <- function(x, base = exp(1)){
  ifelse(sign(x) == -1,
         paste("NULL","%/%", base^abs(x))
         , ifelse(sign(x) == 1,
                  paste("NULL", "%*%", base^abs(x))
                  , paste0("bold(", base^x, ")")
         )
  )
}



#' Truncate log-scaled axis breaks to data range
#'
#' @param v Numeric vector, data or data range
#' @param n Integer, target number of breaks
#'
#' @return Vector of numeric values for axis breaks
#' @export
#'
#' @examples
#' dat <- exp(seq(-2,5,0.2))
#' v <- log(dat) # data or data range
#' n <- 5
#' # axisTicks returns values way beyond data
#' grDevices::axisTicks(nint = n, log = TRUE, usr = range(v))
#' # limBreaks reels this in
#' limBreaks(v = v, n = n)
limBreaks <- function(v, n=5){
  b <- grDevices::axisTicks(nint=n, log=TRUE, usr=range(v))
  # suppressWarnings for max(NULL) etc.
  upr <- suppressWarnings(min(b[log(b)>=max(v)]))
  lwr <- suppressWarnings(max(b[log(b)<=min(v)]))
  ## print(c(lwr=lwr, upr=upr))
  return(b[(b>=lwr) & (b<=upr)])
}


#' Compute breaks for ratio scale
#'
#' @param n Scalar, target number of breaks
#' @param nmin Scalar, forced minimum number of breaks
#' @param anchor Logical, include origin (1 on the ratio scale)
#'
#' @return Vector of values to generate axis breaks
#' @export
#'
#' @examples
#' y <- exp(seq(-2,5, length.out = 10))
#' v <- log(y) # data or data range
#' n <- 5
#'
#' # axisTicks takes giant steps, returns values way beyond data
#' grDevices::axisTicks(nint = n, log = TRUE, usr = range(v))
#' # divmultBreaks gives ~n breaks evenly within the data
#' divmultBreaks(n = n)(v = y)
#'
#' # if 1 is lower limit, only positive log(breaks)
#' divmultBreaks()(c(1, 11))
#' # ditto, only negative log(breaks) if 1 is upper limit
#' divmultBreaks()(c(0.04, 1))
#'
#' # expanding range on one side of 1 doesn't leave the other side behind
#' divmultBreaks()(c(0.04, 2.2))
#' divmultBreaks()(c(0.04, 220))
#' divmultBreaks()(c(0.04, 2200))
#'
#' x <- 1:10
#' dat <- data.frame(x, y)
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y))+
#'      ggplot2::geom_point()+
#'      ggplot2::scale_y_continuous(
#'      trans = "log"
#'      , breaks = divmultBreaks()
#'      , labels = function(x){str2expression(print_operator(log(x)))}
#'      )


divmultBreaks <- function(n=6, nmin=3, anchor=TRUE){
  function(v){
    print(v)
    if (anchor) v <- unique(c(v, 1))
    v <- log(v)
    neg <- min(v)
    if (neg==0) return(limBreaks(v, n))
    pos <- max(v)
    if (pos==0) return(1/limBreaks(-v, n))

    flip <- -neg
    big <- pmax(pos, flip)
    small <- pmin(pos, flip)
    bigprop <- big/(pos + flip)
    bigticks <- ceiling(n*bigprop)

    main <- limBreaks(c(0, big), bigticks)
    cut <- pmin(bigticks, 1+sum(main<small))
    if(cut<nmin)
      other <- limBreaks(c(0, small), nmin)
    else
      other <- main[1:cut]

    breaks <- c(main, 1/other)
    if (flip > pos) breaks <- 1/breaks
    return(sort(unique(breaks)))
  }
}


