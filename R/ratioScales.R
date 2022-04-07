#' Ratio labels
#'
#'
#' @param logscale Logical, are breaks already on the log scale?
#' @inheritParams base::log
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
  function(x){ scales::label_number(scale = 100)(log(x))}
 }

#' Natural log (nel) transformation of breaks
#'
#' @return Function used as argument to `labels` in `scale_*_*`
#' @export
#'
label_nel <- function(){
  function(x) { scales::label_number()(log(x))}
}




#' Scale breakpoints based on percentage difference from reference
#'
#' @inheritParams label_divMult
#'
#' @return Function used as argument to `labels` in `scale_*_*`
#' @export
label_percDiff <- function(logscale = FALSE, base = exp(1)){
  function(x){
    if(logscale){x <- x}
    else{x <- log(x, base = base )}
    myval <- abs(abs(exp(x)) -1)
    prefix <- c("- ", "", "+ " )[sign(x)+2]
    scales::label_percent(prefix = prefix)(myval)
  }
}


#' Scale breakpoints based on percentage difference from reference
#'
#' @inheritParams label_divMult
#'
#' @return Function used as argument to `labels` in `scale_*_*`
#' @export
label_propDiff <- function(logscale = FALSE, base = exp(1)){
  function(x){
    if(logscale){x <- x}
    else{x <- log(x, base = base )}
    myval <- abs(abs(exp(x)) -1)
    prefix <- c("- ", "", "+ " )[sign(x)+2]
    scales::label_number(prefix = prefix)(myval)
  }
}



#' Natural log transformation... providing breaks on the "nel" scale
#'
#' @param n Integer, desired number of breaks
#' @param use_centiNel Logical, should units be "centiNels" (defaul is "nel")
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
#'            , name = "original scale"
#'          )
#'        ) +
#'      ggplot2::labs(y = "nel (natural log) scale") +
#'      ggplot2::geom_hline(yintercept = 1, size = 0.2)
#'
nel_trans <- function(n = 7, use_centiNel = FALSE){
  scales::trans_new(
    "nel"
    , trans = function(x) log(x)*100
    , inverse = function(x) exp(x/100)
    , breaks = scales::breaks_log(n = n)
    , format = ifelse(use_centiNel, label_centiNel(), label_nel())
  )
}



#' Natural log transformation... showing proportional change explicitly
#'
#' @inheritParams breaks_divMult
#' @inheritParams label_propDiff
#' @export
#' @examples
#' dat<-data.frame(x = 1:10, y = exp(-2:7))
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y)) +
#'     ggplot2::geom_point() +
#'     ggplot2::scale_y_continuous(
#'       trans = propDiff_trans()
#'       , sec.axis = ggplot2::sec_axis(
#'           labels = function(x) {x}
#'           , trans = ~.
#'           , breaks = c(0.1, 0.5, 1, 5, 10, 50, 100, 500, 1000)
#'           , name = "original scale"
#'         )
#'       ) +
#'     ggplot2::labs(y = "propDiff scale") +
#'     ggplot2::geom_hline(yintercept = 25, size = 0.2)
#'
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, exp(seq(-1, 0.8, 0.2)))) +
#'  ggplot2::geom_point() +
#'  ggplot2::scale_y_continuous(
#'    trans = propDiff_trans()
#'    , labels = label_propDiff()
#'    , sec.axis = ggplot2::sec_axis(
#'      labels = function(x) {x}
#'      , trans = ~.
#'      , name = "original scale"
#'    )
#'  ) +
#'  ggplot2::labs(y = "propDiff scale") +
#'  ggplot2::geom_hline(yintercept = 1, size = 0.2)
#'
#'
#'
#'
propDiff_trans <- function(n = 7, splits = 3, anchor = TRUE, base = 10){
  scales::trans_new(
    "propDiff"
    , trans = function(x) { log(x, base = base) }
    , inverse = function(x) { base^x}
    , breaks = breaks_divMult(n = n, splits = splits, base = base, anchor = anchor)
    , format = label_propDiff()
  )
}





