
# library(reticulate)
# np <- import("numpy")

# conda_create("r-reticulate")
# 
# # install numpy
# conda_install("r-reticulate", "numpy")
# 
# # import numpy (it will be automatically discovered in "r-reticulate")
# usecondaenv("r-reticulate")



# Sys.setenv(PATH = paste0("/usr/bin/python3.9", Sys.getenv()["PATH"]), sep=':')
# Sys.setenv(PATH = paste0('/usr/lib/python3/dist-packages', Sys.getenv()["PATH"]), sep=':')
# Sys.setenv(RETICULATE_PYTHON = "/usr/bin/python3.9")
library(reticulate)
library(stringr)

results_subfolder<-'run_one/'
storage_folder <-paste0(getwd(), '/', results_subfolder)
# incident_gts <- readRDS(paste0(storage_folder, "incidents_gts.rds"))
# py_save_object(incident_gts, "incident_gts.pkl", pickle = "pickle")
scores <- c("crps","mase","msse","rmsse","q_loss")

rds_2_pkl <- function(path = rds_file, saving_folder = saving_folder, storage_folder=storage_folder){
  x <- readRDS(path)
  name <- str_remove(str_remove(path, storage_folder),".rds")
  print(name)
  py_save_object(x, paste0(saving_folder, name,".pkl"), pickle = "pickle")
}

all_files <- fs::dir_ls(storage_folder, glob = paste0("*.rds"))
skip_these <- all_files[str_detect(all_files, "_\\d{3,4}\\.rds$")]

files_2_pkl<-setdiff(all_files,skip_these)

saving_folder <-"/ssd1/forecasting-emergency-medicine/"
for(i in seq(length(files_2_pkl))){
  rds_2_pkl(files_2_pkl[i],saving_folder, storage_folder)
}

