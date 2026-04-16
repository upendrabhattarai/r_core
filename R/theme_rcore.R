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
#' @importFrom ggplot2 %+replace%
#' @export
#'
#' @examples
#' \donttest{
#'   library(ggplot2)
#'   ggplot(mtcars, aes(wt, mpg)) +
#'     geom_point() +
#'     theme_rcore()
#' }
theme_rcore <- function(base_size = 13, base_family = "sans", ...) {
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


#' Inject rcore CSS styles and report footer into an HTML R Markdown document
#'
#' Call this function inside a setup chunk (with `results = 'asis'`) to embed
#' the rcore visual theme into the rendered HTML report.  The function:
#' \enumerate{
#'   \item Reads \code{inst/css/rcore_styles.css} from the installed package
#'         and writes a \code{<style>} block into the document.
#'   \item Appends a professional footer showing the author/organization name
#'         and contact email stored by \code{\link{rcore_setup}}.  If no
#'         config has been set, the footer is omitted silently.
#' }
#'
#' @return Invisibly returns the CSS string; called for its side-effect of
#'   writing HTML to stdout.
#' @export
#'
#' @examples
#' \donttest{
#'   # In an R Markdown setup chunk:
#'   # ```{r rcore-css, echo=FALSE, results='asis'}
#'   # rcore::rcore_inject_css()
#'   # ```
#' }
rcore_inject_css <- function() {
  # ---- CSS ------------------------------------------------------------------
  css_path <- system.file("css", "rcore_styles.css", package = "rcore")
  if (!nzchar(css_path)) {
    warning("rcore: CSS file not found. Re-install the package.")
    return(invisible(NULL))
  }
  css <- paste(readLines(css_path, warn = FALSE), collapse = "\n")
  cat(sprintf("<style>\n%s\n</style>\n", css))

  # ---- Footer ---------------------------------------------------------------
  cfg <- rcore_get_config()

  # Build footer pieces
  author_str <- if (!is.null(cfg) && nzchar(cfg[["author"]])) {
    cfg[["author"]]
  } else {
    NULL
  }

  email_str <- if (!is.null(cfg) &&
                   !is.null(cfg[["email"]]) &&
                   nzchar(trimws(cfg[["email"]]))) {
    cfg[["email"]]
  } else {
    NULL
  }

  # Only inject footer if we have at least an author
  if (!is.null(author_str)) {
    email_html <- if (!is.null(email_str)) {
      sprintf(
        '<span class="rcore-footer-email">&nbsp;&bull;&nbsp;<a href="mailto:%s">%s</a></span>',
        email_str, email_str
      )
    } else {
      ""
    }

    footer_html <- sprintf(
      '<script>
(function() {
  var footer = document.createElement("div");
  footer.className = "rcore-footer";
  footer.innerHTML = \'<div class="rcore-footer-left"><span class="rcore-footer-badge">rcore</span><span class="rcore-footer-author">%s</span>%s</div><div class="rcore-footer-right">Generated with <a href="https://github.com/upendrabhattarai/r_core" target="_blank">rcore</a> &middot; \'+ new Date().getFullYear() +\'</div>\';
  function appendFooter() {
    var mc = document.querySelector(".main-container");
    if (mc) { mc.appendChild(footer); }
    else { document.body.appendChild(footer); }
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", appendFooter);
  } else {
    appendFooter();
  }
})();
</script>',
      author_str,
      email_html
    )
    cat(footer_html)
  }

  invisible(css)
}
