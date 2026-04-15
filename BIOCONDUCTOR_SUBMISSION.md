# Bioconductor Submission Checklist for `rcore`

This file tracks the steps to submit `rcore` to Bioconductor.
Follow the steps **in order** — each section must be complete before moving on.

---

## Step 1 — Local checks (run on your machine)

Open R in the `r_core` project root and run these in order.

### 1a. Regenerate documentation
```r
devtools::document()
# Check: all man/ pages exist for exported functions
```

### 1b. Run R CMD check (must pass with 0 errors, 0 warnings)
```r
devtools::check()
# If any ERRORs or WARNINGs appear, fix them before proceeding.
# NOTEs are acceptable but minimise where possible.
```

### 1c. Run BiocCheck (Bioconductor-specific rules)
```r
install.packages("BiocManager")
BiocManager::install("BiocCheck")
BiocCheck::BiocCheck(".")
# Fix all ERRORs and WARNINGs. Review NOTEs.
```

### 1d. Check version
```r
# Must be 0.99.x for a new submission
packageVersion("rcore")   # should show 0.99.0
```

### 1e. Confirm the vignette builds
```r
devtools::build_vignettes()
# Inspect the HTML output in doc/
```

### 1f. Run tests
```r
devtools::test()
# All tests must pass
```

---

## Step 2 — Common BiocCheck issues to pre-fix

| Issue | Fix |
|---|---|
| Function has no `@return` tag | Add `@return` to every exported function's roxygen block |
| Function has no runnable `@examples` | Add a small example or wrap in `\dontrun{}` |
| `T` / `F` used instead of `TRUE` / `FALSE` | Search with `grep -rn "\bT\b\|\bF\b" R/` |
| `1:n` loop instead of `seq_len(n)` | Replace `1:length(x)` with `seq_along(x)` |
| `cat()` for user messages | Replace with `message()` (can be suppressed) |
| `sapply()` without type guarantee | Replace with `vapply()` |
| Package-level man page missing | Create `R/rcore-package.R` with `#' @keywords internal` and `"_PACKAGE"` |
| Vignette does not use BiocStyle | Set `output: BiocStyle::html_document` ✓ (done) |

---

## Step 3 — GitHub repository requirements

Bioconductor requires a **public GitHub repository** with these branches:

| Branch | Purpose |
|---|---|
| `main` / `master` | Your source code |
| `devel` | Must exist (can mirror main) |

```bash
# Create the devel branch if it doesn't exist
cd ~/Documents/r_core
git checkout -b devel
git push origin devel
git checkout main
```

Bioconductor will also add its own remote tracking branches after acceptance.

---

## Step 4 — Open a submission issue on Bioconductor

1. Go to: **https://github.com/Bioconductor/Contributions/issues/new**
2. Use the issue template provided on that page.
3. In the body, include:
   - **GitHub URL**: `https://github.com/upendrabhattarai/r_core`
   - **One-sentence description**: Provides R Markdown templates, colorblind-friendly palettes, and utility functions for downstream analysis of nf-core pipeline outputs.
   - Confirm `R CMD check` and `BiocCheck` pass with no errors/warnings.

Example title: `Package: rcore`

---

## Step 5 — What happens after submission

1. **Automated checks** (within minutes): Bioconductor runs `R CMD check` + `BiocCheck` on your commit. A bot posts results to your issue.
2. **Human review** (1–3 weeks): A Bioconductor reviewer reads the code, vignette, and documentation. They will post review comments.
3. **Revisions**: Address all reviewer comments and push fixes. The bot re-checks automatically.
4. **Acceptance**: Once approved, the package is added to the Bioconductor `devel` branch. At the next release cycle (~6 months), it moves to `release`.

---

## Step 6 — After acceptance

Bioconductor will:
- Add a `RELEASE_X_Y` branch to your repository.
- Assign a Bioconductor-specific version bump policy (even minor = release, odd minor = devel).

You maintain the package by pushing fixes to `main` (which Bioconductor tracks as `devel`). They handle the `RELEASE_*` branches.

---

## Version numbering going forward

| Scenario | Version example |
|---|---|
| Working in devel (new features) | `0.99.1`, `0.99.2`, … |
| First Bioconductor release | `1.0.0` (Bioconductor sets this) |
| Bug fix in release branch | `1.0.1` |
| New feature in devel after release | `1.1.0` (odd minor = devel) |
| Next Bioconductor release | `1.2.0` (even minor = release) |

---

## Useful links

- Bioconductor submission guide: https://www.bioconductor.org/developers/package-submission/
- Bioconductor package guidelines: https://www.bioconductor.org/developers/package-guidelines/
- BiocCheck documentation: https://bioconductor.org/packages/BiocCheck/
- Contributions repository: https://github.com/Bioconductor/Contributions
- Support site (for questions): https://support.bioconductor.org/
