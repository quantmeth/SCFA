# ng, Gr, Cpaires, Ppaires, R
asSaturations <- function(AS){
  ng <- AS$ng
  AS$Var <- matrix(0, ng, 1)
  AS$GrDe <- matrix(0, AS$nv, 1)
  for(gr in 1:ng){
    var1 <- sort(AS$Gr[[gr]])
    AS$Gr[[gr]] <- var1
    n <- length(var1)
    satur <- matrix(0, n-1, n)
    rg <- matrix(0, n, 1)
    for(j in 1:(n-1)){
      for(k in (j+1):n){
        if((var1[j] < 0) || (var1[k] < 0)) break
        sat <- asSatPaire(AS, v = var1[c(j, k)])
        if(all(sat == 0)){
          # À valider ####
        } else {
          if((satur[1,j] != 0) &&  sign(sat[1]) != sign(satur[1,j])) sat <-  - sat
          rg[c(j, k)] <- rg[c(j, k)] + 1
          satur[rg[j], j] <- sat[1]
          satur[rg[k], k] <- sat[2]
        }
      }
    }
    # if(any(v<0)) AS$pertinentes[AS$pertinentes == 0]) # What ??
    AS$satur[gr] <- list(satur)
    if(nrow(satur) > 1) satur <- mean(satur)
    
    if(sum(satur) < 0)  satur <- -satur
    
    AS$Fct[AS$Gr[[gr]], gr] <- satur
    f <- which(satur == max(abs(satur)))[1] # pas nécessaire pas la même que matlab
    f <- var1[f]
    AS$Var[[gr]] <- f
    AS$GrDe[f] <- gr
  }
  return(AS)
}