#' Split stingy limit_breaks into three parts per complete decade
#' @param v Vector on the unlogged scale to be examined and split
#' @inheritParams breaks_divMult
#'
#' @return Vector with splits added
split_decades <- function(v, splits = c(1, 2, 3)){
	l <- length(v)
	w <- numeric(0)
	if (l>1) for (i in 1:(l-1)){
		w <- c(w, v[[i]])
		if (splits == 1) { return(c(w, v[[l]])) }
		if (v[[i + 1]] == 10 * v[[i]]) {
		  if (splits == 3) {w <- c(w, 2*v[[i]], 5*v[[i]])}
		  if (splits == 2) {w <- c(w, 3*v[[i]])}
		}
	}
	return(c(w, v[[l]]))
}

#' Truncate log-scaled axis breaks to data range
#'
#' @inheritParams breaks_divMult
#' @param v Numeric vector, data or data range
#'
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
limit_breaks <- function(v
                         , n = 5
                         , splits = 1
                         , base = exp(1)){
  b <- split_decades(
    grDevices::axisTicks(nint = n, log = TRUE, usr = range(v))
    , splits = splits)
  # suppressWarnings for max(NULL) etc.
  upr <- suppressWarnings(min(b[log(b, base = base) >= max(v)]))
  lwr <- suppressWarnings(max(b[log(b, base = base) <= min(v)]))
  return(b[(b >= lwr) & (b <= upr)])
}

#' Compute breaks for ratio scale
#'
#' @param n Scalar, target number of breaks
#' @param nmin Scalar, forced minimum number of breaks
#' @param anchor NULL or scalar, value to include as a reference point (usually
#'   1)
#' @param splits Integer, one of \code{c(1,2,3)}. How many tick marks per
#'   "decade?"
#' @inheritParams base::log
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


