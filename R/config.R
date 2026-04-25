# =============================================================================
#  rcore user configuration
#  Stores author name and org abbreviation in a user-level config file so
#  every deployed template is personalised automatically.
# =============================================================================

#' Set up rcore with your author and organization details
#'
#' Run this once after installing rcore.  Your personal name, contact email,
#' and full organization name are stored in a user-level config file and used
#' automatically in:
#' \itemize{
#'   \item The \code{author:} field of every template deployed by
#'         \code{\link{rcore_templates}} — filled with the full organization
#'         name.
#'   \item The footer of every rendered HTML report (personal author name +
#'         contact email injected by \code{\link{rcore_inject_css}}).
#'   \item The org-specific template sub-folder lookup — the abbreviation is
#'         derived automatically from the initials of each word in
#'         \code{org_name} (e.g. \code{"Center for Translational Neuroscience"}
#'         becomes \code{"ctn"}).
#' }
#'
#' @param author Your personal full name shown in the report footer
#'   (e.g. \code{"Jane Smith"}).
#' @param email Contact email address shown in the report footer.  Leave
#'   \code{NULL} to be prompted interactively, or supply \code{""} to omit the
#'   email from footers.
#' @param org_name Full organization name that will appear in the
#'   \code{author:} field of every deployed template
#'   (e.g. \code{"Awesome Bioinformatics Lab"}).  Leave \code{NULL} to be
#'   prompted interactively.  The abbreviation used for template folder lookup
#'   is derived automatically from the initials of each word.
#'
#' @return Invisibly returns a named list with \code{author}, \code{email},
#'   \code{org_name}, and \code{org_abbr}.
#'
#' @examples
#' \donttest{
#'   rcore_setup(author   = "Jane Smith",
#'               email    = "jane@example.com",
#'               org_name = "Awesome Bioinformatics Lab")
#' }
#' @export
rcore_setup <- function(author = NULL, email = NULL, org_name = NULL) {

  # ---- personal author ------------------------------------------------------
  if (is.null(author)) {
    author <- trimws(readline("Your full name (shown in report footer): "))
  }
  author <- trimws(author)
  if (nchar(author) == 0L)
    stop("Author name cannot be empty.")

  # ---- email ----------------------------------------------------------------
  if (is.null(email)) {
    email <- trimws(readline("Contact email (shown in report footer, leave blank to skip): "))
  }

  # ---- organization name ----------------------------------------------------
  if (is.null(org_name)) {
    org_name <- trimws(readline("Full organization name (shown as author in templates): "))
  }
  org_name <- trimws(org_name)
  if (nchar(org_name) == 0L)
    stop("Organization name cannot be empty.")

  # ---- derive abbreviation from initials of each word ----------------------
  words     <- strsplit(org_name, "\\s+")[[1L]]
  org_abbr  <- tolower(paste(substr(words, 1L, 1L), collapse = ""))
  org_abbr  <- gsub("[^a-z0-9]", "", org_abbr)   # keep only alphanumeric

  # ---- write config ---------------------------------------------------------
  config_dir  <- tools::R_user_dir("rcore", "config")
  dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
  config_path <- file.path(config_dir, "config.dcf")

  write.dcf(
    data.frame(Author  = author,
               Email   = email,
               OrgName = org_name,
               OrgAbbr = org_abbr,
               stringsAsFactors = FALSE),
    file = config_path
  )

  usethis::ui_done("rcore configured")
  usethis::ui_info("  Author   : {usethis::ui_value(author)}")
  if (nchar(email) > 0L)
    usethis::ui_info("  Email    : {usethis::ui_value(email)}")
  usethis::ui_info("  Org name : {usethis::ui_value(org_name)}")
  usethis::ui_info("  Org abbr : {usethis::ui_value(org_abbr)}  (derived from initials)")
  usethis::ui_info("  Saved    : {usethis::ui_value(config_path)}")
  usethis::ui_info(paste0(
    "Templates deployed with rcore_templates() will now use ",
    "{usethis::ui_value(org_name)} as the report author."
  ))

  invisible(list(author = author, email = email,
                 org_name = org_name, org_abbr = org_abbr))
}

#' View the current rcore configuration
#'
#' Returns the configuration stored by \code{\link{rcore_setup}}.
#' Returns \code{NULL} silently if no configuration has been set yet.
#'
#' @return A named list with elements \code{author}, \code{email},
#'   \code{org_name}, and \code{org_abbr}, or \code{NULL}.
#'
#' @examples
#' # Returns NULL if rcore_setup() has not been called yet
#' cfg <- rcore_get_config()
#' is.null(cfg) || is.list(cfg)  # TRUE either way
#'
#' @export
rcore_get_config <- function() {
  config_path <- file.path(tools::R_user_dir("rcore", "config"), "config.dcf")
  if (!file.exists(config_path)) return(NULL)
  cfg <- tryCatch(
    as.list(read.dcf(config_path)[1L, ]),
    error = function(e) NULL
  )
  if (is.null(cfg)) return(NULL)
  names(cfg) <- tolower(names(cfg))
  cfg
}

