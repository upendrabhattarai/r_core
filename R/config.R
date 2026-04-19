# =============================================================================
#  rcore user configuration
#  Stores author name and org abbreviation in a user-level config file so
#  every deployed template is personalised automatically.
# =============================================================================

#' Set up rcore with your author and organization details
#'
#' Run this once after installing rcore.  The name, email, and abbreviation you
#' provide are stored in a user-level config file and used automatically in:
#' \itemize{
#'   \item The \code{author:} field of every Rmd template deployed by
#'         \code{\link{rcore_templates}}.
#'   \item The footer of every rendered HTML report (author name + contact
#'         email injected by \code{\link{rcore_inject_css}}).
#'   \item The default \code{org} folder lookup inside template directories
#'         (replaces the hard-coded \code{"hcbc"} default).
#' }
#'
#' @param author Full author or organization name that will appear in report
#'   YAML headers and the report footer (e.g. \code{"Jane Smith"} or
#'   \code{"Awesome Bioinformatics Lab"}).
#' @param email Contact email address shown in the report footer.  Leave
#'   \code{NULL} to be prompted interactively, or supply \code{""} to omit the
#'   email from footers.
#' @param org_abbr Short lower-case abbreviation used to match org-specific
#'   template sub-folders (e.g. \code{"mylab"}).  Defaults to the first 8
#'   alphanumeric characters of \code{author} if left \code{NULL}.
#'
#' @return Invisibly returns a named list with \code{author}, \code{email},
#'   and \code{org_abbr}.
#'
#' @examples
#' \donttest{
#'   rcore_setup(author = "Jane Smith",
#'               email  = "jane@example.com",
#'               org_abbr = "mylab")
#' }
#' @export
rcore_setup <- function(author = NULL, email = NULL, org_abbr = NULL) {

  # ---- author ---------------------------------------------------------------
  if (is.null(author)) {
    author <- readline(
      "Author / organization name (shown in report headers): "
    )
  }
  author <- trimws(author)
  if (nchar(author) == 0L)
    stop("Author name cannot be empty.")

  # ---- email ----------------------------------------------------------------
  if (is.null(email)) {
    entered_email <- trimws(readline("Contact email (shown in report footer, leave blank to skip): "))
    email <- entered_email
  }

  # ---- org abbreviation -----------------------------------------------------
  if (is.null(org_abbr)) {
    default_abbr <- substr(tolower(gsub("[^a-zA-Z0-9]", "", author)), 1L, 8L)
    prompt <- sprintf(
      "Short org abbreviation for template folders [%s]: ", default_abbr
    )
    entered <- trimws(readline(prompt))
    org_abbr <- if (nchar(entered) == 0L) default_abbr else entered
  }
  org_abbr <- tolower(gsub("[^a-zA-Z0-9_]", "", org_abbr))

  # ---- write config ---------------------------------------------------------
  config_dir  <- tools::R_user_dir("rcore", "config")
  dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
  config_path <- file.path(config_dir, "config.dcf")

  write.dcf(
    data.frame(Author  = author,
               Email   = email,
               OrgAbbr = org_abbr,
               stringsAsFactors = FALSE),
    file = config_path
  )

  usethis::ui_done("rcore configured")
  usethis::ui_info("  Author : {usethis::ui_value(author)}")
  if (nchar(email) > 0L)
    usethis::ui_info("  Email  : {usethis::ui_value(email)}")
  usethis::ui_info("  Org    : {usethis::ui_value(org_abbr)}")
  usethis::ui_info("  Saved  : {usethis::ui_value(config_path)}")
  usethis::ui_info(paste0(
    "Templates deployed with rcore_templates() will now use ",
    "{usethis::ui_value(author)} as the report author."
  ))

  invisible(list(author = author, email = email, org_abbr = org_abbr))
}

#' View the current rcore configuration
#'
#' Returns the author and org abbreviation stored by \code{\link{rcore_setup}}.
#' Returns \code{NULL} silently if no configuration has been set yet.
#'
#' @return A named list with elements \code{author} and \code{org_abbr}, or
#'   \code{NULL}.
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

# Internal: stored author name, or the original HBC credit as fallback
.rcore_author <- function() {
  cfg <- rcore_get_config()
  if (is.null(cfg)) return("Harvard Chan Bioinformatics Core")
  cfg[["author"]]
}

# Internal: replace hardcoded HBC author in all Rmd files under `path`
.replace_author_in_templates <- function(path, author) {
  if (identical(author, "Harvard Chan Bioinformatics Core")) return(invisible(NULL))

  rmd_files <- tryCatch(
    c(fs::dir_ls(path, recurse = TRUE, regexp = "\\.[Rr]md$|\\.[Qq]md$")),
    error = function(e) character(0)
  )

  for (f in rmd_files) {
    txt <- readLines(f, warn = FALSE)
    updated <- gsub(
      'author: "Harvard Chan Bioinformatics Core"',
      sprintf('author: "%s"', author),
      txt, fixed = TRUE
    )
    if (!identical(txt, updated)) writeLines(updated, f)
  }
  invisible(NULL)
}
