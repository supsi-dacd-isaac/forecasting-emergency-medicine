
#Creating a tibble object for comparing results of the original paper

#metric
mase <- readRDS(paste0(storage_folder,"mase.rds"))
msse <- readRDS(paste0(storage_folder,"msse.rds"))
crps <- readRDS(paste0(storage_folder,"crps.rds"))

tabulate_comparison <- function(metric, key){
  
  method_key <- eval(parse(text=paste0(key,'$','method')))
  model_key <- eval(parse(text=paste0(key,'$','model')))
  metric_key <- eval(parse(text=paste0(key)))
  amb <- array(0,c(5,length(unique((model_key))),length(unique((method_key)))))
  for(i in seq(5)){
    for(j in seq(length(unique((model_key))))){
      for(k in seq(length(unique((method_key))))){
        m = metric_key[((method_key)==unique((method_key))[k]) & ((model_key)==unique((model_key))[j]),]
        m_new <- eval(parse(text=paste0("m", "$", key)))
        amb[i,j,k] = mean(m_new[seq(from = (0*5+i), to = (83*5+i), by = 5)]) 
      }
    }
  }
  
  rnames <- unique((model_key))
  cnames <- unique((method_key))
  
  df = list()
  for(i in 1:5){
    df[[i]] <- data.frame(amb[i,,],row.names = rnames)
    colnames(df[[i]]) <- cnames
  }
  
  ## For the results in the paper only base and minT are avilable (not in the overall direction)  
  ## So we will consider only those for our comparison with the results in the paper
  ## To compare the results between any other generated method, a separate code will be given
  
  df_comp <- list()
  for(i in 1:4){
    df_comp[[i]] = (df[[(i+1)]])[,c(1,3)]
  }
  
  
  
  df_original <- list()
  
  mase_or <- matrix(0,4,8)
  mase_or[1,] <- c(0.979,0.785,0.813,0.720,1.169,1.168,0.822,0.722)
  mase_or[2,] <- c(0.875,0.852,0.897,0.827,1.056,1.057,0.901,0.833)
  mase_or[3,] <- c(0.816,0.845,0.875,0.837,1.062,1.062,0.875,0.839)
  mase_or[4,] <- c(0.975,0.994,1.009,1.803,1.031,2.095,1.050,1.851)
  
  msse_or <- matrix(0,4,8)
  msse_or[1,] <- c(0.963,0.877,0.910,0.848,1.139,1.138,0.911,0.852)
  msse_or[2,] <- c(0.930,0.916,0.940,0.901,1.059,1.059,0.939,0.903)
  msse_or[3,] <- c(0.899,0.915,0.923,0.902,1.047,1.047,0.924,0.903)
  msse_or[4,] <- c(1.038,1.239,1.002,2.493,1.019,2.651,1.005,2.513)
  
  crps_or <- matrix(0,4,8)
  crps_or[1,] <- c(14.309,13.515,15.396,13.839,30.387,30.368,15.316,14)
  crps_or[2,] <- c(6.074,5.967,6.253,5.917,10.882,10.902,6.227,5.947)
  crps_or[3,] <- c(3.476,3.547,3.576,3.453,5.5,5.498,3.575,3.455)
  crps_or[4,] <- c(0.244,0.243,0.244,0.246,0.302,0.313,0.245,0.248)
  
  if(key == 'mase'){
    R = mase_or
  }else if(key == 'msse'){
    R = msse_or
  }else if(key == 'crps'){
    R = crps_or
  }
  
  
  
  
  for(i in 1:4){
    df_original[[i]] = data.frame(matrix(R[i,],nrow=4,byrow=TRUE))
    rownames(df_original[[i]]) <- rnames
    colnames(df_original[[i]]) <- cnames[c(1,3)]
  }
  
  disp <- array(0,c(4,4,2))
  
  Level_h <- c("Total", "Control_Area", "Health_Board", "Bottom")
  df_new <- list()
  for(i in 1:4){
    for(j in 1:4){
      for(k in 1:2){
        disp[i,j,k] = 100 * ((((df_original[[i]])[j,k]-(df_comp[[i]])[j,k])) / 
                               (df_original[[i]])[j,k])
        
      }
    }
    df_new[[i]] <- data.frame(disp[i,,])
    rownames(df_new[[i]]) <- rnames
    colnames(df_new[[i]]) <- cnames[c(1,3)]
    write.csv(df_new[[i]],paste0(storage_folder,"Percentage difference_",Level_h[i],"_",key,".csv"))
  }
  
  
  
  
  
}

tabulate_comparison(mase,'mase')
tabulate_comparison(msse,'msse')
tabulate_comparison(crps,'crps')









