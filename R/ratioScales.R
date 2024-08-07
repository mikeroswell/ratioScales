#' Ratio labels
#'
#' @import ggplot2
#' @param logscale Logical, are breaks provided on the log scale (default is
#'   `FALSE`)?
#' @param slashStar Logical, should division and multiplication symbols be "*"
#'   and "/" (default)? Prettier symbols \eqn{\times, \div} are available when
#'   `slashStar == FALSE`, but font libraries and text size may make
#'   distinguishing \eqn{\div} from \eqn{+} difficult.
#' @inheritParams base::log
#'
#' @family {labels}
#'
#'
#' @return Function for generating labeling expressions based on breaks
#' @export
#'
#' @examples
#' label_divMult()(c(1:4,2))
#'
label_divMult <- function(logscale = FALSE
                          , base = exp(1)
                          , slashStar = TRUE ){
  function(x){
  if(logscale){x <- x}
  else{x <- log(x, base = base )}
  if(slashStar){
    chars <- ifelse(sign(x) == -1
                    , paste("paste('/',", base^abs(x), ")")
                    , ifelse(sign(x) == 1
                             , paste("paste(' *',", base^abs(x), ")")
                             , paste(base^x)
                    )
    )
  return(str2expression(chars))

  } else{
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
}

#' 100x Natural log (centinel) transformation of breaks
#'
#' @family {labels}
#' @return Function used as argument to `labels` in `scale_*_*`
#' @export
#'
label_centiNel <- function(){
  function(x){ scales::label_number(scale = 100)(log(x))}
 }

#' Natural log (nel) transformation of breaks
#'
#' @family {labels}
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
#' @family {labels}
#'
#' @return Function used as argument to `labels` in `scale_*_*`
#' @export
label_percDiff <- function(logscale = FALSE, base = 10){
  function(x){
    if(logscale){x <- x}
    else{x <- log(x, base = base )}
    myval <- abs(abs(base^x) -1)
    prefix <- c("- ", "", "+ " )[sign(x)+2]
    scales::label_percent(prefix = prefix)(myval)
  }
}


#' Scale breakpoints based on percentage difference from reference
#'
#' @inheritParams label_divMult
#' @param accuracy Numeric scalar, determines rounding precision
#'
#'
#' @family {labels}
#' @return Function used as argument to `labels` in `scale_*_*`
#' @seealso \code{\link[scales]{label_number}}
#'
#' @export

label_propDiff <- function(logscale = FALSE, base = 10, accuracy = 0.01){
  function(x){
    if(logscale){x <- x}
    else{x <- log(x, base = base )}
    myval <- abs(abs(base^x) -1)
    prefix <- c("- ", "", "+ " )[sign(x)+2]
    scales::label_number(prefix = prefix, accuracy = accuracy)(myval)
  }
}

#' Natural log transformation... providing breaks on the "nel" scale
#'
#' @inheritParams divMult_trans
#' @param use_centiNel Logical, should units be "centiNels" (default is "nel")
#'
#' @family {transformations}
#' @export
#'
#' @examples
#' dat<-data.frame(x = 1:10, y = exp(-2:7))
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y)) +
#'   ggplot2::geom_point() +
#'     ggplot2::scale_y_continuous(
#'        transform = "nel"
#'       , sec.axis = ggplot2::sec_axis(
#'            labels = function(x) {x}
#'            , transform = ~.
#'            , breaks = c(0.1, 0.5, 1, 5, 10, 50, 100, 500, 1000)
#'            , name = "original scale"
#'          )
#'        ) +
#'      ggplot2::labs(y = "nel (natural log) scale") +
#'      ggplot2::geom_hline(yintercept = 1, linewidth = 0.2)
#'

nel_trans <- function(n = 7, base = exp(1), use_centiNel = FALSE, ...){
  scales::trans_new(
    name = "nel"
    , transform = function(x){log(x, base = base)}
    , inverse = function(x) {base ^ x}
    , breaks = function(x){exp(scales::breaks_extended(n = n)(log(x)))}
    , format = if(use_centiNel){label_centiNel()} else{label_nel()}
  )
}


