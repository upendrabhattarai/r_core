# rcore colorblind-friendly palette
# Redesigned with teal, rose/pink, and complementary accent colours.
# All hues are distinguishable for the most common forms of colour-blindness
# (deuteranopia / protanopia) because the palette relies on blue-teal vs
# pink-coral contrast rather than red vs green contrast.

cb_friendly_colors <- c(
  # ---- Teals ----
  `deep_teal`    = "#006B6B",   # rich, dark teal
  `teal`         = "#0D9488",   # main brand teal
  `light_teal`   = "#5EEAD4",   # mint / light teal

  # ---- Pinks & roses ----
  `deep_rose`    = "#BE185D",   # deep rose / fuchsia
  `hot_pink`     = "#EC4899",   # vibrant hot pink
  `blush`        = "#F9A8D4",   # soft blush

  # ---- Purples & blues ----
  `indigo`       = "#4F46E5",   # rich indigo
  `lavender`     = "#A78BFA",   # soft lavender
  `sky`          = "#38BDF8",   # bright sky blue

  # ---- Warm accents ----
  `amber`        = "#F59E0B",   # warm amber / gold
  `coral`        = "#FB7185",   # coral (bridges pink & warm)
  `sand`         = "#D97706",   # dark amber / sand

  # ---- Greens & neutrals ----
  `forest`       = "#059669",   # forest green
  `charcoal`     = "#374151",   # near-black
  `steel`        = "#94A3B8",   # blue-grey steel
  `white`        = "#FFFFFF"
)

#' List all rcore colorblind-friendly colours
#'
#' Returns a named character vector of all available colours and their hex codes.
#'
#' @export
list_cb_friendly_cols <- function() {
  return(cb_friendly_colors)
}

#' Fetch one or more colours by name
#'
#' @param ... One or more colour names (unquoted or quoted strings).
#'   Use [list_cb_friendly_cols()] to see all available names.
#'
#' @return Named character vector of hex colour codes.
#' @export
cb_friendly_cols <- function(...) {
  cols <- c(...)
  if (is.null(cols))
    return(cb_friendly_colors)
  unknown <- cols[!cols %in% names(cb_friendly_colors)]
  if (length(unknown) > 0L)
    stop("Unknown colour name(s): ", paste(unknown, collapse = ", "),
         ". Use list_cb_friendly_cols() to see all available names.")
  cb_friendly_colors[cols]
}

# ---- Named palettes ------------------------------------------------------------

cb_friendly_palettes <- list(
  # General-purpose: covers all 16 hues in a visually balanced order
  `main` = cb_friendly_cols(
    "teal", "hot_pink", "indigo", "amber",
    "coral", "lavender", "sky", "deep_rose",
    "forest", "sand", "light_teal", "charcoal",
    "steel", "blush", "deep_teal"
  ),

  # Cool blues & teals
  `teal` = cb_friendly_cols("deep_teal", "teal", "light_teal", "sky"),

  # Pinks & roses
  `rose` = cb_friendly_cols("deep_rose", "hot_pink", "coral", "blush"),

  # Cool purples & blues
  `cool` = cb_friendly_cols("indigo", "lavender", "deep_teal", "sky"),

  # Warm ambers & corals
  `warm` = cb_friendly_cols("amber", "coral", "sand", "hot_pink"),

  # Greyscale-ish neutrals
  `grey` = cb_friendly_cols("charcoal", "steel", "light_teal"),

  # Diverging heatmap: rose → white → teal
  `heatmap` = cb_friendly_cols("deep_rose", "white", "deep_teal"),

  # Sequential: white → teal
  `white_to_teal` = cb_friendly_cols("white", "teal")
)

#' Build a colour-ramp palette function
#'
#' @param palette Name of the palette: `"main"` (default), `"teal"`, `"rose"`,
#'   `"cool"`, `"warm"`, `"grey"`, `"heatmap"`, or `"white_to_teal"`.
#' @param reverse Logical; reverse the colour order? Default `FALSE`.
#' @param ... Passed to [grDevices::colorRampPalette()].
#'
#' @return A colour-ramp function (as returned by [grDevices::colorRampPalette()]).
#' @export
cb_friendly_pal <- function(palette = "main", reverse = FALSE, ...) {
  pal <- cb_friendly_palettes[[palette]]
  if (is.null(pal))
    stop("Unknown palette '", palette, "'. ",
         "Choose from: ", paste(names(cb_friendly_palettes), collapse = ", "))
  if (reverse) pal <- rev(pal)
  colorRampPalette(pal, ...)
}

#' ggplot2 colour scale using rcore palette
#'
#' @param palette See [cb_friendly_pal()].
#' @param discrete Logical; discrete (`TRUE`, default) or continuous scale?
#' @param reverse Logical; reverse colour order? Default `FALSE`.
#' @param ... Passed to [ggplot2::discrete_scale()] or
#'   [ggplot2::scale_color_gradientn()].
#'
#' @export
scale_color_cb_friendly <- function(palette = "main", discrete = TRUE,
                                    reverse = FALSE, ...) {
  pal <- cb_friendly_pal(palette = palette, reverse = reverse)
  if (discrete) {
    ggplot2::discrete_scale("colour", palette = pal, ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
}

#' ggplot2 fill scale using rcore palette
#'
#' @param palette See [cb_friendly_pal()].
#' @param discrete Logical; discrete (`TRUE`, default) or continuous scale?
#' @param reverse Logical; reverse colour order? Default `FALSE`.
#' @param ... Passed to [ggplot2::discrete_scale()] or
#'   [ggplot2::scale_fill_gradientn()].
#'
#' @export
scale_fill_cb_friendly <- function(palette = "main", discrete = TRUE,
                                   reverse = FALSE, ...) {
  pal <- cb_friendly_pal(palette = palette, reverse = reverse)
  if (discrete) {
    ggplot2::discrete_scale("fill", palette = pal, ...)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}
