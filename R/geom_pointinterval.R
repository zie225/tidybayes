# Like a geom_pointrange but with sensible defaults for displaying multiple intervals
#
# Author: mjskay
###############################################################################


# Names that should be suppressed from global variable check by codetools
# Names used broadly should be put in _global_variables.R
globalVariables(c(".lower", ".upper", ".width"))


#' Point + multiple probability interval plots (ggplot geom)
#'
#' Combined point + multiple interval geoms with default aesthetics
#' designed for use with output from \code{\link{point_interval}}.
#' Wrapper around \code{\link{geom_slabinterval}}.
#'
#' These geoms are wrappers around \code{\link{geom_slabinterval}} with defaults designed to produce
#' points+interval plots. These geoms set some default aesthetics equal
#' to the \code{.lower}, \code{.upper}, and \code{.width} columns generated by the \code{point_interval} family
#' of functions, making them often more convenient than vanilla \code{\link{geom_pointrange}} when used with
#' functions like \code{\link{median_qi}}, \code{\link{mean_qi}}, \code{\link{mode_hdi}}, etc.
#'
#' Specifically, \code{geom_pointinterval} acts as if its default aesthetics are
#' \code{aes(ymin = .lower, ymax = .upper, size = -.width)}. \code{geom_pointintervalh} acts as if its default
#' aesthetics are \code{aes(xmin = .lower, xmax = .upper, size = -.width)}.
#'
#' @eval rd_slabinterval_aesthetics(geom = GeomPointinterval, geom_name = "geom_pointinterval")
#' @inheritParams geom_slabinterval
#' @param position The position adjustment to use for overlapping points on this layer. Setting this equal to
#' \code{"dodge"} or \code{"dodgev"} (if the \code{ggstance} package is loaded) can be useful if you have
#' overlapping intervals.
#' @param show.legend Should this layer be included in the legends? Default is \code{c(size = FALSE)}, unlike most geoms,
#' to match its common use cases. \code{FALSE} hides all legends, \code{TRUE} shows all legends, and \code{NA} shows only
#' those that are mapped (the default for most geoms).
#' @author Matthew Kay
#' @seealso See \code{\link{geom_slabinterval}} for the geom that these geoms wrap. All parameters of that geom are
#' available to these geoms.
#' @seealso See \code{\link{stat_pointinterval}} / \code{\link{stat_pointintervalh}} for the stat versions, intended
#' for use on samples from a distribution.
#' See \code{\link{geom_interval}} / \code{\link{geom_intervalh}} for a similar stat intended for intervals without
#' point summaries.
#' See \code{\link{stat_sample_slabinterval}} for a variety of other
#' stats that combine intervals with densities and CDFs.
#' See \code{\link{geom_slabinterval}} for the geom that these geoms wrap. All parameters of that geom are
#' available to these geoms.
#' @examples
#'
#' library(magrittr)
#' library(ggplot2)
#'
#' data(RankCorr, package = "tidybayes")
#'
#' RankCorr %>%
#'   spread_draws(u_tau[i]) %>%
#'   median_qi(.width = c(.8, .95)) %>%
#'   ggplot(aes(y = i, x = u_tau)) +
#'   geom_pointintervalh()
#'
#' RankCorr %>%
#'   spread_draws(u_tau[i]) %>%
#'   median_qi(.width = c(.8, .95)) %>%
#'   ggplot(aes(x = i, y = u_tau)) +
#'   geom_pointinterval()
#'
#' @import ggplot2
#' @export
geom_pointinterval = function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,

  side = "both",
  orientation = "vertical",
  show_slab = FALSE,

  show.legend = c(size = FALSE)
) {

  layer_geom_slabinterval(
    data = data,
    mapping = mapping,
    default_mapping = aes(ymin = .lower, ymax = .upper, size = -.width),
    stat = stat,
    geom = GeomPointinterval,
    position = position,
    ...,

    side = side,
    orientation = orientation,
    show_slab = show_slab,

    datatype = "interval",

    show.legend = show.legend
  )
}

#' @rdname tidybayes-ggproto
#' @format NULL
#' @usage NULL
#' @import ggplot2
#' @export
GeomPointinterval = ggproto("GeomPointinterval", GeomSlabinterval,
  default_aes = defaults(aes(
    datatype = "interval"
  ), GeomSlabinterval$default_aes),

  default_key_aes = defaults(aes(
    fill = NA
  ), GeomSlabinterval$default_key_aes),

  default_params = defaults(list(
    side = "both",
    orientation = "vertical",
    show_slab = FALSE
  ), GeomSlabinterval$default_params),

  default_datatype = "interval"
)