#' Natural log transformation... providing breaks on the "divMult" scale
#'
#' @inheritParams breaks_divMult
#' @inheritParams label_divMult
#' @param ... Additional arguments passed to breaking function, labeller
#'
#' @family {transformations}
#'
#' @export
#'
#' @examples
#' dat<-data.frame(x = 1:10, y = exp(-2:7))
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y)) +
#'   ggplot2::geom_point() +
#'     ggplot2::scale_y_continuous(
#'        transform = "divMult"
#'        # default breaks aren't perfect; sometimes adding more helps
#'        #  transform = nel_trans(n = 9)
#'        , labels = label_divMult()
#'        , sec.axis = ggplot2::sec_axis(
#'            labels = function(x) {x}
#'            , transform = ~.
#'            , breaks = c(0.1, 0.5, 1, 5, 10, 50, 100, 500, 1000)
#'            , name = "original scale"
#'          )
#'        ) +
#'      ggplot2::labs(y = "nel (natural log) scale") +
#'      ggplot2::geom_hline(yintercept = 1, linewidth = 0.2)
#'
divMult_trans <- function(n = 7, base = exp(1), splits = 2
                          , slashStar = TRUE,  ...){
  scales::trans_new(
    name = "divMult"
    , transform = function(x) log(x, base = base)
    , inverse = function(x) base^x
    , breaks = doCall2(breaks_divMult
                       , list(splits = splits , ...))
    , format = doCall2(label_divMult
                                   , list( slashStar = slashStar, ...))
  )
}



#' Natural log transformation... showing proportional change explicitly
#'
#' @inheritParams breaks_divMult
#' @inheritParams label_propDiff
#' @param ... additional arguments passed to `label_propDiff`
#' @seealso \code{\link[scales]{log_breaks}}
#'
#' @family {transformations}
#' @export
#' @examples
#' dat<-data.frame(x = 1:10, y = exp(-2:7))
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, y)) +
#'     ggplot2::geom_point() +
#'     ggplot2::scale_y_continuous(
#'       transform = propDiff_trans(base = 2)
#'       , sec.axis = ggplot2::sec_axis(
#'           labels = function(x) {x}
#'           , transform = ~.
#'           , breaks = c(0.1, 0.5, 1, 5, 10, 50, 100, 500, 1000)
#'           , name = "original scale"
#'         )
#'       ) +
#'     ggplot2::labs(y = "propDiff scale") +
#'     ggplot2::geom_hline(yintercept = 1, linewidth = 0.2)
#'
#' dat %>% ggplot2::ggplot(ggplot2::aes(x, exp(seq(-1, 0.8, 0.2)))) +
#'  ggplot2::geom_point() +
#'  ggplot2::scale_y_continuous(
#'    transform = propDiff_trans()
#'    , sec.axis = ggplot2::sec_axis(
#'      labels = function(x) {x}
#'      , transform = ~.
#'      , breaks = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2)
#'      , name = "original scale"
#'    )
#'  ) +
#'  ggplot2::labs(y = "propDiff scale") +
#'  ggplot2::geom_hline(yintercept = 1, linewidth = 0.2)
#'
#'
#'
#'
propDiff_trans <- function(n = 7, base = exp(1), ...){
  scales::trans_new(
    "propDiff"
    , transform = function(x) { log(x, base = base) }
    , inverse = function(x) { base^x}
    , breaks = scales::breaks_log(n = n, base = base)
    , format = label_propDiff(base = base, ...)
  )
}





