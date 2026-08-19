#!/usr/bin/env Rscript

root <- normalizePath(getwd(), mustWork = TRUE)
plates <- read.csv(file.path(root, "data", "plate_counts.csv"), check.names = FALSE)
results_dir <- file.path(root, "results")
dir.create(results_dir, showWarnings = FALSE, recursive = TRUE)

count <- function(plate_id) plates$colony_count[plates$plate_id == plate_id]

plated_volume_ml <- 0.1
cfu_per_ml <- count(6) / (1e-6 * plated_volume_ml)
cells_plated <- cfu_per_ml * plated_volume_ml

comparisons <- data.frame(
  comparison = c(
    "true_spontaneous_SA3",
    "apparent_spontaneous_SA2",
    "apparent_spontaneous_SA1",
    "MMS_liquid_1_percent",
    "MMS_spot_1_percent",
    "MMS_spot_2_percent",
    "UV_20_seconds",
    "UV_40_seconds"
  ),
  treated_plate = c(2, 3, 4, 10, 7, 8, 11, 12),
  background_plate = c(NA, NA, NA, 4, 3, 3, 3, 3),
  frequency = c(
    count(2) / cells_plated,
    count(3) / cells_plated,
    count(4) / cells_plated,
    (count(10) - count(4)) / cells_plated,
    (count(7) - count(3)) / cells_plated,
    (count(8) - count(3)) / cells_plated,
    (count(11) - count(3)) / cells_plated,
    (count(12) - count(3)) / cells_plated
  ),
  relation = c("estimate", "estimate", "estimate", "estimate", "estimate", "estimate", "estimate", "lower_bound")
)

write.csv(comparisons, file.path(results_dir, "mutation_frequencies.csv"), row.names = FALSE)
write.csv(
  data.frame(cfu_per_ml = cfu_per_ml, cells_plated = cells_plated, source_plate = 6),
  file.path(results_dir, "cell_density_estimate.csv"),
  row.names = FALSE
)

message(sprintf("Estimated density: %.2e CFU/mL", cfu_per_ml))
message(sprintf("UV 20 s induced frequency: %.2e", comparisons$frequency[comparisons$comparison == "UV_20_seconds"]))
