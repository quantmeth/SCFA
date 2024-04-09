asTuples <- function(AS, k){
  
  if(any(names(AS) %in% "pertinentes")){
    cible <- AS$pertinentes
  } else {
    cible <- 1:AS$nv
  }
  
  if(length(k) == 1){
    melange <- AS$Cpaires[k, ]
  } else {
    melange <- k
  }
  
  crit <- 9e9
  
  # ADDED (0) ?#### 
  mul <- c(1, .5, 2, 0)
  
  for(e in 1:length(mul)){
    
    P <- sign(t(AS$GS[, melange[-length(melange)]]) %*% AS$GS[, melange[length(melange)]])
    # ADDED if P == 0 ####
    # if(any(P == 0) && (length(P) == 1)) P <- 1
    # P <- ifelse(P == 0, 1, P)
    
    if(length(P) == 1){
      if(P == 0) {P <- 1}
      P <- mul[e] * P / sqrt(length(P))
      fopt <- optim(P, fn = asCrit, method = "L-BFGS-B",
                    lower = -10, upper = 10,
                    G = AS$GS,
                    combine = melange,
                    cible = cible,
                    control = list(maxit = 1e9,
                                   factr = 1e-6,
                                   pgtol = 1e-6))
    } else {
      P <- mul[e] * P / sqrt(length(P))
      fopt <- optim(P, fn = asCrit, G = AS$GS, method = "Nelder-Mead",
                    combine = melange,
                    cible = cible,
                    control = list(maxit = 1e9,
                                   factr = 1e-6,
                                   pgtol = 1e-6))
    }
    
    # fopt <- optim(P, fn = asCrit, G = AS$GS, method = "BFGS",
    #               combine = melange,
    #               cible = cible,
    #               control = list(maxit = 1e9,
    #                              factr = 1e-6,
    #                              pgtol = 1e-6))
    # 
    # 
    # fopt <- optim(P, fn = asCrit, G = AS$GS, method = "L-BFGS-B",
    #               lower = -10, upper = 10,
    #               combine = melange,
    #               cible = cible,
    #               control = list(maxit = 1e9,
    #                              factr = 1e-6,
    #                              pgtol = 1e-6))
    # 
    # fopt <- optim(P, fn = asCrit, G = AS$GS, method = "BFGS",
    #       #lower = -1000, upper = 1000,
    #       combine = melange,
    #       cible = cible,
    #       control = list(maxit = 1e9,
    #                      abstol = 1e-9,
    #                      reltol = 1e-9))
    
    corr <- asCrit(fopt$par, 
                   to.opt = FALSE,
                   G = AS$GS,
                   combine =melange,
                   cible = cible)$corr
    
    cc <- sort(abs(corr))
    
    if(fopt$value < crit){
      crit <- fopt$value
      if(length(k) == 1){
        AS$Crit[k] <- corr %*% t(corr)# crit
        AS$Corr[,k] <- corr
        AS$Ppaires[k,] <- fopt$par
      } else {
        # ICI ####
        AS$tmp <- list(Crit = crit,
                       Corr = corr,
                       Poids = t(fopt$par))
      }
    }
    if((cc[length(cc)] - cc[length(cc)-1]) < .0001) break
  }
  stopifnot("L'optimisation n'a pas trouve un vrai creux"=((cc[length(cc)] - cc[length(cc)-1]) <= .0001))
  return(AS)
}