# Internal: stored org abbreviation, or NULL if no config set
.rcore_org <- function() {
  cfg <- rcore_get_config()
  if (is.null(cfg)) return(NULL)
  cfg[["orgabbr"]]
}

# Internal: full org name for template author field, or HBC as fallback
.rcore_author <- function() {
  cfg <- rcore_get_config()
  if (is.null(cfg)) return("Harvard Chan Bioinformatics Core")
  # Use full org name if available; fall back to personal author name
  org <- cfg[["orgname"]]
  if (!is.null(org) && nzchar(org)) org else cfg[["author"]]
}

# Internal: replace grafify/kelly colour calls with rcore equivalents in all
# Rmd/qmd files under `path`. Handles three patterns found in the bcbio
# rnaseq-reports templates:
#   1. scale_colour_discrete / scale_fill_discrete overrides using grafify kelly
#   2. Explicit scale_color_grafify(palette = "kelly") calls
#   3. Raw grafify:::graf_palettes[["kelly"]] vector references
# Also swaps theme_prism for theme_rcore and removes the now-unneeded
# library(grafify) / library(ggprism) calls.
.patch_template_colors <- function(path) {
  tmpl_files <- tryCatch(
    c(fs::dir_ls(path, recurse = TRUE, regexp = "\\.[Rr]md$|\\.[Qq]md$")),
    error = function(e) character(0)
  )

  for (f in tmpl_files) {
    txt <- paste(readLines(f, warn = FALSE), collapse = "\n")
    original <- txt

    # 1. scale_colour_discrete function body using grafify kelly
    txt <- gsub(
      "scale_colour_discrete\\s*<-\\s*function\\s*\\(\\.\\.\\.\\)\\s*\\{[^}]+grafify[^}]+\\}",
      "scale_colour_discrete <- function(...) rcore::scale_color_cb_friendly(...)",
      txt, perl = TRUE
    )

    # 2. scale_fill_discrete function body using grafify kelly
    txt <- gsub(
      "scale_fill_discrete\\s*<-\\s*function\\s*\\(\\.\\.\\.\\)\\s*\\{[^}]+grafify[^}]+\\}",
      "scale_fill_discrete   <- function(...) rcore::scale_fill_cb_friendly(...)",
      txt, perl = TRUE
    )

    # 3. Explicit scale_color_grafify() calls (both named and positional arg)
    txt <- gsub(
      'scale_color_grafify\\(palette\\s*=\\s*"kelly"\\)',
      "rcore::scale_color_cb_friendly()",
      txt, perl = TRUE
    )
    txt <- gsub(
      'scale_color_grafify\\("kelly"\\)',
      "rcore::scale_color_cb_friendly()",
      txt, perl = TRUE
    )

    # 4. Raw grafify kelly vector (used for catCols, l.col, colors, etc.)
    txt <- gsub(
      'grafify:::graf_palettes\\[\\["kelly"\\]\\]',
      'unname(rcore::cb_friendly_pal("main")(20))',
      txt, perl = TRUE
    )

    # 5. Replace theme_prism with theme_rcore
    txt <- gsub(
      "ggplot2::theme_set\\(theme_prism\\([^)]*\\)\\)",
      "ggplot2::theme_set(rcore::theme_rcore())",
      txt, perl = TRUE
    )

    # 6. Remove library(grafify) and library(ggprism) — no longer needed
    txt <- gsub("^library\\(grafify\\)[[:blank:]]*\\n?", "", txt, perl = TRUE)
    txt <- gsub("^library\\(ggprism\\)[[:blank:]]*\\n?",  "", txt, perl = TRUE)

    if (!identical(txt, original)) {
      writeLines(strsplit(txt, "\n", fixed = TRUE)[[1]], f)
    }
  }
  invisible(NULL)
}

# Internal: replace the {{rcore_author}} placeholder in all deployed Rmd/qmd
# files under `path` with the stored author name.
.replace_author_in_templates <- function(path, author) {
  rmd_files <- tryCatch(
    c(fs::dir_ls(path, recurse = TRUE, regexp = "\\.[Rr]md$|\\.[Qq]md$")),
    error = function(e) character(0)
  )

  for (f in rmd_files) {
    txt <- readLines(f, warn = FALSE)
    updated <- gsub(
      "\\{\\{rcore_author\\}\\}",
      author,
      txt, perl = TRUE
    )
    if (!identical(txt, updated)) writeLines(updated, f)
  }
  invisible(NULL)
}
