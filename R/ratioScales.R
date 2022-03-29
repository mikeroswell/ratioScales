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


#' Compute breaks for ratio scale
#'
#' Function to compute tick marks evenly spaced on the log scale but with pretty
#' numbers on the ratio scale (DEPRECATED, USE divmultbreaks)
#'
#' @param base Scalar, base of the logarithm in use (not implemented)
#' @param n scalar, target number of breaks (not implemented)
#'
#'
#' @return Function to apply over a vector of values to generate axis breaks
#' @noRd
#'
#' @examples
#' ggplot2::ggplot(data = data.frame(x= 1:6, y = seq(-1, 1.5, 0.5))
#'        , ggplot2::aes(x, y))+
#'              ggplot2::geom_point()+
#'              ggplot2::scale_y_continuous(
#'              , breaks = rat_breaks()
#'              ) +
#'              ggplot2::geom_hline(yintercept = 0, size = 0.2)



rat_breaks <- function( base = exp(1), n = 5){
  function(x){
    largest_integer = floor(exp(max(abs(x))))
    if(largest_integer >=2){
      one_side = log(floor(seq(exp(seq(-max(abs(x)),  max(abs(x)), log(5^(1/4)))))))
      both_sides = c(one_side, -one_side)
      trun = sort(unique(c(-log(2)
               , both_sides[ifelse(min(x)<0, min(x), -1) < both_sides &
                              both_sides < ifelse(max(both_sides) >0
                                                  , 1.1 *max(both_sides), 2)]
               , log(2))))
      thnnd = sort(unique(c(0, trun[seq.int(1, length(trun), length.out = n)])))
      br = c(thnnd[2:length(thnnd)-1], max(trun[length(trun)], thnnd[length(thnnd)]), min(thnnd[1], trun[1]))
      }
    if(largest_integer <2){
     g<- round(log10(max(abs(x))))
     z<-ifelse(g ==0, -1, g)

      if(-sign(max(x))==sign(min(x))|max(x)==0){
        br = log(c( 1, 1+15*10^z, 1+5*10^z, 1/ (1+15*10^z), 1/(1+5*10^z)))
      }
      else{br = sign(max(x)) *
        log(c( 1, 5*10^z, 2*10^z, 10^z, 5*10^(z+1)))}
      # not sure it will see these little numbers
    }
    return(sort(unique(br)))
  }
}


exp(rat_breaks()(c(-2,4)))
exp(rat_breaks()(c(-2,1)))
exp(rat_breaks()(c(-2,7)))
exp(rat_breaks()(c(-2,1.2)))
exp(rat_breaks()(c(-0.4,0)))
exp(rat_breaks()(c(-1.5,0)))
exp(rat_breaks()(c(-0.7, -0.3)))
exp(rat_breaks()(c(-0.1, -0.3)))
exp(rat_breaks()(c(0.1, 0.3)))
exp(rat_breaks()(c(-0.1, 0.3)))

#' Compute breaks for ratio scale
#'
#' @param v Numeric vector
#' @param n Scalar, target number of breaks
#' @param nmin Scalar, forced minimum number of breaks
#' @param anchor Logical, include origin (1 on the ratio scale)
#'
#' @return Vector of values to generate axis breaks
#' @export
#'
#' @examples
#' divmultBreaks(c(11))
#' divmultBreaks(c(0.04))
#' divmultBreaks(c(0.04, 11))
#' divmultBreaks(c(0.02, 2))
#' divmultBreaks(c(0.8, 20))

divmultBreaks <- function(v, n = 6, nmin = 3, anchor=TRUE){
  if (anchor) v <- unique(c(v, 1))
  v <- log(v)
  neg <- min(v)
  if (neg == 0) return(grDevices::axisTicks(nint=n, log=TRUE, usr=range(v)))
  pos <- max(v)
  if (pos == 0) return(1/grDevices::axisTicks(nint=n, log=TRUE, usr=-range(v)))

  flip <- -neg
  big <- pmax(pos, flip)
  small <- pmin(pos, flip)
  bigprop <- big/(pos + flip)
  bigticks <- ceiling(n*bigprop)

  draft <- grDevices::axisTicks(nint = bigticks, log = TRUE, usr = c(0, big))
  # New: truncate the breaks beyond 1 after the biggest value in data
  os <- min(draft[log(draft)>big])
  main <- draft[draft<=os]
  edge <- pmin(bigticks, 1+sum(main<small))
  if(edge<nmin){
    other_d <- grDevices::axisTicks(nint = nmin, log = TRUE, usr = c(0, small))
    # New: truncate the breaks beyond 1 after biggest data value
    os2 <- min(other_d[log(other_d)>small])
    other <- other_d[other_d<=os2]
  }
  else{
    other <- main[1:edge]}
  # New: don't act weird if big == small
  if(big == small){other <- main}

  breaks <- c(main, 1/other)
  if (flip > pos) breaks <- 1/breaks
  return(sort(unique(breaks)))
}

#' Idiomatic breaking function for ggplot
#'
#' @param n Integer, target number of breaks
#' @param ... Additional arguments passed to divmultBreaks
#'
#' @return A function that takes a vector (e.g. range of data) as an argument
#' and returns values for breaks on a log scale, but with original scale values
#' @export
#'
#' @examples
#' breaks_divmult()(exp(seq(0,5,0.2)))
breaks_divmult <- function(n = 6, ...){
  function(x, n=n, ...){
    breaks <- divmultBreaks(v = range(x), ...)
    breaks
  }
}

# I think I might like how rat_breaks handles things better

# rat_breaks takes pre-logged values
# breaks_divmult takes the log internally

# nice to see numbers like 0.5, 2, 20 (5 might be preferable to 7, but 7's not terrible)
exp(rat_breaks()(seq(0,5,0.2)))
# 1e5 seems useless; I want breaks inside my data
breaks_divmult()(exp(seq(0,5,0.2)))


