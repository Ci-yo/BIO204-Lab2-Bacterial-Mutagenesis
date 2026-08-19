#!/usr/bin/env Rscript

root <- normalizePath(getwd(), mustWork = TRUE)
required <- c(
  "README.md",
  "data/plate_counts.csv",
  "results/mutation_frequencies.csv",
  "results/cell_density_estimate.csv",
  "figures/plate-07-mms-1pct.jpg",
  "figures/plate-08-mms-2pct.jpg",
  "figures/plate-09-water-control.jpg",
  "figures/plate-11-uv-20s.jpg",
  "figures/plate-12-uv-40s.jpg"
)
stopifnot(all(file.exists(file.path(root, required))))

plates <- read.csv(file.path(root, "data", "plate_counts.csv"))
stopifnot(nrow(plates) == 12, plates$colony_count[plates$plate_id == 11] == 911)

results <- read.csv(file.path(root, "results", "mutation_frequencies.csv"))
uv20 <- results$frequency[results$comparison == "UV_20_seconds"]
stopifnot(abs(uv20 - 3.25e-6) < 0.01e-6)

scope <- list.files(".", recursive = TRUE, all.files = TRUE)
scope <- scope[!grepl("^\\.git/", scope)]
forbidden <- grep("2255737|Xiyao Chen|\\.(docx|xlsx|pdf|pptx)$", scope, ignore.case = TRUE, value = TRUE)
if (length(forbidden) > 0) stop("Private or submission files found: ", paste(forbidden, collapse = ", "))

message("Repository checks passed: plate data, frequencies, figures and privacy guard are valid.")
