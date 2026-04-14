#' rcore ggplot2 theme
#'
#' A clean, modern ggplot2 theme for rcore HTML reports.
#' Uses teal and rose accent colours consistent with the rcore colour palette.
#'
#' @param base_size Base font size (default 13).
#' @param base_family Base font family (default "sans").
#' @param ... Additional arguments passed to [ggplot2::theme()].
#'
#' @return A ggplot2 theme object.
#' @export
#'
#' @examples
#' \dontrun{
#'   library(ggplot2)
#'   ggplot(mtcars, aes(wt, mpg)) +
#'     geom_point() +
#'     theme_bcbio()
#' }
theme_bcbio <- function(base_size = 13, base_family = "sans", ...) {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    ggplot2::theme(
      # ---- Panel ----
      panel.background  = ggplot2::element_rect(fill = "#FAFAFA", color = NA),
      panel.border      = ggplot2::element_rect(fill = NA, color = "#E2E8F0",
                                                linewidth = 0.5),
      panel.grid.major  = ggplot2::element_line(color = "#E2E8F0", linewidth = 0.4),
      panel.grid.minor  = ggplot2::element_line(color = "#F1F5F9", linewidth = 0.25),
      panel.spacing     = ggplot2::unit(0.8, "lines"),

      # ---- Axes ----
      axis.title        = ggplot2::element_text(size  = ggplot2::rel(0.88),
                                                color = "#374151",
                                                face  = "bold"),
      axis.title.x      = ggplot2::element_text(margin = ggplot2::margin(t = 8)),
      axis.title.y      = ggplot2::element_text(margin = ggplot2::margin(r = 8),
                                                angle  = 90),
      axis.text         = ggplot2::element_text(size  = ggplot2::rel(0.80),
                                                color = "#6B7280"),
      axis.ticks        = ggplot2::element_line(color = "#CBD5E1", linewidth = 0.4),
      axis.line         = ggplot2::element_line(color = "#CBD5E1", linewidth = 0.4),

      # ---- Legend ----
      legend.background = ggplot2::element_rect(fill  = "white",
                                                color = "#E2E8F0",
                                                linewidth = 0.3),
      legend.key        = ggplot2::element_rect(fill  = "white", color = NA),
      legend.title      = ggplot2::element_text(size  = ggplot2::rel(0.85),
                                                face  = "bold",
                                                color = "#374151"),
      legend.text       = ggplot2::element_text(size  = ggplot2::rel(0.80),
                                                color = "#4B5563"),
      legend.position   = "right",
      legend.margin     = ggplot2::margin(6, 6, 6, 6),

      # ---- Facet strips ----
      strip.background  = ggplot2::element_rect(fill  = "#0D9488", color = NA),
      strip.text        = ggplot2::element_text(color = "white",
                                                face  = "bold",
                                                size  = ggplot2::rel(0.85)),

      # ---- Plot titles ----
      plot.title        = ggplot2::element_text(size   = ggplot2::rel(1.10),
                                                face   = "bold",
                                                color  = "#006B6B",
                                                hjust  = 0,
                                                margin = ggplot2::margin(b = 6)),
      plot.subtitle     = ggplot2::element_text(size   = ggplot2::rel(0.90),
                                                color  = "#6B7280",
                                                hjust  = 0,
                                                margin = ggplot2::margin(b = 8)),
      plot.caption      = ggplot2::element_text(size   = ggplot2::rel(0.75),
                                                color  = "#9CA3AF",
                                                hjust  = 1,
                                                margin = ggplot2::margin(t = 8)),

      # ---- Plot background & margins ----
      plot.background   = ggplot2::element_rect(fill  = "white", color = NA),
      plot.margin       = ggplot2::margin(t = 12, r = 14, b = 12, l = 12),

      complete = TRUE,
      ...
    )
}


#' Inject rcore CSS styles into an HTML R Markdown document
#'
#' Call this function inside a setup chunk (with `results = 'asis'`) to embed
#' the rcore visual theme into the rendered HTML report.  The function reads
#' `inst/css/bcbio_styles.css` from the installed package and writes a
#' `<style>` block directly into the document.
#'
#' @return Invisibly returns the CSS string; called for its side-effect of
#'   writing to stdout.
#' @export
#'
#' @examples
#' \dontrun{
#'   # In an R Markdown setup chunk, use:
#'   # ```{r bcbio-css, echo=FALSE, results='asis'}
#'   # rcore::bcbio_inject_css()
#'   # ```
#' }
bcbio_inject_css <- function() {
  css_path <- system.file("css", "bcbio_styles.css", package = "rcore")
  if (!nzchar(css_path)) {
    warning("rcore: CSS file not found. Re-install the package.")
    return(invisible(NULL))
  }
  css <- paste(readLines(css_path, warn = FALSE), collapse = "\n")
  cat(sprintf("<style>\n%s\n</style>\n", css))
  invisible(css)
}
