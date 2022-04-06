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
label_divMult <- function(logscale = FALSE, base = exp(1)){
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


#' Rescaling breaks relative to reference point
#'
#' @param ref Scalar, reference value for proportional change
#'
#' @return Function used as argument to `labels` in `scale_*_*`
#' @export
label_propChange <- function(ref = 1){function(x) {x/ref}}


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
    , trans = "log"
    , inverse = "exp"
    , breaks = scales::log_breaks(base = exp(1), n = n)
  )
}

#' Natural log transformation... showing proportional change explicitly
#'
#' @inheritParams breaks_divMult
#' @inheritParams label_propChange
#' @export
#' @examples
#' dat<-data.frame(x = 1:10, y = exp(-2:7))
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y)) +
#'     ggplot2::geom_point() +
#'     ggplot2::scale_y_continuous(
#'       trans = propChange_trans(ref = 25)
#'       , labels = label_propChange(ref = 25)
#'       , sec.axis = ggplot2::sec_axis(
#'           labels = function(x) {x}
#'           , trans = ~.
#'           , breaks = c(0.1, 0.5, 1, 5, 10, 50, 100, 500, 1000)
#'           , name = "original data"
#'         )
#'       ) +
#'     ggplot2::labs(y = "propChange scale") +
#'     ggplot2::geom_hline(yintercept = 25, size = 0.2)
#'
#'dat %>% ggplot2::ggplot(ggplot2::aes(x, exp(seq(-1, 0.8, 0.2)))) +
#'  ggplot2::geom_point() +
#'  ggplot2::scale_y_continuous(
#'    trans = propChange_trans()
#'    , labels = label_propChange()
#'    , sec.axis = ggplot2::sec_axis(
#'      labels = function(x) {x}
#'      , trans = ~.
#'      , name = "original data"
#'    )
#'  ) +
#'  ggplot2::labs(y = "propChange scale") +
#'  ggplot2::geom_hline(yintercept = 1, size = 0.2)
#'
#'
#'
#'
propChange_trans <- function(n = 7, split = TRUE, ref = 1, base = 10){
  scales::trans_new(
    "propChange"
    , trans = function(x) { log(x, base = base) }
    , inverse = function(x) { base^x}
    , breaks = breaks_divMult(n = n, split = split, base = base, anchor = ref)
  )
}





#' Split stingy limit_breaks into three parts per complete decade
#' @param v vector on the unlogged scale to be examined and split
#' @return vector with splits added
split_decades <- function(v){
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
#' @param split logical, split decades using split_decades
#' @param base Positive number: the base with respect to which logarithms are
#'   computed. Default is the base of the natural log `exp(1)`
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
#' # limit_breaks reels this in
#' limit_breaks(v = v, n = n)
limit_breaks <- function(v, n=5, split=FALSE, base = exp(1)){
  b <- grDevices::axisTicks(nint=n, log=TRUE, usr=range(v))
  if(split) b <- split_decades(b)
  # suppressWarnings for max(NULL) etc.
  upr <- suppressWarnings(min(b[log(b, base = base)>=max(v)]))
  lwr <- suppressWarnings(max(b[log(b, base = base)<=min(v)]))
  return(b[(b>=lwr) & (b<=upr)])
}

#' Compute breaks for ratio scale
#'
#' @param n Scalar, target number of breaks
#' @param nmin Scalar, forced minimum number of breaks
#' @param anchor NULL or scalar, value to include as a reference point (usually
#'   1)
#' @param split logical, split decades using split_decades
#' @param base Positive number: the base with respect to which logarithms are
#'   computed. Default is the base of the natural log `exp(1)`
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
#' # breaks_divMult gives ~n breaks evenly within the data
#' breaks_divMult(n = n)(v = y)
#'
#' # if 1 is lower limit, only positive log(breaks)
#' breaks_divMult()(c(1, 11))
#' # ditto, only negative log(breaks) if 1 is upper limit
#' breaks_divMult()(c(0.04, 1))
#'
#' # expanding range on one side of 1 doesn't leave the other side behind
#' breaks_divMult()(c(0.04, 2.2))
#' breaks_divMult()(c(0.04, 220))
#' breaks_divMult()(c(0.04, 2200))
#'
#' x <- 1:10
#' dat <- data.frame(x, y)
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y))+
#'      ggplot2::geom_point()+
#'      ggplot2::geom_hline(yintercept = 1, size = 0.2) +
#'      ggplot2::scale_y_continuous(
#'      trans = "log"
#'      , breaks = breaks_divMult()
#'      , labels = label_divMult()
#'      )


breaks_divMult <- function(n=6
                           , nmin=3
                           , anchor=NULL
                           , split=FALSE
                           , base = exp(1)){
  if( !is.null(anchor)){
    if(anchor != 1 ){message("1 is the conventional anchor for the divMult scale. \nYou have chosen an anchor other than 1")}
  }
  function(v){
    print(v)
    v <- unique(c(v, anchor))
    v <- log(v, base = base)
    neg <- min(v)
    if (neg==0) return(invisible(limit_breaks(v
                                              , n
                                              , split = split
                                              , base = base)))
    pos <- max(v)
    if (pos==0) return(1/invisible(limit_breaks(-v
                                                , n
                                                , split = split
                                                , base = base)))

    flip <- -neg
    big <- pmax(pos, flip)
    small <- pmin(pos, flip)
    bigprop <- big/(pos + flip)
    bigticks <- ceiling(n*bigprop)

    main <- invisible(limit_breaks(c(0, big)
                                   , bigticks
                                   , split = split
                                   , base = base))
    cut <- pmin(bigticks, 1+sum(main<small))
    if(cut<nmin)
      other <- invisible(limit_breaks(c(0, small)
                                      , nmin
                                      , split = split
                                      , base = base))
    else
      other <- main[1:cut]

    breaks <- c(main, 1/other)
    if (flip > pos) breaks <- 1/breaks
    return(sort(c(unique(breaks), anchor)))
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
                        , breaks = breaks_divMult()
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
#                         , breaks = breaks_divMult()
#                         , labels = label_divMult()
#                         )
#   }
# }




