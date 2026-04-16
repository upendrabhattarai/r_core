#' Download test data for the ChIP-seq QC report
#'
#' Downloads narrowPeak files from the rcore test-data repository:
#' [upendrabhattarai/rcore-test-data](https://github.com/upendrabhattarai/rcore-test-data/tree/main/chipseq)
#'
#' Specifically downloads the `bowtie2/mergedLibrary/macs2/narrowPeak` output
#' into the current working directory.
#'
#' @return Invisibly returns the path to the downloaded files directory.
#'
#' @examples
#' \donttest{
#'   # Downloads narrowPeak files into the current working directory
#'   rcore_qc_chipseq_testdata()
#' }
#'
#' @export
rcore_qc_chipseq_testdata <- function() {
  if (!requireNamespace("httr",     quietly = TRUE)) stop("Package 'httr' is required. Install with: install.packages('httr')")
  if (!requireNamespace("jsonlite", quietly = TRUE)) stop("Package 'jsonlite' is required. Install with: install.packages('jsonlite')")
  if (!requireNamespace("dplyr",    quietly = TRUE)) stop("Package 'dplyr' is required. Install with: install.packages('dplyr')")
  api_url <- paste0(
    "https://api.github.com/repos/upendrabhattarai/rcore-test-data",
    "/contents/chipseq/bowtie2/mergedLibrary/macs2/narrowPeak"
  )

  response <- tryCatch(
    httr::GET(api_url),
    error = function(e) {
      stop("Could not reach GitHub API: ", conditionMessage(e))
    }
  )

  if (httr::status_code(response) != 200L) {
    stop(
      "GitHub API returned status ", httr::status_code(response),
      ". Check your internet connection or the repository URL."
    )
  }

  raw_text  <- httr::content(response, as = "text", encoding = "UTF-8")
  files_info <- jsonlite::fromJSON(raw_text)
  files_info <- dplyr::filter(files_info, name != "consensus")

  raw_base <- "https://raw.githubusercontent.com/upendrabhattarai/rcore-test-data/main/"
  raw_urls <- paste0(raw_base, files_info$path)

  for (url in raw_urls) {
    dest <- basename(url)
    status <- tryCatch(
      download.file(url, destfile = dest, mode = "wb", quiet = TRUE),
      error = function(e) {
        warning("Failed to download ", basename(url), ": ", conditionMessage(e))
        return(1L)
      }
    )
    if (status == 0L)
      message("Downloaded: ", dest)
  }

  invisible(".")
}
