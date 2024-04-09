asMultiSatur <- function(AS, np, alpha = .05){
  if(length(AS$reste)>0){
    nv <- AS$nv
    C <- t(combn(AS$Var, 2))
    nc <- nrow(C)
    Crit <- matrix(0, nc, 1)
    Corr <- matrix(0, nv, nc)
    P <- matrix(0, nc, np)
    G <- AS$GS
    prob <- matrix(0, nc, 1)
    
    for(j in 1:nc){
      melange <- c(C[j, ], AS$reste[1])
      cible <- AS$pertinentes[!(AS$pertinentes %in% melange)]
      AS <- asTuples(AS, melange)
      Crit[j] <- AS$tmp$Crit
      P[j,] <- AS$tmp$Poids
      Corr[,j] <- AS$tmp$Corr
      prob[j] <- pchisq(Crit[j]*(AS$N-1), length(cible) , lower.tail = FALSE)
    }
    
    Crit <- Crit * (AS$N-1)
    z2 <- Corr^2 * (AS$N-1)
    f <- which(prob == max(prob))[1]
    if((length(f) == 0) || (prob[f] < .05) || (max(z2[,f]) > qchisq(1-alpha,1))){
      
      AS$reste[1] <- -AS$reste[1]
      
    } else {
      
      gd <- AS$GrDe[C[f,]]
      
      if(all(gd > 0)){
        # Belle simplification! ####
        crois <- expand.grid(AS$Gr[gd][length(gd):1])[length(gd):1]
        #crois <- expand.grid(AS$Gr[length(AS$Gr):1])[length(AS$Gr):1]
        
        nt <- nrow(crois)
        CritTuple <- matrix(0, nt, 1)
        saturTuple <- matrix(0, nt, np)
        # ICI  ####
        for(f in 1:nt){
          melange <- unlist(c(crois[f,], AS$reste[[1]]))
          cible <- AS$pertinentes[!(AS$pertinentes %in% melange)]
          AS <- asTuples(AS, melange)
          CritTuple[f] <- AS$tmp$Crit
          Po <- AS$tmp$Poids
          Co <- AS$tmp$Corr
          #if(all(abs(log10(Po))>10)) break
          if(all(log10(abs(Po))>10)) break
          CritTuple[f] <- Co %*% t(Co) * (AS$N - 1)
          saturTuple[f,] <- Po * rowSums(AS$Fct[melange[1:np],])
        }
        po <- t(CritTuple ^ (-2))
        po <- po/sum(po)
        AS$Fct[AS$reste[1], gd] <- po %*% saturTuple
        AS$reste <- AS$reste[-1]
      } else {
        AS$reste <- c(AS$reste[-1], -AS$reste[[1]])
      }
      
    }
    
  }
  return(AS)
}
