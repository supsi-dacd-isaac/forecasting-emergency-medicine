library(tidyverse)
library(hts)
library(readr)
library(furrr)
library(fabletools)
source(here::here("rscript/hts/htsplus.R"))
source(here::here("rscript/hts/glm.R"))
source(here::here("rscript/hts/tscount.R"))
source(here::here("rscript/hts/naive.R"))
source(here::here("rscript/hts/ensemble.R"))
source(here::here("rscript/hts/qcombinations.R"))
source(here::here("rscript/hts/accuracy.R"))
source(here::here("rscript/hts/Comparing_results.R"))

storage_folder <- "/home/bombolo/R/forecasting-emergency-medicine/run_one/"
rand_seed = 123

# Parallelization
plan(multisession, workers = 30)

# Read hierarchical/grouped time series
# incident_gts <- read_rds(paste0(storage_folder, "incidents_test_gts.rds"))
data_folder <- "/home/bombolo/R/forecasting-emergency-medicine/temp_results/"
incident_gts <- read_rds(paste0(data_folder, "incidents_gts.rds"))
holidays <- read_rds(paste0(data_folder, "holidays_ts.rds"))


# Test sets of size 84,
# origins <- 42 * seq(10) + 42
origins <- 42 * seq(10) + 42
for (i in seq(origins)) {
  # Set up training set
  train <- incident_gts
  train$bts <- subset(train$bts, end = nrow(incident_gts$bts) - origins[i])
  # Create reconciled sample paths for different models
  reconcile_sample_paths(train, model_function = "ets", SEED=rand_seed)
  reconcile_sample_paths(train, model_function = "tscount", SEED=rand_seed)
  reconcile_sample_paths(train, model_function = "iglm", SEED=rand_seed)
  reconcile_sample_paths(train, model_function = "naiveecdf", SEED=rand_seed)
}

#create_ensembles() # Include naive
#create_ensembles(models_to_use = c("ets", "iglm", "tscount")) # Don't include naive
#create_qcomb() # Include naive
#create_qcomb(models_to_use = c("ets", "iglm", "tscount")) # Don't include naive

# Accuracy

#mse <- compute_accuracy(incident_gts, "mse")
mase <- compute_accuracy(incident_gts, "mase")
msse <- compute_accuracy(incident_gts, "msse")
crps <- compute_accuracy(incident_gts, "crps")

# mse |>
#   group_by(method, model, series) |>
#   summarise(mse = mean(mse)) |>
#   arrange(mse) |>
#   print(n = 200)
# 
# mase |>
#   group_by(method, model, series) |>
#   summarise(mase = mean(mase)) |>
#   arrange(series, mase) |>
#   print(n = 200)
# 
# msse |>
#   group_by(method, model, series) |>
#   summarise(msse = mean(msse^2)) |>
#   arrange(series, msse) |>
#   print(n = 200)

# crps |>
#   group_by(method, model, series) |>
#   summarise(crps = mean(crps)) |>
#   arrange(series, crps) |>
#   print(n = 200)

compare_res(storage_folder)




# SECOND RUN WITH DIFFERENT SEED - OPTIONAL, JUST TO CHECK VARIABILITY
storage_folder <- "/home/bombolo/R/forecasting-emergency-medicine/run_two/"
rand_seed = 456

# Parallelization
plan(multisession, workers = 30)

# Read hierarchical/grouped time series
# incident_gts <- read_rds(paste0(storage_folder, "incidents_test_gts.rds"))
data_folder <- "/home/bombolo/R/forecasting-emergency-medicine/temp_results/"
incident_gts <- read_rds(paste0(data_folder, "incidents_gts.rds"))
holidays <- read_rds(paste0(data_folder, "holidays_ts.rds"))


# Test sets of size 84,
# origins <- 42 * seq(10) + 42
origins <- 42 * seq(2) + 42
for (i in seq(origins)) {
  # Set up training set
  train <- incident_gts
  train$bts <- subset(train$bts, end = nrow(incident_gts$bts) - origins[i])
  # Create reconciled sample paths for different models
  reconcile_sample_paths(train, model_function = "ets", SEED=rand_seed)
  reconcile_sample_paths(train, model_function = "tscount", SEED=rand_seed)
  reconcile_sample_paths(train, model_function = "iglm", SEED=rand_seed)
  reconcile_sample_paths(train, model_function = "naiveecdf", SEED=rand_seed)
}


mase <- compute_accuracy(incident_gts, "mase")
msse <- compute_accuracy(incident_gts, "msse")
crps <- compute_accuracy(incident_gts, "crps")

compare_res(storage_folder)