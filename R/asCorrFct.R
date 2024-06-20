# Gr, GS, N, ng
asCorrFct <- function(AS, alpha = .05){
  if(length(AS$Gr) > 1){
  AS$CorEstim <- list()
  corr <- coBr <- matrix(0, AS$ng, AS$ng)
  for(j in 1:(AS$ng-1)){
    varJ <- AS$Gr[[j]]
    nj <- length(varJ)
    for(k in (j+1):AS$ng){
      varK <- AS$Gr[[k]]
      nk <- length(varK)
      corrBrut <- corrCorrige <- matrix(0, nj * nk, 1)
      rg <- 0
      for(j1 in 1:nj){
        for(k1 in 1:nk){
          rg <- rg + 1
          corrBrut[rg] <- t(AS$GS[,varJ[j1]]) %*% AS$GS[,varK[k1]]
          corrCorrige[rg] <- corrBrut[rg] / ( AS$Fct[varJ[j1],j] *  AS$Fct[varK[k1],k])
        }
      }
      corr[j, k] <- mean(corrCorrige)
      coBr[j, k] <- mean(corrBrut)
      AS$CorEstim[[length(AS$CorEstim)+1]] <- c(corrCorrige)
    }
  }
  limCorr <- qnorm(1-alpha/2)/sqrt(AS$N-1)
  f <- abs(coBr) < limCorr
  corr[f] <- 0
  corr <- corr + t(corr) + diag(1, ncol = AS$ng, nrow = AS$ng)
  AS$CorFct <- corr
  } else {
    AS$CorFct <- 1
  }
  return(AS)
}
