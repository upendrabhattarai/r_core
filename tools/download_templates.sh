#!/usr/bin/env bash
# Download all external bcbio template repos and bundle them into inst/templates/
# Run from the root of the r_core package: bash tools/download_templates.sh

set -euo pipefail

TEMPLATES="inst/templates"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

download_and_unpack() {
  local name=$1
  local url=$2
  local dir=$3   # e.g. "rnaseq"
  local zip_name="${name}-main"

  echo ""
  echo ">>> Downloading ${name}..."
  curl -fsSL "${url}" -o "${TMP}/${name}.zip"

  echo ">>> Unpacking into ${TEMPLATES}/${dir}/"
  mkdir -p "${TEMPLATES}/${dir}"
  unzip -q -o "${TMP}/${name}.zip" -d "${TMP}/${name}-unpacked"

  # The zip always extracts as <repo>-main/
  cp -r "${TMP}/${name}-unpacked/${zip_name}/." "${TEMPLATES}/${dir}/"
  echo "    Done — $(find "${TEMPLATES}/${dir}" -type f | wc -l | tr -d ' ') files"
}

# ---- repos ---------------------------------------------------------------
download_and_unpack \
  "rnaseq-reports" \
  "https://github.com/bcbio/rnaseq-reports/archive/refs/heads/main.zip" \
  "rnaseq"

download_and_unpack \
  "singlecell-reports" \
  "https://github.com/bcbio/singlecell-reports/archive/refs/heads/main.zip" \
  "singlecell"

download_and_unpack \
  "spatial-reports" \
  "https://github.com/bcbio/spatial-reports/archive/refs/heads/main.zip" \
  "spatial"

download_and_unpack \
  "peakseq-reports" \
  "https://github.com/bcbio/peakseq-reports/archive/refs/heads/main.zip" \
  "peakseq"

echo ""
echo "=== All templates downloaded. Summary: ==="
for d in rnaseq singlecell spatial peakseq; do
  count=$(find "${TEMPLATES}/${d}" -type f | wc -l | tr -d ' ')
  echo "  ${d}: ${count} files"
done
echo ""
echo "Now run in R:"
echo "  devtools::document()"
echo "  devtools::install()"
