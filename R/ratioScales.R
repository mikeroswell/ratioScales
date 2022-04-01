#' Ratio labels
#'
#'
#' @param logscale Logical, are breaks already on the log scale?
#' @param base Scalar, base of the logarithm used
#'
#' @concept Visualization
#'
#' @return Function for generating labeling expressions based on breaks
#' @export
#'
#' @examples
#' label_divMult()(c(1:4,2))
#'
label_divMult <- function(logscale = F, base = exp(1)){
  function(x){
  if(logscale){x <- x}
  else{x <- log(x, base = base )}
  chars <- ifelse(sign(x) == -1,
           paste("NULL","%/%", base^abs(x))
           , ifelse(sign(x) == 1,
                    paste("NULL", "%*%", base^abs(x))
                    , paste0("bold(", base^x, ")")
             )
       )

    return(str2expression(chars))
    }
}

#' 100x Natural log (centinel) transformation of breaks
#'
#' @return Function used as argument to `labels` in `scale_*_*`
#' @export
#'
label_centiNel <- function(){
  function(x){100*log(x)}
}

#' Natural log (nel) transformation of breaks
#'
#' @return Function used as argument to `labels` in `scale_*_*`
#' @export
#'
label_nel <- function(){
  log
}

#' Natural log transformation... with breaking control
#'
#' @param n Integer, desired number of breaks
#' @seealso \code{\link[scales]{log_breaks}}
#'
#' @export
#'
#' @examples
#' dat<-data.frame(x = 1:10, y = exp(-2:7))
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y)) +
#'   ggplot2::geom_point() +
#'     ggplot2::scale_y_continuous(
#'        trans = "nel"
#'        # default breaks aren't perfect; sometimes adding more helps
#'        #  trans = nel_trans(n = 9)
#'        , labels = label_nel()
#'        , sec.axis = ggplot2::sec_axis(
#'            labels = function(x) {x}
#'            , trans = ~.
#'            , breaks = c(0.1, 0.5, 1, 5, 10, 50, 100, 500, 1000)
#'            , name = "original data"
#'          )
#'        ) +
#'      ggplot2::labs(y = "nel (natural log) scale") +
#'      ggplot2::geom_hline(yintercept = 1, size = 0.2)
#'
nel_trans <- function(n = 7){
  scales::trans_new(
    "nel"
    , trans <- "log"
    , inv <- "exp"
    , breaks <- scales::log_breaks(base = exp(1), n = n)
  )
}


#' Split stingy limBreaks into three parts per complete decade
#' @param v vector on the unlogged scale to be examined and split
#' @return vector with splits added
splitDecades <- function(v){
	l <- length(v)
	w <- numeric(0)
	if (l>1) for (i in 1:(l-1)){
		w <- c(w, v[[i]])
		if (v[[i+1]]==10*v[[i]]) w <- c(w, 2*v[[i]], 5*v[[i]])
	}
	return(c(w, v[[l]]))
}

#' Truncate log-scaled axis breaks to data range
#'
#' @param v Numeric vector, data or data range
#' @param n Integer, target number of breaks
#' @param split logical, split decades using splitDecades
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
limBreaks <- function(v, n=5, split=FALSE){
  b <- grDevices::axisTicks(nint=n, log=TRUE, usr=range(v))
  if(split) b <- splitDecades(b)
  # suppressWarnings for max(NULL) etc.
  upr <- suppressWarnings(min(b[log(b)>=max(v)]))
  lwr <- suppressWarnings(max(b[log(b)<=min(v)]))
  return(b[(b>=lwr) & (b<=upr)])
}

#' Compute breaks for ratio scale
#'
#' @param n Scalar, target number of breaks
#' @param nmin Scalar, forced minimum number of breaks
#' @param anchor Logical, always include origin (1 on the ratio scale)
#' @param split logical, split decades using splitDecades
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
#' # divMultBreaks gives ~n breaks evenly within the data
#' divMultBreaks(n = n)(v = y)
#'
#' # if 1 is lower limit, only positive log(breaks)
#' divMultBreaks()(c(1, 11))
#' # ditto, only negative log(breaks) if 1 is upper limit
#' divMultBreaks()(c(0.04, 1))
#'
#' # expanding range on one side of 1 doesn't leave the other side behind
#' divMultBreaks()(c(0.04, 2.2))
#' divMultBreaks()(c(0.04, 220))
#' divMultBreaks()(c(0.04, 2200))
#'
#' x <- 1:10
#' dat <- data.frame(x, y)
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y))+
#'      ggplot2::geom_point()+
#'      ggplot2::geom_hline(yintercept = 1, size = 0.2) +
#'      ggplot2::scale_y_continuous(
#'      trans = "log"
#'      , breaks = divMultBreaks()
#'      , labels = label_divMult()
#'      )


divMultBreaks <- function(n=6, nmin=3, anchor=TRUE, split=FALSE){
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






#' Ratio-based position scales for continuous data (x & y)
#'
#' `scale_x_ratio` and `scale_y_ratio` are alternatives to  traditional
#' `scale_*_continuous` scales for continuous x and y aesthetics, to explicitly
#' highlight multiplicative or geometric value changes. Rather than traditional
#' log transformations (as in `scale_*_log10()`), which rescale the axis and
#' return tickmarks on the original scale of the data, `scale_*_ratio` axis tick
#' values represent a multiplicative change from a reference point. These scales
#' may be especially useful for highlighting proportional changes.
#'
#' @param tickVal Character, one of "divMult", "nel", "centiNel", or
#'   "propChange"
#' @param trans Function or Character name of transformation, most likely "log"
#' @param ... Additional arguments passed to
#'    \code{\link[ggplot2]{scale_y_continuous}}
#'
#'
#' @export
#'
#' @examples
#' y <- exp(seq(-2,5, length.out = 10))
#' x <- 1:10
#' dat <- data.frame(x, y)
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y))+
#'      ggplot2::geom_point()+
#'      ggplot2::geom_hline(yintercept = 1, size = 0.2) +
#'      scale_y_ratio(tickVal = "divMult")
#'
#'  dat %>% ggplot2::ggplot(ggplot2::aes(x, y))+
#'      ggplot2::geom_point()+
#'      scale_y_ratio(tickVal = "centiNel")

scale_y_ratio <- function(tickVal = "divMult"
                          , trans = "nel"
                          , ... ){
  if(tickVal %in% c("divmult", "divMult")){
    return(ggplot2::scale_y_continuous( trans = trans
                        , breaks = divMultBreaks()
                        , labels = label_divMult()
                        , ...
    ))
  }
  if(tickVal %in% c("nel", "Nel")){
    return(ggplot2::scale_y_continuous( trans = trans
                              , labels = label_nel()
                              , ...
    ))
  }
  if(tickVal %in% c("centinel", "centiNel")){
    return(ggplot2::scale_y_continuous( trans = trans
                              , labels = label_centiNel()
                              , ...
    ))
  }
}



# scale_x_ratio <- function(tickVal = "divMult"
#                           , trans = "log"
#                           , ... ){
#   if(tickVal %in% c("divmult", "divMult")){
#     scale_x_continuous( trans = trans
#                         , breaks = divMultBreaks()
#                         , labels = label_divMult()
#                         )
#   }
# }




