asCoplanaire <- function(AS){
  AS$coplan <- numeric()
  AS$GrCoplan <- numeric()
  ng <- length(AS$Gr)
  if(ng >= 3){
    trios <- t(combn(1:ng, 3))
    cible <- 1:length(AS$pertinentes)
    for(t in 1:nrow(trios)){
      tri <- trios[t,]
      nt <- 0
      pire <- 0
      
    }
    
  }
 return(AS) 
}
