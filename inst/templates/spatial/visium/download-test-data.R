# Set working directory to this folder directory
setwd("visium")

library(curl)
# Optional: increase timeout (default is 60 sec, here set to 300 sec = 5 min)
handle <- new_handle(timeout = 300)

url <- "https://zenodo.org/records/15784846/files/allen_ref_subset.qs?download=1"
destfile <- "allen_ref_subset.qs"
curl_download(url, destfile, handle = handle)

url <- "https://zenodo.org/records/15784846/files/visium.qs?download=1"
destfile <- "visium.qs"
curl_download(url, destfile, handle = handle)