breaks_divMult <- function(n = 6
                           , nmin = 3
                           , anchor = TRUE
                           , splits = 1
                           , base = exp(1)){
  function(v){
    if(anchor){unique(c(v, 1))}
    v <- log(v, base = base)
    neg <- min(v)
    if (neg==0) return(limit_breaks(v
                                              , n
                                              , splits = splits
                                              , base = base))
    pos <- max(v)
    if (pos==0) return(1/limit_breaks(-v
                                                , n
                                                , splits = splits
                                                , base = base))

    flip <- -neg
    big <- pmax(pos, flip)
    small <- pmin(pos, flip)
    bigprop <- big/(pos + flip)
    bigticks <- ceiling(n*bigprop)

    main <- limit_breaks(c(0, big)
                                   , bigticks
                                   , splits = splits
                                   , base = base)
    cut <- pmin(bigticks, 1+sum(main<small))
    if(cut<nmin)
      other <- limit_breaks(c(0, small)
                                      , nmin
                                      , splits = splits
                                      , base = base)
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
#'   "propDiff"
#' @param trans Function or Character name of transformation
#' @inheritParams split_decades
#' @param ... Additional arguments passed to
#'    \code{\link[ggplot2]{scale_y_continuous}}
#'
#'
#'
#' @details Logarithmic transformations make multiplicative changes additive,
#'   and are often used to highlight relative change. It is traditional to
#'   rescale an axis logarithmically and mark ticks with original scale values
#'   (e.g. \code{\link[ggplot2]{scale_y_log10}})). `scale_*_ratio` provides
#'   an alternative, marking ticks with transformed values. This may be
#'   especially useful when comparing relative changes of quantities with
#'   different units.
#'
#'   Five ratio scales are provided (and denoted with the `tickVal` argument):
#'   - `divMult` rescales an axis logarithmically, and prints multiplicative
#'   changes for axis ticks, explicitly noting the operator ( \eqn{\times} or
#'   \eqn{\div}). This scale highlights symmetry between division and
#'   multiplication (\eqn{a \times 2} is equally far from \eqn{a} as is \eqn{a
#'   \div 2}).
#'
#'   - `nel` rescales an axis logarithmically, and marks it in units of
#'   "nels" (for _N_atural _L_ogarithm).
#'
#'   - `centiNel` rescales an axis logarithmically, and marks it in units
#'   of "centinels," i.e. one hundredth of a "nel". These may be more
#'   appropriate for small changes (i.e. of a few to a few hundred percents)
#'
#'   -`propDiff` rescales an axis logarithmically, but marks axes in terms of a
#'   proportional  *difference* from the reference point. Unlike when
#'   proportions are plotted on an arithmetic scale, the `propDiff`
#'   transformation reveals underlying geometric symmetry: (\eqn{a \times 2} is
#'   equally far from \eqn{a} as is \eqn{a \div 2}) graphically, but tick values
#'   indicate the more familiar proportional changes \eqn{+ 1}, \eqn{-0.5}.
#'
#'   -`percDiff` rescales an axis logarithmically, but marks axes in terms of a
#'   percentage *difference* from the reference point. Unlike when percentages
#'   are plotted on an arithmetic scale, the `percDiff` transformation reveals
#'   underlying geometric symmetry: (\eqn{a \times 1.25} is equally far from
#'   \eqn{a} as is \eqn{a \div 1.25}) graphically, but tick values indicate the
#'   more familiar proportional changes \eqn{+ 25%}, \eqn{- 20%}.
#'
#'   For small changes, "centinels" and percentage difference may be preferable,
#'   while for larger changes, "nels" (and possibly proportional difference)
#'   may be preferable.
#'
#'   Typically, the data passed to `scale_*_ratio` should be centered on a
#'   reference value in advance.
#'
#'
#'
#'
#' @export
#'
#' @examples

#'
#' smaller <- data.frame(x = 1:10, y = exp(seq(-0.2, 0.7, 0.1)))
#' bigger <- data.frame(x = 1:10, y = exp(-2:7))
#' ax2 <- ggplot2::sec_axis(
#'           labels = function(x) {x}
#'           , trans = ~.
#'           , breaks = breaks_divMult(n = 7, splits = 2)
#'           , name = "original scale"
#'         )
#'
#' bigger %>%  ggplot2::ggplot(ggplot2::aes(x,y)) +
#'      ggplot2::geom_point() +
#'      ggplot2::geom_hline(yintercept = 1, size = 0.2) +
#'      scale_y_ratio(tickVal = "divMult"
#'      , sec.axis = ax2) +
#'         ggplot2::labs(y = "divMult scale (fold change)")
#'
#' smaller %>%  ggplot2::ggplot(ggplot2::aes(x,y)) +
#'      ggplot2::geom_point() +
#'      scale_y_ratio(tickVal = "centiNel"
#'      , sec.axis = ax2
#'      ) +
#'         ggplot2::labs(y = "centiNels")
#'
#' # propDiff is a little strange
#' bigger %>%  ggplot2::ggplot(ggplot2::aes(x,y)) +
#'      ggplot2::geom_point() +
#'      scale_y_ratio(tickVal = "propDiff"
#'      , sec.axis = ax2
#'         ) +
#'         ggplot2::labs(y = "propDiff (proportional difference) scale")
#'
#' # percDiff should be familiar
#' smaller %>%  ggplot2::ggplot(ggplot2::aes(x,y)) +
#'      ggplot2::geom_point() +
#'      scale_y_ratio(tickVal = "percDiff"
#'      , sec.axis = ax2) +
#'         ggplot2::labs(y = "propDiff (perentage difference) scale")

scale_y_ratio <- function(tickVal = "divMult"
                          , trans = "nel"
                          , splits = 2
                          , ... ){
  if(tickVal %in% c("divmult", "divMult")){
    return(ggplot2::scale_y_continuous( trans = trans
                        , breaks = breaks_divMult(splits = splits)
                        , labels = label_divMult()
                        , ...
    ))
  }
  if(tickVal %in% c("nel", "Nel")){
    return(ggplot2::scale_y_continuous( trans = trans
                              , ...
    ))
  }
  if(tickVal %in% c("centinel", "centiNel")){
    return(ggplot2::scale_y_continuous( trans = trans
                              , labels = label_centiNel()
                              , ...
    ))
  }
  if(tickVal %in% c("propDiff", "propDiff")){
    return(ggplot2::scale_y_continuous( trans = propDiff_trans()
                                      , ...
    ))
  }
  if(tickVal %in% c("propDiff", "percDiff")){
    return(ggplot2::scale_y_continuous( trans = propDiff_trans()
                                        , labels = label_percDiff()
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