#' Split stingy limit_breaks into more parts per complete decade
#' @param v Vector on the unlogged scale to be examined and split
#' @inheritParams breaks_divMult
#'
#' @family {breaking}
#'
#' @return Vector with splits added
split_decades <- function(v, splits = c(0, 1, 2, 3, 4, 5, 10)){
  magic10 <- c(1.25, 1.6, 2, 2.5, 3.2, 4, 5, 6.4, 8)
  magic4 <- c(1.8, 3.2, 5.5)
	l <- length(v)
	w <- numeric(0)
	if (l>1) for (i in 1:(l-1)){
		w <- c(w, v[[i]])
		if (splits == 1) { return(c(w, v[[l]])) }
		if (v[[i + 1]] == 10 * v[[i]]) {
		  if (splits == 10) {w <- c(w, magic10*v[i])}
		  if (splits == 5) {w <- c(w, magic10[seq(2, 8, 2)]*v[i] ) }
		  if (splits == 4) {w <- c(w, magic4*v[i])}
		  if (splits == 3) {w <- c(w, 2*v[[i]], 5*v[[i]])}
		  if (splits == 2) {w <- c(w, 3*v[[i]])}
		  if (splits == 0 ){w <- v}
		}
	}
	return(c(w, v[[l]]))
}

#' Truncate log-scaled axis breaks to data range
#'
#' @inheritParams breaks_divMult
#' @param v Numeric vector, data or data range
#'
#' @family {breaking}
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
#' @family {breaking}
#'
#' @return Vector of values to generate axis breaks
#' @export
#'
#' @examples
#' y <- exp(seq(-2,5, length.out = 10))
#' v <- log(y) # log data or data range
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
#'      ggplot2::geom_hline(yintercept = 1, linewidth = 0.2) +
#'      ggplot2::scale_y_continuous(
#'      transform = "log"
#'      , breaks = breaks_divMult()
#'      , labels = label_divMult()
#'      )
#'
#' # custom breaks might still be needed when y-range is small
#' y2 <- seq(0.68, 2.2, length.out = 10)
#'
#' dat2 <- data.frame(x, y2)
#'
#' dat2 %>% ggplot2::ggplot(ggplot2::aes(x, y2))+
#'      ggplot2::geom_point()+
#'      ggplot2::geom_hline(yintercept = 1, linewidth = 0.2) +
#'      ggplot2::scale_y_continuous(
#'      transform = "log"
#'     # , breaks = breaks_divMult()
#'     , breaks = c(seq(0.4, 2.2, by = 0.2))
#'      , labels = label_divMult()
#'      )
#'
#'


breaks_divMult <- function(n = 6
                           , nmin = 5
                           , anchor = TRUE
                           , splits = 5
                           , base = exp(1)){
  function(v){
    if(anchor){v <- unique(c(v, 1))}
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
                         , n = bigticks
                         , splits = splits
                         , base = base)
    cut <- pmin(bigticks, 1+sum(main<small))
    if(cut <= nmin){
      other <- limit_breaks(c(0, small)
                                      , nmin
                                      , splits = splits
                                      , base = base)
    }
    else {other <- main[1:cut]}

    breaks <- c(main, 1/other)
    if (flip > pos) breaks <- 1/breaks
    return(sort(unique(breaks)))
  }
}








