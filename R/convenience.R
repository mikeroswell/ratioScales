# convenience functions for ratioScales

#' Rescale variables to start values by group
#'
#' Convenience wrapper of \code{dplyr::group_by} and \code{dplyr::mutate} to
#' scale variables, especially time-series, by series start values
#'
#' @param df data.frame
#' @param col_vars variable names (quoted or unquoted) to rescale to initial
#' values
#' @param group_vars variable names (quoted or unquoted) to group `col_vars` by
#'
#'
#' @concept convenience
#' @return data.frame with all original data and new `rel_` columns for each
#' rescaled variable
#' @export
#'

#'
#' @examples
#' test_df <- data.frame(grp = rep(1:3, each = 10)
#' , val = rep(10:1, times = 3))
#'
#'
#' test_df %>%
#'   rel_start(col_vars = val, group_vars = grp) %>%
#'   print(n = 30)
#'
#' test_df %>%
#'   rel_start(col_vars = "val", group_vars = "grp") %>%
#'   print(n = 30)

rel_start <- function(df, col_vars, group_vars){
  df %>%
    dplyr::group_by(dplyr::pick({{ group_vars }})) %>%
    dplyr::mutate(dplyr::across({{col_vars}}
                                ,  .fns = function(x){
                                  x/dplyr::first(x, na_rm = TRUE)
                                  }
                                , .names = "rel_{.col}"))

}



