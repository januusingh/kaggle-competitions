# Script to pre-process Kaggle Dataset

## clear everything in R 
rm(list=ls())

# get all paths in 'MJFF-binary-files' folder
mypath="~/Dropbox"
paths = list.dirs(mypath)

# initialize corresponding dataframe
gps = list()
audio = list()
accel = list()
prox = list()
light = list()
batt = list()
cmpss = list()

for (path in paths) {
#   path = paths[i]
  if(which(path==paths) %% 10 == 0 ) print (sprintf('%d/%d',which(path==paths), length(paths)))
  # print (sprintf('%d/%d',which(path==paths), length(paths)))
  f = list.files(path)
  f.info = file.info(file.path(path, f))
  # get some useful info via name
  f.info$type = gsub('hdl_([a-z]+)_[[:print:]]+.csv','\\1',f)
  # set whether this person has parkinson's or not
  f.info$person = gsub('[[:print:]]+_([A-Z]+)_[[:print:]]+.csv','\\1',f)
  
  if (identical(f,character(0))) {next}
  
  for (i in 1:nrow(f.info)){
    if (f.info$person[i] %in% c("VIOLET", "DAISY", "CHERRY",
                                "CROCUS", "ORCHID", "PEONY", "IRIS", "FLOX", "MAPLE")){ f.info$PK[i] = 1
    } else{f.info$PK[i] =0} 
  }
  
  f.info$start.time = gsub('[[:print:]]+_([0-9]{8}_[0-9]{6}).csv','\\1',f)
  f.info$start.time = strptime(f.info$start.time, format='%Y%m%d_%H%M%S')
  ndx = which(!is.na(f.info$start.time))
  f.info=f.info[ndx,]
  f = f[ndx]
  if(length(ndx)==0) next
  
  for (i in 1:nrow(f.info)){
  	if(f.info$type[i]=='gps'){
  	  s = data.frame(read.csv(paste0(path,'/',f[i])))
      Name = rep(f.info$person[i], nrow(s))
  	  PK=rep(f.info$PK[i],nrow(s))
  	  gps = rbind(gps,cbind(s, PK, Name))
  	} else if(f.info$type[i]=='audio'){
  	  s = data.frame(read.csv(paste0(path,'/',f[i]))) 
  	  PK =rep(f.info$PK[i],nrow(s))
      Name = rep(f.info$person[i], nrow(s))
  	  audio = rbind(audio,cbind(s, PK, Name))
  	} else if(f.info$type[i]=='accel'){
  	  s = data.frame(read.csv(paste0(path,'/',f[i]))) 
      Name = rep(f.info$person[i], nrow(s))
  	  PK=rep(f.info$PK[i],nrow(s))
  	  accel = rbind(accel,cbind(s, PK, Name))
  	} else if(f.info$type[i]=='prox'){
  	 
  	  s = data.frame(read.csv(paste0(path,'/',f[i]))) 
  	  PK=rep(f.info$PK[i],nrow(s))
      Name = rep(f.info$person[i], nrow(s))
  	  prox = rbind(prox,cbind(s, PK, Name))
  	  
  	} else if(f.info$type[i]=='light'){
      s = data.frame(read.csv(paste0(path,'/',f[i]))) 
  	  PK=rep(f.info$PK[i],nrow(s))
      Name = rep(f.info$person[i], nrow(s))
  	  light = rbind(light,cbind(s, PK, Name))
  		
  	} else if(f.info$type[i]=='batt'){
      s = data.frame(read.csv(paste0(path,'/',f[i]))) 
      Name = rep(f.info$person[i], nrow(s))
  	  PK=rep(f.info$PK[i],nrow(s))
  	  batt = rbind(batt,cbind(s, PK, Name))
  	} else if(f.info$type[i]=='cmpss'){
  	  s = data.frame(read.csv(paste0(path,'/',f[i])))
      Name = rep(f.info$person[i], nrow(s))
  	  PK=rep(f.info$PK[i],nrow(s))
  	  cmpss = rbind(cmpss,cbind(s, PK, Name))
  	}
  }
  write.csv(accel, paste(mypath, "mjff_accel.csv"))
  write.csv(cmpss, paste(mypath, "mjff_cmpss.csv"))
  write.csv(batt, paste(mypath, "mjff_batt.csv"))
  write.csv(gps, paste(mypath, "mjff_gps.csv"))
    write.csv(audio, paste(mypath, "mjff_audio.csv"))
    write.csv(batt, paste(mypath, "mjff_light.csv"))
    write.csv(gps, paste(mypath, "mjff_prox.csv"))
#   save(gps, audio, accel, prox, light, batt, cmpss,file=paste(mypath,"mjff_2
#                                                               000.Rdata",sep=""))
}