#' Parse flags for ratio scales
#' @inheritParams scale_y_ratio
#'
#' @return List of arguments to pass to scale_(x|y)_continuous()
#'
#' @noRd
#'
#'
trans_picker <- function(tickVal, ... ){
  if(tickVal %in% c("divmult", "divMult")){
    # if("slashStar" %in% names(list(...))){
    #   slashStar <- slashStar
    # }
    # else slashStar <- TRUE
    return(list(transform = doCall2(divMult_trans, args = list(...)), ...))
  }
  if(tickVal %in% c("nel", "Nel")){
    return(list(transform = doCall2(nel_trans, args = list(...)), ...)
    )
  }
  if(tickVal %in% c("centinel", "centiNel")){
    return(list(transform = doCall2(nel_trans, args = list(...))
                , labels = label_centiNel(), ...)
    )
  }
  if(tickVal %in% c("propDiff", "propdiff")){
    warning("'base = 2' chosen by defaut. Setting base of log affects breaking function behavior, and 'exp(1)' may give strange-looking numbers for the propDiff scale")
    return(list(transform = doCall2(propDiff_trans, args = list(base = 2, ...))
                                 , ...)
    )
  }
  if(tickVal %in% c("propDiff", "percDiff")){
    return(list(transform = doCall2(propDiff_trans, args = list(...))
                                 , labels = doCall2(label_percDiff
                                                    , args = list(...))
                                 , ...)
    )
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
#' @param tickVal Character, one of "divMult", "propDiff", "percDiff", "nel", or
#'   "centiNel"
#' @param ... Additional arguments passed to
#'    \code{\link[ggplot2]{scale_y_continuous}} or other scale elements (e.g.,
#'    breaks, labels, etc. )
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
#'
#' @examples

#'
#' smaller <- data.frame(x = 1:10, y = exp(seq(-0.2, 0.7, 0.1)))
#' bigger <- data.frame(x = 1:10, y = exp(-2:7))
#' ax2 <- ggplot2::sec_axis(
#'           labels = function(x) {x}
#'           , transform = ~.
#'           , breaks = breaks_divMult(n = 7, splits = 2)
#'           , name = "original scale"
#'         )
#'
#' bigger %>%  ggplot2::ggplot(ggplot2::aes(x,y)) +
#'      ggplot2::geom_point() +
#'      ggplot2::geom_hline(yintercept = 1, linewidth = 0.2) +
#'      scale_y_ratio(tickVal = "divMult"
#'      , slashStar = TRUE
#'      , sec.axis = ax2
#'      ) +
#'         ggplot2::labs(y = "divMult scale (fold change)")
#'
#' smaller %>%  ggplot2::ggplot(ggplot2::aes(x,y)) +
#'      ggplot2::geom_point() +
#'      scale_y_ratio(tickVal = "centiNel"
#'     , sec.axis = ax2
#'      ) +
#'         ggplot2::labs(y = "centiNels")
#'
#' # propDiff is a little strange
#' bigger %>%  ggplot2::ggplot(ggplot2::aes(x,y)) +
#'      ggplot2::geom_point() +
#'      scale_y_ratio(tickVal = "propDiff"
#'                    , sec.axis = ax2
#'         ) +
#'         ggplot2::labs(y = "propDiff (proportional difference) scale")
#'
#' # percDiff should be familiar
#' smaller %>%  ggplot2::ggplot(ggplot2::aes(x,y)) +
#'      ggplot2::geom_point() +
#'      scale_y_ratio(tickVal = "percDiff"
#'      , sec.axis = ax2) +
#'         ggplot2::labs(y = "propDiff (perentage difference) scale")
#'

#' @rdname scale_ratio
#' @concept {scales}
#' @export
scale_y_ratio <- function(tickVal = "divMult", ...){
  doCall2(ggplot2::scale_y_continuous
          , trans_picker(tickVal, ...))
}

#' @rdname scale_ratio
#' @concept {scales}
#' @export
scale_x_ratio <- function(tickVal = "divMult", ...){
  doCall2(ggplot2::scale_x_continuous
          , trans_picker(tickVal, ...))
}




#' Expand limits for symmetry on log scale
#'
#' @param v Numeric vector of length > 1, data range or limits
#'
#' @family {breaking}
#'
#' @return Numeric vector at least as long as v, with upper and lower range
#' limits symmetrical around 1 on log scale.
#'

#'
#' @export
#'
#' @examples
#'
#' limitimil(c(0.66, 2.1))
#' \dontrun{
#' imitimil(c (-1, 3))
#' }
#'
limitimil <- function(v){
  if(any(v<=0)){stop("range must be positive to produce symmetrical, log-scale limits")}
  outer = max(abs(log(v)))
  return(c(v, exp(-outer), exp(outer)))
}




