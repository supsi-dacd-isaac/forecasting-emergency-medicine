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


base_path <-getwd()


# compare inputs for the computation of CRPS, for naiveecdf
for(method_name in c("base", "wls", "mint", "bu") ){
  for(history_number in c("1274", "1316") ){
    result_2 <- readRDS(paste0(base_path, "Run_two/naiveecdf_", history_number,"_sim_", method_name, ".rds"))
    result_3 <- readRDS(paste0(base_path, "Run_three/naiveecdf_", history_number,"_sim_", method_name, ".rds"))
    res <- sum(abs(result_2 - result_3))
    print(paste0('method ', method_name, ' history_number ', history_number, ': ', res))
  }
}

# recompute CRPS results from the simulation files, we want to see the same diff
# beware, use of global parameter in compute accuracy. This is VERY BAD. 
# !! MAKE SURE THAT THE crps.rds is not present in the storage_folder !!
results_subfolder<-'run_one/'
storage_folder <-paste0(getwd(), '/', results_subfolder)
incident_gts <- read_rds(paste0(storage_folder, "incidents_gts.rds"))
crps_2 <- compute_accuracy(incident_gts, "crps")

results_subfolder<-'run_two/'
storage_folder <-paste0(getwd(), '/', results_subfolder)
crps_3 <- compute_accuracy(incident_gts, "crps")

diff = sum(abs(crps_2$crps-crps_3$crps))
print(paste0('sum of abs diff in crps: ', diff))
